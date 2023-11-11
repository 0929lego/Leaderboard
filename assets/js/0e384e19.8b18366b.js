"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[671],{3905:(e,t,r)=>{r.d(t,{Zo:()=>d,kt:()=>b});var o=r(67294);function n(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);t&&(o=o.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,o)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){n(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,o,n=function(e,t){if(null==e)return{};var r,o,n={},a=Object.keys(e);for(o=0;o<a.length;o++)r=a[o],t.indexOf(r)>=0||(n[r]=e[r]);return n}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(o=0;o<a.length;o++)r=a[o],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(n[r]=e[r])}return n}var s=o.createContext({}),u=function(e){var t=o.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},d=function(e){var t=u(e.components);return o.createElement(s.Provider,{value:t},e.children)},c="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return o.createElement(o.Fragment,{},t)}},y=o.forwardRef((function(e,t){var r=e.components,n=e.mdxType,a=e.originalType,s=e.parentName,d=l(e,["components","mdxType","originalType","parentName"]),c=u(r),y=n,b=c["".concat(s,".").concat(y)]||c[y]||p[y]||a;return r?o.createElement(b,i(i({ref:t},d),{},{components:r})):o.createElement(b,i({ref:t},d))}));function b(e,t){var r=arguments,n=t&&t.mdxType;if("string"==typeof e||n){var a=r.length,i=new Array(a);i[0]=y;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l[c]="string"==typeof e?e:n,i[1]=l;for(var u=2;u<a;u++)i[u]=r[u];return o.createElement.apply(null,i)}return o.createElement.apply(null,r)}y.displayName="MDXCreateElement"},59881:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>s,contentTitle:()=>i,default:()=>p,frontMatter:()=>a,metadata:()=>l,toc:()=>u});var o=r(87462),n=(r(67294),r(3905));const a={sidebar_position:1},i="About",l={unversionedId:"intro",id:"intro",title:"About",description:"Leaderboard is an intuitive, open-source module designed to effortlessly establish and manage robust non-persistent & persistent global leaderboards for your Roblox experiences.",source:"@site/docs/intro.md",sourceDirName:".",slug:"/intro",permalink:"/Leaderboard/docs/intro",draft:!1,editUrl:"https://github.com/arxkdev/Leaderboard/edit/main/docs/intro.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"defaultSidebar",next:{title:"Features",permalink:"/Leaderboard/docs/features"}},s={},u=[{value:"What can I do with this?",id:"what-can-i-do-with-this",level:3},{value:"Why not OrderedDataStore?",id:"why-not-ordereddatastore",level:3}],d={toc:u},c="wrapper";function p(e){let{components:t,...r}=e;return(0,n.kt)(c,(0,o.Z)({},d,r,{components:t,mdxType:"MDXLayout"}),(0,n.kt)("h1",{id:"about"},"About"),(0,n.kt)("p",null,"Leaderboard is an intuitive, open-source module designed to effortlessly establish and manage robust non-persistent & persistent global leaderboards for your Roblox experiences."),(0,n.kt)("h3",{id:"what-can-i-do-with-this"},"What can I do with this?"),(0,n.kt)("ul",null,(0,n.kt)("li",{parentName:"ul"},"Create leaderboards for your Roblox experiences"),(0,n.kt)("li",{parentName:"ul"},"Pick from a variety of leaderboard types such as ",(0,n.kt)("b",null,(0,n.kt)("i",null,"Hourly, Daily, Weekly, Monthly, All-Time and Yearly"))),(0,n.kt)("li",{parentName:"ul"},"Not have to worry about rate limits"),(0,n.kt)("li",{parentName:"ul"},"Not have to worry about messing with your PlayerData and setup a million hacky workarounds to store individual dated leaderboards"),(0,n.kt)("li",{parentName:"ul"},"Customize your leaderboard settings to your liking"),(0,n.kt)("li",{parentName:"ul"},"Use automation to automatically update your leaderboards"),(0,n.kt)("li",{parentName:"ul"},"Easily integrate into your existing codebase with the abstract API")),(0,n.kt)("h3",{id:"why-not-ordereddatastore"},"Why not OrderedDataStore?"),(0,n.kt)("p",null,"You should not be using ODS for non persistent data. It should be persistent data. For years there was a workaround to allow people to create Daily/Weekly/Monthly boards with ODS, a very hacky workaround, but now we have MemoryStoreService which is a much better solution for non persistent data."))}p.isMDXComponent=!0}}]);