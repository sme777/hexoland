var e={};
/*
 * @version    1.4.0
 * @date       2015-10-26
 * @stability  3 - Stable
 * @author     Lauri Rooden (https://github.com/litejs/natural-compare-lite)
 * @license    MIT License
 */var naturalCompare=function(e,r){var t,a,o=1,n=0,f=0,i=String.alphabet;function getCode(e,r,a){if(a){for(t=r;a=getCode(e,t),a<76&&a>65;)++t;return+e.slice(r-1,t)}a=i&&i.indexOf(e.charAt(r));return a>-1?a+76:(a=e.charCodeAt(r)||0,a<45||a>127?a:a<46?65:a<48?a-1:a<58?a+18:a<65?a-11:a<91?a+11:a<97?a-37:a<123?a+5:a-63)}if((e+="")!=(r+=""))for(;o;){a=getCode(e,n++);o=getCode(r,f++);if(a<76&&o<76&&a>66&&o>66){a=getCode(e,n,n);o=getCode(r,f,n=t);f=t}if(a!=o)return a<o?-1:1}return 0};try{e=naturalCompare}catch(e){String.naturalCompare=naturalCompare}var r=e;export default r;

