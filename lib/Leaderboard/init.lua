--[[
	Arxk was here
]]

-- DataStoreService to handle longer than 42 days (all time most likely)
local DataStoreService = game:GetService("DataStoreService");
local RunService = game:GetService("RunService");
local UserService = game:GetService("UserService");
local Players = game:GetService("Players");

-- Requirements
local Promise = require(script.Promise);
local Signal = require(script.Signal);
local Shards = require(script.Shards);
local Compression = require(script.Compression);

-- Constants
local SHARD_COUNTS = { -- Feel free to change these based on how many MAU your game does have
	["Hourly"] = 5,
	["Daily"] = 10,
	["Weekly"] = 10,
	["Monthly"] = 15,
}
local DEBUG = false;

-- We support Daily, Weekly, Monthly and AllTime currently
type Shard = Shards.Shards;
export type LeaderboardType = "Hourly" | "Daily" | "Weekly" | "Monthly" | "Yearly" | "AllTime";
export type LeaderboardArguments = {
	ServiceKey: string,
	Type: LeaderboardType,
	StoreUsing: string,
	Store: MemoryStoreSortedMap | OrderedDataStore | Shard,
	LeaderboardUpdated: Signal.Signal<{TopData}>,
}
export type TopData = {
	rank: number,
	key: number,
	value: number,
	username: string,
	displayName: string,
}

type Object = {
	__index: Object,
	UpdateInterval: number,
	TopAmount: number,
	UpsertFunction: ((Leaderboard) -> ())?,
	Start: (self: Object, topAmount: number, interval: number, func: (Leaderboard) -> ()) -> (),
	UpdateData: (self: Leaderboard, userId: number, value: number) -> (),
	GetTopData: (self: Leaderboard, amount: number) -> Promise.TypedPromise<{TopData}>,
	Destroy: (self: Leaderboard) -> (),
	new: (serviceKey: string, leaderboardType: LeaderboardType, handleUpsertAndRetrieval: boolean?) -> Leaderboard,
}

type UpsertFunctionType = (Leaderboard) -> ();
export type Leaderboard = typeof(setmetatable({} :: LeaderboardArguments, {} :: Object));

-- Start
local Leaderboards = {}; -- To handle automatic upserting and retrieval of leaderboards
local UserIdsCache = {}; -- To assign userids {username, displayName}

local Leaderboard: Object = {} :: Object;
Leaderboard.__index = Leaderboard;
Leaderboard.UpsertFunction = nil;
Leaderboard.UpdateInterval = 120; -- Default to 2 minutes
Leaderboard.TopAmount = 100; -- Default to 100

local function dPrint(...)
	if (DEBUG) then
		warn(`[Leaderboard]`, ...);
	end;
end

local function SmartAssert(condition: boolean, message: string)
	if (not condition) then
		error(message, 2);
	end;
end

function Leaderboard:Start(interval: number, topAmount: number, func: UpsertFunctionType)
	Leaderboard.UpsertFunction = func;
	Leaderboard.UpdateInterval = interval;
	Leaderboard.TopAmount = topAmount;

	task.spawn(function()
		while (true) do
			if (Leaderboard.UpsertFunction) then
				for _, v in Leaderboards do
					pcall(Leaderboard.UpsertFunction, v);
					v:GetTopData(Leaderboard.TopAmount):andThen(function(data)
						v.LeaderboardUpdated:Fire(data)
					end);
				end;
			end;
			task.wait(Leaderboard.UpdateInterval);
		end;
	end);
end

-- Helpers
local function ConstructStore(serviceKey: string, leaderboardType: LeaderboardType): (string, MemoryStoreSortedMap | OrderedDataStore | Shard)
	if (leaderboardType == "Hourly" or leaderboardType == "Daily" or leaderboardType == "Weekly" or leaderboardType == "Monthly") then
		return "MemoryStore", Shards.new(leaderboardType, serviceKey, SHARD_COUNTS[leaderboardType]);
	end;

	if (leaderboardType == "Yearly") then
		local DateTable = os.date("*t", os.time());
		local CurrentYear = DateTable.year;
		return "OrderedDataStore", DataStoreService:GetOrderedDataStore(`{CurrentYear}:{serviceKey}`);
	end;

	return "OrderedDataStore", DataStoreService:GetOrderedDataStore(serviceKey);
end

local function GetUserInfosFromId(userId: number): string
	userId = tonumber(userId);

	-- First, check if the cache contains the name
	if (UserIdsCache[userId]) then
		local Username, DisplayName = unpack(UserIdsCache[userId]);
		return Username, DisplayName;
	end;

	-- Second, check if the user is already connected to the server
	local player = Players:GetPlayerByUserId(userId);
	if (player) then
		UserIdsCache[userId] = {player.Name, player.DisplayName};
		return player.Name, player.DisplayName;
	end;

	-- If all else fails, send a request
	local Success, Result = pcall(function()
		return UserService:GetUserInfosByUserIdsAsync({userId});
	end);
	if (not Success) then
		warn(`Leaderboard had trouble getting user info: {Result}`);
		return "Unknown", "Unknown";
	end;
	local Username = Result[1] and Result[1].Username or "Unknown";
	local DisplayName = Result[1] and Result[1].DisplayName or "Unknown";
	UserIdsCache[userId] = {Username, DisplayName};
	return Username, DisplayName;
end

function Leaderboard.new(serviceKey: string, leaderboardType: LeaderboardType, handleUpsertAndRetrieval: boolean?)
	local self = setmetatable({} :: LeaderboardArguments, Leaderboard);

	self.ServiceKey = serviceKey;
	self.Type = leaderboardType;
	self.StoreType, self.Store = ConstructStore(serviceKey, leaderboardType);
	self.LeaderboardUpdated = Signal.new();

	-- If the leaderboard is yearly, we need to check if the year has changed and update the store
	if (leaderboardType == "Yearly") then
		local InitialDate = os.date("*t", os.time());
		RunService.Heartbeat:Connect(function()
			local Date = os.date("*t", os.time());
			local isNewYear = Date.year ~= InitialDate.year;
			if (isNewYear) then
				InitialDate = Date;
				self.StoreType, self.Store = ConstructStore(serviceKey, leaderboardType);
			end;
		end);
	end;

	if (handleUpsertAndRetrieval) then
		dPrint(`Leaderboard ${serviceKey} is being handled automatically.`);
		Leaderboards[serviceKey] = self;
	end;
	return self;
end

function Leaderboard:GetTopData(amount)
	SmartAssert(type(amount) == "number", "Amount must be a number");
	SmartAssert(amount <= 100, "You can only get the top 100.");

	local function PromiseRetrieveTopData()
		if (self.StoreType == "MemoryStore") then
			local data = self.Store:GetTopData(amount, Enum.SortDirection.Descending);
			for rank, v in data do
				v.rank = rank;
				v.value = Compression.Decompress(v.value);
				v.username, v.displayName = GetUserInfosFromId(v.key);
			end;
			return data;
		else
			local result = self.Store:GetSortedAsync(false, amount);
			local data = result:GetCurrentPage();
			for rank, v in data do
				v.rank = rank;
				v.value = Compression.Decompress(v.value);
				v.username, v.displayName = GetUserInfosFromId(v.key);
			end;
			return data;
		end;
	end;

	return Promise.new(function(resolve, reject)
		local success, data = pcall(PromiseRetrieveTopData);

		if (success) then
			dPrint(`Successfully retrieved top data for ${self.ServiceKey}`);
			resolve(data);
		else
			warn(success, data);
			reject(data);
		end;
	end);
end

function Leaderboard:UpdateData(userId, value) : ()
	SmartAssert(type(userId) == "number", "UserId must be a number");
	SmartAssert(type(value) == "number", "Value must be a number");
	local CompressedValue = Compression.Compress(value);

	if (self.StoreType == "MemoryStore") then
		self.Store:UpdateData(userId, value);
		dPrint(`Successfully updated data for ${userId} in ${self.ServiceKey}`);
		return;
	end;

	local Success, Error = pcall(function()
		self.Store:SetAsync(userId, CompressedValue);
	end);
	if (not Success) then
		warn(`Leaderboard had trouble saving: {Error}`);
	end;

	dPrint(`Successfully updated data for ${userId} in ${self.ServiceKey}`);
end

function Leaderboard:Destroy()
	if (Leaderboards[self.ServiceKey]) then
		Leaderboards[self.ServiceKey] = nil;
	end;
end

return Leaderboard;