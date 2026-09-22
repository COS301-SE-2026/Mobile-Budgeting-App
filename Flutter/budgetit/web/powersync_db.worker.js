(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.ES(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.u(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.w6(b)
return new s(c,this)}:function(){if(s===null)s=A.w6(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.w6(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
wf(a,b,c,d){return{i:a,p:b,e:c,x:d}},
uB(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.wd==null){A.Ep()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.b(A.vA("Return interceptor for "+A.q(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.rS
if(o==null)o=$.rS=A.uA(n)
p=q[o]}if(p!=null)return p
p=A.Ez(a)
if(p!=null)return p
if(typeof a=="function")return B.b6
s=Object.getPrototypeOf(a)
if(s==null)return B.ac
if(s===Object.prototype)return B.ac
if(typeof q=="function"){o=$.rS
if(o==null)o=$.rS=A.uA(n)
Object.defineProperty(q,o,{value:B.V,enumerable:false,writable:true,configurable:true})
return B.V}return B.V},
vj(a,b){if(a<0||a>4294967295)throw A.b(A.ab(a,0,4294967295,"length",null))
return J.AA(new Array(a),b)},
vk(a,b){if(a<0)throw A.b(A.K("Length must be a non-negative integer: "+a,null))
return A.u(new Array(a),b.h("t<0>"))},
AA(a,b){var s=A.u(a,b.h("t<0>"))
s.$flags=1
return s},
AB(a,b){return J.wq(a,b)},
dA(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.fi.prototype
return J.iA.prototype}if(typeof a=="string")return J.cl.prototype
if(a==null)return J.dR.prototype
if(typeof a=="boolean")return J.iz.prototype
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.aY.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.k)return a
return J.uB(a)},
a3(a){if(typeof a=="string")return J.cl.prototype
if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.aY.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.k)return a
return J.uB(a)},
bC(a){if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.aY.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.k)return a
return J.uB(a)},
Ej(a){if(typeof a=="number")return J.dS.prototype
if(typeof a=="string")return J.cl.prototype
if(a==null)return a
if(!(a instanceof A.k))return J.db.prototype
return a},
wb(a){if(typeof a=="string")return J.cl.prototype
if(a==null)return a
if(!(a instanceof A.k))return J.db.prototype
return a},
uz(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.aY.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.k)return a
return J.uB(a)},
z(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.dA(a).D(a,b)},
eT(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.yT(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.a3(a).i(a,b)},
l_(a,b,c){if(typeof b==="number")if((Array.isArray(a)||A.yT(a,a[v.dispatchPropertyName]))&&!(a.$flags&2)&&b>>>0===b&&b<a.length)return a[b]=c
return J.bC(a).m(a,b,c)},
l0(a,b){return J.bC(a).q(a,b)},
zJ(a,b){return J.wb(a).e1(a,b)},
zK(a){return J.uz(a).iW(a)},
cJ(a,b,c){return J.uz(a).e2(a,b,c)},
wp(a,b){return J.bC(a).d7(a,b)},
wq(a,b){return J.Ej(a).Z(a,b)},
wr(a,b){return J.a3(a).S(a,b)},
hO(a,b){return J.bC(a).T(a,b)},
zL(a){return J.uz(a).gan(a)},
y(a){return J.dA(a).gv(a)},
l1(a){return J.a3(a).gE(a)},
zM(a){return J.a3(a).gaN(a)},
T(a){return J.bC(a).gA(a)},
aE(a){return J.a3(a).gk(a)},
zN(a){return J.uz(a).gjv(a)},
ws(a){return J.dA(a).ga3(a)},
eU(a,b,c){return J.bC(a).b6(a,b,c)},
zO(a,b,c){return J.wb(a).cC(a,b,c)},
zP(a,b){return J.a3(a).sk(a,b)},
zQ(a,b,c,d,e){return J.bC(a).O(a,b,c,d,e)},
l2(a,b){return J.bC(a).aS(a,b)},
wt(a,b){return J.bC(a).cN(a,b)},
zR(a,b){return J.wb(a).dI(a,b)},
wu(a,b){return J.bC(a).bN(a,b)},
zS(a){return J.bC(a).ev(a)},
aU(a){return J.dA(a).j(a)},
iw:function iw(){},
iz:function iz(){},
dR:function dR(){},
ag:function ag(){},
cm:function cm(){},
iY:function iY(){},
db:function db(){},
aY:function aY(){},
aO:function aO(){},
dT:function dT(){},
t:function t(a){this.$ti=a},
iy:function iy(){},
nv:function nv(a){this.$ti=a},
dE:function dE(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
dS:function dS(){},
fi:function fi(){},
iA:function iA(){},
cl:function cl(){}},A={vn:function vn(){},
i4(a,b,c){if(t.O.b(a))return new A.h8(a,b.h("@<0>").H(c).h("h8<1,2>"))
return new A.cN(a,b.h("@<0>").H(c).h("cN<1,2>"))},
wW(a){return new A.cX("Field '"+a+"' has been assigned during initialization.")},
wX(a){return new A.cX("Field '"+a+"' has not been initialized.")},
AF(a){return new A.cX("Field '"+a+"' has already been initialized.")},
uE(a){var s,r=a^48
if(r<=9)return r
s=a|32
if(97<=s&&s<=102)return s-87
return-1},
E(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
c2(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
xo(a,b,c){return A.c2(A.E(A.E(c,a),b))},
ba(a,b,c){return a},
we(a){var s,r
for(s=$.dx.length,r=0;r<s;++r)if(a===$.dx[r])return!0
return!1},
bM(a,b,c,d){A.aH(b,"start")
if(c!=null){A.aH(c,"end")
if(b>c)A.v(A.ab(b,0,c,"start",null))}return new A.d8(a,b,c,d.h("d8<0>"))},
fr(a,b,c,d){if(t.O.b(a))return new A.cT(a,b,c.h("@<0>").H(d).h("cT<1,2>"))
return new A.bX(a,b,c.h("@<0>").H(d).h("bX<1,2>"))},
xp(a,b,c){var s="takeCount"
A.hR(b,s)
A.aH(b,s)
if(t.O.b(a))return new A.f8(a,b,c.h("f8<0>"))
return new A.da(a,b,c.h("da<0>"))},
xj(a,b,c){var s="count"
if(t.O.b(a)){A.hR(b,s)
A.aH(b,s)
return new A.dM(a,b,c.h("dM<0>"))}A.hR(b,s)
A.aH(b,s)
return new A.c0(a,b,c.h("c0<0>"))},
bW(){return new A.b5("No element")},
wR(){return new A.b5("Too few elements")},
j9(a,b,c,d){if(c-b<=32)A.Be(a,b,c,d)
else A.Bd(a,b,c,d)},
Be(a,b,c,d){var s,r,q,p,o
for(s=b+1,r=J.a3(a);s<=c;++s){q=r.i(a,s)
p=s
for(;;){if(!(p>b&&d.$2(r.i(a,p-1),q)>0))break
o=p-1
r.m(a,p,r.i(a,o))
p=o}r.m(a,p,q)}},
Bd(a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i=B.b.V(a5-a4+1,6),h=a4+i,g=a5-i,f=B.b.V(a4+a5,2),e=f-i,d=f+i,c=J.a3(a3),b=c.i(a3,h),a=c.i(a3,e),a0=c.i(a3,f),a1=c.i(a3,d),a2=c.i(a3,g)
if(a6.$2(b,a)>0){s=a
a=b
b=s}if(a6.$2(a1,a2)>0){s=a2
a2=a1
a1=s}if(a6.$2(b,a0)>0){s=a0
a0=b
b=s}if(a6.$2(a,a0)>0){s=a0
a0=a
a=s}if(a6.$2(b,a1)>0){s=a1
a1=b
b=s}if(a6.$2(a0,a1)>0){s=a1
a1=a0
a0=s}if(a6.$2(a,a2)>0){s=a2
a2=a
a=s}if(a6.$2(a,a0)>0){s=a0
a0=a
a=s}if(a6.$2(a1,a2)>0){s=a2
a2=a1
a1=s}c.m(a3,h,b)
c.m(a3,f,a0)
c.m(a3,g,a2)
c.m(a3,e,c.i(a3,a4))
c.m(a3,d,c.i(a3,a5))
r=a4+1
q=a5-1
p=J.z(a6.$2(a,a1),0)
if(p)for(o=r;o<=q;++o){n=c.i(a3,o)
m=a6.$2(n,a)
if(m===0)continue
if(m<0){if(o!==r){c.m(a3,o,c.i(a3,r))
c.m(a3,r,n)}++r}else for(;;){m=a6.$2(c.i(a3,q),a)
if(m>0){--q
continue}else{l=q-1
if(m<0){c.m(a3,o,c.i(a3,r))
k=r+1
c.m(a3,r,c.i(a3,q))
c.m(a3,q,n)
q=l
r=k
break}else{c.m(a3,o,c.i(a3,q))
c.m(a3,q,n)
q=l
break}}}}else for(o=r;o<=q;++o){n=c.i(a3,o)
if(a6.$2(n,a)<0){if(o!==r){c.m(a3,o,c.i(a3,r))
c.m(a3,r,n)}++r}else if(a6.$2(n,a1)>0)for(;;)if(a6.$2(c.i(a3,q),a1)>0){--q
if(q<o)break
continue}else{l=q-1
if(a6.$2(c.i(a3,q),a)<0){c.m(a3,o,c.i(a3,r))
k=r+1
c.m(a3,r,c.i(a3,q))
c.m(a3,q,n)
r=k}else{c.m(a3,o,c.i(a3,q))
c.m(a3,q,n)}q=l
break}}j=r-1
c.m(a3,a4,c.i(a3,j))
c.m(a3,j,a)
j=q+1
c.m(a3,a5,c.i(a3,j))
c.m(a3,j,a1)
A.j9(a3,a4,r-2,a6)
A.j9(a3,q+2,a5,a6)
if(p)return
if(r<h&&q>g){while(J.z(a6.$2(c.i(a3,r),a),0))++r
while(J.z(a6.$2(c.i(a3,q),a1),0))--q
for(o=r;o<=q;++o){n=c.i(a3,o)
if(a6.$2(n,a)===0){if(o!==r){c.m(a3,o,c.i(a3,r))
c.m(a3,r,n)}++r}else if(a6.$2(n,a1)===0)for(;;)if(a6.$2(c.i(a3,q),a1)===0){--q
if(q<o)break
continue}else{l=q-1
if(a6.$2(c.i(a3,q),a)<0){c.m(a3,o,c.i(a3,r))
k=r+1
c.m(a3,r,c.i(a3,q))
c.m(a3,q,n)
r=k}else{c.m(a3,o,c.i(a3,q))
c.m(a3,q,n)}q=l
break}}A.j9(a3,r,q,a6)}else A.j9(a3,r,q,a6)},
eY:function eY(a,b){this.a=a
this.$ti=b},
dG:function dG(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
cw:function cw(){},
i5:function i5(a,b){this.a=a
this.$ti=b},
cN:function cN(a,b){this.a=a
this.$ti=b},
h8:function h8(a,b){this.a=a
this.$ti=b},
h2:function h2(){},
qQ:function qQ(a,b){this.a=a
this.b=b},
al:function al(a,b){this.a=a
this.$ti=b},
cO:function cO(a,b){this.a=a
this.$ti=b},
lC:function lC(a,b){this.a=a
this.b=b},
lB:function lB(a){this.a=a},
cX:function cX(a){this.a=a},
bq:function bq(a){this.a=a},
uV:function uV(){},
ok:function ok(){},
w:function w(){},
W:function W(){},
d8:function d8(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
ar:function ar(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bX:function bX(a,b,c){this.a=a
this.b=b
this.$ti=c},
cT:function cT(a,b,c){this.a=a
this.b=b
this.$ti=c},
bE:function bE(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
aa:function aa(a,b,c){this.a=a
this.b=b
this.$ti=c},
c6:function c6(a,b,c){this.a=a
this.b=b
this.$ti=c},
eg:function eg(a,b){this.a=a
this.b=b},
fa:function fa(a,b,c){this.a=a
this.b=b
this.$ti=c},
il:function il(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
da:function da(a,b,c){this.a=a
this.b=b
this.$ti=c},
f8:function f8(a,b,c){this.a=a
this.b=b
this.$ti=c},
jp:function jp(a,b,c){this.a=a
this.b=b
this.$ti=c},
c0:function c0(a,b,c){this.a=a
this.b=b
this.$ti=c},
dM:function dM(a,b,c){this.a=a
this.b=b
this.$ti=c},
j8:function j8(a,b){this.a=a
this.b=b},
cU:function cU(a){this.$ti=a},
ig:function ig(){},
fW:function fW(a,b){this.a=a
this.$ti=b},
jC:function jC(a,b){this.a=a
this.$ti=b},
fz:function fz(a,b){this.a=a
this.$ti=b},
iS:function iS(a){this.a=a
this.b=null},
fd:function fd(){},
js:function js(){},
ec:function ec(){},
d4:function d4(a,b){this.a=a
this.$ti=b},
jn:function jn(a){this.a=a},
hF:function hF(){},
A7(){throw A.b(A.Q("Cannot modify unmodifiable Map"))},
A8(){throw A.b(A.Q("Cannot modify constant Set"))},
z8(a){var s=A.z7(a)
if(s!=null)return s
return"minified:"+a},
yT(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.dX.b(a)},
q(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.aU(a)
return s},
e1(a){var s,r=$.x5
if(r==null)r=$.x5=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
vs(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
j_(a){var s,r,q,p
if(a instanceof A.k)return A.b8(A.bn(a),null)
s=J.dA(a)
if(s===B.b5||s===B.b7||t.cx.b(a)){r=B.Z(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.b8(A.bn(a),null)},
xc(a){var s,r,q
if(a==null||typeof a=="number"||A.kO(a))return J.aU(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.cP)return a.j(0)
if(a instanceof A.hn)return a.iL(!0)
s=$.zD()
for(r=0;r<1;++r){q=s[r].oU(a)
if(q!=null)return q}return"Instance of '"+A.j_(a)+"'"},
AU(){if(!!self.location)return self.location.href
return null},
x4(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
AY(a){var s,r,q,p=A.u([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r){q=a[r]
if(!A.hG(q))throw A.b(A.dy(q))
if(q<=65535)p.push(q)
else if(q<=1114111){p.push(55296+(B.b.a1(q-65536,10)&1023))
p.push(56320+(q&1023))}else throw A.b(A.dy(q))}return A.x4(p)},
xd(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.hG(q))throw A.b(A.dy(q))
if(q<0)throw A.b(A.dy(q))
if(q>65535)return A.AY(a)}return A.x4(a)},
AZ(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
aP(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.b.a1(s,10)|55296)>>>0,s&1023|56320)}}throw A.b(A.ab(a,0,1114111,null,null))},
d1(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
xb(a){var s=A.d1(a).getFullYear()+0
return s},
x9(a){var s=A.d1(a).getMonth()+1
return s},
x6(a){var s=A.d1(a).getDate()+0
return s},
x7(a){var s=A.d1(a).getHours()+0
return s},
x8(a){var s=A.d1(a).getMinutes()+0
return s},
xa(a){var s=A.d1(a).getSeconds()+0
return s},
AW(a){var s=A.d1(a).getMilliseconds()+0
return s},
AX(a){var s=A.d1(a).getDay()+0
return B.b.aR(s+6,7)+1},
AV(a){var s=a.$thrownJsError
if(s==null)return null
return A.O(s)},
j0(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.ao(a,s)
a.$thrownJsError=s
s.stack=b.j(0)}},
kT(a,b){var s,r="index"
if(!A.hG(b))return new A.a4(!0,b,r,null)
s=J.aE(a)
if(b<0||b>=s)return A.it(b,s,a,null,r)
return A.o3(b,r)},
Ec(a,b,c){if(a<0||a>c)return A.ab(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ab(b,a,c,"end",null)
return new A.a4(!0,b,"end",null)},
dy(a){return new A.a4(!0,a,null,null)},
b(a){return A.ao(a,new Error())},
ao(a,b){var s
if(a==null)a=new A.c3()
b.dartException=a
s=A.ET
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
ET(){return J.aU(this.dartException)},
v(a,b){throw A.ao(a,b==null?new Error():b)},
C(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.v(A.CV(a,b,c),s)},
CV(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.fP("'"+s+"': Cannot "+o+" "+l+k+n)},
a6(a){throw A.b(A.ap(a))},
c4(a){var s,r,q,p,o,n
a=A.z_(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.u([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.ps(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
pt(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
xr(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
vo(a,b){var s=b==null,r=s?null:b.method
return new A.iB(a,r,s?null:b.receiver)},
H(a){if(a==null)return new A.iU(a)
if(a instanceof A.f9)return A.cH(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.cH(a,a.dartException)
return A.DK(a)},
cH(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
DK(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.b.a1(r,16)&8191)===10)switch(q){case 438:return A.cH(a,A.vo(A.q(s)+" (Error "+q+")",null))
case 445:case 5007:A.q(s)
return A.cH(a,new A.fA())}}if(a instanceof TypeError){p=$.ze()
o=$.zf()
n=$.zg()
m=$.zh()
l=$.zk()
k=$.zl()
j=$.zj()
$.zi()
i=$.zn()
h=$.zm()
g=p.b7(s)
if(g!=null)return A.cH(a,A.vo(s,g))
else{g=o.b7(s)
if(g!=null){g.method="call"
return A.cH(a,A.vo(s,g))}else if(n.b7(s)!=null||m.b7(s)!=null||l.b7(s)!=null||k.b7(s)!=null||j.b7(s)!=null||m.b7(s)!=null||i.b7(s)!=null||h.b7(s)!=null)return A.cH(a,new A.fA())}return A.cH(a,new A.jr(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.fG()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.cH(a,new A.a4(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.fG()
return a},
O(a){var s
if(a instanceof A.f9)return a.b
if(a==null)return new A.ht(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.ht(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
kU(a){if(a==null)return J.y(a)
if(typeof a=="object")return A.e1(a)
return J.y(a)},
Eh(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.m(0,a[s],a[r])}return b},
D5(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.b(A.wJ("Unsupported number of arguments for wrapped closure"))},
cG(a,b){var s
if(a==null)return null
s=a.$identity
if(!!s)return s
s=A.E6(a,b)
a.$identity=s
return s},
E6(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.D5)},
A1(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.ov().constructor.prototype):Object.create(new A.eW(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.wF(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.zY(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.wF(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
zY(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.b("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.zU)}throw A.b("Error in functionType of tearoff")},
zZ(a,b,c,d){var s=A.wC
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
wF(a,b,c,d){if(c)return A.A0(a,b,d)
return A.zZ(b.length,d,a,b)},
A_(a,b,c,d){var s=A.wC,r=A.zV
switch(b?-1:a){case 0:throw A.b(new A.j5("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
A0(a,b,c){var s,r
if($.wA==null)$.wA=A.wz("interceptor")
if($.wB==null)$.wB=A.wz("receiver")
s=b.length
r=A.A_(s,c,a,b)
return r},
w6(a){return A.A1(a)},
zU(a,b){return A.hA(v.typeUniverse,A.bn(a.a),b)},
wC(a){return a.a},
zV(a){return a.b},
wz(a){var s,r,q,p=new A.eW("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.b(A.K("Field name "+a+" not found.",null))},
uA(a){return v.getIsolateTag(a)},
EX(a,b){var s=$.m
if(s===B.e)return a
return s.fI(a,b)},
z1(){return v.G},
FX(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
Ez(a){var s,r,q,p,o,n=$.yP.$1(a),m=$.uw[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.uI[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.yI.$2(a,n)
if(q!=null){m=$.uw[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.uI[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.uN(s)
$.uw[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.uI[n]=s
return s}if(p==="-"){o=A.uN(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.yX(a,s)
if(p==="*")throw A.b(A.vA(n))
if(v.leafTags[n]===true){o=A.uN(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.yX(a,s)},
yX(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.wf(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
uN(a){return J.wf(a,!1,null,!!a.$iaZ)},
EB(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.uN(s)
else return J.wf(s,c,null,null)},
Ep(){if(!0===$.wd)return
$.wd=!0
A.Eq()},
Eq(){var s,r,q,p,o,n,m,l
$.uw=Object.create(null)
$.uI=Object.create(null)
A.Eo()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.yZ.$1(o)
if(n!=null){m=A.EB(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
Eo(){var s,r,q,p,o,n,m=B.aC()
m=A.eO(B.aD,A.eO(B.aE,A.eO(B.a_,A.eO(B.a_,A.eO(B.aF,A.eO(B.aG,A.eO(B.aH(B.Z),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.yP=new A.uF(p)
$.yI=new A.uG(o)
$.yZ=new A.uH(n)},
eO(a,b){return a(b)||b},
Cg(a,b){var s
for(s=0;s<a.length;++s)if(!J.z(a[s],b[s]))return!1
return!0},
Eb(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
vm(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=function(g,h){try{return new RegExp(g,h)}catch(n){return n}}(a,s+r+q+p+f)
if(o instanceof RegExp)return o
throw A.b(A.ak("Illegal RegExp pattern ("+String(o)+")",a,null))},
EP(a,b,c){var s
if(typeof b=="string")return a.indexOf(b,c)>=0
else if(b instanceof A.fj){s=B.a.a0(a,c)
return b.b.test(s)}else return!J.zJ(b,B.a.a0(a,c)).gE(0)},
Ee(a){if(a.indexOf("$",0)>=0)return a.replace(/\$/g,"$$$$")
return a},
z_(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
hL(a,b,c){var s=A.EQ(a,b,c)
return s},
EQ(a,b,c){var s,r,q
if(b===""){if(a==="")return c
s=a.length
for(r=c,q=0;q<s;++q)r=r+a[q]+c
return r.charCodeAt(0)==0?r:r}if(a.indexOf(b,0)<0)return a
if(a.length<500||c.indexOf("$",0)>=0)return a.split(b).join(c)
return a.replace(new RegExp(A.z_(b),"g"),A.Ee(c))},
yE(a){return a},
z2(a,b,c,d){var s,r,q,p,o,n,m
for(s=b.e1(0,a),s=new A.jH(s.a,s.b,s.c),r=t.lu,q=0,p="";s.l();){o=s.d
if(o==null)o=r.a(o)
n=o.b
m=n.index
p=p+A.q(A.yE(B.a.t(a,q,m)))+A.q(c.$1(o))
q=m+n[0].length}s=p+A.q(A.yE(B.a.a0(a,q)))
return s.charCodeAt(0)==0?s:s},
ER(a,b,c,d){var s=a.indexOf(b,d)
if(s<0)return a
return A.z3(a,s,s+b.length,c)},
z3(a,b,c,d){return a.substring(0,b)+d+a.substring(c)},
ho:function ho(a){this.a=a},
a2:function a2(a,b){this.a=a
this.b=b},
hp:function hp(a,b){this.a=a
this.b=b},
hq:function hq(a,b){this.a=a
this.b=b},
kd:function kd(a,b){this.a=a
this.b=b},
ez:function ez(a,b){this.a=a
this.b=b},
ke:function ke(a,b){this.a=a
this.b=b},
kf:function kf(a,b){this.a=a
this.b=b},
cy:function cy(a,b,c){this.a=a
this.b=b
this.c=c},
kg:function kg(a,b,c){this.a=a
this.b=b
this.c=c},
kh:function kh(a,b,c){this.a=a
this.b=b
this.c=c},
ki:function ki(a,b,c){this.a=a
this.b=b
this.c=c},
kj:function kj(a){this.a=a},
f0:function f0(){},
lX:function lX(a,b,c){this.a=a
this.b=b
this.c=c},
aW:function aW(a,b,c){this.a=a
this.b=b
this.$ti=c},
hf:function hf(a,b){this.a=a
this.$ti=b},
et:function et(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
f1:function f1(){},
f2:function f2(a,b,c){this.a=a
this.b=b
this.$ti=c},
nn:function nn(){},
fh:function fh(a,b){this.a=a
this.$ti=b},
fB:function fB(){},
ps:function ps(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
fA:function fA(){},
iB:function iB(a,b,c){this.a=a
this.b=b
this.c=c},
jr:function jr(a){this.a=a},
iU:function iU(a){this.a=a},
f9:function f9(a,b){this.a=a
this.b=b},
ht:function ht(a){this.a=a
this.b=null},
cP:function cP(){},
lI:function lI(){},
lJ:function lJ(){},
pg:function pg(){},
ov:function ov(){},
eW:function eW(a,b){this.a=a
this.b=b},
j5:function j5(a){this.a=a},
b_:function b_(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
nw:function nw(a){this.a=a},
nz:function nz(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
b0:function b0(a,b){this.a=a
this.$ti=b},
fn:function fn(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
bd:function bd(a,b){this.a=a
this.$ti=b},
bc:function bc(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
ax:function ax(a,b){this.a=a
this.$ti=b},
iI:function iI(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
fk:function fk(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
uF:function uF(a){this.a=a},
uG:function uG(a){this.a=a},
uH:function uH(a){this.a=a},
hn:function hn(){},
ka:function ka(){},
k9:function k9(){},
kb:function kb(){},
kc:function kc(){},
fj:function fj(a,b){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=null},
ex:function ex(a){this.b=a},
jG:function jG(a,b,c){this.a=a
this.b=b
this.c=c},
jH:function jH(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
fK:function fK(a,b){this.a=a
this.c=b},
ku:function ku(a,b,c){this.a=a
this.b=b
this.c=c},
tn:function tn(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
ES(a){throw A.ao(A.wW(a),new Error())},
L(){throw A.ao(A.wX(""),new Error())},
z4(){throw A.ao(A.AF(""),new Error())},
wh(){throw A.ao(A.wW(""),new Error())},
xE(){var s=new A.jQ("")
return s.b=s},
qR(a){var s=new A.jQ(a)
return s.b=s},
jQ:function jQ(a){this.a=a
this.b=null},
kM(a,b,c){},
vZ(a){var s,r,q
if(t.iy.b(a))return a
s=J.a3(a)
r=A.b1(s.gk(a),null,!1,t.z)
for(q=0;q<s.gk(a);++q)r[q]=s.i(a,q)
return r},
AN(a){return new DataView(new ArrayBuffer(a))},
AO(a,b,c){var s
A.kM(a,b,c)
s=new DataView(a,b)
return s},
bZ(a,b,c){A.kM(a,b,c)
c=B.b.V(a.byteLength-b,4)
return new Int32Array(a,b,c)},
AP(a){return new Int8Array(a)},
AQ(a,b,c){A.kM(a,b,c)
return new Uint32Array(a,b,c)},
AR(a){return new Uint8Array(a)},
b3(a,b,c){A.kM(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
cd(a,b,c){if(a>>>0!==a||a>=c)throw A.b(A.kT(b,a))},
yh(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.b(A.Ec(a,b,c))
return b},
dY:function dY(){},
bF:function bF(){},
fw:function fw(){},
kC:function kC(a){this.a=a},
fv:function fv(){},
dZ:function dZ(){},
co:function co(){},
b2:function b2(){},
iL:function iL(){},
iM:function iM(){},
iN:function iN(){},
iO:function iO(){},
iP:function iP(){},
iQ:function iQ(){},
fx:function fx(){},
fy:function fy(){},
d_:function d_(){},
hi:function hi(){},
hj:function hj(){},
hk:function hk(){},
hl:function hl(){},
vu(a,b){var s=b.c
return s==null?b.c=A.hy(a,"o",[b.x]):s},
xf(a){var s=a.w
if(s===6||s===7)return A.xf(a.x)
return s===11||s===12},
B8(a){return a.as},
ED(a,b){var s,r=b.length
for(s=0;s<r;++s)if(!a[s].b(b[s]))return!1
return!0},
ai(a){return A.tw(v.typeUniverse,a,!1)},
Es(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.cE(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
cE(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.cE(a1,s,a3,a4)
if(r===s)return a2
return A.xU(a1,r,!0)
case 7:s=a2.x
r=A.cE(a1,s,a3,a4)
if(r===s)return a2
return A.xT(a1,r,!0)
case 8:q=a2.y
p=A.eN(a1,q,a3,a4)
if(p===q)return a2
return A.hy(a1,a2.x,p)
case 9:o=a2.x
n=A.cE(a1,o,a3,a4)
m=a2.y
l=A.eN(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.vO(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.eN(a1,j,a3,a4)
if(i===j)return a2
return A.xV(a1,k,i)
case 11:h=a2.x
g=A.cE(a1,h,a3,a4)
f=a2.y
e=A.DE(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.xS(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.eN(a1,d,a3,a4)
o=a2.x
n=A.cE(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.vP(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.b(A.hW("Attempted to substitute unexpected RTI kind "+a0))}},
eN(a,b,c,d){var s,r,q,p,o=b.length,n=A.tF(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.cE(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
DF(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.tF(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.cE(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
DE(a,b,c,d){var s,r=b.a,q=A.eN(a,r,c,d),p=b.b,o=A.eN(a,p,c,d),n=b.c,m=A.DF(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.jZ()
s.a=q
s.b=o
s.c=m
return s},
u(a,b){a[v.arrayRti]=b
return a},
kS(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.Ek(s)
return a.$S()}return null},
Er(a,b){var s
if(A.xf(b))if(a instanceof A.cP){s=A.kS(a)
if(s!=null)return s}return A.bn(a)},
bn(a){if(a instanceof A.k)return A.p(a)
if(Array.isArray(a))return A.a8(a)
return A.w2(J.dA(a))},
a8(a){var s=a[v.arrayRti],r=t.dG
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
p(a){var s=a.$ti
return s!=null?s:A.w2(a)},
w2(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.D3(a,s)},
D3(a,b){var s=a instanceof A.cP?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.Cs(v.typeUniverse,s.name)
b.$ccache=r
return r},
Ek(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.tw(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
uD(a){return A.bm(A.p(a))},
wc(a){var s=A.kS(a)
return A.bm(s==null?A.bn(a):s)},
w5(a){var s
if(a instanceof A.hn)return a.i7()
s=a instanceof A.cP?A.kS(a):null
if(s!=null)return s
if(t.aJ.b(a))return J.ws(a).a
if(Array.isArray(a))return A.a8(a)
return A.bn(a)},
bm(a){var s=a.r
return s==null?a.r=new A.tu(a):s},
Ef(a,b){var s,r,q=b,p=q.length
if(p===0)return t.aK
s=A.hA(v.typeUniverse,A.w5(q[0]),"@<0>")
for(r=1;r<p;++r)s=A.xX(v.typeUniverse,s,A.w5(q[r]))
return A.hA(v.typeUniverse,s,a)},
bo(a){return A.bm(A.tw(v.typeUniverse,a,!1))},
D2(a){var s=this
s.b=A.DB(s)
return s.b(a)},
DB(a){var s,r,q,p
if(a===t.K)return A.Db
if(A.dB(a))return A.Df
s=a.w
if(s===6)return A.D0
if(s===1)return A.yp
if(s===7)return A.D6
r=A.DA(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.dB)){a.f="$i"+q
if(q==="r")return A.D9
if(a===t.m)return A.D8
return A.De}}else if(s===10){p=A.Eb(a.x,a.y)
return p==null?A.yp:p}return A.CZ},
DA(a){if(a.w===8){if(a===t.S)return A.hG
if(a===t.i||a===t.q)return A.Da
if(a===t.N)return A.Dd
if(a===t.y)return A.kO}return null},
D1(a){var s=this,r=A.CY
if(A.dB(s))r=A.CG
else if(s===t.K)r=A.CF
else if(A.eQ(s)){r=A.D_
if(s===t.aV)r=A.ye
else if(s===t.T)r=A.kK
else if(s===t.o9)r=A.vV
else if(s===t.jh)r=A.CE
else if(s===t.jX)r=A.yd
else if(s===t.A)r=A.vW}else if(s===t.S)r=A.R
else if(s===t.N)r=A.an
else if(s===t.y)r=A.aT
else if(s===t.q)r=A.CD
else if(s===t.i)r=A.bR
else if(s===t.m)r=A.S
s.a=r
return s.a(a)},
CZ(a){var s=this
if(a==null)return A.eQ(s)
return A.Ex(v.typeUniverse,A.Er(a,s),s)},
D0(a){if(a==null)return!0
return this.x.b(a)},
De(a){var s,r=this
if(a==null)return A.eQ(r)
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.dA(a)[s]},
D9(a){var s,r=this
if(a==null)return A.eQ(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.dA(a)[s]},
D8(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.k)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
yo(a){if(typeof a=="object"){if(a instanceof A.k)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
CY(a){var s=this
if(a==null){if(A.eQ(s))return a}else if(s.b(a))return a
throw A.ao(A.yk(a,s),new Error())},
D_(a){var s=this
if(a==null||s.b(a))return a
throw A.ao(A.yk(a,s),new Error())},
yk(a,b){return new A.hw("TypeError: "+A.xH(a,A.b8(b,null)))},
xH(a,b){return A.ij(a)+": type '"+A.b8(A.w5(a),null)+"' is not a subtype of type '"+b+"'"},
bl(a,b){return new A.hw("TypeError: "+A.xH(a,b))},
D6(a){var s=this
return s.x.b(a)||A.vu(v.typeUniverse,s).b(a)},
Db(a){return a!=null},
CF(a){if(a!=null)return a
throw A.ao(A.bl(a,"Object"),new Error())},
Df(a){return!0},
CG(a){return a},
yp(a){return!1},
kO(a){return!0===a||!1===a},
aT(a){if(!0===a)return!0
if(!1===a)return!1
throw A.ao(A.bl(a,"bool"),new Error())},
vV(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.ao(A.bl(a,"bool?"),new Error())},
bR(a){if(typeof a=="number")return a
throw A.ao(A.bl(a,"double"),new Error())},
yd(a){if(typeof a=="number")return a
if(a==null)return a
throw A.ao(A.bl(a,"double?"),new Error())},
hG(a){return typeof a=="number"&&Math.floor(a)===a},
R(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.ao(A.bl(a,"int"),new Error())},
ye(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.ao(A.bl(a,"int?"),new Error())},
Da(a){return typeof a=="number"},
CD(a){if(typeof a=="number")return a
throw A.ao(A.bl(a,"num"),new Error())},
CE(a){if(typeof a=="number")return a
if(a==null)return a
throw A.ao(A.bl(a,"num?"),new Error())},
Dd(a){return typeof a=="string"},
an(a){if(typeof a=="string")return a
throw A.ao(A.bl(a,"String"),new Error())},
kK(a){if(typeof a=="string")return a
if(a==null)return a
throw A.ao(A.bl(a,"String?"),new Error())},
S(a){if(A.yo(a))return a
throw A.ao(A.bl(a,"JSObject"),new Error())},
vW(a){if(a==null)return a
if(A.yo(a))return a
throw A.ao(A.bl(a,"JSObject?"),new Error())},
yA(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.b8(a[q],b)
return s},
Dr(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.yA(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.b8(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
ym(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=", ",a0=null
if(a3!=null){s=a3.length
if(a2==null)a2=A.u([],t.s)
else a0=a2.length
r=a2.length
for(q=s;q>0;--q)a2.push("T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a){o=o+n+a2[a2.length-1-q]
m=a3[q]
l=m.w
if(!(l===2||l===3||l===4||l===5||m===p))o+=" extends "+A.b8(m,a2)}o+=">"}else o=""
p=a1.x
k=a1.y
j=k.a
i=j.length
h=k.b
g=h.length
f=k.c
e=f.length
d=A.b8(p,a2)
for(c="",b="",q=0;q<i;++q,b=a)c+=b+A.b8(j[q],a2)
if(g>0){c+=b+"["
for(b="",q=0;q<g;++q,b=a)c+=b+A.b8(h[q],a2)
c+="]"}if(e>0){c+=b+"{"
for(b="",q=0;q<e;q+=3,b=a){c+=b
if(f[q+1])c+="required "
c+=A.b8(f[q+2],a2)+" "+f[q]}c+="}"}if(a0!=null){a2.toString
a2.length=a0}return o+"("+c+") => "+d},
b8(a,b){var s,r,q,p,o,n,m=a.w
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){s=a.x
r=A.b8(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(m===7)return"FutureOr<"+A.b8(a.x,b)+">"
if(m===8){p=A.DJ(a.x)
o=a.y
return o.length>0?p+("<"+A.yA(o,b)+">"):p}if(m===10)return A.Dr(a,b)
if(m===11)return A.ym(a,b,null)
if(m===12)return A.ym(a.x,b,a.y)
if(m===13){n=a.x
return b[b.length-1-n]}return"?"},
DJ(a){var s=A.z7(a)
if(s!=null)return s
return"minified:"+a},
Ct(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
Cs(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.tw(a,b,!1)
else if(typeof m=="number"){s=m
r=A.hz(a,5,"#")
q=A.tF(s)
for(p=0;p<s;++p)q[p]=r
o=A.hy(a,b,q)
n[b]=o
return o}else return m},
Cr(a,b){return A.ya(a.tR,b)},
Cq(a,b){return A.ya(a.eT,b)},
tw(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.xW(a,null,b,!1)
r.set(b,s)
return s},
hA(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.xW(a,b,c,!0)
q.set(c,r)
return r},
xX(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.vO(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
xW(a,b,c,d){return A.Ce(A.C8(a,b,c,d))},
cC(a,b){b.a=A.D1
b.b=A.D2
return b},
hz(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.bt(null,null)
s.w=b
s.as=c
r=A.cC(a,s)
a.eC.set(c,r)
return r},
xU(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.Co(a,b,r,c)
a.eC.set(r,s)
return s},
Co(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.dB(b))if(!(b===t.P||b===t.v))if(s!==6)r=s===7&&A.eQ(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.bt(null,null)
q.w=6
q.x=b
q.as=c
return A.cC(a,q)},
xT(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.Cm(a,b,r,c)
a.eC.set(r,s)
return s},
Cm(a,b,c,d){var s,r
if(d){s=b.w
if(A.dB(b)||b===t.K)return b
else if(s===1)return A.hy(a,"o",[b])
else if(b===t.P||b===t.v)return t.gK}r=new A.bt(null,null)
r.w=7
r.x=b
r.as=c
return A.cC(a,r)},
Cp(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.bt(null,null)
s.w=13
s.x=b
s.as=q
r=A.cC(a,s)
a.eC.set(q,r)
return r},
hx(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
Cl(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
hy(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.hx(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.bt(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.cC(a,r)
a.eC.set(p,q)
return q},
vO(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.hx(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.bt(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.cC(a,o)
a.eC.set(q,n)
return n},
xV(a,b,c){var s,r,q="+"+(b+"("+A.hx(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.bt(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.cC(a,s)
a.eC.set(q,r)
return r},
xS(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.hx(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.hx(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.Cl(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.bt(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.cC(a,p)
a.eC.set(r,o)
return o},
vP(a,b,c,d){var s,r=b.as+("<"+A.hx(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.Cn(a,b,c,r,d)
a.eC.set(r,s)
return s},
Cn(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.tF(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.cE(a,b,r,0)
m=A.eN(a,c,r,0)
return A.vP(a,n,m,c!==m)}}l=new A.bt(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.cC(a,l)},
C8(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
Ce(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.Ca(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.xO(a,r,l,k,!1)
else if(q===46)r=A.xO(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.dq(a.u,a.e,k.pop()))
break
case 94:k.push(A.Cp(a.u,k.pop()))
break
case 35:k.push(A.hz(a.u,5,"#"))
break
case 64:k.push(A.hz(a.u,2,"@"))
break
case 126:k.push(A.hz(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.Cc(a,k)
break
case 38:A.Cb(a,k)
break
case 63:p=a.u
k.push(A.xU(p,A.dq(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.xT(p,A.dq(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.C9(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.xP(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.Cf(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.dq(a.u,a.e,m)},
Ca(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
xO(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.Ct(s,o.x)[p]
if(n==null)A.v('No "'+p+'" in "'+A.B8(o)+'"')
d.push(A.hA(s,o,n))}else d.push(p)
return m},
Cc(a,b){var s,r=a.u,q=A.xN(a,b),p=b.pop()
if(typeof p=="string")b.push(A.hy(r,p,q))
else{s=A.dq(r,a.e,p)
switch(s.w){case 11:b.push(A.vP(r,s,q,a.n))
break
default:b.push(A.vO(r,s,q))
break}}},
C9(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.xN(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.dq(p,a.e,o)
q=new A.jZ()
q.a=s
q.b=n
q.c=m
b.push(A.xS(p,r,q))
return
case-4:b.push(A.xV(p,b.pop(),s))
return
default:throw A.b(A.hW("Unexpected state under `()`: "+A.q(o)))}},
Cb(a,b){var s=b.pop()
if(0===s){b.push(A.hz(a.u,1,"0&"))
return}if(1===s){b.push(A.hz(a.u,4,"1&"))
return}throw A.b(A.hW("Unexpected extended operation "+A.q(s)))},
xN(a,b){var s=b.splice(a.p)
A.xP(a.u,a.e,s)
a.p=b.pop()
return s},
dq(a,b,c){if(typeof c=="string")return A.hy(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.Cd(a,b,c)}else return c},
xP(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.dq(a,b,c[s])},
Cf(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.dq(a,b,c[s])},
Cd(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.b(A.hW("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.b(A.hW("Bad index "+c+" for "+b.j(0)))},
Ex(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.aw(a,b,null,c,null)
r.set(c,s)}return s},
aw(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.dB(d))return!0
s=b.w
if(s===4)return!0
if(A.dB(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.aw(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.v){if(q===7)return A.aw(a,b,c,d.x,e)
return d===p||d===t.v||q===6}if(d===t.K){if(s===7)return A.aw(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.aw(a,b.x,c,d,e))return!1
return A.aw(a,A.vu(a,b),c,d,e)}if(s===6)return A.aw(a,p,c,d,e)&&A.aw(a,b.x,c,d,e)
if(q===7){if(A.aw(a,b,c,d.x,e))return!0
return A.aw(a,b,c,A.vu(a,d),e)}if(q===6)return A.aw(a,b,c,p,e)||A.aw(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.gY)return!0
o=s===10
if(o&&d===t.lZ)return!0
if(q===12){if(b===t.g)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.aw(a,j,c,i,e)||!A.aw(a,i,e,j,c))return!1}return A.yn(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.yn(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.D7(a,b,c,d,e)}if(o&&q===10)return A.Dc(a,b,c,d,e)
return!1},
yn(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.aw(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.aw(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.aw(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.aw(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.aw(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
D7(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.hA(a,b,r[o])
return A.yc(a,p,null,c,d.y,e)}return A.yc(a,b.y,null,c,d.y,e)},
yc(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.aw(a,b[s],d,e[s],f))return!1
return!0},
Dc(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.aw(a,r[s],c,q[s],e))return!1
return!0},
eQ(a){var s=a.w,r=!0
if(!(a===t.P||a===t.v))if(!A.dB(a))if(s!==6)r=s===7&&A.eQ(a.x)
return r},
dB(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
ya(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
tF(a){return a>0?new Array(a):v.typeUniverse.sEA},
bt:function bt(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
jZ:function jZ(){this.c=this.b=this.a=null},
tu:function tu(a){this.a=a},
jV:function jV(){},
hw:function hw(a){this.a=a},
BD(){var s,r,q
if(self.scheduleImmediate!=null)return A.DL()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.cG(new A.qx(s),1)).observe(r,{childList:true})
return new A.qw(s,r,q)}else if(self.setImmediate!=null)return A.DM()
return A.DN()},
BE(a){self.scheduleImmediate(A.cG(new A.qy(a),0))},
BF(a){self.setImmediate(A.cG(new A.qz(a),0))},
BG(a){A.vy(B.a2,a)},
vy(a,b){var s=B.b.V(a.a,1000)
return A.Cj(s<0?0:s,b)},
Cj(a,b){var s=new A.ky(!0)
s.l1(a,b)
return s},
Ck(a,b){var s=new A.ky(!1)
s.l2(a,b)
return s},
i(a){return new A.h_(new A.l($.m,a.h("l<0>")),a.h("h_<0>"))},
h(a,b){a.$2(0,null)
b.b=!0
return b.a},
c(a,b){A.yf(a,b)},
f(a,b){b.W(a)},
e(a,b){b.b5(A.H(a),A.O(a))},
yf(a,b){var s,r,q=new A.tU(b),p=new A.tV(b)
if(a instanceof A.l)a.iJ(q,p,t.z)
else{s=t.z
if(a instanceof A.l)a.b8(q,p,s)
else{r=new A.l($.m,t._)
r.a=8
r.c=a
r.iJ(q,p,s)}}},
d(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.m.cE(new A.uq(s),t.H,t.S,t.z)},
kL(a,b,c){var s,r,q,p
if(b===0){s=c.c
if(s!=null)s.bU(null)
else{s=c.a
s===$&&A.L()
s.n()}return}else if(b===1){s=c.c
if(s!=null){r=A.H(a)
q=A.O(a)
s.aa(new A.a1(r,q))}else{s=A.H(a)
r=A.O(a)
q=c.a
q===$&&A.L()
q.ae(s,r)
c.a.n()}return}if(a instanceof A.he){if(c.c!=null){b.$2(2,null)
return}s=a.b
if(s===0){s=a.a
r=c.a
r===$&&A.L()
r.q(0,s)
A.eS(new A.tS(c,b))
return}else if(s===1){p=a.a
s=c.a
s===$&&A.L()
s.e0(p,!1).aQ(new A.tT(c,b),t.P)
return}}A.yf(a,b)},
DD(a){var s=a.a
s===$&&A.L()
return new A.a5(s,A.p(s).h("a5<1>"))},
BH(a,b){var s=new A.jJ(b.h("jJ<0>"))
s.kX(a,b)
return s},
Dh(a,b){return A.BH(a,b)},
C0(a){return new A.he(a,1)},
xL(a){return new A.he(a,0)},
xR(a,b,c){return 0},
cK(a){var s
if(t.C.b(a)){s=a.gby()
if(s!=null)return s}return B.r},
Ao(a,b){var s=new A.l($.m,b.h("l<0>"))
A.pr(B.a2,new A.mT(a,s))
return s},
dP(a,b){var s,r,q,p,o,n,m,l=null
try{l=a.$0()}catch(q){s=A.H(q)
r=A.O(q)
p=new A.l($.m,b.h("l<0>"))
o=s
n=r
m=A.dw(o,n)
if(m==null)o=new A.a1(o,n==null?A.cK(o):n)
else o=m
p.R(o)
return p}return b.h("o<0>").b(l)?l:A.bO(l,b)},
mS(a,b){var s=a==null?b.a(a):a,r=new A.l($.m,b.h("l<0>"))
r.az(s)
return r},
mU(a,b){var s,r,q,p,o,n,m,l,k,j,i={},h=null,g=!1,f=new A.l($.m,b.h("l<r<0>>"))
i.a=null
i.b=0
i.c=i.d=null
s=new A.mW(i,h,g,f)
try{for(n=J.T(a),m=t.P;n.l();){r=n.gp()
q=i.b
r.b8(new A.mV(i,q,f,b,h,g),s,m);++i.b}n=i.b
if(n===0){n=f
n.bU(A.u([],b.h("t<0>")))
return n}i.a=A.b1(n,null,!1,b.h("0?"))}catch(l){p=A.H(l)
o=A.O(l)
if(i.b===0||g){n=f
m=p
k=o
j=A.dw(m,k)
if(j==null)m=new A.a1(m,k==null?A.cK(m):k)
else m=j
n.R(m)
return n}else{i.d=p
i.c=o}}return f},
ir(a,b,c,d){var s=new A.mM(d,null,b,c),r=$.m,q=new A.l(r,c.h("l<0>"))
if(r!==B.e)s=r.cE(s,c.h("0/"),t.K,t.l)
a.cj(new A.bi(q,2,null,s,a.$ti.h("@<1>").H(c).h("bi<1,2>")))
return q},
An(a,b){var s,r,q,p=A.u([],b.h("t<bj<0>>"))
for(s=a.length,r=b.h("bj<0>"),q=0;q<a.length;a.length===s||(0,A.a6)(a),++q)p.push(new A.bj(a[q],r))
if(p.length===0)return A.mS(A.u([],b.h("t<0>")),b.h("r<0>"))
s=new A.l($.m,b.h("l<r<0>>"))
A.xI(p,new A.mN(new A.N(s,b.h("N<r<0>>")),p,b))
return s},
Dk(a){return a!=null},
wO(a,b,c,d){var s=b.h("@<0>").H(c).H(d),r=new A.l($.m,s.h("l<+(1,2,3)>")),q=new A.bj(a.a,b.h("bj<0>")),p=new A.bj(a.b,c.h("bj<0>")),o=new A.bj(a.c,d.h("bj<0>"))
A.xI(A.u([q,p,o],t.dB),new A.mR(new A.N(r,s.h("N<+(1,2,3)>")),q,p,o))
return r},
xI(a,b){var s,r={},q=r.a=r.b=0,p=new A.rq(r,a,b)
for(s=a.length;q<a.length;a.length===s||(0,A.a6)(a),++q)a[q].mC(p)},
dw(a,b){var s,r,q,p=$.m
if(p===B.e)return null
s=p.jb(a,b)
if(s==null)return null
r=s.a
q=s.b
if(t.C.b(r))A.j0(r,q)
return s},
av(a,b){var s
if($.m!==B.e){s=A.dw(a,b)
if(s!=null)return s}if(b==null)if(t.C.b(a)){b=a.gby()
if(b==null){A.j0(a,B.r)
b=B.r}}else b=B.r
else if(t.C.b(a))A.j0(a,b)
return new A.a1(a,b)},
BV(a,b,c){var s=new A.l(b,c.h("l<0>"))
s.a=8
s.c=a
return s},
bO(a,b){var s=new A.l($.m,b.h("l<0>"))
s.a=8
s.c=a
return s},
rw(a,b,c){var s,r,q,p={},o=p.a=a
while(s=o.a,(s&4)!==0){o=o.c
p.a=o}if(o===b){s=A.fH()
b.R(new A.a1(new A.a4(!0,o,null,"Cannot complete a future with itself"),s))
return}r=b.a&1
s=o.a=s|r
if((s&24)===0){q=b.c
b.a=b.a&1|4
b.c=o
o.il(q)
return}if(!c)if(b.c==null)o=(s&16)===0||r!==0
else o=!1
else o=!0
if(o){q=b.d_()
b.dL(p.a)
A.dn(b,q)
return}b.a^=2
b.b.bP(new A.rx(p,b))},
dn(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g={},f=g.a=a
for(;;){s={}
r=f.a
q=(r&16)===0
p=!q
if(b==null){if(p&&(r&1)===0){r=f.c
f.b.cv(r.a,r.b)}return}s.a=b
o=b.a
for(f=b;o!=null;f=o,o=n){f.a=null
A.dn(g.a,f)
s.a=o
n=o.a}r=g.a
m=r.c
s.b=p
s.c=m
if(q){l=f.c
l=(l&1)!==0||(l&15)===8}else l=!0
if(l){k=f.b.b
if(p){f=r.b
f=!(f===k||f.gbk()===k.gbk())}else f=!1
if(f){f=g.a
r=f.c
f.b.cv(r.a,r.b)
return}j=$.m
if(j!==k)$.m=k
else j=null
f=s.a.c
if((f&15)===8)new A.rB(s,g,p).$0()
else if(q){if((f&1)!==0)new A.rA(s,m).$0()}else if((f&2)!==0)new A.rz(g,s).$0()
if(j!=null)$.m=j
f=s.c
if(f instanceof A.l){r=s.a.$ti
r=r.h("o<2>").b(f)||!r.y[1].b(f)}else r=!1
if(r){i=s.a.b
if((f.a&24)!==0){h=i.c
i.c=null
b=i.dR(h)
i.a=f.a&30|i.a&1
i.c=f.c
g.a=f
continue}else A.rw(f,i,!0)
return}}i=s.a.b
h=i.c
i.c=null
b=i.dR(h)
f=s.b
r=s.c
if(!f){i.a=8
i.c=r}else{i.a=i.a&1|16
i.c=r}g.a=i
f=i}},
yu(a,b){if(t.b.b(a))return b.cE(a,t.z,t.K,t.l)
if(t.mq.b(a))return b.bL(a,t.z,t.K)
throw A.b(A.aV(a,"onError",u.w))},
Dj(){var s,r
for(s=$.eL;s!=null;s=$.eL){$.hI=null
r=s.b
$.eL=r
if(r==null)$.hH=null
s.a.$0()}},
DC(){$.w3=!0
try{A.Dj()}finally{$.hI=null
$.w3=!1
if($.eL!=null)$.wk().$1(A.yJ())}},
yC(a){var s=new A.jI(a),r=$.hH
if(r==null){$.eL=$.hH=s
if(!$.w3)$.wk().$1(A.yJ())}else $.hH=r.b=s},
Dz(a){var s,r,q,p=$.eL
if(p==null){A.yC(a)
$.hI=$.hH
return}s=new A.jI(a)
r=$.hI
if(r==null){s.b=p
$.eL=$.hI=s}else{q=r.b
s.b=q
$.hI=r.b=s
if(q==null)$.hH=s}},
eS(a){var s,r=null,q=$.m
if(B.e===q){A.ud(r,r,B.e,a)
return}if(B.e===q.gft().a)s=B.e.gbk()===q.gbk()
else s=!1
if(s){A.ud(r,r,q,q.aY(a,t.H))
return}s=$.m
s.bP(s.d6(a))},
xk(a,b){var s=null,r=b.h("bN<0>"),q=new A.bN(s,s,s,s,r)
q.M(a)
q.hJ()
return new A.a5(q,r.h("a5<1>"))},
Fc(a){return new A.bQ(A.ba(a,"stream",t.K))},
bK(a,b,c,d,e,f){return e?new A.cB(b,c,d,a,f.h("cB<0>")):new A.bN(b,c,d,a,f.h("bN<0>"))},
d7(a,b){var s=null
return a?new A.ds(s,s,b.h("ds<0>")):new A.h0(s,s,b.h("h0<0>"))},
kP(a){var s,r,q
if(a==null)return
try{a.$0()}catch(q){s=A.H(q)
r=A.O(q)
$.m.cv(s,r)}},
BT(a,b,c,d,e,f){var s=$.m,r=e?1:0,q=c!=null?32:0,p=A.jM(s,b,f),o=A.jN(s,c),n=d==null?A.ur():d
return new A.cx(a,p,o,s.aY(n,t.H),s,r|q,f.h("cx<0>"))},
BB(a,b,c){var s=$.m,r=a.geQ(),q=a.gdK()
return new A.fZ(new A.l(s,t._),b.B(r,!1,a.geW(),q))},
BC(a){return new A.qu(a)},
jM(a,b,c){var s=b==null?A.DP():b
return a.bL(s,t.H,c)},
jN(a,b){if(b==null)b=A.DQ()
if(t.r.b(b))return a.cE(b,t.z,t.K,t.l)
if(t.i6.b(b))return a.bL(b,t.z,t.K)
throw A.b(A.K(u.y,null))},
Dl(a){},
Dn(a,b){$.m.cv(a,b)},
Dm(){},
xG(a,b){var s=$.m,r=new A.ep(s,b.h("ep<0>"))
A.eS(r.gii())
if(a!=null)r.c=s.aY(a,t.H)
return r},
Dx(a,b,c){var s,r,q,p
try{b.$1(a.$0())}catch(p){s=A.H(p)
r=A.O(p)
q=A.dw(s,r)
if(q!=null)c.$2(q.a,q.b)
else c.$2(s,r)}},
CO(a,b,c){var s=a.u()
if(s!==$.cI())s.J(new A.tY(b,c))
else b.aa(c)},
CP(a,b){return new A.tX(a,b)},
CQ(a,b,c){var s=a.u()
if(s!==$.cI())s.J(new A.tZ(b,c))
else b.bb(c)},
yb(a,b,c){var s=A.dw(b,c)
if(s!=null){b=s.a
c=s.b}a.a8(b,c)},
pr(a,b){var s=$.m
if(s===B.e)return s.fM(a,b)
return s.fM(a,s.d6(b))},
EL(a,b,c){return A.Dy(a,null,b,c)},
Dy(a,b,c,d){return $.m.eb(c,b).bs(a,d)},
Dv(a,b,c,d,e){A.hJ(d,e)},
hJ(a,b){A.Dz(new A.ua(a,b))},
ub(a,b,c,d){var s,r=$.m
if(r===c)return d.$0()
$.m=c
s=r
try{r=d.$0()
return r}finally{$.m=s}},
uc(a,b,c,d,e){var s,r=$.m
if(r===c)return d.$1(e)
$.m=c
s=r
try{r=d.$1(e)
return r}finally{$.m=s}},
w4(a,b,c,d,e,f){var s,r=$.m
if(r===c)return d.$2(e,f)
$.m=c
s=r
try{r=d.$2(e,f)
return r}finally{$.m=s}},
yy(a,b,c,d){return d},
yz(a,b,c,d){return d},
yx(a,b,c,d){return d},
Du(a,b,c,d,e){return null},
ud(a,b,c,d){var s,r
if(B.e!==c){s=B.e.gbk()
r=c.gbk()
d=s!==r?c.d6(d):c.fH(d,t.H)}A.yC(d)},
Dt(a,b,c,d,e){e=c.fH(e,t.H)
return A.vy(d,e)},
Ds(a,b,c,d,e){var s
e=c.pL(e,t.H,t.hU)
s=d.gpS()
return A.Ck(s.pI(0,0)?0:s,e)},
Dw(a,b,c,d){A.yY(d)},
yw(a,b,c,d,e){var s,r,q,p,o=null
if(e!=null){s=t.X
r=A.vh(o,o,o,s,s)
r.ab(0,e)}else r=o
s=new A.jS(c.giz(),c.giB(),c.giA(),c.git(),c.giu(),c.gis(),c.ghZ(),c.gft(),c.ghT(),c.ghS(),c.gim(),c.gi3(),c.gfj(),c.gfD(),c)
if(d!=null){q=d.x
if(q!=null)s.w=new A.kH(s,q)
p=d.a
if(p!=null)s.as=new A.kG(s,p)}if(r!=null)s.at=new A.kI(s,r)
return s},
qx:function qx(a){this.a=a},
qw:function qw(a,b,c){this.a=a
this.b=b
this.c=c},
qy:function qy(a){this.a=a},
qz:function qz(a){this.a=a},
ky:function ky(a){this.a=a
this.b=null
this.c=0},
tt:function tt(a,b){this.a=a
this.b=b},
ts:function ts(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
h_:function h_(a,b){this.a=a
this.b=!1
this.$ti=b},
tU:function tU(a){this.a=a},
tV:function tV(a){this.a=a},
uq:function uq(a){this.a=a},
tS:function tS(a,b){this.a=a
this.b=b},
tT:function tT(a,b){this.a=a
this.b=b},
jJ:function jJ(a){var _=this
_.a=$
_.b=!1
_.c=null
_.$ti=a},
qB:function qB(a){this.a=a},
qC:function qC(a){this.a=a},
qE:function qE(a){this.a=a},
qF:function qF(a,b){this.a=a
this.b=b},
qD:function qD(a,b){this.a=a
this.b=b},
qA:function qA(a){this.a=a},
he:function he(a,b){this.a=a
this.b=b},
kw:function kw(a){var _=this
_.a=a
_.e=_.d=_.c=_.b=null},
eD:function eD(a,b){this.a=a
this.$ti=b},
a1:function a1(a,b){this.a=a
this.b=b},
aJ:function aJ(a,b){this.a=a
this.$ti=b},
di:function di(a,b,c,d,e,f,g){var _=this
_.ay=0
_.CW=_.ch=null
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
c8:function c8(){},
ds:function ds(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.r=_.f=_.e=_.d=null
_.$ti=c},
tp:function tp(a,b){this.a=a
this.b=b},
tr:function tr(a,b,c){this.a=a
this.b=b
this.c=c},
tq:function tq(a){this.a=a},
h0:function h0(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.r=_.f=_.e=_.d=null
_.$ti=c},
mT:function mT(a,b){this.a=a
this.b=b},
mW:function mW(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mV:function mV(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
mM:function mM(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mN:function mN(a,b,c){this.a=a
this.b=b
this.c=c},
mR:function mR(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
e_:function e_(a,b){this.c=a
this.d=b},
bj:function bj(a,b){var _=this
_.a=a
_.c=_.b=null
_.$ti=b},
rr:function rr(a,b){this.a=a
this.b=b},
rs:function rs(a,b){this.a=a
this.b=b},
rq:function rq(a,b,c){this.a=a
this.b=b
this.c=c},
dj:function dj(){},
ad:function ad(a,b){this.a=a
this.$ti=b},
N:function N(a,b){this.a=a
this.$ti=b},
bi:function bi(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
l:function l(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
rt:function rt(a,b){this.a=a
this.b=b},
ry:function ry(a,b){this.a=a
this.b=b},
rx:function rx(a,b){this.a=a
this.b=b},
rv:function rv(a,b){this.a=a
this.b=b},
ru:function ru(a,b){this.a=a
this.b=b},
rB:function rB(a,b,c){this.a=a
this.b=b
this.c=c},
rC:function rC(a,b){this.a=a
this.b=b},
rD:function rD(a){this.a=a},
rA:function rA(a,b){this.a=a
this.b=b},
rz:function rz(a,b){this.a=a
this.b=b},
rE:function rE(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
rF:function rF(a,b,c){this.a=a
this.b=b
this.c=c},
rG:function rG(a,b){this.a=a
this.b=b},
jI:function jI(a){this.a=a
this.b=null},
G:function G(){},
oC:function oC(a,b,c){this.a=a
this.b=b
this.c=c},
oB:function oB(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
oH:function oH(a,b){this.a=a
this.b=b},
oI:function oI(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
oF:function oF(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
oG:function oG(a,b){this.a=a
this.b=b},
oJ:function oJ(a,b){this.a=a
this.b=b},
oK:function oK(a,b){this.a=a
this.b=b},
oD:function oD(a){this.a=a},
oE:function oE(a,b,c){this.a=a
this.b=b
this.c=c},
fJ:function fJ(){},
jj:function jj(){},
cz:function cz(){},
tj:function tj(a){this.a=a},
ti:function ti(a){this.a=a},
kx:function kx(){},
jK:function jK(){},
bN:function bN(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
cB:function cB(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
a5:function a5(a,b){this.a=a
this.$ti=b},
cx:function cx(a,b,c,d,e,f,g){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
fZ:function fZ(a,b){this.a=a
this.b=b},
qu:function qu(a){this.a=a},
qt:function qt(a){this.a=a},
kt:function kt(a,b,c){this.c=a
this.a=b
this.b=c},
au:function au(){},
qO:function qO(a,b,c){this.a=a
this.b=b
this.c=c},
qN:function qN(a){this.a=a},
eC:function eC(){},
jU:function jU(){},
bx:function bx(a){this.b=a
this.a=null},
eo:function eo(a,b){this.b=a
this.c=b
this.a=null},
ri:function ri(){},
ey:function ey(){this.a=0
this.c=this.b=null},
t3:function t3(a,b){this.a=a
this.b=b},
ep:function ep(a,b){var _=this
_.a=1
_.b=a
_.c=null
_.$ti=b},
bQ:function bQ(a){this.a=null
this.b=a
this.c=!1},
dm:function dm(a){this.$ti=a},
bA:function bA(a,b,c){this.a=a
this.b=b
this.$ti=c},
t1:function t1(a,b){this.a=a
this.b=b},
hh:function hh(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
tY:function tY(a,b){this.a=a
this.b=b},
tX:function tX(a,b){this.a=a
this.b=b},
tZ:function tZ(a,b){this.a=a
this.b=b},
b6:function b6(){},
es:function es(a,b,c,d,e,f,g){var _=this
_.w=a
_.x=null
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
dv:function dv(a,b,c){this.b=a
this.a=b
this.$ti=c},
bz:function bz(a,b,c){this.b=a
this.a=b
this.$ti=c},
h9:function h9(a){this.a=a},
eA:function eA(a,b,c,d,e,f){var _=this
_.w=$
_.x=null
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=null
_.$ti=f},
c7:function c7(a,b,c){this.a=a
this.b=b
this.$ti=c},
ks:function ks(a){this.a=a},
tP:function tP(a,b){this.a=a
this.b=b},
tR:function tR(a,b){this.a=a
this.b=b},
tQ:function tQ(a,b){this.a=a
this.b=b},
tN:function tN(a,b){this.a=a
this.b=b},
tO:function tO(a,b){this.a=a
this.b=b},
tM:function tM(a,b){this.a=a
this.b=b},
tJ:function tJ(a,b){this.a=a
this.b=b},
kH:function kH(a,b){this.a=a
this.b=b},
tI:function tI(a,b){this.a=a
this.b=b},
tH:function tH(){},
tL:function tL(a,b){this.a=a
this.b=b},
tK:function tK(a,b){this.a=a
this.b=b},
kG:function kG(a,b){this.a=a
this.b=b},
kI:function kI(a,b){this.a=a
this.b=b},
kF:function kF(){},
jS:function jS(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l
_.as=m
_.at=n
_.ax=null
_.ay=o},
rd:function rd(a,b,c){this.a=a
this.b=b
this.c=c},
rc:function rc(a,b){this.a=a
this.b=b},
re:function re(a,b,c){this.a=a
this.b=b
this.c=c},
ko:function ko(){},
t8:function t8(a,b,c){this.a=a
this.b=b
this.c=c},
t7:function t7(a,b){this.a=a
this.b=b},
t9:function t9(a,b,c){this.a=a
this.b=b
this.c=c},
eH:function eH(a){this.a=a},
ua:function ua(a,b){this.a=a
this.b=b},
fX:function fX(a,b,c,d,e,f,g,h,i,j,k,l,m){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l
_.as=m},
vh(a,b,c,d,e){if(c==null)if(b==null){if(a==null)return new A.ca(d.h("@<0>").H(e).h("ca<1,2>"))
b=A.w8()}else{if(A.yM()===b&&A.yL()===a)return new A.dp(d.h("@<0>").H(e).h("dp<1,2>"))
if(a==null)a=A.w7()}else{if(b==null)b=A.w8()
if(a==null)a=A.w7()}return A.BU(a,b,c,d,e)},
xJ(a,b){var s=a[b]
return s===a?null:s},
vL(a,b,c){if(c==null)a[b]=a
else a[b]=c},
vK(){var s=Object.create(null)
A.vL(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
BU(a,b,c,d,e){var s=c!=null?c:new A.rb(d)
return new A.h4(a,b,s,d.h("@<0>").H(e).h("h4<1,2>"))},
vp(a,b,c,d){if(b==null){if(a==null)return new A.b_(c.h("@<0>").H(d).h("b_<1,2>"))
b=A.w8()}else{if(A.yM()===b&&A.yL()===a)return new A.fk(c.h("@<0>").H(d).h("fk<1,2>"))
if(a==null)a=A.w7()}return A.C6(a,b,null,c,d)},
br(a,b,c){return A.Eh(a,new A.b_(b.h("@<0>").H(c).h("b_<1,2>")))},
Z(a,b){return new A.b_(a.h("@<0>").H(b).h("b_<1,2>"))},
C6(a,b,c,d,e){return new A.hg(a,b,new A.t_(d),d.h("@<0>").H(e).h("hg<1,2>"))},
vq(a){return new A.cb(a.h("cb<0>"))},
bs(a){return new A.cb(a.h("cb<0>"))},
vN(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
C7(a,b,c){var s=new A.ev(a,b,c.h("ev<0>"))
s.c=a.e
return s},
CS(a,b){return J.z(a,b)},
CT(a){return J.y(a)},
Ay(a){var s=new A.kl(a)
if(s.l())return s.gp()
return null},
wY(a,b,c){var s=A.vp(null,null,b,c)
a.ac(0,new A.nA(s,b,c))
return s},
AG(a,b){var s,r,q=A.vq(b)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)q.q(0,b.a(a[r]))
return q},
AH(a,b){var s=A.vq(b)
s.ab(0,a)
return s},
AI(a,b){var s=t.bP
return J.wq(s.a(a),s.a(b))},
nF(a){var s,r
if(A.we(a))return"{...}"
s=new A.X("")
try{r={}
$.dx.push(a)
s.a+="{"
r.a=!0
a.ac(0,new A.nG(r,s))
s.a+="}"}finally{$.dx.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
nB(a){return new A.fo(A.b1(A.AJ(null),null,!1,a.h("0?")),a.h("fo<0>"))},
AJ(a){return 8},
ca:function ca(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
rH:function rH(a){this.a=a},
dp:function dp(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
h4:function h4(a,b,c,d){var _=this
_.f=a
_.r=b
_.w=c
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=d},
rb:function rb(a){this.a=a},
hc:function hc(a,b){this.a=a
this.$ti=b},
k_:function k_(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
hg:function hg(a,b,c,d){var _=this
_.w=a
_.x=b
_.y=c
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=d},
t_:function t_(a){this.a=a},
cb:function cb(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
t0:function t0(a){this.a=a
this.c=this.b=null},
ev:function ev(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
dc:function dc(a,b){this.a=a
this.$ti=b},
nA:function nA(a,b,c){this.a=a
this.b=b
this.c=c},
cY:function cY(a){var _=this
_.b=_.a=0
_.c=null
_.$ti=a},
k6:function k6(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=null
_.d=c
_.e=!1
_.$ti=d},
aG:function aG(){},
A:function A(){},
J:function J(){},
nE:function nE(a){this.a=a},
nG:function nG(a,b){this.a=a
this.b=b},
kB:function kB(){},
fq:function fq(){},
dd:function dd(a,b){this.a=a
this.$ti=b},
fo:function fo(a,b){var _=this
_.a=a
_.d=_.c=_.b=0
_.$ti=b},
k7:function k7(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.$ti=e},
cr:function cr(){},
hs:function hs(){},
hB:function hB(){},
yr(a,b){var s,r,q,p=null
try{p=JSON.parse(a)}catch(r){s=A.H(r)
q=A.ak(String(s),null,null)
throw A.b(q)}q=A.u_(p)
return q},
u_(a){var s
if(a==null)return null
if(typeof a!="object")return a
if(!Array.isArray(a))return new A.k3(a,Object.create(null))
for(s=0;s<a.length;++s)a[s]=A.u_(a[s])
return a},
CC(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.zt()
else s=new Uint8Array(o)
for(r=J.a3(a),q=0;q<o;++q){p=r.i(a,b+q)
if((p&255)!==p)p=255
s[q]=p}return s},
CB(a,b,c,d){var s=a?$.zs():$.zr()
if(s==null)return null
if(0===c&&d===b.length)return A.y8(s,b)
return A.y8(s,b.subarray(c,d))},
y8(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
ww(a,b,c,d,e,f){if(B.b.aR(f,4)!==0)throw A.b(A.ak("Invalid base64 padding, padded length must be multiple of four, is "+f,a,c))
if(d+e!==f)throw A.b(A.ak("Invalid base64 padding, '=' not at the end",a,b))
if(e>2)throw A.b(A.ak("Invalid base64 padding, more than two '=' characters",a,b))},
BI(a,b,c,d,e,f,g,h){var s,r,q,p,o,n,m,l=h>>>2,k=3-(h&3)
for(s=J.a3(b),r=f.$flags|0,q=c,p=0;q<d;++q){o=s.i(b,q)
p=(p|o)>>>0
l=(l<<8|o)&16777215;--k
if(k===0){n=g+1
r&2&&A.C(f)
f[g]=a.charCodeAt(l>>>18&63)
g=n+1
f[n]=a.charCodeAt(l>>>12&63)
n=g+1
f[g]=a.charCodeAt(l>>>6&63)
g=n+1
f[n]=a.charCodeAt(l&63)
l=0
k=3}}if(p>=0&&p<=255){if(e&&k<3){n=g+1
m=n+1
if(3-k===1){r&2&&A.C(f)
f[g]=a.charCodeAt(l>>>2&63)
f[n]=a.charCodeAt(l<<4&63)
f[m]=61
f[m+1]=61}else{r&2&&A.C(f)
f[g]=a.charCodeAt(l>>>10&63)
f[n]=a.charCodeAt(l>>>4&63)
f[m]=a.charCodeAt(l<<2&63)
f[m+1]=61}return 0}return(l<<2|3-k)>>>0}for(q=c;q<d;){o=s.i(b,q)
if(o<0||o>255)break;++q}throw A.b(A.aV(b,"Not a byte value at index "+q+": 0x"+B.b.oS(s.i(b,q),16),null))},
wI(a){return B.bl.i(0,a.toLowerCase())},
wV(a,b,c){return new A.fl(a,b)},
CU(a){return a.eu()},
C1(a,b){return new A.rV(a,[],A.E8())},
C2(a,b,c){var s,r=new A.X("")
A.xM(a,r,b,c)
s=r.a
return s.charCodeAt(0)==0?s:s},
xM(a,b,c,d){var s=A.C1(b,c)
s.eB(a)},
C3(a,b,c){var s,r,q
for(s=J.a3(a),r=b,q=0;r<c;++r)q=(q|s.i(a,r))>>>0
if(q>=0&&q<=255)return
A.C4(a,b,c)},
C4(a,b,c){var s,r,q
for(s=J.a3(a),r=b;r<c;++r){q=s.i(a,r)
if(q<0||q>255)throw A.b(A.ak("Source contains non-Latin-1 characters.",a,r))}},
C5(a){return new A.eu(a,new A.dr(a))},
y9(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
k3:function k3(a,b){this.a=a
this.b=b
this.c=null},
k4:function k4(a){this.a=a},
rT:function rT(a,b,c){this.b=a
this.c=b
this.a=c},
tD:function tD(){},
tC:function tC(){},
hS:function hS(){},
kA:function kA(){},
hU:function hU(a){this.a=a},
tv:function tv(a,b){this.a=a
this.b=b},
kz:function kz(){},
hT:function hT(a,b){this.a=a
this.b=b},
rl:function rl(a){this.a=a},
ta:function ta(a){this.a=a},
lh:function lh(){},
hY:function hY(){},
qG:function qG(){},
qM:function qM(a){this.c=null
this.a=0
this.b=a},
qH:function qH(){},
qv:function qv(a,b){this.a=a
this.b=b},
lu:function lu(){},
jO:function jO(a){this.a=a},
jP:function jP(a,b){this.a=a
this.b=b
this.c=0},
i7:function i7(){},
dk:function dk(a,b){this.a=a
this.b=b},
i8:function i8(){},
af:function af(){},
m0:function m0(a){this.a=a},
cV:function cV(){},
mG:function mG(){},
mH:function mH(){},
fl:function fl(a,b){this.a=a
this.b=b},
iC:function iC(a,b){this.a=a
this.b=b},
nx:function nx(){},
iE:function iE(a){this.b=a},
rU:function rU(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
iD:function iD(a){this.a=a},
rW:function rW(){},
rX:function rX(a,b){this.a=a
this.b=b},
rV:function rV(a,b,c){this.c=a
this.a=b
this.b=c},
iF:function iF(){},
iH:function iH(a){this.a=a},
iG:function iG(a,b){this.a=a
this.b=b},
k5:function k5(a){this.a=a},
rY:function rY(a){this.a=a},
ny:function ny(){},
rZ:function rZ(){},
eu:function eu(a,b){var _=this
_.e=a
_.a=b
_.c=_.b=null
_.d=!1},
jl:function jl(){},
to:function to(a,b){this.a=a
this.b=b},
hv:function hv(){},
dr:function dr(a){this.a=a},
kD:function kD(a,b,c){this.a=a
this.b=b
this.c=c},
jy:function jy(){},
jA:function jA(){},
kE:function kE(a){this.b=this.a=0
this.c=a},
tE:function tE(a,b){var _=this
_.d=a
_.b=_.a=0
_.c=b},
jz:function jz(a){this.a=a},
cD:function cD(a){this.a=a
this.b=16
this.c=0},
kJ:function kJ(){},
BM(a,b){var s,r,q=$.ce(),p=a.length,o=4-p%4
if(o===4)o=0
for(s=0,r=0;r<p;++r){s=s*10+a.charCodeAt(r)-48;++o
if(o===4){q=q.aH(0,$.wl()).dD(0,A.qI(s))
s=0
o=0}}if(b)return q.bx(0)
return q},
xx(a){if(48<=a&&a<=57)return a-48
return(a|32)-97+10},
BN(a,b,c){var s,r,q,p,o,n,m,l=a.length,k=l-b,j=B.a6.mX(k/4),i=new Uint16Array(j),h=j-1,g=k-h*4
for(s=b,r=0,q=0;q<g;++q,s=p){p=s+1
o=A.xx(a.charCodeAt(s))
if(o>=16)return null
r=r*16+o}n=h-1
i[h]=r
for(;s<l;n=m){for(r=0,q=0;q<4;++q,s=p){p=s+1
o=A.xx(a.charCodeAt(s))
if(o>=16)return null
r=r*16+o}m=n-1
i[n]=r}if(j===1&&i[0]===0)return $.ce()
l=A.bh(j,i)
return new A.az(l===0?!1:c,i,l)},
BP(a,b){var s,r,q,p,o
if(a==="")return null
s=$.zp().jg(a)
if(s==null)return null
r=s.b
q=r[1]==="-"
p=r[4]
o=r[3]
if(p!=null)return A.BM(p,q)
if(o!=null)return A.BN(o,2,q)
return null},
bh(a,b){for(;;){if(!(a>0&&b[a-1]===0))break;--a}return a},
vI(a,b,c,d){var s,r=new Uint16Array(d),q=c-b
for(s=0;s<q;++s)r[s]=a[b+s]
return r},
qI(a){var s,r,q,p,o=a<0
if(o){if(a===-9223372036854776e3){s=new Uint16Array(4)
s[3]=32768
r=A.bh(4,s)
return new A.az(r!==0,s,r)}a=-a}if(a<65536){s=new Uint16Array(1)
s[0]=a
r=A.bh(1,s)
return new A.az(r===0?!1:o,s,r)}if(a<=4294967295){s=new Uint16Array(2)
s[0]=a&65535
s[1]=B.b.a1(a,16)
r=A.bh(2,s)
return new A.az(r===0?!1:o,s,r)}r=B.b.V(B.b.gj_(a)-1,16)+1
s=new Uint16Array(r)
for(q=0;a!==0;q=p){p=q+1
s[q]=a&65535
a=B.b.V(a,65536)}r=A.bh(r,s)
return new A.az(r===0?!1:o,s,r)},
vJ(a,b,c,d){var s,r,q
if(b===0)return 0
if(c===0&&d===a)return b
for(s=b-1,r=d.$flags|0;s>=0;--s){q=a[s]
r&2&&A.C(d)
d[s+c]=q}for(s=c-1;s>=0;--s){r&2&&A.C(d)
d[s]=0}return b+c},
BL(a,b,c,d){var s,r,q,p,o,n=B.b.V(c,16),m=B.b.aR(c,16),l=16-m,k=B.b.cL(1,l)-1
for(s=b-1,r=d.$flags|0,q=0;s>=0;--s){p=a[s]
o=B.b.cM(p,l)
r&2&&A.C(d)
d[s+n+1]=(o|q)>>>0
q=B.b.cL((p&k)>>>0,m)}r&2&&A.C(d)
d[n]=q},
xy(a,b,c,d){var s,r,q,p,o=B.b.V(c,16)
if(B.b.aR(c,16)===0)return A.vJ(a,b,o,d)
s=b+o+1
A.BL(a,b,c,d)
for(r=d.$flags|0,q=o;--q,q>=0;){r&2&&A.C(d)
d[q]=0}p=s-1
return d[p]===0?p:s},
BO(a,b,c,d){var s,r,q,p,o=B.b.V(c,16),n=B.b.aR(c,16),m=16-n,l=B.b.cL(1,n)-1,k=B.b.cM(a[o],n),j=b-o-1
for(s=d.$flags|0,r=0;r<j;++r){q=a[r+o+1]
p=B.b.cL((q&l)>>>0,m)
s&2&&A.C(d)
d[r]=(p|k)>>>0
k=B.b.cM(q,n)}s&2&&A.C(d)
d[j]=k},
qJ(a,b,c,d){var s,r=b-d
if(r===0)for(s=b-1;s>=0;--s){r=a[s]-c[s]
if(r!==0)return r}return r},
BJ(a,b,c,d,e){var s,r,q
for(s=e.$flags|0,r=0,q=0;q<d;++q){r+=a[q]+c[q]
s&2&&A.C(e)
e[q]=r&65535
r=B.b.a1(r,16)}for(q=d;q<b;++q){r+=a[q]
s&2&&A.C(e)
e[q]=r&65535
r=B.b.a1(r,16)}s&2&&A.C(e)
e[b]=r},
jL(a,b,c,d,e){var s,r,q
for(s=e.$flags|0,r=0,q=0;q<d;++q){r+=a[q]-c[q]
s&2&&A.C(e)
e[q]=r&65535
r=0-(B.b.a1(r,16)&1)}for(q=d;q<b;++q){r+=a[q]
s&2&&A.C(e)
e[q]=r&65535
r=0-(B.b.a1(r,16)&1)}},
xD(a,b,c,d,e,f){var s,r,q,p,o,n
if(a===0)return
for(s=d.$flags|0,r=0;--f,f>=0;e=o,c=q){q=c+1
p=a*b[c]+d[e]+r
o=e+1
s&2&&A.C(d)
d[e]=p&65535
r=B.b.V(p,65536)}for(;r!==0;e=o){n=d[e]+r
o=e+1
s&2&&A.C(d)
d[e]=n&65535
r=B.b.V(n,65536)}},
BK(a,b,c){var s,r=b[c]
if(r===a)return 65535
s=B.b.hz((r<<16|b[c-1])>>>0,a)
if(s>65535)return 65535
return s},
En(a){return A.kU(a)},
Ak(a){var s=!0
s=typeof a=="string"
if(s)A.wK(a)},
wK(a){throw A.b(A.aV(a,"object","Expandos are not allowed on strings, numbers, bools, records or null"))},
jY(a,b){var s=$.zq()
s=s==null?null:new s(A.cG(A.EX(a,b),1))
return new A.jX(s,b.h("jX<0>"))},
yR(a){var s=A.vs(a,null)
if(s!=null)return s
throw A.b(A.ak(a,null,null))},
Ai(a,b){a=A.ao(a,new Error())
a.stack=b.j(0)
throw a},
b1(a,b,c,d){var s,r=c?J.vk(a,d):J.vj(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
AL(a,b,c){var s,r=A.u([],c.h("t<0>"))
for(s=J.T(a);s.l();)r.push(s.gp())
r.$flags=1
return r},
as(a,b){var s,r
if(Array.isArray(a))return A.u(a.slice(0),b.h("t<0>"))
s=A.u([],b.h("t<0>"))
for(r=J.T(a);r.l();)s.push(r.gp())
return s},
nC(a,b){var s=A.AL(a,!1,b)
s.$flags=3
return s},
bL(a,b,c){var s,r,q,p,o
A.aH(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.b(A.ab(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.xd(b>0||c<o?p.slice(b,c):p)}if(t.Z.b(a))return A.Bi(a,b,c)
if(r)a=J.wu(a,c)
if(b>0)a=J.l2(a,b)
s=A.as(a,t.S)
return A.xd(s)},
Bi(a,b,c){var s=a.length
if(b>=s)return""
return A.AZ(a,b,c==null||c>s?s:c)},
at(a,b){return new A.fj(a,A.vm(a,!1,b,!1,!1,""))},
Em(a,b){return a==null?b==null:a===b},
vw(a,b,c){var s=J.T(b)
if(!s.l())return a
if(c.length===0){do a+=A.q(s.gp())
while(s.l())}else{a+=A.q(s.gp())
while(s.l())a=a+c+A.q(s.gp())}return a},
vB(){var s,r,q=A.AU()
if(q==null)throw A.b(A.Q("'Uri.base' is not supported"))
s=$.xv
if(s!=null&&q===$.xu)return s
r=A.de(q)
$.xv=r
$.xu=q
return r},
fH(){return A.O(new Error())},
mC(a){var s=B.b.aR(a,1000),r=B.b.V(a-s,1000)
if(r<-864e13||r>864e13)A.v(A.ab(r,-864e13,864e13,"millisecondsSinceEpoch",null))
if(r===864e13&&s!==0)A.v(A.aV(s,"microsecond","Time including microseconds is outside valid range"))
A.ba(!1,"isUtc",t.y)
return new A.bb(r,s,!1)},
Ad(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
wH(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
ie(a){if(a>=10)return""+a
return"0"+a},
mF(a,b){return new A.aX(a+1000*b)},
ih(a,b){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(q.b===b)return q}throw A.b(A.aV(b,"name","No enum value with that name"))},
ij(a){if(typeof a=="number"||A.kO(a)||a==null)return J.aU(a)
if(typeof a=="string")return JSON.stringify(a)
return A.xc(a)},
ik(a,b){A.ba(a,"error",t.K)
A.ba(b,"stackTrace",t.l)
A.Ai(a,b)},
hW(a){return new A.hV(a)},
K(a,b){return new A.a4(!1,null,b,a)},
aV(a,b,c){return new A.a4(!0,a,b,c)},
hR(a,b){return a},
ay(a){var s=null
return new A.e2(s,s,!1,s,s,a)},
o3(a,b){return new A.e2(null,null,!0,a,b,"Value not in range")},
ab(a,b,c,d,e){return new A.e2(b,c,!0,a,d,"Invalid value")},
xe(a,b,c,d){if(a<b||a>c)throw A.b(A.ab(a,b,c,d,null))
return a},
aL(a,b,c){if(0>a||a>c)throw A.b(A.ab(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.b(A.ab(b,a,c,"end",null))
return b}return c},
aH(a,b){if(a<0)throw A.b(A.ab(a,0,null,b,null))
return a},
wQ(a,b){var s=b.b
return new A.fg(s,!0,a,null,"Index out of range")},
it(a,b,c,d,e){return new A.fg(b,!0,a,e,"Index out of range")},
At(a,b,c,d,e){if(0>a||a>=b)throw A.b(A.it(a,b,c,d,e==null?"index":e))
return a},
Q(a){return new A.fP(a)},
vA(a){return new A.jq(a)},
D(a){return new A.b5(a)},
ap(a){return new A.i9(a)},
wJ(a){return new A.jW(a)},
ak(a,b,c){return new A.aR(a,b,c)},
Az(a,b,c){var s,r
if(A.we(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.u([],t.s)
$.dx.push(a)
try{A.Dg(a,s)}finally{$.dx.pop()}r=A.vw(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
nu(a,b,c){var s,r
if(A.we(a))return b+"..."+c
s=new A.X(b)
$.dx.push(a)
try{r=s
r.a=A.vw(r.a,a,", ")}finally{$.dx.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
Dg(a,b){var s,r,q,p,o,n,m,l=a.gA(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.l())return
s=A.q(l.gp())
b.push(s)
k+=s.length+2;++j}if(!l.l()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gp();++j
if(!l.l()){if(j<=4){b.push(A.q(p))
return}r=A.q(p)
q=b.pop()
k+=r.length+2}else{o=l.gp();++j
for(;l.l();p=o,o=n){n=l.gp();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
k-=b.pop().length+2;--j}b.push("...")
return}}q=A.q(p)
r=A.q(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)b.push(m)
b.push(q)
b.push(r)},
x0(a,b,c,d,e){return new A.cO(a,b.h("@<0>").H(c).H(d).H(e).h("cO<1,2,3,4>"))},
bG(a,b,c,d,e,f,g,h,i,j){var s
if(B.c===c)return A.xo(J.y(a),J.y(b),$.bT())
if(B.c===d){s=J.y(a)
b=J.y(b)
c=J.y(c)
return A.c2(A.E(A.E(A.E($.bT(),s),b),c))}if(B.c===e){s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
return A.c2(A.E(A.E(A.E(A.E($.bT(),s),b),c),d))}if(B.c===f){s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
e=J.y(e)
return A.c2(A.E(A.E(A.E(A.E(A.E($.bT(),s),b),c),d),e))}if(B.c===g){s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
e=J.y(e)
f=J.y(f)
return A.c2(A.E(A.E(A.E(A.E(A.E(A.E($.bT(),s),b),c),d),e),f))}if(B.c===h){s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
e=J.y(e)
f=J.y(f)
g=J.y(g)
return A.c2(A.E(A.E(A.E(A.E(A.E(A.E(A.E($.bT(),s),b),c),d),e),f),g))}if(B.c===i){s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
e=J.y(e)
f=J.y(f)
g=J.y(g)
h=J.y(h)
return A.c2(A.E(A.E(A.E(A.E(A.E(A.E(A.E(A.E($.bT(),s),b),c),d),e),f),g),h))}if(B.c===j){s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
e=J.y(e)
f=J.y(f)
g=J.y(g)
h=J.y(h)
i=J.y(i)
return A.c2(A.E(A.E(A.E(A.E(A.E(A.E(A.E(A.E(A.E($.bT(),s),b),c),d),e),f),g),h),i))}s=J.y(a)
b=J.y(b)
c=J.y(c)
d=J.y(d)
e=J.y(e)
f=J.y(f)
g=J.y(g)
h=J.y(h)
i=J.y(i)
j=J.y(j)
j=A.c2(A.E(A.E(A.E(A.E(A.E(A.E(A.E(A.E(A.E(A.E($.bT(),s),b),c),d),e),f),g),h),i),j))
return j},
AS(a){var s,r,q=$.bT()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)q=A.E(q,J.y(a[r]))
return A.c2(q)},
AT(a){var s,r,q,p,o
for(s=a.gA(a),r=0,q=0;s.l();){p=J.y(s.gp())
o=((p^p>>>16)>>>0)*569420461>>>0
o=((o^o>>>15)>>>0)*3545902487>>>0
r=r+((o^o>>>15)>>>0)&1073741823;++q}return A.xo(r,q,0)},
uZ(a){var s=A.q(a),r=$.Do
if(r==null)A.yY(s)
else r.$1(s)},
de(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=null,a4=a5.length
if(a4>=5){s=((a5.charCodeAt(4)^58)*3|a5.charCodeAt(0)^100|a5.charCodeAt(1)^97|a5.charCodeAt(2)^116|a5.charCodeAt(3)^97)>>>0
if(s===0)return A.xt(a4<a4?B.a.t(a5,0,a4):a5,5,a3).gjM()
else if(s===32)return A.xt(B.a.t(a5,5,a4),0,a3).gjM()}r=A.b1(8,0,!1,t.S)
r[0]=0
r[1]=-1
r[2]=-1
r[7]=-1
r[3]=0
r[4]=0
r[5]=a4
r[6]=a4
if(A.yB(a5,0,a4,0,r)>=14)r[7]=a4
q=r[1]
if(q>=0)if(A.yB(a5,0,q,20,r)===20)r[7]=q
p=r[2]+1
o=r[3]
n=r[4]
m=r[5]
l=r[6]
if(l<m)m=l
if(n<p)n=m
else if(n<=q)n=q+1
if(o<p)o=n
k=r[7]<0
j=a3
if(k){k=!1
if(!(p>q+3)){i=o>0
if(!(i&&o+1===n)){if(!B.a.P(a5,"\\",n))if(p>0)h=B.a.P(a5,"\\",p-1)||B.a.P(a5,"\\",p-2)
else h=!1
else h=!0
if(!h){if(!(m<a4&&m===n+2&&B.a.P(a5,"..",n)))h=m>n+2&&B.a.P(a5,"/..",m-3)
else h=!0
if(!h)if(q===4){if(B.a.P(a5,"file",0)){if(p<=0){if(!B.a.P(a5,"/",n)){g="file:///"
s=3}else{g="file://"
s=2}a5=g+B.a.t(a5,n,a4)
m+=s
l+=s
a4=a5.length
p=7
o=7
n=7}else if(n===m){++l
f=m+1
a5=B.a.c5(a5,n,m,"/");++a4
m=f}j="file"}else if(B.a.P(a5,"http",0)){if(i&&o+3===n&&B.a.P(a5,"80",o+1)){l-=3
e=n-3
m-=3
a5=B.a.c5(a5,o,n,"")
a4-=3
n=e}j="http"}}else if(q===5&&B.a.P(a5,"https",0)){if(i&&o+4===n&&B.a.P(a5,"443",o+1)){l-=4
e=n-4
m-=4
a5=B.a.c5(a5,o,n,"")
a4-=3
n=e}j="https"}k=!h}}}}if(k)return new A.bk(a4<a5.length?B.a.t(a5,0,a4):a5,q,p,o,n,m,l,j)
if(j==null)if(q>0)j=A.vR(a5,0,q)
else{if(q===0)A.eF(a5,0,"Invalid empty scheme")
j=""}d=a3
if(p>0){c=q+3
b=c<p?A.y4(a5,c,p-1):""
a=A.y1(a5,p,o,!1)
i=o+1
if(i<n){a0=A.vs(B.a.t(a5,i,n),a3)
d=A.tB(a0==null?A.v(A.ak("Invalid port",a5,i)):a0,j)}}else{a=a3
b=""}a1=A.y2(a5,n,m,a3,j,a!=null)
a2=m<l?A.y3(a5,m+1,l,a3):a3
return A.hD(j,b,a,d,a1,a2,l<a4?A.y0(a5,l+1,a4):a3)},
Bw(a){return A.vU(a,0,a.length,B.k,!1)},
jx(a,b,c){throw A.b(A.ak("Illegal IPv4 address, "+a,b,c))},
Bt(a,b,c,d,e){var s,r,q,p,o,n,m,l,k="invalid character"
for(s=d.$flags|0,r=b,q=r,p=0,o=0;;){n=q>=c?0:a.charCodeAt(q)
m=n^48
if(m<=9){if(o!==0||q===r){o=o*10+m
if(o<=255){++q
continue}A.jx("each part must be in the range 0..255",a,r)}A.jx("parts must not have leading zeros",a,r)}if(q===r){if(q===c)break
A.jx(k,a,q)}l=p+1
s&2&&A.C(d)
d[e+p]=o
if(n===46){if(l<4){++q
p=l
r=q
o=0
continue}break}if(q===c){if(l===4)return
break}A.jx(k,a,q)
p=l}A.jx("IPv4 address should contain exactly 4 parts",a,q)},
Bu(a,b,c){var s
if(b===c)throw A.b(A.ak("Empty IP address",a,b))
if(a.charCodeAt(b)===118){s=A.Bv(a,b,c)
if(s!=null)throw A.b(s)
return!1}A.xw(a,b,c)
return!0},
Bv(a,b,c){var s,r,q,p,o="Missing hex-digit in IPvFuture address";++b
for(s=b;;s=r){if(s<c){r=s+1
q=a.charCodeAt(s)
if((q^48)<=9)continue
p=q|32
if(p>=97&&p<=102)continue
if(q===46){if(r-1===b)return new A.aR(o,a,r)
s=r
break}return new A.aR("Unexpected character",a,r-1)}if(s-1===b)return new A.aR(o,a,s)
return new A.aR("Missing '.' in IPvFuture address",a,s)}if(s===c)return new A.aR("Missing address in IPvFuture address, host, cursor",null,null)
for(;;){if((u.S.charCodeAt(a.charCodeAt(s))&16)!==0){++s
if(s<c)continue
return null}return new A.aR("Invalid IPvFuture address character",a,s)}},
xw(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a="an address must contain at most 8 parts",a0=new A.pF(a1)
if(a3-a2<2)a0.$2("address is too short",null)
s=new Uint8Array(16)
r=-1
q=0
if(a1.charCodeAt(a2)===58)if(a1.charCodeAt(a2+1)===58){p=a2+2
o=p
r=0
q=1}else{a0.$2("invalid start colon",a2)
p=a2
o=p}else{p=a2
o=p}for(n=0,m=!0;;){l=p>=a3?0:a1.charCodeAt(p)
A:{k=l^48
j=!1
if(k<=9)i=k
else{h=l|32
if(h>=97&&h<=102)i=h-87
else break A
m=j}if(p<o+4){n=n*16+i;++p
continue}a0.$2("an IPv6 part can contain a maximum of 4 hex digits",o)}if(p>o){if(l===46){if(m){if(q<=6){A.Bt(a1,o,a3,s,q*2)
q+=2
p=a3
break}a0.$2(a,o)}break}g=q*2
s[g]=B.b.a1(n,8)
s[g+1]=n&255;++q
if(l===58){if(q<8){++p
o=p
n=0
m=!0
continue}a0.$2(a,p)}break}if(l===58){if(r<0){f=q+1;++p
r=q
q=f
o=p
continue}a0.$2("only one wildcard `::` is allowed",p)}if(r!==q-1)a0.$2("missing part",p)
break}if(p<a3)a0.$2("invalid character",p)
if(q<8){if(r<0)a0.$2("an address without a wildcard must contain exactly 8 parts",a3)
e=r+1
d=q-e
if(d>0){c=e*2
b=16-d*2
B.f.O(s,b,16,s,c)
B.f.fR(s,c,b,0)}}return s},
hD(a,b,c,d,e,f,g){return new A.hC(a,b,c,d,e,f,g)},
xY(a){if(a==="http")return 80
if(a==="https")return 443
return 0},
eF(a,b,c){throw A.b(A.ak(c,a,b))},
Cv(a,b){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(B.a.S(q,"/")){s=A.Q("Illegal path character "+q)
throw A.b(s)}}},
tB(a,b){if(a!=null&&a===A.xY(b))return null
return a},
y1(a,b,c,d){var s,r,q,p,o,n,m,l
if(a==null)return null
if(b===c)return""
if(a.charCodeAt(b)===91){s=c-1
if(a.charCodeAt(s)!==93)A.eF(a,b,"Missing end `]` to match `[` in host")
r=b+1
q=""
if(a.charCodeAt(r)!==118){p=A.Cw(a,r,s)
if(p<s){o=p+1
q=A.y7(a,B.a.P(a,"25",o)?p+3:o,s,"%25")}s=p}n=A.Bu(a,r,s)
m=B.a.t(a,r,s)
return"["+(n?m.toLowerCase():m)+q+"]"}for(l=b;l<c;++l)if(a.charCodeAt(l)===58){s=B.a.bl(a,"%",b)
s=s>=b&&s<c?s:c
if(s<c){o=s+1
q=A.y7(a,B.a.P(a,"25",o)?s+3:o,c,"%25")}else q=""
A.xw(a,b,s)
return"["+B.a.t(a,b,s)+q+"]"}return A.Cz(a,b,c)},
Cw(a,b,c){var s=B.a.bl(a,"%",b)
return s>=b&&s<c?s:c},
y7(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i=d!==""?new A.X(d):null
for(s=b,r=s,q=!0;s<c;){p=a.charCodeAt(s)
if(p===37){o=A.vS(a,s,!0)
n=o==null
if(n&&q){s+=3
continue}if(i==null)i=new A.X("")
m=i.a+=B.a.t(a,r,s)
if(n)o=B.a.t(a,s,s+3)
else if(o==="%")A.eF(a,s,"ZoneID should not contain % anymore")
i.a=m+o
s+=3
r=s
q=!0}else if(p<127&&(u.S.charCodeAt(p)&1)!==0){if(q&&65<=p&&90>=p){if(i==null)i=new A.X("")
if(r<s){i.a+=B.a.t(a,r,s)
r=s}q=!1}++s}else{l=1
if((p&64512)===55296&&s+1<c){k=a.charCodeAt(s+1)
if((k&64512)===56320){p=65536+((p&1023)<<10)+(k&1023)
l=2}}j=B.a.t(a,r,s)
if(i==null){i=new A.X("")
n=i}else n=i
n.a+=j
m=A.vQ(p)
n.a+=m
s+=l
r=s}}if(i==null)return B.a.t(a,b,c)
if(r<c){j=B.a.t(a,r,c)
i.a+=j}n=i.a
return n.charCodeAt(0)==0?n:n},
Cz(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=u.S
for(s=b,r=s,q=null,p=!0;s<c;){o=a.charCodeAt(s)
if(o===37){n=A.vS(a,s,!0)
m=n==null
if(m&&p){s+=3
continue}if(q==null)q=new A.X("")
l=B.a.t(a,r,s)
if(!p)l=l.toLowerCase()
k=q.a+=l
j=3
if(m)n=B.a.t(a,s,s+3)
else if(n==="%"){n="%25"
j=1}q.a=k+n
s+=j
r=s
p=!0}else if(o<127&&(h.charCodeAt(o)&32)!==0){if(p&&65<=o&&90>=o){if(q==null)q=new A.X("")
if(r<s){q.a+=B.a.t(a,r,s)
r=s}p=!1}++s}else if(o<=93&&(h.charCodeAt(o)&1024)!==0)A.eF(a,s,"Invalid character")
else{j=1
if((o&64512)===55296&&s+1<c){i=a.charCodeAt(s+1)
if((i&64512)===56320){o=65536+((o&1023)<<10)+(i&1023)
j=2}}l=B.a.t(a,r,s)
if(!p)l=l.toLowerCase()
if(q==null){q=new A.X("")
m=q}else m=q
m.a+=l
k=A.vQ(o)
m.a+=k
s+=j
r=s}}if(q==null)return B.a.t(a,b,c)
if(r<c){l=B.a.t(a,r,c)
if(!p)l=l.toLowerCase()
q.a+=l}m=q.a
return m.charCodeAt(0)==0?m:m},
vR(a,b,c){var s,r,q
if(b===c)return""
if(!A.y_(a.charCodeAt(b)))A.eF(a,b,"Scheme not starting with alphabetic character")
for(s=b,r=!1;s<c;++s){q=a.charCodeAt(s)
if(!(q<128&&(u.S.charCodeAt(q)&8)!==0))A.eF(a,s,"Illegal scheme character")
if(65<=q&&q<=90)r=!0}a=B.a.t(a,b,c)
return A.Cu(r?a.toLowerCase():a)},
Cu(a){if(a==="http")return"http"
if(a==="file")return"file"
if(a==="https")return"https"
if(a==="package")return"package"
return a},
y4(a,b,c){if(a==null)return""
return A.hE(a,b,c,16,!1,!1)},
y2(a,b,c,d,e,f){var s,r=e==="file",q=r||f
if(a==null)return r?"/":""
else s=A.hE(a,b,c,128,!0,!0)
if(s.length===0){if(r)return"/"}else if(q&&!B.a.K(s,"/"))s="/"+s
return A.Cy(s,e,f)},
Cy(a,b,c){var s=b.length===0
if(s&&!c&&!B.a.K(a,"/")&&!B.a.K(a,"\\"))return A.vT(a,!s||c)
return A.du(a)},
y3(a,b,c,d){if(a!=null)return A.hE(a,b,c,256,!0,!1)
return null},
y0(a,b,c){if(a==null)return null
return A.hE(a,b,c,256,!0,!1)},
vS(a,b,c){var s,r,q,p,o,n=b+2
if(n>=a.length)return"%"
s=a.charCodeAt(b+1)
r=a.charCodeAt(n)
q=A.uE(s)
p=A.uE(r)
if(q<0||p<0)return"%"
o=q*16+p
if(o<127&&(u.S.charCodeAt(o)&1)!==0)return A.aP(c&&65<=o&&90>=o?(o|32)>>>0:o)
if(s>=97||r>=97)return B.a.t(a,b,b+3).toUpperCase()
return null},
vQ(a){var s,r,q,p,o,n="0123456789ABCDEF"
if(a<=127){s=new Uint8Array(3)
s[0]=37
s[1]=n.charCodeAt(a>>>4)
s[2]=n.charCodeAt(a&15)}else{if(a>2047)if(a>65535){r=240
q=4}else{r=224
q=3}else{r=192
q=2}s=new Uint8Array(3*q)
for(p=0;--q,q>=0;r=128){o=B.b.mq(a,6*q)&63|r
s[p]=37
s[p+1]=n.charCodeAt(o>>>4)
s[p+2]=n.charCodeAt(o&15)
p+=3}}return A.bL(s,0,null)},
hE(a,b,c,d,e,f){var s=A.y6(a,b,c,d,e,f)
return s==null?B.a.t(a,b,c):s},
y6(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=null,i=u.S
for(s=!e,r=b,q=r,p=j;r<c;){o=a.charCodeAt(r)
if(o<127&&(i.charCodeAt(o)&d)!==0)++r
else{n=1
if(o===37){m=A.vS(a,r,!1)
if(m==null){r+=3
continue}if("%"===m)m="%25"
else n=3}else if(o===92&&f)m="/"
else if(s&&o<=93&&(i.charCodeAt(o)&1024)!==0){A.eF(a,r,"Invalid character")
n=j
m=n}else{if((o&64512)===55296){l=r+1
if(l<c){k=a.charCodeAt(l)
if((k&64512)===56320){o=65536+((o&1023)<<10)+(k&1023)
n=2}}}m=A.vQ(o)}if(p==null){p=new A.X("")
l=p}else l=p
l.a=(l.a+=B.a.t(a,q,r))+m
r+=n
q=r}}if(p==null)return j
if(q<c){s=B.a.t(a,q,c)
p.a+=s}s=p.a
return s.charCodeAt(0)==0?s:s},
y5(a){if(B.a.K(a,"."))return!0
return B.a.cw(a,"/.")!==-1},
du(a){var s,r,q,p,o,n
if(!A.y5(a))return a
s=A.u([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(n===".."){if(s.length!==0){s.pop()
if(s.length===0)s.push("")}p=!0}else{p="."===n
if(!p)s.push(n)}}if(p)s.push("")
return B.d.bH(s,"/")},
vT(a,b){var s,r,q,p,o,n
if(!A.y5(a))return!b?A.xZ(a):a
s=A.u([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(".."===n){if(s.length!==0&&B.d.gaO(s)!=="..")s.pop()
else s.push("..")
p=!0}else{p="."===n
if(!p)s.push(n.length===0&&s.length===0?"./":n)}}if(s.length===0)return"./"
if(p)s.push("")
if(!b)s[0]=A.xZ(s[0])
return B.d.bH(s,"/")},
xZ(a){var s,r,q=a.length
if(q>=2&&A.y_(a.charCodeAt(0)))for(s=1;s<q;++s){r=a.charCodeAt(s)
if(r===58)return B.a.t(a,0,s)+"%3A"+B.a.a0(a,s+1)
if(r>127||(u.S.charCodeAt(r)&8)===0)break}return a},
CA(a,b){if(a.eg("package")&&a.c==null)return A.yD(b,0,b.length)
return-1},
Cx(a,b){var s,r,q
for(s=0,r=0;r<2;++r){q=a.charCodeAt(b+r)
if(48<=q&&q<=57)s=s*16+q-48
else{q|=32
if(97<=q&&q<=102)s=s*16+q-87
else throw A.b(A.K("Invalid URL encoding",null))}}return s},
vU(a,b,c,d,e){var s,r,q,p,o=b
for(;;){if(!(o<c)){s=!0
break}r=a.charCodeAt(o)
if(r<=127)q=r===37
else q=!0
if(q){s=!1
break}++o}if(s)if(B.k===d)return B.a.t(a,b,c)
else p=new A.bq(B.a.t(a,b,c))
else{p=A.u([],t.t)
for(q=a.length,o=b;o<c;++o){r=a.charCodeAt(o)
if(r>127)throw A.b(A.K("Illegal percent encoding in URI",null))
if(r===37){if(o+3>q)throw A.b(A.K("Truncated URI",null))
p.push(A.Cx(a,o+1))
o+=2}else p.push(r)}}return d.aF(p)},
y_(a){var s=a|32
return 97<=s&&s<=122},
xt(a,b,c){var s,r,q,p,o,n,m,l,k="Invalid MIME type",j=A.u([b-1],t.t)
for(s=a.length,r=b,q=-1,p=null;r<s;++r){p=a.charCodeAt(r)
if(p===44||p===59)break
if(p===47){if(q<0){q=r
continue}throw A.b(A.ak(k,a,r))}}if(q<0&&r>b)throw A.b(A.ak(k,a,r))
while(p!==44){j.push(r);++r
for(o=-1;r<s;++r){p=a.charCodeAt(r)
if(p===61){if(o<0)o=r}else if(p===59||p===44)break}if(o>=0)j.push(o)
else{n=B.d.gaO(j)
if(p!==44||r!==n+7||!B.a.P(a,"base64",n+1))throw A.b(A.ak("Expecting '='",a,r))
break}}j.push(r)
m=r+1
if((j.length&1)===1)a=B.ay.ov(a,m,s)
else{l=A.y6(a,m,s,256,!0,!1)
if(l!=null)a=B.a.c5(a,m,s,l)}return new A.pE(a,j,c)},
yB(a,b,c,d,e){var s,r,q
for(s=b;s<c;++s){r=a.charCodeAt(s)^96
if(r>95)r=31
q='\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe3\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x0e\x03\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xea\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\n\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\xeb\xeb\x8b\xeb\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\x83\xeb\xeb\x8b\xeb\x8b\xeb\xcd\x8b\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x92\x83\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\x8b\xeb\x8b\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xebD\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x12D\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\xe5\xe5\xe5\x05\xe5D\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe8\x8a\xe5\xe5\x05\xe5\x05\xe5\xcd\x05\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x8a\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05f\x05\xe5\x05\xe5\xac\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\xe5\xe5\xe5\x05\xe5D\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\x8a\xe5\xe5\x05\xe5\x05\xe5\xcd\x05\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x8a\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05f\x05\xe5\x05\xe5\xac\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7D\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\xe7\xe7\xe7\xe7\xe7\xcd\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\x07\x07\x07\x07\x07\x07\x07\x07\x07\xe7\xe7\xe7\xe7\xe7\xac\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7D\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\xe7\xe7\xe7\xe7\xe7\xcd\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\x07\x07\x07\x07\x07\x07\x07\x07\x07\x07\xe7\xe7\xe7\xe7\xe7\xac\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\x05\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x10\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x12\n\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\n\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xec\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\xec\xec\xec\f\xec\xec\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\xec\xec\xec\xec\f\xec\f\xec\xcd\f\xec\f\f\f\f\f\f\f\f\f\xec\f\f\f\f\f\f\f\f\f\f\xec\f\xec\f\xec\f\xed\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\xed\xed\xed\r\xed\xed\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\xed\xed\xed\xed\r\xed\r\xed\xed\r\xed\r\r\r\r\r\r\r\r\r\xed\r\r\r\r\r\r\r\r\r\r\xed\r\xed\r\xed\r\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xea\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x0f\xea\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe9\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x11\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xe9\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\t\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x13\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\x15\xf5\x15\x15\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5'.charCodeAt(d*96+r)
d=q&31
e[q>>>5]=s}return d},
xQ(a){if(a.b===7&&B.a.K(a.a,"package")&&a.c<=0)return A.yD(a.a,a.e,a.f)
return-1},
yD(a,b,c){var s,r,q
for(s=b,r=0;s<c;++s){q=a.charCodeAt(s)
if(q===47)return r!==0?s:-1
if(q===37||q===58)return-1
r|=q^46}return-1},
yg(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=0,q=0;q<s;++q){p=b.charCodeAt(c+q)
o=a.charCodeAt(q)^p
if(o!==0){if(o===32){n=p|o
if(97<=n&&n<=122){r=32
continue}}return-1}}return r},
az:function az(a,b,c){this.a=a
this.b=b
this.c=c},
qK:function qK(){},
qL:function qL(){},
jX:function jX(a,b){this.a=a
this.$ti=b},
bb:function bb(a,b,c){this.a=a
this.b=b
this.c=c},
aX:function aX(a){this.a=a},
rj:function rj(){},
V:function V(){},
hV:function hV(a){this.a=a},
c3:function c3(){},
a4:function a4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
e2:function e2(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fg:function fg(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
fP:function fP(a){this.a=a},
jq:function jq(a){this.a=a},
b5:function b5(a){this.a=a},
i9:function i9(a){this.a=a},
iV:function iV(){},
fG:function fG(){},
jW:function jW(a){this.a=a},
aR:function aR(a,b,c){this.a=a
this.b=b
this.c=c},
iv:function iv(){},
n:function n(){},
M:function M(a,b,c){this.a=a
this.b=b
this.$ti=c},
F:function F(){},
k:function k(){},
kv:function kv(){},
X:function X(a){this.a=a},
pF:function pF(a){this.a=a},
hC:function hC(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.y=_.x=_.w=$},
pE:function pE(a,b,c){this.a=a
this.b=b
this.c=c},
bk:function bk(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=null},
jT:function jT(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.y=_.x=_.w=$},
im:function im(a){this.a=a},
yi(a,b,c,d){if(a)return""+d+"-"+c+"-begin"
if(b)return""+d+"-"+c+"-end"
return c},
yt(a){var s=$.eI.i(0,a)
if(s==null)return a
return a+"-"+A.q(s)},
CR(a){var s,r
if(!$.eI.G(a))return
s=$.eI.i(0,a)
s.toString
r=s-1
s=$.eI
if(r<=0)s.I(0,a)
else s.m(0,a,r)},
FR(a,b,c,d,e){var s,r,q,p,o,n
if(c===9||c===11||c===10)return
if($.eK>1e4&&$.eI.a===0){$.kZ().clearMarks()
$.kZ().clearMeasures()
$.eK=0}s=c===1||c===5
r=c===2||c===7
q=A.yi(s,r,d,a)
if(s){p=$.eI.i(0,q)
if(p==null)p=0
$.eI.m(0,q,p+1)
q=A.yt(q)}o=$.kZ()
o.toString
o.mark(q,$.zy().parse(e))
$.eK=$.eK+1
if(r){n=A.yi(!0,!1,d,a)
o=$.kZ()
o.toString
o.measure(d,A.yt(n),q)
$.eK=$.eK+1
A.CR(n)}B.b.mY($.eK,0,10001)},
FE(a){if(a==null||a.a===0)return"{}"
return B.h.bi(a)},
u7:function u7(){},
u5:function u5(){},
vE:function vE(a,b){this.a=a
this.b=b},
yQ(){return v.G},
AK(a){return a},
AC(a){return a},
AE(a){return a},
vx(a){return a},
wN(a){return new v.G.Promise(A.b7(new A.mQ(a)))},
iT:function iT(a){this.a=a},
mQ:function mQ(a){this.a=a},
mO:function mO(a){this.a=a},
mP:function mP(a){this.a=a},
u4(a){var s
if(typeof a=="function")throw A.b(A.K("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(){return b(c)}}(A.CI,a)
s[$.dC()]=a
return s},
bB(a){var s
if(typeof a=="function")throw A.b(A.K("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.CJ,a)
s[$.dC()]=a
return s},
b7(a){var s
if(typeof a=="function")throw A.b(A.K("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e){return b(c,d,e,arguments.length)}}(A.CK,a)
s[$.dC()]=a
return s},
kN(a){var s
if(typeof a=="function")throw A.b(A.K("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f){return b(c,d,e,f,arguments.length)}}(A.CL,a)
s[$.dC()]=a
return s},
eJ(a){var s
if(typeof a=="function")throw A.b(A.K("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f,g){return b(c,d,e,f,g,arguments.length)}}(A.CM,a)
s[$.dC()]=a
return s},
w1(a){var s
if(typeof a=="function")throw A.b(A.K("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f,g,h){return b(c,d,e,f,g,h,arguments.length)}}(A.CN,a)
s[$.dC()]=a
return s},
CI(a){return a.$0()},
CJ(a,b,c){if(c>=1)return a.$1(b)
return a.$0()},
CK(a,b,c,d){if(d>=2)return a.$2(b,c)
if(d===1)return a.$1(b)
return a.$0()},
CL(a,b,c,d,e){if(e>=3)return a.$3(b,c,d)
if(e===2)return a.$2(b,c)
if(e===1)return a.$1(b)
return a.$0()},
CM(a,b,c,d,e,f){if(f>=4)return a.$4(b,c,d,e)
if(f===3)return a.$3(b,c,d)
if(f===2)return a.$2(b,c)
if(f===1)return a.$1(b)
return a.$0()},
CN(a,b,c,d,e,f,g){if(g>=5)return a.$5(b,c,d,e,f)
if(g===4)return a.$4(b,c,d,e)
if(g===3)return a.$3(b,c,d)
if(g===2)return a.$2(b,c)
if(g===1)return a.$1(b)
return a.$0()},
yq(a){return a==null||A.kO(a)||typeof a=="number"||typeof a=="string"||t.jx.b(a)||t.p.b(a)||t.nn.b(a)||t.m6.b(a)||t.i7.b(a)||t.bW.b(a)||t.mC.b(a)||t.pk.b(a)||t.kI.b(a)||t.lo.b(a)||t.fW.b(a)},
Ey(a){if(A.yq(a))return a
return new A.uJ(new A.dp(t.mp)).$1(a)},
uC(a,b){return a[b]},
yK(a,b,c){return a[b].apply(a,c)},
E2(a,b){var s,r
if(b==null)return new a()
if(b instanceof Array)switch(b.length){case 0:return new a()
case 1:return new a(b[0])
case 2:return new a(b[0],b[1])
case 3:return new a(b[0],b[1],b[2])
case 4:return new a(b[0],b[1],b[2],b[3])}s=[null]
B.d.ab(s,b)
r=a.bind.apply(a,s)
String(r)
return new r()},
aq(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.ad(s,b.h("ad<0>"))
a.then(A.cG(new A.v_(r),1),A.cG(new A.v0(r),1))
return s},
uJ:function uJ(a){this.a=a},
v_:function v_(a){this.a=a},
v0:function v0(a){this.a=a},
yU(a,b){return Math.max(a,b)},
B_(){return B.aQ},
rQ:function rQ(){},
rR:function rR(a){this.a=a},
ii:function ii(a,b){this.a=a
this.b=b},
fT:function fT(a){this.a=a},
fI:function fI(a,b,c){var _=this
_.a=$
_.b=!1
_.c=a
_.e=b
_.$ti=c},
oz:function oz(){},
oA:function oA(a,b){this.a=a
this.b=b},
oy:function oy(){},
ox:function ox(a){this.a=a},
ow:function ow(a,b){this.a=a
this.b=b},
eB:function eB(a){this.a=a},
U:function U(){},
lw:function lw(a){this.a=a},
lx:function lx(a){this.a=a},
ly:function ly(a,b){this.a=a
this.b=b},
lz:function lz(a){this.a=a},
lA:function lA(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
f6:function f6(){},
iJ:function iJ(a){this.$ti=a},
eE:function eE(){},
d5:function d5(a){this.$ti=a},
ew:function ew(a,b,c){this.a=a
this.b=b
this.c=c},
dW:function dW(a){this.$ti=a},
x2(){throw A.b(A.Q(u.O))},
Bp(){throw A.b(A.Q("Cannot modify an unmodifiable Map"))},
iR:function iR(){},
jt:function jt(){},
Fb(a){return new A.cq("Request aborted by `abortTrigger`",a)},
l5:function l5(){},
cq:function cq(a,b){this.a=a
this.b=b},
hZ:function hZ(){},
i_:function i_(){},
li:function li(){},
lj:function lj(){},
lk:function lk(){},
yF(a,b){var s
if(t.m.b(a)&&"AbortError"===a.name)return new A.cq("Request aborted by `abortTrigger`",b.b)
if(!(a instanceof A.bU)){s=J.aU(a)
if(B.a.K(s,"TypeError: "))s=B.a.a0(s,11)
a=new A.bU(s,b.b)}return a},
yv(a,b,c){A.ik(A.yF(a,c),b)},
CH(a,b){return new A.bA(!1,new A.tW(a,b),t.fb)},
eM(a,b,c){return A.Dq(a,b,c)},
Dq(a,a0,a1){var s=0,r=A.i(t.H),q,p=2,o=[],n,m,l,k,j,i,h,g,f,e,d,c,b
var $async$eM=A.d(function(a2,a3){if(a2===1){o.push(a3)
s=p}for(;;)switch(s){case 0:e={}
d=a0.body
c=d==null?null:d.getReader()
s=c==null?3:4
break
case 3:s=5
return A.c(a1.n(),$async$eM)
case 5:s=1
break
case 4:e.a=null
e.b=e.c=!1
a1.f=new A.u8(e)
a1.r=new A.u9(e,c,a)
d=t.Z,k=t.m,j=t.D,i=t.h
case 6:n=null
p=9
s=12
return A.c(A.aq(c.read(),k),$async$eM)
case 12:n=a3
p=2
s=11
break
case 9:p=8
b=o.pop()
m=A.H(b)
l=A.O(b)
s=!e.c?13:14
break
case 13:e.b=!0
d=A.yF(m,a)
k=l
j=a1.b
if(j>=4)A.v(a1.al())
if((j&1)!==0){j=a1.ga5()
j.a8(d,k==null?B.r:k)}s=15
return A.c(a1.n(),$async$eM)
case 15:case 14:s=7
break
s=11
break
case 8:s=2
break
case 11:if(n.done){a1.j3()
s=7
break}else{g=n.value
g.toString
d.a(g)
f=a1.b
if(f>=4)A.v(a1.al())
if((f&1)!==0)a1.ga5().M(g)}g=a1.b
s=((g&1)!==0?(a1.ga5().e&4)!==0:(g&2)===0)?16:17
break
case 16:g=e.a
s=18
return A.c((g==null?e.a=new A.ad(new A.l($.m,j),i):g).a,$async$eM)
case 18:case 17:if((a1.b&1)===0){s=7
break}s=6
break
case 7:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$eM,r)},
i2:function i2(a){this.b=!1
this.c=a},
ll:function ll(a){this.a=a},
lm:function lm(a){this.a=a},
tW:function tW(a,b){this.a=a
this.b=b},
u8:function u8(a){this.a=a},
u9:function u9(a,b,c){this.a=a
this.b=b
this.c=c},
cM:function cM(a){this.a=a},
lv:function lv(a){this.a=a},
wE(a,b){return new A.bU(a,b)},
bU:function bU(a,b){this.a=a
this.b=b},
va(a,b,c){var s=new Uint8Array(0),r=$.z9()
if(!r.b.test(a))A.v(A.aV(a,"method","Not a valid method"))
r=t.N
return new A.hQ(c,s,a,b,A.vp(new A.li(),new A.lj(),r,r))},
of:function of(){},
hQ:function hQ(a,b,c,d,e){var _=this
_.cx=a
_.y=b
_.a=c
_.b=d
_.r=e
_.w=!1},
jF:function jF(){},
j4(a){var s=0,r=A.i(t.Y),q,p,o,n,m,l,k,j
var $async$j4=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(a.w.he(),$async$j4)
case 3:p=c
o=a.b
n=a.a
m=a.e
l=a.c
k=A.z6(p)
j=p.length
k=new A.e4(k,n,o,l,j,m,!1,!0)
k.eO(o,j,m,!1,!0,l,n)
q=k
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$j4,r)},
vX(a){var s=a.i(0,"content-type")
if(s!=null)return A.x1(s)
return A.nH("application","octet-stream",null)},
e4:function e4(a,b,c,d,e,f,g,h){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h},
Bh(a,b,c,d,e,f,g,h){var s=new A.ct(A.z5(a),h,b,g,c,d,!1,!0)
s.eO(b,c,d,!1,!0,g,h)
return s},
ct:function ct(a,b,c,d,e,f,g,h){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h},
jk:function jk(a,b,c,d,e,f,g,h){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h},
zW(a){return a.toLowerCase()},
eX:function eX(a,b,c){this.a=a
this.c=b
this.$ti=c},
x1(a){return A.EV("media type",a,new A.nI(a))},
nH(a,b,c){var s=t.N
if(c==null)s=A.Z(s,s)
else{s=new A.eX(A.E3(),A.Z(s,t.gc),t.kj)
s.ab(0,c)}return new A.fs(a.toLowerCase(),b.toLowerCase(),new A.dd(s,t.oP))},
fs:function fs(a,b,c){this.a=a
this.b=b
this.c=c},
nI:function nI(a){this.a=a},
nK:function nK(a){this.a=a},
nJ:function nJ(){},
Eg(a){var s
a.je($.zB(),"quoted string")
s=a.gh1().i(0,0)
return A.z2(B.a.t(s,1,s.length-1),$.zA(),new A.ux(),null)},
ux:function ux(){},
cn:function cn(a,b){this.a=a
this.b=b},
dU:function dU(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.d=c
_.e=d
_.r=e
_.w=f},
vr(a){return $.AM.cD(a,new A.nD(a))},
x_(a,b,c){var s=new A.dV(a,b,c)
if(b==null)s.c=B.l
else b.d.m(0,a,s)
return s},
dV:function dV(a,b,c){var _=this
_.a=a
_.b=b
_.c=null
_.d=c
_.f=null},
nD:function nD(a){this.a=a},
ys(a){return a},
yG(a,b){var s,r,q,p,o,n,m,l
for(s=b.length,r=1;r<s;++r){if(b[r]==null||b[r-1]!=null)continue
for(;s>=1;s=q){q=s-1
if(b[q]!=null)break}p=new A.X("")
o=a+"("
p.a=o
n=A.a8(b)
m=n.h("d8<1>")
l=new A.d8(b,0,s,m)
l.kT(b,0,s,n.c)
m=o+new A.aa(l,new A.up(),m.h("aa<W.E,j>")).bH(0,", ")
p.a=m
p.a=m+("): part "+(r-1)+" was null, but part "+r+" was not.")
throw A.b(A.K(p.j(0),null))}},
lY:function lY(a){this.a=a},
lZ:function lZ(){},
m_:function m_(){},
up:function up(){},
nr:function nr(){},
iW(a,b){var s,r,q,p,o,n=b.kq(a)
b.bG(a)
if(n!=null)a=B.a.a0(a,n.length)
s=t.s
r=A.u([],s)
q=A.u([],s)
s=a.length
if(s!==0&&b.bm(a.charCodeAt(0))){q.push(a[0])
p=1}else{q.push("")
p=0}for(o=p;o<s;++o)if(b.bm(a.charCodeAt(o))){r.push(B.a.t(a,p,o))
q.push(a[o])
p=o+1}if(p<s){r.push(B.a.a0(a,p))
q.push("")}return new A.nQ(b,n,r,q)},
nQ:function nQ(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
x3(a){return new A.iX(a)},
iX:function iX(a){this.a=a},
Bj(){var s,r,q,p,o,n,m,l,k=null
if(A.vB().gaw()!=="file")return $.hM()
if(!B.a.bE(A.vB().gaP(),"/"))return $.hM()
s=A.y4(k,0,0)
r=A.y1(k,0,0,!1)
q=A.y3(k,0,0,k)
p=A.y0(k,0,0)
o=A.tB(k,"")
if(r==null)if(s.length===0)n=o!=null
else n=!0
else n=!1
if(n)r=""
n=r==null
m=!n
l=A.y2("a/b",0,3,k,"",m)
if(n&&!B.a.K(l,"/"))l=A.vT(l,m)
else l=A.du(l)
if(A.hD("",s,n&&B.a.K(l,"//")?"":r,o,l,q,p).hf()==="a\\b")return $.kX()
return $.zd()},
p3:function p3(){},
nR:function nR(a,b,c){this.d=a
this.e=b
this.f=c},
pG:function pG(a,b,c,d){var _=this
_.d=a
_.e=b
_.f=c
_.r=d},
q9:function q9(a,b,c,d){var _=this
_.d=a
_.e=b
_.f=c
_.r=d},
wv(){var s=$.m,r=t.D,q=t.h,p=new A.ad(new A.l(s,r),q),o=A.bs(t.oh)
o.q(0,p)
return new A.hP(p,o,new A.ad(new A.l(s,r),q))},
hP:function hP(a,b,c){this.a=a
this.b=b
this.c=c},
l3:function l3(a,b,c){this.a=a
this.b=b
this.c=c},
l4:function l4(a,b){this.a=a
this.b=b},
bH:function bH(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
Bs(a){switch(a){case"PUT":return B.bW
case"PATCH":return B.bV
case"DELETE":return B.bU
default:return null}},
f4:function f4(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
fR:function fR(a,b,c){this.c=a
this.a=b
this.b=c},
EG(a){var s=a.$ti.h("bz<G.T,be>"),r=s.h("dv<G.T>")
return new A.eY(new A.dv(new A.uX(),new A.bz(new A.uY(),a,s),r),r.h("eY<G.T,ac>"))},
uY:function uY(){},
uX:function uX(){},
vd(a){return new A.f3(a)},
p4(a){return A.Bl(a)},
Bl(a){var s=0,r=A.i(t.jM),q,p=2,o=[],n,m,l,k
var $async$p4=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:p=4
s=7
return A.c(B.k.n6(a.w),$async$p4)
case 7:n=c
m=A.xl(a,n)
q=m
s=1
break
p=2
s=6
break
case 4:p=3
k=o.pop()
if(t.L.b(A.H(k))){q=A.xm(a)
s=1
break}else throw k
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$p4,r)},
xn(a){var s,r,q
try{s=A.wa(A.vX(a.e)).aF(a.w)
r=A.xl(a,s)
return r}catch(q){if(t.L.b(A.H(q)))return A.xm(a)
else throw q}},
xl(a,b){var s,r,q=J.eT(B.h.c2(b,null),"error")
A:{if(t.f.b(q)){s=A.Bk(q)
break A}s=null
break A}r=s==null?b:s
s=a.c
if(s==null)s="Request failed"
return new A.d9(a.b,s+": "+r)},
xm(a){var s=a.c
if(s==null)s="Request failed"
return new A.d9(a.b,s)},
Bk(a){var s,r=a.i(0,"code"),q=a.i(0,"description"),p=a.i(0,"name"),o=a.i(0,"details")
if(typeof r!="string"||typeof q!="string")return null
s=(typeof p=="string"?r+("("+p+")"):r)+": "+q
if(typeof o=="string")s=s+", "+o
return s.charCodeAt(0)==0?s:s},
f3:function f3(a){this.a=a},
e0:function e0(a){this.a=a},
d9:function d9(a,b){this.a=a
this.b=b},
Di(){var s=A.x_("PowerSync",null,A.Z(t.N,t.I))
if(s.b!=null)A.v(A.Q('Please set "hierarchicalLoggingEnabled" to true if you want to change the level on a non-root logger.'))
J.z(s.c,B.t)
s.c=B.t
s.fa().a_(new A.u6())
return s},
u6:function u6(){},
cW:function cW(a){this.a=a},
w0(a){var s,r,q,p=A.bs(t.N)
for(s=a.gA(a);s.l();){r=s.gp()
q=A.Ei(r)
if(q!=null)p.q(0,q)
else if(!B.a.K(r,"ps_"))p.q(0,r)}return p},
be:function be(a){this.a=a},
i3(a,b){var s=0,r=A.i(t.G),q
var $async$i3=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(a.av(b,B.o),$async$i3)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$i3,r)},
lp(a){var s=0,r=A.i(t.N),q,p
var $async$lp=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.i3(a,"SELECT powersync_client_id() as client_id"),$async$lp)
case 3:p=c
q=A.an(p.gaf(p).i(0,"client_id"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$lp,r)},
vb(a,b,c,d){return a.mL(new A.lt(b,d),c,d)},
dF(a,b){var s=0,r=A.i(t.y),q,p,o,n,m
var $async$dF=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(a.oH(new A.lr(),t.T),$async$dF)
case 3:if(d!=="9223372036854775807"){q=!1
s=1
break}s=4
return A.c(A.i3(a,u.B),$async$dF)
case 4:p=d
if(p.gk(0)===0){q=!1
s=1
break}o=a
n=A
m=A.R(p.gaf(p).i(0,"seq"))
s=6
return A.c(b.$0(),$async$dF)
case 6:s=5
return A.c(o.aZ(new n.ls(m,d),t.y),$async$dF)
case 5:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dF,r)},
lq(a){var s=0,r=A.i(t.d_),q,p,o,n,m,l,k,j,i,h,g
var $async$lq=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(a.km("SELECT * FROM ps_crud ORDER BY id ASC LIMIT 1"),$async$lq)
case 3:g=c
if(g==null)p=null
else{o=B.h.c2(A.an(g.i(0,"data")),null)
p=A.R(g.i(0,"id"))
n=J.a3(o)
m=A.Bs(A.an(n.i(o,"op")))
m.toString
l=A.an(n.i(o,"type"))
k=A.an(n.i(o,"id"))
j=A.R(g.i(0,"tx_id"))
i=t.h9
h=i.a(n.i(o,"data"))
i=i.a(n.i(o,"old"))
i=new A.f4(p,j,m,l,k,A.kK(n.i(o,"metadata")),h,i)
p=i}q=p
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$lq,r)},
ln(a,b,c){var s=0,r=A.i(t.N),q
var $async$ln=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=3
return A.c(a.aZ(new A.lo(b,c),t.N),$async$ln)
case 3:q=e
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ln,r)},
iZ(a,b,c){var s=0,r=A.i(t.T),q,p
var $async$iZ=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:p=A
s=3
return A.c(a.bv("SELECT CAST(powersync_control(?, ?) AS TEXT)",[b,c]),$async$iZ)
case 3:q=p.kK(e.b[0])
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$iZ,r)},
d0(a,b,c){var s=0,r=A.i(t.T),q
var $async$d0=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=3
return A.c(A.iZ(a,b+"_checkpoint_request_id",c),$async$d0)
case 3:q=e
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$d0,r)},
nT(a){var s=0,r=A.i(t.N),q,p
var $async$nT=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.d0(a,"next",null),$async$nT)
case 3:p=c
p.toString
q=p
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$nT,r)},
lt:function lt(a,b){this.a=a
this.b=b},
lr:function lr(){},
ls:function ls(a,b){this.a=a
this.b=b},
lo:function lo(a,b){this.a=a
this.b=b},
dH:function dH(a){this.a=a},
lF:function lF(a,b,c){this.a=a
this.b=b
this.c=c},
lG:function lG(a,b){this.a=a
this.b=b},
c9:function c9(){},
hm:function hm(){},
ej:function ej(a){this.a=a},
h7:function h7(){},
Av(a){return A.Au(a)},
Au(a){var s,r,q,p,o,n,m,l="UpdateSyncStatus",k="EstablishSyncStream",j="FetchCredentials",i="CloseSyncStream",h="DidCompleteSync"
A:{s=a.i(0,"LogLine")
if(s==null)r=a.G("LogLine")
else r=!0
if(r){t.f.a(s)
r=new A.fp(A.an(s.i(0,"severity")),A.an(s.i(0,"line")))
break A}q=a.i(0,l)
if(q==null)r=a.G(l)
else r=!0
if(r){r=t.f
r=new A.fQ(A.Aa(r.a(r.a(q).i(0,"status"))))
break A}p=a.i(0,k)
if(p==null)r=a.G(k)
else r=!0
if(r){r=A.Aj(t.f.a(p))
break A}o=a.i(0,j)
if(o==null)r=a.G(j)
else r=!0
if(r){r=new A.fb(A.aT(t.f.a(o).i(0,"did_expire")))
break A}n=a.i(0,i)
if(n==null)r=a.G(i)
else r=!0
if(r){t.f.a(n)
r=new A.dI(A.aT(n.i(0,"hide_disconnect")))
break A}m=a.i(0,h)
if(m==null)r=a.G(h)
else r=!0
if(r){r=B.aA
break A}r=new A.fO(a)
break A}return r},
Aj(a){var s=t.f,r=s.a(a.i(0,"request")),q=a.i(0,"checkpoint_request")
A:{if(q==null){s=null
break A}s.a(q)
s=new A.lE(A.an(q.i(0,"client_id")),A.an(q.i(0,"checkpoint_request_id")))
break A}return new A.dN(r,s)},
Aa(a){var s,r,q,p,o,n=A.aT(a.i(0,"connected")),m=A.aT(a.i(0,"connecting")),l=A.u([],t.cH)
for(s=J.T(t.j.a(a.i(0,"priority_status"))),r=t.f;s.l();)l.push(A.Ab(r.a(s.gp())))
q=a.i(0,"downloading")
A:{if(q==null){s=null
break A}s=A.Ae(r.a(q))
break A}r=J.eU(t.ia.a(a.i(0,"streams")),new A.m2(),t.em)
r=A.as(r,r.$ti.h("W.E"))
p=A.kK(a.i(0,"internal_last_applied_checkpoint_request_id"))
B:{if(p==null){o=null
break B}o=new A.cW(v.G.BigInt(p))
break B}return new A.m1(n,m,l,s,r,o)},
Ab(a){var s,r=A.R(a.i(0,"priority")),q=A.vV(a.i(0,"has_synced")),p=a.i(0,"last_synced_at")
A:{if(p==null){s=null
break A}s=A.mC(A.R(p))
break A}return new A.ki(q,s,r)},
Ae(a){return new A.mD(t.f.a(a.i(0,"buckets")).cB(0,new A.mE(),t.N,t.cV))},
fp:function fp(a,b){this.a=a
this.b=b},
dN:function dN(a,b){this.a=a
this.b=b},
lE:function lE(a,b){this.a=a
this.b=b},
fQ:function fQ(a){this.a=a},
m1:function m1(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
m2:function m2(){},
mD:function mD(a){this.a=a},
mE:function mE(){},
fb:function fb(a){this.a=a},
dI:function dI(a){this.a=a},
f7:function f7(){},
fO:function fO(a){this.a=a},
qP:function qP(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fu:function fu(a){var _=this
_.d=_.c=_.b=_.a=!1
_.e=null
_.f=a
_.z=_.y=_.x=_.w=_.r=null},
nL:function nL(){},
pc:function pc(a,b,c){this.a=a
this.b=b
this.c=c},
B3(a){var s=a.a
return s==null?B.L:s},
B4(a){var s=a.b
return s==null?B.K:s},
fL:function fL(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
lD:function lD(){},
fm:function fm(){},
d3:function d3(a){this.a=a},
jo:function jo(a,b){this.a=a
this.b=b},
A9(a){var s,r,q,p,o,n,m,l,k,j,i=A.an(a.i(0,"name")),h=t.h9.a(a.i(0,"parameters")),g=A.ye(a.i(0,"priority"))
A:{if(g!=null){s=g
break A}s=2147483647
break A}r=t.f.a(a.i(0,"progress"))
q=A.R(r.i(0,"total"))
r=A.R(r.i(0,"downloaded"))
p=A.aT(a.i(0,"active"))
o=A.aT(a.i(0,"is_default"))
n=A.aT(a.i(0,"has_explicit_subscription"))
m=a.i(0,"expires_at")
B:{if(m==null){l=null
break B}l=A.mC(A.R(m))
break B}k=a.i(0,"last_synced_at")
C:{if(k==null){j=null
break C}j=A.mC(A.R(k))
break C}return new A.dL(i,h,s,new A.kd(r,q),p,o,n,l,j)},
dL:function dL(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
yV(a,b){var s=null,r={},q=A.bK(s,s,s,s,!0,b)
r.a=null
r.b=!1
q.d=new A.uR(r,a,q,b)
q.r=new A.uS(r)
q.e=new A.uT(r)
q.f=new A.uU(r)
return new A.a5(q,A.p(q).h("a5<1>"))},
EF(a){var s,r
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)a[r].ah()},
EJ(a){var s,r
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)a[r].aj()},
kQ(a){var s=0,r=A.i(t.H)
var $async$kQ=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=2
return A.c(A.mU(new A.aa(a,new A.us(),A.a8(a).h("aa<1,o<~>>")),t.H),$async$kQ)
case 2:return A.f(null,r)}})
return A.h($async$kQ,r)},
EM(a,b){var s=null,r={},q=A.bK(s,s,s,s,!0,b)
r.a=!1
q.r=new A.v5(r,a.b8(new A.v6(q,b),new A.v7(r,q),t.P))
return new A.a5(q,A.p(q).h("a5<1>"))},
Bx(a,b,c,d,e,f){var s=new A.l($.m,t.D),r=new A.ad(s,t.h),q=a.a_(null),p=new A.pH(e,r,q,f)
q.bq(p)
p.$1(c)
b.J(new A.pI(r,d,q))
return s},
BQ(a){return new A.ei(a,new DataView(new ArrayBuffer(4)))},
uR:function uR(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
uQ:function uQ(a,b,c){this.a=a
this.b=b
this.c=c},
uO:function uO(a,b){this.a=a
this.b=b},
uP:function uP(a,b){this.a=a
this.b=b},
uS:function uS(a){this.a=a},
uT:function uT(a){this.a=a},
uU:function uU(a){this.a=a},
us:function us(){},
v6:function v6(a,b){this.a=a
this.b=b},
v7:function v7(a,b){this.a=a
this.b=b},
v5:function v5(a,b){this.a=a
this.b=b},
pH:function pH(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pI:function pI(a,b,c){this.a=a
this.b=b
this.c=c},
ei:function ei(a,b){var _=this
_.a=a
_.b=b
_.c=4
_.d=null},
vY(a){var s,r={},q=new A.l($.m,t.D)
r.a=null
s=new A.u1(r,new A.N(q,t.F))
r.a=A.pr(a,s)
return new A.a2(q,s)},
DG(a){var s="Sync service error"
if(a instanceof A.bU)return s
else if(a instanceof A.d9)if(a.a===401)return"Authorization error"
else return s
else if(a instanceof A.a4||t.lW.b(a))return"Configuration error"
else if(a instanceof A.f3)return"Credentials error"
else if(a instanceof A.e0)return"Protocol error"
else return J.ws(a).j(0)+": "+A.q(a)},
B1(a){return new A.cp(a)},
w_(a,b){if((a.a.a.a&30)===0)return!1
return b instanceof A.bU||b instanceof A.cf},
oL:function oL(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=null
_.as=l
_.at=m
_.ax=n
_.ay=o
_.ch=null},
p1:function p1(a,b){this.a=a
this.b=b},
oT:function oT(a,b){this.a=a
this.b=b},
oU:function oU(a){this.a=a},
oV:function oV(a){this.a=a},
oM:function oM(a,b){this.a=a
this.b=b},
oN:function oN(){},
oO:function oO(){},
oP:function oP(a,b){this.a=a
this.b=b},
oQ:function oQ(a){this.a=a},
oR:function oR(){},
p0:function p0(a){this.a=a},
p_:function p_(){},
oW:function oW(a,b,c){this.a=a
this.b=b
this.c=c},
oZ:function oZ(a,b){this.a=a
this.b=b},
oX:function oX(a,b){this.a=a
this.b=b},
oY:function oY(){},
oS:function oS(a,b){this.a=a
this.b=b},
u1:function u1(a,b){this.a=a
this.b=b},
qk:function qk(a,b){this.a=a
this.b=b
this.c=!1},
ql:function ql(){},
qs:function qs(a){this.a=a},
qr:function qr(a){this.a=a},
qq:function qq(){},
qm:function qm(a){this.a=a},
qn:function qn(a){this.a=a},
qo:function qo(a){this.a=a},
qp:function qp(){},
dK:function dK(a,b){this.a=a
this.b=b},
cp:function cp(a){this.a=a},
fS:function fS(){},
fN:function fN(){},
fe:function fe(a){this.a=a},
f_:function f_(a,b){this.a=a
this.b=b},
Aw(a){var s=A.p(a).h("bd<2>"),r=t.S,q=s.h("n.E")
return new A.ix(a,A.wS(A.fr(new A.bd(a,s),new A.ns(),q,r)),A.wS(A.fr(new A.bd(a,s),new A.nt(),q,r)))},
cu:function cu(a,b,c,d,e,f,g,h,i,j,k,l){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l},
pd:function pd(a,b){this.a=a
this.b=b},
ix:function ix(a,b,c){this.c=a
this.a=b
this.b=c},
ns:function ns(){},
nt:function nt(){},
nW:function nW(){},
Ch(a,b){var s=null,r=new A.kk(a,b,A.bK(s,s,s,s,!0,t.p))
r.l0(a,b)
return r},
e3:function e3(a){this.a=a
this.b=0},
oe:function oe(a,b){this.a=a
this.b=b},
kk:function kk(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
t5:function t5(a){this.a=a},
Fa(a){var s
if(t.p.b(a)){s=B.f.gan(a)
if(a.byteOffset===0&&J.zN(s)===a.length)return t.a.a(s)}return t.a.a(B.f.gan(new Uint8Array(A.vZ(a))))},
vt:function vt(a){this.a=a},
vM:function vM(a){this.a=!1
this.b=a
this.c=null},
A6(a,b){var s=new A.cg(b)
s.kP(a,b)
return s},
Bm(a){var s=null,r=new A.fI(B.as,A.Z(t.ir,t.mQ),t.a9),q=t.pp
r.a=A.bK(r.gmu(),r.glY(),r.gmv(),r.gmx(),!0,q)
q=new A.ea(a,new A.fL(s,s,s,s,B.O,s,s,s),r,A.bK(s,s,s,s,!1,q),A.Z(t.hM,t.eL),A.u([],t.bN))
q.kU(a)
return q},
pe:function pe(a){this.a=a},
pf:function pf(a){this.a=a},
cg:function cg(a){var _=this
_.a=$
_.b=a
_.d=_.c=null},
lV:function lV(a){this.a=a},
lU:function lU(a){this.a=a},
lW:function lW(a){this.a=a},
ea:function ea(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c="{}"
_.d=c
_.e=d
_.w=_.r=_.f=null
_.x=e
_.y=f},
pb:function pb(a){this.a=a},
p5:function p5(a,b,c){this.a=a
this.b=b
this.c=c},
p6:function p6(a,b,c){this.a=a
this.b=b
this.c=c},
p7:function p7(a){this.a=a},
p8:function p8(a){this.a=a},
p9:function p9(a){this.a=a},
pa:function pa(a){this.a=a},
fY:function fY(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
hr:function hr(a){this.a=a},
h6:function h6(a){this.a=a},
h3:function h3(a,b){this.a=a
this.b=b},
xs(a){var s=a.content
s=B.d.b6(s,new A.pD(),t.E)
s=A.as(s,s.$ti.h("W.E"))
return s},
xg(a){var s,r,q=a.endpoint,p=a.token,o=a.userId
if(o==null)o=null
if(a.expiresAt==null)s=null
else{s=a.expiresAt
s.toString
s=A.mC(A.R(s))}r=A.de(q)
if(!r.eg("http")&&!r.eg("https")||r.gbF().length===0)A.v(A.aV(q,"PowerSync endpoint must be a valid URL",null))
return new A.bH(q,p,o,s)},
Bc(a){var s,r,q,p=A.u([],t.W)
for(s=new A.ax(a,A.p(a).h("ax<1,2>")).gA(0);s.l();){r=s.d
q=r.a
r=r.b.a
p.push({name:q,priority:r[1],atLast:r[0],sinceLast:r[2],targetCount:r[3]})}return p},
xh(a){var s,r,q,p,o,n,m,l,k,j,i,h=null,g=a.f
g=g==null?h:1000*g.a+g.b
s=a.w
s=s==null?h:J.aU(s)
r=a.x
r=r==null?h:J.aU(r)
q=A.u([],t.fT)
for(p=J.T(a.y);p.l();){o=p.gp()
n=o.c
m=o.b
m=m==null?h:1000*m.a+m.b
l=o.a
q.push([n,m,l==null?h:l])}k=a.d
A:{if(k==null){p=h
break A}p=A.Bc(k.c)
break A}n=B.h.bi(a.z)
j=a.Q
B:{if(j==null){m=h
break B}i=j.a
m=i
break B}return{connected:a.a,connecting:a.b,downloading:a.c,uploading:a.e,lastSyncedAt:g,hasSyned:a.r,uploadError:s,downloadError:r,priorityStatusEntries:q,syncProgress:p,streamSubscriptions:n,lastAppliedCheckpoint:m}},
Bz(a,b){var s=null,r=$.m,q=A.bK(s,s,s,s,!1,t.l4),p=$.wn()
r=new A.jD(A.Z(t.S,t.kn),new A.ad(new A.l(r,t.D),t.h),a,b,q,p,s)
r.kW(s,s,s,a,b)
return r},
am:function am(a,b){this.a=a
this.b=b},
pD:function pD(){},
jD:function jD(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=0
_.e=_.d=!1
_.r=_.f=null
_.x=c
_.y=d
_.z=e
_.Q=f
_.as=g},
qe:function qe(a){this.a=a},
qa:function qa(){},
qb:function qb(a,b){this.a=a
this.b=b},
qc:function qc(a,b){this.a=a
this.b=b},
qd:function qd(a,b,c){this.a=a
this.b=b
this.c=c},
i6:function i6(){},
EA(){var s=null,r=v.G,q=r.location.href,p=t.m,o=A.bK(s,s,s,s,!0,p),n=t.d
new A.qf(new A.rk(new A.nU(new A.rh(q)),new A.a5(o,A.p(o).h("a5<1>"))),new A.nS(),A.u([],t.az),A.Z(t.S,t.lp),new A.dX(A.nB(n)),new A.dX(A.nB(n))).cu()
if($.zw())A.aC(r,"connect",new A.uK(new A.uM(new A.uL(new A.pe(A.Z(t.N,t.mO)),o))),!1,p)
else A.aC(r,"message",o.ge_(o),!1,p)},
uL:function uL(a,b){this.a=a
this.b=b},
uM:function uM(a){this.a=a},
uK:function uK(a){this.a=a},
rk:function rk(a,b){this.a=a
this.b=b},
nS:function nS(){},
nU:function nU(a){this.a=a},
vg(a,b){if(b<0)A.v(A.ay("Offset may not be negative, was "+b+"."))
else if(b>a.c.length)A.v(A.ay("Offset "+b+u.D+a.gk(0)+"."))
return new A.iq(a,b)},
oo:function oo(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
iq:function iq(a,b){this.a=a
this.b=b},
er:function er(a,b,c){this.a=a
this.b=b
this.c=c},
Ap(a,b){var s=A.Aq(A.u([A.BW(a,!0)],t.g7)),r=new A.nh(b).$0(),q=B.b.j(B.d.gaO(s).b+1),p=A.Ar(s)?0:3,o=A.a8(s)
return new A.mY(s,r,null,1+Math.max(q.length,p),new A.aa(s,new A.n_(),o.h("aa<1,a>")).oI(0,B.ax),!A.Ev(new A.aa(s,new A.n0(),o.h("aa<1,k?>"))),new A.X(""))},
Ar(a){var s,r,q
for(s=0;s<a.length-1;){r=a[s];++s
q=a[s]
if(r.b+1!==q.b&&J.z(r.c,q.c))return!1}return!0},
Aq(a){var s,r,q=A.El(a,new A.n2(),t.nf,t.K)
for(s=new A.bc(q,q.r,q.e);s.l();)J.wt(s.d,new A.n3())
s=A.p(q).h("ax<1,2>")
r=s.h("fa<n.E,by>")
s=A.as(new A.fa(new A.ax(q,s),new A.n4(),r),r.h("n.E"))
return s},
BW(a,b){var s=new A.rI(a).$0()
return new A.aN(s,!0,null)},
BY(a){var s,r,q,p,o,n,m=a.gag()
if(!B.a.S(m,"\r\n"))return a
s=a.gC().ga7()
for(r=m.length-1,q=0;q<r;++q)if(m.charCodeAt(q)===13&&m.charCodeAt(q+1)===10)--s
r=a.gF()
p=a.gL()
o=a.gC().gU()
p=A.ja(s,a.gC().ga6(),o,p)
o=A.hL(m,"\r\n","\n")
n=a.gaE()
return A.op(r,p,o,A.hL(n,"\r\n","\n"))},
BZ(a){var s,r,q,p,o,n,m
if(!B.a.bE(a.gaE(),"\n"))return a
if(B.a.bE(a.gag(),"\n\n"))return a
s=B.a.t(a.gaE(),0,a.gaE().length-1)
r=a.gag()
q=a.gF()
p=a.gC()
if(B.a.bE(a.gag(),"\n")){o=A.uy(a.gaE(),a.gag(),a.gF().ga6())
o.toString
o=o+a.gF().ga6()+a.gk(a)===a.gaE().length}else o=!1
if(o){r=B.a.t(a.gag(),0,a.gag().length-1)
if(r.length===0)p=q
else{o=a.gC().ga7()
n=a.gL()
m=a.gC().gU()
p=A.ja(o-1,A.xK(s),m-1,n)
q=a.gF().ga7()===a.gC().ga7()?p:a.gF()}}return A.op(q,p,r,s)},
BX(a){var s,r,q,p,o
if(a.gC().ga6()!==0)return a
if(a.gC().gU()===a.gF().gU())return a
s=B.a.t(a.gag(),0,a.gag().length-1)
r=a.gF()
q=a.gC().ga7()
p=a.gL()
o=a.gC().gU()
p=A.ja(q-1,s.length-B.a.cA(s,"\n")-1,o-1,p)
return A.op(r,p,s,B.a.bE(a.gaE(),"\n")?B.a.t(a.gaE(),0,a.gaE().length-1):a.gaE())},
xK(a){var s=a.length
if(s===0)return 0
else if(a.charCodeAt(s-1)===10)return s===1?0:s-B.a.eh(a,"\n",s-2)-1
else return s-B.a.cA(a,"\n")-1},
mY:function mY(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
nh:function nh(a){this.a=a},
n_:function n_(){},
mZ:function mZ(){},
n0:function n0(){},
n2:function n2(){},
n3:function n3(){},
n4:function n4(){},
n1:function n1(a){this.a=a},
ni:function ni(){},
n5:function n5(a){this.a=a},
nc:function nc(a,b,c){this.a=a
this.b=b
this.c=c},
nd:function nd(a,b){this.a=a
this.b=b},
ne:function ne(a){this.a=a},
nf:function nf(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
na:function na(a,b){this.a=a
this.b=b},
nb:function nb(a,b){this.a=a
this.b=b},
n6:function n6(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
n7:function n7(a,b,c){this.a=a
this.b=b
this.c=c},
n8:function n8(a,b,c){this.a=a
this.b=b
this.c=c},
n9:function n9(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ng:function ng(a,b,c){this.a=a
this.b=b
this.c=c},
aN:function aN(a,b,c){this.a=a
this.b=b
this.c=c},
rI:function rI(a){this.a=a},
by:function by(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ja(a,b,c,d){if(a<0)A.v(A.ay("Offset may not be negative, was "+a+"."))
else if(c<0)A.v(A.ay("Line may not be negative, was "+c+"."))
else if(b<0)A.v(A.ay("Column may not be negative, was "+b+"."))
return new A.bv(d,a,c,b)},
bv:function bv(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jb:function jb(){},
jd:function jd(){},
Bf(a,b,c){return new A.e6(c,a,b)},
je:function je(){},
e6:function e6(a,b,c){this.c=a
this.a=b
this.b=c},
e7:function e7(){},
op(a,b,c,d){var s=new A.c1(d,a,b,c)
s.kS(a,b,c)
if(!B.a.S(d,c))A.v(A.K('The context line "'+d+'" must contain "'+c+'".',null))
if(A.uy(d,c,a.ga6())==null)A.v(A.K('The span text "'+c+'" must start at column '+(a.ga6()+1)+' in a line within "'+d+'".',null))
return s},
c1:function c1(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
Bg(a){var s
A:{if(18===a){s=B.af
break A}if(23===a){s=B.ag
break A}if(9===a){s=B.ah
break A}s=null
break A}return s},
e8:function e8(a,b){this.a=a
this.b=b},
b4:function b4(a,b,c){this.a=a
this.b=b
this.c=c},
ji(a,b,c,d,e,f,g){return new A.d6(d,b,c,e,f,a,g)},
d6:function d6(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
ou:function ou(){},
ml:function ml(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=null
_.r=!1},
mu:function mu(a){this.a=a},
mt:function mt(a){this.a=a},
mv:function mv(a){this.a=a},
mr:function mr(a){this.a=a},
mq:function mq(a){this.a=a},
ms:function ms(a){this.a=a},
mn:function mn(a){this.a=a},
mm:function mm(a){this.a=a},
mo:function mo(a){this.a=a},
mp:function mp(a,b){this.a=a
this.b=b},
cA:function cA(a,b,c,d,e){var _=this
_.a=a
_.b=!1
_.c=b
_.d=null
_.e=c
_.f=d
_.w=_.r=null
_.$ti=e},
tk:function tk(a,b){this.a=a
this.b=b},
tl:function tl(a,b,c){this.a=a
this.b=b
this.c=c},
tm:function tm(a,b,c){this.a=a
this.b=b
this.c=c},
oq:function oq(){},
e9:function e9(a,b,c){var _=this
_.a=a
_.b=b
_.d=c
_.e=null
_.f=!0
_.r=!1},
vi(a,b){var s=$.kW()
return new A.is(A.Z(t.N,t.a_),s,a)},
is:function is(a,b,c){this.d=a
this.b=b
this.a=c},
k0:function k0(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=0},
EE(a){var s=J.zR(new v.G.URL(a,"file:///").pathname,"/")
return new A.c6(s,new A.uW(),A.a8(s).h("c6<1>"))},
uW:function uW(){},
m3:function m3(){},
bI:function bI(a,b,c){this.d=a
this.a=b
this.c=c},
aS:function aS(a,b){this.a=a
this.b=b},
kl:function kl(a){this.a=a
this.b=-1},
km:function km(){},
kn:function kn(){},
kp:function kp(){},
kq:function kq(){},
nP:function nP(a,b){this.a=a
this.b=b},
B0(a){var s=a.f=!1,r=a.a
r=r.c.d.sqlite3_step(r.b)
A:{if(100===r){s=!0
break A}if(101===r||0===r)break A
s=a.bt(r,"step")}return s},
cQ:function cQ(){},
nm:function nm(){},
f5:function f5(a){this.a=a},
ed(a){return new A.c5(a)},
wx(a,b){var s,r,q,p
if(b==null)b=$.kW()
for(s=a.length,r=a.$flags|0,q=0;q<s;++q){p=b.el(256)
r&2&&A.C(a)
a[q]=p}},
c5:function c5(a){this.a=a},
fF:function fF(a){this.a=a},
aB:function aB(){},
i1:function i1(){},
i0:function i0(){},
EK(a,b){var s=null,r=new A.cY(t.kk)
return A.EL(a,new A.fX(s,s,s,s,s,s,s,s,new A.v2(new A.v1(r,A.u4(new A.v3(r)))),s,s,s,s),b)},
dh:function dh(a){var _=this
_.d=a
_.c=_.b=_.a=null},
v3:function v3(a){this.a=a},
v1:function v1(a,b){this.a=a
this.b=b},
v2:function v2(a){this.a=a},
pT:function pT(a){this.a=a},
pO:function pO(a,b,c){this.a=a
this.b=b
this.c=c},
pV:function pV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pU:function pU(a,b,c){this.b=a
this.c=b
this.d=c},
df:function df(){},
cv:function cv(){},
ef:function ef(a,b,c){this.a=a
this.b=b
this.c=c},
b9(a){var s,r,q
try{a.$0()
return 0}catch(r){q=A.H(r)
if(q instanceof A.c5){s=q
return s.a}else return 1}},
ib:function ib(a){this.b=this.a=$
this.d=a},
m8:function m8(a,b,c){this.a=a
this.b=b
this.c=c},
m5:function m5(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ma:function ma(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mc:function mc(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
me:function me(a,b){this.a=a
this.b=b},
m7:function m7(a){this.a=a},
md:function md(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mi:function mi(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mg:function mg(a,b){this.a=a
this.b=b},
mf:function mf(a,b){this.a=a
this.b=b},
m9:function m9(a,b,c){this.a=a
this.b=b
this.c=c},
mb:function mb(a,b){this.a=a
this.b=b},
mh:function mh(a,b){this.a=a
this.b=b},
m6:function m6(a,b,c){this.a=a
this.b=b
this.c=c},
eV:function eV(a,b){this.a=a
this.$ti=b},
l6:function l6(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l8:function l8(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l7:function l7(a,b,c){this.a=a
this.b=b
this.c=c},
bD(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aC(a,"success",new A.lM(r,a,b),!1,q)
A.aC(a,"error",new A.lN(r,a),!1,q)
return s},
A5(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aC(a,"success",new A.lR(r,a,b),!1,q)
A.aC(a,"error",new A.lS(r,a),!1,q)
A.aC(a,"blocked",new A.lT(r),!1,q)
return s},
dl:function dl(a,b){var _=this
_.c=_.b=_.a=null
_.d=a
_.$ti=b},
r9:function r9(a,b){this.a=a
this.b=b},
ra:function ra(a,b){this.a=a
this.b=b},
lM:function lM(a,b,c){this.a=a
this.b=b
this.c=c},
lN:function lN(a,b){this.a=a
this.b=b},
lR:function lR(a,b,c){this.a=a
this.b=b
this.c=c},
lS:function lS(a,b){this.a=a
this.b=b},
lT:function lT(a){this.a=a},
v4(){var s=v.G.navigator
if("storage" in s)return s.storage
return null},
wL(a,b,c){var s=a.read(b,c)
return s},
wM(a,b,c){var s=a.write(b,c)
return s},
Al(a){var s=t.om
if(!(v.G.Symbol.asyncIterator in a))A.v(A.K("Target object does not implement the async iterable interface",null))
return new A.bz(new A.mJ(),new A.eV(a,s),s.h("bz<G.T,x>"))},
mJ:function mJ(){},
pP:function pP(a){this.a=a},
pQ:function pQ(a){this.a=a},
pS(a,b){var s=0,r=A.i(t.w),q,p,o
var $async$pS=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p=v.G
o=A
s=3
return A.c(A.aq(p.fetch(new p.URL(a,A.S(p.location).href),null),t.m),$async$pS)
case 3:q=o.pR(d,null)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$pS,r)},
pR(a,b){var s=0,r=A.i(t.w),q,p,o,n,m
var $async$pR=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p=new A.ib(A.Z(t.S,t.ie))
o=A
n=A
m=A
s=3
return A.c(new A.pP(p).ej(a),$async$pR)
case 3:q=new o.ee(new n.pT(m.By(d,p)))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$pR,r)},
ee:function ee(a){this.a=a},
C_(a){var s=new A.hd(a,new A.N(new A.l($.m,t.D),t.F),a.objectStore("files"),a.objectStore("blocks"))
s.kZ(a)
return s},
iu(a,b,c){var s=0,r=A.i(t.cF),q,p,o,n,m,l
var $async$iu=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:p=t.N
o=new A.ld(a)
n=A.vi("dart-memory",null)
m=$.kW()
l=new A.ck(o,n,new A.cY(t.p3),A.bs(p),A.Z(p,t.S),m,b)
l.r=!1
s=3
return A.c(o.em(),$async$iu)
case 3:s=4
return A.c(l.cZ(),$async$iu)
case 4:q=l
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$iu,r)},
ld:function ld(a){this.a=null
this.b=a},
lg:function lg(a){this.a=a},
lf:function lf(a,b,c){this.a=a
this.b=b
this.c=c},
le:function le(a){this.a=a},
hd:function hd(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=!1
_.d=c
_.e=d},
rL:function rL(a){this.a=a},
rM:function rM(a){this.a=a},
rK:function rK(a){this.a=a},
rN:function rN(a,b,c){this.a=a
this.b=b
this.c=c},
rP:function rP(a,b){this.a=a
this.b=b},
rO:function rO(a,b){this.a=a
this.b=b},
ro:function ro(a,b,c){this.a=a
this.b=b
this.c=c},
rp:function rp(a,b){this.a=a
this.b=b},
k8:function k8(a,b){this.a=a
this.b=b},
ck:function ck(a,b,c,d,e,f,g){var _=this
_.d=a
_.f=_.e=!1
_.r=!0
_.w=b
_.x=c
_.y=d
_.z=e
_.b=f
_.a=g},
nk:function nk(a,b,c){this.a=a
this.b=b
this.c=c},
nl:function nl(){},
nj:function nj(a,b){this.a=a
this.b=b},
k1:function k1(a,b,c){this.a=a
this.b=b
this.c=c},
rJ:function rJ(a,b){this.a=a
this.b=b},
aD:function aD(){},
hb:function hb(a,b){var _=this
_.w=a
_.d=b
_.c=_.b=_.a=null},
h5:function h5(a,b,c){var _=this
_.w=a
_.x=b
_.d=c
_.c=_.b=_.a=null},
en:function en(a,b,c){var _=this
_.w=a
_.x=b
_.d=c
_.c=_.b=_.a=null},
eG:function eG(a,b,c,d,e){var _=this
_.w=a
_.x=b
_.y=c
_.z=d
_.d=e
_.c=_.b=_.a=null},
xi(a){var s=A.vi("dart-memory",null),r=$.kW()
return new A.e5(s,r,a)},
j6(a,b){var s=0,r=A.i(t.mt),q,p,o,n,m,l,k,j
var $async$j6=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:j=A.v4()
if(j==null)throw A.b(A.ed(1))
p=t.m
s=3
return A.c(A.aq(j.getDirectory(),p),$async$j6)
case 3:o=d
n=A.EE(a),m=J.T(n.a),n=new A.eg(m,n.b),l=null
case 4:if(!n.l()){s=6
break}s=7
return A.c(A.aq(o.getDirectoryHandle(m.gp(),{create:!0}),p),$async$j6)
case 7:k=d
case 5:l=o,o=k
s=4
break
case 6:q=new A.a2(l,o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$j6,r)},
j7(a){var s=0,r=A.i(t.m),q
var $async$j7=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.j6(a,!0),$async$j7)
case 3:q=c.b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$j7,r)},
om(a,b){var s=0,r=A.i(t.g_),q,p
var $async$om=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:if(A.v4()==null)throw A.b(A.ed(1))
p=A
s=3
return A.c(A.j7(a),$async$om)
case 3:q=p.ol(d,!1,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$om,r)},
ol(a,b,c){var s=0,r=A.i(t.g_),q,p
var $async$ol=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:p=A.xi(c)
s=3
return A.c(p.bK(a,!1),$async$ol)
case 3:q=p
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ol,r)},
dO:function dO(a,b,c){this.c=a
this.a=b
this.b=c},
e5:function e5(a,b,c){var _=this
_.d=null
_.e=a
_.b=b
_.a=c},
on:function on(a,b){this.a=a
this.b=b},
kr:function kr(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=0},
t2:function t2(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
By(a,b){var s=A.S(a.exports.memory)
b.b!==$&&A.z4()
b.b=s
s=new A.pJ(s,b,a.exports)
s.kV(a,b)
return s},
qj(a,b){var s,r=A.b3(a.buffer,b,null)
for(s=0;r[s]!==0;)++s
return s},
eh(a,b){var s=a.buffer,r=A.qj(a,b)
return B.k.aF(A.b3(s,b,r))},
vD(a,b,c){var s
if(b===0)return null
s=a.buffer
return B.k.aF(A.b3(s,b,c==null?A.qj(a,b):c))},
pJ:function pJ(a,b,c){var _=this
_.b=a
_.c=b
_.d=c
_.w=_.r=null},
pK:function pK(a){this.a=a},
pL:function pL(a){this.a=a},
pM:function pM(a){this.a=a},
pN:function pN(a){this.a=a},
uv(){var s=0,r=A.i(t.ja),q,p,o,n,m,l
var $async$uv=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:m=new v.G.MessageChannel()
l=$.hN()
s=l!=null?3:5
break
case 3:p=A.Dp()
s=6
return A.c(A.fV(l,p,null,null,!1),$async$uv)
case 6:o=b
s=4
break
case 5:o=null
p=null
case 4:n=m.port2
q=new A.a2({port:m.port1,lockName:p},new A.dJ(n,p,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$uv,r)},
Dp(){var s,r
for(s=0,r="channel-close-";s<16;++s)r+=A.aP(97+$.zC().el(26))
return r.charCodeAt(0)==0?r:r},
zX(a){return new A.eZ(a)},
dJ:function dJ(a,b,c){this.a=a
this.b=b
this.c=c},
nX:function nX(){},
o0:function o0(a){this.a=a},
o1:function o1(a){this.a=a},
o_:function o_(a){this.a=a},
nZ:function nZ(a){this.a=a},
nY:function nY(a){this.a=a},
o2:function o2(a,b,c){this.a=a
this.b=b
this.c=c},
eZ:function eZ(a){this.a=a},
B2(a,b){var s=t.H
s=new A.j3(a,b,new A.ad(new A.l($.m,t.ny),t.mE),A.d7(!1,t.e1),new A.jR(A.d7(!1,s)),new A.jR(A.d7(!1,s)))
s.kQ(a,b)
return s},
BA(a,b){var s=t.m,r=A.d7(!1,s),q=new A.l($.m,t.D),p=t.S
s=new A.jE(r,b,a.a,new A.ad(q,t.h),A.Z(p,t.br),A.Z(p,s))
s.hA(a)
q.J(r.gaD())
return s},
Ac(a,b,c,d){var s=A.nB(t.d)
return new A.mj(d,new A.dX(s),A.bs(t.jC))},
jR:function jR(a){this.a=null
this.b=a},
j3:function j3(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.e=d
_.f=e
_.r=f},
o9:function o9(a){this.a=a},
oa:function oa(a){this.a=a},
o5:function o5(a){this.a=a},
ob:function ob(a){this.a=a},
oc:function oc(a){this.a=a},
od:function od(a){this.a=a},
o7:function o7(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
o6:function o6(a,b,c){this.a=a
this.b=b
this.c=c},
o8:function o8(a,b,c){this.a=a
this.b=b
this.c=c},
jE:function jE(a,b,c,d,e,f){var _=this
_.w=a
_.x=b
_.a=c
_.b=d
_.d=_.c=null
_.e=0
_.f=e
_.r=f},
mj:function mj(a,b,c){this.d=a
this.e=b
this.z=c},
mk:function mk(){},
ia:function ia(a){this.a=a},
m4:function m4(a,b){this.c=a
this.a=b},
dg:function dg(){},
rg:function rg(){},
ip(a,b,c){var s=0,r=A.i(t.eZ),q,p,o
var $async$ip=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=3
return A.c(A.j7(a),$async$ip)
case 3:p=e
o=A.xi(c)
s=b?4:5
break
case 4:s=6
return A.c(o.bK(p,!0),$async$ip)
case 6:case 5:q=new A.io(o,p,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ip,r)},
io:function io(a,b,c){this.a=a
this.b=b
this.c=c},
mX:function mX(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=0},
fV(a,b,c,d,e){var s,r,q={},p=new A.l($.m,t.fV),o=new A.N(p,t.l6)
q.a=null
s={steal:e}
if(c!=null)s.signal=c
r=t.X
A.ir(A.aq(a.request(b,s,A.bB(new A.q1(q,o))),r),new A.q2(q,d,o),r,t.K)
return p},
q1:function q1(a,b){this.a=a
this.b=b},
q2:function q2(a,b,c){this.a=a
this.b=b
this.c=c},
bV:function bV(a){this.a=a},
ic:function ic(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.f=_.e=null},
mx:function mx(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mw:function mw(a,b){this.a=a
this.b=b},
my:function my(a){this.a=a},
dX:function dX(a){this.a=!1
this.b=a},
nO:function nO(a,b){this.a=a
this.b=b},
nN:function nN(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
nM:function nM(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
A2(a){var s,r,q,p,o=A.u([],t.kC),n=t.c.a(a.a),m=t.o.b(n)?n:new A.al(n,A.a8(n).h("al<1,j>"))
for(s=J.a3(m),r=0;r<s.gk(m)/2;++r){q=r*2
o.push(new A.a2(A.ih(B.bj,s.i(m,q)),s.i(m,q+1)))}s=A.aT(a.b)
q=A.aT(a.c)
p=A.aT(a.d)
return new A.cR(o,s,q,A.aT(a.g),p)},
cR:function cR(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
B5(a){var s
if(J.z(a.t,"errorResponse")){s=A.Af(a)
if(s!=null&&s instanceof A.bp)return s
else return new A.d2(a.e,s)}else return new A.d2("Did not respond with expected type, got "+A.q(a),null)},
Af(a){var s=a.s,r=s==null?null:A.R(s)
A:{if(0===r){s=A.Ag(t.c.a(a.r))
break A}if(1===r){s=B.A
break A}s=null
break A}return s},
Ag(a){var s,r,q,p,o=null,n=a.length>=8,m=o,l=o,k=o,j=o,i=o,h=o,g=o
if(n){s=a[0]
m=a[1]
l=a[2]
k=a[3]
j=a[4]
i=a[5]
h=a[6]
g=a[7]}else s=o
if(!n)throw A.b(A.D("Pattern matching error"))
n=new A.mI()
l=A.R(A.bR(l))
A.an(s)
r=n.$1(m)
q=n.$1(j)
if(i!=null&&h!=null){t.c.a(i)
t.a.a(h)
p=new A.ci(i,h,A.b3(h,0,o))}else p=o
n=n.$1(k)
A.yd(g)
return new A.d6(s,r,l,g==null?o:A.R(g),n,q,p)},
Ah(a){var s,r,q,p,o,n,m=null,l=a.r
A:{if(l==null){s=m
break A}s=A.vz(l)
break A}r=a.b
if(r==null)r=m
q=a.e
if(q==null)q=m
p=a.f
if(p==null)p=m
o=s==null
n=o?m:s.a
s=o?m:s.b
o=a.d
if(o==null)o=m
return[a.a,r,a.c,q,p,n,s,o]},
B6(a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=null,a0=v.G,a1=new a0.Array(),a2=new a0.ArrayBuffer(512),a3=new A.mX(a2,512,"transfer" in a2)
a5.iZ(a4)
for(s=a4.a,r=s.c,s=s.b,q=r.d,r=r.b,p=0,o=!0;A.B0(a4);){if(o){p=q.sqlite3_column_count(s)
o=!1}n=a3.d
m=a3.d=n+p
if(m>a3.b)a3.lK(m)
m=new a0.DataView(a3.a,n,p)
l=new a0.Array(p)
for(k=0;k<p;++k){switch(q.sqlite3_column_type(s,k)){case 1:j=q.sqlite3_column_int64(s,k)
i=a0.Number(j)
if(a0.Number.isSafeInteger(i)){j=i
h=B.P}else h=B.Q
break
case 2:j=q.sqlite3_column_double(s,k)
h=B.R
break
case 3:g=q.sqlite3_column_text(s,k)
f=r.buffer
e=A.qj(r,g)
g=new Uint8Array(f,g,e)
d=new A.cD(!1).cS(g,0,a,!0)
j=d
h=B.S
break
case 4:g=q.sqlite3_column_bytes(s,k)
f=q.sqlite3_column_blob(s,k)
c=new Uint8Array(g)
e=r.buffer
g=new Uint8Array(e,f,g)
B.f.ce(c,0,g)
j=c
h=B.T
break
case 5:default:j=a
h=B.U}l[k]=j
m.setUint8(k,h.a)}a1.push(l)}b=new a0.Array(p)
for(k=0;k<p;++k){a0=q.sqlite3_column_name(s,k)
m=r.buffer
g=A.qj(r,a0)
a0=new Uint8Array(m,a0,g)
b[k]=new A.cD(!1).cS(a0,0,a,!0)}return A.yW(!1,b,0,0,a1,a,a3.oQ(0))},
B7(a){var s,r,q,p,o,n,m,l,k,j,i,h=a.c
if(h!=null){s=t.o.b(h)?h:new A.al(h,A.a8(h).h("al<1,j>"))
s=J.eU(s,new A.oh(),t.N)
r=A.as(s,s.$ti.h("W.E"))
s=a.n
if(s!=null){s=t.fi.b(s)?s:new A.al(s,A.a8(s).h("al<1,j?>"))
s=J.eU(s,new A.oi(),t.T)
A.as(s,s.$ti.h("W.E"))}s=a.v
q=s==null?null:A.b3(s,0,null)
p=A.u([],t.dO)
s=a.r
s.toString
if(!t.mu.b(s))s=new A.al(s,A.a8(s).h("al<1,t<k?>>"))
s=J.T(s)
o=q!=null
n=0
while(s.l()){m=s.gp()
l=[]
m=B.d.gA(m)
while(m.l()){k=m.gp()
if(o){j=q[n]
i=j>=8?B.w:B.I[j]}else i=B.w
l.push(i.j9(k));++n}p.push(l)}s=new A.bI(p,r,B.bm)
s.la()
return s}else return null},
Ew(a){if(a==="sharedCompatibilityCheck"||a==="dedicatedCompatibilityCheck"||a==="dedicatedInSharedCompatibilityCheck")return!0
else return!1},
mI:function mI(){},
oh:function oh(){},
oi:function oi(){},
yW(a,b,c,d,e,f,g){return{c:b,n:f,v:g,r:e,x:a,y:c,i:d,t:"rowsResponse"}},
dz(a){var s,r,q,p,o=v.G,n=new o.Array()
switch(a.t){case"connect":n.push(a.r.port)
break
case"fileSystemAccess":s=a.b
if(s!=null)n.push(s)
break
case"runQuery":n.push(a.v)
break
case"simpleSuccessResponse":r=a.r
if(r!=null){o=o.ArrayBuffer
o=r instanceof o
q=r}else{q=null
o=!1}if(o)n.push(q)
break
case"endpointResponse":n.push(a.r.port)
break
case"rowsResponse":p=a.v
if(p!=null)n.push(p)
break}return n},
Ed(a,b,c,d,e){switch(a.t){case"abort":return b.$1(a)
case"notifyUpdate":case"notifyCommit":case"notifyRollback":return c.$1(a)
case"simpleSuccessResponse":case"endpointResponse":case"rowsResponse":case"errorResponse":return e.$1(a)
default:return d.$1(a)}},
ft:function ft(a,b){this.a=a
this.b=b},
og:function og(){},
Am(a){var s,r
for(s=0;s<5;++s){r=B.bd[s]
if(r.c===a)return r}throw A.b(A.K("Unknown FS implementation: "+a,null))},
Bo(a){var s,r,q,p,o,n,m,l,k,j=null
A:{if(a==null){s=j
r=B.U
break A}q=A.hG(a)
p=q?a:j
if(q){s=p
r=B.P
break A}q=a instanceof A.az
if(q)o=a
else o=j
if(q){s=v.G.BigInt(o.j(0))
r=B.Q
break A}q=typeof a=="number"
n=q?a:j
if(q){s=n
r=B.R
break A}q=typeof a=="string"
m=q?a:j
if(q){s=m
r=B.S
break A}q=t.p.b(a)
l=q?a:j
if(q){s=l
r=B.T
break A}q=A.kO(a)
k=q?a:j
if(q){s=k
r=B.ap
break A}throw A.b(A.K("Unsupported value: "+A.q(a),j))}return new A.a2(r,s)},
vz(a){var s,r,q,p,o,n
if(a instanceof A.ci)return new A.a2(a.a,a.b)
s=[]
r=J.a3(a)
q=r.gk(a)
p=new Uint8Array(q)
for(o=0;o<r.gk(a);++o){n=A.Bo(r.i(a,o))
p[o]=n.a.a
s.push(n.b)}return new A.a2(s,t.a.a(B.f.gan(p)))},
cj:function cj(a,b,c){this.c=a
this.a=b
this.b=c},
bw:function bw(a,b){this.a=a
this.b=b},
ci:function ci(a,b,c){this.a=a
this.b=b
this.c=c},
kR(){var s=0,r=A.i(t.y),q,p=2,o=[],n=[],m,l,k,j,i,h
var $async$kR=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:i=v.G
if(!("indexedDB" in i)||!("FileReader" in i)){q=!1
s=1
break}m=A.S(i.indexedDB)
i=$.hN()
i=i==null?null:A.fV(i,"drift_mock_db",null,null,!1)
s=3
return A.c(t.fP.b(i)?i:A.bO(i,t.b3),$async$kR)
case 3:l=b
p=5
s=8
return A.c(A.A4(m.open("drift_mock_db"),t.m),$async$kR)
case 8:k=b
k.close()
m.deleteDatabase("drift_mock_db")
n.push(7)
s=6
break
case 5:p=4
h=o.pop()
q=!1
n=[1]
s=6
break
n.push(7)
s=6
break
case 4:n=[2]
case 6:p=2
i=l
if(i!=null)i.a.N()
s=n.pop()
break
case 7:q=!0
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$kR,r)},
ut(a){return A.E4(a)},
E4(a){var s=0,r=A.i(t.y),q,p=2,o=[],n,m,l,k,j,i
var $async$ut=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:j={}
j.a=null
p=4
n=A.S(v.G.indexedDB)
m=n.open(a,1)
m.onupgradeneeded=A.bB(new A.uu(j,m))
s=7
return A.c(A.A3(m,t.m),$async$ut)
case 7:l=c
if(j.a==null)j.a=!0
l.close()
p=2
s=6
break
case 4:p=3
i=o.pop()
s=6
break
case 3:s=2
break
case 6:j=j.a
q=j===!0
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$ut,r)},
eR(){var s=0,r=A.i(t.o),q,p=2,o=[],n=[],m,l,k,j,i,h,g
var $async$eR=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:h=A.v4()
if(h==null){q=B.J
s=1
break}j=t.m
s=3
return A.c(A.aq(h.getDirectory(),j),$async$eR)
case 3:m=b
p=5
s=8
return A.c(A.aq(m.getDirectoryHandle("drift_db",{create:!1}),j),$async$eR)
case 8:m=b
p=2
s=7
break
case 5:p=4
g=o.pop()
q=B.J
s=1
break
s=7
break
case 4:s=2
break
case 7:l=A.u([],t.s)
j=new A.bQ(A.ba(A.Al(m),"stream",t.K))
p=9
case 12:s=14
return A.c(j.l(),$async$eR)
case 14:if(!b){s=13
break}k=j.gp()
if(J.z(k.kind,"directory"))J.l0(l,k.name)
s=12
break
case 13:n.push(11)
s=10
break
case 9:n=[2]
case 10:p=2
s=15
return A.c(j.u(),$async$eR)
case 15:s=n.pop()
break
case 11:q=l
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$eR,r)},
A3(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aC(a,"success",new A.lK(r,a,b),!1,q)
A.aC(a,"error",new A.lL(r,a),!1,q)
return s},
A4(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aC(a,"success",new A.lO(r,a,b),!1,q)
A.aC(a,"error",new A.lP(r,a),!1,q)
A.aC(a,"blocked",new A.lQ(r,a),!1,q)
return s},
uu:function uu(a,b){this.a=a
this.b=b},
lK:function lK(a,b,c){this.a=a
this.b=b
this.c=c},
lL:function lL(a,b){this.a=a
this.b=b},
lO:function lO(a,b,c){this.a=a
this.b=b
this.c=c},
lP:function lP(a,b){this.a=a
this.b=b},
lQ:function lQ(a,b){this.a=a
this.b=b},
nV:function nV(a,b){this.a=a
this.b=b},
fc:function fc(a,b){this.a=a
this.b=b},
cs:function cs(a,b){this.a=a
this.b=b},
d2:function d2(a,b){this.a=a
this.b=b},
bp:function bp(a,b){this.a=a
this.b=b},
CW(a){var s=a.go9()
return new A.bz(new A.u2(),s,A.p(s).h("bz<G.T,x>"))},
xF(a,b){var s=A.u([],t.W),r=b==null?a.b:b
return new A.el(a,r,new A.hu(),new A.hu(),new A.hu(),s)},
BR(a,b,c){var s=t.S
s=new A.ek(c,A.u([],t.ba),a.a,new A.ad(new A.l($.m,t.D),t.h),A.Z(s,t.br),A.Z(s,t.m))
s.hA(a)
s.kY(a,b,c)
return s},
yl(a){var s
switch(a.a){case 0:s="/database"
break
case 1:s="/database-journal"
break
default:s=null}return s},
cF(){var s=0,r=A.i(t.kO),q,p=2,o=[],n=[],m,l,k,j,i,h,g,f,e,d,c,b,a
var $async$cF=A.d(function(a0,a1){if(a0===1){o.push(a1)
s=p}for(;;)switch(s){case 0:b=A.v4()
if(b==null){q=B.N
s=1
break}m=null
l=null
k=null
j=null
i=!1
p=4
d=$.hN()
d=d==null?null:A.fV(d,"_drift_feature_detection",null,null,!1)
s=7
return A.c(t.fP.b(d)?d:A.bO(d,t.b3),$async$cF)
case 7:j=a1
d=t.m
s=8
return A.c(A.aq(b.getDirectory(),d),$async$cF)
case 8:m=a1
s=9
return A.c(A.aq(m.getFileHandle("_drift_feature_detection",{create:!0}),d),$async$cF)
case 9:l=a1
s=10
return A.c(A.hK(l),$async$cF)
case 10:h=a1
g=null
f=null
g=h.a
f=h.b
i=g
k=f
e=A.vl(k,"getSize",null,null,null,null)
s=typeof e==="object"?11:12
break
case 11:s=13
return A.c(A.aq(A.S(e),t.X),$async$cF)
case 13:q=B.N
n=[1]
s=5
break
case 12:g=i
q=new A.hp(!0,g)
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:p=3
a=o.pop()
q=B.N
n=[1]
s=5
break
n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
g=j
if(g!=null)g.a.N()
if(k!=null)k.close()
s=m!=null&&l!=null?14:15
break
case 14:s=16
return A.c(A.aq(m.removeEntry("_drift_feature_detection",{recursive:!1}),t.X),$async$cF)
case 16:case 15:s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$cF,r)},
hK(a){return A.DI(a)},
DI(a){var s=0,r=A.i(t.mk),q,p=2,o=[],n,m,l,k,j,i
var $async$hK=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:j=null
p=4
l=t.m
s=7
return A.c(A.aq(a.createSyncAccessHandle({mode:"readwrite-unsafe"}),l),$async$hK)
case 7:j=c
s=8
return A.c(A.aq(a.createSyncAccessHandle({mode:"readwrite-unsafe"}),l),$async$hK)
case 8:n=c
n.close()
l=j
q=new A.a2(!0,l)
s=1
break
p=2
s=6
break
case 4:p=3
i=o.pop()
l=j
if(l!=null)l.close()
s=9
return A.c(A.aq(a.createSyncAccessHandle(),t.m),$async$hK)
case 9:m=c
q=new A.a2(!1,m)
s=1
break
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$hK,r)},
u2:function u2(){},
hu:function hu(){this.a=null},
el:function el(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=null
_.r=1
_.w=f},
r4:function r4(a){this.a=a},
r8:function r8(a,b){this.a=a
this.b=b},
r5:function r5(a,b){this.a=a
this.b=b},
r6:function r6(a){this.a=a},
r7:function r7(a,b){this.a=a
this.b=b},
ek:function ek(a,b,c,d,e,f){var _=this
_.w=a
_.x=b
_.a=c
_.b=d
_.d=_.c=null
_.e=0
_.f=e
_.r=f},
qT:function qT(a){this.a=a},
qW:function qW(a,b,c){this.a=a
this.b=b
this.c=c},
qZ:function qZ(a,b){this.a=a
this.b=b},
r1:function r1(a,b,c){this.a=a
this.b=b
this.c=c},
qV:function qV(a,b){this.a=a
this.b=b},
qU:function qU(a,b){this.a=a
this.b=b},
r0:function r0(a,b){this.a=a
this.b=b},
r_:function r_(a,b){this.a=a
this.b=b},
r3:function r3(a,b){this.a=a
this.b=b},
r2:function r2(a,b){this.a=a
this.b=b},
qX:function qX(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
qY:function qY(a,b){this.a=a
this.b=b},
qS:function qS(a){this.a=a},
id:function id(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=1
_.Q=_.z=_.y=_.x=null},
mB:function mB(a){this.a=a},
mA:function mA(a){this.a=a},
mz:function mz(a,b){this.a=a
this.b=b},
qf:function qf(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=0
_.e=d
_.f=0
_.w=_.r=null
_.x=e
_.y=f
_.Q=$},
qg:function qg(a,b){this.a=a
this.b=b},
qh:function qh(a,b){this.a=a
this.b=b},
qi:function qi(a){this.a=a},
rh:function rh(a){this.a=a},
tG:function tG(){},
rf:function rf(a){this.a=a},
Ci(){return new A.tb(A.jY(new A.tc(),t.z))},
iK:function iK(a){this.a=a},
tb:function tb(a){this.a=null
this.b=a},
tc:function tc(){},
tg:function tg(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
td:function td(a,b){this.a=a
this.b=b},
te:function te(a){this.a=a},
th:function th(a,b){this.a=a
this.b=b},
tf:function tf(a){this.a=a},
jg:function jg(){},
jh:function jh(){},
ot:function ot(a,b,c){this.a=a
this.b=b
this.c=c},
cf:function cf(a){this.a=a},
oj(a,b,c){return A.B9(a,b,c,c)},
B9(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m,l
var $async$oj=A.d(function(e,f){if(e===1){o.push(f)
s=p}for(;;)switch(s){case 0:l=new A.fC(a)
p=3
s=6
return A.c(b.$1(l),$async$oj)
case 6:m=f
q=m
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
l.c=!0
s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$oj,r)},
Ba(a){var s
A:{if(0===a){s=B.bq
break A}s=""+a
s=new A.cy("SAVEPOINT s"+s,"RELEASE s"+s,"ROLLBACK TO s"+s)
break A}return s},
fE(a,b,c){return A.Bb(a,b,c,c)},
Bb(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m,l
var $async$fE=A.d(function(e,f){if(e===1){o.push(f)
s=p}for(;;)switch(s){case 0:l=new A.fD(0,a)
p=3
s=6
return A.c(b.$1(l),$async$fE)
case 6:m=f
s=7
return A.c(a.e4(),$async$fE)
case 7:q=m
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
l.c=!0
s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$fE,r)},
ju:function ju(){},
fC:function fC(a){this.a=a
this.c=this.b=!1},
fD:function fD(a,b){var _=this
_.d=a
_.a=b
_.c=_.b=!1},
jf:function jf(){},
or:function or(a,b){this.a=a
this.b=b},
os:function os(a,b){this.a=a
this.b=b},
Br(a,b,c){return A.DH(new A.pC(),c,a,!0,b,t.en)},
Bq(a){var s,r=A.bs(t.N)
for(s=0;s<1;++s)r.q(0,a[s].toLowerCase())
return new A.ks(new A.pB(r))},
DH(a,b,c,d,e,f){return new A.bA(!1,new A.uj(e,a,c,b,!0,f),f.h("bA<0>"))},
ac:function ac(a){this.a=a},
pC:function pC(){},
pB:function pB(a){this.a=a},
pA:function pA(a){this.a=a},
uj:function uj(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
uk:function uk(a,b){this.a=a
this.b=b},
ul:function ul(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
uf:function uf(a,b,c){this.a=a
this.b=b
this.c=c},
ue:function ue(a,b){this.a=a
this.b=b},
um:function um(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
uo:function uo(a,b){this.a=a
this.b=b},
un:function un(a,b){this.a=a
this.b=b},
ug:function ug(a){this.a=a},
uh:function uh(a,b,c){this.a=a
this.b=b
this.c=c},
ui:function ui(a,b){this.a=a
this.b=b},
xq(a,b,c,d,e,f){var s
if(a==null)return c.$0()
s=A.EH(b,d,e)
a.pJ(s.a,s.b)
return A.dP(c,f).J(new A.pq(a))},
EH(a,b,c){var s,r,q,p,o,n,m=t.z
m=A.Z(m,m)
m.m(0,"sql",c)
s=[]
for(r=b.length,q=t.j,p=0;p<b.length;b.length===r||(0,A.a6)(b),++p){o=b[p]
A:{if(q.b(o)){n="<blob>"
break A}if(o instanceof A.az){n=o.j(0)
break A}n=o
break A}s.push(n)}m.m(0,"parameters",s)
return new A.a2("sqlite_async:"+a+" "+c,m)},
pq:function pq(a){this.a=a},
eP(a,b,c,d){return A.Eu(a,b,c,d,d)},
Eu(a,b,c,d,e){var s=0,r=A.i(e),q,p=2,o=[],n,m,l,k,j
var $async$eP=A.d(function(f,g){if(f===1){o.push(g)
s=p}for(;;)switch(s){case 0:p=4
s=7
return A.c(a.eI(c?"BEGIN IMMEDIATE":"BEGIN"),$async$eP)
case 7:s=8
return A.c(b.$1(a),$async$eP)
case 8:n=g
s=9
return A.c(a.eI("END TRANSACTION"),$async$eP)
case 9:q=n
s=1
break
p=2
s=6
break
case 4:p=3
k=o.pop()
p=11
s=14
return A.c(a.eI("ROLLBACK"),$async$eP)
case 14:p=3
s=13
break
case 11:p=10
j=o.pop()
s=13
break
case 10:s=3
break
case 13:throw k
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$eP,r)},
Bn(a){var s={},r=A.u([],t.jI),q=A.bs(t.N)
s.a=A.u([],t.bO)
return new A.bA(!0,new A.pn(new A.pi(s,r,a,new A.po(q),new A.pl(r,q),new A.pm(q)),new A.pp(s,r)),t.cn)},
po:function po(a){this.a=a},
pl:function pl(a,b){this.a=a
this.b=b},
pm:function pm(a){this.a=a},
pi:function pi(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
pj:function pj(a){this.a=a},
pk:function pk(a){this.a=a},
pp:function pp(a,b){this.a=a
this.b=b},
pn:function pn(a,b){this.a=a
this.b=b},
ph:function ph(a,b){this.a=a
this.b=b},
dt:function dt(a,b){this.a=a
this.b=b},
kV(a,b){return A.EW(a,b,b)},
EW(a,b,c){var s=0,r=A.i(c),q,p=2,o=[],n,m,l,k,j,i,h
var $async$kV=A.d(function(d,e){if(d===1){o.push(e)
s=p}for(;;)switch(s){case 0:p=4
s=7
return A.c(a.$0(),$async$kV)
case 7:j=e
q=j
s=1
break
p=2
s=6
break
case 4:p=3
h=o.pop()
j=A.H(h)
if(j instanceof A.d2){n=j
m=n.b
l=null
if(m!=null){l=m
throw A.b(l)}if(B.a.S(n.a,"Database is not in a transaction"))throw A.b(A.ji(null,null,0,"Transaction rolled back by earlier statement. Cannot execute.",null,null,null))
if(B.a.S("Remote error: "+n.a,"SqliteException")){k=A.at("SqliteException\\((\\d+)\\)",!0)
j=k.jg(n.a)
j=j==null?null:j.i(0,1)
throw A.b(A.ji(null,null,A.yR(j==null?"0":j),n.a,null,null,null))}throw h}else throw h
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$kV,r)},
CX(a,b,c){return A.ir(a,new A.u3(b),c,t.fN)},
jB:function jB(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pY:function pY(a,b){this.a=a
this.b=b},
q0:function q0(a,b){this.a=a
this.b=b},
q_:function q_(a,b){this.a=a
this.b=b},
pZ:function pZ(a,b){this.a=a
this.b=b},
pW:function pW(a,b,c){this.a=a
this.b=b
this.c=c},
pX:function pX(a,b,c){this.a=a
this.b=b
this.c=c},
cc:function cc(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
tA:function tA(a,b,c){this.a=a
this.b=b
this.c=c},
tz:function tz(a,b,c){this.a=a
this.b=b
this.c=c},
ty:function ty(a,b,c){this.a=a
this.b=b
this.c=c},
tx:function tx(a,b,c){this.a=a
this.b=b
this.c=c},
u3:function u3(a){this.a=a},
ve(a,b,c){var s=A.vz(c)
return{rawKind:a.b,rawSql:b,rawParameters:s.a,typeInfo:s.b}},
ch:function ch(a,b){this.a=a
this.b=b},
jv:function jv(a){this.a=0
this.b=a},
px:function px(){},
py:function py(a,b){this.a=a
this.b=b},
pz:function pz(a,b,c){this.a=a
this.b=b
this.c=c},
q4(a){var s=A.Ci()
return new A.q3(s,a)},
q3:function q3(a,b){this.a=a
this.b=b},
q5:function q5(a,b,c){this.a=a
this.b=b
this.c=c},
q7:function q7(a){this.a=a},
q6:function q6(){},
ff:function ff(a){this.a=a},
BS(){return new A.em()},
l9:function l9(){},
hX:function hX(a,b,c){this.a=a
this.b=b
this.c=c},
la:function la(a){this.a=a},
lb:function lb(a,b){this.a=a
this.b=b},
lc:function lc(a,b,c){this.a=a
this.b=b
this.c=c},
em:function em(){this.a=!1
this.b=null},
jm:function jm(a,b,c){this.c=a
this.a=b
this.b=c},
p2:function p2(a,b){var _=this
_.a=a
_.b=b
_.c=0
_.e=_.d=null},
eb:function eb(){},
k2:function k2(){},
bf:function bf(a,b){this.a=a
this.b=b},
aC(a,b,c,d,e){var s
if(c==null)s=null
else{s=A.yH(new A.rm(c),t.m)
s=s==null?null:A.bB(s)}s=new A.eq(a,b,s,!1,e.h("eq<0>"))
s.fw()
return s},
yH(a,b){var s=$.m
if(s===B.e)return a
return s.fI(a,b)},
vf:function vf(a,b){this.a=a
this.$ti=b},
ha:function ha(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
eq:function eq(a,b,c,d,e){var _=this
_.a=0
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
rm:function rm(a){this.a=a},
rn:function rn(a){this.a=a},
q8(a){var s=0,r=A.i(t.m1),q,p,o,n,m
var $async$q8=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=new A.jv(A.Z(t.N,t.ao))
s=3
return A.c(A.Ac(B.aR,v.G.location.href,B.aO,o.go2()).fJ(new A.a2(a.b,a.a)),$async$q8)
case 3:n=c
m=a.c
A:{p=null
if(m!=null){p=A.q4(m)
break A}break A}q=new A.jB(n,p,!1,o.oV(n))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$q8,r)},
z7(a){return v.mangledGlobalNames[a]},
yY(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
AD(a,b){return b in a},
vl(a,b,c,d,e,f){var s
if(c==null)return a[b]()
else if(d==null)return a[b](c)
else if(e==null)return a[b](c,d)
else{s=a[b](c,d,e)
return s}},
wU(a,b){return b in a},
El(a,b,c,d){var s,r,q,p,o,n=A.Z(d,c.h("r<0>"))
for(s=c.h("t<0>"),r=0;r<1;++r){q=a[r]
p=b.$1(q)
o=n.i(0,p)
if(o==null){o=A.u([],s)
n.m(0,p,o)
p=o}else p=o
J.l0(p,q)}return n},
Ax(a,b){var s,r,q
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r){q=a[r]
if(b.$1(q))return q}return null},
wS(a){var s,r,q,p
for(s=A.p(a),r=new A.bE(J.T(a.a),a.b,s.h("bE<1,2>")),s=s.y[1],q=0;r.l();){p=r.a
q+=p==null?s.a(p):p}return q},
wT(a,b){var s,r,q=A.bs(b)
for(s=a.a,s=new A.bc(s,s.r,s.e);s.l();)for(r=J.T(s.d);r.l();)q.q(0,r.gp())
return q},
wa(a){var s,r=a.c.a.i(0,"charset")
if(a.a==="application"&&a.b==="json"&&r==null)return B.k
if(r!=null){s=A.wI(r)
if(s==null)s=B.j}else s=B.j
return s},
z6(a){return a},
z5(a){return new A.cM(a)},
EV(a,b,c){var s,r,q,p
try{q=c.$0()
return q}catch(p){q=A.H(p)
if(q instanceof A.e6){s=q
throw A.b(A.Bf("Invalid "+a+": "+s.a,s.b,s.gdH()))}else if(t.lW.b(q)){r=q
throw A.b(A.ak("Invalid "+a+' "'+b+'": '+r.gjw(),r.gdH(),r.ga7()))}else throw p}},
yN(){var s,r,q,p,o=null
try{o=A.vB()}catch(s){if(t.L.b(A.H(s))){r=$.u0
if(r!=null)return r
throw s}else throw s}if(J.z(o,$.yj)){r=$.u0
r.toString
return r}$.yj=o
if($.wi()===$.hM())r=$.u0=o.dv(".").j(0)
else{q=o.hf()
p=q.length-1
r=$.u0=p===0?q:B.a.t(q,0,p)}return r},
yS(a){var s
if(!(a>=65&&a<=90))s=a>=97&&a<=122
else s=!0
return s},
yO(a,b){var s,r,q=null,p=a.length,o=b+2
if(p<o)return q
if(!A.yS(a.charCodeAt(b)))return q
s=b+1
if(a.charCodeAt(s)!==58){r=b+4
if(p<r)return q
if(B.a.t(a,s,r).toLowerCase()!=="%3a")return q
b=o}s=b+2
if(p===s)return s
if(a.charCodeAt(s)!==47)return q
return b+3},
Ei(a){if(B.a.K(a,"ps_data_local__"))return B.a.a0(a,15)
else if(B.a.K(a,"ps_data__"))return B.a.a0(a,9)
else return null},
As(a){var s=t.N
return t.f.a(B.h.aF(a.h)).bh(0,s,s)},
Ev(a){var s,r,q,p
if(a.gk(0)===0)return!0
s=a.gaf(0)
for(r=A.bM(a,1,null,a.$ti.h("W.E")),q=r.$ti,r=new A.ar(r,r.gk(0),q.h("ar<W.E>")),q=q.h("W.E");r.l();){p=r.d
if(!J.z(p==null?q.a(p):p,s))return!1}return!0},
EI(a,b){var s=B.d.cw(a,null)
if(s<0)throw A.b(A.K(A.q(a)+" contains no null elements.",null))
a[s]=b},
z0(a,b){var s=B.d.cw(a,b)
if(s<0)throw A.b(A.K(A.q(a)+" contains no elements matching "+b.j(0)+".",null))
a[s]=null},
Ea(a,b){var s,r,q,p
for(s=new A.bq(a),r=t.V,s=new A.ar(s,s.gk(0),r.h("ar<A.E>")),r=r.h("A.E"),q=0;s.l();){p=s.d
if((p==null?r.a(p):p)===b)++q}return q},
uy(a,b,c){var s,r,q
if(b.length===0)for(s=0;;){r=B.a.bl(a,"\n",s)
if(r===-1)return a.length-s>=c?s:null
if(r-s>=c)return s
s=r+1}r=B.a.cw(a,b)
while(r!==-1){q=r===0?0:B.a.eh(a,"\n",r-1)+1
if(c===r-q)return q
r=B.a.bl(a,b,r+1)}return null},
w9(a,b,c,d,e,f){var s,r=b.a,q=b.b,p=r.d,o=p.sqlite3_extended_errcode(q),n=p.sqlite3_error_offset(q)
A:{if(n<0){n=null
break A}break A}s=a.a
return new A.d6(A.eh(r.b,p.sqlite3_errmsg(q)),A.eh(s.b,s.d.sqlite3_errstr(o))+" (code "+A.q(o)+")",c,n,d,e,f)},
wg(a,b,c,d,e){throw A.b(A.w9(a.a,a.b,b,c,d,e))},
wP(a,b){var s,r
for(s=b,r=0;r<16;++r)s+=A.aP("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012346789".charCodeAt(a.el(61)))
return s.charCodeAt(0)==0?s:s},
o4(a){var s=0,r=A.i(t.lo),q
var $async$o4=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.aq(a.arrayBuffer(),t.a),$async$o4)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$o4,r)}},B={}
var w=[A,J,B]
var $={}
A.vn.prototype={}
J.iw.prototype={
D(a,b){return a===b},
gv(a){return A.e1(a)},
j(a){return"Instance of '"+A.j_(a)+"'"},
ga3(a){return A.bm(A.w2(this))}}
J.iz.prototype={
j(a){return String(a)},
gv(a){return a?519018:218159},
ga3(a){return A.bm(t.y)},
$ia0:1,
$iI:1}
J.dR.prototype={
D(a,b){return null==b},
j(a){return"null"},
gv(a){return 0},
$ia0:1,
$iF:1}
J.ag.prototype={$ix:1}
J.cm.prototype={
gv(a){return 0},
ga3(a){return B.bO},
j(a){return String(a)}}
J.iY.prototype={}
J.db.prototype={}
J.aY.prototype={
j(a){var s=a[$.za()]
if(s==null)s=a[$.dC()]
if(s==null)return this.kF(a)
return"JavaScript function for "+J.aU(s)}}
J.aO.prototype={
gv(a){return 0},
j(a){return String(a)}}
J.dT.prototype={
gv(a){return 0},
j(a){return String(a)}}
J.t.prototype={
d7(a,b){return new A.al(a,A.a8(a).h("@<1>").H(b).h("al<1,2>"))},
q(a,b){a.$flags&1&&A.C(a,29)
a.push(b)},
eq(a,b){var s
a.$flags&1&&A.C(a,"removeAt",1)
s=a.length
if(b>=s)throw A.b(A.o3(b,null))
return a.splice(b,1)[0]},
ob(a,b,c){var s
a.$flags&1&&A.C(a,"insert",2)
s=a.length
if(b>s)throw A.b(A.o3(b,null))
a.splice(b,0,c)},
fY(a,b,c){var s,r
a.$flags&1&&A.C(a,"insertAll",2)
A.xe(b,0,a.length,"index")
if(!t.O.b(c))c=J.zS(c)
s=J.aE(c)
a.length=a.length+s
r=b+s
this.O(a,r,a.length,a,b)
this.ai(a,b,r,c)},
jI(a){a.$flags&1&&A.C(a,"removeLast",1)
if(a.length===0)throw A.b(A.kT(a,-1))
return a.pop()},
I(a,b){var s
a.$flags&1&&A.C(a,"remove",1)
for(s=0;s<a.length;++s)if(J.z(a[s],b)){a.splice(s,1)
return!0}return!1},
mc(a,b,c){var s,r,q,p=[],o=a.length
for(s=0;s<o;++s){r=a[s]
if(!b.$1(r))p.push(r)
if(a.length!==o)throw A.b(A.ap(a))}q=p.length
if(q===o)return
this.sk(a,q)
for(s=0;s<p.length;++s)a[s]=p[s]},
ab(a,b){var s
a.$flags&1&&A.C(a,"addAll",2)
if(Array.isArray(b)){this.l6(a,b)
return}for(s=J.T(b);s.l();)a.push(s.gp())},
l6(a,b){var s,r=b.length
if(r===0)return
if(a===b)throw A.b(A.ap(a))
for(s=0;s<r;++s)a.push(b[s])},
aC(a){a.$flags&1&&A.C(a,"clear","clear")
a.length=0},
b6(a,b,c){return new A.aa(a,b,A.a8(a).h("@<1>").H(c).h("aa<1,2>"))},
bH(a,b){var s,r=A.b1(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)r[s]=A.q(a[s])
return r.join(b)},
bN(a,b){return A.bM(a,0,A.ba(b,"count",t.S),A.a8(a).c)},
aS(a,b){return A.bM(a,b,null,A.a8(a).c)},
jh(a,b){var s,r,q=a.length
for(s=0;s<q;++s){r=a[s]
if(b.$1(r))return r
if(a.length!==q)throw A.b(A.ap(a))}throw A.b(A.bW())},
T(a,b){return a[b]},
gaf(a){if(a.length>0)return a[0]
throw A.b(A.bW())},
gaO(a){var s=a.length
if(s>0)return a[s-1]
throw A.b(A.bW())},
O(a,b,c,d,e){var s,r,q,p,o
a.$flags&2&&A.C(a,5)
A.aL(b,c,a.length)
s=c-b
if(s===0)return
A.aH(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.l2(d,e).bu(0,!1)
q=0}p=J.a3(r)
if(q+s>p.gk(r))throw A.b(A.wR())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.i(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.i(r,q+o)},
ai(a,b,c,d){return this.O(a,b,c,d,0)},
cN(a,b){var s,r,q,p,o
a.$flags&2&&A.C(a,"sort")
s=a.length
if(s<2)return
if(b==null)b=J.D4()
if(s===2){r=a[0]
q=a[1]
if(b.$2(r,q)>0){a[0]=q
a[1]=r}return}p=0
if(A.a8(a).c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.cG(b,2))
if(p>0)this.md(a,p)},
ky(a){return this.cN(a,null)},
md(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
cw(a,b){var s,r=a.length
if(0>=r)return-1
for(s=0;s<r;++s)if(J.z(a[s],b))return s
return-1},
cA(a,b){var s,r=a.length,q=r-1
if(q<0)return-1
q<r
for(s=q;s>=0;--s)if(J.z(a[s],b))return s
return-1},
S(a,b){var s
for(s=0;s<a.length;++s)if(J.z(a[s],b))return!0
return!1},
gE(a){return a.length===0},
gaN(a){return a.length!==0},
j(a){return A.nu(a,"[","]")},
bu(a,b){var s=A.u(a.slice(0),A.a8(a))
return s},
ev(a){return this.bu(a,!0)},
gA(a){return new J.dE(a,a.length,A.a8(a).h("dE<1>"))},
gv(a){return A.e1(a)},
gk(a){return a.length},
sk(a,b){a.$flags&1&&A.C(a,"set length","change the length of")
if(b<0)throw A.b(A.ab(b,0,null,"newLength",null))
if(b>a.length)A.a8(a).c.a(null)
a.length=b},
i(a,b){if(!(b>=0&&b<a.length))throw A.b(A.kT(a,b))
return a[b]},
m(a,b,c){a.$flags&2&&A.C(a)
if(!(b>=0&&b<a.length))throw A.b(A.kT(a,b))
a[b]=c},
oa(a,b){var s
if(0>=a.length)return-1
for(s=0;s<a.length;++s)if(b.$1(a[s]))return s
return-1},
ga3(a){return A.bm(A.a8(a))},
$iaF:1,
$iw:1,
$in:1,
$ir:1}
J.iy.prototype={
oU(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.j_(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.nv.prototype={}
J.dE.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
l(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.b(A.a6(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0}}
J.dS.prototype={
Z(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gh0(b)
if(this.gh0(a)===s)return 0
if(this.gh0(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gh0(a){return a===0?1/a<0:a<0},
mX(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.b(A.Q(""+a+".ceil()"))},
mY(a,b,c){if(B.b.Z(b,c)>0)throw A.b(A.dy(b))
if(this.Z(a,b)<0)return b
if(this.Z(a,c)>0)return c
return a},
oS(a,b){var s,r,q,p
if(b<2||b>36)throw A.b(A.ab(b,2,36,"radix",null))
s=a.toString(b)
if(s.charCodeAt(s.length-1)!==41)return s
r=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(r==null)A.v(A.Q("Unexpected toString result: "+s))
s=r[1]
q=+r[3]
p=r[2]
if(p!=null){s+=p
q-=p.length}return s+B.a.aH("0",q)},
j(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gv(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
dD(a,b){return a+b},
aR(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
hz(a,b){if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.iH(a,b)},
V(a,b){return(a|0)===a?a/b|0:this.iH(a,b)},
iH(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.b(A.Q("Result of truncating division is "+A.q(s)+": "+A.q(a)+" ~/ "+b))},
cL(a,b){if(b<0)throw A.b(A.dy(b))
return b>31?0:a<<b>>>0},
cM(a,b){var s
if(b<0)throw A.b(A.dy(b))
if(a>0)s=this.fu(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
a1(a,b){var s
if(a>0)s=this.fu(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
mq(a,b){if(0>b)throw A.b(A.dy(b))
return this.fu(a,b)},
fu(a,b){return b>31?0:a>>>b},
kr(a,b){return a>b},
ga3(a){return A.bm(t.q)},
$ia7:1,
$iY:1}
J.fi.prototype={
gj_(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.V(q,4294967296)
s+=32}return s-Math.clz32(q)},
ga3(a){return A.bm(t.S)},
$ia0:1,
$ia:1}
J.iA.prototype={
ga3(a){return A.bm(t.i)},
$ia0:1}
J.cl.prototype={
fF(a,b,c){var s=b.length
if(c>s)throw A.b(A.ab(c,0,s,null,null))
return new A.ku(b,a,c)},
e1(a,b){return this.fF(a,b,0)},
cC(a,b,c){var s,r,q=null
if(c<0||c>b.length)throw A.b(A.ab(c,0,b.length,q,q))
s=a.length
if(c+s>b.length)return q
for(r=0;r<s;++r)if(b.charCodeAt(c+r)!==a.charCodeAt(r))return q
return new A.fK(c,a)},
bE(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.a0(a,r-s)},
dI(a,b){var s=A.u(a.split(b),t.s)
return s},
c5(a,b,c,d){var s=A.aL(b,c,a.length)
return A.z3(a,b,s,d)},
P(a,b,c){var s
if(c<0||c>a.length)throw A.b(A.ab(c,0,a.length,null,null))
s=c+b.length
if(s>a.length)return!1
return b===a.substring(c,s)},
K(a,b){return this.P(a,b,0)},
t(a,b,c){return a.substring(b,A.aL(b,c,a.length))},
a0(a,b){return this.t(a,b,null)},
aH(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.b(B.aJ)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
oB(a,b,c){var s=b-a.length
if(s<=0)return a
return this.aH(c,s)+a},
oC(a,b){var s=b-a.length
if(s<=0)return a
return a+this.aH(" ",s)},
bl(a,b,c){var s
if(c<0||c>a.length)throw A.b(A.ab(c,0,a.length,null,null))
s=a.indexOf(b,c)
return s},
cw(a,b){return this.bl(a,b,0)},
eh(a,b,c){var s,r
if(c==null)c=a.length
else if(c<0||c>a.length)throw A.b(A.ab(c,0,a.length,null,null))
s=b.length
r=a.length
if(c+s>r)c=r-s
return a.lastIndexOf(b,c)},
cA(a,b){return this.eh(a,b,null)},
S(a,b){return A.EP(a,b,0)},
Z(a,b){var s
if(a===b)s=0
else s=a<b?-1:1
return s},
j(a){return a},
gv(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
ga3(a){return A.bm(t.N)},
gk(a){return a.length},
i(a,b){if(!(b>=0&&b<a.length))throw A.b(A.kT(a,b))
return a[b]},
$iaF:1,
$ia0:1,
$ia7:1,
$ij:1}
A.eY.prototype={
gap(){return this.a.gap()},
B(a,b,c,d){var s=this.a.bn(null,b,c),r=new A.dG(s,$.m,this.$ti.h("dG<1,2>"))
s.bq(r.gl3())
r.bq(a)
r.dq(d)
return r},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.dG.prototype={
u(){return this.a.u()},
bq(a){this.c=a==null?null:this.b.bL(a,t.z,this.$ti.y[1])},
dq(a){var s=this
s.a.dq(a)
if(a==null)s.d=null
else if(t.r.b(a))s.d=s.b.cE(a,t.z,t.K,t.l)
else if(t.i6.b(a))s.d=s.b.bL(a,t.z,t.K)
else throw A.b(A.K(u.y,null))},
l4(a){var s,r,q,p,o,n,m=this,l=m.c
if(l==null)return
s=null
try{s=m.$ti.y[1].a(a)}catch(o){r=A.H(o)
q=A.O(o)
p=m.d
if(p==null)m.b.cv(r,q)
else{l=t.K
n=m.b
if(t.r.b(p))n.hd(p,r,q,l,t.l)
else n.c6(t.i6.a(p),r,l)}return}m.b.c6(l,s,m.$ti.y[1])},
aG(a){this.a.aG(a)},
ah(){return this.aG(null)},
aj(){this.a.aj()},
$iah:1}
A.cw.prototype={
gA(a){return new A.i5(J.T(this.gb4()),A.p(this).h("i5<1,2>"))},
gk(a){return J.aE(this.gb4())},
gE(a){return J.l1(this.gb4())},
gaN(a){return J.zM(this.gb4())},
aS(a,b){var s=A.p(this)
return A.i4(J.l2(this.gb4(),b),s.c,s.y[1])},
bN(a,b){var s=A.p(this)
return A.i4(J.wu(this.gb4(),b),s.c,s.y[1])},
T(a,b){return A.p(this).y[1].a(J.hO(this.gb4(),b))},
S(a,b){return J.wr(this.gb4(),b)},
j(a){return J.aU(this.gb4())}}
A.i5.prototype={
l(){return this.a.l()},
gp(){return this.$ti.y[1].a(this.a.gp())}}
A.cN.prototype={
gb4(){return this.a}}
A.h8.prototype={$iw:1}
A.h2.prototype={
i(a,b){return this.$ti.y[1].a(J.eT(this.a,b))},
m(a,b,c){J.l_(this.a,b,this.$ti.c.a(c))},
sk(a,b){J.zP(this.a,b)},
q(a,b){J.l0(this.a,this.$ti.c.a(b))},
cN(a,b){var s=b==null?null:new A.qQ(this,b)
J.wt(this.a,s)},
O(a,b,c,d,e){var s=this.$ti
J.zQ(this.a,b,c,A.i4(d,s.y[1],s.c),e)},
ai(a,b,c,d){return this.O(0,b,c,d,0)},
$iw:1,
$ir:1}
A.qQ.prototype={
$2(a,b){var s=this.a.$ti.y[1]
return this.b.$2(s.a(a),s.a(b))},
$S(){return this.a.$ti.h("a(1,1)")}}
A.al.prototype={
d7(a,b){return new A.al(this.a,this.$ti.h("@<1>").H(b).h("al<1,2>"))},
gb4(){return this.a}}
A.cO.prototype={
bh(a,b,c){return new A.cO(this.a,this.$ti.h("@<1,2>").H(b).H(c).h("cO<1,2,3,4>"))},
G(a){return this.a.G(a)},
i(a,b){return this.$ti.h("4?").a(this.a.i(0,b))},
m(a,b,c){var s=this.$ti
this.a.m(0,s.c.a(b),s.y[1].a(c))},
ac(a,b){this.a.ac(0,new A.lC(this,b))},
ga2(){var s=this.$ti
return A.i4(this.a.ga2(),s.c,s.y[2])},
gk(a){var s=this.a
return s.gk(s)},
gE(a){var s=this.a
return s.gE(s)},
gbj(){var s=this.a.gbj()
return s.b6(s,new A.lB(this),this.$ti.h("M<3,4>"))}}
A.lC.prototype={
$2(a,b){var s=this.a.$ti
this.b.$2(s.y[2].a(a),s.y[3].a(b))},
$S(){return this.a.$ti.h("~(1,2)")}}
A.lB.prototype={
$1(a){var s=this.a.$ti
return new A.M(s.y[2].a(a.a),s.y[3].a(a.b),s.h("M<3,4>"))},
$S(){return this.a.$ti.h("M<3,4>(M<1,2>)")}}
A.cX.prototype={
j(a){return"LateInitializationError: "+this.a}}
A.bq.prototype={
gk(a){return this.a.length},
i(a,b){return this.a.charCodeAt(b)}}
A.uV.prototype={
$0(){return A.mS(null,t.H)},
$S:3}
A.ok.prototype={}
A.w.prototype={}
A.W.prototype={
gA(a){var s=this
return new A.ar(s,s.gk(s),A.p(s).h("ar<W.E>"))},
gE(a){return this.gk(this)===0},
gaf(a){if(this.gk(this)===0)throw A.b(A.bW())
return this.T(0,0)},
S(a,b){var s,r=this,q=r.gk(r)
for(s=0;s<q;++s){if(J.z(r.T(0,s),b))return!0
if(q!==r.gk(r))throw A.b(A.ap(r))}return!1},
bH(a,b){var s,r,q,p=this,o=p.gk(p)
if(b.length!==0){if(o===0)return""
s=A.q(p.T(0,0))
if(o!==p.gk(p))throw A.b(A.ap(p))
for(r=s,q=1;q<o;++q){r=r+b+A.q(p.T(0,q))
if(o!==p.gk(p))throw A.b(A.ap(p))}return r.charCodeAt(0)==0?r:r}else{for(q=0,r="";q<o;++q){r+=A.q(p.T(0,q))
if(o!==p.gk(p))throw A.b(A.ap(p))}return r.charCodeAt(0)==0?r:r}},
oe(a){return this.bH(0,"")},
b6(a,b,c){return new A.aa(this,b,A.p(this).h("@<W.E>").H(c).h("aa<1,2>"))},
oI(a,b){var s,r,q=this,p=q.gk(q)
if(p===0)throw A.b(A.bW())
s=q.T(0,0)
for(r=1;r<p;++r){s=b.$2(s,q.T(0,r))
if(p!==q.gk(q))throw A.b(A.ap(q))}return s},
aS(a,b){return A.bM(this,b,null,A.p(this).h("W.E"))},
bN(a,b){return A.bM(this,0,A.ba(b,"count",t.S),A.p(this).h("W.E"))},
ew(a){var s,r=this,q=A.vq(A.p(r).h("W.E"))
for(s=0;s<r.gk(r);++s)q.q(0,r.T(0,s))
return q}}
A.d8.prototype={
kT(a,b,c,d){var s,r=this.b
A.aH(r,"start")
s=this.c
if(s!=null){A.aH(s,"end")
if(r>s)throw A.b(A.ab(r,0,s,"start",null))}},
glp(){var s=J.aE(this.a),r=this.c
if(r==null||r>s)return s
return r},
gms(){var s=J.aE(this.a),r=this.b
if(r>s)return s
return r},
gk(a){var s,r=J.aE(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
T(a,b){var s=this,r=s.gms()+b
if(b<0||r>=s.glp())throw A.b(A.it(b,s.gk(0),s,null,"index"))
return J.hO(s.a,r)},
aS(a,b){var s,r,q=this
A.aH(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.cU(q.$ti.h("cU<1>"))
return A.bM(q.a,s,r,q.$ti.c)},
bN(a,b){var s,r,q,p=this
A.aH(b,"count")
s=p.c
r=p.b
if(s==null)return A.bM(p.a,r,B.b.dD(r,b),p.$ti.c)
else{q=B.b.dD(r,b)
if(s<q)return p
return A.bM(p.a,r,q,p.$ti.c)}},
bu(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.a3(n),l=m.gk(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=p.$ti.c
return b?J.vk(0,n):J.vj(0,n)}r=A.b1(s,m.T(n,o),b,p.$ti.c)
for(q=1;q<s;++q){r[q]=m.T(n,o+q)
if(m.gk(n)<l)throw A.b(A.ap(p))}return r}}
A.ar.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
l(){var s,r=this,q=r.a,p=J.a3(q),o=p.gk(q)
if(r.b!==o)throw A.b(A.ap(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.T(q,s);++r.c
return!0}}
A.bX.prototype={
gA(a){return new A.bE(J.T(this.a),this.b,A.p(this).h("bE<1,2>"))},
gk(a){return J.aE(this.a)},
gE(a){return J.l1(this.a)},
T(a,b){return this.b.$1(J.hO(this.a,b))}}
A.cT.prototype={$iw:1}
A.bE.prototype={
l(){var s=this,r=s.b
if(r.l()){s.a=s.c.$1(r.gp())
return!0}s.a=null
return!1},
gp(){var s=this.a
return s==null?this.$ti.y[1].a(s):s}}
A.aa.prototype={
gk(a){return J.aE(this.a)},
T(a,b){return this.b.$1(J.hO(this.a,b))}}
A.c6.prototype={
gA(a){return new A.eg(J.T(this.a),this.b)},
b6(a,b,c){return new A.bX(this,b,this.$ti.h("@<1>").H(c).h("bX<1,2>"))}}
A.eg.prototype={
l(){var s,r
for(s=this.a,r=this.b;s.l();)if(r.$1(s.gp()))return!0
return!1},
gp(){return this.a.gp()}}
A.fa.prototype={
gA(a){return new A.il(J.T(this.a),this.b,B.Y,this.$ti.h("il<1,2>"))}}
A.il.prototype={
gp(){var s=this.d
return s==null?this.$ti.y[1].a(s):s},
l(){var s,r,q=this,p=q.c
if(p==null)return!1
for(s=q.a,r=q.b;!p.l();){q.d=null
if(s.l()){q.c=null
p=J.T(r.$1(s.gp()))
q.c=p}else return!1}q.d=q.c.gp()
return!0}}
A.da.prototype={
gA(a){var s=this.a
return new A.jp(s.gA(s),this.b,A.p(this).h("jp<1>"))}}
A.f8.prototype={
gk(a){var s=this.a,r=s.gk(s)
s=this.b
if(B.b.kr(r,s))return s
return r},
$iw:1}
A.jp.prototype={
l(){if(--this.b>=0)return this.a.l()
this.b=-1
return!1},
gp(){if(this.b<0){this.$ti.c.a(null)
return null}return this.a.gp()}}
A.c0.prototype={
aS(a,b){A.hR(b,"count")
A.aH(b,"count")
return new A.c0(this.a,this.b+b,A.p(this).h("c0<1>"))},
gA(a){var s=this.a
return new A.j8(s.gA(s),this.b)}}
A.dM.prototype={
gk(a){var s=this.a,r=s.gk(s)-this.b
if(r>=0)return r
return 0},
aS(a,b){A.hR(b,"count")
A.aH(b,"count")
return new A.dM(this.a,this.b+b,this.$ti)},
$iw:1}
A.j8.prototype={
l(){var s,r
for(s=this.a,r=0;r<this.b;++r)s.l()
this.b=0
return s.l()},
gp(){return this.a.gp()}}
A.cU.prototype={
gA(a){return B.Y},
gE(a){return!0},
gk(a){return 0},
T(a,b){throw A.b(A.ab(b,0,0,"index",null))},
S(a,b){return!1},
b6(a,b,c){return new A.cU(c.h("cU<0>"))},
aS(a,b){A.aH(b,"count")
return this},
bN(a,b){A.aH(b,"count")
return this},
bu(a,b){var s=this.$ti.c
return b?J.vk(0,s):J.vj(0,s)}}
A.ig.prototype={
l(){return!1},
gp(){throw A.b(A.bW())}}
A.fW.prototype={
gA(a){return new A.jC(J.T(this.a),this.$ti.h("jC<1>"))}}
A.jC.prototype={
l(){var s,r
for(s=this.a,r=this.$ti.c;s.l();)if(r.b(s.gp()))return!0
return!1},
gp(){return this.$ti.c.a(this.a.gp())}}
A.fz.prototype={
gi2(){var s,r,q
for(s=this.a,r=A.p(s),s=new A.bE(J.T(s.a),s.b,r.h("bE<1,2>")),r=r.y[1];s.l();){q=s.a
if(q==null)q=r.a(q)
if(q!=null)return q}return null},
gE(a){return this.gi2()==null},
gaN(a){return this.gi2()!=null},
gA(a){var s=this.a
return new A.iS(new A.bE(J.T(s.a),s.b,A.p(s).h("bE<1,2>")))}}
A.iS.prototype={
l(){var s,r,q
this.b=null
for(s=this.a,r=s.$ti.y[1];s.l();){q=s.a
if(q==null)q=r.a(q)
if(q!=null){this.b=q
return!0}}return!1},
gp(){var s=this.b
return s==null?A.v(A.bW()):s}}
A.fd.prototype={
sk(a,b){throw A.b(A.Q(u.O))},
q(a,b){throw A.b(A.Q("Cannot add to a fixed-length list"))}}
A.js.prototype={
m(a,b,c){throw A.b(A.Q("Cannot modify an unmodifiable list"))},
sk(a,b){throw A.b(A.Q("Cannot change the length of an unmodifiable list"))},
q(a,b){throw A.b(A.Q("Cannot add to an unmodifiable list"))},
cN(a,b){throw A.b(A.Q("Cannot modify an unmodifiable list"))},
O(a,b,c,d,e){throw A.b(A.Q("Cannot modify an unmodifiable list"))},
ai(a,b,c,d){return this.O(0,b,c,d,0)}}
A.ec.prototype={}
A.d4.prototype={
gk(a){return J.aE(this.a)},
T(a,b){var s=this.a,r=J.a3(s)
return r.T(s,r.gk(s)-1-b)}}
A.jn.prototype={
gv(a){var s=this._hashCode
if(s!=null)return s
s=664597*B.a.gv(this.a)&536870911
this._hashCode=s
return s},
j(a){return'Symbol("'+this.a+'")'},
D(a,b){if(b==null)return!1
return b instanceof A.jn&&this.a===b.a}}
A.hF.prototype={}
A.ho.prototype={$r:"+immediateRestart(1)",$s:1}
A.a2.prototype={$r:"+(1,2)",$s:2}
A.hp.prototype={$r:"+basicSupport,supportsReadWriteUnsafe(1,2)",$s:3}
A.hq.prototype={$r:"+controller,sync(1,2)",$s:4}
A.kd.prototype={$r:"+downloaded,total(1,2)",$s:5}
A.ez.prototype={$r:"+file,outFlags(1,2)",$s:6}
A.ke.prototype={$r:"+name,parameters(1,2)",$s:7}
A.kf.prototype={$r:"+result,resultCode(1,2)",$s:8}
A.cy.prototype={$r:"+(1,2,3)",$s:9}
A.kg.prototype={$r:"+autocommit,lastInsertRowid,result(1,2,3)",$s:10}
A.kh.prototype={$r:"+connectName,connectPort,lockName(1,2,3)",$s:11}
A.ki.prototype={$r:"+hasSynced,lastSyncedAt,priority(1,2,3)",$s:12}
A.kj.prototype={$r:"+atLast,priority,sinceLast,targetCount(1,2,3,4)",$s:13}
A.f0.prototype={
bh(a,b,c){var s=A.p(this)
return A.x0(this,s.c,s.y[1],b,c)},
gE(a){return this.gk(this)===0},
j(a){return A.nF(this)},
m(a,b,c){A.A7()},
gbj(){return new A.eD(this.nA(),A.p(this).h("eD<M<1,2>>"))},
nA(){var s=this
return function(){var r=0,q=1,p=[],o,n,m
return function $async$gbj(a,b,c){if(b===1){p.push(c)
r=q}for(;;)switch(r){case 0:o=s.ga2(),o=o.gA(o),n=A.p(s).h("M<1,2>")
case 2:if(!o.l()){r=3
break}m=o.gp()
r=4
return a.b=new A.M(m,s.i(0,m),n),1
case 4:r=2
break
case 3:return 0
case 1:return a.c=p.at(-1),3}}}},
cB(a,b,c,d){var s=A.Z(c,d)
this.ac(0,new A.lX(this,b,s))
return s},
$ia_:1}
A.lX.prototype={
$2(a,b){var s=this.b.$2(a,b)
this.c.m(0,s.a,s.b)},
$S(){return A.p(this.a).h("~(1,2)")}}
A.aW.prototype={
gk(a){return this.b.length},
gic(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
G(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
i(a,b){if(!this.G(b))return null
return this.b[this.a[b]]},
ac(a,b){var s,r,q=this.gic(),p=this.b
for(s=q.length,r=0;r<s;++r)b.$2(q[r],p[r])},
ga2(){return new A.hf(this.gic(),this.$ti.h("hf<1>"))}}
A.hf.prototype={
gk(a){return this.a.length},
gE(a){return 0===this.a.length},
gaN(a){return 0!==this.a.length},
gA(a){var s=this.a
return new A.et(s,s.length,this.$ti.h("et<1>"))}}
A.et.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
l(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0}}
A.f1.prototype={
q(a,b){A.A8()}}
A.f2.prototype={
gk(a){return this.b},
gE(a){return this.b===0},
gaN(a){return this.b!==0},
gA(a){var s,r=this,q=r.$keys
if(q==null){q=Object.keys(r.a)
r.$keys=q}s=q
return new A.et(s,s.length,r.$ti.h("et<1>"))},
S(a,b){if(typeof b!="string")return!1
if("__proto__"===b)return!1
return this.a.hasOwnProperty(b)},
ew(a){return A.AH(this,this.$ti.c)}}
A.nn.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.fh&&this.a.D(0,b.a)&&A.wc(this)===A.wc(b)},
gv(a){return A.bG(this.a,A.wc(this),B.c,B.c,B.c,B.c,B.c,B.c,B.c,B.c)},
j(a){var s=B.d.bH([A.bm(this.$ti.c)],", ")
return this.a.j(0)+" with "+("<"+s+">")}}
A.fh.prototype={
$1(a){return this.a.$1$1(a,this.$ti.y[0])},
$2(a,b){return this.a.$1$2(a,b,this.$ti.y[0])},
$4(a,b,c,d){return this.a.$1$4(a,b,c,d,this.$ti.y[0])},
$S(){return A.Es(A.kS(this.a),this.$ti)}}
A.fB.prototype={}
A.ps.prototype={
b7(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.fA.prototype={
j(a){return"Null check operator used on a null value"}}
A.iB.prototype={
j(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.jr.prototype={
j(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.iU.prototype={
j(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"},
$iP:1}
A.f9.prototype={}
A.ht.prototype={
j(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iae:1}
A.cP.prototype={
j(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.z8(r==null?"unknown":r)+"'"},
ga3(a){var s=A.kS(this)
return A.bm(s==null?A.bn(this):s)},
gpH(){return this},
$C:"$1",
$R:1,
$D:null}
A.lI.prototype={$C:"$0",$R:0}
A.lJ.prototype={$C:"$2",$R:2}
A.pg.prototype={}
A.ov.prototype={
j(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.z8(s)+"'"}}
A.eW.prototype={
D(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.eW))return!1
return this.$_target===b.$_target&&this.a===b.a},
gv(a){return(A.kU(this.a)^A.e1(this.$_target))>>>0},
j(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.j_(this.a)+"'")}}
A.j5.prototype={
j(a){return"RuntimeError: "+this.a}}
A.b_.prototype={
gk(a){return this.a},
gE(a){return this.a===0},
ga2(){return new A.b0(this,A.p(this).h("b0<1>"))},
gbj(){return new A.ax(this,A.p(this).h("ax<1,2>"))},
G(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.jr(a)},
jr(a){var s=this.d
if(s==null)return!1
return this.cz(this.i6(s,a),a)>=0},
ab(a,b){b.ac(0,new A.nw(this))},
i(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.js(b)},
js(a){var s,r,q=this.d
if(q==null)return null
s=this.i6(q,a)
r=this.cz(s,a)
if(r<0)return null
return s[r].b},
m(a,b,c){var s,r,q=this
if(typeof b=="string"){s=q.b
q.hD(s==null?q.b=q.fn():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.hD(r==null?q.c=q.fn():r,b,c)}else q.ju(b,c)},
ju(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=p.fn()
s=p.dl(a)
r=o[s]
if(r==null)o[s]=[p.fo(a,b)]
else{q=p.cz(r,a)
if(q>=0)r[q].b=b
else r.push(p.fo(a,b))}},
cD(a,b){var s,r,q=this
if(q.G(a)){s=q.i(0,a)
return s==null?A.p(q).y[1].a(s):s}r=b.$0()
q.m(0,a,r)
return r},
I(a,b){var s=this
if(typeof b=="string")return s.iv(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.iv(s.c,b)
else return s.jt(b)},
jt(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.dl(a)
r=n[s]
q=o.cz(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.iM(p)
if(r.length===0)delete n[s]
return p.b},
aC(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.fm()}},
ac(a,b){var s=this,r=s.e,q=s.r
while(r!=null){b.$2(r.a,r.b)
if(q!==s.r)throw A.b(A.ap(s))
r=r.c}},
hD(a,b,c){var s=a[b]
if(s==null)a[b]=this.fo(b,c)
else s.b=c},
iv(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.iM(s)
delete a[b]
return s.b},
fm(){this.r=this.r+1&1073741823},
fo(a,b){var s,r=this,q=new A.nz(a,b)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.d=s
r.f=s.c=q}++r.a
r.fm()
return q},
iM(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.fm()},
dl(a){return J.y(a)&1073741823},
i6(a,b){return a[this.dl(b)]},
cz(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.z(a[r].a,b))return r
return-1},
j(a){return A.nF(this)},
fn(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s}}
A.nw.prototype={
$2(a,b){this.a.m(0,a,b)},
$S(){return A.p(this.a).h("~(1,2)")}}
A.nz.prototype={}
A.b0.prototype={
gk(a){return this.a.a},
gE(a){return this.a.a===0},
gA(a){var s=this.a
return new A.fn(s,s.r,s.e)},
S(a,b){return this.a.G(b)}}
A.fn.prototype={
gp(){return this.d},
l(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.b(A.ap(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}}}
A.bd.prototype={
gk(a){return this.a.a},
gE(a){return this.a.a===0},
gA(a){var s=this.a
return new A.bc(s,s.r,s.e)}}
A.bc.prototype={
gp(){return this.d},
l(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.b(A.ap(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}}}
A.ax.prototype={
gk(a){return this.a.a},
gE(a){return this.a.a===0},
gA(a){var s=this.a
return new A.iI(s,s.r,s.e,this.$ti.h("iI<1,2>"))}}
A.iI.prototype={
gp(){var s=this.d
s.toString
return s},
l(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.b(A.ap(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.M(s.a,s.b,r.$ti.h("M<1,2>"))
r.c=s.c
return!0}}}
A.fk.prototype={
dl(a){return A.kU(a)&1073741823},
cz(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;++r){q=a[r].a
if(q==null?b==null:q===b)return r}return-1}}
A.uF.prototype={
$1(a){return this.a(a)},
$S:45}
A.uG.prototype={
$2(a,b){return this.a(a,b)},
$S:79}
A.uH.prototype={
$1(a){return this.a(a)},
$S:139}
A.hn.prototype={
ga3(a){return A.bm(this.i7())},
i7(){return A.Ef(this.$r,this.cU())},
j(a){return this.iL(!1)},
iL(a){var s,r,q,p,o,n=this.lt(),m=this.cU(),l=(a?"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
o=m[q]
l=a?l+A.xc(o):l+A.q(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
lt(){var s,r=this.$s
while($.t4.length<=r)$.t4.push(null)
s=$.t4[r]
if(s==null){s=this.lg()
$.t4[r]=s}return s},
lg(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=A.u(new Array(l),t.hf)
for(s=0;s<l;++s)k[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
k[q]=r[s]}}return A.nC(k,t.K)}}
A.ka.prototype={
cU(){return[this.a,this.b]},
D(a,b){if(b==null)return!1
return b instanceof A.ka&&this.$s===b.$s&&J.z(this.a,b.a)&&J.z(this.b,b.b)},
gv(a){return A.bG(this.$s,this.a,this.b,B.c,B.c,B.c,B.c,B.c,B.c,B.c)}}
A.k9.prototype={
cU(){return[this.a]},
D(a,b){if(b==null)return!1
return b instanceof A.k9&&this.$s===b.$s&&J.z(this.a,b.a)},
gv(a){return A.bG(this.$s,this.a,B.c,B.c,B.c,B.c,B.c,B.c,B.c,B.c)}}
A.kb.prototype={
cU(){return[this.a,this.b,this.c]},
D(a,b){var s=this
if(b==null)return!1
return b instanceof A.kb&&s.$s===b.$s&&J.z(s.a,b.a)&&J.z(s.b,b.b)&&J.z(s.c,b.c)},
gv(a){var s=this
return A.bG(s.$s,s.a,s.b,s.c,B.c,B.c,B.c,B.c,B.c,B.c)}}
A.kc.prototype={
cU(){return this.a},
D(a,b){if(b==null)return!1
return b instanceof A.kc&&this.$s===b.$s&&A.Cg(this.a,b.a)},
gv(a){return A.bG(this.$s,A.AS(this.a),B.c,B.c,B.c,B.c,B.c,B.c,B.c,B.c)}}
A.fj.prototype={
j(a){return"RegExp/"+this.a+"/"+this.b.flags},
glP(){var s=this,r=s.c
if(r!=null)return r
r=s.b
return s.c=A.vm(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,"g")},
glO(){var s=this,r=s.d
if(r!=null)return r
r=s.b
return s.d=A.vm(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,"y")},
jg(a){var s=this.b.exec(a)
if(s==null)return null
return new A.ex(s)},
fF(a,b,c){var s=b.length
if(c>s)throw A.b(A.ab(c,0,s,null,null))
return new A.jG(this,b,c)},
e1(a,b){return this.fF(0,b,0)},
ls(a,b){var s,r=this.glP()
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.ex(s)},
lr(a,b){var s,r=this.glO()
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.ex(s)},
cC(a,b,c){if(c<0||c>b.length)throw A.b(A.ab(c,0,b.length,null,null))
return this.lr(b,c)}}
A.ex.prototype={
gC(){var s=this.b
return s.index+s[0].length},
i(a,b){return this.b[b]},
$icZ:1,
$ij1:1}
A.jG.prototype={
gA(a){return new A.jH(this.a,this.b,this.c)}}
A.jH.prototype={
gp(){var s=this.d
return s==null?t.lu.a(s):s},
l(){var s,r,q,p,o,n,m=this,l=m.b
if(l==null)return!1
s=m.c
r=l.length
if(s<=r){q=m.a
p=q.ls(l,s)
if(p!=null){m.d=p
o=p.gC()
if(p.b.index===o){s=!1
if(q.b.unicode){q=m.c
n=q+1
if(n<r){r=l.charCodeAt(q)
if(r>=55296&&r<=56319){s=l.charCodeAt(n)
s=s>=56320&&s<=57343}}}o=(s?o+1:o)+1}m.c=o
return!0}}m.b=m.d=null
return!1}}
A.fK.prototype={
gC(){return this.a+this.c.length},
i(a,b){if(b!==0)throw A.b(A.o3(b,null))
return this.c},
$icZ:1}
A.ku.prototype={
gA(a){return new A.tn(this.a,this.b,this.c)}}
A.tn.prototype={
l(){var s,r,q=this,p=q.c,o=q.b,n=o.length,m=q.a,l=m.length
if(p+n>l){q.d=null
return!1}s=m.indexOf(o,p)
if(s<0){q.c=l+1
q.d=null
return!1}r=s+n
q.d=new A.fK(s,o)
q.c=r===q.c?r+1:r
return!0},
gp(){var s=this.d
s.toString
return s}}
A.jQ.prototype={
dQ(){var s=this.b
if(s===this)throw A.b(new A.cX("Local '"+this.a+"' has not been initialized."))
return s},
aT(){var s=this.b
if(s===this)throw A.b(A.wX(this.a))
return s}}
A.dY.prototype={
gjv(a){return a.byteLength},
ga3(a){return B.bH},
e2(a,b,c){A.kM(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
iW(a){return this.e2(a,0,null)},
$ia0:1,
$icL:1}
A.bF.prototype={$ibF:1}
A.fw.prototype={
gan(a){if(((a.$flags|0)&2)!==0)return new A.kC(a.buffer)
else return a.buffer},
lG(a,b,c,d){var s=A.ab(b,0,c,d,null)
throw A.b(s)},
hI(a,b,c,d){if(b>>>0!==b||b>c)this.lG(a,b,c,d)}}
A.kC.prototype={
gjv(a){return this.a.byteLength},
e2(a,b,c){var s=A.b3(this.a,b,c)
s.$flags=3
return s},
iW(a){return this.e2(0,0,null)},
$icL:1}
A.fv.prototype={
ga3(a){return B.bI},
$ia0:1,
$ivc:1}
A.dZ.prototype={
gk(a){return a.length},
iD(a,b,c,d,e){var s,r,q=a.length
this.hI(a,b,q,"start")
this.hI(a,c,q,"end")
if(b>c)throw A.b(A.ab(b,0,c,null,null))
s=c-b
if(e<0)throw A.b(A.K(e,null))
r=d.length
if(r-e<s)throw A.b(A.D("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iaF:1,
$iaZ:1}
A.co.prototype={
i(a,b){A.cd(b,a,a.length)
return a[b]},
m(a,b,c){a.$flags&2&&A.C(a)
A.cd(b,a,a.length)
a[b]=c},
O(a,b,c,d,e){a.$flags&2&&A.C(a,5)
if(t.dQ.b(d)){this.iD(a,b,c,d,e)
return}this.hx(a,b,c,d,e)},
ai(a,b,c,d){return this.O(a,b,c,d,0)},
$iw:1,
$in:1,
$ir:1}
A.b2.prototype={
m(a,b,c){a.$flags&2&&A.C(a)
A.cd(b,a,a.length)
a[b]=c},
O(a,b,c,d,e){a.$flags&2&&A.C(a,5)
if(t.aj.b(d)){this.iD(a,b,c,d,e)
return}this.hx(a,b,c,d,e)},
ai(a,b,c,d){return this.O(a,b,c,d,0)},
$iw:1,
$in:1,
$ir:1}
A.iL.prototype={
ga3(a){return B.bJ},
$ia0:1,
$imK:1}
A.iM.prototype={
ga3(a){return B.bK},
$ia0:1,
$imL:1}
A.iN.prototype={
ga3(a){return B.bL},
i(a,b){A.cd(b,a,a.length)
return a[b]},
$ia0:1,
$ino:1}
A.iO.prototype={
ga3(a){return B.bM},
i(a,b){A.cd(b,a,a.length)
return a[b]},
$ia0:1,
$inp:1}
A.iP.prototype={
ga3(a){return B.bN},
i(a,b){A.cd(b,a,a.length)
return a[b]},
$ia0:1,
$inq:1}
A.iQ.prototype={
ga3(a){return B.bQ},
i(a,b){A.cd(b,a,a.length)
return a[b]},
$ia0:1,
$ipu:1}
A.fx.prototype={
ga3(a){return B.bR},
i(a,b){A.cd(b,a,a.length)
return a[b]},
bR(a,b,c){return new Uint32Array(a.subarray(b,A.yh(b,c,a.length)))},
$ia0:1,
$ipv:1}
A.fy.prototype={
ga3(a){return B.bS},
gk(a){return a.length},
i(a,b){A.cd(b,a,a.length)
return a[b]},
$ia0:1,
$ipw:1}
A.d_.prototype={
ga3(a){return B.bT},
gk(a){return a.length},
i(a,b){A.cd(b,a,a.length)
return a[b]},
bR(a,b,c){return new Uint8Array(a.subarray(b,A.yh(b,c,a.length)))},
$ia0:1,
$id_:1,
$ibg:1}
A.hi.prototype={}
A.hj.prototype={}
A.hk.prototype={}
A.hl.prototype={}
A.bt.prototype={
h(a){return A.hA(v.typeUniverse,this,a)},
H(a){return A.xX(v.typeUniverse,this,a)}}
A.jZ.prototype={}
A.tu.prototype={
j(a){return A.b8(this.a,null)}}
A.jV.prototype={
j(a){return this.a}}
A.hw.prototype={$ic3:1}
A.qx.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:14}
A.qw.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:135}
A.qy.prototype={
$0(){this.a.$0()},
$S:1}
A.qz.prototype={
$0(){this.a.$0()},
$S:1}
A.ky.prototype={
l1(a,b){if(self.setTimeout!=null)this.b=self.setTimeout(A.cG(new A.tt(this,b),0),a)
else throw A.b(A.Q("`setTimeout()` not found."))},
l2(a,b){if(self.setTimeout!=null)this.b=self.setInterval(A.cG(new A.ts(this,a,Date.now(),b),0),a)
else throw A.b(A.Q("Periodic timer."))},
u(){if(self.setTimeout!=null){var s=this.b
if(s==null)return
if(this.a)self.clearTimeout(s)
else self.clearInterval(s)
this.b=null}else throw A.b(A.Q("Canceling a timer."))}}
A.tt.prototype={
$0(){var s=this.a
s.b=null
s.c=1
this.b.$0()},
$S:0}
A.ts.prototype={
$0(){var s,r=this,q=r.a,p=q.c+1,o=r.b
if(o>0){s=Date.now()-r.c
if(s>(p+1)*o)p=B.b.hz(s,o)}q.c=p
r.d.$1(q)},
$S:1}
A.h_.prototype={
W(a){var s,r=this
if(a==null)a=r.$ti.c.a(a)
if(!r.b)r.a.az(a)
else{s=r.a
if(r.$ti.h("o<1>").b(a))s.hH(a)
else s.bU(a)}},
N(){return this.W(null)},
b5(a,b){var s
if(b==null)b=A.cK(a)
s=this.a
if(this.b)s.aa(new A.a1(a,b))
else s.R(new A.a1(a,b))},
a9(a){return this.b5(a,null)},
$icS:1}
A.tU.prototype={
$1(a){return this.a.$2(0,a)},
$S:13}
A.tV.prototype={
$2(a,b){this.a.$2(1,new A.f9(a,b))},
$S:91}
A.uq.prototype={
$2(a,b){this.a(a,b)},
$S:103}
A.tS.prototype={
$0(){var s,r=this.a,q=r.a
q===$&&A.L()
s=q.b
if((s&1)!==0?(q.ga5().e&4)!==0:(s&2)===0){r.b=!0
return}r=r.c!=null?2:0
this.b.$2(r,null)},
$S:0}
A.tT.prototype={
$1(a){var s=this.a.c!=null?2:0
this.b.$2(s,null)},
$S:14}
A.jJ.prototype={
kX(a,b){var s=new A.qB(a)
this.a=A.bK(new A.qD(this,a),new A.qE(s),null,new A.qF(this,s),!1,b)}}
A.qB.prototype={
$0(){A.eS(new A.qC(this.a))},
$S:1}
A.qC.prototype={
$0(){this.a.$2(0,null)},
$S:0}
A.qE.prototype={
$0(){this.a.$0()},
$S:0}
A.qF.prototype={
$0(){var s=this.a
if(s.b){s.b=!1
this.b.$0()}},
$S:0}
A.qD.prototype={
$0(){var s=this.a,r=s.a
r===$&&A.L()
if((r.b&4)===0){s.c=new A.l($.m,t._)
if(s.b){s.b=!1
A.eS(new A.qA(this.b))}return s.c}},
$S:110}
A.qA.prototype={
$0(){this.a.$2(2,null)},
$S:0}
A.he.prototype={
j(a){return"IterationMarker("+this.b+", "+A.q(this.a)+")"}}
A.kw.prototype={
gp(){return this.b},
mj(a,b){var s,r,q
a=a
b=b
s=this.a
for(;;)try{r=s(this,a,b)
return r}catch(q){b=q
a=1}},
l(){var s,r,q,p,o=this,n=null,m=0
for(;;){s=o.d
if(s!=null)try{if(s.l()){o.b=s.gp()
return!0}else o.d=null}catch(r){n=r
m=1
o.d=null}q=o.mj(m,n)
if(1===q)return!0
if(0===q){o.b=null
p=o.e
if(p==null||p.length===0){o.a=A.xR
return!1}o.a=p.pop()
m=0
n=null
continue}if(2===q){m=0
n=null
continue}if(3===q){n=o.c
o.c=null
p=o.e
if(p==null||p.length===0){o.b=null
o.a=A.xR
throw n
return!1}o.a=p.pop()
m=1
continue}throw A.b(A.D("sync*"))}return!1},
pK(a){var s,r,q=this
if(a instanceof A.eD){s=a.a()
r=q.e
if(r==null)r=q.e=[]
r.push(q.a)
q.a=s
return 2}else{q.d=J.T(a)
return 2}}}
A.eD.prototype={
gA(a){return new A.kw(this.a())}}
A.a1.prototype={
j(a){return A.q(this.a)},
$iV:1,
gby(){return this.b}}
A.aJ.prototype={
gap(){return!0}}
A.di.prototype={
b0(){},
b1(){}}
A.c8.prototype={
sjz(a){throw A.b(A.Q(u.t))},
sjA(a){throw A.b(A.Q(u.t))},
gbz(){return new A.aJ(this,A.p(this).h("aJ<1>"))},
gbZ(){return this.c<4},
dM(){var s=this.r
return s==null?this.r=new A.l($.m,t.D):s},
iw(a){var s=a.CW,r=a.ch
if(s==null)this.d=r
else s.ch=r
if(r==null)this.e=s
else r.CW=s
a.CW=a
a.ch=a},
fv(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=this
if((j.c&4)!==0)return A.xG(c,A.p(j).c)
s=A.p(j)
r=$.m
q=d?1:0
p=b!=null?32:0
o=A.jM(r,a,s.c)
n=A.jN(r,b)
m=c==null?A.ur():c
l=new A.di(j,o,n,r.aY(m,t.H),r,q|p,s.h("di<1>"))
l.CW=l
l.ch=l
l.ay=j.c&1
k=j.e
j.e=l
l.ch=null
l.CW=k
if(k==null)j.d=l
else k.ch=l
if(j.d===l)A.kP(j.a)
return l},
ip(a){var s,r=this
A.p(r).h("di<1>").a(a)
if(a.ch===a)return null
s=a.ay
if((s&2)!==0)a.ay=s|4
else{r.iw(a)
if((r.c&2)===0&&r.d==null)r.eS()}return null},
iq(a){},
ir(a){},
bT(){if((this.c&4)!==0)return new A.b5("Cannot add new events after calling close")
return new A.b5("Cannot add new events while doing an addStream")},
q(a,b){if(!this.gbZ())throw A.b(this.bT())
this.am(b)},
ae(a,b){var s
if(!this.gbZ())throw A.b(this.bT())
s=A.av(a,b)
this.bf(s.a,s.b)},
n(){var s,r,q=this
if((q.c&4)!==0){s=q.r
s.toString
return s}if(!q.gbZ())throw A.b(q.bT())
q.c|=4
r=q.dM()
q.bC()
return r},
e0(a,b){var s,r=this
if(!r.gbZ())throw A.b(r.bT())
r.c|=8
s=A.BB(r,a,!1)
r.f=s
return s.a},
iU(a){return this.e0(a,null)},
M(a){this.am(a)},
a8(a,b){this.bf(a,b)},
Y(){var s=this.f
s.toString
this.f=null
this.c&=4294967287
s.a.az(null)},
f9(a){var s,r,q,p=this,o=p.c
if((o&2)!==0)throw A.b(A.D(u.c))
s=p.d
if(s==null)return
r=o&1
p.c=o^3
while(s!=null){o=s.ay
if((o&1)===r){s.ay=o|2
a.$1(s)
o=s.ay^=1
q=s.ch
if((o&4)!==0)p.iw(s)
s.ay&=4294967293
s=q}else s=s.ch}p.c&=4294967293
if(p.d==null)p.eS()},
eS(){if((this.c&4)!==0){var s=this.r
if((s.a&30)===0)s.az(null)}A.kP(this.b)},
$iaj:1,
$ibJ:1,
sjy(a){return this.a=a},
sjx(a){return this.b=a}}
A.ds.prototype={
gbZ(){return A.c8.prototype.gbZ.call(this)&&(this.c&2)===0},
bT(){if((this.c&2)!==0)return new A.b5(u.c)
return this.kJ()},
am(a){var s=this,r=s.d
if(r==null)return
if(r===s.e){s.c|=2
r.M(a)
s.c&=4294967293
if(s.d==null)s.eS()
return}s.f9(new A.tp(s,a))},
bf(a,b){if(this.d==null)return
this.f9(new A.tr(this,a,b))},
bC(){var s=this
if(s.d!=null)s.f9(new A.tq(s))
else s.r.az(null)}}
A.tp.prototype={
$1(a){a.M(this.b)},
$S(){return this.a.$ti.h("~(au<1>)")}}
A.tr.prototype={
$1(a){a.a8(this.b,this.c)},
$S(){return this.a.$ti.h("~(au<1>)")}}
A.tq.prototype={
$1(a){a.Y()},
$S(){return this.a.$ti.h("~(au<1>)")}}
A.h0.prototype={
am(a){var s
for(s=this.d;s!=null;s=s.ch)s.ba(new A.bx(a))},
bf(a,b){var s
for(s=this.d;s!=null;s=s.ch)s.ba(new A.eo(a,b))},
bC(){var s=this.d
if(s!=null)for(;s!=null;s=s.ch)s.ba(B.z)
else this.r.az(null)}}
A.mT.prototype={
$0(){var s,r,q,p,o,n,m=null
try{m=this.a.$0()}catch(q){s=A.H(q)
r=A.O(q)
p=s
o=r
n=A.dw(p,o)
if(n==null)p=new A.a1(p,o)
else p=n
this.b.aa(p)
return}this.b.bb(m)},
$S:0}
A.mW.prototype={
$2(a,b){var s=this,r=s.a,q=--r.b
if(r.a!=null){r.a=null
r.d=a
r.c=b
if(q===0||s.c)s.d.aa(new A.a1(a,b))}else if(q===0&&!s.c){q=r.d
q.toString
r=r.c
r.toString
s.d.aa(new A.a1(q,r))}},
$S:4}
A.mV.prototype={
$1(a){var s,r,q,p,o,n,m=this,l=m.a,k=--l.b,j=l.a
if(j!=null){J.l_(j,m.b,a)
if(J.z(k,0)){l=m.d
s=A.u([],l.h("t<0>"))
for(q=j,p=q.length,o=0;o<q.length;q.length===p||(0,A.a6)(q),++o){r=q[o]
n=r
if(n==null)n=l.a(n)
J.l0(s,n)}m.c.bU(s)}}else if(J.z(k,0)&&!m.f){s=l.d
s.toString
l=l.c
l.toString
m.c.aa(new A.a1(s,l))}},
$S(){return this.d.h("F(0)")}}
A.mM.prototype={
$2(a,b){if(!this.a.b(a))throw A.b(a)
return this.c.$2(a,b)},
$S(){return this.d.h("0/(k,ae)")}}
A.mN.prototype={
$1(a){var s,r,q,p,o,n,m=this
if(a===0){s=A.u([],m.c.h("t<0>"))
for(r=m.b,q=r.length,p=0;p<r.length;r.length===q||(0,A.a6)(r),++p){o=r[p]
n=o.b
if(n==null)o.$ti.c.a(n)
s.push(n)}m.a.W(s)}else{s=A.u([],t.b9)
for(r=m.b,q=r.length,p=0;p<r.length;r.length===q||(0,A.a6)(r),++p)s.push(r[p].c)
q=A.u([],m.c.h("t<0?>"))
for(n=r.length,p=0;p<r.length;r.length===n||(0,A.a6)(r),++p)q.push(r[p].b)
m.a.a9(new A.e_(B.d.jh(s,A.DO()),a))}},
$S:7}
A.mR.prototype={
$1(a){var s=this,r=s.a,q=s.b
if(a===0)r.W(new A.cy(q.ghi(),s.c.ghi(),s.d.ghi()))
else{q=q.c
if(q==null)q=s.c.c
r.a9(new A.e_(q==null?s.d.c:q,a))}},
$S:7}
A.e_.prototype={
j(a){var s,r,q="ParallelWaitError",p=this.c
if(p==null){p=this.d
s=p<=1
if(s)return q
return"ParallelWaitError("+p+" errors)"}s=this.d
r=s>1
if(r)s="("+s+" errors)"
else s=""
return q+s+": "+A.q(p.a)},
gby(){var s=this.c
s=s==null?null:s.b
return s==null?A.V.prototype.gby.call(this):s}}
A.bj.prototype={
ghi(){var s=this.b
if(s==null)this.$ti.c.a(s)
return s},
mC(a){this.a.b8(new A.rr(this,a),new A.rs(this,a),t.P)}}
A.rr.prototype={
$1(a){this.a.b=a
this.b.$1(0)},
$S(){return this.a.$ti.h("F(1)")}}
A.rs.prototype={
$2(a,b){this.a.c=new A.a1(a,b)
this.b.$1(1)},
$S:5}
A.rq.prototype={
$1(a){var s=this.a,r=s.a+=a
if(++s.b===this.b.length)this.c.$1(r)},
$S:7}
A.dj.prototype={
b5(a,b){if((this.a.a&30)!==0)throw A.b(A.D("Future already completed"))
this.aa(A.av(a,b))},
a9(a){return this.b5(a,null)},
$icS:1}
A.ad.prototype={
W(a){var s=this.a
if((s.a&30)!==0)throw A.b(A.D("Future already completed"))
s.az(a)},
N(){return this.W(null)},
aa(a){this.a.R(a)}}
A.N.prototype={
W(a){var s=this.a
if((s.a&30)!==0)throw A.b(A.D("Future already completed"))
s.bb(a)},
N(){return this.W(null)},
aa(a){this.a.aa(a)}}
A.bi.prototype={
ou(a){if((this.c&15)!==6)return!0
return this.b.b.dA(this.d,a.a,t.y,t.K)},
nW(a){var s,r=this.e,q=null,p=t.z,o=t.K,n=a.a,m=this.b.b
if(t.b.b(r))q=m.hc(r,n,a.b,p,o,t.l)
else q=m.dA(r,n,p,o)
try{p=q
return p}catch(s){if(t.do.b(A.H(s))){if((this.c&1)!==0)throw A.b(A.K("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.b(A.K("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.l.prototype={
b8(a,b,c){var s,r,q=$.m
if(q===B.e){if(b!=null&&!t.b.b(b)&&!t.mq.b(b))throw A.b(A.aV(b,"onError",u.w))}else{a=q.bL(a,c.h("0/"),this.$ti.c)
if(b!=null)b=A.yu(b,q)}s=new A.l($.m,c.h("l<0>"))
r=b==null?1:3
this.cj(new A.bi(s,r,a,b,this.$ti.h("@<1>").H(c).h("bi<1,2>")))
return s},
aQ(a,b){return this.b8(a,null,b)},
iJ(a,b,c){var s=new A.l($.m,c.h("l<0>"))
this.cj(new A.bi(s,19,a,b,this.$ti.h("@<1>").H(c).h("bi<1,2>")))
return s},
lD(){var s,r
if(((this.a|=1)&4)!==0){s=this
do s=s.c
while(r=s.a,(r&4)!==0)
s.a=r|1}},
j1(a){var s=this.$ti,r=$.m,q=new A.l(r,s)
if(r!==B.e)a=A.yu(a,r)
this.cj(new A.bi(q,2,null,a,s.h("bi<1,1>")))
return q},
J(a){var s=this.$ti,r=$.m,q=new A.l(r,s)
if(r!==B.e)a=r.aY(a,t.z)
this.cj(new A.bi(q,8,a,null,s.h("bi<1,1>")))
return q},
mo(a){this.a=this.a&1|16
this.c=a},
dL(a){this.a=a.a&30|this.a&1
this.c=a.c},
cj(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.cj(a)
return}s.dL(r)}s.b.bP(new A.rt(s,a))}},
il(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.il(a)
return}n.dL(s)}m.a=n.dR(a)
n.b.bP(new A.ry(m,n))}},
d_(){var s=this.c
this.c=null
return this.dR(s)},
dR(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
bb(a){var s,r=this
if(r.$ti.h("o<1>").b(a))A.rw(a,r,!0)
else{s=r.d_()
r.a=8
r.c=a
A.dn(r,s)}},
bU(a){var s=this,r=s.d_()
s.a=8
s.c=a
A.dn(s,r)},
lf(a){var s,r,q,p=this
if((a.a&16)!==0){s=p.b
r=a.b
s=!(s===r||s.gbk()===r.gbk())}else s=!1
if(s)return
q=p.d_()
p.dL(a)
A.dn(p,q)},
aa(a){var s=this.d_()
this.mo(a)
A.dn(this,s)},
le(a,b){this.aa(new A.a1(a,b))},
az(a){if(this.$ti.h("o<1>").b(a)){this.hH(a)
return}this.hF(a)},
hF(a){this.a^=2
this.b.bP(new A.rv(this,a))},
hH(a){A.rw(a,this,!1)
return},
R(a){this.a^=2
this.b.bP(new A.ru(this,a))},
oR(a,b){var s,r,q,p=this,o={}
if((p.a&24)!==0){o=new A.l($.m,p.$ti)
o.az(p)
return o}s=p.$ti
r=$.m
q=new A.l(r,s)
o.a=null
o.a=A.pr(a,new A.rE(p,q,r,r.aY(b,s.h("1/"))))
p.b8(new A.rF(o,p,q),new A.rG(o,q),t.P)
return q},
$io:1}
A.rt.prototype={
$0(){A.dn(this.a,this.b)},
$S:0}
A.ry.prototype={
$0(){A.dn(this.b,this.a.a)},
$S:0}
A.rx.prototype={
$0(){A.rw(this.a.a,this.b,!0)},
$S:0}
A.rv.prototype={
$0(){this.a.bU(this.b)},
$S:0}
A.ru.prototype={
$0(){this.a.aa(this.b)},
$S:0}
A.rB.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.bs(q.d,t.z)}catch(p){s=A.H(p)
r=A.O(p)
if(k.c&&k.b.a.c.a===s){q=k.a
q.c=k.b.a.c}else{q=s
o=r
if(o==null)o=A.cK(q)
n=k.a
n.c=new A.a1(q,o)
q=n}q.b=!0
return}if(j instanceof A.l&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=j.c
q.b=!0}return}if(j instanceof A.l){m=k.b.a
l=new A.l(m.b,m.$ti)
j.b8(new A.rC(l,m),new A.rD(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.rC.prototype={
$1(a){this.a.lf(this.b)},
$S:14}
A.rD.prototype={
$2(a,b){this.a.aa(new A.a1(a,b))},
$S:5}
A.rA.prototype={
$0(){var s,r,q,p,o,n
try{q=this.a
p=q.a
o=p.$ti
q.c=p.b.b.dA(p.d,this.b,o.h("2/"),o.c)}catch(n){s=A.H(n)
r=A.O(n)
q=s
p=r
if(p==null)p=A.cK(q)
o=this.a
o.c=new A.a1(q,p)
o.b=!0}},
$S:0}
A.rz.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=l.a.a.c
p=l.b
if(p.a.ou(s)&&p.a.e!=null){p.c=p.a.nW(s)
p.b=!1}}catch(o){r=A.H(o)
q=A.O(o)
p=l.a.a.c
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.cK(p)
m=l.b
m.c=new A.a1(p,n)
p=m}p.b=!0}},
$S:0}
A.rE.prototype={
$0(){var s,r,q,p,o,n=this
try{n.b.bb(n.c.bs(n.d,n.a.$ti.h("1/")))}catch(q){s=A.H(q)
r=A.O(q)
p=s
o=r
if(o==null)o=A.cK(p)
n.b.aa(new A.a1(p,o))}},
$S:0}
A.rF.prototype={
$1(a){var s=this.a.a
if(s.b!=null){s.u()
this.c.bU(a)}},
$S(){return this.b.$ti.h("F(1)")}}
A.rG.prototype={
$2(a,b){var s=this.a.a
if(s.b!=null){s.u()
this.b.aa(new A.a1(a,b))}},
$S:5}
A.jI.prototype={}
A.G.prototype={
gap(){return!1},
mV(a,b){var s,r=null,q={}
q.a=null
s=this.gap()?q.a=new A.ds(r,r,b.h("ds<0>")):q.a=new A.cB(r,r,r,r,b.h("cB<0>"))
s.sjy(new A.oC(q,this,a))
return q.a.gbz()},
nO(a,b,c,d){var s,r={},q=new A.l($.m,d.h("l<0>"))
r.a=b
s=this.B(null,!0,new A.oH(r,q),q.gf1())
s.bq(new A.oI(r,this,c,s,q,d))
return q},
gk(a){var s={},r=new A.l($.m,t.hy)
s.a=0
this.B(new A.oJ(s,this),!0,new A.oK(s,r),r.gf1())
return r},
gaf(a){var s=new A.l($.m,A.p(this).h("l<G.T>")),r=this.B(null,!0,new A.oD(s),s.gf1())
r.bq(new A.oE(this,r,s))
return s}}
A.oC.prototype={
$0(){var s=this.b,r=this.a,q=r.a.gdK(),p=s.aq(null,r.a.gaD(),q)
p.bq(new A.oB(r,s,this.c,p))
r.a.sjx(p.ge3())
if(!s.gap()){s=r.a
s.sjz(p.gen())
s.sjA(p.gbM())}},
$S:0}
A.oB.prototype={
$1(a){var s,r,q,p,o,n,m,l=this,k=null
try{k=l.c.$1(a)}catch(p){s=A.H(p)
r=A.O(p)
o=s
n=r
m=A.dw(o,n)
if(m==null)m=new A.a1(o,n==null?A.cK(o):n)
q=m
l.a.a.ae(q.a,q.b)
return}if(k!=null){o=l.d
o.ah()
l.a.a.iU(k).J(o.gbM())}},
$S(){return A.p(this.b).h("~(G.T)")}}
A.oH.prototype={
$0(){this.b.bb(this.a.a)},
$S:0}
A.oI.prototype={
$1(a){var s=this,r=s.a,q=s.f
A.Dx(new A.oF(r,s.c,a,q),new A.oG(r,q),A.CP(s.d,s.e))},
$S(){return A.p(this.b).h("~(G.T)")}}
A.oF.prototype={
$0(){return this.b.$2(this.a.a,this.c)},
$S(){return this.d.h("0()")}}
A.oG.prototype={
$1(a){this.a.a=a},
$S(){return this.b.h("F(0)")}}
A.oJ.prototype={
$1(a){++this.a.a},
$S(){return A.p(this.b).h("~(G.T)")}}
A.oK.prototype={
$0(){this.b.bb(this.a.a)},
$S:0}
A.oD.prototype={
$0(){var s,r=A.fH(),q=new A.b5("No element")
A.j0(q,r)
s=A.dw(q,r)
if(s==null)s=new A.a1(q,r)
this.a.aa(s)},
$S:0}
A.oE.prototype={
$1(a){A.CQ(this.b,this.c,a)},
$S(){return A.p(this.a).h("~(G.T)")}}
A.fJ.prototype={
gap(){return this.a.gap()},
B(a,b,c,d){return this.a.B(a,b,c,d)},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.jj.prototype={}
A.cz.prototype={
gbz(){return new A.a5(this,A.p(this).h("a5<1>"))},
gm0(){if((this.b&8)===0)return this.a
return this.a.c},
bW(){var s,r,q=this
if((q.b&8)===0){s=q.a
return s==null?q.a=new A.ey():s}r=q.a
s=r.c
return s==null?r.c=new A.ey():s},
ga5(){var s=this.a
return(this.b&8)!==0?s.c:s},
al(){if((this.b&4)!==0)return new A.b5("Cannot add event after closing")
return new A.b5("Cannot add event while adding a stream")},
e0(a,b){var s,r,q,p=this,o=p.b
if(o>=4)throw A.b(p.al())
if((o&2)!==0){o=new A.l($.m,t._)
o.az(null)
return o}o=p.a
s=b===!0
r=new A.l($.m,t._)
q=s?A.BC(p):p.gdK()
q=a.B(p.geQ(),s,p.geW(),q)
s=p.b
if((s&1)!==0?(p.ga5().e&4)!==0:(s&2)===0)q.ah()
p.a=new A.kt(o,r,q)
p.b|=8
return r},
iU(a){return this.e0(a,null)},
dM(){var s=this.c
if(s==null)s=this.c=(this.b&2)!==0?$.cI():new A.l($.m,t.D)
return s},
q(a,b){if(this.b>=4)throw A.b(this.al())
this.M(b)},
ae(a,b){var s
if(this.b>=4)throw A.b(this.al())
s=A.av(a,b)
this.a8(s.a,s.b)},
mO(a){return this.ae(a,null)},
n(){var s=this,r=s.b
if((r&4)!==0)return s.dM()
if(r>=4)throw A.b(s.al())
s.hJ()
return s.dM()},
hJ(){var s=this.b|=4
if((s&1)!==0)this.bC()
else if((s&3)===0)this.bW().q(0,B.z)},
M(a){var s=this.b
if((s&1)!==0)this.am(a)
else if((s&3)===0)this.bW().q(0,new A.bx(a))},
a8(a,b){var s=this.b
if((s&1)!==0)this.bf(a,b)
else if((s&3)===0)this.bW().q(0,new A.eo(a,b))},
Y(){var s=this.a
this.a=s.c
this.b&=4294967287
s.a.az(null)},
fv(a,b,c,d){var s,r,q,p=this
if((p.b&3)!==0)throw A.b(A.D("Stream has already been listened to."))
s=A.BT(p,a,b,c,d,A.p(p).c)
r=p.gm0()
if(((p.b|=1)&8)!==0){q=p.a
q.c=s
q.b.aj()}else p.a=s
s.mp(r)
s.fb(new A.tj(p))
return s},
ip(a){var s,r,q,p,o,n,m,l=this,k=null
if((l.b&8)!==0)k=l.a.u()
l.a=null
l.b=l.b&4294967286|2
s=l.r
if(s!=null)if(k==null)try{r=s.$0()
if(r instanceof A.l)k=r}catch(o){q=A.H(o)
p=A.O(o)
n=new A.l($.m,t.D)
n.R(new A.a1(q,p))
k=n}else k=k.J(s)
m=new A.ti(l)
if(k!=null)k=k.J(m)
else m.$0()
return k},
iq(a){if((this.b&8)!==0)this.a.b.ah()
A.kP(this.e)},
ir(a){if((this.b&8)!==0)this.a.b.aj()
A.kP(this.f)},
$iaj:1,
$ibJ:1,
sjy(a){return this.d=a},
sjz(a){return this.e=a},
sjA(a){return this.f=a},
sjx(a){return this.r=a}}
A.tj.prototype={
$0(){A.kP(this.a.d)},
$S:0}
A.ti.prototype={
$0(){var s=this.a.c
if(s!=null&&(s.a&30)===0)s.az(null)},
$S:0}
A.kx.prototype={
am(a){this.ga5().M(a)},
bf(a,b){this.ga5().a8(a,b)},
bC(){this.ga5().Y()}}
A.jK.prototype={
am(a){this.ga5().ba(new A.bx(a))},
bf(a,b){this.ga5().ba(new A.eo(a,b))},
bC(){this.ga5().ba(B.z)}}
A.bN.prototype={}
A.cB.prototype={}
A.a5.prototype={
gv(a){return(A.e1(this.a)^892482866)>>>0},
D(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.a5&&b.a===this.a}}
A.cx.prototype={
dP(){return this.w.ip(this)},
b0(){this.w.iq(this)},
b1(){this.w.ir(this)}}
A.fZ.prototype={
u(){var s=this.b.u()
return s.J(new A.qt(this))}}
A.qu.prototype={
$2(a,b){var s=this.a
s.a8(a,b)
s.Y()},
$S:5}
A.qt.prototype={
$0(){this.a.a.az(null)},
$S:1}
A.kt.prototype={}
A.au.prototype={
mp(a){var s=this
if(a==null)return
s.r=a
if(a.c!=null){s.e=(s.e|128)>>>0
a.dF(s)}},
bq(a){this.a=A.jM(this.d,a,A.p(this).h("au.T"))},
dq(a){var s=this,r=s.e
if(a==null)s.e=(r&4294967263)>>>0
else s.e=(r|32)>>>0
s.b=A.jN(s.d,a)},
aG(a){var s,r=this,q=r.e
if((q&8)!==0)return
r.e=(q+256|4)>>>0
if(a!=null)a.J(r.gbM())
if(q<256){s=r.r
if(s!=null)if(s.a===1)s.a=3}if((q&4)===0&&(r.e&64)===0)r.fb(r.gcW())},
ah(){return this.aG(null)},
aj(){var s=this,r=s.e
if((r&8)!==0)return
if(r>=256){r=s.e=r-256
if(r<256)if((r&128)!==0&&s.r.c!=null)s.r.dF(s)
else{r=(r&4294967291)>>>0
s.e=r
if((r&64)===0)s.fb(s.gcX())}}},
u(){var s=this,r=(s.e&4294967279)>>>0
s.e=r
if((r&8)===0)s.eT()
r=s.f
return r==null?$.cI():r},
eT(){var s,r=this,q=r.e=(r.e|8)>>>0
if((q&128)!==0){s=r.r
if(s.a===1)s.a=3}if((q&64)===0)r.r=null
r.f=r.dP()},
M(a){var s=this.e
if((s&8)!==0)return
if(s<64)this.am(a)
else this.ba(new A.bx(a))},
a8(a,b){var s
if(t.C.b(a))A.j0(a,b)
s=this.e
if((s&8)!==0)return
if(s<64)this.bf(a,b)
else this.ba(new A.eo(a,b))},
Y(){var s=this,r=s.e
if((r&8)!==0)return
r=(r|2)>>>0
s.e=r
if(r<64)s.bC()
else s.ba(B.z)},
b0(){},
b1(){},
dP(){return null},
ba(a){var s,r=this,q=r.r
if(q==null)q=r.r=new A.ey()
q.q(0,a)
s=r.e
if((s&128)===0){s=(s|128)>>>0
r.e=s
if(s<256)q.dF(r)}},
am(a){var s=this,r=s.e
s.e=(r|64)>>>0
s.d.c6(s.a,a,A.p(s).h("au.T"))
s.e=(s.e&4294967231)>>>0
s.eV((r&4)!==0)},
bf(a,b){var s,r=this,q=r.e,p=new A.qO(r,a,b)
if((q&1)!==0){r.e=(q|16)>>>0
r.eT()
s=r.f
if(s!=null&&s!==$.cI())s.J(p)
else p.$0()}else{p.$0()
r.eV((q&4)!==0)}},
bC(){var s,r=this,q=new A.qN(r)
r.eT()
r.e=(r.e|16)>>>0
s=r.f
if(s!=null&&s!==$.cI())s.J(q)
else q.$0()},
fb(a){var s=this,r=s.e
s.e=(r|64)>>>0
a.$0()
s.e=(s.e&4294967231)>>>0
s.eV((r&4)!==0)},
eV(a){var s,r,q=this,p=q.e
if((p&128)!==0&&q.r.c==null){p=q.e=(p&4294967167)>>>0
s=!1
if((p&4)!==0)if(p<256){s=q.r
s=s==null?null:s.c==null
s=s!==!1}if(s){p=(p&4294967291)>>>0
q.e=p}}for(;;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=(p^64)>>>0
if(r)q.b0()
else q.b1()
p=(q.e&4294967231)>>>0
q.e=p}if((p&128)!==0&&p<256)q.r.dF(q)},
$iah:1}
A.qO.prototype={
$0(){var s,r,q,p=this.a,o=p.e
if((o&8)!==0&&(o&16)===0)return
p.e=(o|64)>>>0
s=p.b
o=this.b
r=t.K
q=p.d
if(t.r.b(s))q.hd(s,o,this.c,r,t.l)
else q.c6(s,o,r)
p.e=(p.e&4294967231)>>>0},
$S:0}
A.qN.prototype={
$0(){var s=this.a,r=s.e
if((r&16)===0)return
s.e=(r|74)>>>0
s.d.dz(s.c)
s.e=(s.e&4294967231)>>>0},
$S:0}
A.eC.prototype={
B(a,b,c,d){return this.a.fv(a,d,c,b===!0)},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.jU.prototype={
gbp(){return this.a},
sbp(a){return this.a=a}}
A.bx.prototype={
ha(a){a.am(this.b)}}
A.eo.prototype={
ha(a){a.bf(this.b,this.c)}}
A.ri.prototype={
ha(a){a.bC()},
gbp(){return null},
sbp(a){throw A.b(A.D("No events after a done."))}}
A.ey.prototype={
dF(a){var s=this,r=s.a
if(r===1)return
if(r>=1){s.a=1
return}A.eS(new A.t3(s,a))
s.a=1},
q(a,b){var s=this,r=s.c
if(r==null)s.b=s.c=b
else{r.sbp(b)
s.c=b}}}
A.t3.prototype={
$0(){var s,r,q=this.a,p=q.a
q.a=0
if(p===3)return
s=q.b
r=s.gbp()
q.b=r
if(r==null)q.c=null
s.ha(this.b)},
$S:0}
A.ep.prototype={
bq(a){},
dq(a){},
aG(a){var s=this.a
if(s>=0){this.a=s+2
if(a!=null)a.J(this.gbM())}},
ah(){return this.aG(null)},
aj(){var s=this,r=s.a-2
if(r<0)return
if(r===0){s.a=1
A.eS(s.gii())}else s.a=r},
u(){this.a=-1
this.c=null
return $.cI()},
m_(){var s,r=this,q=r.a-1
if(q===0){r.a=-1
s=r.c
if(s!=null){r.c=null
r.b.dz(s)}}else r.a=q},
$iah:1}
A.bQ.prototype={
gp(){if(this.c)return this.b
return null},
l(){var s,r=this,q=r.a
if(q!=null){if(r.c){s=new A.l($.m,t.x)
r.b=s
r.c=!1
q.aj()
return s}throw A.b(A.D("Already waiting for next."))}return r.lE()},
lE(){var s,r,q=this,p=q.b
if(p!=null){s=new A.l($.m,t.x)
q.b=s
r=p.B(q.glS(),!0,q.glU(),q.glW())
if(q.b!=null)q.a=r
return s}return $.zb()},
u(){var s=this,r=s.a,q=s.b
s.b=null
if(r!=null){s.a=null
if(!s.c)q.az(!1)
else s.c=!1
return r.u()}return $.cI()},
lT(a){var s,r,q=this
if(q.a==null)return
s=q.b
q.b=a
q.c=!0
s.bb(!0)
if(q.c){r=q.a
if(r!=null)r.ah()}},
lX(a,b){var s=this,r=s.a,q=s.b
s.b=s.a=null
if(r!=null)q.aa(new A.a1(a,b))
else q.R(new A.a1(a,b))},
lV(){var s=this,r=s.a,q=s.b
s.b=s.a=null
if(r!=null)q.bU(!1)
else q.hF(!1)}}
A.dm.prototype={
B(a,b,c,d){return A.xG(c,this.$ti.c)},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)},
gap(){return!0}}
A.bA.prototype={
B(a,b,c,d){var s=null,r=new A.hh(s,s,s,s,this.$ti.h("hh<1>"))
r.d=new A.t1(this,r)
return r.fv(a,d,c,b===!0)},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)},
gap(){return this.a}}
A.t1.prototype={
$0(){this.a.b.$1(this.b)},
$S:0}
A.hh.prototype={
mS(a){var s=this.b
if(s>=4)throw A.b(this.al())
if((s&1)!==0)this.ga5().M(a)},
mP(a,b){var s=this.b
if(s>=4)throw A.b(this.al())
if((s&1)!==0){s=this.ga5()
s.a8(a,b==null?B.r:b)}},
j3(){var s=this,r=s.b
if((r&4)!==0)return
if(r>=4)throw A.b(s.al())
r|=4
s.b=r
if((r&1)!==0)s.ga5().Y()},
$ibY:1}
A.tY.prototype={
$0(){return this.a.aa(this.b)},
$S:0}
A.tX.prototype={
$2(a,b){A.CO(this.a,this.b,new A.a1(a,b))},
$S:4}
A.tZ.prototype={
$0(){return this.a.bb(this.b)},
$S:0}
A.b6.prototype={
gap(){return this.a.gap()},
B(a,b,c,d){var s=A.p(this),r=$.m,q=b===!0?1:0,p=d!=null?32:0,o=A.jM(r,a,s.h("b6.T")),n=A.jN(r,d),m=c==null?A.ur():c
s=new A.es(this,o,n,r.aY(m,t.H),r,q|p,s.h("es<b6.S,b6.T>"))
s.x=this.a.aq(s.gfc(),s.gfe(),s.gfg())
return s},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.es.prototype={
M(a){if((this.e&2)!==0)return
this.bS(a)},
a8(a,b){if((this.e&2)!==0)return
this.eN(a,b)},
b0(){var s=this.x
if(s!=null)s.ah()},
b1(){var s=this.x
if(s!=null)s.aj()},
dP(){var s=this.x
if(s!=null){this.x=null
return s.u()}return null},
fd(a){this.w.i9(a,this)},
fh(a,b){this.a8(a,b)},
ff(){this.Y()}}
A.dv.prototype={
i9(a,b){var s,r,q,p=null
try{p=this.b.$1(a)}catch(q){s=A.H(q)
r=A.O(q)
A.yb(b,s,r)
return}if(p)b.M(a)}}
A.bz.prototype={
i9(a,b){var s,r,q,p=null
try{p=this.b.$1(a)}catch(q){s=A.H(q)
r=A.O(q)
A.yb(b,s,r)
return}b.M(p)}}
A.h9.prototype={
q(a,b){var s=this.a
if((s.e&2)!==0)A.v(A.D("Stream is already closed"))
s.bS(b)},
ae(a,b){this.a.a8(a,b)},
n(){var s=this.a
if((s.e&2)!==0)A.v(A.D("Stream is already closed"))
s.hy()},
$iaj:1}
A.eA.prototype={
M(a){if((this.e&2)!==0)throw A.b(A.D("Stream is already closed"))
this.bS(a)},
a8(a,b){if((this.e&2)!==0)throw A.b(A.D("Stream is already closed"))
this.eN(a,b)},
Y(){if((this.e&2)!==0)throw A.b(A.D("Stream is already closed"))
this.hy()},
b0(){var s=this.x
if(s!=null)s.ah()},
b1(){var s=this.x
if(s!=null)s.aj()},
dP(){var s=this.x
if(s!=null){this.x=null
return s.u()}return null},
fd(a){var s,r,q,p
try{q=this.w
q===$&&A.L()
q.q(0,a)}catch(p){s=A.H(p)
r=A.O(p)
this.a8(s,r)}},
fh(a,b){var s,r,q,p
try{q=this.w
q===$&&A.L()
q.ae(a,b)}catch(p){s=A.H(p)
r=A.O(p)
if(s===a)this.a8(a,b)
else this.a8(s,r)}},
ff(){var s,r,q,p
try{this.x=null
q=this.w
q===$&&A.L()
q.n()}catch(p){s=A.H(p)
r=A.O(p)
this.a8(s,r)}}}
A.c7.prototype={
gap(){return this.b.gap()},
B(a,b,c,d){var s=this.$ti,r=$.m,q=b===!0?1:0,p=d!=null?32:0,o=A.jM(r,a,s.y[1]),n=A.jN(r,d),m=c==null?A.ur():c,l=new A.eA(o,n,r.aY(m,t.H),r,q|p,s.h("eA<1,2>"))
l.w=this.a.$1(new A.h9(l))
l.x=this.b.aq(l.gfc(),l.gfe(),l.gfg())
return l},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.ks.prototype={
bg(a){return this.a.$1(a)}}
A.tP.prototype={}
A.tR.prototype={}
A.tQ.prototype={}
A.tN.prototype={}
A.tO.prototype={}
A.tM.prototype={}
A.tJ.prototype={}
A.kH.prototype={}
A.tI.prototype={}
A.tH.prototype={}
A.tL.prototype={}
A.tK.prototype={}
A.kG.prototype={
nP(a,b,c,d,e){return this.b.$5(a,b,c,d,e)}}
A.kI.prototype={}
A.kF.prototype={
cY(a,b,c){var s,r,q,p,o,n,m=this.gfj(),l=m.a
if(l===B.e){A.hJ(b,c)
return}o=l.gh7()
o.toString
s=o
r=$.m
try{$.m=s
m.nP(l,l.gaL(),a,b,c)
$.m=r}catch(n){q=A.H(n)
p=A.O(n)
$.m=r
o=b===q?c:p
s.cY(l,q,o)}},
$iB:1}
A.jS.prototype={
ghW(){var s=this.ax
return s==null?this.ax=new A.eH(this):s},
gaL(){return this.ay.ghW()},
gbk(){return this.as.a},
dz(a){var s,r,q
try{this.bs(a,t.H)}catch(q){s=A.H(q)
r=A.O(q)
this.cY(this,s,r)}},
c6(a,b,c){var s,r,q
try{this.dA(a,b,t.H,c)}catch(q){s=A.H(q)
r=A.O(q)
this.cY(this,s,r)}},
hd(a,b,c,d,e){var s,r,q
try{this.hc(a,b,c,t.H,d,e)}catch(q){s=A.H(q)
r=A.O(q)
this.cY(this,s,r)}},
fH(a,b){return new A.rd(this,this.aY(a,b),b)},
d6(a){return new A.rc(this,this.aY(a,t.H))},
fI(a,b){return new A.re(this,this.bL(a,t.H,b),b)},
i(a,b){var s,r,q=this.at
if(q===B.W)return null
s=q.b
r=s.i(0,b)
return r!=null||s.G(b)?r:this.m8(q,b)},
m8(a,b){var s,r,q
for(s=a,r=null;;){s=s.a.gh7().gfD()
if(s===B.W)break
q=s.b
r=q.i(0,b)
if(r!=null||q.G(b)){a.b.m(0,b,r)
break}}return r},
cv(a,b){this.cY(this,a,b)},
eb(a,b){var s=this.Q,r=s.a
return s.b.$5(r,r.gaL(),this,a,b)},
ji(a){return this.eb(null,a)},
bs(a,b){var s=this.a,r=s.a
return s.b.$1$4(r,r.gaL(),this,a,b)},
dA(a,b,c,d){var s=this.b,r=s.a
return s.b.$2$5(r,r.gaL(),this,a,b,c,d)},
hc(a,b,c,d,e,f){var s=this.c,r=s.a
return s.b.$3$6(r,r.gaL(),this,a,b,c,d,e,f)},
aY(a,b){var s=this.d,r=s.a
return s.b.$1$4(r,r.gaL(),this,a,b)},
bL(a,b,c){var s=this.e,r=s.a
return s.b.$2$4(r,r.gaL(),this,a,b,c)},
cE(a,b,c,d){var s=this.f,r=s.a
return s.b.$3$4(r,r.gaL(),this,a,b,c,d)},
jb(a,b){var s=this.r,r=s.a
if(r===B.e)return null
return s.b.$5(r,r.gaL(),this,a,b)},
bP(a){var s=this.w,r=s.a
return s.b.$4(r,r.gaL(),this,a)},
fM(a,b){var s=this.x,r=s.a
return s.b.$5(r,r.gaL(),this,a,b)},
giz(){return this.a},
giB(){return this.b},
giA(){return this.c},
git(){return this.d},
giu(){return this.e},
gis(){return this.f},
ghZ(){return this.r},
gft(){return this.w},
ghT(){return this.x},
ghS(){return this.y},
gim(){return this.z},
gi3(){return this.Q},
gfj(){return this.as},
gfD(){return this.at},
gh7(){return this.ay}}
A.rd.prototype={
$0(){return this.a.bs(this.b,this.c)},
$S(){return this.c.h("0()")}}
A.rc.prototype={
$0(){return this.a.dz(this.b)},
$S:0}
A.re.prototype={
$1(a){return this.a.c6(this.b,a,this.c)},
$S(){return this.c.h("~(0)")}}
A.ko.prototype={
giz(){return B.c9},
giB(){return B.c8},
giA(){return B.c7},
git(){return B.c5},
giu(){return B.c6},
gis(){return B.c4},
ghZ(){return B.c0},
gft(){return B.ca},
ghT(){return B.c_},
ghS(){return B.aS},
gim(){return B.c3},
gi3(){return B.c1},
gfj(){return B.c2},
gfD(){return B.W},
gh7(){return null},
ghW(){var s=$.t6
return s==null?$.t6=new A.eH(this):s},
gaL(){var s=$.t6
return s==null?$.t6=new A.eH(this):s},
gbk(){return this},
dz(a){var s,r,q
try{if(B.e===$.m){a.$0()
return}A.ub(null,null,this,a)}catch(q){s=A.H(q)
r=A.O(q)
A.hJ(s,r)}},
c6(a,b){var s,r,q
try{if(B.e===$.m){a.$1(b)
return}A.uc(null,null,this,a,b)}catch(q){s=A.H(q)
r=A.O(q)
A.hJ(s,r)}},
hd(a,b,c){var s,r,q
try{if(B.e===$.m){a.$2(b,c)
return}A.w4(null,null,this,a,b,c)}catch(q){s=A.H(q)
r=A.O(q)
A.hJ(s,r)}},
fH(a,b){return new A.t8(this,a,b)},
d6(a){return new A.t7(this,a)},
fI(a,b){return new A.t9(this,a,b)},
i(a,b){return null},
cv(a,b){A.hJ(a,b)},
eb(a,b){return A.yw(null,null,this,a,b)},
ji(a){return this.eb(null,a)},
bs(a){if($.m===B.e)return a.$0()
return A.ub(null,null,this,a)},
dA(a,b){if($.m===B.e)return a.$1(b)
return A.uc(null,null,this,a,b)},
hc(a,b,c){if($.m===B.e)return a.$2(b,c)
return A.w4(null,null,this,a,b,c)},
aY(a){return a},
bL(a){return a},
cE(a){return a},
jb(a,b){return null},
bP(a){A.ud(null,null,this,a)},
fM(a,b){return A.vy(a,b)}}
A.t8.prototype={
$0(){return this.a.bs(this.b,this.c)},
$S(){return this.c.h("0()")}}
A.t7.prototype={
$0(){return this.a.dz(this.b)},
$S:0}
A.t9.prototype={
$1(a){return this.a.c6(this.b,a,this.c)},
$S(){return this.c.h("~(0)")}}
A.eH.prototype={$ia9:1}
A.ua.prototype={
$0(){A.ik(this.a,this.b)},
$S:0}
A.fX.prototype={}
A.ca.prototype={
gk(a){return this.a},
gE(a){return this.a===0},
ga2(){return new A.hc(this,A.p(this).h("hc<1>"))},
G(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.hQ(a)},
hQ(a){var s=this.d
if(s==null)return!1
return this.bc(this.hN(s,a),a)>=0},
ab(a,b){b.ac(0,new A.rH(this))},
i(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.xJ(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.xJ(q,b)
return r}else return this.i5(b)},
i5(a){var s,r,q=this.d
if(q==null)return null
s=this.hN(q,a)
r=this.bc(s,a)
return r<0?null:s[r+1]},
m(a,b,c){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
q.hL(s==null?q.b=A.vK():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
q.hL(r==null?q.c=A.vK():r,b,c)}else q.iC(b,c)},
iC(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=A.vK()
s=p.bA(a)
r=o[s]
if(r==null){A.vL(o,s,[a,b]);++p.a
p.e=null}else{q=p.bc(r,a)
if(q>=0)r[q+1]=b
else{r.push(a,b);++p.a
p.e=null}}},
ac(a,b){var s,r,q,p,o,n=this,m=n.hM()
for(s=m.length,r=A.p(n).y[1],q=0;q<s;++q){p=m[q]
o=n.i(0,p)
b.$2(p,o==null?r.a(o):o)
if(m!==n.e)throw A.b(A.ap(n))}},
hM(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.b1(i.a,null,!1,t.z)
s=i.b
r=0
if(s!=null){q=Object.getOwnPropertyNames(s)
p=q.length
for(o=0;o<p;++o){h[r]=q[o];++r}}n=i.c
if(n!=null){q=Object.getOwnPropertyNames(n)
p=q.length
for(o=0;o<p;++o){h[r]=+q[o];++r}}m=i.d
if(m!=null){q=Object.getOwnPropertyNames(m)
p=q.length
for(o=0;o<p;++o){l=m[q[o]]
k=l.length
for(j=0;j<k;j+=2){h[r]=l[j];++r}}}return i.e=h},
hL(a,b,c){if(a[b]==null){++this.a
this.e=null}A.vL(a,b,c)},
bA(a){return J.y(a)&1073741823},
hN(a,b){return a[this.bA(b)]},
bc(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2)if(J.z(a[r],b))return r
return-1}}
A.rH.prototype={
$2(a,b){this.a.m(0,a,b)},
$S(){return A.p(this.a).h("~(1,2)")}}
A.dp.prototype={
bA(a){return A.kU(a)&1073741823},
bc(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.h4.prototype={
i(a,b){if(!this.w.$1(b))return null
return this.kL(b)},
m(a,b,c){this.kM(b,c)},
G(a){if(!this.w.$1(a))return!1
return this.kK(a)},
bA(a){return this.r.$1(a)&1073741823},
bc(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=this.f,q=0;q<s;q+=2)if(r.$2(a[q],b))return q
return-1}}
A.rb.prototype={
$1(a){return this.a.b(a)},
$S:16}
A.hc.prototype={
gk(a){return this.a.a},
gE(a){return this.a.a===0},
gaN(a){return this.a.a!==0},
gA(a){var s=this.a
return new A.k_(s,s.hM(),this.$ti.h("k_<1>"))},
S(a,b){return this.a.G(b)}}
A.k_.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
l(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.b(A.ap(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}}}
A.hg.prototype={
i(a,b){if(!this.y.$1(b))return null
return this.kC(b)},
m(a,b,c){this.kE(b,c)},
G(a){if(!this.y.$1(a))return!1
return this.kB(a)},
I(a,b){if(!this.y.$1(b))return null
return this.kD(b)},
dl(a){return this.x.$1(a)&1073741823},
cz(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=this.w,q=0;q<s;++q)if(r.$2(a[q].a,b))return q
return-1}}
A.t_.prototype={
$1(a){return this.a.b(a)},
$S:16}
A.cb.prototype={
lR(){return new A.cb(A.p(this).h("cb<1>"))},
gA(a){var s=this,r=new A.ev(s,s.r,A.p(s).h("ev<1>"))
r.c=s.e
return r},
gk(a){return this.a},
gE(a){return this.a===0},
gaN(a){return this.a!==0},
S(a,b){var s,r
if(typeof b=="string"&&b!=="__proto__"){s=this.b
if(s==null)return!1
return s[b]!=null}else{r=this.li(b)
return r}},
li(a){var s=this.d
if(s==null)return!1
return this.bc(s[this.bA(a)],a)>=0},
q(a,b){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.hK(s==null?q.b=A.vN():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.hK(r==null?q.c=A.vN():r,b)}else return q.eY(b)},
eY(a){var s,r,q=this,p=q.d
if(p==null)p=q.d=A.vN()
s=q.bA(a)
r=p[s]
if(r==null)p[s]=[q.f_(a)]
else{if(q.bc(r,a)>=0)return!1
r.push(q.f_(a))}return!0},
I(a,b){var s=this
if(typeof b=="string"&&b!=="__proto__")return s.hO(s.b,b)
else if(typeof b=="number"&&(b&1073741823)===b)return s.hO(s.c,b)
else return s.fs(b)},
fs(a){var s,r,q,p,o=this,n=o.d
if(n==null)return!1
s=o.bA(a)
r=n[s]
q=o.bc(r,a)
if(q<0)return!1
p=r.splice(q,1)[0]
if(0===r.length)delete n[s]
o.hP(p)
return!0},
aC(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.eZ()}},
hK(a,b){if(a[b]!=null)return!1
a[b]=this.f_(b)
return!0},
hO(a,b){var s
if(a==null)return!1
s=a[b]
if(s==null)return!1
this.hP(s)
delete a[b]
return!0},
eZ(){this.r=this.r+1&1073741823},
f_(a){var s,r=this,q=new A.t0(a)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.c=s
r.f=s.b=q}++r.a
r.eZ()
return q},
hP(a){var s=this,r=a.c,q=a.b
if(r==null)s.e=q
else r.b=q
if(q==null)s.f=r
else q.c=r;--s.a
s.eZ()},
bA(a){return J.y(a)&1073741823},
bc(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.z(a[r].a,b))return r
return-1}}
A.t0.prototype={}
A.ev.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
l(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.b(A.ap(q))
else if(r==null){s.d=null
return!1}else{s.d=r.a
s.c=r.b
return!0}}}
A.dc.prototype={
d7(a,b){return new A.dc(J.wp(this.a,b),b.h("dc<0>"))},
gk(a){return J.aE(this.a)},
i(a,b){return J.hO(this.a,b)}}
A.nA.prototype={
$2(a,b){this.a.m(0,this.b.a(a),this.c.a(b))},
$S:126}
A.cY.prototype={
S(a,b){return!1},
gA(a){var s=this
return new A.k6(s,s.a,s.c,s.$ti.h("k6<1>"))},
gk(a){return this.b},
aC(a){var s,r,q,p=this;++p.a
if(p.b===0)return
s=p.c
s.toString
r=s
do{q=r.b
q.toString
r.b=r.c=r.a=null
if(q!==s){r=q
continue}else break}while(!0)
p.c=null
p.b=0},
gaf(a){var s
if(this.b===0)throw A.b(A.D("No such element"))
s=this.c
s.toString
return s},
gaO(a){var s
if(this.b===0)throw A.b(A.D("No such element"))
s=this.c.c
s.toString
return s},
gE(a){return this.b===0},
dN(a,b,c){var s,r,q=this
if(b.a!=null)throw A.b(A.D("LinkedListEntry is already in a LinkedList"));++q.a
b.a=q
s=q.b
if(s===0){b.b=b
q.c=b.c=b
q.b=s+1
return}r=a.c
r.toString
b.c=r
b.b=a
a.c=r.b=b
q.b=s+1},
fz(a){var s,r,q=this;++q.a
s=a.b
s.c=a.c
a.c.b=s
r=--q.b
a.a=a.b=a.c=null
if(r===0)q.c=null
else if(a===q.c)q.c=s}}
A.k6.prototype={
gp(){var s=this.c
return s==null?this.$ti.c.a(s):s},
l(){var s=this,r=s.a
if(s.b!==r.a)throw A.b(A.ap(s))
if(r.b!==0)r=s.e&&s.d===r.gaf(0)
else r=!0
if(r){s.c=null
return!1}s.e=!0
r=s.d
s.c=r
s.d=r.b
return!0}}
A.aG.prototype={
gds(){var s=this.a
if(s==null||this===s.gaf(0))return null
return this.c}}
A.A.prototype={
gA(a){return new A.ar(a,this.gk(a),A.bn(a).h("ar<A.E>"))},
T(a,b){return this.i(a,b)},
gE(a){return this.gk(a)===0},
gaN(a){return!this.gE(a)},
gaf(a){if(this.gk(a)===0)throw A.b(A.bW())
return this.i(a,0)},
S(a,b){var s,r=this.gk(a)
for(s=0;s<r;++s){if(J.z(this.i(a,s),b))return!0
if(r!==this.gk(a))throw A.b(A.ap(a))}return!1},
b6(a,b,c){return new A.aa(a,b,A.bn(a).h("@<A.E>").H(c).h("aa<1,2>"))},
aS(a,b){return A.bM(a,b,null,A.bn(a).h("A.E"))},
bN(a,b){return A.bM(a,0,A.ba(b,"count",t.S),A.bn(a).h("A.E"))},
q(a,b){var s=this.gk(a)
this.sk(a,s+1)
this.m(a,s,b)},
d7(a,b){return new A.al(a,A.bn(a).h("@<A.E>").H(b).h("al<1,2>"))},
cN(a,b){var s=b==null?A.E5():b
A.j9(a,0,this.gk(a)-1,s)},
kp(a,b,c){A.aL(b,c,this.gk(a))
return A.bM(a,b,c,A.bn(a).h("A.E"))},
fR(a,b,c,d){var s
A.aL(b,c,this.gk(a))
for(s=b;s<c;++s)this.m(a,s,d)},
O(a,b,c,d,e){var s,r,q,p,o
A.aL(b,c,this.gk(a))
s=c-b
if(s===0)return
A.aH(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.l2(d,e).bu(0,!1)
r=0}p=J.a3(q)
if(r+s>p.gk(q))throw A.b(A.wR())
if(r<b)for(o=s-1;o>=0;--o)this.m(a,b+o,p.i(q,r+o))
else for(o=0;o<s;++o)this.m(a,b+o,p.i(q,r+o))},
ai(a,b,c,d){return this.O(a,b,c,d,0)},
ce(a,b,c){var s,r
if(t.j.b(c))this.ai(a,b,b+c.length,c)
else for(s=J.T(c);s.l();b=r){r=b+1
this.m(a,b,s.gp())}},
j(a){return A.nu(a,"[","]")},
$iw:1,
$in:1,
$ir:1}
A.J.prototype={
bh(a,b,c){var s=A.p(this)
return A.x0(this,s.h("J.K"),s.h("J.V"),b,c)},
ac(a,b){var s,r,q,p
for(s=J.T(this.ga2()),r=A.p(this).h("J.V");s.l();){q=s.gp()
p=this.i(0,q)
b.$2(q,p==null?r.a(p):p)}},
gbj(){return J.eU(this.ga2(),new A.nE(this),A.p(this).h("M<J.K,J.V>"))},
cB(a,b,c,d){var s,r,q,p,o,n=A.Z(c,d)
for(s=J.T(this.ga2()),r=A.p(this).h("J.V");s.l();){q=s.gp()
p=this.i(0,q)
o=b.$2(q,p==null?r.a(p):p)
n.m(0,o.a,o.b)}return n},
G(a){return J.wr(this.ga2(),a)},
gk(a){return J.aE(this.ga2())},
gE(a){return J.l1(this.ga2())},
j(a){return A.nF(this)},
$ia_:1}
A.nE.prototype={
$1(a){var s=this.a,r=s.i(0,a)
if(r==null)r=A.p(s).h("J.V").a(r)
return new A.M(a,r,A.p(s).h("M<J.K,J.V>"))},
$S(){return A.p(this.a).h("M<J.K,J.V>(J.K)")}}
A.nG.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.q(a)
r.a=(r.a+=s)+": "
s=A.q(b)
r.a+=s},
$S:36}
A.kB.prototype={
m(a,b,c){throw A.b(A.Q("Cannot modify unmodifiable map"))}}
A.fq.prototype={
bh(a,b,c){return this.a.bh(0,b,c)},
i(a,b){return this.a.i(0,b)},
m(a,b,c){this.a.m(0,b,c)},
G(a){return this.a.G(a)},
ac(a,b){this.a.ac(0,b)},
gE(a){var s=this.a
return s.gE(s)},
gk(a){var s=this.a
return s.gk(s)},
ga2(){return this.a.ga2()},
j(a){return this.a.j(0)},
gbj(){return this.a.gbj()},
cB(a,b,c,d){return this.a.cB(0,b,c,d)},
$ia_:1}
A.dd.prototype={
bh(a,b,c){return new A.dd(this.a.bh(0,b,c),b.h("@<0>").H(c).h("dd<1,2>"))}}
A.fo.prototype={
gA(a){var s=this
return new A.k7(s,s.c,s.d,s.b,s.$ti.h("k7<1>"))},
gE(a){return this.b===this.c},
gk(a){return(this.c-this.b&this.a.length-1)>>>0},
T(a,b){var s,r=this
A.At(b,r.gk(0),r,null,null)
s=r.a
s=s[(r.b+b&s.length-1)>>>0]
return s==null?r.$ti.c.a(s):s},
I(a,b){var s,r=this
for(s=r.b;s!==r.c;s=(s+1&r.a.length-1)>>>0)if(J.z(r.a[s],b)){r.fs(s);++r.d
return!0}return!1},
j(a){return A.nu(this,"{","}")},
oK(){var s,r,q=this,p=q.b
if(p===q.c)throw A.b(A.bW());++q.d
s=q.a
r=s[p]
if(r==null)r=q.$ti.c.a(r)
s[p]=null
q.b=(p+1&s.length-1)>>>0
return r},
eY(a){var s,r,q=this,p=q.a,o=q.c
p[o]=a
p=p.length
o=(o+1&p-1)>>>0
q.c=o
if(q.b===o){s=A.b1(p*2,null,!1,q.$ti.h("1?"))
p=q.a
o=q.b
r=p.length-o
B.d.O(s,0,r,p,o)
B.d.O(s,r,r+q.b,q.a,0)
q.b=0
q.c=q.a.length
q.a=s}++q.d},
fs(a){var s,r,q,p=this,o=p.a,n=o.length-1,m=p.b,l=p.c
if((a-m&n)>>>0<(l-a&n)>>>0){for(s=a;s!==m;s=r){r=(s-1&n)>>>0
o[s]=o[r]}o[m]=null
p.b=(m+1&n)>>>0
return(a+1&n)>>>0}else{m=p.c=(l-1&n)>>>0
for(s=a;s!==m;s=q){q=(s+1&n)>>>0
o[s]=o[q]}o[m]=null
return a}}}
A.k7.prototype={
gp(){var s=this.e
return s==null?this.$ti.c.a(s):s},
l(){var s,r=this,q=r.a
if(r.c!==q.d)A.v(A.ap(q))
s=r.d
if(s===r.b){r.e=null
return!1}q=q.a
r.e=q[s]
r.d=(s+1&q.length-1)>>>0
return!0}}
A.cr.prototype={
gE(a){return this.gk(this)===0},
gaN(a){return this.gk(this)!==0},
ab(a,b){var s
for(s=J.T(b);s.l();)this.q(0,s.gp())},
cH(a){var s=this.ew(0)
s.ab(0,a)
return s},
bu(a,b){var s=A.as(this,A.p(this).c)
return s},
ev(a){return this.bu(0,!0)},
b6(a,b,c){return new A.cT(this,b,A.p(this).h("@<1>").H(c).h("cT<1,2>"))},
j(a){return A.nu(this,"{","}")},
bN(a,b){return A.xp(this,b,A.p(this).c)},
aS(a,b){return A.xj(this,b,A.p(this).c)},
T(a,b){var s,r
A.aH(b,"index")
s=this.gA(this)
for(r=b;s.l();){if(r===0)return s.gp();--r}throw A.b(A.it(b,b-r,this,null,"index"))},
$iw:1,
$in:1,
$ibu:1}
A.hs.prototype={
ew(a){var s=this.lR()
s.ab(0,this)
return s}}
A.hB.prototype={}
A.k3.prototype={
i(a,b){var s,r=this.b
if(r==null)return this.c.i(0,b)
else if(typeof b!="string")return null
else{s=r[b]
return typeof s=="undefined"?this.m4(b):s}},
gk(a){return this.b==null?this.c.a:this.cR().length},
gE(a){return this.gk(0)===0},
ga2(){if(this.b==null){var s=this.c
return new A.b0(s,A.p(s).h("b0<1>"))}return new A.k4(this)},
m(a,b,c){var s,r,q=this
if(q.b==null)q.c.m(0,b,c)
else if(q.G(b)){s=q.b
s[b]=c
r=q.a
if(r==null?s!=null:r!==s)r[b]=null}else q.mB().m(0,b,c)},
G(a){if(this.b==null)return this.c.G(a)
if(typeof a!="string")return!1
return Object.prototype.hasOwnProperty.call(this.a,a)},
ac(a,b){var s,r,q,p,o=this
if(o.b==null)return o.c.ac(0,b)
s=o.cR()
for(r=0;r<s.length;++r){q=s[r]
p=o.b[q]
if(typeof p=="undefined"){p=A.u_(o.a[q])
o.b[q]=p}b.$2(q,p)
if(s!==o.c)throw A.b(A.ap(o))}},
cR(){var s=this.c
if(s==null)s=this.c=A.u(Object.keys(this.a),t.s)
return s},
mB(){var s,r,q,p,o,n=this
if(n.b==null)return n.c
s=A.Z(t.N,t.z)
r=n.cR()
for(q=0;p=r.length,q<p;++q){o=r[q]
s.m(0,o,n.i(0,o))}if(p===0)r.push("")
else B.d.aC(r)
n.a=n.b=null
return n.c=s},
m4(a){var s
if(!Object.prototype.hasOwnProperty.call(this.a,a))return null
s=A.u_(this.a[a])
return this.b[a]=s}}
A.k4.prototype={
gk(a){return this.a.gk(0)},
T(a,b){var s=this.a
return s.b==null?s.ga2().T(0,b):s.cR()[b]},
gA(a){var s=this.a
if(s.b==null){s=s.ga2()
s=s.gA(s)}else{s=s.cR()
s=new J.dE(s,s.length,A.a8(s).h("dE<1>"))}return s},
S(a,b){return this.a.G(b)}}
A.rT.prototype={
n(){var s,r,q=this
q.kN()
s=q.a
r=s.a
s.a=""
s=q.c.a
s.M(A.yr(r.charCodeAt(0)==0?r:r,q.b))
s.Y()}}
A.tD.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:32}
A.tC.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:32}
A.hS.prototype={
gbJ(){return"us-ascii"},
bi(a){return B.av.ao(a)},
aF(a){var s=B.X.ao(a)
return s},
gd9(){return B.X}}
A.kA.prototype={
ao(a){var s,r,q,p=A.aL(0,null,a.length),o=new Uint8Array(p)
for(s=~this.a,r=0;r<p;++r){q=a.charCodeAt(r)
if((q&s)!==0)throw A.b(A.aV(a,"string","Contains invalid characters."))
o[r]=q}return o},
b9(a){return new A.tv(new A.jO(a),this.a)}}
A.hU.prototype={}
A.tv.prototype={
n(){this.a.a.a.Y()},
ad(a,b,c,d){var s,r,q,p,o
A.aL(b,c,a.length)
for(s=~this.b,r=b;r<c;++r){q=a.charCodeAt(r)
if((q&s)!==0)throw A.b(A.K("Source contains invalid character with code point: "+q+".",null))}s=new A.bq(a)
p=s.gk(0)
A.aL(b,c,p)
s=A.as(s.kp(s,b,c),t.V.h("A.E"))
o=this.a.a.a
o.M(s)
if(d)o.Y()}}
A.kz.prototype={
ao(a){var s,r,q,p=A.aL(0,null,a.length)
for(s=~this.b,r=0;r<p;++r){q=a[r]
if((q&s)!==0){if(!this.a)throw A.b(A.ak("Invalid value in input: "+q,null,null))
return this.lj(a,0,p)}}return A.bL(a,0,p)},
lj(a,b,c){var s,r,q,p
for(s=~this.b,r=b,q="";r<c;++r){p=a[r]
q+=A.aP((p&s)!==0?65533:p)}return q.charCodeAt(0)==0?q:q},
bg(a){return this.hw(a)}}
A.hT.prototype={
b9(a){var s=new A.dr(a)
if(this.a)return new A.rl(new A.kD(new A.cD(!1),s,new A.X("")))
else return new A.ta(s)}}
A.rl.prototype={
n(){this.a.n()},
q(a,b){this.ad(b,0,J.aE(b),!1)},
ad(a,b,c,d){var s,r,q=J.a3(a)
A.aL(b,c,q.gk(a))
for(s=this.a,r=b;r<c;++r)if((q.i(a,r)&4294967168)>>>0!==0){if(r>b)s.ad(a,b,r,!1)
s.ad(B.bb,0,3,!1)
b=r+1}if(b<c)s.ad(a,b,c,!1)}}
A.ta.prototype={
n(){this.a.a.a.Y()},
q(a,b){var s,r
for(s=J.a3(b),r=0;r<s.gk(b);++r)if((s.i(b,r)&4294967168)>>>0!==0)throw A.b(A.ak("Source contains non-ASCII bytes.",null,null))
this.a.a.a.M(A.bL(b,0,null))}}
A.lh.prototype={
ov(a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a="Invalid base64 encoding length "
a2=A.aL(a1,a2,a0.length)
s=$.zo()
for(r=a1,q=r,p=null,o=-1,n=-1,m=0;r<a2;r=l){l=r+1
k=a0.charCodeAt(r)
if(k===37){j=l+2
if(j<=a2){i=A.uE(a0.charCodeAt(l))
h=A.uE(a0.charCodeAt(l+1))
g=i*16+h-(h&256)
if(g===37)g=-1
l=j}else g=-1}else g=k
if(0<=g&&g<=127){f=s[g]
if(f>=0){g=u.U.charCodeAt(f)
if(g===k)continue
k=g}else{if(f===-1){if(o<0){e=p==null?null:p.a.length
if(e==null)e=0
o=e+(r-q)
n=r}++m
if(k===61)continue}k=g}if(f!==-2){if(p==null){p=new A.X("")
e=p}else e=p
e.a+=B.a.t(a0,q,r)
d=A.aP(k)
e.a+=d
q=l
continue}}throw A.b(A.ak("Invalid base64 data",a0,r))}if(p!=null){e=B.a.t(a0,q,a2)
e=p.a+=e
d=e.length
if(o>=0)A.ww(a0,n,a2,o,m,d)
else{c=B.b.aR(d-1,4)+1
if(c===1)throw A.b(A.ak(a,a0,a2))
while(c<4){e+="="
p.a=e;++c}}e=p.a
return B.a.c5(a0,a1,a2,e.charCodeAt(0)==0?e:e)}b=a2-a1
if(o>=0)A.ww(a0,n,a2,o,m,b)
else{c=B.b.aR(b,4)
if(c===1)throw A.b(A.ak(a,a0,a2))
if(c>1)a0=B.a.c5(a0,a2,a2,c===2?"==":"=")}return a0}}
A.hY.prototype={
b9(a){return new A.qv(a,new A.qM(u.U))}}
A.qG.prototype={
j5(a){return new Uint8Array(a)},
ny(a,b,c,d){var s,r=this,q=(r.a&3)+(c-b),p=B.b.V(q,3),o=p*4
if(d&&q-p*3>0)o+=4
s=r.j5(o)
r.a=A.BI(r.b,a,b,c,d,s,0,r.a)
if(o>0)return s
return null}}
A.qM.prototype={
j5(a){var s=this.c
if(s==null||s.length<a)s=this.c=new Uint8Array(a)
return J.cJ(B.f.gan(s),s.byteOffset,a)}}
A.qH.prototype={
q(a,b){this.hR(b,0,J.aE(b),!1)},
n(){this.hR(B.bh,0,0,!0)}}
A.qv.prototype={
hR(a,b,c,d){var s=this.b.ny(a,b,c,d)
if(s!=null)this.a.a.M(A.bL(s,0,null))
if(d)this.a.a.Y()}}
A.lu.prototype={}
A.jO.prototype={
q(a,b){this.a.a.M(b)},
n(){this.a.a.Y()}}
A.jP.prototype={
q(a,b){var s,r,q=this,p=q.b,o=q.c,n=J.a3(b)
if(n.gk(b)>p.length-o){p=q.b
s=n.gk(b)+p.length-1
s|=B.b.a1(s,1)
s|=s>>>2
s|=s>>>4
s|=s>>>8
r=new Uint8Array((((s|s>>>16)>>>0)+1)*2)
p=q.b
B.f.ai(r,0,p.length,p)
q.b=r}p=q.b
o=q.c
B.f.ai(p,o,o+n.gk(b),b)
q.c=q.c+n.gk(b)},
n(){this.a.$1(B.f.bR(this.b,0,this.c))}}
A.i7.prototype={}
A.dk.prototype={
q(a,b){this.b.q(0,b)},
ae(a,b){A.ba(a,"error",t.K)
this.a.ae(a,b)},
n(){this.b.n()},
$iaj:1}
A.i8.prototype={}
A.af.prototype={
b9(a){throw A.b(A.Q("This converter does not support chunked conversions: "+this.j(0)))},
bg(a){return new A.c7(new A.m0(this),a,t.fM.H(A.p(this).h("af.T")).h("c7<1,2>"))}}
A.m0.prototype={
$1(a){return new A.dk(a,this.a.b9(a))},
$S:149}
A.cV.prototype={
n6(a){return this.gd9().bg(a).nO(0,new A.X(""),new A.mG(),t.of).aQ(new A.mH(),t.N)}}
A.mG.prototype={
$2(a,b){a.a+=b
return a},
$S:161}
A.mH.prototype={
$1(a){var s=a.a
return s.charCodeAt(0)==0?s:s},
$S:62}
A.fl.prototype={
j(a){var s=A.ij(this.a)
return(this.b!=null?"Converting object to an encodable object failed:":"Converting object did not return an encodable object:")+" "+s}}
A.iC.prototype={
j(a){return"Cyclic error in JSON stringify"}}
A.nx.prototype={
c2(a,b){var s=A.yr(a,this.gd9().a)
return s},
aF(a){return this.c2(a,null)},
fP(a,b){var s=A.C2(a,this.gnz().b,null)
return s},
bi(a){return this.fP(a,null)},
gnz(){return B.b9},
gd9(){return B.b8}}
A.iE.prototype={
b9(a){return new A.rU(null,this.b,new A.dr(a))}}
A.rU.prototype={
q(a,b){var s,r,q,p=this
if(p.d)throw A.b(A.D("Only one call to add allowed"))
p.d=!0
s=p.c
r=new A.X("")
q=new A.to(r,s)
A.xM(b,q,p.b,p.a)
if(r.a.length!==0)q.f8()
s.n()},
n(){}}
A.iD.prototype={
b9(a){return new A.rT(this.a,a,new A.X(""))}}
A.rW.prototype={
jO(a){var s,r,q,p,o,n=this,m=a.length
for(s=0,r=0;r<m;++r){q=a.charCodeAt(r)
if(q>92){if(q>=55296){p=q&64512
if(p===55296){o=r+1
o=!(o<m&&(a.charCodeAt(o)&64512)===56320)}else o=!1
if(!o)if(p===56320){p=r-1
p=!(p>=0&&(a.charCodeAt(p)&64512)===55296)}else p=!1
else p=!0
if(p){if(r>s)n.eC(a,s,r)
s=r+1
n.a4(92)
n.a4(117)
n.a4(100)
p=q>>>8&15
n.a4(p<10?48+p:87+p)
p=q>>>4&15
n.a4(p<10?48+p:87+p)
p=q&15
n.a4(p<10?48+p:87+p)}}continue}if(q<32){if(r>s)n.eC(a,s,r)
s=r+1
n.a4(92)
switch(q){case 8:n.a4(98)
break
case 9:n.a4(116)
break
case 10:n.a4(110)
break
case 12:n.a4(102)
break
case 13:n.a4(114)
break
default:n.a4(117)
n.a4(48)
n.a4(48)
p=q>>>4&15
n.a4(p<10?48+p:87+p)
p=q&15
n.a4(p<10?48+p:87+p)
break}}else if(q===34||q===92){if(r>s)n.eC(a,s,r)
s=r+1
n.a4(92)
n.a4(q)}}if(s===0)n.au(a)
else if(s<m)n.eC(a,s,m)},
eU(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<r;++q){p=s[q]
if(a==null?p==null:a===p)throw A.b(new A.iC(a,null))}s.push(a)},
eB(a){var s,r,q,p,o=this
if(o.jN(a))return
o.eU(a)
try{s=o.b.$1(a)
if(!o.jN(s)){q=A.wV(a,null,o.gij())
throw A.b(q)}o.a.pop()}catch(p){r=A.H(p)
q=A.wV(a,r,o.gij())
throw A.b(q)}},
jN(a){var s,r=this
if(typeof a=="number"){if(!isFinite(a))return!1
r.p5(a)
return!0}else if(a===!0){r.au("true")
return!0}else if(a===!1){r.au("false")
return!0}else if(a==null){r.au("null")
return!0}else if(typeof a=="string"){r.au('"')
r.jO(a)
r.au('"')
return!0}else if(t.j.b(a)){r.eU(a)
r.p_(a)
r.a.pop()
return!0}else if(t.av.b(a)){r.eU(a)
s=r.p0(a)
r.a.pop()
return s}else return!1},
p_(a){var s,r,q=this
q.au("[")
s=J.a3(a)
if(s.gaN(a)){q.eB(s.i(a,0))
for(r=1;r<s.gk(a);++r){q.au(",")
q.eB(s.i(a,r))}}q.au("]")},
p0(a){var s,r,q,p,o=this,n={}
if(a.gE(a)){o.au("{}")
return!0}s=a.gk(a)*2
r=A.b1(s,null,!1,t.X)
q=n.a=0
n.b=!0
a.ac(0,new A.rX(n,r))
if(!n.b)return!1
o.au("{")
for(p='"';q<s;q+=2,p=',"'){o.au(p)
o.jO(A.an(r[q]))
o.au('":')
o.eB(r[q+1])}o.au("}")
return!0}}
A.rX.prototype={
$2(a,b){var s,r,q,p
if(typeof a!="string")this.a.b=!1
s=this.b
r=this.a
q=r.a
p=r.a=q+1
s[q]=a
r.a=p+1
s[p]=b},
$S:36}
A.rV.prototype={
gij(){var s=this.c
return s instanceof A.X?s.j(0):null},
p5(a){this.c.eA(B.a6.j(a))},
au(a){this.c.eA(a)},
eC(a,b,c){this.c.eA(B.a.t(a,b,c))},
a4(a){this.c.a4(a)}}
A.iF.prototype={
gbJ(){return"iso-8859-1"},
bi(a){return B.ba.ao(a)},
aF(a){var s=B.a7.ao(a)
return s},
gd9(){return B.a7}}
A.iH.prototype={}
A.iG.prototype={
b9(a){var s=new A.dr(a)
if(!this.a)return new A.k5(s)
return new A.rY(s)}}
A.k5.prototype={
n(){this.a.a.a.Y()
this.a=null},
q(a,b){this.ad(b,0,J.aE(b),!1)},
hE(a,b,c,d){var s=this.a
s.toString
s.a.a.M(A.bL(a,b,c))},
ad(a,b,c,d){A.aL(b,c,J.aE(a))
if(b===c)return
if(!t.p.b(a))A.C3(a,b,c)
this.hE(a,b,c,!1)}}
A.rY.prototype={
ad(a,b,c,d){var s,r,q,p,o="Stream is already closed",n=J.a3(a)
A.aL(b,c,n.gk(a))
for(s=b;s<c;++s){r=n.i(a,s)
if(r>255||r<0){if(s>b){q=this.a
q.toString
p=A.bL(a,b,s)
q=q.a.a
if((q.e&2)!==0)A.v(A.D(o))
q.bS(p)}q=this.a
q.toString
p=A.bL(B.bc,0,1)
q=q.a.a
if((q.e&2)!==0)A.v(A.D(o))
q.bS(p)
b=s+1}}if(b<c)this.hE(a,b,c,!1)}}
A.ny.prototype={
bg(a){return new A.c7(A.E7(),a,t.it)}}
A.rZ.prototype={
ad(a,b,c,d){var s=this
c=A.aL(b,c,a.length)
if(b<c){if(s.d){if(a.charCodeAt(b)===10)++b
s.d=!1}s.l7(a,b,c,d)}if(d)s.n()},
n(){var s=this,r=s.b
if(r!=null)s.a.a.a.M(s.fB(r,""))
s.a.a.a.Y()},
l7(a,b,c,d){var s,r,q,p,o,n,m,l,k=this,j=k.b
for(s=k.a.a.a,r=b,q=r,p=0;r<c;++r,p=o){o=a.charCodeAt(r)
if(o!==13){if(o!==10)continue
if(p===13){q=r+1
continue}}n=B.a.t(a,q,r)
if(j!=null){n=k.fB(j,n)
j=null}if((s.e&2)!==0)A.v(A.D("Stream is already closed"))
s.bS(n)
q=r+1}if(q<c){m=B.a.t(a,q,c)
if(d){s.M(j!=null?k.fB(j,m):m)
return}if(j==null)k.b=m
else{l=k.c
if(l==null)l=k.c=new A.X("")
if(j.length!==0){l.a+=j
k.b=""}l.a+=m}}else k.d=p===13},
fB(a,b){var s,r
this.b=null
if(a.length!==0)return a+b
s=this.c
r=s.a+=b
s.a=""
return r.charCodeAt(0)==0?r:r}}
A.eu.prototype={
ae(a,b){this.e.ae(a,b)},
$iaj:1}
A.jl.prototype={
q(a,b){this.ad(b,0,b.length,!1)}}
A.to.prototype={
a4(a){var s=this.a,r=A.aP(a)
if((s.a+=r).length>16)this.f8()},
eA(a){if(this.a.a.length!==0)this.f8()
this.b.q(0,a)},
f8(){var s=this.a,r=s.a
s.a=""
this.b.q(0,r.charCodeAt(0)==0?r:r)}}
A.hv.prototype={
n(){},
ad(a,b,c,d){var s,r,q
if(b!==0||c!==a.length)for(s=this.a,r=b;r<c;++r){q=A.aP(a.charCodeAt(r))
s.a+=q}else this.a.a+=a
if(d)this.n()},
q(a,b){this.a.a+=b}}
A.dr.prototype={
q(a,b){this.a.a.M(b)},
ad(a,b,c,d){var s=b===0&&c===a.length,r=this.a.a
if(s)r.M(a)
else r.M(B.a.t(a,b,c))
if(d)r.Y()},
n(){this.a.a.Y()}}
A.kD.prototype={
n(){var s,r,q,p=this.c
this.a.nN(p)
s=p.a
r=this.b
if(s.length!==0){q=s.charCodeAt(0)==0?s:s
p.a=""
r.ad(q,0,q.length,!0)}else r.n()},
q(a,b){this.ad(b,0,J.aE(b),!1)},
ad(a,b,c,d){var s,r=this,q=r.c,p=r.a.cS(a,b,c,!1)
p=q.a+=p
if(p.length!==0){s=p.charCodeAt(0)==0?p:p
r.b.ad(s,0,s.length,d)
q.a=""
return}if(d)r.n()}}
A.jy.prototype={
gbJ(){return"utf-8"},
aF(a){return new A.cD(!1).cS(a,0,null,!0)},
bi(a){return B.n.ao(a)},
gd9(){return B.aq}}
A.jA.prototype={
ao(a){var s,r,q=A.aL(0,null,a.length)
if(q===0)return new Uint8Array(0)
s=new Uint8Array(q*3)
r=new A.kE(s)
if(r.i1(a,0,q)!==q)r.dV()
return B.f.bR(s,0,r.b)},
b9(a){return new A.tE(new A.jO(a),new Uint8Array(1024))}}
A.kE.prototype={
dV(){var s=this,r=s.c,q=s.b,p=s.b=q+1
r.$flags&2&&A.C(r)
r[q]=239
q=s.b=p+1
r[p]=191
s.b=q+1
r[q]=189},
iS(a,b){var s,r,q,p,o=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=o.c
q=o.b
p=o.b=q+1
r.$flags&2&&A.C(r)
r[q]=s>>>18|240
q=o.b=p+1
r[p]=s>>>12&63|128
p=o.b=q+1
r[q]=s>>>6&63|128
o.b=p+1
r[p]=s&63|128
return!0}else{o.dV()
return!1}},
i1(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c&&(a.charCodeAt(c-1)&64512)===55296)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=b;p<c;++p){o=a.charCodeAt(p)
if(o<=127){n=k.b
if(n>=q)break
k.b=n+1
r&2&&A.C(s)
s[n]=o}else{n=o&64512
if(n===55296){if(k.b+4>q)break
m=p+1
if(k.iS(o,a.charCodeAt(m)))p=m}else if(n===56320){if(k.b+3>q)break
k.dV()}else if(o<=2047){n=k.b
l=n+1
if(l>=q)break
k.b=l
r&2&&A.C(s)
s[n]=o>>>6|192
k.b=l+1
s[l]=o&63|128}else{n=k.b
if(n+2>=q)break
l=k.b=n+1
r&2&&A.C(s)
s[n]=o>>>12|224
n=k.b=l+1
s[l]=o>>>6&63|128
k.b=n+1
s[n]=o&63|128}}}return p}}
A.tE.prototype={
n(){if(this.a!==0){this.ad("",0,0,!0)
return}this.d.a.a.Y()},
ad(a,b,c,d){var s,r,q,p,o,n=this
n.b=0
s=b===c
if(s&&!d)return
r=n.a
if(r!==0){if(n.iS(r,!s?a.charCodeAt(b):0))++b
n.a=0}s=n.d
r=n.c
q=c-1
p=r.length-3
do{b=n.i1(a,b,c)
o=d&&b===c
if(b===q&&(a.charCodeAt(b)&64512)===55296){if(d&&n.b<p)n.dV()
else n.a=a.charCodeAt(b);++b}s.q(0,B.f.bR(r,0,n.b))
if(o)s.n()
n.b=0}while(b<c)
if(d)n.n()}}
A.jz.prototype={
b9(a){return new A.kD(new A.cD(this.a),new A.dr(a),new A.X(""))},
bg(a){return this.hw(a)}}
A.cD.prototype={
cS(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.aL(b,c,J.aE(a))
if(b===l)return""
if(a instanceof Uint8Array){s=a
r=s
q=0}else{r=A.CC(a,b,l)
l-=b
q=b
b=0}if(d&&l-b>=15){p=m.a
o=A.CB(p,r,b,l)
if(o!=null){if(!p)return o
if(o.indexOf("\ufffd")<0)return o}}o=m.f4(r,b,l,d)
p=m.b
if((p&1)!==0){n=A.y9(p)
m.b=0
throw A.b(A.ak(n,a,q+m.c))}return o},
f4(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.b.V(b+c,2)
r=q.f4(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.f4(a,s,c,d)}return q.n5(a,b,c,d)},
nN(a){var s,r=this.b
this.b=0
if(r<=32)return
if(this.a){s=A.aP(65533)
a.a+=s}else throw A.b(A.ak(A.y9(77),null,null))},
n5(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.X(""),g=b+1,f=a[b]
A:for(s=l.a;;){for(;;g=p){r="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE".charCodeAt(f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA".charCodeAt(j+r)
if(j===0){q=A.aP(i)
h.a+=q
if(g===c)break A
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:q=A.aP(k)
h.a+=q
break
case 65:q=A.aP(k)
h.a+=q;--g
break
default:q=A.aP(k)
h.a=(h.a+=q)+q
break}else{l.b=j
l.c=g-1
return""}j=0}if(g===c)break A
p=g+1
f=a[g]}p=g+1
f=a[g]
if(f<128){for(;;){if(!(p<c)){o=c
break}n=p+1
f=a[p]
if(f>=128){o=n-1
p=n
break}p=n}if(o-g<20)for(m=g;m<o;++m){q=A.aP(a[m])
h.a+=q}else{q=A.bL(a,g,o)
h.a+=q}if(o===c)break A
g=p}else g=p}if(d&&j>32)if(s){s=A.aP(k)
h.a+=s}else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.kJ.prototype={}
A.az.prototype={
bx(a){var s,r,q=this,p=q.c
if(p===0)return q
s=!q.a
r=q.b
p=A.bh(p,r)
return new A.az(p===0?!1:s,r,p)},
lo(a){var s,r,q,p,o,n,m,l=this,k=l.c
if(k===0)return $.ce()
s=k-a
if(s<=0)return l.a?$.wm():$.ce()
r=l.b
q=new Uint16Array(s)
for(p=a;p<k;++p)q[p-a]=r[p]
o=l.a
n=A.bh(s,q)
m=new A.az(n===0?!1:o,q,n)
if(o)for(p=0;p<a;++p)if(r[p]!==0)return m.eM(0,$.kY())
return m},
cM(a,b){var s,r,q,p,o,n,m,l,k,j=this
if(b<0)throw A.b(A.K("shift-amount must be posititve "+b,null))
s=j.c
if(s===0)return j
r=B.b.V(b,16)
q=B.b.aR(b,16)
if(q===0)return j.lo(r)
p=s-r
if(p<=0)return j.a?$.wm():$.ce()
o=j.b
n=new Uint16Array(p)
A.BO(o,s,b,n)
s=j.a
m=A.bh(p,n)
l=new A.az(m===0?!1:s,n,m)
if(s){if((o[r]&B.b.cL(1,q)-1)>>>0!==0)return l.eM(0,$.kY())
for(k=0;k<r;++k)if(o[k]!==0)return l.eM(0,$.kY())}return l},
Z(a,b){var s,r=this.a
if(r===b.a){s=A.qJ(this.b,this.c,b.b,b.c)
return r?0-s:s}return r?-1:1},
eP(a,b){var s,r,q,p=this,o=p.c,n=a.c
if(o<n)return a.eP(p,b)
if(o===0)return $.ce()
if(n===0)return p.a===b?p:p.bx(0)
s=o+1
r=new Uint16Array(s)
A.BJ(p.b,o,a.b,n,r)
q=A.bh(s,r)
return new A.az(q===0?!1:b,r,q)},
dJ(a,b){var s,r,q,p=this,o=p.c
if(o===0)return $.ce()
s=a.c
if(s===0)return p.a===b?p:p.bx(0)
r=new Uint16Array(o)
A.jL(p.b,o,a.b,s,r)
q=A.bh(o,r)
return new A.az(q===0?!1:b,r,q)},
dD(a,b){var s,r,q=this,p=q.c
if(p===0)return b
s=b.c
if(s===0)return q
r=q.a
if(r===b.a)return q.eP(b,r)
if(A.qJ(q.b,p,b.b,s)>=0)return q.dJ(b,r)
return b.dJ(q,!r)},
eM(a,b){var s,r,q=this,p=q.c
if(p===0)return b.bx(0)
s=b.c
if(s===0)return q
r=q.a
if(r!==b.a)return q.eP(b,r)
if(A.qJ(q.b,p,b.b,s)>=0)return q.dJ(b,r)
return b.dJ(q,!r)},
aH(a,b){var s,r,q,p,o,n,m,l=this.c,k=b.c
if(l===0||k===0)return $.ce()
s=l+k
r=this.b
q=b.b
p=new Uint16Array(s)
for(o=0;o<k;){A.xD(q[o],r,0,p,o,l);++o}n=this.a!==b.a
m=A.bh(s,p)
return new A.az(m===0?!1:n,p,m)},
lm(a){var s,r,q,p
if(this.c<a.c)return $.ce()
this.hX(a)
s=$.vG.aT()-$.h1.aT()
r=A.vI($.vF.aT(),$.h1.aT(),$.vG.aT(),s)
q=A.bh(s,r)
p=new A.az(!1,r,q)
return this.a!==a.a&&q>0?p.bx(0):p},
mb(a){var s,r,q,p=this
if(p.c<a.c)return p
p.hX(a)
s=A.vI($.vF.aT(),0,$.h1.aT(),$.h1.aT())
r=A.bh($.h1.aT(),s)
q=new A.az(!1,s,r)
if($.vH.aT()>0)q=q.cM(0,$.vH.aT())
return p.a&&q.c>0?q.bx(0):q},
hX(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.c
if(b===$.xA&&a.c===$.xC&&c.b===$.xz&&a.b===$.xB)return
s=a.b
r=a.c
q=16-B.b.gj_(s[r-1])
if(q>0){p=new Uint16Array(r+5)
o=A.xy(s,r,q,p)
n=new Uint16Array(b+5)
m=A.xy(c.b,b,q,n)}else{n=A.vI(c.b,0,b,b+2)
o=r
p=s
m=b}l=p[o-1]
k=m-o
j=new Uint16Array(m)
i=A.vJ(p,o,k,j)
h=m+1
g=n.$flags|0
if(A.qJ(n,m,j,i)>=0){g&2&&A.C(n)
n[m]=1
A.jL(n,h,j,i,n)}else{g&2&&A.C(n)
n[m]=0}f=new Uint16Array(o+2)
f[o]=1
A.jL(f,o+1,p,o,f)
e=m-1
while(k>0){d=A.BK(l,n,e);--k
A.xD(d,f,0,n,k,o)
if(n[e]<d){i=A.vJ(f,o,k,j)
A.jL(n,h,j,i,n)
while(--d,n[e]<d)A.jL(n,h,j,i,n)}--e}$.xz=c.b
$.xA=b
$.xB=s
$.xC=r
$.vF.b=n
$.vG.b=h
$.h1.b=o
$.vH.b=q},
gv(a){var s,r,q,p=new A.qK(),o=this.c
if(o===0)return 6707
s=this.a?83585:429689
for(r=this.b,q=0;q<o;++q)s=p.$2(s,r[q])
return new A.qL().$1(s)},
D(a,b){if(b==null)return!1
return b instanceof A.az&&this.Z(0,b)===0},
j(a){var s,r,q,p,o,n=this,m=n.c
if(m===0)return"0"
if(m===1){if(n.a)return B.b.j(-n.b[0])
return B.b.j(n.b[0])}s=A.u([],t.s)
m=n.a
r=m?n.bx(0):n
while(r.c>1){q=$.wl()
if(q.c===0)A.v(B.aB)
p=r.mb(q).j(0)
s.push(p)
o=p.length
if(o===1)s.push("000")
if(o===2)s.push("00")
if(o===3)s.push("0")
r=r.lm(q)}s.push(B.b.j(r.b[0]))
if(m)s.push("-")
return new A.d4(s,t.hF).oe(0)},
$ia7:1}
A.qK.prototype={
$2(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
$S:63}
A.qL.prototype={
$1(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
$S:75}
A.jX.prototype={
iX(a,b,c){var s=this.a
if(s!=null)s.register(a,b,c)},
ja(a){var s=this.a
if(s!=null)s.unregister(a)}}
A.bb.prototype={
D(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.bb)if(this.a===b.a)s=this.b===b.b
return s},
gv(a){return A.bG(this.a,this.b,B.c,B.c,B.c,B.c,B.c,B.c,B.c,B.c)},
Z(a,b){var s=B.b.Z(this.a,b.a)
if(s!==0)return s
return B.b.Z(this.b,b.b)},
j(a){var s=this,r=A.Ad(A.xb(s)),q=A.ie(A.x9(s)),p=A.ie(A.x6(s)),o=A.ie(A.x7(s)),n=A.ie(A.x8(s)),m=A.ie(A.xa(s)),l=A.wH(A.AW(s)),k=s.b,j=k===0?"":A.wH(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j},
$ia7:1}
A.aX.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.aX&&this.a===b.a},
gv(a){return B.b.gv(this.a)},
Z(a,b){return B.b.Z(this.a,b.a)},
j(a){var s,r,q,p,o,n=this.a,m=B.b.V(n,36e8),l=n%36e8
if(n<0){m=0-m
n=0-l
s="-"}else{n=l
s=""}r=B.b.V(n,6e7)
n%=6e7
q=r<10?"0":""
p=B.b.V(n,1e6)
o=p<10?"0":""
return s+m+":"+q+r+":"+o+p+"."+B.a.oB(B.b.j(n%1e6),6,"0")},
$ia7:1}
A.rj.prototype={
j(a){return this.aA()}}
A.V.prototype={
gby(){return A.AV(this)}}
A.hV.prototype={
j(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.ij(s)
return"Assertion failed"}}
A.c3.prototype={}
A.a4.prototype={
gf7(){return"Invalid argument"+(!this.a?"(s)":"")},
gf6(){return""},
j(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.q(p),n=s.gf7()+q+o
if(!s.a)return n
return n+s.gf6()+": "+A.ij(s.gh_())},
gh_(){return this.b}}
A.e2.prototype={
gh_(){return this.b},
gf7(){return"RangeError"},
gf6(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.q(q):""
else if(q==null)s=": Not greater than or equal to "+A.q(r)
else if(q>r)s=": Not in inclusive range "+A.q(r)+".."+A.q(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.q(r)
return s}}
A.fg.prototype={
gh_(){return this.b},
gf7(){return"RangeError"},
gf6(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gk(a){return this.f}}
A.fP.prototype={
j(a){return"Unsupported operation: "+this.a}}
A.jq.prototype={
j(a){var s=this.a
return s!=null?"UnimplementedError: "+s:"UnimplementedError"}}
A.b5.prototype={
j(a){return"Bad state: "+this.a}}
A.i9.prototype={
j(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.ij(s)+"."}}
A.iV.prototype={
j(a){return"Out of Memory"},
gby(){return null},
$iV:1}
A.fG.prototype={
j(a){return"Stack Overflow"},
gby(){return null},
$iV:1}
A.jW.prototype={
j(a){return"Exception: "+this.a},
$iP:1}
A.aR.prototype={
j(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.a.t(e,0,75)+"..."
return g+"\n"+e}for(r=1,q=0,p=!1,o=0;o<f;++o){n=e.charCodeAt(o)
if(n===10){if(q!==o||!p)++r
q=o+1
p=!1}else if(n===13){++r
q=o+1
p=!0}}g=r>1?g+(" (at line "+r+", character "+(f-q+1)+")\n"):g+(" (at character "+(f+1)+")\n")
m=e.length
for(o=f;o<m;++o){n=e.charCodeAt(o)
if(n===10||n===13){m=o
break}}l=""
if(m-q>78){k="..."
if(f-q<75){j=q+75
i=q}else{if(m-f<75){i=m-75
j=m
k=""}else{i=f-36
j=f+36}l="..."}}else{j=m
i=q
k=""}return g+l+B.a.t(e,i,j)+k+"\n"+B.a.aH(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.q(f)+")"):g},
$iP:1,
gjw(){return this.a},
gdH(){return this.b},
ga7(){return this.c}}
A.iv.prototype={
gby(){return null},
j(a){return"IntegerDivisionByZeroException"},
$iV:1,
$iP:1}
A.n.prototype={
d7(a,b){return A.i4(this,A.p(this).h("n.E"),b)},
b6(a,b,c){return A.fr(this,b,A.p(this).h("n.E"),c)},
S(a,b){var s
for(s=this.gA(this);s.l();)if(J.z(s.gp(),b))return!0
return!1},
bu(a,b){var s=A.p(this).h("n.E")
if(b)s=A.as(this,s)
else{s=A.as(this,s)
s.$flags=1
s=s}return s},
ev(a){return this.bu(0,!0)},
gk(a){var s,r=this.gA(this)
for(s=0;r.l();)++s
return s},
gE(a){return!this.gA(this).l()},
gaN(a){return!this.gE(this)},
bN(a,b){return A.xp(this,b,A.p(this).h("n.E"))},
aS(a,b){return A.xj(this,b,A.p(this).h("n.E"))},
gaf(a){var s=this.gA(this)
if(!s.l())throw A.b(A.bW())
return s.gp()},
T(a,b){var s,r
A.aH(b,"index")
s=this.gA(this)
for(r=b;s.l();){if(r===0)return s.gp();--r}throw A.b(A.it(b,b-r,this,null,"index"))},
j(a){return A.Az(this,"(",")")}}
A.M.prototype={
j(a){return"MapEntry("+A.q(this.a)+": "+A.q(this.b)+")"}}
A.F.prototype={
gv(a){return A.k.prototype.gv.call(this,0)},
j(a){return"null"}}
A.k.prototype={$ik:1,
D(a,b){return this===b},
gv(a){return A.e1(this)},
j(a){return"Instance of '"+A.j_(this)+"'"},
ga3(a){return A.uD(this)},
toString(){return this.j(this)}}
A.kv.prototype={
j(a){return""},
$iae:1}
A.X.prototype={
gk(a){return this.a.length},
eA(a){var s=A.q(a)
this.a+=s},
a4(a){var s=A.aP(a)
this.a+=s},
j(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.pF.prototype={
$2(a,b){throw A.b(A.ak("Illegal IPv6 address, "+a,this.a,b))},
$S:56}
A.hC.prototype={
giI(){var s,r,q,p,o=this,n=o.w
if(n===$){s=o.a
r=s.length!==0?s+":":""
q=o.c
p=q==null
if(!p||s==="file"){s=r+"//"
r=o.b
if(r.length!==0)s=s+r+"@"
if(!p)s+=q
r=o.d
if(r!=null)s=s+":"+A.q(r)}else s=r
s+=o.e
r=o.f
if(r!=null)s=s+"?"+r
r=o.r
if(r!=null)s=s+"#"+r
n=o.w=s.charCodeAt(0)==0?s:s}return n},
goD(){var s,r,q=this,p=q.x
if(p===$){s=q.e
if(s.length!==0&&s.charCodeAt(0)===47)s=B.a.a0(s,1)
r=s.length===0?B.J:A.nC(new A.aa(A.u(s.split("/"),t.s),A.E9(),t.iZ),t.N)
q.x!==$&&A.wh()
p=q.x=r}return p},
gv(a){var s,r=this,q=r.y
if(q===$){s=B.a.gv(r.giI())
r.y!==$&&A.wh()
r.y=s
q=s}return q},
ghh(){return this.b},
gbF(){var s=this.c
if(s==null)return""
if(B.a.K(s,"[")&&!B.a.P(s,"v",1))return B.a.t(s,1,s.length-1)
return s},
gdr(){var s=this.d
return s==null?A.xY(this.a):s},
gdt(){var s=this.f
return s==null?"":s},
gec(){var s=this.r
return s==null?"":s},
eg(a){var s=this.a
if(a.length!==s.length)return!1
return A.yg(a,s,0)>=0},
jK(a){var s,r,q,p,o,n,m,l=this
a=A.vR(a,0,a.length)
s=a==="file"
r=l.b
q=l.d
if(a!==l.a)q=A.tB(q,a)
p=l.c
if(!(p!=null))p=r.length!==0||q!=null||s?"":null
o=l.e
if(!s)n=p!=null&&o.length!==0
else n=!0
if(n&&!B.a.K(o,"/"))o="/"+o
m=o
return A.hD(a,r,p,q,m,l.f,l.r)},
ih(a,b){var s,r,q,p,o,n,m
for(s=0,r=0;B.a.P(b,"../",r);){r+=3;++s}q=B.a.cA(a,"/")
for(;;){if(!(q>0&&s>0))break
p=B.a.eh(a,"/",q-1)
if(p<0)break
o=q-p
n=o!==2
m=!1
if(!n||o===3)if(a.charCodeAt(p+1)===46)n=!n||a.charCodeAt(p+2)===46
else n=m
else n=m
if(n)break;--s
q=p}return B.a.c5(a,q+1,null,B.a.a0(b,r-3*s))},
dv(a){return this.dw(A.de(a))},
dw(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
if(a.gaw().length!==0)return a
else{s=h.a
if(a.gfV()){r=a.jK(s)
return r}else{q=h.b
p=h.c
o=h.d
n=h.e
if(a.gjp())m=a.gee()?a.gdt():h.f
else{l=A.CA(h,n)
if(l>0){k=B.a.t(n,0,l)
n=a.gfU()?k+A.du(a.gaP()):k+A.du(h.ih(B.a.a0(n,k.length),a.gaP()))}else if(a.gfU())n=A.du(a.gaP())
else if(n.length===0)if(p==null)n=s.length===0?a.gaP():A.du(a.gaP())
else n=A.du("/"+a.gaP())
else{j=h.ih(n,a.gaP())
r=s.length===0
if(!r||p!=null||B.a.K(n,"/"))n=A.du(j)
else n=A.vT(j,!r||p!=null)}m=a.gee()?a.gdt():null}}}i=a.gfW()?a.gec():null
return A.hD(s,q,p,o,n,m,i)},
gfV(){return this.c!=null},
gee(){return this.f!=null},
gfW(){return this.r!=null},
gjp(){return this.e.length===0},
gfU(){return B.a.K(this.e,"/")},
hf(){var s,r=this,q=r.a
if(q!==""&&q!=="file")throw A.b(A.Q("Cannot extract a file path from a "+q+" URI"))
q=r.f
if((q==null?"":q)!=="")throw A.b(A.Q(u.z))
q=r.r
if((q==null?"":q)!=="")throw A.b(A.Q(u.A))
if(r.c!=null&&r.gbF()!=="")A.v(A.Q(u.Q))
s=r.goD()
A.Cv(s,!1)
q=A.vw(B.a.K(r.e,"/")?"/":"",s,"/")
q=q.charCodeAt(0)==0?q:q
return q},
j(a){return this.giI()},
D(a,b){var s,r,q,p=this
if(b==null)return!1
if(p===b)return!0
s=!1
if(t.R.b(b))if(p.a===b.gaw())if(p.c!=null===b.gfV())if(p.b===b.ghh())if(p.gbF()===b.gbF())if(p.gdr()===b.gdr())if(p.e===b.gaP()){r=p.f
q=r==null
if(!q===b.gee()){if(q)r=""
if(r===b.gdt()){r=p.r
q=r==null
if(!q===b.gfW()){s=q?"":r
s=s===b.gec()}}}}return s},
$ijw:1,
gaw(){return this.a},
gaP(){return this.e}}
A.pE.prototype={
gjM(){var s,r,q,p,o=this,n=null,m=o.c
if(m==null){m=o.a
s=o.b[0]+1
r=B.a.bl(m,"?",s)
q=m.length
if(r>=0){p=A.hE(m,r+1,q,256,!1,!1)
q=r}else p=n
m=o.c=new A.jT("data","",n,n,A.hE(m,s,q,128,!1,!1),p,n)}return m},
j(a){var s=this.a
return this.b[0]===-1?"data:"+s:s}}
A.bk.prototype={
gfV(){return this.c>0},
gfX(){return this.c>0&&this.d+1<this.e},
gee(){return this.f<this.r},
gfW(){return this.r<this.a.length},
gfU(){return B.a.P(this.a,"/",this.e)},
gjp(){return this.e===this.f},
eg(a){var s=a.length
if(s===0)return this.b<0
if(s!==this.b)return!1
return A.yg(a,this.a,0)>=0},
gaw(){var s=this.w
return s==null?this.w=this.lh():s},
lh(){var s,r=this,q=r.b
if(q<=0)return""
s=q===4
if(s&&B.a.K(r.a,"http"))return"http"
if(q===5&&B.a.K(r.a,"https"))return"https"
if(s&&B.a.K(r.a,"file"))return"file"
if(q===7&&B.a.K(r.a,"package"))return"package"
return B.a.t(r.a,0,q)},
ghh(){var s=this.c,r=this.b+3
return s>r?B.a.t(this.a,r,s-1):""},
gbF(){var s=this.c
return s>0?B.a.t(this.a,s,this.d):""},
gdr(){var s,r=this
if(r.gfX())return A.yR(B.a.t(r.a,r.d+1,r.e))
s=r.b
if(s===4&&B.a.K(r.a,"http"))return 80
if(s===5&&B.a.K(r.a,"https"))return 443
return 0},
gaP(){return B.a.t(this.a,this.e,this.f)},
gdt(){var s=this.f,r=this.r
return s<r?B.a.t(this.a,s+1,r):""},
gec(){var s=this.r,r=this.a
return s<r.length?B.a.a0(r,s+1):""},
ib(a){var s=this.d+1
return s+a.length===this.e&&B.a.P(this.a,a,s)},
oL(){var s=this,r=s.r,q=s.a
if(r>=q.length)return s
return new A.bk(B.a.t(q,0,r),s.b,s.c,s.d,s.e,s.f,r,s.w)},
jK(a){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null
a=A.vR(a,0,a.length)
s=!(h.b===a.length&&B.a.K(h.a,a))
r=a==="file"
q=h.c
p=q>0?B.a.t(h.a,h.b+3,q):""
o=h.gfX()?h.gdr():g
if(s)o=A.tB(o,a)
q=h.c
if(q>0)n=B.a.t(h.a,q,h.d)
else n=p.length!==0||o!=null||r?"":g
q=h.a
m=h.f
l=B.a.t(q,h.e,m)
if(!r)k=n!=null&&l.length!==0
else k=!0
if(k&&!B.a.K(l,"/"))l="/"+l
k=h.r
j=m<k?B.a.t(q,m+1,k):g
m=h.r
i=m<q.length?B.a.a0(q,m+1):g
return A.hD(a,p,n,o,l,j,i)},
dv(a){return this.dw(A.de(a))},
dw(a){if(a instanceof A.bk)return this.mr(this,a)
return this.iK().dw(a)},
mr(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=b.b
if(c>0)return b
s=b.c
if(s>0){r=a.b
if(r<=0)return b
q=r===4
if(q&&B.a.K(a.a,"file"))p=b.e!==b.f
else if(q&&B.a.K(a.a,"http"))p=!b.ib("80")
else p=!(r===5&&B.a.K(a.a,"https"))||!b.ib("443")
if(p){o=r+1
return new A.bk(B.a.t(a.a,0,o)+B.a.a0(b.a,c+1),r,s+o,b.d+o,b.e+o,b.f+o,b.r+o,a.w)}else return this.iK().dw(b)}n=b.e
c=b.f
if(n===c){s=b.r
if(c<s){r=a.f
o=r-c
return new A.bk(B.a.t(a.a,0,r)+B.a.a0(b.a,c),a.b,a.c,a.d,a.e,c+o,s+o,a.w)}c=b.a
if(s<c.length){r=a.r
return new A.bk(B.a.t(a.a,0,r)+B.a.a0(c,s),a.b,a.c,a.d,a.e,a.f,s+(r-s),a.w)}return a.oL()}s=b.a
if(B.a.P(s,"/",n)){m=a.e
l=A.xQ(this)
k=l>0?l:m
o=k-n
return new A.bk(B.a.t(a.a,0,k)+B.a.a0(s,n),a.b,a.c,a.d,m,c+o,b.r+o,a.w)}j=a.e
i=a.f
if(j===i&&a.c>0){while(B.a.P(s,"../",n))n+=3
o=j-n+1
return new A.bk(B.a.t(a.a,0,j)+"/"+B.a.a0(s,n),a.b,a.c,a.d,j,c+o,b.r+o,a.w)}h=a.a
l=A.xQ(this)
if(l>=0)g=l
else for(g=j;B.a.P(h,"../",g);)g+=3
f=0
for(;;){e=n+3
if(!(e<=c&&B.a.P(s,"../",n)))break;++f
n=e}for(d="";i>g;){--i
if(h.charCodeAt(i)===47){if(f===0){d="/"
break}--f
d="/"}}if(i===g&&a.b<=0&&!B.a.P(h,"/",j)){n-=f*3
d=""}o=i-n+d.length
return new A.bk(B.a.t(h,0,i)+d+B.a.a0(s,n),a.b,a.c,a.d,j,c+o,b.r+o,a.w)},
hf(){var s,r=this,q=r.b
if(q>=0){s=!(q===4&&B.a.K(r.a,"file"))
q=s}else q=!1
if(q)throw A.b(A.Q("Cannot extract a file path from a "+r.gaw()+" URI"))
q=r.f
s=r.a
if(q<s.length){if(q<r.r)throw A.b(A.Q(u.z))
throw A.b(A.Q(u.A))}if(r.c<r.d)A.v(A.Q(u.Q))
q=B.a.t(s,r.e,q)
return q},
gv(a){var s=this.x
return s==null?this.x=B.a.gv(this.a):s},
D(a,b){if(b==null)return!1
if(this===b)return!0
return t.R.b(b)&&this.a===b.j(0)},
iK(){var s=this,r=null,q=s.gaw(),p=s.ghh(),o=s.c>0?s.gbF():r,n=s.gfX()?s.gdr():r,m=s.a,l=s.f,k=B.a.t(m,s.e,l),j=s.r
l=l<j?s.gdt():r
return A.hD(q,p,o,n,k,l,j<m.length?s.gec():r)},
j(a){return this.a},
$ijw:1}
A.jT.prototype={}
A.im.prototype={
i(a,b){var s=!0
s=typeof b=="string"
if(s)A.wK(b)
return this.a.get(b)},
j(a){return"Expando:null"}}
A.u7.prototype={
$0(){var s=v.G.performance
if(t.m.b(s))if(s.measure!=null&&s.mark!=null&&s.clearMeasures!=null&&s.clearMarks!=null)return s
return null},
$S:80}
A.u5.prototype={
$0(){var s=v.G.JSON
if(t.m.b(s))return s
throw A.b(A.Q("Missing JSON.parse() support"))},
$S:19}
A.vE.prototype={}
A.iT.prototype={
j(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."},
$iP:1}
A.mQ.prototype={
$2(a,b){this.a.b8(new A.mO(a),new A.mP(b),t.X)},
$S:94}
A.mO.prototype={
$1(a){var s=this.a
return s.call(s)},
$S:99}
A.mP.prototype={
$2(a,b){var s,r,q=t.g.a(v.G.Error),p=A.E2(q,["Dart exception thrown from converted Future. Use the properties 'error' to fetch the boxed error and 'stack' to recover the stack trace."])
if(t.d9.b(a))A.v("Attempting to box non-Dart object.")
s={}
s[$.zx()]=a
p.error=s
p.stack=b.j(0)
r=this.a
r.call(r,p)},
$S:5}
A.uJ.prototype={
$1(a){var s,r,q,p
if(A.yq(a))return a
s=this.a
if(s.G(a))return s.i(0,a)
if(t.av.b(a)){r={}
s.m(0,a,r)
for(s=J.T(a.ga2());s.l();){q=s.gp()
r[q]=this.$1(a.i(0,q))}return r}else if(t.e7.b(a)){p=[]
s.m(0,a,p)
B.d.ab(p,J.eU(a,this,t.z))
return p}else return a},
$S:101}
A.v_.prototype={
$1(a){return this.a.W(a)},
$S:13}
A.v0.prototype={
$1(a){if(a==null)return this.a.a9(new A.iT(a===undefined))
return this.a.a9(a)},
$S:13}
A.rQ.prototype={
el(a){if(a<=0||a>4294967296)throw A.b(A.ay(u.E+a))
return Math.random()*a>>>0}}
A.rR.prototype={
l_(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.b(A.Q("No source of cryptographically secure random numbers available."))},
el(a){var s,r,q,p,o,n,m,l
if(a<=0||a>4294967296)throw A.b(A.ay(u.E+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.C(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.R(Math.pow(256,s))
for(o=a-1,n=(a&o)===0;;){crypto.getRandomValues(J.cJ(B.ab.gan(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}}}
A.ii.prototype={
giV(){return this},
gv(a){return(J.y(this.a)^A.e1(this.b)^492929599)>>>0},
D(a,b){if(b==null)return!1
return b instanceof A.ii&&J.z(this.a,b.a)&&this.b===b.b}}
A.fT.prototype={
giV(){return null},
gv(a){return B.H.gv(this.a)^842997089},
D(a,b){if(b==null)return!1
return b instanceof A.fT}}
A.fI.prototype={
q(a,b){var s,r=this
if(r.b)throw A.b(A.D("Can't add a Stream to a closed StreamGroup."))
s=r.c
if(s===B.as)r.e.cD(b,new A.oz())
else if(s===B.ar)return b.a_(null).u()
else r.e.cD(b,new A.oA(r,b))
return null},
lZ(){var s,r,q,p,o,n,m,l=this
l.c=B.at
r=l.e
q=A.as(new A.ax(r,A.p(r).h("ax<1,2>")),l.$ti.h("M<G<1>,ah<1>?>"))
p=q.length
o=0
for(;o<q.length;q.length===p||(0,A.a6)(q),++o){n=q[o]
if(n.b!=null)continue
s=n.a
try{r.m(0,s,l.ie(s))}catch(m){r=l.iG()
if(r!=null)r.j1(new A.oy())
throw m}}},
mw(){this.c=B.au
for(var s=this.e,s=new A.bc(s,s.r,s.e);s.l();)s.d.ah()},
my(){this.c=B.at
for(var s=this.e,s=new A.bc(s,s.r,s.e);s.l();)s.d.aj()},
iG(){var s,r,q,p
this.c=B.ar
s=this.e
r=A.p(s).h("ax<1,2>")
q=t.bC
p=A.as(new A.fz(A.fr(new A.ax(s,r),new A.ox(this),r.h("n.E"),t.m2),q),q.h("n.E"))
s.aC(0)
return p.length===0?null:A.mU(p,t.H)},
ie(a){var s,r=this.a
r===$&&A.L()
s=a.aq(r.ge_(r),new A.ow(this,a),r.gfE())
if(this.c===B.au)s.ah()
return s}}
A.oz.prototype={
$0(){return null},
$S:1}
A.oA.prototype={
$0(){return this.a.ie(this.b)},
$S(){return this.a.$ti.h("ah<1>()")}}
A.oy.prototype={
$1(a){},
$S:14}
A.ox.prototype={
$1(a){var s,r,q=a.b
try{if(q!=null){s=q.u()
return s}s=a.a.a_(null).u()
return s}catch(r){return null}},
$S(){return this.a.$ti.h("o<~>?(M<G<1>,ah<1>?>)")}}
A.ow.prototype={
$0(){var s=this.a,r=s.e,q=r.I(0,this.b),p=q==null?null:q.u()
if(r.a===0)if(s.b){s=s.a
s===$&&A.L()
A.eS(s.gaD())}return p},
$S:0}
A.eB.prototype={
j(a){return this.a}}
A.U.prototype={
i(a,b){var s,r=this
if(!r.fl(b))return null
s=r.c.i(0,r.a.$1(r.$ti.h("U.K").a(b)))
return s==null?null:s.b},
m(a,b,c){var s=this
if(!s.fl(b))return
s.c.m(0,s.a.$1(b),new A.M(b,c,s.$ti.h("M<U.K,U.V>")))},
ab(a,b){b.ac(0,new A.lw(this))},
bh(a,b,c){return this.c.bh(0,b,c)},
G(a){var s=this
if(!s.fl(a))return!1
return s.c.G(s.a.$1(s.$ti.h("U.K").a(a)))},
gbj(){var s=this.c,r=A.p(s).h("ax<1,2>")
return A.fr(new A.ax(s,r),new A.lx(this),r.h("n.E"),this.$ti.h("M<U.K,U.V>"))},
ac(a,b){this.c.ac(0,new A.ly(this,b))},
gE(a){return this.c.a===0},
ga2(){var s=this.c,r=A.p(s).h("bd<2>")
return A.fr(new A.bd(s,r),new A.lz(this),r.h("n.E"),this.$ti.h("U.K"))},
gk(a){return this.c.a},
cB(a,b,c,d){return this.c.cB(0,new A.lA(this,b,c,d),c,d)},
j(a){return A.nF(this)},
fl(a){return this.$ti.h("U.K").b(a)},
$ia_:1}
A.lw.prototype={
$2(a,b){this.a.m(0,a,b)
return b},
$S(){return this.a.$ti.h("~(U.K,U.V)")}}
A.lx.prototype={
$1(a){var s=a.b
return new A.M(s.a,s.b,this.a.$ti.h("M<U.K,U.V>"))},
$S(){return this.a.$ti.h("M<U.K,U.V>(M<U.C,M<U.K,U.V>>)")}}
A.ly.prototype={
$2(a,b){return this.b.$2(b.a,b.b)},
$S(){return this.a.$ti.h("~(U.C,M<U.K,U.V>)")}}
A.lz.prototype={
$1(a){return a.a},
$S(){return this.a.$ti.h("U.K(M<U.K,U.V>)")}}
A.lA.prototype={
$2(a,b){return this.b.$2(b.a,b.b)},
$S(){return this.a.$ti.H(this.c).H(this.d).h("M<1,2>(U.C,M<U.K,U.V>)")}}
A.f6.prototype={
aM(a,b){return J.z(a,b)},
c4(a){return J.y(a)},
od(a){return!0}}
A.iJ.prototype={
aM(a,b){var s,r,q,p
if(a==null?b==null:a===b)return!0
if(a==null||b==null)return!1
s=J.a3(a)
r=s.gk(a)
q=J.a3(b)
if(r!==q.gk(b))return!1
for(p=0;p<r;++p)if(!J.z(s.i(a,p),q.i(b,p)))return!1
return!0},
c4(a){var s,r,q
if(a==null)return B.H.gv(null)
for(s=J.a3(a),r=0,q=0;q<s.gk(a);++q){r=r+J.y(s.i(a,q))&2147483647
r=r+(r<<10>>>0)&2147483647
r^=r>>>6}r=r+(r<<3>>>0)&2147483647
r^=r>>>11
return r+(r<<15>>>0)&2147483647}}
A.eE.prototype={
aM(a,b){var s,r,q,p,o
if(a===b)return!0
s=A.vh(B.B.gnB(),B.B.go6(),B.B.goc(),this.$ti.h("eE.E"),t.S)
for(r=a.gA(a),q=0;r.l();){p=r.gp()
o=s.i(0,p)
s.m(0,p,(o==null?0:o)+1);++q}for(r=b.gA(b);r.l();){p=r.gp()
o=s.i(0,p)
if(o==null||o===0)return!1
s.m(0,p,o-1);--q}return q===0}}
A.d5.prototype={}
A.ew.prototype={
gv(a){return 3*J.y(this.b)+7*J.y(this.c)&2147483647},
D(a,b){if(b==null)return!1
return b instanceof A.ew&&J.z(this.b,b.b)&&J.z(this.c,b.c)}}
A.dW.prototype={
aM(a,b){var s,r,q,p,o
if(a==b)return!0
if(a==null||b==null)return!1
if(a.gk(a)!==b.gk(b))return!1
s=A.vh(null,null,null,t.fA,t.S)
for(r=J.T(a.ga2());r.l();){q=r.gp()
p=new A.ew(this,q,a.i(0,q))
o=s.i(0,p)
s.m(0,p,(o==null?0:o)+1)}for(r=J.T(b.ga2());r.l();){q=r.gp()
p=new A.ew(this,q,b.i(0,q))
o=s.i(0,p)
if(o==null||o===0)return!1
s.m(0,p,o-1)}return!0},
c4(a){var s,r,q,p,o,n
if(a==null)return B.H.gv(null)
for(s=J.T(a.ga2()),r=this.$ti.y[1],q=0;s.l();){p=s.gp()
o=J.y(p)
n=a.i(0,p)
q=q+3*o+7*J.y(n==null?r.a(n):n)&2147483647}q=q+(q<<3>>>0)&2147483647
q^=q>>>11
return q+(q<<15>>>0)&2147483647}}
A.iR.prototype={
sk(a,b){A.x2()},
q(a,b){return A.x2()}}
A.jt.prototype={
m(a,b,c){return A.Bp()}}
A.l5.prototype={}
A.cq.prototype={}
A.hZ.prototype={
n(){},
$ilH:1}
A.i_.prototype={
nJ(){if(this.w)throw A.b(A.D("Can't finalize a finalized Request."))
this.w=!0
return B.aw},
j(a){return this.a+" "+this.b.j(0)}}
A.li.prototype={
$2(a,b){return a.toLowerCase()===b.toLowerCase()},
$S:111}
A.lj.prototype={
$1(a){return B.a.gv(a.toLowerCase())},
$S:112}
A.lk.prototype={
eO(a,b,c,d,e,f,g){var s=this.b
if(s<100)throw A.b(A.K("Invalid status code "+s+".",null))
else{s=this.d
if(s!=null&&s<0)throw A.b(A.K("Invalid content length "+A.q(s)+".",null))}}}
A.i2.prototype={
aI(a){return this.ku(a)},
ku(b6){var s=0,r=A.i(t.n),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5
var $async$aI=A.d(function(b7,b8){if(b7===1){o.push(b8)
s=p}for(;;)switch(s){case 0:if(m.b)throw A.b(A.wE("HTTP request failed. Client is already closed.",b6.b))
a4=v.G
l=new a4.AbortController()
a5=m.c
a5.push(l)
b6.hv()
s=3
return A.c(new A.cM(A.xk(b6.y,t.f4)).he(),$async$aI)
case 3:k=b8
p=5
j=b6
i=null
h=!1
g=null
if(j instanceof A.hQ){if(h)a6=i
else{h=!0
a7=j.cx
i=a7
a6=a7}a6=a6!=null}else a6=!1
if(a6){if(h){a6=i
a8=a6}else{h=!0
a7=j.cx
i=a7
a8=a7}g=a8==null?t.p8.a(a8):a8
g.J(new A.ll(l))}a6=b6.b
a9=a6.j(0)
b0=!J.l1(k)?k:null
b1=t.N
f=A.Z(b1,t.K)
e=b6.y.length
d=null
if(e!=null){d=e
J.l_(f,"content-length",d)}for(b2=b6.r,b2=new A.ax(b2,A.p(b2).h("ax<1,2>")).gA(0);b2.l();){b3=b2.d
b3.toString
c=b3
J.l_(f,c.a,c.b)}f=A.Ey(f)
f.toString
A.S(f)
b2=l.signal
s=8
return A.c(A.aq(a4.fetch(a9,{method:b6.a,headers:f,body:b0,credentials:"same-origin",redirect:"follow",signal:b2}),t.m),$async$aI)
case 8:b=b8
a=b.headers.get("content-length")
a0=a!=null?A.vs(a,null):null
if(a0==null&&a!=null){f=A.wE("Invalid content-length header ["+a+"].",a6)
throw A.b(f)}a1=A.Z(b1,b1)
b.headers.forEach(A.kN(new A.lm(a1)))
f=A.CH(b6,b)
a4=b.status
a6=a1
b0=a0
A.de(b.url)
b1=b.statusText
f=new A.jk(A.z5(f),b6,a4,b1,b0,a6,!1,!0)
f.eO(a4,b0,a6,!1,!0,b1,b6)
q=f
n=[1]
s=6
break
n.push(7)
s=6
break
case 5:p=4
b5=o.pop()
a2=A.H(b5)
a3=A.O(b5)
A.yv(a2,a3,b6)
n.push(7)
s=6
break
case 4:n=[2]
case 6:p=2
B.d.I(a5,l)
s=n.pop()
break
case 7:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$aI,r)},
n(){var s,r,q
for(s=this.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q)s[q].abort()
this.b=!0}}
A.ll.prototype={
$0(){return this.a.abort()},
$S:0}
A.lm.prototype={
$3(a,b,c){this.a.m(0,b.toLowerCase(),a)},
$2(a,b){return this.$3(a,b,null)},
$S:114}
A.tW.prototype={
$1(a){return A.eM(this.a,this.b,a)},
$S:118}
A.u8.prototype={
$0(){var s=this.a,r=s.a
if(r!=null){s.a=null
r.N()}},
$S:0}
A.u9.prototype={
$0(){var s=0,r=A.i(t.H),q=1,p=[],o=this,n,m,l,k
var $async$$0=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:q=3
o.a.c=!0
s=6
return A.c(A.aq(o.b.cancel(),t.X),$async$$0)
case 6:q=1
s=5
break
case 3:q=2
k=p.pop()
n=A.H(k)
m=A.O(k)
if(!o.a.b)A.yv(n,m,o.c)
s=5
break
case 2:s=1
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:3}
A.cM.prototype={
he(){var s=new A.l($.m,t.jz),r=new A.ad(s,t.iq),q=new A.jP(new A.lv(r),new Uint8Array(1024))
this.B(q.ge_(q),!0,q.gaD(),r.gn_())
return s}}
A.lv.prototype={
$1(a){return this.a.W(new Uint8Array(A.vZ(a)))},
$S:119}
A.bU.prototype={
j(a){var s=this.b,r="ClientException: "+this.a
if(s!=null)return r+", uri="+s.j(0)
else return r},
$iP:1}
A.of.prototype={
gfQ(){var s,r
if(this.gbB()==null||!this.gbB().c.a.G("charset"))return B.k
s=this.gbB().c.a.i(0,"charset")
s.toString
r=A.wI(s)
return r==null?A.v(A.ak('Unsupported encoding "'+s+'".',null,null)):r},
sj0(a){var s,r,q,p,o,n,m=this,l=m.gfQ().bi(a)
m.lb()
m.y=A.z6(l)
s=m.gbB()
if(s==null){l=t.N
m.sbB(A.nH("text","plain",A.br(["charset",m.gfQ().gbJ()],l,l)))}else{l=m.gbB()
if(l!=null){r=l.a
if(r!=="text"){l=r+"/"+l.b
l=l==="application/xml"||l==="application/xml-external-parsed-entity"||l==="application/xml-dtd"||B.a.bE(l,"+xml")}else l=!0}else l=!1
if(l&&!s.c.a.G("charset")){l=t.N
q=A.br(["charset",m.gfQ().gbJ()],l,l)
p=s.a
o=s.b
n=A.wY(s.c,l,l)
n.ab(0,q)
m.sbB(A.nH(p,o,n))}}},
gbB(){var s=this.r.i(0,"content-type")
if(s==null)return null
return A.x1(s)},
sbB(a){this.r.m(0,"content-type",a.j(0))},
lb(){if(!this.w)return
throw A.b(A.D("Can't modify a finalized Request."))}}
A.hQ.prototype={}
A.jF.prototype={}
A.e4.prototype={}
A.ct.prototype={}
A.jk.prototype={}
A.eX.prototype={}
A.fs.prototype={
j(a){var s=new A.X(""),r=this.a
s.a=r
r+="/"
s.a=r
s.a=r+this.b
this.c.a.ac(0,new A.nK(s))
r=s.a
return r.charCodeAt(0)==0?r:r}}
A.nI.prototype={
$0(){var s,r,q,p,o,n,m,l,k,j=this.a,i=new A.p2(null,j),h=$.zI()
i.eK(h)
s=$.zH()
i.dc(s)
r=i.gh1().i(0,0)
r.toString
i.dc("/")
i.dc(s)
q=i.gh1().i(0,0)
q.toString
i.eK(h)
p=t.N
o=A.Z(p,p)
for(;;){p=i.d=B.a.cC(";",j,i.c)
n=i.e=i.c
m=p!=null
p=m?i.e=i.c=p.gC():n
if(!m)break
p=i.d=h.cC(0,j,p)
i.e=i.c
if(p!=null)i.e=i.c=p.gC()
i.dc(s)
if(i.c!==i.e)i.d=null
p=i.d.i(0,0)
p.toString
i.dc("=")
n=i.d=s.cC(0,j,i.c)
l=i.e=i.c
m=n!=null
if(m){n=i.e=i.c=n.gC()
l=n}else n=l
if(m){if(n!==l)i.d=null
n=i.d.i(0,0)
n.toString
k=n}else k=A.Eg(i)
n=i.d=h.cC(0,j,i.c)
i.e=i.c
if(n!=null)i.e=i.c=n.gC()
o.m(0,p,k)}i.nG()
return A.nH(r,q,o)},
$S:124}
A.nK.prototype={
$2(a,b){var s,r,q=this.a
q.a+="; "+a+"="
s=$.zF()
s=s.b.test(b)
r=q.a
if(s){q.a=r+'"'
s=A.z2(b,$.zu(),new A.nJ(),null)
q.a=(q.a+=s)+'"'}else q.a=r+b},
$S:42}
A.nJ.prototype={
$1(a){return"\\"+A.q(a.i(0,0))},
$S:34}
A.ux.prototype={
$1(a){var s=a.i(0,1)
s.toString
return s},
$S:34}
A.cn.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.cn&&this.b===b.b},
Z(a,b){return this.b-b.b},
gv(a){return this.b},
j(a){return this.a},
$ia7:1}
A.dU.prototype={
j(a){return"["+this.a.a+"] "+this.d+": "+this.b}}
A.dV.prototype={
gjj(){var s=this.b,r=s==null?null:s.a.length!==0,q=this.a
return r===!0?s.gjj()+"."+q:q},
gog(){var s,r
if(this.b==null){s=this.c
s.toString
r=s}else{s=$.v9().c
s.toString
r=s}return r},
X(a,b,c,d){var s,r,q=this,p=a.b
if(p>=q.gog().b){if((d==null||d===B.r)&&p>=2000){d=A.fH()
if(c==null)c="autogenerated stack trace for "+a.j(0)+" "+b}p=q.gjj()
s=Date.now()
$.wZ=$.wZ+1
r=new A.dU(a,b,p,new A.bb(s,0,!1),c,d)
if(q.b==null)q.io(r)
else $.v9().io(r)}},
oq(a,b){return this.X(a,b,null,null)},
fa(){if(this.b==null){var s=this.f
if(s==null)s=this.f=A.d7(!0,t.ag)
return new A.aJ(s,A.p(s).h("aJ<1>"))}else return $.v9().fa()},
io(a){var s=this.f
return s==null?null:s.q(0,a)}}
A.nD.prototype={
$0(){var s,r,q=this.a
if(B.a.K(q,"."))A.v(A.K("name shouldn't start with a '.'",null))
if(B.a.bE(q,"."))A.v(A.K("name shouldn't end with a '.'",null))
s=B.a.cA(q,".")
if(s===-1)r=q!==""?A.vr(""):null
else{r=A.vr(B.a.t(q,0,s))
q=B.a.a0(q,s+1)}return A.x_(q,r,A.Z(t.N,t.I))},
$S:136}
A.lY.prototype={
mN(a){var s,r,q=t.mf
A.yG("absolute",A.u([a,null,null,null,null,null,null,null,null,null,null,null,null,null,null],q))
s=this.a
s=s.ar(a)>0&&!s.bG(a)
if(s)return a
s=A.yN()
r=A.u([s,a,null,null,null,null,null,null,null,null,null,null,null,null,null,null],q)
A.yG("join",r)
return this.of(new A.fW(r,t.lS))},
of(a){var s,r,q,p,o,n,m,l,k
for(s=a.gA(0),r=new A.eg(s,new A.lZ()),q=this.a,p=!1,o=!1,n="";r.l();){m=s.gp()
if(q.bG(m)&&o){l=A.iW(m,q)
k=n.charCodeAt(0)==0?n:n
n=B.a.t(k,0,q.cG(k,!0))
l.b=n
if(q.dn(n))l.e[0]=q.gcd()
n=l.j(0)}else if(q.ar(m)>0){o=!q.bG(m)
n=m}else{if(!(m.length!==0&&q.fL(m[0])))if(p)n+=q.gcd()
n+=m}p=q.dn(m)}return n.charCodeAt(0)==0?n:n},
dI(a,b){var s=A.iW(b,this.a),r=s.d,q=A.a8(r).h("c6<1>")
r=A.as(new A.c6(r,new A.m_(),q),q.h("n.E"))
s.d=r
q=s.b
if(q!=null)B.d.ob(r,0,q)
return s.d},
h5(a){var s
if(!this.lQ(a))return a
s=A.iW(a,this.a)
s.h4()
return s.j(0)},
lQ(a){var s,r,q,p,o,n,m,l=this.a,k=l.ar(a)
if(k!==0){if(l===$.kX())for(s=0;s<k;++s)if(a.charCodeAt(s)===47)return!0
r=k
q=47}else{r=0
q=null}for(p=a.length,s=r,o=null;s<p;++s,o=q,q=n){n=a.charCodeAt(s)
if(l.bm(n)){if(l===$.kX()&&n===47)return!0
if(q!=null&&l.bm(q))return!0
if(q===46)m=o==null||o===46||l.bm(o)
else m=!1
if(m)return!0}}if(q==null)return!0
if(l.bm(q))return!0
if(q===46)l=o==null||l.bm(o)||o===46
else l=!1
if(l)return!0
return!1},
oJ(a){var s,r,q,p,o=this,n='Unable to find a path to "',m=o.a,l=m.ar(a)
if(l<=0)return o.h5(a)
s=A.yN()
if(m.ar(s)<=0&&m.ar(a)>0)return o.h5(a)
if(m.ar(a)<=0||m.bG(a))a=o.mN(a)
if(m.ar(a)<=0&&m.ar(s)>0)throw A.b(A.x3(n+a+'" from "'+s+'".'))
r=A.iW(s,m)
r.h4()
q=A.iW(a,m)
q.h4()
l=r.d
if(l.length!==0&&l[0]===".")return q.j(0)
l=r.b
p=q.b
if(l!=p)l=l==null||p==null||!m.h9(l,p)
else l=!1
if(l)return q.j(0)
for(;;){l=r.d
if(l.length!==0){p=q.d
l=p.length!==0&&m.h9(l[0],p[0])}else l=!1
if(!l)break
B.d.eq(r.d,0)
B.d.eq(r.e,1)
B.d.eq(q.d,0)
B.d.eq(q.e,1)}l=r.d
p=l.length
if(p!==0&&l[0]==="..")throw A.b(A.x3(n+a+'" from "'+s+'".'))
l=t.N
B.d.fY(q.d,0,A.b1(p,"..",!1,l))
p=q.e
p[0]=""
B.d.fY(p,1,A.b1(r.d.length,m.gcd(),!1,l))
m=q.d
l=m.length
if(l===0)return"."
if(l>1&&B.d.gaO(m)==="."){B.d.jI(q.d)
m=q.e
m.pop()
m.pop()
m.push("")}q.b=""
q.jJ()
return q.j(0)},
jC(a){var s,r,q=this,p=A.ys(a)
if(p.gaw()==="file"&&q.a===$.hM())return p.j(0)
else if(p.gaw()!=="file"&&p.gaw()!==""&&q.a!==$.hM())return p.j(0)
s=q.h5(q.a.h8(A.ys(p)))
r=q.oJ(s)
return q.dI(0,r).length>q.dI(0,s).length?s:r}}
A.lZ.prototype={
$1(a){return a!==""},
$S:22}
A.m_.prototype={
$1(a){return a.length!==0},
$S:22}
A.up.prototype={
$1(a){return a==null?"null":'"'+a+'"'},
$S:145}
A.nr.prototype={
kq(a){var s=this.ar(a)
if(s>0)return B.a.t(a,0,s)
return this.bG(a)?a[0]:null},
h9(a,b){return a===b}}
A.nQ.prototype={
jJ(){var s,r,q=this
for(;;){s=q.d
if(!(s.length!==0&&B.d.gaO(s)===""))break
B.d.jI(q.d)
q.e.pop()}s=q.e
r=s.length
if(r!==0)s[r-1]=""},
h4(){var s,r,q,p,o,n=this,m=A.u([],t.s)
for(s=n.d,r=s.length,q=0,p=0;p<s.length;s.length===r||(0,A.a6)(s),++p){o=s[p]
if(!(o==="."||o===""))if(o==="..")if(m.length!==0)m.pop()
else ++q
else m.push(o)}if(n.b==null)B.d.fY(m,0,A.b1(q,"..",!1,t.N))
if(m.length===0&&n.b==null)m.push(".")
n.d=m
s=n.a
n.e=A.b1(m.length+1,s.gcd(),!0,t.N)
r=n.b
if(r==null||m.length===0||!s.dn(r))n.e[0]=""
r=n.b
if(r!=null&&s===$.kX())n.b=A.hL(r,"/","\\")
n.jJ()},
j(a){var s,r,q,p,o=this.b
o=o!=null?o:""
for(s=this.d,r=s.length,q=this.e,p=0;p<r;++p)o=o+q[p]+s[p]
o+=B.d.gaO(q)
return o.charCodeAt(0)==0?o:o}}
A.iX.prototype={
j(a){return"PathException: "+this.a},
$iP:1}
A.p3.prototype={
j(a){return this.gbJ()}}
A.nR.prototype={
fL(a){return B.a.S(a,"/")},
bm(a){return a===47},
dn(a){var s=a.length
return s!==0&&a.charCodeAt(s-1)!==47},
cG(a,b){if(a.length!==0&&a.charCodeAt(0)===47)return 1
return 0},
ar(a){return this.cG(a,!1)},
bG(a){return!1},
h8(a){var s
if(a.gaw()===""||a.gaw()==="file"){s=a.gaP()
return A.vU(s,0,s.length,B.k,!1)}throw A.b(A.K("Uri "+a.j(0)+" must have scheme 'file:'.",null))},
gbJ(){return"posix"},
gcd(){return"/"}}
A.pG.prototype={
fL(a){return B.a.S(a,"/")},
bm(a){return a===47},
dn(a){var s=a.length
if(s===0)return!1
if(a.charCodeAt(s-1)!==47)return!0
return B.a.bE(a,"://")&&this.ar(a)===s},
cG(a,b){var s,r,q,p=a.length
if(p===0)return 0
if(a.charCodeAt(0)===47)return 1
for(s=0;s<p;++s){r=a.charCodeAt(s)
if(r===47)return 0
if(r===58){if(s===0)return 0
q=B.a.bl(a,"/",B.a.P(a,"//",s+1)?s+3:s)
if(q<=0)return p
if(!b||p<q+3)return q
if(!B.a.K(a,"file://"))return q
p=A.yO(a,q+1)
return p==null?q:p}}return 0},
ar(a){return this.cG(a,!1)},
bG(a){return a.length!==0&&a.charCodeAt(0)===47},
h8(a){return a.j(0)},
gbJ(){return"url"},
gcd(){return"/"}}
A.q9.prototype={
fL(a){return B.a.S(a,"/")},
bm(a){return a===47||a===92},
dn(a){var s=a.length
if(s===0)return!1
s=a.charCodeAt(s-1)
return!(s===47||s===92)},
cG(a,b){var s,r=a.length
if(r===0)return 0
if(a.charCodeAt(0)===47)return 1
if(a.charCodeAt(0)===92){if(r<2||a.charCodeAt(1)!==92)return 1
s=B.a.bl(a,"\\",2)
if(s>0){s=B.a.bl(a,"\\",s+1)
if(s>0)return s}return r}if(r<3)return 0
if(!A.yS(a.charCodeAt(0)))return 0
if(a.charCodeAt(1)!==58)return 0
r=a.charCodeAt(2)
if(!(r===47||r===92))return 0
return 3},
ar(a){return this.cG(a,!1)},
bG(a){return this.ar(a)===1},
h8(a){var s,r
if(a.gaw()!==""&&a.gaw()!=="file")throw A.b(A.K("Uri "+a.j(0)+" must have scheme 'file:'.",null))
s=a.gaP()
if(a.gbF()===""){r=s.length
if(r>=3&&B.a.K(s,"/")&&A.yO(s,1)!=null){A.xe(0,0,r,"startIndex")
s=A.ER(s,"/","",0)}}else s="\\\\"+a.gbF()+s
r=A.hL(s,"/","\\")
return A.vU(r,0,r.length,B.k,!1)},
mZ(a,b){var s
if(a===b)return!0
if(a===47)return b===92
if(a===92)return b===47
if((a^b)!==32)return!1
s=a|32
return s>=97&&s<=122},
h9(a,b){var s,r
if(a===b)return!0
s=a.length
if(s!==b.length)return!1
for(r=0;r<s;++r)if(!this.mZ(a.charCodeAt(r),b.charCodeAt(r)))return!1
return!0},
gbJ(){return"windows"},
gcd(){return"\\"}}
A.hP.prototype={
aB(){var s=0,r=A.i(t.H),q=this,p,o,n,m
var $async$aB=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if((q.a.a.a&30)===0){for(p=q.b,o=A.C7(p,p.r,A.p(p).c),n=o.$ti.c;o.l();){m=o.d;(m==null?n.a(m):m).N()}p.aC(0)}s=2
return A.c(q.c.a,$async$aB)
case 2:return A.f(null,r)}})
return A.h($async$aB,r)},
j4(){var s=this.c
if((s.a.a&30)===0)s.N()},
cb(a,b){var s=new A.ad(new A.l($.m,t.D),t.h)
if((this.a.a.a&30)!==0)s.N()
else this.b.q(0,s)
return A.dP(new A.l3(a,s,b),b).J(new A.l4(this,s))}}
A.l3.prototype={
$0(){return this.a.$1(this.b.a)},
$S(){return this.c.h("o<0>()")}}
A.l4.prototype={
$0(){var s=this.b
this.a.b.I(0,s)
if((s.a.a&30)===0)s.N()},
$S:1}
A.bH.prototype={
j(a){return"PowerSyncCredentials<endpoint: "+this.a+" userId: "+A.q(this.c)+" expiresAt: "+A.q(this.d)+">"}}
A.f4.prototype={
eu(){var s=this
return A.br(["op_id",s.a,"op",s.c.c,"type",s.d,"id",s.e,"tx_id",s.b,"data",s.r,"metadata",s.f,"old",s.w],t.N,t.z)},
j(a){var s=this
return"CrudEntry<"+s.b+"/"+s.a+" "+s.c.c+" "+s.d+"/"+s.e+" "+A.q(s.r)+">"},
D(a,b){var s=this
if(b==null)return!1
return b instanceof A.f4&&b.b===s.b&&b.a===s.a&&b.c===s.c&&b.d===s.d&&b.e===s.e&&B.y.aM(b.r,s.r)},
gv(a){var s=this
return A.bG(s.b,s.a,s.c.c,s.d,s.e,B.y.c4(s.r),B.c,B.c,B.c,B.c)}}
A.fR.prototype={
aA(){return"UpdateType."+this.b},
eu(){return this.c}}
A.uY.prototype={
$1(a){return new A.be(A.w0(a.a))},
$S:146}
A.uX.prototype={
$1(a){var s=a.a
return s.gaN(s)},
$S:148}
A.f3.prototype={
j(a){return"CredentialsException: "+this.a},
$iP:1}
A.e0.prototype={
j(a){return"SyncProtocolException: "+this.a},
$iP:1}
A.d9.prototype={
j(a){return"SyncResponseException: "+this.a+" "+this.b},
$iP:1}
A.u6.prototype={
$1(a){var s
A.uZ("["+a.d+"] "+a.a.a+": "+a.e.j(0)+": "+a.b)
s=a.r
if(s!=null)A.uZ(s)
s=a.w
if(s!=null)A.uZ(s)},
$S:33}
A.cW.prototype={
j(a){return v.G.String(this.a)},
gv(a){return A.R(v.G.Number(this.a))},
D(a,b){if(b==null)return!1
return b instanceof A.cW&&this.a===b.a},
$idQ:1}
A.be.prototype={
cH(a){var s=this.a
if(a instanceof A.be)return new A.be(s.cH(a.a))
else return new A.be(s.cH(A.w0(a.a)))},
fK(a){return this.kI(A.w0(a))}}
A.lt.prototype={
$1(a){return a.aZ(this.a,this.b)},
$S(){return this.b.h("o<0>(aI)")}}
A.lr.prototype={
$1(a){return A.d0(a,"target",null)},
$S:151}
A.ls.prototype={
$1(a){return this.jS(a)},
jS(a){var s=0,r=A.i(t.y),q,p=this,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(a.jc("SELECT 1 FROM ps_crud LIMIT 1"),$async$$1)
case 3:n=c
if(!n.gE(n)){q=!1
s=1
break}s=4
return A.c(a.jc(u.B),$async$$1)
case 4:o=c
if(A.R(o.gaf(o).i(0,"seq"))!==p.a){q=!1
s=1
break}s=5
return A.c(A.d0(a,"target",p.b),$async$$1)
case 5:q=!0
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:159}
A.lo.prototype={
$1(a){return this.jR(a)},
jR(a){var s=0,r=A.i(t.N),q,p=this,o
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.iZ(a,p.a,p.b),$async$$1)
case 3:o=c
o.toString
q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:30}
A.dH.prototype={
j(a){return this.a},
$iP:1}
A.lF.prototype={
hj(a,b){var s=this.b
return A.Bx(new A.aJ(s,A.p(s).h("aJ<1>")),a,this.a,"waitForCheckpointRequestsReady",new A.lG(this,b),t.hi)},
oX(a){return this.hj(a,!0)}}
A.lG.prototype={
$1(a){var s,r,q
if(a instanceof A.h7)throw A.b(B.aU)
s=a instanceof A.ej
r=s?a.a:null
if(s){q=r.giV()
if(q!=null)A.ik(q.a,q.b)
return!0}if(a instanceof A.hm){if(this.b&&(this.a.c.a.a&30)===0)this.a.c.N()
return!1}},
$S:165}
A.c9.prototype={}
A.hm.prototype={}
A.ej.prototype={}
A.h7.prototype={}
A.fp.prototype={$iaK:1,$ic_:1}
A.dN.prototype={$iaK:1}
A.lE.prototype={}
A.fQ.prototype={$iaK:1,$ic_:1}
A.m1.prototype={}
A.m2.prototype={
$1(a){return A.A9(t.f.a(a))},
$S:57}
A.mD.prototype={
eu(){var s,r,q,p,o=t.N,n=A.Z(o,t.dV)
for(s=this.a,s=new A.ax(s,A.p(s).h("ax<1,2>")).gA(0),r=t.S;s.l();){q=s.d
p=q.a
q=q.b.a
n.m(0,p,A.br(["priority",q[1],"at_last",q[0],"since_last",q[2],"target_count",q[3]],o,r))}return A.br(["buckets",n],o,t.X)}}
A.mE.prototype={
$2(a,b){var s
t.f.a(b)
s=A.R(b.i(0,"priority"))
return new A.M(a,new A.kj([A.R(b.i(0,"at_last")),s,A.R(b.i(0,"since_last")),A.R(b.i(0,"target_count"))]),t.lx)},
$S:58}
A.fb.prototype={$iaK:1,$ic_:1}
A.dI.prototype={$iaK:1}
A.f7.prototype={$iaK:1,$ic_:1}
A.fO.prototype={$iaK:1,$ic_:1}
A.qP.prototype={
oE(a,b){var s=this.d.$2(a,b)
return s}}
A.fu.prototype={
mU(a){var s,r,q,p=this
p.a=a.a
p.b=a.b
s=a.d
r=s==null
p.c=!r
q=a.c
p.f=q
A:{if(r){s=null
break A}s=A.Aw(s.a)
break A}p.e=s
q=A.Ax(q,new A.nL())
p.x=q==null?null:q.b
p.r=a.e
p.w=a.f}}
A.nL.prototype={
$1(a){return a.c===2147483647},
$S:59}
A.pc.prototype={
c8(a){var s,r,q,p,o,n,m,l,k,j=this,i=j.a
a.$1(i)
s=j.c
if((s.c&4)!==0)return
r=i.a
q=i.b
p=i.c
o=i.d
n=i.e
if(n==null)n=null
m=i.f
l=i.x
k=new A.cu(r,q,p,n,o,l,l!=null,i.y,i.z,new A.dc(m,t.ph),i.r,i.w)
if(!k.D(0,j.b)){s.q(0,k)
j.b=k}}}
A.fL.prototype={}
A.lD.prototype={}
A.fm.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.fm},
gv(a){return B.a.gv("legacy")}}
A.d3.prototype={
D(a,b){var s
if(b==null)return!1
if(b instanceof A.d3)s=b.a.a===this.a.a
else s=!1
return s},
gv(a){return B.b.gv(this.a.a)}}
A.jo.prototype={
aA(){return"SyncClientImplementation."+this.b}}
A.dL.prototype={
eu(){var s,r,q,p,o=this,n=o.d,m=t.N
n=A.br(["total",n.b,"downloaded",n.a],m,t.S)
s=o.w
A:{if(s==null){r=null
break A}r=1000*s.a+s.b
break A}q=o.x
B:{if(q==null){p=null
break B}p=1000*q.a+q.b
break B}return A.br(["name",o.a,"parameters",o.b,"priority",o.c,"progress",n,"active",o.e,"is_default",o.f,"has_explicit_subscription",o.r,"expires_at",r,"last_synced_at",p],m,t.X)}}
A.uR.prototype={
$0(){var s=this,r=s.b,q=s.a,p=s.d,o=A.a8(r).h("@<1>").H(p.h("ah<0>")).h("aa<1,2>"),n=A.as(new A.aa(r,new A.uQ(q,s.c,p),o),o.h("W.E"))
q.a=n},
$S:0}
A.uQ.prototype={
$1(a){var s=this.b
return a.aq(new A.uO(s,this.c),new A.uP(this.a,s),s.gfE())},
$S(){return this.c.h("ah<0>(G<0>)")}}
A.uO.prototype={
$1(a){return this.a.q(0,a)},
$S(){return this.b.h("~(0)")}}
A.uP.prototype={
$0(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i
var $async$$0=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:j=n.a
s=!j.b?2:3
break
case 2:j.b=!0
q=5
j=j.a
j.toString
s=8
return A.c(A.kQ(j),$async$$0)
case 8:o.push(7)
s=6
break
case 5:q=4
i=p.pop()
m=A.H(i)
l=A.O(i)
n.b.ae(m,l)
o.push(7)
s=6
break
case 4:o=[1]
case 6:q=1
n.b.n()
s=o.pop()
break
case 7:case 3:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:3}
A.uS.prototype={
$0(){var s=this.a,r=s.a
if(r!=null&&!s.b)return A.kQ(r)},
$S:39}
A.uT.prototype={
$0(){var s=this.a.a
if(s!=null)return A.EF(s)},
$S:0}
A.uU.prototype={
$0(){var s=this.a.a
if(s!=null)return A.EJ(s)},
$S:0}
A.us.prototype={
$1(a){return a.u()},
$S:60}
A.v6.prototype={
$1(a){var s=this.a
s.q(0,a)
s.n()},
$S(){return this.b.h("F(0)")}}
A.v7.prototype={
$2(a,b){var s
if(this.a.a)throw A.b(a)
else{s=this.b
s.ae(a,b)
s.n()}},
$S:5}
A.v5.prototype={
$0(){var s=0,r=A.i(t.H),q=this
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q.a.a=!0
s=2
return A.c(q.b,$async$$0)
case 2:return A.f(null,r)}})
return A.h($async$$0,r)},
$S:3}
A.pH.prototype={
$1(a){var s,r,q,p=this
try{if(p.a.$1(a)){p.b.N()
p.c.u()}}catch(q){s=A.H(q)
r=A.O(q)
p.b.b5(s,r)
p.c.u()}},
$S(){return this.d.h("~(0)")}}
A.pI.prototype={
$0(){var s=this.a
if((s.a.a&30)===0){s.a9(new A.cf(this.b))
this.c.u()}},
$S:1}
A.ei.prototype={
q(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f="Stream is already closed"
for(s=J.a3(b),r=h.b,q=h.a.a,p=0;p<s.gk(b);){o=s.gk(b)-p
n=h.d
m=h.c
if(n!=null){l=Math.min(o,m)
k=p+l
if(p<0)A.v(A.ab(p,0,g,"start",g))
if(p>k)A.v(A.ab(k,p,g,"end",g))
n.hC(b,p,k)
if((h.c-=l)===0){m=B.f.gan(n.a)
j=n.a
j=J.cJ(m,j.byteOffset,n.b*j.BYTES_PER_ELEMENT)
if((q.e&2)!==0)A.v(A.D(f))
q.bS(j)
h.d=null
h.c=4}p=k}else{l=Math.min(o,m)
i=J.zK(B.ab.gan(r))
m=4-h.c
B.f.O(i,m,m+l,b,p)
p+=l
if((h.c-=l)===0){m=h.c=r.getInt32(0,!0)-4
if(m<5){j=A.fH()
if((q.e&2)!==0)A.v(A.D(f))
q.eN(new A.e0("Invalid length for bson: "+m),j)}m=new A.bf(new Uint8Array(0),0)
m.hC(i,0,g)
h.d=m}}}},
ae(a,b){this.a.ae(a,b)},
n(){var s=this
if(s.d!=null||s.c!==4)s.a.ae(new A.e0("Pending data when stream was closed"),A.fH())
s.a.a.Y()},
$iaj:1,
gk(a){return this.b}}
A.oL.prototype={
aB(){var s=0,r=A.i(t.H),q=this,p,o
var $async$aB=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=q.Q
s=o!=null?2:3
break
case 2:p=t.z
s=4
return A.c(A.wO(new A.cy(o.aB(),q.w.n(),q.ax.n()),t.H,p,p),$async$aB)
case 4:case 3:q.x.n()
q.y.c.n()
return A.f(null,r)}})
return A.h($async$aB,r)},
cP(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j
var $async$cP=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:j=A.wv()
n.Q=j
m=j
q=2
s=5
return A.c(n.co(),$async$cP)
case 5:k=t.H
l=A.ir(n.ck(m),new A.p1(n,m),k,t.K)
s=6
return A.c(A.wO(new A.cy(l,n.cT(m),n.d0(m)),k,k,k),$async$cP)
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
k=n.z
k.a=B.a1
k.b.q(0,B.a1)
m.j4()
s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$cP,r)},
er(){var s=0,r=A.i(t.g2),q,p=this,o,n,m
var $async$er=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.d.w
if(!((o==null?B.q:o) instanceof A.d3))throw A.b(B.aV)
n=A
m=v.G
s=3
return A.c(p.iy(A.wv()),$async$er)
case 3:q=new n.cW(m.BigInt(b))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$er,r)},
co(){var s=0,r=A.i(t.N),q,p=this,o
var $async$co=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.ch
s=o==null?3:5
break
case 3:s=6
return A.c(A.lp(p.b),$async$co)
case 6:b=p.ch=b
s=4
break
case 5:b=o
case 4:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$co,r)},
cT(a){return this.ln(a)},
ln(a1){var s=0,r=A.i(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$cT=A.d(function(a2,a3){if(a2===1){o.push(a3)
s=p}for(;;)switch(s){case 0:g=a1.a.a,f=n.f,e=n.y,d=n.as,c=t.U,b=t.H
case 3:if(!((g.a&30)===0)){s=4
break}m=!1
p=6
l=null
s=9
return A.c(d.bI(new A.oT(n,a1),n.f5(a1),c),$async$cT)
case 9:k=a3
l=k.a
m=!l
p=2
s=8
break
case 6:p=5
a0=o.pop()
j=A.H(a0)
i=A.O(a0)
if(A.w_(a1,j)){s=1
break}m=!0
h=A.DG(j)
f.X(B.m,"Sync error: "+A.q(h),j,i)
e.c8(new A.oU(j))
s=8
break
case 5:s=2
break
case 8:s=(g.a&30)===0&&m?10:11
break
case 10:s=12
return A.c(a1.cb(new A.oV(n),b),$async$cT)
case 12:case 11:s=3
break
case 4:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$cT,r)},
ck(a){return this.lk(a)},
lk(a){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k
var $async$ck=A.d(function(b,c){if(b===1){p.push(c)
s=q}for(;;)switch(s){case 0:l=n.w
k=t.H
l=new A.bQ(A.ba(A.yV(A.u([n.r,new A.a5(l,A.p(l).h("a5<1>"))],t.i3),k),"stream",t.K))
q=2
m=n.at
case 5:s=7
return A.c(l.l(),$async$ck)
case 7:if(!c){s=6
break}l.gp()
s=8
return A.c(m.bI(new A.oM(n,a),n.f5(a),k),$async$ck)
case 8:s=5
break
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
s=9
return A.c(l.u(),$async$ck)
case 9:s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$ck,r)},
bV(a){return this.ll(a)},
ll(a4){var s=0,r=A.i(t.H),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3
var $async$bV=A.d(function(a5,a6){if(a5===1){o.push(a6)
s=p}for(;;)switch(s){case 0:a2=null
h=a4.a.a,g=m.y,f=g.a,e=m.f,d=m.c.c,c=m.b,b=m.ax
case 3:if(!((h.a&30)===0)){s=4
break}l=!1
p=6
s=9
return A.c(A.lq(c),$async$bV)
case 9:k=a6
s=k!=null?10:12
break
case 10:g.c8(new A.oN())
a=k.a
a0=a2
if(a===(a0==null?null:a0.a)){e.X(B.m,"Potentially previously uploaded CRUD entries are still present in the upload queue. \n                Make sure to handle uploads and complete CRUD transactions or batches by calling and awaiting their [.complete()] method.\n                The next upload iteration will be delayed.",null,null)
a=A.wJ("Delaying due to previously encountered CRUD item.")
throw A.b(a)}a2=k
s=13
return A.c(d.$0(),$async$bV)
case 13:g.c8(new A.oO())
s=11
break
case 12:s=14
return A.c(A.dF(c,new A.oP(m,a4)),$async$bV)
case 14:l=a6
n=[4]
s=7
break
case 11:n.push(8)
s=7
break
case 6:p=5
a3=o.pop()
j=A.H(a3)
i=A.O(a3)
a2=null
if(A.w_(a4,j)){n=[1]
s=7
break}e.X(B.m,"Data upload error",j,i)
g.c8(new A.oQ(j))
s=15
return A.c(m.f5(a4),$async$bV)
case 15:if(!f.a){n=[4]
s=7
break}e.X(B.m,"Caught exception when uploading. Upload will retry after a delay",j,i)
n.push(8)
s=7
break
case 5:n=[2]
case 7:p=2
g.c8(new A.oR())
if((h.a&30)===0&&l){if(!b.gbZ())A.v(b.bT())
b.am(B.aN)}s=n.pop()
break
case 8:s=3
break
case 4:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$bV,r)},
eR(a,b){var s=a.r
s.m(0,"Authorization","Token "+b.b)
s.ab(0,this.ay)},
iy(a){return a.cb(new A.p0(this),t.N)},
b2(a,b,c){return this.mg(a,b,c)},
ix(a,b){return this.b2(a,b,null)},
mg(a,b,c){var s=0,r=A.i(t.N),q,p=this,o,n,m,l,k,j,i
var $async$b2=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=c==null?3:4
break
case 3:s=5
return A.c(p.co(),$async$b2)
case 5:c=e
case 4:o=p.c
n=o.oE(c,b)
s=6
return A.c(t.cI.b(n)?n:A.bO(n,t.T),$async$b2)
case 6:m=e
if(m!=null){q=m
s=1
break}s=7
return A.c(o.a.$0(),$async$b2)
case 7:l=e
if(l==null)throw A.b(A.vd("Not logged in"))
k=A.va("POST",A.de(l.a).dv("sync/checkpoint-request"),a)
n=t.N
k.sj0(B.h.fP(A.br(["client_id",c,"checkpoint_request_id",b],n,n),null))
p.eR(k,l)
n=k.r
n.m(0,"Accept","application/json")
n.m(0,"Content-Type","application/json")
i=A
s=9
return A.c(p.x.aI(k),$async$b2)
case 9:s=8
return A.c(i.j4(e),$async$b2)
case 8:j=e
n=j.b
s=n===401?10:11
break
case 10:s=12
return A.c(o.b.$1$invalidate(!0),$async$b2)
case 12:case 11:if(n===404)throw A.b(B.aT)
if(n!==200)throw A.b(A.xn(j))
q=A.an(J.eT(J.eT(B.h.c2(A.wa(A.vX(j.e)).aF(j.w),null),"data"),"checkpoint_request_id"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$b2,r)},
bX(a){return this.lv(a)},
lv(a){var s=0,r=A.i(t.N),q,p=this,o,n,m,l,k
var $async$bX=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:m=p.c
s=3
return A.c(m.a.$0(),$async$bX)
case 3:l=c
if(l==null)throw A.b(A.vd("Not logged in"))
k=A
s=4
return A.c(p.co(),$async$bX)
case 4:o=k.q(c)
s=5
return A.c(a.cb(new A.oW(p,A.de(l.a).dv("write-checkpoint2.json?client_id="+o),l),t.Y),$async$bX)
case 5:n=c
o=n.b
s=o===401?6:7
break
case 6:s=8
return A.c(m.b.$1$invalidate(!0),$async$bX)
case 8:case 7:if(o!==200)throw A.b(A.xn(n))
q=A.an(J.eT(J.eT(B.h.c2(A.wa(A.vX(n.e)).aF(n.w),null),"data"),"write_checkpoint"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bX,r)},
dS(a){return this.mm(a)},
mm(a){var s=0,r=A.i(t.U),q,p=this,o,n
var $async$dS=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:n=p.f
n.X(B.l,"Starting Rust sync iteration",null,null)
s=3
return A.c(new A.qk(p,a).kO(),$async$dS)
case 3:o=c
n.X(B.l,"Ending Rust sync iteration. Immediate restart: "+o.a,null,null)
q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dS,r)},
c_(a,b){return this.m2(a,b)},
m2(a,b){var s=0,r=A.i(t.n),q,p=this,o,n,m,l,k,j
var $async$c_=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:l=p.c
s=3
return A.c(l.a.$0(),$async$c_)
case 3:k=d
if(k==null)throw A.b(A.vd("Not logged in"))
o=A.va("POST",A.de(k.a).dv("sync/stream"),b)
p.eR(o,k)
n=o.r
n.m(0,"Content-Type","application/json")
n.m(0,"Accept","application/vnd.powersync.bson-stream;q=0.9,application/x-ndjson;q=0.8")
o.sj0(B.h.fP(a,null))
s=4
return A.c(p.x.aI(o),$async$c_)
case 4:m=d
n=m.b
s=n===401?5:6
break
case 5:s=7
return A.c(l.b.$1$invalidate(!0),$async$c_)
case 7:case 6:s=n!==200?8:9
break
case 8:j=A
s=10
return A.c(A.p4(m),$async$c_)
case 10:throw j.b(d)
case 9:q=m
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$c_,r)},
d0(a){return this.mf(a)},
mf(a){var s=0,r=A.i(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d
var $async$d0=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:e={}
e.a=null
A:{k=n.d.w
if(k==null)k=B.q
j=k instanceof A.d3
i=j?k.a:null
if(j){e.a=i
break A}s=1
break}j=a.a.a,h=n.f,g=t.H
case 3:if(!((j.a&30)===0)){s=4
break}p=6
s=9
return A.c(a.cb(new A.oZ(e,n),g),$async$d0)
case 9:p=2
s=8
break
case 6:p=5
d=o.pop()
m=A.H(d)
l=A.O(d)
if((j.a&30)!==0){s=1
break}h.X(B.m,"Error retrying checkpoint request",m,l)
s=10
return A.c(n.hV(a,e.a),$async$d0)
case 10:s=8
break
case 5:s=2
break
case 8:s=3
break
case 4:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$d0,r)},
be(a,b){return this.me(a,b)},
me(a,b){var s=0,r=A.i(t.H),q,p=this,o,n,m,l,k,j,i
var $async$be=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:k=new A.oX(p,b)
j=p.z
s=3
return A.c(j.hj(b,!1),$async$be)
case 3:s=4
return A.c(k.$0(),$async$be)
case 4:o=d
n=A.vY(a)
b.J(n.b)
s=5
return A.c(n.a,$async$be)
case 5:i=o==null
if(i)d=i
else{s=6
break}s=7
break
case 6:i=o
s=8
return A.c(k.$0(),$async$be)
case 8:d=!i.D(0,d)
case 7:if(d){s=1
break}m=p.y.a.w
k=!1
if(m!=null){l=m.a>=o.a
k=l}if(k){s=1
break}s=9
return A.c(j.hj(b,!1),$async$be)
case 9:p.f.X(B.t,"Retry checkpoint request "+o.j(0),null,null)
s=10
return A.c(p.ix(b,v.G.String(o.a)),$async$be)
case 10:case 1:return A.f(q,r)}})
return A.h($async$be,r)},
hV(a,b){return a.cb(new A.oS(this,b),t.H)},
f5(a){return this.hV(a,null)}}
A.p1.prototype={
$2(a,b){if(A.w_(this.b,a))return
this.a.f.X(B.m,"Error in crud upload loop",a,b)},
$S:5}
A.oT.prototype={
$0(){return this.a.dS(this.b)},
$S:61}
A.oU.prototype={
$1(a){a.c=a.b=a.a=!1
a.e=null
a.z=this.a
return null},
$S:8}
A.oV.prototype={
$1(a){var s=this.a,r=s.d.d,q=A.vY(r==null?B.u:r),p=q.b
a.J(p)
s.z.c.a.J(p)
return q.a},
$S:24}
A.oM.prototype={
$0(){return this.a.bV(this.b)},
$S:3}
A.oN.prototype={
$1(a){return a.d=!0},
$S:8}
A.oO.prototype={
$1(a){return a.y=null},
$S:8}
A.oP.prototype={
$0(){var s,r=this.a,q=r.d.w
if(q==null)q=B.q
s=this.b
if(q instanceof A.fm)return r.bX(s)
else return r.iy(s)},
$S:64}
A.oQ.prototype={
$1(a){a.d=!1
a.y=this.a
return null},
$S:8}
A.oR.prototype={
$1(a){return a.d=!1},
$S:8}
A.p0.prototype={
$1(a){return this.k6(a)},
k6(a){var s=0,r=A.i(t.N),q,p=this,o,n,m
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.a
s=3
return A.c(o.z.oX(a),$async$$1)
case 3:n=o
m=a
s=5
return A.c(A.vb(o.b,new A.p_(),a,t.N),$async$$1)
case 5:s=4
return A.c(n.ix(m,c),$async$$1)
case 4:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:65}
A.p_.prototype={
$1(a){return A.nT(a)},
$S:30}
A.oW.prototype={
$1(a){return this.k0(a)},
k0(a){var s=0,r=A.i(t.Y),q,p=this,o,n,m
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=A.va("GET",p.b,a)
n=p.a
n.eR(o,p.c)
o.r.m(0,"Accept","application/json")
m=A
s=4
return A.c(n.x.aI(o),$async$$1)
case 4:s=3
return A.c(m.j4(c),$async$$1)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:66}
A.oZ.prototype={
$1(a){return this.b.be(this.a.a,a)},
$S:24}
A.oX.prototype={
$0(){return A.vb(this.a.b,new A.oY(),this.b,t.fo)},
$S:67}
A.oY.prototype={
$1(a){return this.k5(a)},
k5(a){var s=0,r=A.i(t.fo),q,p
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.d0(a,"current",null),$async$$1)
case 3:p=c
q=p==null?null:new A.cW(v.G.BigInt(p))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:68}
A.oS.prototype={
$1(a){var s,r=this.b
if(r==null){r=this.a.d.d
if(r==null)r=B.u}s=A.vY(r)
a.J(s.b)
return s.a},
$S:24}
A.u1.prototype={
$0(){var s,r,q=this.b
if((q.a.a&30)===0){s=this.a
r=s.a
if(r!=null)r.u()
s.a=null
q.N()}},
$S:0}
A.qk.prototype={
hY(a){var s=this.a.e,r=A.a8(s).h("aa<1,a_<j,@>>")
s=A.as(new A.aa(s,new A.ql(),r),r.h("W.E"))
return s},
kO(){return this.b.cb(new A.qs(this),t.U)},
dT(){var s=0,r=A.i(t.ks),q,p=this,o,n,m,l,k,j
var $async$dT=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=p.a
m=n.d
l=A.B3(m)
k=A.B4(m)
j=B.h.aF(n.a)
n=p.hY(n.e)
o=m.w
o=(o==null?B.q:o) instanceof A.d3?"requests":"legacy"
s=3
return A.c(p.bd("start",B.h.bi(A.br(["app_metadata",l,"parameters",k,"schema",j,"include_defaults",m.f!==!1,"active_streams",n,"checkpoint_mode",o],t.N,t.z))),$async$dT)
case 3:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dT,r)},
d1(a,b){return this.mn(a,b)},
mn(a,b){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g
var $async$d1=A.d(function(c,d){if(c===1){p.push(d)
s=q}for(;;)switch(s){case 0:q=3
j=n.a
i=b.a.a
s=6
return A.c(j.b2(i,a.b,a.a),$async$d1)
case 6:m=d
s=7
return A.c(A.vb(j.b,new A.qr(m),i,t.H),$async$d1)
case 7:j=j.z
i=new A.ej(new A.fT(null))
j.a=i
j.b.q(0,i)
o.push(5)
s=4
break
case 3:q=2
g=p.pop()
l=A.H(g)
k=A.O(g)
if((b.a.a.a&30)===0){j=n.a
j.ax.q(0,new A.f_(l,k))
j=j.z
i=new A.ej(new A.ii(l,k))
j.a=i
j.b.q(0,i)}o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
b.j4()
s=o.pop()
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$d1,r)},
m7(a,b){return A.EM(this.a.c_(a,b),t.n).mV(new A.qq(),t.k)},
aK(a){return this.lA(a)},
lA(b5){var s=0,r=A.i(t.U),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4
var $async$aK=A.d(function(b6,b7){if(b6===1){o.push(b7)
s=p}for(;;)switch(s){case 0:b3=!1
p=4
a2=new A.bQ(A.ba(b5,"stream",t.K))
p=7
a3=t.M,a4=m.a,a5=a4.f,a6=m.b.a.a,a7=t.p,a4=a4.w
case 11:s=13
return A.c(a2.l(),$async$aK)
case 13:if(!b7){s=12
break}l=a2.gp()
if((a6.a&30)!==0){s=10
break}k=null
j=l
i=null
h=!1
s=j instanceof A.dK?15:16
break
case 15:s=17
return A.c(m.bd("connection",l.b),$async$aK)
case 17:k=b7
s=14
break
case 16:g=null
if(j instanceof A.cp){if(h)a8=i
else{h=!0
a9=j.a
i=a9
a8=a9}a8=a7.b(a8)
if(a8){if(h)b0=i
else{h=!0
a9=j.a
i=a9
b0=a9}g=a7.a(b0)}}else a8=!1
s=a8?18:19
break
case 18:if(!m.c){a8=a4.b
if(a8>=4)A.v(a4.al())
if((a8&1)!==0)a4.am(null)
else if((a8&3)===0){a8=a4.bW()
b0=new A.bx(null)
b1=a8.c
if(b1==null)a8.b=a8.c=b0
else{b1.sbp(b0)
a8.c=b0}}m.c=!0}s=20
return A.c(m.bd("line_binary",g),$async$aK)
case 20:k=b7
s=14
break
case 19:f=null
a8=j instanceof A.cp
if(a8){if(h)b0=i
else{h=!0
a9=j.a
i=a9
b0=a9}A.an(b0)
if(h)b0=i
else{h=!0
a9=j.a
i=a9
b0=a9}f=A.an(b0)}s=a8?21:22
break
case 21:if(!m.c){a8=a4.b
if(a8>=4)A.v(a4.al())
if((a8&1)!==0)a4.am(null)
else if((a8&3)===0){a8=a4.bW()
b0=new A.bx(null)
b1=a8.c
if(b1==null)a8.b=a8.c=b0
else{b1.sbp(b0)
a8.c=b0}}m.c=!0}s=23
return A.c(m.bd("line_text",f),$async$aK)
case 23:k=b7
s=14
break
case 22:s=j instanceof A.fS?24:25
break
case 24:s=26
return A.c(m.fk("completed_upload"),$async$aK)
case 26:k=b7
s=14
break
case 25:s=j instanceof A.fN?27:28
break
case 27:s=29
return A.c(m.fk("refreshed_token"),$async$aK)
case 29:k=b7
s=14
break
case 28:e=null
a8=j instanceof A.fe
if(a8)e=j.a
s=a8?30:31
break
case 30:s=32
return A.c(m.bd("update_subscriptions",B.h.bi(m.hY(e))),$async$aK)
case 32:k=b7
s=14
break
case 31:d=null
c=null
a8=j instanceof A.f_
if(a8){d=j.a
c=j.b}if(a8)A.ik(d,c)
case 14:a8=J.T(k)
case 33:if(!a8.l()){s=34
break}b=a8.gp()
a=b
if(a instanceof A.dN){a5.X(B.m,"Received EstablishSyncStream connection while already connected.",null,null)
s=33
break}a0=null
b0=a instanceof A.dI
if(b0)a0=a.a
if(b0){b3=a0
s=10
break}a1=null
b0=a3.b(a)
if(b0)a1=a
s=b0?35:36
break
case 35:s=37
return A.c(m.cn(a1),$async$aK)
case 37:case 36:s=33
break
case 34:s=11
break
case 12:case 10:n.push(9)
s=8
break
case 7:n=[4]
case 8:p=4
s=38
return A.c(a2.u(),$async$aK)
case 38:s=n.pop()
break
case 9:p=2
s=6
break
case 4:p=3
b4=o.pop()
if(A.H(b4) instanceof A.cq){if((m.b.a.a.a&30)===0)throw b4}else throw b4
s=6
break
case 3:s=2
break
case 6:q=new A.ho(b3)
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$aK,r)},
d2(){var s=0,r=A.i(t.H),q=this,p,o,n,m
var $async$d2=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:m=J
s=2
return A.c(q.fk("stop"),$async$d2)
case 2:p=m.T(b),o=t.M
case 3:if(!p.l()){s=4
break}n=p.gp()
s=o.b(n)?5:6
break
case 5:s=7
return A.c(q.cn(n),$async$d2)
case 7:case 6:s=3
break
case 4:return A.f(null,r)}})
return A.h($async$d2,r)},
bd(a,b){return this.lH(a,b)},
fk(a){return this.bd(a,null)},
lH(a,b){var s=0,r=A.i(t.ks),q,p=this,o,n,m,l
var $async$bd=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=J
m=t.j
l=B.h
s=3
return A.c(A.ln(p.a.b,a,b),$async$bd)
case 3:o=n.wp(m.a(l.aF(d)),t.f)
q=new A.aa(o,A.Et(),A.p(o).h("aa<A.E,aK>"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bd,r)},
cn(a){return this.lz(a)},
lz(a){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$cn=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=a instanceof A.fp
if(p){o=a.a
n=a.b}else{o=null
n=null}if(p){A:{if("DEBUG"===o){p=B.t
break A}if("INFO"===o){p=B.l
break A}p=B.m
break A}q.a.f.oq(p,n)
s=2
break}p={}
p.a=null
m=a instanceof A.fQ
if(m)p.a=a.a
if(m){q.a.y.c8(new A.qm(p))
s=2
break}p=a instanceof A.fb
l=p?a.a:null
s=p?3:4
break
case 3:p=q.a.c
s=l?5:7
break
case 5:s=8
return A.c(p.b.$1$invalidate(!0),$async$cn)
case 8:s=6
break
case 7:p.b.$1$invalidate(!1).b8(new A.qn(q),new A.qo(q),t.P)
case 6:s=2
break
case 4:if(a instanceof A.f7){q.a.y.c8(new A.qp())
s=2
break}p=a instanceof A.fO
k=p?a.a:null
if(p)q.a.f.X(B.m,"Unknown instruction: "+A.q(k),null,null)
case 2:return A.f(null,r)}})
return A.h($async$cn,r)}}
A.ql.prototype={
$1(a){return A.br(["name",a.a,"params",B.h.aF(a.b)],t.N,t.z)},
$S:69}
A.qs.prototype={
$1(a){return this.ke(a)},
ke(b0){var s=0,r=A.i(t.U),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
var $async$$1=A.d(function(b1,b2){if(b1===1){o.push(b2)
s=p}for(;;)switch(s){case 0:a6=null
a7=null
a8=l=m.a
a9=J
s=3
return A.c(l.dT(),$async$$1)
case 3:a8,k=a9.T(b2),j=t.M,i=l.a,h=i.ax,g=A.p(h).h("aJ<1>"),f=t.k,e=t.fu,d=t.D,c=t.h,b=t.oh
case 4:if(!k.l()){s=5
break}a=k.gp()
a0=a instanceof A.dN
if(a0){a1=a.a
a2=a.b}else{a1=null
a2=null}if(a0){a6=A.yV(A.u([l.m7(a1,b0),new A.aJ(h,g)],e),f)
if(a2!=null){a0=$.m
a3=new A.ad(new A.l(a0,d),c)
a4=A.bs(b)
a5=new A.hP(a3,a4,new A.ad(new A.l(a0,d),c))
a4.q(0,a3)
a7=a5
l.d1(a2,a5)}s=4
break}if(a instanceof A.dI){q=B.ad
s=1
break}a0=j.b(a)
a=a0?a:null
s=a0?6:7
break
case 6:s=8
return A.c(l.cn(a),$async$$1)
case 8:case 7:s=4
break
case 5:if(a6==null){q=B.ad
s=1
break}p=9
s=12
return A.c(l.aK(a6),$async$$1)
case 12:k=b2
q=k
n=[1]
s=10
break
n.push(11)
s=10
break
case 9:n=[2]
case 10:p=2
k=a7
k=k==null?null:k.aB()
s=13
return A.c(k instanceof A.l?k:A.bO(k,t.H),$async$$1)
case 13:k=i.z
k.c=new A.ad(new A.l($.m,d),c)
k.a=B.C
k.b.q(0,B.C)
s=14
return A.c(l.d2(),$async$$1)
case 14:s=n.pop()
break
case 11:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$1,r)},
$S:70}
A.qr.prototype={
$1(a){return A.d0(a,"seed",this.a)},
$S:71}
A.qq.prototype={
$1(a){return this.kd(a)},
kd(a){var $async$$1=A.d(function(b,c){switch(b){case 2:n=q
s=n.pop()
break
case 1:o.push(c)
s=p}for(;;)switch(s){case 0:s=3
q=[1]
return A.kL(A.xL(B.aW),$async$$1,r)
case 3:m=a.w
if(a.e.i(0,"content-type")==="application/vnd.powersync.bson-stream")m=new A.c7(A.EN(),m,t.jB)
else m=B.aI.bg(B.aq.bg(m))
s=4
q=[1]
return A.kL(A.C0(new A.bz(A.EO(),m,m.$ti.h("bz<G.T,aQ>"))),$async$$1,r)
case 4:s=5
q=[1]
return A.kL(A.xL(B.aX),$async$$1,r)
case 5:case 1:return A.kL(null,0,r)
case 2:return A.kL(o.at(-1),1,r)}})
var s=0,r=A.Dh($async$$1,t.k),q,p=2,o=[],n=[],m
return A.DD(r)},
$S:72}
A.qm.prototype={
$1(a){return a.mU(this.a.a)},
$S:8}
A.qn.prototype={
$1(a){var s=this.a
if((s.b.a.a.a&30)===0)s.a.ax.q(0,B.aM)},
$S:73}
A.qo.prototype={
$2(a,b){this.a.a.f.X(B.m,"Could not prefetch credentials",a,b)},
$S:5}
A.qp.prototype={
$1(a){return a.z=null},
$S:8}
A.dK.prototype={
aA(){return"ConnectionEvent."+this.b},
$iaQ:1}
A.cp.prototype={$iaQ:1}
A.fS.prototype={$iaQ:1}
A.fN.prototype={$iaQ:1}
A.fe.prototype={$iaQ:1}
A.f_.prototype={$iaQ:1}
A.cu.prototype={
D(a,b){var s=this
if(b==null)return!1
return b instanceof A.cu&&b.a===s.a&&b.c===s.c&&b.e===s.e&&b.b===s.b&&J.z(b.x,s.x)&&J.z(b.w,s.w)&&J.z(b.f,s.f)&&b.r==s.r&&B.x.aM(b.y,s.y)&&B.x.aM(b.z,s.z)&&J.z(b.d,s.d)&&J.z(b.Q,s.Q)},
gv(a){var s=this
return A.bG(s.a,s.c,s.e,s.b,s.w,s.x,s.f,B.x.c4(s.y),s.d,B.x.c4(s.z))},
j(a){var s,r,q,p,o=this,n="connected",m={},l=new A.X("SyncStatus<")
m.a=!0
m=new A.pd(m,l)
if(o.a)m.$2(n,!0)
else if(o.b)m.$2(n,"connecting")
else m.$2(n,"offline (not connecting)")
m.$2("downloading",""+o.c+" (progress: "+A.q(o.d)+")")
m.$2("uploading",o.e)
m.$2("lastSyncedAt",o.f)
m.$2("hasSynced",o.r)
s=o.x
r=s==null
if(!r)m.$2("downloadError",s)
q=o.w
p=q==null
if(!p)m.$2("uploadError",q)
if(r&&p)m.$2("error",null)
m=l.a+=">"
return m.charCodeAt(0)==0?m:m}}
A.pd.prototype={
$2(a,b){var s,r,q=this.a
if(!q.a)this.b.a+=" "
s=this.b
r=a+": "+A.q(b)
s.a+=r
q.a=!1},
$S:74}
A.ix.prototype={
gv(a){return B.a0.c4(this.c)},
D(a,b){if(b==null)return!1
return b instanceof A.ix&&this.a===b.a&&this.b===b.b&&B.a0.aM(this.c,b.c)},
j(a){return"for total: "+this.b+" / "+this.a}}
A.ns.prototype={
$1(a){var s=a.a
return s[3]-s[0]},
$S:43}
A.nt.prototype={
$1(a){return a.a[2]},
$S:43}
A.nW.prototype={}
A.e3.prototype={
aI(a){return this.kv(a)},
kv(a){var s=0,r=A.i(t.n),q,p=this,o,n,m,l,k,j
var $async$aI=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:a.hv()
k=t.a
j=B.f
s=3
return A.c(new A.cM(A.xk(a.y,t.f4)).he(),$async$aI)
case 3:o=k.a(j.gan(c))
n=p.b++
m=p.a.dG({r:0,i:n,u:a.b.j(0),m:a.a,h:B.h.bi(a.r),b:o})
a.cx.J(new A.oe(p,n))
s=4
return A.c(m,$async$aI)
case 4:l=c
n=A.Ch(p,n).c
q=A.Bh(new A.a5(n,A.p(n).h("a5<1>")),l.s,null,A.As(l),!1,!0,null,a)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aI,r)},
hs(a,b){this.a.x.postMessage({type:"abortHttpRequest",payload:{r:b,i:a}})}}
A.oe.prototype={
$0(){return this.a.hs(this.b,!1)},
$S:0}
A.kk.prototype={
l0(a,b){var s=this.c
s.f=s.d=this.gnH()
s.r=new A.t5(this)},
e9(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h
var $async$e9=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:n.d=!0
q=3
s=6
return A.c(n.a.a.ep(n.b),$async$e9)
case 6:m=b
j=n.c
if(m!=null)j.q(0,A.b3(m,0,null))
else j.n()
o.push(5)
s=4
break
case 3:q=2
h=p.pop()
l=A.H(h)
k=A.O(h)
j=n.c
j.ae(l,k)
j.n()
o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
n.d=!1
n.jf()
s=o.pop()
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$e9,r)},
jf(){var s,r,q=!1
if(!this.d){s=this.c
r=s.b
if((r&1)!==0)if((r&4)===0){q=s.ga5().e
q=(q&4)===0}}if(q)this.e9()}}
A.t5.prototype={
$0(){var s=this.a
return s.a.hs(s.b,!0)},
$S:0}
A.vt.prototype={
$2(a,b){this.a.r.m(0,a,b)
return b},
$S:42}
A.vM.prototype={
n(){var s,r=this
if(!r.a){r.a=!0
s=r.c
if(s!=null)s.u()
r.iT(!1)}},
iT(a){var s,r=this.b
if((r.a.a&30)===0){if(a){s=this.c
if(s!=null)s.u()}r.N()}}}
A.pe.prototype={
m9(a,b,c,d,e){var s=this.a.cD(a,new A.pf(a))
s.e.q(0,new A.fY(e,b,c,d))
return s}}
A.pf.prototype={
$0(){return A.Bm(this.a)},
$S:76}
A.cg.prototype={
kP(a,b){var s=this,r=A.Bz(a,new A.lV(s))
s.a=r
r.b.a.J(s.got())
s.d=$.dD().fa().a_(new A.lW(s))},
h3(){var s=this,r=s.d
if(r!=null)r.u()
r=s.c
if(r!=null)r.e.q(0,new A.hr(s))
s.c=null}}
A.lV.prototype={
$2(a,b){return this.jT(a,b)},
jT(a2,a3){var s=0,r=A.i(t.k0),q,p=this,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
var $async$$2=A.d(function(a4,a5){if(a4===1)return A.e(a5,r)
for(;;)switch(s){case 0:case 3:switch(a2.a){case 1:s=5
break
case 3:s=6
break
case 2:s=7
break
case 7:s=8
break
default:s=9
break}break
case 5:A.S(a3)
o=p.a
n=o.a
n===$&&A.L()
m=a3.lockName
if(!n.e){n.e=!0
A.q4(m).oo(n.gaD(),t.H)}n=A.mF(0,a3.crudThrottleTimeMs)
l=a3.retryDelayMs
A:{if(l==null){m=null
break A}m=A.mF(0,l)
break A}k=a3.syncParamsEncoded
B:{if(k==null){j=null
break B}j=t.f.a(B.h.c2(k,null))
break B}i=a3.implementationName
C:{if(i==null){h=B.O
break C}h=A.ih(B.be,i)
break C}g=a3.appMetadataEncoded
D:{if(g==null){f=null
break D}f=t.N
f=A.wY(t.ea.a(B.h.c2(g,null)),f,f)
break D}e=J.z(a3.customHttpClient,!0)?new A.lU(o):null
d=a3.checkpointModeRequestsDelay
E:{if(d==null){c=B.q
break E}c=new A.d3(A.mF(d,0))
break E}b=a3.databaseName
a=a3.schemaJson
a0=a3.subscriptions
a0=a0==null?null:A.xs(a0)
if(a0==null)a0=B.bg
o.c=o.b.m9(b,new A.fL(f,j,n,m,h,null,e,c),a,a0,o)
q=new A.a2({},null)
s=1
break
case 6:o=p.a
n=o.c
if(n!=null)n.e.q(0,new A.h6(o))
o.c=null
q=new A.a2({},null)
s=1
break
case 7:o=p.a
n=o.c
if(n!=null){m=A.xs(A.S(a3))
n.e.q(0,new A.h3(o,m))}q=new A.a2({},null)
s=1
break
case 8:a1=A
s=10
return A.c(p.a.c.f.er(),$async$$2)
case 10:q=new a1.a2(a5.a,null)
s=1
break
case 9:throw A.b(A.D("Unexpected message type "+a2.j(0)))
case 4:case 1:return A.f(q,r)}})
return A.h($async$$2,r)},
$S:77}
A.lU.prototype={
$0(){var s=this.a.a
s===$&&A.L()
return new A.e3(s)},
$S:78}
A.lW.prototype={
$1(a){var s="["+a.d+"] "+a.a.a+": "+a.e.j(0)+": "+a.b,r=a.r
if(r!=null)s=s+"\n"+A.q(r)
r=a.w
if(r!=null)s=s+"\n"+r.j(0)
r=this.a.a
r===$&&A.L()
r.x.postMessage({type:"logEvent",payload:s.charCodeAt(0)==0?s:s})},
$S:33}
A.ea.prototype={
kU(a){var s=this.e
this.d.q(0,new A.a5(s,A.p(s).h("a5<1>")))
A.Ao(new A.pb(this),t.P)},
ci(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$ci=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=$.dD()
n.X(B.l,"Remote database closed, finding a new client",null,null)
p=q.f
p=p==null?null:p.aB()
s=2
return A.c(p instanceof A.l?p:A.bO(p,t.H),$async$ci)
case 2:q.f=null
s=3
return A.c(q.eX(),$async$ci)
case 3:o=b
s=o==null?4:6
break
case 4:n.X(B.l,"No client remains",null,null)
s=5
break
case 6:s=7
return A.c(q.c0(o),$async$ci)
case 7:case 5:return A.f(null,r)}})
return A.h($async$ci,r)},
jG(){var s,r,q=this,p=q.y,o=A.AG(p,A.a8(p).c)
p=q.x
s=A.wT(new A.bd(p,A.p(p).h("bd<2>")),t.E)
if(!B.aK.aM(o,s)){$.dD().X(B.l,"Subscriptions across tabs have changed, checking whether a reconnect is necessary",null,null)
p=A.as(s,A.p(s).c)
q.y=p
r=q.f
if(r!=null){r.e=p
r=r.ax
if(r.d!=null)r.q(0,new A.fe(p))}}},
eX(){return this.lc()},
lc(){var s=0,r=A.i(t.gO),q,p=this,o,n,m,l,k,j,i,h,g
var $async$eX=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:j={}
i=p.x
h=A.p(i).h("b0<1>")
g=A.as(new A.b0(i,h),h.h("n.E"))
i=g.length
if(i===0){q=null
s=1
break}h=new A.l($.m,t.iB)
o=new A.ad(h,t.if)
j.a=i
for(n=t.P,m=0;m<g.length;g.length===i||(0,A.a6)(g),++m){l=g[m]
k=l.a
k===$&&A.L()
k.eo().aQ(new A.p5(j,o,l),n).oR(B.u,new A.p6(j,l,o))}q=h
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$eX,r)},
c0(a){return this.mh(a)},
mh(a4){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3
var $async$c0=A.d(function(a5,a6){if(a5===1)return A.e(a6,r)
for(;;)switch(s){case 0:a3=$.dD()
a3.X(B.l,"Sync setup: Requesting database",null,null)
p=a4.a
p===$&&A.L()
s=2
return A.c(p.es(),$async$c0)
case 2:o=a6
a3.X(B.l,"Sync setup: Connecting to endpoint",null,null)
p=o.databasePort
s=3
return A.c(A.q8(new A.kh(o.databaseName,p,o.lockName)),$async$c0)
case 3:n=a6
a3.X(B.l,"Sync setup: Has database, starting sync!",null,null)
q.w=a4
p=t.P
n.a.c.a.aQ(new A.p7(a4),p)
m=A.u(["ps_crud"],t.s)
A.EG(new A.dm(t.hV))
l=n.d
k=A.Bq(m).bg(l)
l=q.b.c
if(l==null)l=B.F
j=A.Br(k,l,new A.ac(B.br))
l=q.x
l=A.wT(new A.bd(l,A.p(l).h("bd<2>")),t.E)
l=A.as(l,A.p(l).c)
q.y=l
i=q.c
h=a4.a
g=q.b
f=q.a
p=A.bK(null,null,null,null,!1,p)
e=A.d7(!1,t.gs)
d=A.d7(!1,t.hi)
c=$.m
b=A.d7(!1,t.k)
a=g.r
a=a==null?null:a.$0()
if(a==null){a0=$.m.i(0,B.bt)
a=a0==null?null:t.dF.a(a0).$0()
if(a==null)a=new A.i2(A.u([],t.W))}a1=A.q4("sync-"+f)
f=A.q4("crud-"+f)
a2=t.N
a2=A.br(["X-User-Agent","powersync-dart-core/2.4.0 Dart (flutter-web)"],a2,a2)
q.f=new A.oL(i,n,new A.qP(h.gn3(),new A.p8(a4),h.goW(),new A.p9(a4)),g,l,a3,j,p,a,new A.pc(new A.fu(B.aa),B.bu,e),new A.lF(B.C,d,new A.ad(new A.l(c,t.D),t.h)),a1,f,b,a2)
new A.aJ(e,A.p(e).h("aJ<1>")).a_(new A.pa(q))
q.f.cP()
return A.f(null,r)}})
return A.h($async$c0,r)}}
A.pb.prototype={
$0(){var s=0,r=A.i(t.P),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8
var $async$$0=A.d(function(c9,d0){if(c9===1){p.push(d0)
s=q}for(;;)switch(s){case 0:c6=n.a
c7=c6.d.a
c7===$&&A.L()
c7=new A.bQ(A.ba(new A.a5(c7,A.p(c7).h("a5<1>")),"stream",t.K))
q=2
a8=c6.x,a9=t.D
case 5:s=7
return A.c(c7.l(),$async$$0)
case 7:if(!d0){s=6
break}m=c7.gp()
q=9
l=m
k=null
j=!1
i=null
h=!1
g=null
f=null
e=null
d=null
b0=l instanceof A.fY
if(b0){if(j)b1=k
else{j=!0
b2=l.a
k=b2
b1=b2}g=b1
f=l.b
e=l.c
if(h)b3=i
else{h=!0
b4=l.d
i=b4
b3=b4}d=b3}s=b0?13:14
break
case 13:a8.m(0,g,d)
c=null
b=null
b0=c6.b
b5=f
b6=b5.c
if(b6==null){b6=b0.c
if(b6==null)b6=B.F}b7=b5.d
if(b7==null){b7=b0.d
if(b7==null)b7=B.u}b8=b5.b
if(b8==null){b8=b0.b
if(b8==null)b8=B.K}b9=b5.e
c0=b5.f
if(c0==null)c0=b0.f!==!1
c1=b5.a
if(c1==null){c1=b0.a
if(c1==null)c1=B.L}c2=b5.r
if(c2==null)c2=b0.r
b5=b5.w
if(b5==null){b5=b0.w
if(b5==null)b5=B.q}c3=b0.b
c4=!0
if(B.y.aM(b8,c3==null?B.K:c3)){c3=b0.c
if(b6.D(0,c3==null?B.F:c3)){c3=b0.d
if(b7.D(0,c3==null?B.u:c3))if(b9===b0.e)if(c0===(b0.f!==!1)){c3=b0.a
if(B.y.aM(c1,c3==null?B.L:c3)){b0=b0.w
b0=!b5.D(0,b0==null?B.q:b0)}else b0=c4}else b0=c4
else b0=c4
else b0=c4
c4=b0}}a=new A.a2(new A.fL(c1,b8,b6,b7,b9,c0,c2,b5),c4)
c=a.a
b=a.b
c6.b=c
c6.c=e
b0=c6.f
s=b0==null?15:17
break
case 15:s=18
return A.c(c6.c0(g),$async$$0)
case 18:s=16
break
case 17:s=b?19:21
break
case 19:b0.aB()
c6.f=null
s=22
return A.c(c6.c0(g),$async$$0)
case 22:s=20
break
case 21:c6.jG()
case 20:case 16:a0=c6.r
a1=null
if(a0!=null){a1=a0
b0=g
b5=A.xh(a1)
b0=b0.a
b0===$&&A.L()
b0.x.postMessage({type:"notifySyncStatus",payload:b5})}s=12
break
case 14:a2=null
b0=l instanceof A.hr
if(b0){if(j)b1=k
else{j=!0
b2=l.a
k=b2
b1=b2}a2=b1}s=b0?23:24
break
case 23:a8.I(0,a2)
s=a8.a===0?25:27
break
case 25:b0=c6.f
b0=b0==null?null:b0.aB()
if(!(b0 instanceof A.l)){b5=new A.l($.m,a9)
b5.a=8
b5.c=b0
b0=b5}s=28
return A.c(b0,$async$$0)
case 28:c6.f=null
s=26
break
case 27:s=J.z(a2,c6.w)?29:30
break
case 29:s=31
return A.c(c6.ci(),$async$$0)
case 31:case 30:case 26:s=12
break
case 24:a3=null
b0=l instanceof A.h6
if(b0){if(j)b1=k
else{j=!0
b2=l.a
k=b2
b1=b2}a3=b1}s=b0?32:33
break
case 32:a8.I(0,a3)
b0=c6.f
b0=b0==null?null:b0.aB()
if(!(b0 instanceof A.l)){b5=new A.l($.m,a9)
b5.a=8
b5.c=b0
b0=b5}s=34
return A.c(b0,$async$$0)
case 34:c6.f=null
s=12
break
case 33:a4=null
a5=null
b0=l instanceof A.h3
if(b0){if(j)b1=k
else{j=!0
b2=l.a
k=b2
b1=b2}a4=b1
if(h)b3=i
else{h=!0
b4=l.b
i=b4
b3=b4}a5=b3}if(b0){a8.m(0,a4,a5)
c6.jG()}case 12:q=2
s=11
break
case 9:q=8
c8=p.pop()
a6=A.H(c8)
a7=A.O(c8)
b0=$.dD()
b5=A.q(m)
b0.X(B.m,"Error handling "+b5,a6,a7)
s=11
break
case 8:s=2
break
case 11:s=5
break
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
s=35
return A.c(c7.u(),$async$$0)
case 35:s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:48}
A.p5.prototype={
$1(a){var s;--this.a.a
s=this.b
if((s.a.a&30)===0)s.W(this.c)},
$S:9}
A.p6.prototype={
$0(){var s=this,r=s.a;--r.a
s.b.h3()
if(r.a===0&&(s.c.a.a&30)===0)s.c.W(null)},
$S:1}
A.p7.prototype={
$1(a){$.dD().X(B.t,"Detected closed client",null,null)
this.a.h3()},
$S:9}
A.p8.prototype={
$1$invalidate(a){return this.k8(a)},
k8(a){var s=0,r=A.i(t.B),q,p=this,o
var $async$$1$invalidate=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.a.a
o===$&&A.L()
s=3
return A.c(o.ef(),$async$$1$invalidate)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1$invalidate,r)},
$S:81}
A.p9.prototype={
$2(a,b){return this.k7(a,b)},
k7(a,b){var s=0,r=A.i(t.T),q,p=this,o
var $async$$2=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.a.a
o===$&&A.L()
s=3
return A.c(o.e7(a,b),$async$$2)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$2,r)},
$S:82}
A.pa.prototype={
$1(a){var s,r,q
$.dD().X(B.t,"Broadcasting sync event: "+a.j(0),null,null)
s=this.a
s.r=a
r=A.xh(a)
for(s=s.x,s=new A.fn(s,s.r,s.e);s.l();){q=s.d.a
q===$&&A.L()
q.x.postMessage({type:"notifySyncStatus",payload:r})}},
$S:83}
A.fY.prototype={$ibP:1}
A.hr.prototype={$ibP:1}
A.h6.prototype={$ibP:1}
A.h3.prototype={$ibP:1}
A.am.prototype={
aA(){return"SyncWorkerMessageType."+this.b}}
A.pD.prototype={
$1(a){var s,r,q,p,o
t.c.a(a)
s=t.o.b(a)?a:new A.al(a,A.a8(a).h("al<1,j>"))
r=J.a3(s)
q=r.gk(s)===2
if(q){p=r.i(s,0)
o=r.i(s,1)}else{p=null
o=null}if(!q)throw A.b(A.D("Pattern matching error"))
return new A.ke(p,o)},
$S:84}
A.jD.prototype={
kW(a,b,c,d,e){var s=this,r=s.x
r.start()
s.r=null
s.f=A.aC(r,"message",new A.qe(s),!1,t.m)},
c1(a,b){return this.mi(a,b)},
mi(a,b){var s=0,r=A.i(t.H),q=1,p=[],o=this,n,m,l,k,j,i,h,g,f,e
var $async$c1=A.d(function(c,d){if(c===1){p.push(d)
s=q}for(;;)switch(s){case 0:q=3
n=null
m=null
g=b.$0()
s=6
return A.c(t.nK.b(g)?g:A.bO(g,t.iu),$async$c1)
case 6:l=d
n=l.a
m=l.b
k={type:"okResponse",payload:{requestId:a,payload:n}}
g=o.x
if(m!=null)g.postMessage(k,m)
else g.postMessage(k)
q=1
s=5
break
case 3:q=2
e=p.pop()
j=A.H(e)
i=null
h=j
A:{if(h instanceof A.cq){i=1
break A}i=0
break A}o.x.postMessage({type:"errorResponse",payload:{requestId:a,recognizedType:i,errorMessage:J.aU(j)}})
s=5
break
case 2:s=1
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$c1,r)},
dO(){var s,r,q=this
if(q.d||(q.b.a.a&30)!==0)throw A.b(A.D("Channel has error, cannot send new requests"))
s=q.c++
r=new A.l($.m,t.ny)
q.a.m(0,s,new A.N(r,t.gW))
return new A.a2(s,r)},
cV(a){var s=this.dO()
this.x.postMessage({type:a.b,payload:s.a})
return s.b},
eo(){var s=0,r=A.i(t.H),q=this
var $async$eo=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=2
return A.c(q.cV(B.ak),$async$eo)
case 2:return A.f(null,r)}})
return A.h($async$eo,r)},
es(){var s=0,r=A.i(t.m),q,p=this,o
var $async$es=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=A
s=3
return A.c(p.cV(B.al),$async$es)
case 3:q=o.S(b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$es,r)},
e6(){var s=0,r=A.i(t.B),q,p=this,o,n
var $async$e6=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=A
s=3
return A.c(p.cV(B.ao),$async$e6)
case 3:o=n.vW(b)
q=o==null?null:A.xg(o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$e6,r)},
ef(){var s=0,r=A.i(t.B),q,p=this,o,n
var $async$ef=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=A
s=3
return A.c(p.cV(B.an),$async$ef)
case 3:o=n.vW(b)
q=o==null?null:A.xg(o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ef,r)},
ex(){var s=0,r=A.i(t.H),q=this
var $async$ex=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=2
return A.c(q.cV(B.am),$async$ex)
case 2:return A.f(null,r)}})
return A.h($async$ex,r)},
e7(a,b){return this.n4(a,b)},
n4(a,b){var s=0,r=A.i(t.T),q,p=this,o,n,m
var $async$e7=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=p.dO()
p.x.postMessage({type:"customCheckpointRequest",payload:{req:n.a,clientId:a,requestId:b}})
m=A
s=3
return A.c(n.b,$async$e7)
case 3:o=m.kK(d)
q=o==null?null:o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$e7,r)},
dG(a){return this.kw(a)},
kw(a){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$dG=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.dO()
a.r=o.a
p.x.postMessage({type:"sendHttpRequest",payload:a},[a.b])
n=A
s=3
return A.c(o.b,$async$dG)
case 3:q=n.S(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dG,r)},
ep(a){return this.oG(a)},
oG(a){var s=0,r=A.i(t.aC),q,p=this,o,n
var $async$ep=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.dO()
p.x.postMessage({type:"readResponseChunk",payload:{r:o.a,i:a}})
n=t.aC
s=3
return A.c(o.b,$async$ep)
case 3:q=n.a(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ep,r)},
n(){var s=0,r=A.i(t.H),q=this,p,o
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=q.b
if((o.a.a&30)===0){p=q.f
if(p!=null)p.u()
q.x.close()
p=q.as
if(p!=null)p.pQ()
for(p=q.a,p=new A.bc(p,p.r,p.e);p.l();)p.d.a9(B.az)
o.N()}return A.f(null,r)}})
return A.h($async$n,r)}}
A.qe.prototype={
$1(a){return this.kc(a)},
kc(a){var s=0,r=A.i(t.H),q,p=this,o,n,m,l,k,j,i,h,g
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)A:switch(s){case 0:j=A.S(a.data)
i=A.ih(B.bk,j.type)
h=p.a
g=h.Q
g.X(B.t,"[in] "+i.j(0),null,null)
switch(i.a){case 0:q=h.c1(A.R(A.bR(j.payload)),new A.qa())
s=1
break A
case 1:o=A.S(j.payload).requestId
break
case 2:o=A.S(j.payload).requestId
break
case 4:case 3:case 9:case 8:case 5:case 7:o=A.R(A.bR(j.payload))
break
case 6:o=A.R(A.S(j.payload).req)
break
case 12:n=A.S(j.payload)
q=h.c1(n.r,new A.qb(h,n))
s=1
break A
case 13:m=A.S(j.payload)
g=m.i
l=m.r
g=h.as.b.I(0,g)
if(g!=null)g.iT(l)
s=1
break A
case 14:n=A.S(j.payload)
q=h.c1(n.r,new A.qc(h,n))
s=1
break A
case 15:m=A.S(j.payload)
h.a.I(0,m.requestId).W(m.payload)
s=1
break A
case 16:m=A.S(j.payload)
k=m.recognizedType
B:{if(1===(k==null?0:k)){g=new A.cq("Request aborted by `abortTrigger`",null)
break B}g=m.errorMessage
break B}h.a.I(0,m.requestId).a9(g)
s=1
break A
case 10:h.z.q(0,new A.a2(i,j.payload))
s=1
break A
case 11:g.X(B.l,"[Sync Worker]: "+A.an(j.payload),null,null)
s=1
break A
default:o=null}s=3
return A.c(h.c1(o,new A.qd(h,i,j)),$async$$1)
case 3:case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:86}
A.qa.prototype={
$0(){var s=0,r=A.i(t.lg),q
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q=B.ae
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:87}
A.qb.prototype={
$0(){var s=0,r=A.i(t.iS),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=A
s=3
return A.c(p.a.as.pR(p.b),$async$$0)
case 3:q=new o.a2(b,null)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:88}
A.qc.prototype={
$0(){var s=0,r=A.i(t.jc),q,p=this,o,n
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=3
return A.c(p.a.as.pT(p.b.i),$async$$0)
case 3:n=b
A:{if(n==null){o=B.ae
break A}o=new A.a2(n,[n])
break A}q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:89}
A.qd.prototype={
$0(){return this.a.y.$2(this.b,this.c.payload)},
$S:90}
A.i6.prototype={
j(a){return"Worker communication channel closed"},
$iP:1}
A.uL.prototype={
$1(a){var s=A.S(a.data)
if(s.isForSyncWorker)A.A6(A.S(s.message),this.a)
else this.b.q(0,new v.G.MessageEvent("message",{data:s.message}))},
$S:2}
A.uM.prototype={
$1(a){a.start()
A.aC(a,"message",this.a,!1,t.m)},
$S:2}
A.uK.prototype={
$1(a){var s,r=a.ports
r=J.T(t.ip.b(r)?r:new A.al(r,A.a8(r).h("al<1,x>")))
s=this.a
while(r.l())s.$1(r.gp())},
$S:2}
A.rk.prototype={
n(){if($.zv())v.G.close()},
gn0(){return this.a},
go9(){return this.b}}
A.nS.prototype={}
A.nU.prototype={
eL(){return this.a.eL()}}
A.oo.prototype={
gk(a){return this.c.length},
goh(){return this.b.length},
kR(a,b){var s,r,q,p,o,n,m,l,k
for(s=this.c,r=s.length,q=a.a,p=s.$flags|0,o=q.length,n=this.b,m=0;m<r;++m){l=q.charCodeAt(m)
p&2&&A.C(s)
s[m]=l
if(l===13){k=m+1
if(k>=o||q.charCodeAt(k)!==10)l=10}if(l===10)n.push(m+1)}},
cJ(a){var s,r=this
if(a<0)throw A.b(A.ay("Offset may not be negative, was "+a+"."))
else if(a>r.c.length)throw A.b(A.ay("Offset "+a+u.D+r.gk(0)+"."))
s=r.b
if(a<B.d.gaf(s))return-1
if(a>=B.d.gaO(s))return s.length-1
if(r.lI(a)){s=r.d
s.toString
return s}return r.d=r.l8(a)-1},
lI(a){var s,r,q=this.d
if(q==null)return!1
s=this.b
if(a<s[q])return!1
r=s.length
if(q>=r-1||a<s[q+1])return!0
if(q>=r-2||a<s[q+2]){this.d=q+1
return!0}return!1},
l8(a){var s,r,q=this.b,p=q.length-1
for(s=0;s<p;){r=s+B.b.V(p-s,2)
if(q[r]>a)p=r
else s=r+1}return p},
eJ(a){var s,r,q=this
if(a<0)throw A.b(A.ay("Offset may not be negative, was "+a+"."))
else if(a>q.c.length)throw A.b(A.ay("Offset "+a+" must be not be greater than the number of characters in the file, "+q.gk(0)+"."))
s=q.cJ(a)
r=q.b[s]
if(r>a)throw A.b(A.ay("Line "+s+" comes after offset "+a+"."))
return a-r},
dE(a){var s,r,q,p
if(a<0)throw A.b(A.ay("Line may not be negative, was "+a+"."))
else{s=this.b
r=s.length
if(a>=r)throw A.b(A.ay("Line "+a+" must be less than the number of lines in the file, "+this.goh()+"."))}q=s[a]
if(q<=this.c.length){p=a+1
s=p<r&&q>=s[p]}else s=!0
if(s)throw A.b(A.ay("Line "+a+" doesn't have 0 columns."))
return q}}
A.iq.prototype={
gL(){return this.a.a},
gU(){return this.a.cJ(this.b)},
ga6(){return this.a.eJ(this.b)},
ga7(){return this.b}}
A.er.prototype={
gL(){return this.a.a},
gk(a){return this.c-this.b},
gF(){return A.vg(this.a,this.b)},
gC(){return A.vg(this.a,this.c)},
gag(){return A.bL(B.M.bR(this.a.c,this.b,this.c),0,null)},
gaE(){var s=this,r=s.a,q=s.c,p=r.cJ(q)
if(r.eJ(q)===0&&p!==0){if(q-s.b===0)return p===r.b.length-1?"":A.bL(B.M.bR(r.c,r.dE(p),r.dE(p+1)),0,null)}else q=p===r.b.length-1?r.c.length:r.dE(p+1)
return A.bL(B.M.bR(r.c,r.dE(r.cJ(s.b)),q),0,null)},
Z(a,b){var s
if(!(b instanceof A.er))return this.kH(0,b)
s=B.b.Z(this.b,b.b)
return s===0?B.b.Z(this.c,b.c):s},
D(a,b){var s=this
if(b==null)return!1
if(!(b instanceof A.er))return s.kG(0,b)
return s.b===b.b&&s.c===b.c&&J.z(s.a.a,b.a.a)},
gv(a){return A.bG(this.b,this.c,this.a.a,B.c,B.c,B.c,B.c,B.c,B.c,B.c)},
$ic1:1}
A.mY.prototype={
o7(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.a
a.iQ(B.d.gaf(a1).c)
s=a.e
r=A.b1(s,a0,!1,t.dd)
for(q=a.r,s=s!==0,p=a.b,o=0;o<a1.length;++o){n=a1[o]
if(o>0){m=a1[o-1]
l=n.c
if(!J.z(m.c,l)){a.dW("\u2575")
q.a+="\n"
a.iQ(l)}else if(m.b+1!==n.b){a.mJ("...")
q.a+="\n"}}for(l=n.d,k=A.a8(l).h("d4<1>"),j=new A.d4(l,k),j=new A.ar(j,j.gk(0),k.h("ar<W.E>")),k=k.h("W.E"),i=n.b,h=n.a;j.l();){g=j.d
if(g==null)g=k.a(g)
f=g.a
if(f.gF().gU()!==f.gC().gU()&&f.gF().gU()===i&&a.lJ(B.a.t(h,0,f.gF().ga6()))){e=B.d.cw(r,a0)
if(e<0)A.v(A.K(A.q(r)+" contains no null elements.",a0))
r[e]=g}}a.mI(i)
q.a+=" "
a.mH(n,r)
if(s)q.a+=" "
d=B.d.oa(l,new A.ni())
c=d===-1?a0:l[d]
k=c!=null
if(k){j=c.a
g=j.gF().gU()===i?j.gF().ga6():0
a.mF(h,g,j.gC().gU()===i?j.gC().ga6():h.length,p)}else a.dY(h)
q.a+="\n"
if(k)a.mG(n,c,r)
for(l=l.length,b=0;b<l;++b)continue}a.dW("\u2575")
a1=q.a
return a1.charCodeAt(0)==0?a1:a1},
iQ(a){var s,r,q=this
if(!q.f||!t.R.b(a))q.dW("\u2577")
else{q.dW("\u250c")
q.aJ(new A.n5(q),"\x1b[34m")
s=q.r
r=" "+$.wo().jC(a)
s.a+=r}q.r.a+="\n"},
dU(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=this,g={}
g.a=!1
g.b=null
s=c==null
if(s)r=null
else r=h.b
for(q=b.length,p=h.b,s=!s,o=h.r,n=!1,m=0;m<q;++m){l=b[m]
k=l==null
j=k?null:l.a.gF().gU()
i=k?null:l.a.gC().gU()
if(s&&l===c){h.aJ(new A.nc(h,j,a),r)
n=!0}else if(n)h.aJ(new A.nd(h,l),r)
else if(k)if(g.a)h.aJ(new A.ne(h),g.b)
else o.a+=" "
else h.aJ(new A.nf(g,h,c,j,a,l,i),p)}},
mH(a,b){return this.dU(a,b,null)},
mF(a,b,c,d){var s=this
s.dY(B.a.t(a,0,b))
s.aJ(new A.n6(s,a,b,c),d)
s.dY(B.a.t(a,c,a.length))},
mG(a,b,c){var s,r=this,q=r.b,p=b.a
if(p.gF().gU()===p.gC().gU()){r.fC()
p=r.r
p.a+=" "
r.dU(a,c,b)
if(c.length!==0)p.a+=" "
r.iR(b,c,r.aJ(new A.n7(r,a,b),q))}else{s=a.b
if(p.gF().gU()===s){if(B.d.S(c,b))return
A.EI(c,b)
r.fC()
p=r.r
p.a+=" "
r.dU(a,c,b)
r.aJ(new A.n8(r,a,b),q)
p.a+="\n"}else if(p.gC().gU()===s){p=p.gC().ga6()
if(p===a.a.length){A.z0(c,b)
return}r.fC()
r.r.a+=" "
r.dU(a,c,b)
r.iR(b,c,r.aJ(new A.n9(r,!1,a,b),q))
A.z0(c,b)}}},
iP(a,b,c){var s=c?0:1,r=this.r
s=B.a.aH("\u2500",1+b+this.f2(B.a.t(a.a,0,b+s))*3)
r.a=(r.a+=s)+"^"},
mE(a,b){return this.iP(a,b,!0)},
iR(a,b,c){this.r.a+="\n"
return},
dY(a){var s,r,q,p
for(s=new A.bq(a),r=t.V,s=new A.ar(s,s.gk(0),r.h("ar<A.E>")),q=this.r,r=r.h("A.E");s.l();){p=s.d
if(p==null)p=r.a(p)
if(p===9)q.a+=B.a.aH(" ",4)
else{p=A.aP(p)
q.a+=p}}},
dX(a,b,c){var s={}
s.a=c
if(b!=null)s.a=B.b.j(b+1)
this.aJ(new A.ng(s,this,a),"\x1b[34m")},
dW(a){return this.dX(a,null,null)},
mJ(a){return this.dX(null,null,a)},
mI(a){return this.dX(null,a,null)},
fC(){return this.dX(null,null,null)},
f2(a){var s,r,q,p
for(s=new A.bq(a),r=t.V,s=new A.ar(s,s.gk(0),r.h("ar<A.E>")),r=r.h("A.E"),q=0;s.l();){p=s.d
if((p==null?r.a(p):p)===9)++q}return q},
lJ(a){var s,r,q
for(s=new A.bq(a),r=t.V,s=new A.ar(s,s.gk(0),r.h("ar<A.E>")),r=r.h("A.E");s.l();){q=s.d
if(q==null)q=r.a(q)
if(q!==32&&q!==9)return!1}return!0},
ld(a,b){var s,r=this.b!=null
if(r&&b!=null)this.r.a+=b
s=a.$0()
if(r&&b!=null)this.r.a+="\x1b[0m"
return s},
aJ(a,b){return this.ld(a,b,t.z)}}
A.nh.prototype={
$0(){return this.a},
$S:92}
A.n_.prototype={
$1(a){var s=a.d
return new A.c6(s,new A.mZ(),A.a8(s).h("c6<1>")).gk(0)},
$S:93}
A.mZ.prototype={
$1(a){var s=a.a
return s.gF().gU()!==s.gC().gU()},
$S:23}
A.n0.prototype={
$1(a){return a.c},
$S:95}
A.n2.prototype={
$1(a){var s=a.a.gL()
return s==null?new A.k():s},
$S:96}
A.n3.prototype={
$2(a,b){return a.a.Z(0,b.a)},
$S:97}
A.n4.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=a.a,c=a.b,b=A.u([],t.dg)
for(s=J.bC(c),r=s.gA(c),q=t.g7;r.l();){p=r.gp().a
o=p.gaE()
n=A.uy(o,p.gag(),p.gF().ga6())
n.toString
m=B.a.e1("\n",B.a.t(o,0,n)).gk(0)
l=p.gF().gU()-m
for(p=o.split("\n"),n=p.length,k=0;k<n;++k){j=p[k]
if(b.length===0||l>B.d.gaO(b).b)b.push(new A.by(j,l,d,A.u([],q)));++l}}i=A.u([],q)
for(r=b.length,h=i.$flags|0,g=0,k=0;k<b.length;b.length===r||(0,A.a6)(b),++k){j=b[k]
h&1&&A.C(i,16)
B.d.mc(i,new A.n1(j),!0)
f=i.length
for(q=s.aS(c,g),p=q.$ti,q=new A.ar(q,q.gk(0),p.h("ar<W.E>")),n=j.b,p=p.h("W.E");q.l();){e=q.d
if(e==null)e=p.a(e)
if(e.a.gF().gU()>n)break
i.push(e)}g+=i.length-f
B.d.ab(j.d,i)}return b},
$S:98}
A.n1.prototype={
$1(a){return a.a.gC().gU()<this.a.b},
$S:23}
A.ni.prototype={
$1(a){return!0},
$S:23}
A.n5.prototype={
$0(){this.a.r.a+=B.a.aH("\u2500",2)+">"
return null},
$S:0}
A.nc.prototype={
$0(){var s=this.a.r,r=this.b===this.c.b?"\u250c":"\u2514"
s.a+=r},
$S:1}
A.nd.prototype={
$0(){var s=this.a.r,r=this.b==null?"\u2500":"\u253c"
s.a+=r},
$S:1}
A.ne.prototype={
$0(){this.a.r.a+="\u2500"
return null},
$S:0}
A.nf.prototype={
$0(){var s,r,q=this,p=q.a,o=p.a?"\u253c":"\u2502"
if(q.c!=null)q.b.r.a+=o
else{s=q.e
r=s.b
if(q.d===r){s=q.b
s.aJ(new A.na(p,s),p.b)
p.a=!0
if(p.b==null)p.b=s.b}else{s=q.r===r&&q.f.a.gC().ga6()===s.a.length
r=q.b
if(s)r.r.a+="\u2514"
else r.aJ(new A.nb(r,o),p.b)}}},
$S:1}
A.na.prototype={
$0(){var s=this.b.r,r=this.a.a?"\u252c":"\u250c"
s.a+=r},
$S:1}
A.nb.prototype={
$0(){this.a.r.a+=this.b},
$S:1}
A.n6.prototype={
$0(){var s=this
return s.a.dY(B.a.t(s.b,s.c,s.d))},
$S:0}
A.n7.prototype={
$0(){var s,r,q=this.a,p=q.r,o=p.a,n=this.c.a,m=n.gF().ga6(),l=n.gC().ga6()
n=this.b.a
s=q.f2(B.a.t(n,0,m))
r=q.f2(B.a.t(n,m,l))
m+=s*3
n=(p.a+=B.a.aH(" ",m))+B.a.aH("^",Math.max(l+(s+r)*3-m,1))
p.a=n
return n.length-o.length},
$S:26}
A.n8.prototype={
$0(){return this.a.mE(this.b,this.c.a.gF().ga6())},
$S:0}
A.n9.prototype={
$0(){var s=this,r=s.a,q=r.r,p=q.a
if(s.b)q.a=p+B.a.aH("\u2500",3)
else r.iP(s.c,Math.max(s.d.a.gC().ga6()-1,0),!1)
return q.a.length-p.length},
$S:26}
A.ng.prototype={
$0(){var s=this.b,r=s.r,q=this.a.a
if(q==null)q=""
s=B.a.oC(q,s.d)
s=r.a+=s
q=this.c
r.a=s+(q==null?"\u2502":q)},
$S:1}
A.aN.prototype={
j(a){var s=this.a
s="primary "+(""+s.gF().gU()+":"+s.gF().ga6()+"-"+s.gC().gU()+":"+s.gC().ga6())
return s.charCodeAt(0)==0?s:s}}
A.rI.prototype={
$0(){var s,r,q,p,o=this.a
if(!(t.ol.b(o)&&A.uy(o.gaE(),o.gag(),o.gF().ga6())!=null)){s=A.ja(o.gF().ga7(),0,0,o.gL())
r=o.gC().ga7()
q=o.gL()
p=A.Ea(o.gag(),10)
o=A.op(s,A.ja(r,A.xK(o.gag()),p,q),o.gag(),o.gag())}return A.BX(A.BZ(A.BY(o)))},
$S:100}
A.by.prototype={
j(a){return""+this.b+': "'+this.a+'" ('+B.d.bH(this.d,", ")+")"}}
A.bv.prototype={
fO(a){var s=this.a
if(!J.z(s,a.gL()))throw A.b(A.K('Source URLs "'+A.q(s)+'" and "'+A.q(a.gL())+"\" don't match.",null))
return Math.abs(this.b-a.ga7())},
Z(a,b){var s=this.a
if(!J.z(s,b.gL()))throw A.b(A.K('Source URLs "'+A.q(s)+'" and "'+A.q(b.gL())+"\" don't match.",null))
return this.b-b.ga7()},
D(a,b){if(b==null)return!1
return t.hq.b(b)&&J.z(this.a,b.gL())&&this.b===b.ga7()},
gv(a){var s=this.a
s=s==null?null:s.gv(s)
if(s==null)s=0
return s+this.b},
j(a){var s=this,r=A.uD(s).j(0),q=s.a
return"<"+r+": "+s.b+" "+(A.q(q==null?"unknown source":q)+":"+(s.c+1)+":"+(s.d+1))+">"},
$ia7:1,
gL(){return this.a},
ga7(){return this.b},
gU(){return this.c},
ga6(){return this.d}}
A.jb.prototype={
fO(a){if(!J.z(this.a.a,a.gL()))throw A.b(A.K('Source URLs "'+A.q(this.gL())+'" and "'+A.q(a.gL())+"\" don't match.",null))
return Math.abs(this.b-a.ga7())},
Z(a,b){if(!J.z(this.a.a,b.gL()))throw A.b(A.K('Source URLs "'+A.q(this.gL())+'" and "'+A.q(b.gL())+"\" don't match.",null))
return this.b-b.ga7()},
D(a,b){if(b==null)return!1
return t.hq.b(b)&&J.z(this.a.a,b.gL())&&this.b===b.ga7()},
gv(a){var s=this.a.a
s=s==null?null:s.gv(s)
if(s==null)s=0
return s+this.b},
j(a){var s=A.uD(this).j(0),r=this.b,q=this.a,p=q.a
return"<"+s+": "+r+" "+(A.q(p==null?"unknown source":p)+":"+(q.cJ(r)+1)+":"+(q.eJ(r)+1))+">"},
$ia7:1,
$ibv:1}
A.jd.prototype={
kS(a,b,c){var s,r=this.b,q=this.a
if(!J.z(r.gL(),q.gL()))throw A.b(A.K('Source URLs "'+A.q(q.gL())+'" and  "'+A.q(r.gL())+"\" don't match.",null))
else if(r.ga7()<q.ga7())throw A.b(A.K("End "+r.j(0)+" must come after start "+q.j(0)+".",null))
else{s=this.c
if(s.length!==q.fO(r))throw A.b(A.K('Text "'+s+'" must be '+q.fO(r)+" characters long.",null))}},
gF(){return this.a},
gC(){return this.b},
gag(){return this.c}}
A.je.prototype={
gjw(){return this.a},
j(a){var s,r,q,p=this.b,o="line "+(p.gF().gU()+1)+", column "+(p.gF().ga6()+1)
if(p.gL()!=null){s=p.gL()
r=$.wo()
s.toString
s=o+(" of "+r.jC(s))
o=s}o+=": "+this.a
q=p.o8(null)
p=q.length!==0?o+"\n"+q:o
return"Error on "+(p.charCodeAt(0)==0?p:p)},
$iP:1}
A.e6.prototype={
ga7(){var s=this.b
s=A.vg(s.a,s.b)
return s.b},
$iaR:1,
gdH(){return this.c}}
A.e7.prototype={
gL(){return this.gF().gL()},
gk(a){return this.gC().ga7()-this.gF().ga7()},
Z(a,b){var s=this.gF().Z(0,b.gF())
return s===0?this.gC().Z(0,b.gC()):s},
o8(a){var s=this
if(!t.ol.b(s)&&s.gk(s)===0)return""
return A.Ap(s,a).o7()},
D(a,b){if(b==null)return!1
return b instanceof A.e7&&this.gF().D(0,b.gF())&&this.gC().D(0,b.gC())},
gv(a){return A.bG(this.gF(),this.gC(),B.c,B.c,B.c,B.c,B.c,B.c,B.c,B.c)},
j(a){var s=this
return"<"+A.uD(s).j(0)+": from "+s.gF().j(0)+" to "+s.gC().j(0)+' "'+s.gag()+'">'},
$ia7:1}
A.c1.prototype={
gaE(){return this.d}}
A.e8.prototype={
aA(){return"SqliteUpdateKind."+this.b}}
A.b4.prototype={
gv(a){return A.bG(this.a,this.b,this.c,B.c,B.c,B.c,B.c,B.c,B.c,B.c)},
D(a,b){if(b==null)return!1
return b instanceof A.b4&&b.a===this.a&&b.b===this.b&&b.c===this.c},
j(a){return"SqliteUpdate: "+this.a.j(0)+" on "+this.b+", rowid = "+this.c}}
A.d6.prototype={
j(a){var s,r,q=this,p=q.e
p=p==null?"":"while "+p+", "
p="SqliteException("+q.c+"): "+p+q.a
s=q.b
if(s!=null)p=p+", "+s
s=q.f
if(s!=null){r=q.d
r=r!=null?" (at position "+A.q(r)+"): ":": "
s=p+"\n  Causing statement"+r+s
p=q.r
p=p!=null?s+(", parameters: "+J.eU(p,new A.ou(),t.N).bH(0,", ")):s}return p.charCodeAt(0)==0?p:p},
$iP:1}
A.ou.prototype={
$1(a){if(t.p.b(a))return"blob ("+a.length+" bytes)"
else return J.aU(a)},
$S:35}
A.ml.prototype={
iO(){var s=this,r=s.d
return r==null?s.d=new A.cA(s,A.u([],t.fU),new A.mu(s),new A.mv(s),t.jy):r},
mk(){var s=this,r=s.e
return r==null?s.e=new A.cA(s,A.u([],t.lw),new A.mr(s),new A.ms(s),t.lU):r},
f0(){var s=this,r=s.f
return r==null?s.f=new A.cA(s,A.u([],t.lw),new A.mn(s),new A.mo(s),t.af):r},
n(){var s,r,q,p=this
if(p.r)return
p.r=!0
s=p.d
if(s!=null)s.n()
s=p.f
if(s!=null)s.n()
s=p.e
if(s!=null)s.n()
s=p.b
r=s.ht()
q=r!==0?A.w9(p.a,s,r,"closing database",null,null):null
if(q!=null)throw A.b(q)},
aW(a,b){var s,r,q
if(this.r)A.v(A.D("This database has already been closed"))
s=this.b
r=s.a
q=r.d5(B.n.ao(a),1)
r=r.d
s=A.yK(r,"sqlite3_exec",[s.b,q,0,0,0])
r.dart_sqlite3_free(q)
if(s!==0)A.wg(this,s,"executing",a,b)},
m3(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(e.r)A.v(A.D("This database has already been closed"))
s=B.n.ao(a)
r=e.b
q=r.a
p=q.fG(s)
o=q.d
n=o.dart_sqlite3_malloc(4)
o=o.dart_sqlite3_malloc(4)
m=new A.pV(r,p,n,o)
l=A.u([],t.lE)
k=new A.mp(m,l)
for(r=s.length,q=q.b,j=0;j<r;j=g){i=m.hu(j,r-j,0)
n=i.b
if(n!==0){k.$0()
A.wg(e,n,"preparing statement",a,null)}n=q.buffer
h=B.b.V(n.byteLength,4)
g=new Int32Array(n,0,h)[B.b.a1(o,2)]-p
f=i.a
if(f!=null)l.push(new A.e9(f,e,new A.cD(!1).cS(s,j,g,!0)))
if(l.length===c){j=g
break}}if(b)while(j<r){i=m.hu(j,r-j,0)
n=q.buffer
h=B.b.V(n.byteLength,4)
j=new Int32Array(n,0,h)[B.b.a1(o,2)]-p
f=i.a
if(f!=null){l.push(new A.e9(f,e,""))
k.$0()
throw A.b(A.aV(a,"sql","Had an unexpected trailing statement."))}else if(i.b!==0){k.$0()
throw A.b(A.aV(a,"sql","Has trailing data after the first sql statement:"))}}m.n()
return l},
jB(a,b){var s=this.m3(a,b,1,!1,!0)
if(s.length===0)throw A.b(A.aV(a,"sql","Must contain an SQL statement."))
return B.d.gaf(s)},
oF(a){return this.jB(a,!1)}}
A.mu.prototype={
$0(){var s=this.a,r=s.b
r.a.j8(r.b,new A.mt(s))},
$S:0}
A.mt.prototype={
$3(a,b,c){var s=A.Bg(a)
if(s==null)return
this.a.d.fN(new A.b4(s,b,c))},
$S:102}
A.mv.prototype={
$0(){var s=this.a.b
s.a.j8(s.b,null)
return null},
$S:0}
A.mr.prototype={
$0(){var s=this.a,r=s.b
r.a.j7(r.b,new A.mq(s))
return null},
$S:0}
A.mq.prototype={
$0(){this.a.e.fN(null)},
$S:0}
A.ms.prototype={
$0(){var s=this.a.b
s.a.j7(s.b,null)
return null},
$S:0}
A.mn.prototype={
$0(){var s=this.a,r=s.b
r.a.j6(r.b,new A.mm(s))
return null},
$S:0}
A.mm.prototype={
$0(){var s=this.a.f
s.fN(null)
return 0},
$S:26}
A.mo.prototype={
$0(){var s=this.a.b
s.a.j6(s.b,null)
return null},
$S:0}
A.mp.prototype={
$0(){var s,r,q,p,o,n
this.a.n()
for(s=this.b,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
if(!p.r){p.r=!0
if(!p.f){o=p.a
o.c.d.sqlite3_reset(o.b)
p.f=!0}o=p.a
n=o.c
n.d.sqlite3_finalize(o.b)
n=n.w
if(n!=null){n=n.a
if(n!=null)n.unregister(o.d)}}}},
$S:0}
A.cA.prototype={
gbz(){var s=this.r
return s==null?this.r=this.i4(!1):s},
i4(a){return new A.bA(!0,new A.tk(this,a),this.$ti.h("bA<1>"))},
fN(a){var s,r,q,p,o,n,m
for(s=this.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
o=p.a
if(p.b){n=o.b
if(n>=4)A.v(o.al())
if((n&1)!==0)o.ga5().M(a)}else{n=o.b
if(n>=4)A.v(o.al())
if((n&1)!==0)o.am(a)
else if((n&3)===0){o=o.bW()
n=new A.bx(a)
m=o.c
if(m==null)o.b=o.c=n
else{m.sbp(n)
o.c=n}}}}},
n(){var s,r,q,p=this
for(s=p.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q)s[q].a.n()
p.d=null
if(p.b){p.f.$0()
p.b=!1}}}
A.tk.prototype={
$1(a){var s,r,q=this.a
if(q.a.r){a.n()
return}s=this.b
r=new A.tl(q,a,s)
a.r=a.e=new A.tm(q,a,s)
a.f=r
r.$0()},
$S(){return this.a.$ti.h("~(bY<1>)")}}
A.tl.prototype={
$0(){var s=this.a,r=s.c,q=r.length
r.push(new A.hq(this.b,this.c))
if(q===0){s.e.$0()
s.b=!0}},
$S:0}
A.tm.prototype={
$0(){var s=this.a,r=s.c
B.d.I(r,new A.hq(this.b,this.c))
r=r.length
if(r===0&&!s.a.r){s.f.$0()
s.b=!1}},
$S:0}
A.oq.prototype={
jq(){var s=null,r=this.a.a.d.sqlite3_initialize()
if(r!==0)throw A.b(A.ji(s,s,r,"Error returned by sqlite3_initialize",s,s,s))},
oy(a,b){var s,r,q,p,o,n,m,l,k,j
this.jq()
switch(2){case 2:break}s=this.a
r=s.a
q=r.d5(B.n.ao(a),1)
p=r.d
o=p.dart_sqlite3_malloc(4)
n=r.d5(B.n.ao(b),1)
m=p.sqlite3_open_v2(q,o,6,n)
l=A.bZ(r.b.buffer,0,null)[B.b.a1(o,2)]
p.dart_sqlite3_free(q)
p.dart_sqlite3_free(n)
p.dart_sqlite3_free(n)
o=new A.k()
k=new A.pO(r,l,o)
r=r.r
if(r!=null)r.iX(k,l,o)
if(m!==0){j=A.w9(s,k,m,"opening the database",null,null)
k.ht()
throw A.b(j)}p.sqlite3_extended_result_codes(l,1)
return new A.ml(s,k,!1)}}
A.e9.prototype={
bt(a,b){A.wg(this.b,a,b,this.d,this.e)},
i_(){var s,r=this,q=r.f=!1,p=r.a,o=p.b
p=p.c.d
do s=p.sqlite3_step(o)
while(s===100)
r.du()
if(s!==0?s!==101:q)r.bt(s,"executing statement")},
l9(a){var s=this.a
s=s.c.d.sqlite3_bind_parameter_count(s.b)
if(0!==s)A.v(A.aV(a,"parameters","Expected "+A.q(s)+" parameters, got 0"))
return},
hG(a){A:{if(a instanceof A.nm){this.l9(a.a)
break A}if(a instanceof A.f5)a.a.$1(this)}},
du(){if(!this.f){var s=this.a
s.c.d.sqlite3_reset(s.b)
this.f=!0}},
n(){var s,r,q=this
if(!q.r){q.r=!0
q.du()
s=q.a
r=s.c
r.d.sqlite3_finalize(s.b)
r=r.w
if(r!=null)r.ja(s.d)}},
nF(a){var s=this
if(s.r||s.b.r)A.v(A.D(u.f))
s.du()
s.hG(a)
s.i_()}}
A.is.prototype={
eD(a,b){return this.d.G(a)?1:0},
hm(a,b){this.d.I(0,a)},
hn(a){return new v.G.URL(a,"file:///").pathname},
ca(a,b){var s,r=a.a
if(r==null)r=A.wP(this.b,"/")
s=this.d
if(!s.G(r))if((b&4)!==0)s.m(0,r,new A.bf(new Uint8Array(0),0))
else throw A.b(A.ed(14))
return new A.ez(new A.k0(this,r,(b&8)!==0),0)},
hp(a){}}
A.k0.prototype={
jD(a,b){var s,r=this.a.d.i(0,this.b)
if(r==null||r.b<=b)return 0
s=Math.min(a.length,r.b-b)
B.f.O(a,0,s,J.cJ(B.f.gan(r.a),0,r.b),b)
return s},
hl(){return this.d>=2?1:0},
eE(){if(this.c)this.a.d.I(0,this.b)},
dB(){return this.a.d.i(0,this.b).b},
ho(a){this.d=a},
hq(a){},
dC(a){var s=this.a.d,r=this.b,q=s.i(0,r)
if(q==null){s.m(0,r,new A.bf(new Uint8Array(0),0))
s.i(0,r).sk(0,a)}else q.sk(0,a)},
hr(a){this.d=a},
cI(a,b){var s,r=this.a.d,q=this.b,p=r.i(0,q)
if(p==null){p=new A.bf(new Uint8Array(0),0)
r.m(0,q,p)}s=b+a.length
if(s>p.b)p.sk(0,s)
p.ai(0,b,s,a)}}
A.uW.prototype={
$1(a){return a.length!==0},
$S:22}
A.m3.prototype={
la(){var s,r,q,p,o=A.Z(t.N,t.S)
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
o.m(0,p,B.d.cA(s,p))}this.c=o}}
A.bI.prototype={
gA(a){return new A.kl(this)},
i(a,b){return new A.aS(this,A.nC(this.d[b],t.X))},
m(a,b,c){throw A.b(A.Q("Can't change rows from a result set"))},
gk(a){return this.d.length},
$iw:1,
$in:1,
$ir:1}
A.aS.prototype={
i(a,b){var s
if(typeof b!="string"){if(A.hG(b))return this.b[b]
return null}s=this.a.c.i(0,b)
if(s==null)return null
return this.b[s]},
ga2(){return this.a.a},
$ia_:1}
A.kl.prototype={
gp(){var s=this.a
return new A.aS(s,A.nC(s.d[this.b],t.X))},
l(){return++this.b<this.a.d.length}}
A.km.prototype={}
A.kn.prototype={}
A.kp.prototype={}
A.kq.prototype={}
A.nP.prototype={
aA(){return"OpenMode."+this.b}}
A.cQ.prototype={}
A.nm.prototype={}
A.f5.prototype={}
A.c5.prototype={
j(a){return"VfsException("+this.a+")"},
$iP:1}
A.fF.prototype={}
A.aB.prototype={}
A.i1.prototype={}
A.i0.prototype={
geF(){return 0},
jP(a,b){return 12},
geH(){return 4096},
eG(a,b){var s=this.jD(a,b),r=a.length
if(s<r){B.f.fR(a,s,r,0)
throw A.b(B.bY)}},
$iaM:1,
$ifU:1}
A.dh.prototype={}
A.v3.prototype={
$0(){var s,r,q
for(s=this.a;!s.gE(0);){if(s.b===0)A.v(A.D("No such element"))
r=s.c
q=r.a
q.toString
q.fz(A.p(r).h("aG.E").a(r))
r.d.$0()}},
$S:0}
A.v1.prototype={
$1(a){var s=this.a,r=s.b
s.dN(s.c,new A.dh(a),!1)
if(r===0)v.G.Promise.resolve().then(this.b)},
$S:10}
A.v2.prototype={
$4(a,b,c,d){this.a.$1(c.d6(d))},
$S:104}
A.pT.prototype={}
A.pO.prototype={
ht(){var s=this.a,r=s.r
if(r!=null)r.ja(this.c)
return s.d.sqlite3_close_v2(this.b)}}
A.pV.prototype={
n(){var s=this,r=s.a.a.d
r.dart_sqlite3_free(s.b)
r.dart_sqlite3_free(s.c)
r.dart_sqlite3_free(s.d)},
hu(a,b,c){var s,r,q=this,p=q.a,o=p.a,n=q.c
p=A.yK(o.d,"sqlite3_prepare_v3",[p.b,q.b+a,b,c,n,q.d])
s=A.bZ(o.b.buffer,0,null)[B.b.a1(n,2)]
if(s===0)r=null
else{n=new A.k()
r=new A.pU(s,o,n)
o=o.w
if(o!=null)o.iX(r,s,n)}return new A.kf(r,p)}}
A.pU.prototype={}
A.df.prototype={}
A.cv.prototype={}
A.ef.prototype={
sk(a,b){throw A.b(A.Q("Setting length in WasmValueList"))},
i(a,b){A.bZ(this.a.b.buffer,0,null)
B.b.a1(this.c+b*4,2)
return new A.cv()},
m(a,b,c){throw A.b(A.Q("Setting element in WasmValueList"))},
gk(a){return this.b}}
A.ib.prototype={
os(a){var s=this.b
s===$&&A.L()
A.uZ("[sqlite3] "+A.eh(s,a))},
on(a,b){var s,r,q,p=A.R(v.G.Number(a))*1000
if(p<-864e13||p>864e13)A.v(A.ab(p,-864e13,864e13,"millisecondsSinceEpoch",null))
A.ba(!1,"isUtc",t.y)
s=new A.bb(p,0,!1)
r=this.b
r===$&&A.L()
q=A.AQ(r.buffer,b,8)
q.$flags&2&&A.C(q)
q[0]=A.xa(s)
q[1]=A.x8(s)
q[2]=A.x7(s)
q[3]=A.x6(s)
q[4]=A.x9(s)-1
q[5]=A.xb(s)-1900
q[6]=B.b.aR(A.AX(s),7)},
pr(a,b,c,d,e){var s,r,q,p,o,n,m,l,k=null,j=this.b
j===$&&A.L()
s=new A.fF(A.vD(j,b,k))
try{r=a.ca(s,d)
if(e!==0){p=r.b
o=A.bZ(j.buffer,0,k)
n=B.b.a1(e,2)
o.$flags&2&&A.C(o)
o[n]=p}p=A.bZ(j.buffer,0,k)
o=B.b.a1(c,2)
p.$flags&2&&A.C(p)
p[o]=0
m=r.a
return m}catch(l){p=A.H(l)
if(p instanceof A.c5){q=p
p=q.a
j=A.bZ(j.buffer,0,k)
o=B.b.a1(c,2)
j.$flags&2&&A.C(j)
j[o]=p}else{j=j.buffer
j=A.bZ(j,0,k)
p=B.b.a1(c,2)
j.$flags&2&&A.C(j)
j[p]=1}}return k},
pg(a,b,c){var s=this.b
s===$&&A.L()
return A.b9(new A.m8(a,A.eh(s,b),c))},
p8(a,b,c,d){var s=this.b
s===$&&A.L()
return A.b9(new A.m5(this,a,A.eh(s,b),c,d))},
pn(a,b,c,d){var s=this.b
s===$&&A.L()
return A.b9(new A.ma(this,a,A.eh(s,b),c,d))},
pt(a,b,c){return A.b9(new A.mc(this,c,b,a))},
py(a,b){return A.b9(new A.me(a,b))},
pe(a,b){var s,r=Date.now(),q=this.b
q===$&&A.L()
s=v.G.BigInt(r)
A.vl(A.AO(q.buffer,0,null),"setBigInt64",b,s,!0,null)
return 0},
pc(a){return A.b9(new A.m7(a))},
pv(a,b,c,d){return A.b9(new A.md(this,a,b,c,d))},
pG(a,b,c,d){return A.b9(new A.mi(this,a,b,c,d))},
pC(a,b){return A.b9(new A.mg(a,b))},
pA(a,b){return A.b9(new A.mf(a,b))},
pl(a,b){return A.b9(new A.m9(this,a,b))},
pp(a,b){return A.b9(new A.mb(a,b))},
pE(a,b){return A.b9(new A.mh(a,b))},
pa(a,b){return A.b9(new A.m6(this,a,b))},
ph(a){return a.geF()},
pj(a,b,c){if(t.j2.b(a))return a.jP(b,c)
return 12},
pw(a){if(t.j2.b(a))return a.geH()
return 4096},
nk(a){a.$0()},
nf(a){return a.$0()},
ni(a,b,c,d,e){var s=this.b
s===$&&A.L()
a.$3(b,A.eh(s,d),A.R(v.G.Number(e)))},
nq(a,b,c,d){var s=a.gpV(),r=this.a
r===$&&A.L()
s.$2(new A.df(),new A.ef(r,c,d))},
nu(a,b,c,d){var s=a.gpX(),r=this.a
r===$&&A.L()
s.$2(new A.df(),new A.ef(r,c,d))},
ns(a,b,c,d){var s=a.gpW(),r=this.a
r===$&&A.L()
s.$2(new A.df(),new A.ef(r,c,d))},
nw(a,b){var s=a.gpY()
this.a===$&&A.L()
s.$1(new A.df())},
no(a,b){var s=a.gpU()
this.a===$&&A.L()
s.$1(new A.df())},
nm(a,b,c,d,e){var s,r,q=this.b
q===$&&A.L()
s=A.vD(q,c,b)
r=A.vD(q,e,d)
return a.gpM().$2(s,r)},
nd(a,b){return a.$1(b)},
nb(a,b){return a.gpO().$1(b)},
n9(a,b,c){return a.gpN().$2(b,c)}}
A.m8.prototype={
$0(){return this.a.hm(this.b,this.c)},
$S:0}
A.m5.prototype={
$0(){var s,r=this,q=r.b.eD(r.c,r.d),p=r.a.b
p===$&&A.L()
p=A.bZ(p.buffer,0,null)
s=B.b.a1(r.e,2)
p.$flags&2&&A.C(p)
p[s]=q},
$S:0}
A.ma.prototype={
$0(){var s,r,q=this,p=B.n.ao(q.b.hn(q.c)),o=p.length
if(o>q.d)throw A.b(A.ed(14))
s=q.a.b
s===$&&A.L()
s=A.b3(s.buffer,0,null)
r=q.e
B.f.ce(s,r,p)
s.$flags&2&&A.C(s)
s[r+o]=0},
$S:0}
A.mc.prototype={
$0(){var s,r=this,q=r.a.b
q===$&&A.L()
s=A.b3(q.buffer,r.b,r.c)
q=r.d
if(q!=null)A.wx(s,q.b)
else return A.wx(s,null)},
$S:0}
A.me.prototype={
$0(){this.a.hp(A.mF(this.b,0))},
$S:0}
A.m7.prototype={
$0(){return this.a.eE()},
$S:0}
A.md.prototype={
$0(){var s=this,r=s.a.b
r===$&&A.L()
s.b.eG(A.b3(r.buffer,s.c,s.d),A.R(v.G.Number(s.e)))},
$S:0}
A.mi.prototype={
$0(){var s=this,r=s.a.b
r===$&&A.L()
s.b.cI(A.b3(r.buffer,s.c,s.d),A.R(v.G.Number(s.e)))},
$S:0}
A.mg.prototype={
$0(){return this.a.dC(A.R(v.G.Number(this.b)))},
$S:0}
A.mf.prototype={
$0(){return this.a.hq(this.b)},
$S:0}
A.m9.prototype={
$0(){var s,r=this.b.dB(),q=this.a.b
q===$&&A.L()
q=A.bZ(q.buffer,0,null)
s=B.b.a1(this.c,2)
q.$flags&2&&A.C(q)
q[s]=r},
$S:0}
A.mb.prototype={
$0(){return this.a.ho(this.b)},
$S:0}
A.mh.prototype={
$0(){return this.a.hr(this.b)},
$S:0}
A.m6.prototype={
$0(){var s,r=this.b.hl(),q=this.a.b
q===$&&A.L()
q=A.bZ(q.buffer,0,null)
s=B.b.a1(this.c,2)
q.$flags&2&&A.C(q)
q[s]=r},
$S:0}
A.eV.prototype={
B(a,b,c,d){var s,r=null,q={},p=A.S(A.vl(this.a,v.G.Symbol.asyncIterator,r,r,r,r)),o=A.bK(r,r,r,r,!0,this.$ti.c)
q.a=null
s=new A.l6(q,this,p,o)
o.d=s
o.f=new A.l7(q,o,s)
return new A.a5(o,A.p(o).h("a5<1>")).B(a,b,c,d)},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.l6.prototype={
$0(){var s,r=this,q=r.c.next(),p=r.a
p.a=q
s=r.d
A.aq(q,t.m).b8(new A.l8(p,r.b,s,r),s.gfE(),t.P)},
$S:0}
A.l8.prototype={
$1(a){var s,r,q=this,p=a.done
if(p==null)p=null
s=a.value
r=q.c
if(p===!0){r.n()
q.a.a=null}else{r.q(0,s==null?q.b.$ti.c.a(s):s)
q.a.a=null
p=r.b
if(!((p&1)!==0?(r.ga5().e&4)!==0:(p&2)===0))q.d.$0()}},
$S:11}
A.l7.prototype={
$0(){var s,r
if(this.a.a==null){s=this.b
r=s.b
s=!((r&1)!==0?(s.ga5().e&4)!==0:(r&2)===0)}else s=!1
if(s)this.c.$0()},
$S:0}
A.dl.prototype={
u(){var s=0,r=A.i(t.H),q=this,p
var $async$u=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=q.b
if(p!=null)p.u()
p=q.c
if(p!=null)p.u()
q.c=q.b=null
return A.f(null,r)}})
return A.h($async$u,r)},
gp(){var s=this.a
return s==null?A.v(A.D("Await moveNext() first")):s},
l(){var s,r,q,p=this,o=p.a
if(o!=null)o.continue()
o=new A.l($.m,t.x)
s=new A.N(o,t.ex)
r=p.d
q=t.m
p.b=A.aC(r,"success",new A.r9(p,s),!1,q)
p.c=A.aC(r,"error",new A.ra(p,s),!1,q)
return o}}
A.r9.prototype={
$1(a){var s,r=this.a
r.u()
s=r.$ti.h("1?").a(r.d.result)
r.a=s
this.b.W(s!=null)},
$S:2}
A.ra.prototype={
$1(a){var s=this.a
s.u()
s=s.d.error
if(s==null)s=a
this.b.a9(s)},
$S:2}
A.lM.prototype={
$1(a){this.a.W(this.c.a(this.b.result))},
$S:2}
A.lN.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.a9(s)},
$S:2}
A.lR.prototype={
$1(a){this.a.W(this.c.a(this.b.result))},
$S:2}
A.lS.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.a9(s)},
$S:2}
A.lT.prototype={
$1(a){this.a.a9(new A.b5("IndexedDB open blocked"))},
$S:2}
A.mJ.prototype={
$1(a){return A.S(a[1])},
$S:125}
A.pP.prototype={
n2(){var s={}
s.dart=new A.pQ(this).$0()
return s},
ej(a){return this.oi(a)},
oi(a){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$ej=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(A.aq(v.G.WebAssembly.instantiateStreaming(a,p.n2()),t.m),$async$ej)
case 3:o=c
n=o.instance.exports
if("_initialize" in n)t.g.a(n._initialize).call()
q=o.instance
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ej,r)}}
A.pQ.prototype={
$0(){var s=this.a.a,r=A.S(v.G.Object),q=A.S(r.create.apply(r,[null]))
q.error_log=A.bB(s.gor())
q.localtime=A.b7(s.gom())
q.xOpen=A.w1(s.gpq())
q.xDelete=A.kN(s.gpf())
q.xAccess=A.eJ(s.gp7())
q.xFullPathname=A.eJ(s.gpm())
q.xRandomness=A.kN(s.gps())
q.xSleep=A.b7(s.gpx())
q.xCurrentTimeInt64=A.b7(s.gpd())
q.xClose=A.bB(s.gpb())
q.xRead=A.eJ(s.gpu())
q.xWrite=A.eJ(s.gpF())
q.xTruncate=A.b7(s.gpB())
q.xSync=A.b7(s.gpz())
q.xFileSize=A.b7(s.gpk())
q.xLock=A.b7(s.gpo())
q.xUnlock=A.b7(s.gpD())
q.xCheckReservedLock=A.b7(s.gp9())
q.xDeviceCharacteristics=A.bB(s.geF())
q.xFileControl=A.kN(s.gpi())
q.xSectorSize=A.bB(s.geH())
q["dispatch_()v"]=A.bB(s.gnj())
q["dispatch_()i"]=A.bB(s.gne())
q.dispatch_update=A.w1(s.gnh())
q.dispatch_xFunc=A.eJ(s.gnp())
q.dispatch_xStep=A.eJ(s.gnt())
q.dispatch_xInverse=A.eJ(s.gnr())
q.dispatch_xValue=A.b7(s.gnv())
q.dispatch_xFinal=A.b7(s.gnn())
q.dispatch_compare=A.w1(s.gnl())
q.dispatch_busy=A.b7(s.gnc())
q.changeset_apply_filter=A.b7(s.gna())
q.changeset_apply_conflict=A.kN(s.gn8())
return q},
$S:19}
A.ee.prototype={}
A.ld.prototype={
em(){var s=0,r=A.i(t.H),q=this,p,o
var $async$em=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=new A.l($.m,t.a7)
o=v.G.indexedDB.open(q.b,1)
o.onupgradeneeded=A.bB(new A.lg(o))
new A.N(p,t.h1).W(A.A5(o,t.m))
s=2
return A.c(p,$async$em)
case 2:q.a=b
return A.f(null,r)}})
return A.h($async$em,r)},
cp(a,b){return this.ml(a,b)},
ml(a,b){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$cp=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=q.a
n.toString
p=n.transaction($.zE(),b)
o=A.C_(p)
s=2
return A.c(A.EK(new A.lf(a,o,p),t.mj),$async$cp)
case 2:s=3
return A.c(o.b.a,$async$cp)
case 3:if(o.c){n=q.a
if(n!=null)n.close()
q.a=null}return A.f(null,r)}})
return A.h($async$cp,r)},
m1(a){return this.cp(new A.le(a),"readwrite")}}
A.lg.prototype={
$1(a){var s=A.S(this.a.result)
if(J.z(a.oldVersion,0)){s.createObjectStore("files",{autoIncrement:!0}).createIndex("fileName","name",{unique:!0})
s.createObjectStore("blocks")}},
$S:11}
A.lf.prototype={
$0(){var s=0,r=A.i(t.P),q=1,p=[],o=this,n,m
var $async$$0=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:q=3
s=6
return A.c(o.a.$1(o.b),$async$$0)
case 6:q=1
s=5
break
case 3:q=2
m=p.pop()
o.c.abort()
throw m
s=5
break
case 2:s=1
break
case 5:o.c.commit()
return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:48}
A.le.prototype={
$1(a){return this.jQ(a)},
jQ(a){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=q.a,o=p.length,n=0
case 2:if(!(n<p.length)){s=4
break}s=5
return A.c(p[n].ak(a),$async$$1)
case 5:case 3:p.length===o||(0,A.a6)(p),++n
s=2
break
case 4:return A.f(null,r)}})
return A.h($async$$1,r)},
$S:18}
A.hd.prototype={
kZ(a){var s=A.u4(new A.rL(this)),r=this.a
r.oncomplete=s
r.onabort=s
r.onerror=A.u4(new A.rM(this))},
fp(a,b,c){var s=t.gk
return v.G.IDBKeyRange.bound(A.u([a,c],s),A.u([a,b],s))},
m5(a){return this.fp(a,9007199254740992,0)},
m6(a,b){return this.fp(a,9007199254740992,b)},
ei(){var s=0,r=A.i(t.dV),q,p=this,o,n,m,l,k
var $async$ei=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:l=A.Z(t.N,t.S)
k=new A.dl(p.d.index("fileName").openKeyCursor(),t.Q)
case 3:s=5
return A.c(k.l(),$async$ei)
case 5:if(!b){s=4
break}o=k.a
if(o==null)o=A.v(A.D("Await moveNext() first"))
n=o.key
n.toString
A.an(n)
m=o.primaryKey
m.toString
l.m(0,n,A.R(A.bR(m)))
s=3
break
case 4:q=l
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ei,r)},
ea(a){return this.nI(a)},
nI(a){var s=0,r=A.i(t.aV),q,p=this,o
var $async$ea=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=A
s=3
return A.c(A.bD(p.d.index("fileName").getKey(a),t.i),$async$ea)
case 3:q=o.R(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ea,r)},
fq(a){return A.bD(this.d.get(a),t.A).aQ(new A.rK(a),t.m)},
cO(a,b){return this.kz(a,b)},
kz(a,b){var s=0,r=A.i(t.oR),q,p=this,o,n,m,l,k,j,i,h,g,f,e
var $async$cO=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.fq(a),$async$cO)
case 3:h=d
g=h.length
f=new A.bf(new Uint8Array(g),g)
e=new A.dl(p.e.openCursor(p.m5(a)),t.Q)
g=t.a,o=v.G,n=t.c,m=t.H
case 4:s=6
return A.c(e.l(),$async$cO)
case 6:if(!d){s=5
break}l=e.a
if(l==null)l=A.v(A.D("Await moveNext() first"))
k=n.a(l.key)
j=A.R(A.bR(k[1]))
if(j>=h.length){s=5
break}i=new A.rN(f,j,Math.min(4096,h.length-j))
if(l.value instanceof o.Blob)b.push(A.o4(A.S(l.value)).aQ(i,m))
else i.$1(g.a(l.value))
s=4
break
case 5:q=f
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cO,r)},
e5(a){return this.n1(a)},
n1(a){var s=0,r=A.i(t.S),q,p=this,o
var $async$e5=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:if((p.b.a.a&30)!==0)A.v(A.D("IDB transaction already completed"))
o=A
s=3
return A.c(A.bD(p.d.put({name:a,length:0}),t.i),$async$e5)
case 3:q=o.R(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$e5,r)},
c9(a,b){return this.oZ(a,b)},
oZ(a,b){var s=0,r=A.i(t.H),q=this,p,o,n,m,l
var $async$c9=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:if((q.b.a.a&30)!==0)A.v(A.D("IDB transaction already completed"))
s=2
return A.c(q.fq(a),$async$c9)
case 2:p=d
o=b.b
n=A.p(o).h("b0<1>")
m=A.as(new A.b0(o,n),n.h("n.E"))
B.d.ky(m)
s=3
return A.c(A.mU(new A.aa(m,new A.rO(new A.rP(q,a),b),A.a8(m).h("aa<1,o<~>>")),t.H),$async$c9)
case 3:s=b.c!==p.length?4:5
break
case 4:l=new A.dl(q.d.openCursor(a),t.Q)
s=6
return A.c(l.l(),$async$c9)
case 6:s=7
return A.c(A.bD(l.gp().update({name:p.name,length:b.c}),t.X),$async$c9)
case 7:case 5:return A.f(null,r)}})
return A.h($async$c9,r)},
c7(a,b,c){return this.oT(0,b,c)},
oT(a,b,c){var s=0,r=A.i(t.H),q=this,p,o
var $async$c7=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:if((q.b.a.a&30)!==0)A.v(A.D("IDB transaction already completed"))
s=2
return A.c(q.fq(b),$async$c7)
case 2:p=e
s=p.length>c?3:4
break
case 3:s=5
return A.c(A.bD(q.e.delete(q.m6(b,B.b.V(c,4096)*4096)),t.X),$async$c7)
case 5:case 4:o=new A.dl(q.d.openCursor(b),t.Q)
s=6
return A.c(o.l(),$async$c7)
case 6:s=7
return A.c(A.bD(o.gp().update({name:p.name,length:c}),t.X),$async$c7)
case 7:return A.f(null,r)}})
return A.h($async$c7,r)},
e8(a){return this.n7(a)},
n7(a){var s=0,r=A.i(t.H),q=this,p
var $async$e8=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:if((q.b.a.a&30)!==0)A.v(A.D("IDB transaction already completed"))
p=t.X
s=2
return A.c(A.mU(A.u([A.bD(q.e.delete(q.fp(a,9007199254740992,0)),p),A.bD(q.d.delete(a),p)],t.iw),t.H),$async$e8)
case 2:return A.f(null,r)}})
return A.h($async$e8,r)}}
A.rL.prototype={
$0(){this.a.b.N()},
$S:1}
A.rM.prototype={
$0(){var s=this.a,r=s.a.error
if(r==null)r=new v.G.DOMException("IDB transaction error")
s.b.a9(r)},
$S:1}
A.rK.prototype={
$1(a){if(a==null)throw A.b(A.aV(this.a,"fileId","File not found in database"))
else return a},
$S:127}
A.rN.prototype={
$1(a){var s=this.a
s.ce(s,this.b,J.cJ(a,0,this.c))},
$S:128}
A.rP.prototype={
kg(a,b){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$$2=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p=q.a.e
o=q.b
n=t.gk
s=2
return A.c(A.bD(p.openCursor(v.G.IDBKeyRange.only(A.u([o,a],n))),t.A),$async$$2)
case 2:m=d
l=t.a.a(B.f.gan(b))
k=t.X
s=m==null?3:5
break
case 3:s=6
return A.c(A.bD(p.put(l,A.u([o,a],n)),k),$async$$2)
case 6:s=4
break
case 5:s=7
return A.c(A.bD(m.update(l),k),$async$$2)
case 7:case 4:return A.f(null,r)}})
return A.h($async$$2,r)},
$2(a,b){return this.kg(a,b)},
$S:129}
A.rO.prototype={
$1(a){var s=this.b.b.i(0,a)
s.toString
return this.a.$2(a,s)},
$S:130}
A.ro.prototype={
mA(a,b,c){B.f.ce(this.b.cD(a,new A.rp(this,a)),b,c)},
mT(a,b){var s,r,q,p,o,n,m,l
for(s=b.length,r=0;r<s;r=l){q=a+r
p=B.b.V(q,4096)
o=B.b.aR(q,4096)
n=s-r
if(o!==0)m=Math.min(4096-o,n)
else{m=Math.min(4096,n)
o=0}l=r+m
this.mA(p*4096,o,J.cJ(B.f.gan(b),b.byteOffset+r,m))}this.c=Math.max(this.c,a+s)}}
A.rp.prototype={
$0(){var s=new Uint8Array(4096),r=this.a.a,q=r.length,p=this.b
if(q>p)B.f.ce(s,0,J.cJ(B.f.gan(r),r.byteOffset+p,Math.min(4096,q-p)))
return s},
$S:131}
A.k8.prototype={}
A.ck.prototype={
d3(a){var s=this
if(s.e||s.d.a==null)A.v(A.ed(10))
if(a.fZ(s.x)){s.bD(!0)
return a.d.a}else return A.mS(null,t.H)},
bD(a){return this.mt(a)},
mt(a){var s=0,r=A.i(t.H),q,p=this,o,n
var $async$bD=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:if(a&&!p.r){s=1
break}s=!p.f&&!p.x.gE(0)?3:4
break
case 3:p.f=!0
o=p.x
n=A.as(o,o.$ti.h("n.E"))
o.aC(0)
s=5
return A.c(p.d.m1(n).J(new A.nk(p,n,a)),$async$bD)
case 5:case 4:case 1:return A.f(q,r)}})
return A.h($async$bD,r)},
n(){var s=0,r=A.i(t.H),q,p=this,o,n
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if(!p.e){o=p.d3(new A.hb(new A.nl(),new A.N(new A.l($.m,t.D),t.F)))
p.e=!0
p.bD(!1)
q=o
s=1
break}else{n=p.x
if(!n.gE(0)){q=n.gaO(0).d.a
s=1
break}}case 1:return A.f(q,r)}})
return A.h($async$n,r)},
cl(a,b){return this.lu(a,b)},
lu(a,b){var s=0,r=A.i(t.S),q,p=this,o,n
var $async$cl=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=p.z
s=n.G(b)?3:5
break
case 3:n=n.i(0,b)
n.toString
q=n
s=1
break
s=4
break
case 5:s=6
return A.c(a.ea(b),$async$cl)
case 6:o=d
o.toString
n.m(0,b,o)
q=o
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$cl,r)},
cZ(){var s=0,r=A.i(t.H),q=this,p
var $async$cZ=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=A.u([],t.iw)
s=2
return A.c(q.d.cp(new A.nj(q,p),"readonly"),$async$cZ)
case 2:s=3
return A.c(A.An(p,t.H),$async$cZ)
case 3:return A.f(null,r)}})
return A.h($async$cZ,r)},
nM(){return this.bD(!1)},
eD(a,b){return this.w.d.G(a)?1:0},
hm(a,b){var s=this
s.w.d.I(0,a)
if(!s.y.I(0,a))s.d3(new A.h5(s,a,new A.N(new A.l($.m,t.D),t.F)))},
hn(a){return new v.G.URL(a,"file:///").pathname},
ca(a,b){var s,r,q,p=this,o=a.a
if(o==null)o=A.wP(p.b,"/")
s=p.w
r=s.d.G(o)?1:0
q=s.ca(new A.fF(o),b)
if(r===0)if((b&8)!==0)p.y.q(0,o)
else p.d3(new A.en(p,o,new A.N(new A.l($.m,t.D),t.F)))
return new A.ez(new A.k1(p,q.a,o),0)},
hp(a){}}
A.nk.prototype={
$0(){var s,r,q,p,o=this.a
o.f=!1
for(s=this.b,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q].d.a
if((p.a&30)!==0)A.v(A.D("Future already completed"))
p.bb(null)}o.bD(this.c)},
$S:1}
A.nl.prototype={
$1(a){return this.jV(a)},
jV(a){var s=0,r=A.i(t.H)
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:a.c=!0
return A.f(null,r)}})
return A.h($async$$1,r)},
$S:18}
A.nj.prototype={
$1(a){return this.jU(a)},
jU(a){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=2
return A.c(a.ei(),$async$$1)
case 2:m=c
l=q.a
l.z.ab(0,m)
p=m.gbj(),p=p.gA(p),o=q.b,l=l.w.d
case 3:if(!p.l()){s=4
break}n=p.gp()
k=l
j=n.a
s=5
return A.c(a.cO(n.b,o),$async$$1)
case 5:k.m(0,j,c)
s=3
break
case 4:return A.f(null,r)}})
return A.h($async$$1,r)},
$S:18}
A.k1.prototype={
eG(a,b){this.b.eG(a,b)},
geF(){return 0},
geH(){return 4096},
hl(){return this.b.d>=2?1:0},
eE(){},
dB(){return this.b.dB()},
ho(a){this.b.d=a
return null},
hq(a){},
jP(a,b){return 12},
dC(a){var s=this,r=s.a
if(r.e||r.d.a==null)A.v(A.ed(10))
s.b.dC(a)
if(!r.y.S(0,s.c))r.d3(new A.hb(new A.rJ(s,a),new A.N(new A.l($.m,t.D),t.F)))},
hr(a){this.b.d=a
return null},
cI(a,b){var s,r,q,p,o,n,m=this,l=m.a
if(l.e||l.d.a==null)A.v(A.ed(10))
s=m.c
if(l.y.S(0,s)){m.b.cI(a,b)
return}r=l.w.d.i(0,s)
if(r==null)r=new A.bf(new Uint8Array(0),0)
q=J.cJ(B.f.gan(r.a),0,r.b)
m.b.cI(a,b)
p=new Uint8Array(a.length)
B.f.ce(p,0,a)
o=A.u([],t.o6)
n=$.m
o.push(new A.k8(b,p))
l.d3(new A.eG(l,s,q,o,new A.N(new A.l(n,t.D),t.F)))},
$iaM:1,
$ifU:1}
A.rJ.prototype={
$1(a){return this.kf(a)},
kf(a){var s=0,r=A.i(t.H),q,p=this,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.a
n=a
s=3
return A.c(o.a.cl(a,o.c),$async$$1)
case 3:q=n.c7(0,c,p.b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:18}
A.aD.prototype={
fZ(a){a.dN(a.c,this,!1)
return!0}}
A.hb.prototype={
ak(a){return this.w.$1(a)}}
A.h5.prototype={
fZ(a){var s,r,q,p
if(!a.gE(0)){s=a.gaO(0)
for(r=this.x;s!=null;)if(s instanceof A.h5)if(s.x===r)return!1
else s=s.gds()
else if(s instanceof A.eG){q=s.gds()
if(s.x===r){p=s.a
p.toString
p.fz(A.p(s).h("aG.E").a(s))}s=q}else if(s instanceof A.en){if(s.x===r){r=s.a
r.toString
r.fz(A.p(s).h("aG.E").a(s))
return!1}s=s.gds()}else break}a.dN(a.c,this,!1)
return!0},
ak(a){return this.oO(a)},
oO(a){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$ak=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=q.w
o=q.x
s=2
return A.c(p.cl(a,o),$async$ak)
case 2:n=c
p.z.I(0,o)
s=3
return A.c(a.e8(n),$async$ak)
case 3:return A.f(null,r)}})
return A.h($async$ak,r)}}
A.en.prototype={
ak(a){return this.oN(a)},
oN(a){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$ak=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=q.x
o=q.w.z
n=p
s=2
return A.c(a.e5(p),$async$ak)
case 2:o.m(0,n,c)
return A.f(null,r)}})
return A.h($async$ak,r)}}
A.eG.prototype={
fZ(a){var s,r=a.b===0?null:a.gaO(0)
for(s=this.x;r!=null;)if(r instanceof A.eG)if(r.x===s){B.d.ab(r.z,this.z)
return!1}else r=r.gds()
else if(r instanceof A.en){if(r.x===s)break
r=r.gds()}else break
a.dN(a.c,this,!1)
return!0},
ak(a){return this.oP(a)},
oP(a){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$ak=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:m=q.y
l=new A.ro(m,A.Z(t.S,t.p),m.length)
for(m=q.z,p=m.length,o=0;o<m.length;m.length===p||(0,A.a6)(m),++o){n=m[o]
l.mT(n.a,n.b)}k=a
s=3
return A.c(q.w.cl(a,q.x),$async$ak)
case 3:s=2
return A.c(k.c9(c,l),$async$ak)
case 2:return A.f(null,r)}})
return A.h($async$ak,r)}}
A.dO.prototype={
aA(){return"FileType."+this.b}}
A.e5.prototype={
b3(){var s=this.d
if(s!=null)return s
throw A.b(A.D("VFS closed"))},
eD(a,b){var s=$.v8().i(0,a)
if(s==null)return this.e.d.G(a)?1:0
else return this.b3().jd(s)?1:0},
hm(a,b){var s=$.v8().i(0,a)
if(s==null){this.e.d.I(0,a)
return null}else this.b3().dm(s,!1)},
hn(a){return new v.G.URL(a,"file:///").pathname},
ca(a,b){var s,r,q=this,p=a.a
if(p==null)return q.e.ca(a,b)
s=$.v8().i(0,p)
if(s==null)return q.e.ca(a,b)
r=q.b3()
if(!r.jd(s))if((b&4)!==0){r.c3(s).truncate(0)
r.dm(s,!0)}else throw A.b(B.bX)
return new A.ez(new A.kr(q,s,(b&8)!==0),0)},
hp(a){},
n(){var s=this.d
if(s!=null){s.b.close()
s.c.close()
s.d.close()}this.d=null},
bK(a,b){return this.oz(a,b)},
ox(a){return this.bK(a,!1)},
oz(a,b){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$bK=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:m=new A.on(a,b)
s=2
return A.c(m.$1("meta"),$async$bK)
case 2:l=d
k=J.z(l.getSize(),0)
l.truncate(2)
s=3
return A.c(m.$1("database"),$async$bK)
case 3:p=d
s=4
return A.c(m.$1("journal"),$async$bK)
case 4:o=d
n=q.d=new A.t2(new Uint8Array(2),l,p,o)
if(k){n.dm(B.a4,p.getSize()>0)
n.dm(B.a5,o.getSize()>0)}return A.f(null,r)}})
return A.h($async$bK,r)}}
A.on.prototype={
jX(a){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=t.m
s=3
return A.c(A.aq(p.a.getFileHandle(a,{create:!0}),o),$async$$1)
case 3:n=c
s=4
return A.c(A.aq(p.b?n.createSyncAccessHandle({mode:"readwrite-unsafe"}):n.createSyncAccessHandle(),o),$async$$1)
case 4:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$1(a){return this.jX(a)},
$S:132}
A.kr.prototype={
jD(a,b){return A.wL(this.a.b3().c3(this.b),a,{at:b})},
hl(){return this.d>=2?1:0},
eE(){var s=this.a,r=this.b
s.b3().c3(r).flush()
if(this.c)s.b3().dm(r,!1)},
dB(){return this.a.b3().c3(this.b).getSize()},
ho(a){this.d=a},
hq(a){this.a.b3().c3(this.b).flush()},
dC(a){this.a.b3().c3(this.b).truncate(a)},
hr(a){this.d=a},
cI(a,b){if(A.wM(this.a.b3().c3(this.b),a,{at:b})<a.length)throw A.b(B.bZ)}}
A.t2.prototype={
jd(a){var s=this.a
A.wL(this.b,s,{at:0})
return s[a.a]!==0},
dm(a,b){var s=this.a,r=b?1:0
s.$flags&2&&A.C(s)
s[a.a]=r
A.wM(this.b,s,{at:0})},
c3(a){var s
switch(a.a){case 0:s=this.c
break
case 1:s=this.d
break
default:s=null}return s}}
A.pJ.prototype={
kV(a,b){var s=this,r=s.c
r.a!==$&&A.z4()
r.a=s
r=t.S
A.jY(new A.pK(s),r)
A.jY(new A.pL(s),r)
s.r=A.jY(new A.pM(s),r)
s.w=A.jY(new A.pN(s),r)},
d5(a,b){var s=a.length,r=this.d.dart_sqlite3_malloc(s+b),q=A.b3(this.b.buffer,0,null)
s=r+s
B.f.ai(q,r,s,a)
B.f.fR(q,s,s+b,0)
return r},
fG(a){return this.d5(a,0)},
j8(a,b){var s=b==null?null:b
return this.d.dart_sqlite3_updates(a,s)},
j6(a,b){var s=b==null?null:b
return this.d.dart_sqlite3_commits(a,s)},
j7(a,b){var s=b==null?null:b
return this.d.dart_sqlite3_rollbacks(a,s)}}
A.pK.prototype={
$1(a){return this.a.d.sqlite3changeset_finalize(a)},
$S:7}
A.pL.prototype={
$1(a){return this.a.d.sqlite3session_delete(a)},
$S:7}
A.pM.prototype={
$1(a){return this.a.d.sqlite3_close_v2(a)},
$S:7}
A.pN.prototype={
$1(a){return this.a.d.sqlite3_finalize(a)},
$S:7}
A.dJ.prototype={}
A.nX.prototype={
hA(a){var s,r=this,q=r.a
q.start()
r.c=A.aC(q,"message",new A.o0(r),!1,t.m)
s=a.b
if(a.c==null&&s!=null){q=$.hN()
q.toString
A.fV(q,s,null,null,!1).aQ(new A.o1(r),t.P)}},
fi(a){return this.ly(a)},
ly(a){var s=0,r=A.i(t.H),q=this
var $async$fi=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:A.Ed(a,new A.nY(q),q.gjm(),new A.nZ(q),new A.o_(q))
return A.f(null,r)}})
return A.h($async$fi,r)},
bQ(a,b,c,d){return this.kx(a,b,c,d,d)},
cc(a,b,c){return this.bQ(a,b,null,c)},
kx(a,b,c,d,e){var s=0,r=A.i(e),q,p=this,o,n,m,l
var $async$bQ=A.d(function(f,g){if(f===1)return A.e(g,r)
for(;;)switch(s){case 0:l={}
if((p.b.a.a&30)!==0)throw A.b(A.zX(null))
o=p.e++
n=new A.l($.m,t.a7)
p.f.m(0,o,new A.N(n,t.h1))
a.i=o
p.a.postMessage(a,A.dz(a))
l.a=!1
if(c!=null)c.J(new A.o2(l,p,o))
s=3
return A.c(n,$async$bQ)
case 3:m=g
l.a=!0
if(J.z(m.t,b.b)){q=d.a(m)
s=1
break}else throw A.b(A.B5(m))
case 1:return A.f(q,r)}})
return A.h($async$bQ,r)},
lN(a){var s,r,q=this,p=q.b
if((p.a.a&30)!==0)return
q.a.postMessage("_disconnect")
s=q.c
if(s!=null)s.u()
s=q.d
if(s!=null)s.u()
for(s=q.f,r=new A.bc(s,s.r,s.e);r.l();)r.d.a9(new A.eZ(a))
s.aC(0)
p.N()},
ig(){return this.lN(null)}}
A.o0.prototype={
$1(a){if(a.data=="_disconnect"){this.a.ig()
return}this.a.fi(A.S(a.data))},
$S:2}
A.o1.prototype={
$1(a){this.a.ig()
a.a.N()},
$S:133}
A.o_.prototype={
$1(a){var s=this.a.f.I(0,a.i)
if(s!=null)s.W(a)},
$S:11}
A.nZ.prototype={
$1(a){return this.jW(a)},
jW(a1){var s=0,r=A.i(t.P),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$$1=A.d(function(a2,a3){if(a2===1){p.push(a3)
s=q}for(;;)switch(s){case 0:f=null
e=a1.i
d=n.a
c=d.r
b=v.G
a=new b.AbortController()
c.m(0,e,a)
m=a
q=3
j=d.ng(a1,m.signal)
s=6
return A.c(t.nW.b(j)?j:A.bO(j,t.m),$async$$1)
case 6:f=a3
o.push(5)
s=4
break
case 3:q=2
a0=p.pop()
l=A.H(a0)
k=A.O(a0)
if(!(l instanceof A.bp)){b.console.error("Error in worker: "+J.aU(l))
b.console.error("Original trace: "+A.q(k))}b=l
if(b instanceof A.d6){h=A.Ah(b)
g=0}else{g=b instanceof A.bp?1:null
h=null}f={e:J.aU(b),s:g,r:h,i:e,t:"errorResponse"}
o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
c.I(0,e)
s=o.pop()
break
case 5:c=f
d.a.postMessage(c,A.dz(c))
return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$1,r)},
$S:134}
A.nY.prototype={
$1(a){var s=this.a.r.I(0,a.i)
if(s!=null)s.abort()},
$S:11}
A.o2.prototype={
$0(){if(!this.a.a){var s={i:this.c,t:"abort"}
this.b.a.postMessage(s,A.dz(s))}},
$S:1}
A.eZ.prototype={
j(a){return"Channel to database worker is closed: "+A.q(this.a)},
$iP:1}
A.jR.prototype={}
A.j3.prototype={
kQ(a,b){var s,r=this
r.a.b.a.aQ(new A.o9(r),t.P)
s=r.e
s.a=new A.oa(r)
s.b=new A.ob(r)
r.iE(r.f,new A.oc(r),"notifyCommit")
r.iE(r.r,new A.od(r),"notifyRollback")},
iE(a,b,c){var s=a.b
s.a=new A.o7(this,a,c,b)
s.b=new A.o8(this,a,b)},
aV(a){var s=0,r=A.i(t.X),q,p=this
var $async$aV=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(p.a.bQ({r:a,z:null,i:0,d:p.b,t:"custom"},B.p,null,t.m),$async$aV)
case 3:q=c.r
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aV,r)},
cF(a,b,c){return this.oM(a,b,c,c)},
oM(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f
var $async$cF=A.d(function(e,a0){if(e===1){o.push(a0)
s=p}for(;;)switch(s){case 0:k=m.a
j=m.b
i=t.m
g=A
f=A
s=3
return A.c(k.bQ({i:0,d:j,t:"exclusiveLock"},B.p,b,i),$async$cF)
case 3:h=g.R(f.bR(a0.r))
p=4
s=7
return A.c(a.$1(h),$async$cF)
case 7:l=a0
q=l
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:n=[2]
case 5:p=2
s=8
return A.c(k.cc({z:h,i:0,d:j,t:"releaseLock"},B.p,i),$async$cF)
case 8:s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$cF,r)},
cK(a,b,c,d){return this.kt(a,b,c,d)},
kt(a,b,c,d){var s=0,r=A.i(t.ii),q,p=this,o,n,m,l,k
var $async$cK=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:m=A.vz(c)
l=d==null?null:d
s=3
return A.c(p.a.bQ({s:a,p:m.a,v:m.b,z:l,r:!0,c:b,i:0,d:p.b,t:"runQuery"},B.bo,null,t.m),$async$cK)
case 3:k=f
l=k.x
o=k.y
n=A.B7(k)
n.toString
q=new A.kg(l,o,n)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cK,r)},
$iwG:1}
A.o9.prototype={
$1(a){var s=this.a,r=s.c
if((r.a.a&30)===0){r.N()
s.e.n()
s.r.b.n()
s.f.b.n()}},
$S:9}
A.oa.prototype={
$0(){var s,r=this.a
if(r.d==null){s=r.a.w
r.d=new A.aJ(s,A.p(s).h("aJ<1>")).a_(new A.o5(r))}if((r.c.a.a&30)===0)r.a.cc({a:!0,i:0,d:r.b,t:"updateRequest"},B.p,t.m)},
$S:0}
A.o5.prototype={
$1(a){var s
if(J.z(a.t,"notifyUpdate")){s=this.a
if(J.z(a.d,s.b))s.e.q(0,new A.b4(B.bf[a.k],a.u,a.r))}},
$S:2}
A.ob.prototype={
$0(){var s=this.a,r=s.d
if(r!=null)r.u()
s.d=null
if((s.c.a.a&30)===0)s.a.cc({a:!1,i:0,d:s.b,t:"updateRequest"},B.p,t.m)},
$S:1}
A.oc.prototype={
$1(a){return{a:a,i:0,d:this.a.b,t:"commitRequest"}},
$S:46}
A.od.prototype={
$1(a){return{a:a,i:0,d:this.a.b,t:"rollbackRequest"}},
$S:46}
A.o7.prototype={
$0(){var s,r,q=this,p=q.b
if(p.a==null){s=q.a
r=s.a.w
p.a=new A.aJ(r,A.p(r).h("aJ<1>")).a_(new A.o6(s,q.c,p))}p=q.a
if((p.c.a.a&30)===0)p.a.cc(q.d.$1(!0),B.p,t.m)},
$S:0}
A.o6.prototype={
$1(a){if(J.z(a.t,this.b)&&J.z(a.d,this.a.b))this.c.b.q(0,null)},
$S:2}
A.o8.prototype={
$0(){var s=this.b,r=s.a
if(r!=null)r.u()
s.a=null
s=this.a
if((s.c.a.a&30)===0)s.a.cc(this.c.$1(!1),B.p,t.m)},
$S:1}
A.jE.prototype={
aX(a,b){return this.nT(a,b)},
nT(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$aX=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.x.$1(a.r),$async$aX)
case 3:q={r:d,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aX,r)},
fS(a){this.w.q(0,a)}}
A.mj.prototype={
fJ(a){var s=0,r=A.i(t.kS),q,p=this,o
var $async$fJ=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o={port:a.a,lockName:a.b}
q=A.B2(A.BA(new A.dJ(o.port,o.lockName,null),p.d),0)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$fJ,r)}}
A.mk.prototype={
bo(a){return this.oj(a)},
oj(a){var s=0,r=A.i(t.w),q
var $async$bo=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:q=A.pS(a,null)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bo,r)}}
A.ia.prototype={}
A.m4.prototype={}
A.dg.prototype={}
A.rg.prototype={}
A.io.prototype={
ek(){var s=0,r=A.i(t.H),q=this
var $async$ek=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=!q.c?2:3
break
case 2:s=4
return A.c(q.a.ox(q.b),$async$ek)
case 4:case 3:return A.f(null,r)}})
return A.h($async$ek,r)},
hb(){var s=0,r=A.i(t.H),q=this
var $async$hb=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if(!q.c)q.a.n()
return A.f(null,r)}})
return A.h($async$hb,r)}}
A.mX.prototype={
oQ(a){var s=this.a,r=this.d
if(this.c)return s.transfer(r)
else return s.slice(0,r)},
lK(a){var s,r,q,p=this,o=p.b
for(s=o;s<a;){s*=2
p.b=s}if(p.c)p.a=p.a.transfer(s)
else{r=v.G
q=new r.ArrayBuffer(s)
new r.Uint8Array(q,0,p.b).set(new r.Uint8Array(p.a,0,o))
p.a=q}}}
A.q1.prototype={
$1(a){var s=new A.l($.m,t.D),r=new A.bV(new A.N(s,t.F))
this.a.a=r
this.b.W(r)
return A.wN(s)},
$S:47}
A.q2.prototype={
$2(a,b){var s,r,q
A.S(a)
s=J.z(a.name,"AbortError")
r=this.a.a
if(r!=null){if((r.a.a.a&30)===0){q=this.b
if(q!=null)q.$0()}}else{q=this.c
if(s)q.b5(new A.bp("Operation was cancelled",null),b)
else q.b5(a,b)}return null},
$S:137}
A.bV.prototype={}
A.ic.prototype={
gmW(){if(this.c.a)return!1
return!this.d||this.f!=null},
cg(a){return this.l5(a)},
l5(a){var s=0,r=A.i(t.H),q=1,p=[],o=this,n,m,l,k,j,i
var $async$cg=A.d(function(b,c){if(b===1){p.push(c)
s=q}for(;;)switch(s){case 0:j=$.hN()
j.toString
n=j
m=null
l=null
q=3
s=6
return A.c(A.fV(n,o.a,null,o.glB(),!0),$async$cg)
case 6:m=c
s=7
return A.c(A.fV(n,o.b,a,null,!1),$async$cg)
case 7:l=c
j=o.e
j=j==null?null:j.ek()
s=8
return A.c(j instanceof A.l?j:A.bO(j,t.H),$async$cg)
case 8:o.f=new A.a2(m,l)
q=1
s=5
break
case 3:q=2
i=p.pop()
j=m
if(j!=null)j.a.N()
j=l
if(j!=null)j.a.N()
throw i
s=5
break
case 2:s=1
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$cg,r)},
lC(){this.jH()},
h2(a,b,c){return this.c.ez(new A.mx(this,a,b,c),b,c)},
jH(){return this.c.hk(new A.my(this),t.H)}}
A.mx.prototype={
$0(){var s,r=this,q=r.a
if(!q.d||q.f!=null)return r.b.$0()
s=r.d
return q.cg(r.c).aQ(new A.mw(r.b,s),s)},
$S(){return this.d.h("0/()")}}
A.mw.prototype={
$1(a){return this.a.$0()},
$S(){return this.b.h("0/(~)")}}
A.my.prototype={
$0(){var s,r,q,p=this.a,o=p.f
if(o!=null){s=o.a
r=o.b
q=p.e
if(q!=null)q.hb()
s.a.N()
r.a.N()
p.f=null}},
$S:1}
A.dX.prototype={
ez(a,b,c){return this.oY(a,b,c,c)},
hk(a,b){return this.ez(a,null,b)},
oY(a,b,c,d){var s=0,r=A.i(d),q,p=this,o,n,m,l,k,j
var $async$ez=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:k={}
j=b==null
if(J.z(j?null:b.aborted,!0))throw A.b(B.A)
k.a=!1
o=new A.nO(k,p)
if(!p.a){k.a=p.a=!0
q=A.dP(a,c).J(o)
s=1
break}else{n={}
m=new A.l($.m,c.h("l<0>"))
l=new A.N(m,c.h("N<0>"))
n.a=null
k=new A.nN(k,n,l,a,c)
if(!j)n.a=A.aC(b,"abort",new A.nM(n,p,l,k),!1,t.m)
p.b.eY(k)
q=m.J(o)
s=1
break}case 1:return A.f(q,r)}})
return A.h($async$ez,r)}}
A.nO.prototype={
$0(){var s,r
if(!this.a.a)return
s=this.b
r=s.b
if(!r.gE(0))r.oK().$0()
else s.a=!1},
$S:0}
A.nN.prototype={
$0(){var s,r=this
r.a.a=!0
s=r.b.a
if(s!=null)s.u()
r.c.W(A.dP(r.d,r.e))},
$S:0}
A.nM.prototype={
$1(a){var s,r=this
r.a.a.u()
s=r.c
if((s.a.a&30)===0){r.b.b.I(0,r.d)
s.a9(B.A)}},
$S:2}
A.cR.prototype={
gjL(){var s,r,q,p,o,n=this,m=t.s,l=A.u([],m)
for(s=n.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
B.d.ab(l,A.u([p.a.b,p.b],m))}o={}
o.a=l
o.b=n.b
o.c=n.c
o.d=n.e
o.e=!1
o.f=!1
o.g=n.d
return o}}
A.mI.prototype={
$1(a){if(a!=null)return A.an(a)
return null},
$S:138}
A.oh.prototype={
$1(a){return a},
$S:21}
A.oi.prototype={
$1(a){return a==null?null:a},
$S:140}
A.ft.prototype={
aA(){return"MessageType."+this.b}}
A.og.prototype={
dg(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
ed(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
aX(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
cs(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
ct(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
cr(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
dj(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
df(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
jn(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
dd(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
dh(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
dk(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
di(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
de(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
jk(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
jo(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
jl(a,b){var s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.R(s)
return r},
ng(a,b){var s,r,q=this
switch(a.t){case"open":return q.dg(a,b)
case"connect":return q.ed(a,b)
case"custom":return q.aX(a,b)
case"fileSystemExists":return q.cs(a,b)
case"fileSystemFlush":return q.ct(a,b)
case"fileSystemAccess":return q.cr(a,b)
case"runQuery":return q.dj(a,b)
case"exclusiveLock":return q.df(a,b)
case"releaseLock":return q.jn(a,b)
case"closeDatabase":return q.dd(a,b)
case"openAdditionalConnection":return q.dh(a,b)
case"updateRequest":return q.dk(a,b)
case"rollbackRequest":return q.di(a,b)
case"commitRequest":return q.de(a,b)
case"dedicatedCompatibilityCheck":return q.jk(a,b)
case"sharedCompatibilityCheck":return q.jo(a,b)
case"dedicatedInSharedCompatibilityCheck":return q.jl(a,b)
default:s=A.av(new A.a4(!1,null,null,"Unsupported request "+A.q(a.t)),null)
r=new A.l($.m,t.e)
r.R(s)
return r}}}
A.cj.prototype={
aA(){return"FileSystemImplementation."+this.b}}
A.bw.prototype={
aA(){return"TypeCode."+this.b},
j9(a){var s,r=null,q=r
switch(this.a){case 0:q=A.v(A.K("Unsupported type code",r))
break
case 1:a=A.R(A.bR(a))
q=a
break
case 2:q=t.bJ.a(a).toString()
s=A.BP(q,r)
if(s==null)A.v(A.ak("Could not parse BigInt",q,r))
q=s
break
case 3:A.bR(a)
q=a
break
case 4:A.an(a)
q=a
break
case 5:t.Z.a(a)
q=a
break
case 7:A.aT(a)
q=a
break
case 6:break}return q}}
A.ci.prototype={
iZ(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e="binding parameter",d=a.a,c=d.c
d=d.b
s=c.d
r=s.sqlite3_bind_parameter_count(d)
q=this.a
p=q.length
if(p!==r)throw A.b(A.K("Expected "+A.q(r)+" parameters, got "+A.q(p),null))
a.e=this
for(r=this.c,o=v.G,n=t.Z,m=t.bJ,l=0;l<p;l=i){k=r[l]
j=k>=8?B.w:B.I[k]
i=l+1
h=q[l]
switch(j.a){case 1:k=s.sqlite3_bind_int64(d,i,o.BigInt(A.R(A.bR(h))))
if(k!==0)a.bt(k,e)
break
case 2:k=s.sqlite3_bind_int64(d,i,m.a(h))
if(k!==0)a.bt(k,e)
break
case 3:k=s.sqlite3_bind_double(d,i,A.bR(h))
if(k!==0)a.bt(k,e)
break
case 4:g=B.n.ao(A.an(h))
k=s.dart_sqlite3_bind_text(d,i,c.fG(g),g.length)
if(k!==0)a.bt(k,e)
break
case 5:n.a(h)
k=s.dart_sqlite3_bind_blob(d,i,c.fG(h),h.length)
if(k!==0)a.bt(k,e)
break
case 6:k=s.sqlite3_bind_null(d,i)
if(k!==0)a.bt(k,e)
break
case 7:f=A.aT(h)?1:0
k=s.sqlite3_bind_int64(d,i,o.BigInt(f))
if(k!==0)a.bt(k,e)
break
case 0:throw A.b(A.Q("Unknown type code"))}}},
gk(a){return this.a.length},
sk(a,b){this.iN()},
i(a,b){var s=this.c[b],r=s>=8?B.w:B.I[s]
return r.j9(this.a[b])},
m(a,b,c){this.iN()},
iN(){throw A.b(A.Q("decodeValues list is unmodifiable"))}}
A.uu.prototype={
$1(a){this.b.transaction.abort()
this.a.a=!1},
$S:11}
A.lK.prototype={
$1(a){this.a.W(this.c.a(this.b.result))},
$S:2}
A.lL.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.a9(s)},
$S:2}
A.lO.prototype={
$1(a){this.a.W(this.c.a(this.b.result))},
$S:2}
A.lP.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.a9(s)},
$S:2}
A.lQ.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.a9(s)},
$S:2}
A.nV.prototype={
nx(){var s,r,q,p
for(s=this.b,r=new A.bc(s,s.r,s.e);r.l();){q=r.d
if(!q.r){q.r=!0
if(!q.f){p=q.a
p.c.d.sqlite3_reset(p.b)
q.f=!0}q=q.a
p=q.c
p.d.sqlite3_finalize(q.b)
p=p.w
if(p!=null){p=p.a
if(p!=null)p.unregister(q.d)}}}s.aC(0)}}
A.fc.prototype={
aA(){return"FileType."+this.b}}
A.cs.prototype={
aA(){return"StorageMode."+this.b}}
A.d2.prototype={
j(a){return"Remote error: "+this.a},
$iP:1}
A.bp.prototype={}
A.u2.prototype={
$1(a){return A.S(a.data)},
$S:142}
A.hu.prototype={
u(){var s=this.a
if(s!=null)s.u()
this.a=null}}
A.el.prototype={
n(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q.c.u()
q.d.u()
q.e.u()
for(p=q.w,o=p.length,n=0;n<p.length;p.length===o||(0,A.a6)(p),++n)p[n].abort()
B.d.aC(p)
p=q.f
if(p!=null)p.b.N()
s=2
return A.c(q.a.da(),$async$n)
case 2:return A.f(null,r)}})
return A.h($async$n,r)},
iF(a){var s=new v.G.AbortController()
a.onabort=A.u4(new A.r4(s))
this.w.push(s)
return s},
ey(a,b,c,d){var s,r,q,p=this,o=null
if(a==null){s=p.a.f
if(!s.gmW()){r=p.iF(b)
o=s.h2(c,r.signal,d).J(new A.r8(p,r))}}else{s=p.f
if((s==null?null:s.a)!==a)throw A.b(A.D("Requested operation on inactive lock state."))}if(o==null)o=A.dP(c,d)
q=p.a.z
return q instanceof A.ck?o.J(q.gnL()):o},
ow(a){var s=this,r=s.iF(a),q=new A.l($.m,t.hy),p=new A.ad(q,t.ho),o=t.H
A.ir(s.a.f.h2(new A.r5(s,p),r.signal,o),new A.r6(p),o,t.K)
return q.J(new A.r7(s,r))}}
A.r4.prototype={
$0(){return this.a.abort()},
$S:0}
A.r8.prototype={
$0(){B.d.I(this.a.w,this.b)},
$S:1}
A.r5.prototype={
$0(){var s=this.a,r=s.r++,q=new A.l($.m,t.D)
s.f=new A.a2(r,new A.ad(q,t.h))
this.b.W(r)
return q},
$S:3}
A.r6.prototype={
$2(a,b){var s=this.a
if((s.a.a&30)===0)s.b5(a,b)},
$S:5}
A.r7.prototype={
$0(){B.d.I(this.a.w,this.b)},
$S:1}
A.ek.prototype={
kY(a,b,c){this.b.a.J(new A.qT(this))},
cm(a,b){return this.lx(a,b)},
lx(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$cm=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.w.j2(a),$async$cm)
case 3:q={r:d.gjL(),i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cm,r)},
jk(a,b){return this.cm(a,b)},
jl(a,b){return this.cm(a,b)},
jo(a,b){return this.cm(a,b)},
ed(a,b){return this.nS(a,b)},
nS(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$ed=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=p.w.gia()
n.toString
o={r:a.r,i:0,d:null,t:"connect"}
n.a.postMessage(o,A.dz(o))
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ed,r)},
aX(a,b){return this.nU(a,b)},
nU(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m,l,k
var $async$aX=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:k=a.d
s=k!=null?3:5
break
case 3:o=p.hU(k)
n=a.z
m=a.r
s=7
return A.c(o.a.gbr(),$async$aX)
case 7:s=6
return A.c(d.cq(p,new A.m4(new A.qW(o,n,b),m)),$async$aX)
case 6:l=d
s=4
break
case 5:s=8
return A.c(p.w.b.cq(p,new A.ia(a)),$async$aX)
case 8:l=d
case 4:q={r:l,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aX,r)},
dg(a,b){return this.o0(a,b)},
o0(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$dg=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.w.y.hk(new A.qZ(p,a),t.m),$async$dg)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dg,r)},
dj(a,b){return this.o4(a,b)},
o4(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m
var $async$dj=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
n=o.a
s=3
return A.c(n.gbr(),$async$dj)
case 3:m=d
q=o.ey(a.z,b,new A.r1(m,a,n),t.m)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dj,r)},
df(a,b){return this.nX(a,b)},
nX(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$df=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.aU(a).ow(b),$async$df)
case 3:q={r:d,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$df,r)},
jn(a,b){var s=this.aU(a),r=a.z,q=s.f
if((q==null?null:q.a)!==r)A.v(A.D("Lock to be released is not active."))
q.b.N()
s.f=null
return{r:null,i:a.i,t:"simpleSuccessResponse"}},
de(a,b){return this.nR(a,b)},
nR(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$de=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
n=o.e
s=a.a?3:5
break
case 3:s=6
return A.c(p.cf(n,new A.qV(p,o),a),$async$de)
case 6:q=d
s=1
break
s=4
break
case 5:n.u()
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$de,r)},
di(a,b){return this.o3(a,b)},
o3(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$di=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
n=o.d
s=a.a?3:5
break
case 3:s=6
return A.c(p.cf(n,new A.r0(p,o),a),$async$di)
case 6:q=d
s=1
break
s=4
break
case 5:n.u()
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$di,r)},
dk(a,b){return this.o5(a,b)},
o5(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$dk=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
n=o.c
s=a.a?3:5
break
case 3:s=6
return A.c(p.cf(n,new A.r3(p,o),a),$async$dk)
case 6:q=d
s=1
break
s=4
break
case 5:n.u()
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$dk,r)},
dh(a,b){return this.o1(a,b)},
o1(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m
var $async$dh=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:m=p.aU(a).a;++m.w
s=3
return A.c(A.uv(),$async$dh)
case 3:o=d
n=o.a
p.w.hB(o.b).x.push(A.xF(m,0))
q={r:n,i:a.i,t:"endpointResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dh,r)},
dd(a,b){return this.nQ(a,b)},
nQ(a,b){var s=0,r=A.i(t.m),q,p=this,o
var $async$dd=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
B.d.I(p.x,o)
s=3
return A.c(o.n(),$async$dd)
case 3:q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dd,r)},
ct(a,b){return this.o_(a,b)},
o_(a,b){var s=0,r=A.i(t.m),q,p=this,o
var $async$ct=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.aU(a).a.gbO(),$async$ct)
case 3:o=d
s=o instanceof A.ck?4:5
break
case 4:s=6
return A.c(o.bD(!1),$async$ct)
case 6:case 5:q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ct,r)},
cr(a,b){return this.nY(a,b)},
nY(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m,l,k,j
var $async$cr=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
n=B.a9[a.f]
m=a.b
l=o
k=b
j=A
s=4
return A.c(o.a.gbO(),$async$cr)
case 4:s=3
return A.c(l.ey(null,k,new j.qX(d,n,m,a),t.m),$async$cr)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cr,r)},
cs(a,b){return this.nZ(a,b)},
nZ(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m,l
var $async$cs=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aU(a)
n=o
m=b
l=A
s=4
return A.c(o.a.gbO(),$async$cs)
case 4:s=3
return A.c(n.ey(null,m,new l.qY(d,a),t.y),$async$cs)
case 3:q={r:d,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cs,r)},
cf(a,b,c){return this.kA(a,b,c)},
kA(a,b,c){var s=0,r=A.i(t.m),q,p
var $async$cf=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=a.a==null?3:4
break
case 3:p=a
s=5
return A.c(b.$0(),$async$cf)
case 5:p.a=e
case 4:q={r:null,i:c.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cf,r)},
fS(a){},
aV(a){var s=0,r=A.i(t.X),q,p=this
var $async$aV=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(p.cc({r:a,z:null,i:0,d:null,t:"custom"},B.p,t.m),$async$aV)
case 3:q=c.r
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aV,r)},
hU(a){return B.d.jh(this.x,new A.qS(a))},
aU(a){var s=a.d
if(s!=null)return this.hU(s)
else throw A.b(A.K("Request requires database id",null))},
$iwD:1}
A.qT.prototype={
$0(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=q.a.x,o=p.length,n=0
case 2:if(!(n<p.length)){s=4
break}s=5
return A.c(p[n].n(),$async$$0)
case 5:case 3:p.length===o||(0,A.a6)(p),++n
s=2
break
case 4:B.d.aC(p)
return A.f(null,r)}})
return A.h($async$$0,r)},
$S:3}
A.qW.prototype={
$1$1(a,b){return this.a.ey(this.b,this.c,a,b)},
$1(a){return this.$1$1(a,t.z)},
$S:143}
A.qZ.prototype={
$0(){var s=0,r=A.i(t.m),q,p=2,o=[],n=this,m,l,k,j,i,h,g
var $async$$0=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:j=n.a
i=j.w
h=n.b
s=3
return A.c(i.bo(h.u),$async$$0)
case 3:m=null
l=null
p=5
m=i.nK(h.d,A.Am(h.s),h.c,h.a)
s=8
return A.c(h.o?m.gbO():m.gbr(),$async$$0)
case 8:l=A.xF(m,null)
j.x.push(l)
i={r:m.b,i:h.i,t:"simpleSuccessResponse"}
q=i
s=1
break
p=2
s=7
break
case 5:p=4
g=o.pop()
s=m!=null?9:10
break
case 9:B.d.I(j.x,l)
s=11
return A.c(m.da(),$async$$0)
case 11:case 10:throw g
s=7
break
case 4:s=2
break
case 7:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$0,r)},
$S:144}
A.r1.prototype={
$0(){var s,r,q,p,o,n,m=null,l=this.a.gd8(),k=this.b
if(k.c){s=l.b
s=s.a.d.sqlite3_get_autocommit(s.b)!==0}else s=!1
if(s)throw A.b(A.D("Database is not in a transaction"))
s=k.p
r=k.v
r.toString
q=new A.ci(s,r,A.b3(r,0,m))
s=this.c
r=v.G
p=l.b
o=p.a
p=p.b
if(k.r){n=s.ks(l,k.s,q)
n.i=k.i
k=o.d
n.x=k.sqlite3_get_autocommit(p)!==0
n.y=A.R(r.Number(k.sqlite3_last_insert_rowid(p)))
return n}else{s.nD(l,k.s,q)
s=o.d
return A.yW(s.sqlite3_get_autocommit(p)!==0,m,A.R(r.Number(s.sqlite3_last_insert_rowid(p))),k.i,m,m,m)}},
$S:19}
A.qV.prototype={
$0(){var s=0,r=A.i(t.ey),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.b
s=3
return A.c(o.a.gbr(),$async$$0)
case 3:q=b.gd8().f0().gbz().a_(new A.qU(p.a,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:49}
A.qU.prototype={
$1(a){var s={d:this.b.b,t:"notifyCommit"}
this.a.a.postMessage(s,A.dz(s))},
$S:15}
A.r0.prototype={
$0(){var s=0,r=A.i(t.ey),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.b
s=3
return A.c(o.a.gbr(),$async$$0)
case 3:q=b.gd8().mk().gbz().a_(new A.r_(p.a,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:49}
A.r_.prototype={
$1(a){var s={d:this.b.b,t:"notifyRollback"}
this.a.a.postMessage(s,A.dz(s))},
$S:15}
A.r3.prototype={
$0(){var s=0,r=A.i(t.ha),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.b
s=3
return A.c(o.a.gbr(),$async$$0)
case 3:q=b.gd8().iO().gbz().a_(new A.r2(p.a,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:147}
A.r2.prototype={
$1(a){var s={k:a.a.a,u:a.b,r:a.c,d:this.b.b,t:"notifyUpdate"}
this.a.a.postMessage(s,A.dz(s))},
$S:51}
A.qX.prototype={
$0(){var s,r,q,p=this,o=p.a.ca(new A.fF(A.yl(p.b)),4).a
try{q=p.c
if(q!=null){s=q
o.dC(s.byteLength)
o.cI(A.b3(s,0,null),0)
q={r:null,i:p.d.i,t:"simpleSuccessResponse"}
return q}else{q=o.dB()
r=new Uint8Array(q)
o.eG(r,0)
q={r:t.a.a(J.zL(r)),i:p.d.i,t:"simpleSuccessResponse"}
return q}}finally{o.eE()}},
$S:19}
A.qY.prototype={
$0(){return this.a.eD(A.yl(B.a9[this.b.f]),0)===1},
$S:52}
A.qS.prototype={
$1(a){return a.b===this.a},
$S:150}
A.id.prototype={
gbO(){var s=0,r=A.i(t.e6),q,p=this,o
var $async$gbO=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.y
s=3
return A.c(o==null?p.y=A.dP(new A.mB(p),t.H):o,$async$gbO)
case 3:o=p.z
o.toString
q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$gbO,r)},
gbr(){var s=0,r=A.i(t.u),q,p=this,o
var $async$gbr=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.x
s=3
return A.c(o==null?p.x=A.dP(new A.mA(p),t.u):o,$async$gbr)
case 3:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$gbr,r)},
da(){var s=0,r=A.i(t.H),q=this
var $async$da=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=--q.w===0?2:3
break
case 2:s=4
return A.c(q.n(),$async$da)
case 4:case 3:return A.f(null,r)}})
return A.h($async$da,r)},
n(){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:j=q.a.r
j.toString
s=2
return A.c(j,$async$n)
case 2:p=b
o=q.x
s=o!=null?3:4
break
case 3:s=5
return A.c(o,$async$n)
case 5:n=b
j=q.r
if(j!=null)j.nx()
n.gd8().n()
m=q.z
if(m!=null){j=p.a
l=$.wj()
A.Ak(m)
k=l.a.get(m)
if(k==null)A.v(A.D("vfs has not been registered"))
j.a.d.dart_sqlite3_unregister_vfs(k)}case 4:j=q.Q
j=j==null?null:j.$0()
s=6
return A.c(j instanceof A.l?j:A.bO(j,t.H),$async$n)
case 6:q.f.jH()
return A.f(null,r)}})
return A.h($async$n,r)},
ik(a,b){var s,r,q,p,o=this.r,n=o==null
if(n)s=null
else{r=o.b
q=r.I(0,b)
if(q!=null)r.m(0,b,q)
s=q}if(s!=null)return new A.a2(s,!0)
p=a.jB(b,!0)
if(!n){n=p.a
n=n.c.d.sqlite3_stmt_isexplain(n.b)===0}else n=!1
if(n){n=o.b
if(n.a===o.a)n.I(0,new A.b0(n,A.p(n).h("b0<1>")).gaf(0)).n()
n.m(0,p.d,p)
return new A.a2(p,!0)}return new A.a2(p,!1)},
nD(a,b,c){var s,r,q
if(c.gk(0)===0)return a.aW(b,B.o)
else{s=null
r=null
q=this.ik(a,b)
s=q.a
r=q.b
try{s.nF(new A.f5(c.giY()))}finally{if(r)s.du()
else s.n()}}},
ks(a,b,c){var s,r=null,q=null,p=this.ik(a,b)
r=p.a
q=p.b
try{s=A.B6(r,c)
return s}finally{if(q)r.du()
else r.n()}}}
A.mB.prototype={
$0(){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:l=q.a
k=l.d
case 2:switch(k.a){case 0:s=4
break
case 1:s=5
break
case 2:s=6
break
case 3:s=7
break
case 4:s=8
break
default:s=3
break}break
case 4:s=9
return A.c(A.om("drift_db/"+l.c,"vfs-web-"+l.b),$async$$0)
case 9:p=b
l.z=p
l.Q=p.gaD()
s=3
break
case 5:case 6:s=10
return A.c(A.ip("drift_db/"+l.c,k===B.G,"vfs-web-"+l.b),$async$$0)
case 10:o=b
l.f.e=o
n=o.a
l.z=n
l.Q=n.gaD()
s=3
break
case 7:s=11
return A.c(A.iu(l.c,"vfs-web-"+l.b,!1),$async$$0)
case 11:m=b
l.z=m
l.Q=m.gaD()
s=3
break
case 8:l.z=A.vi("vfs-web-"+l.b,null)
s=3
break
case 3:return A.f(null,r)}})
return A.h($async$$0,r)},
$S:3}
A.mA.prototype={
$0(){var s=0,r=A.i(t.u),q,p=this,o,n,m,l,k
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:l=p.a
k=l.a.r
k.toString
s=3
return A.c(k,$async$$0)
case 3:o=b
s=4
return A.c(l.gbO(),$async$$0)
case 4:n=b
o.jq()
k=o.a
k=k.a
m=k.d.dart_sqlite3_register_vfs(k.d5(B.n.ao(n.a),1),n,0)
if(m===0)A.v(A.D("could not register vfs"))
k=$.wj()
k.a.set(n,m)
s=5
return A.c(l.f.h2(new A.mz(l,o),null,t.u),$async$$0)
case 5:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:53}
A.mz.prototype={
$0(){var s=this.a
return s.a.b.h6(this.b,"/database","vfs-web-"+s.b,s.e)},
$S:53}
A.qf.prototype={
gia(){var s,r=this,q=r.Q
if(q===$){s=r.a.gn0().eL()
r.Q!==$&&A.wh()
r.Q=s
q=s}return q},
cu(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h
var $async$cu=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:h=new A.bQ(A.ba(A.CW(n.a),"stream",t.K))
q=2
j=v.G
case 5:s=7
return A.c(h.l(),$async$cu)
case 7:if(!b){s=6
break}m=h.gp()
s=J.z(m.t,"connect")?8:10
break
case 8:i=m.r
l=new A.dJ(i.port,i.lockName,null)
n.hB(l)
s=9
break
case 10:s=A.Ew(m.t)?11:12
break
case 11:s=13
return A.c(n.j2(m),$async$cu)
case 13:k=b
j.postMessage(k.gjL())
case 12:case 9:s=5
break
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
s=14
return A.c(h.u(),$async$cu)
case 14:s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$cu,r)},
hB(a){var s=this,r=A.BR(a,s.d++,s)
s.c.push(r)
r.b.a.J(new A.qg(s,r))
return r},
j2(a){return this.x.hk(new A.qh(this,a),t.p6)},
bo(a){return this.ol(a)},
ol(a){var s=0,r=A.i(t.H),q=this,p,o,n,m
var $async$bo=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:n=v.G
m=new n.URL(a,A.S(n.location).href).href
n=q.r
s=n!=null?2:4
break
case 2:p=q.w
if(p!==m)throw A.b(A.D("Workers only support a single sqlite3 wasm module, provided different URI (has "+A.q(p)+", got "+m+")"))
s=5
return A.c(t.jN.b(n)?n:A.bO(n,t.he),$async$bo)
case 5:s=3
break
case 4:o=A.ir(q.b.bo(m),new A.qi(q),t.w,t.K)
q.r=o
s=6
return A.c(o,$async$bo)
case 6:q.w=m
case 3:return A.f(null,r)}})
return A.h($async$bo,r)},
nK(a,b,c,d){var s,r,q,p,o,n
for(s=this.e,r=new A.bc(s,s.r,s.e);r.l();){q=r.d
p=q.w
if(p!==0&&q.c===a&&q.d===b){q.w=p+1
return q}}r=this.f++
q="pkg-sqlite3-web-"+a
p=b===B.G||b===B.a3
o=A.nB(t.d)
n=c===0?null:new A.nV(c,A.vp(null,null,t.N,t.fw))
n=new A.id(this,r,a,b,d,new A.ic(q+"-outer",q,new A.dX(o),p),n)
s.m(0,r,n)
return n}}
A.qg.prototype={
$0(){var s=this.a,r=s.c
B.d.I(r,this.b)
if(r.length===0)s.a.n()
return null},
$S:0}
A.qh.prototype={
$0(){var s=0,r=A.i(t.p6),q,p=this,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a
var $async$$0=A.d(function(a0,a1){if(a0===1)return A.e(a1,r)
for(;;)switch(s){case 0:d=p.b
c=d.d
s=J.z(d.t,"dedicatedCompatibilityCheck")||J.z(d.t,"dedicatedInSharedCompatibilityCheck")?3:5
break
case 3:s=6
return A.c(A.cF(),$async$$0)
case 6:o=a1
n=o.a
m=o.b
l=m
k=n
s=4
break
case 5:k=!1
l=!1
case 4:b=J.z(d.t,"dedicatedCompatibilityCheck")||J.z(d.t,"sharedCompatibilityCheck")
if(b){s=7
break}else a1=b
s=8
break
case 7:s=9
return A.c(A.kR(),$async$$0)
case 9:case 8:j=a1
i=A.bs(t.cU)
s=J.z(d.t,"sharedCompatibilityCheck")?10:12
break
case 10:h=p.a.gia()
g=h!=null
s=g?13:14
break
case 13:d={d:c,i:0,t:"dedicatedInSharedCompatibilityCheck"}
f=A.dz(d)
n=h.a
n.postMessage(d,f)
b=A
a=A
s=15
return A.c(new A.ha(n,"message",!1,t.d4).gaf(0),$async$$0)
case 15:e=b.A2(a.S(a1.data))
k=e.c
l=e.d
i.ab(0,e.a)
case 14:s=11
break
case 12:g=!1
case 11:s=k?16:17
break
case 16:b=J
s=18
return A.c(A.eR(),$async$$0)
case 18:d=b.T(a1)
case 19:if(!d.l()){s=20
break}i.q(0,new A.a2(B.ai,d.gp()))
s=19
break
case 20:case 17:s=j&&c!=null?21:22
break
case 21:s=23
return A.c(A.ut(c),$async$$0)
case 23:if(a1)i.q(0,new A.a2(B.aj,c))
case 22:d=A.as(i,i.$ti.c)
q=new A.cR(d,g,k,l,j)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:152}
A.qi.prototype={
$2(a,b){this.a.r=null
throw A.b(a)},
$S:153}
A.rh.prototype={
eL(){var s=v.G
if(!("Worker" in s))return null
return new A.rf(new s.Worker(this.a,{name:"sqlite3_worker"}))}}
A.tG.prototype={}
A.rf.prototype={}
A.iK.prototype={
j(a){return"LockError: "+this.a}}
A.tb.prototype={
bI(a,b,c){return this.op(a,b,c,c)},
op(a,b,c,d){var s=0,r=A.i(d),q,p=this,o
var $async$bI=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:if($.m.i(0,p)!=null)throw A.b(new A.iK("Recursive lock is not allowed"))
o=t.X
q=$.m.ji(A.br([p,!0],o,o)).bs(new A.tg(p,b,a,c),c.h("0/"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bI,r)}}
A.tc.prototype={
$1(a){},
$S:13}
A.tg.prototype={
$0(){return this.kh(this.d)},
kh(a){var s=0,r=A.i(a),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c
var $async$$0=A.d(function(b,a0){if(b===1){o.push(a0)
s=p}for(;;)switch(s){case 0:j={}
i=m.a
h=i.a
g=j.a=!1
f=$.m
e=t.D
d=t.F
c=new A.N(new A.l(f,e),d)
i.a=c.a
p=3
s=h!=null?6:7
break
case 6:l=new A.N(new A.l(f,e),d)
h.aQ(new A.td(j,l),t.P)
f=m.b
if(f!=null)f.J(new A.te(l))
s=8
return A.c(l.a,$async$$0)
case 8:case 7:s=9
return A.c(m.c.$0(),$async$$0)
case 9:f=a0
q=f
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
k=new A.th(i,c)
if(h!=null?!j.a:g)h.aQ(new A.tf(k),t.P).lD()
else k.$0()
s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$0,r)},
$S(){return this.d.h("o<0>()")}}
A.td.prototype={
$1(a){var s
this.a.a=!0
s=this.b
if((s.a.a&30)===0)s.N()},
$S:9}
A.te.prototype={
$0(){var s=this.a
if((s.a.a&30)===0)s.b5(new A.cf("lock"),A.fH())},
$S:1}
A.th.prototype={
$0(){var s=this.a,r=this.b
if(s.a===r.a)s.a=null
r.N()},
$S:0}
A.tf.prototype={
$1(a){this.a.$0()},
$S:9}
A.jg.prototype={}
A.jh.prototype={
oH(a,b){return this.jF(new A.ot(this,a,b),"readTransaction()",null,b)}}
A.ot.prototype={
$1(a){return this.k_(a,this.c)},
k_(a,b){var s=0,r=A.i(b),q,p=this
var $async$$1=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(A.eP(a,p.b,!1,p.c),$async$$1)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S(){return this.c.h("o<0>(aA)")}}
A.cf.prototype={
j(a){return"A call to "+this.a+" has been aborted"},
$iP:1}
A.ju.prototype={
bv(a,b){return this.kj(a,b)},
kj(a,b){var s=0,r=A.i(t.oy),q,p=this,o
var $async$bv=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.av(a,b),$async$bv)
case 3:o=d
q=o.gaf(o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bv,r)},
b_(a,b){return this.ko(a,b)},
ko(a,b){var s=0,r=A.i(t.J),q,p=this,o
var $async$b_=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=A
s=3
return A.c(p.av(a,b),$async$b_)
case 3:q=o.Ay(d)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$b_,r)},
e4(){var s=0,r=A.i(t.H),q=this
var $async$e4=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=2
return A.c(q.bw(),$async$e4)
case 2:if(!b)throw A.b(A.ji(null,null,0,"Dangling transaction detected. If you want to use BEGIN statements manually, COMMIT or ROLLBACK them before returning from writeLock.",null,null,null))
return A.f(null,r)}})
return A.h($async$e4,r)},
$iaA:1}
A.fC.prototype={
cQ(){if(this.c)A.v(A.D("This context to a callback is no longer open. Make sure to await all statements on a database to avoid a context still being used after its callback has finished."))
if(this.b)throw A.b(A.D("The context from the callback was locked, e.g. due to a nested transaction."))},
bv(a,b){return this.ki(a,b)},
ki(a,b){var s=0,r=A.i(t.oy),q,p=this
var $async$bv=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cQ()
q=p.a.bv(a,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bv,r)},
av(a,b){return this.kk(a,b)},
eI(a){return this.av(a,B.o)},
kk(a,b){var s=0,r=A.i(t.G),q,p=this
var $async$av=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cQ()
s=3
return A.c(p.a.av(a,b),$async$av)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$av,r)},
b_(a,b){return this.kn(a,b)},
kn(a,b){var s=0,r=A.i(t.J),q,p=this
var $async$b_=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cQ()
q=p.a.b_(a,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$b_,r)},
$iaA:1}
A.fD.prototype={
aW(a,b){return this.nE(a,b)},
jc(a){return this.aW(a,B.o)},
nE(a,b){var s=0,r=A.i(t.G),q,p=this
var $async$aW=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cQ()
s=3
return A.c(p.a.aW(a,b),$async$aW)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aW,r)},
aZ(a,b){return this.p6(a,b,b)},
p6(a2,a3,a4){var s=0,r=A.i(a4),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
var $async$aZ=A.d(function(a5,a6){if(a5===1){o.push(a6)
s=p}for(;;)switch(s){case 0:m.cQ()
l=null
k=null
j=null
f=m.d
e=A.Ba(f)
l=e.a
k=e.b
j=e.c
i=null
d=m.a
if(f===0){c=new A.cc(d.a,d.b,null)
c.d=!0}else c=d
h=c
p=4
m.b=!0
s=7
return A.c(d.aW(l,B.o),$async$aZ)
case 7:i=new A.fD(f+1,h)
s=8
return A.c(a2.$1(i),$async$aZ)
case 8:g=a6
s=9
return A.c(h.aW(k,B.o),$async$aZ)
case 9:q=g
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:p=3
a0=o.pop()
p=11
s=14
return A.c(h.aW(j,B.o),$async$aZ)
case 14:p=3
s=13
break
case 11:p=10
a1=o.pop()
s=13
break
case 10:s=3
break
case 13:throw a0
n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
m.b=!1
f=i
if(f!=null)f.c=!0
s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$aZ,r)},
$iaI:1}
A.jf.prototype={
jF(a,b,c,d){return this.mK(a,null,b,d)},
jE(a,b,c){return this.jF(a,b,null,c)},
av(a,b){return this.jE(new A.or(a,b),"getAll()",t.G)},
b_(a,b){return this.jE(new A.os(a,b),"getOptional()",t.J)},
km(a){return this.b_(a,B.o)},
$iaA:1,
$iaI:1}
A.or.prototype={
$1(a){return this.jY(a)},
jY(a){var s=0,r=A.i(t.G),q,p=this
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:q=a.av(p.a,p.b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:154}
A.os.prototype={
$1(a){return this.jZ(a)},
jZ(a){var s=0,r=A.i(t.J),q,p=this
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:q=a.b_(p.a,p.b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:155}
A.ac.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.ac&&B.aL.aM(b.a,this.a)},
gv(a){return A.AT(this.a)},
j(a){return"UpdateNotification<"+this.a.j(0)+">"},
cH(a){return new A.ac(this.a.cH(a.a))},
fK(a){var s
for(s=this.a,s=s.gA(s);s.l();)if(a.S(0,s.gp().toLowerCase()))return!0
return!1}}
A.pC.prototype={
$2(a,b){return a.cH(b)},
$S:156}
A.pB.prototype={
$1(a){return new A.dv(new A.pA(this.a),a,A.p(a).h("dv<G.T>"))},
$S:157}
A.pA.prototype={
$1(a){return a.fK(this.a)},
$S:158}
A.uj.prototype={
$1(a){var s,r,q,p,o=this,n={}
n.a=n.b=null
n.c=!1
s=new A.uk(n,a)
r=A.xE()
q=new A.ul(n,a,s,r)
r.b=new A.uf(n,o.a,q)
p=o.c.aq(new A.um(n,o.b,q,o.f),new A.un(s,a),new A.uo(s,a))
a.e=new A.ug(n)
a.f=new A.uh(n,r,q)
a.r=new A.ui(n,p)
a.q(0,o.d)
r.dQ().$0()},
$S(){return this.f.h("~(bY<0>)")}}
A.uk.prototype={
$0(){var s,r=this.a,q=r.b
if(q!=null){r.b=null
this.b.mS(q)
s=r.a
if(s!=null)s.u()
r.a=null
return!0}else return!1},
$S:52}
A.ul.prototype={
$0(){var s,r,q=this,p=q.a
if(p.a==null){s=q.b
r=s.b
s=!((r&1)!==0?(s.ga5().e&4)!==0:(r&2)===0)}else s=!1
if(s)if(q.c.$0()){s=q.b
r=s.b
if((r&1)!==0?(s.ga5().e&4)!==0:(r&2)===0)p.c=!0
else q.d.dQ().$0()}},
$S:0}
A.uf.prototype={
$0(){var s=this.a
s.a=A.pr(this.b,new A.ue(s,this.c))},
$S:0}
A.ue.prototype={
$0(){this.a.a=null
this.b.$0()},
$S:0}
A.um.prototype={
$1(a){var s,r=this.a,q=r.b
A:{if(q==null){s=a
break A}s=this.b.$2(q,a)
break A}r.b=s
this.c.$0()},
$S(){return this.d.h("~(0)")}}
A.uo.prototype={
$2(a,b){this.a.$0()
this.b.mP(a,b)},
$S:4}
A.un.prototype={
$0(){this.a.$0()
this.b.j3()},
$S:0}
A.ug.prototype={
$0(){var s=this.a,r=s.a,q=r==null
s.c=!q
if(!q)r.u()
s.a=null},
$S:0}
A.uh.prototype={
$0(){if(this.a.c)this.b.dQ().$0()
else this.c.$0()},
$S:0}
A.ui.prototype={
$0(){var s=0,r=A.i(t.H),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.a.a
if(o!=null)o.u()
q=p.b.u()
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:3}
A.pq.prototype={
$0(){this.a.pP()},
$S:1}
A.po.prototype={
$1(a){this.a.q(0,a.b)},
$S:51}
A.pl.prototype={
$0(){var s,r,q,p,o,n,m,l,k,j,i
for(s=this.a,r=s.length,q=this.b,p=t.N,o=0;o<s.length;s.length===r||(0,A.a6)(s),++o){n=s[o]
n.b.ab(0,q)
m=n.a
l=m.b
k=(l&1)!==0
if(!(k?(m.ga5().e&4)!==0:(l&2)===0)){j=n.b
if(j.a!==0){if(l>=4)A.v(m.al())
if(k)m.am(j)
else if((l&3)===0){m=m.bW()
j=new A.bx(j)
i=m.c
if(i==null)m.b=m.c=j
else{i.sbp(j)
m.c=j}}n.b=A.bs(p)}}}q.aC(0)},
$S:0}
A.pm.prototype={
$0(){this.a.aC(0)},
$S:0}
A.pi.prototype={
$1(a){var s,r,q=this,p=q.b
p.push(a)
if(p.length===1){p=q.c
s=p.iO()
r=s.w
s=r==null?s.w=s.i4(!0):r
q.a.a=A.u([s.a_(q.d),p.f0().gbz().a_(new A.pj(q.e)),p.f0().gbz().a_(new A.pk(q.f))],t.bO)}},
$S:54}
A.pj.prototype={
$1(a){return this.a.$0()},
$S:15}
A.pk.prototype={
$1(a){return this.a.$0()},
$S:15}
A.pp.prototype={
$1(a){var s,r,q=this.b
B.d.I(q,a)
if(q.length===0)for(q=this.a.a,s=q.length,r=0;r<q.length;q.length===s||(0,A.a6)(q),++r)q[r].u()},
$S:54}
A.pn.prototype={
$1(a){var s=new A.dt(a,A.bs(t.N))
this.a.$1(s)
a.f=s.gmQ()
a.r=new A.ph(this.b,s)},
$S:160}
A.ph.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
A.dt.prototype={
mR(){var s=this.b
if(s.a!==0){this.a.q(0,s)
this.b=A.bs(t.N)}}}
A.jB.prototype={
bw(){var s=0,r=A.i(t.y),q,p=this,o,n
var $async$bw=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=A
s=3
return A.c(p.a.aV({rawKind:"getAutoCommit"}),$async$bw)
case 3:o=n.vV(b)
if(o==null)o=null
q=o===!0
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bw,r)},
mK(a,b,c,d){return this.bY(new A.pY(a,d),b,c,d)},
aZ(a,b){return this.lL(new A.q0(a,b),null,b)},
dZ(a,b,c,d){return this.mM(a,b,c,d,d)},
mL(a,b,c){return this.dZ(a,b,null,c)},
mM(a,b,c,d,e){var s=0,r=A.i(e),q,p=this
var $async$dZ=A.d(function(f,g){if(f===1)return A.e(g,r)
for(;;)switch(s){case 0:s=3
return A.c(p.bY(new A.pZ(a,d),b,c,d),$async$dZ)
case 3:q=g
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dZ,r)},
bY(a,b,c,d){return this.lM(a,b,c,d,d)},
lL(a,b,c){return this.bY(a,b,null,c)},
lM(a,b,c,d,e){var s=0,r=A.i(e),q,p=this,o,n
var $async$bY=A.d(function(f,g){if(f===1)return A.e(g,r)
for(;;)switch(s){case 0:n=p.b
s=n!=null?3:5
break
case 3:s=6
return A.c(n.bI(new A.pW(p,a,d),b,d),$async$bY)
case 6:q=g
s=1
break
s=4
break
case 5:o=p.a.cF(new A.pX(p,a,d),b,d)
s=7
return A.c(A.CX(o,c==null?"lock":c,d),$async$bY)
case 7:q=g
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$bY,r)},
$ivC:1}
A.pY.prototype={
$1(a){return A.oj(a,this.a,this.b)},
$S(){return this.b.h("o<0>(cc)")}}
A.q0.prototype={
$1(a){var s=this.b
return A.fE(a,new A.q_(this.a,s),s)},
$S(){return this.b.h("o<0>(cc)")}}
A.q_.prototype={
$1(a){return this.kb(a,this.b)},
kb(a,b){var s=0,r=A.i(b),q,p=this
var $async$$1=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(a.aZ(p.a,p.b),$async$$1)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S(){return this.b.h("o<0>(aI)")}}
A.pZ.prototype={
$1(a){return A.fE(a,this.a,this.b)},
$S(){return this.b.h("o<0>(cc)")}}
A.pW.prototype={
$0(){return this.ka(this.c)},
ka(a){var s=0,r=A.i(a),q,p=this
var $async$$0=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.c(p.b.$1(new A.cc(p.a,null,null)),$async$$0)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S(){return this.c.h("o<0>()")}}
A.pX.prototype={
$1(a){return this.k9(a,this.c)},
k9(a,b){var s=0,r=A.i(b),q,p=this
var $async$$1=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.c(p.b.$1(new A.cc(p.a,a,null)),$async$$1)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S(){return this.c.h("o<0>(a)")}}
A.cc.prototype={
av(a,b){return this.kl(a,b)},
kl(a,b){var s=0,r=A.i(t.G),q,p=this
var $async$av=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:q=A.xq(p.c,"getAll",new A.tA(p,a,b),b,a,t.G)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$av,r)},
bw(){var s=0,r=A.i(t.y),q,p=this
var $async$bw=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q=p.a.bw()
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bw,r)},
aW(a,b){return A.xq(this.c,"execute",new A.ty(this,a,b),b,a,t.G)}}
A.tA.prototype={
$0(){var s=0,r=A.i(t.G),q,p=this
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=3
return A.c(A.kV(new A.tz(p.a,p.b,p.c),t.G),$async$$0)
case 3:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:17}
A.tz.prototype={
$0(){var s=0,r=A.i(t.G),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.a
s=3
return A.c(o.a.a.cK(p.b,o.d,p.c,o.b),$async$$0)
case 3:q=b.c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:17}
A.ty.prototype={
$0(){return A.kV(new A.tx(this.a,this.b,this.c),t.G)},
$S:17}
A.tx.prototype={
$0(){var s=0,r=A.i(t.G),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.a
s=3
return A.c(o.a.a.cK(p.b,o.d,p.c,o.b),$async$$0)
case 3:q=b.c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:17}
A.u3.prototype={
$2(a,b){return A.ik(new A.cf(this.a),b)},
$S:162}
A.ch.prototype={
aA(){return"CustomDatabaseMessageKind."+this.b}}
A.jv.prototype={
fT(a){var s=0,r=A.i(t.X),q,p=this,o,n
var $async$fT=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:A.S(a)
if(A.ih(B.a8,a.rawKind)===B.E){o=a.rawParameters
o=B.d.b6(o,new A.px(),t.N).ew(0)
n=p.b.i(0,a.rawSql)
if(n!=null)n.q(0,new A.ac(o))}q=null
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$fT,r)},
oV(a){var s=null,r=B.b.j(this.a++),q=A.bK(s,s,s,s,!1,t.en)
this.b.m(0,r,q)
q.d=new A.py(a,r)
q.r=new A.pz(this,a,r)
return new A.a5(q,A.p(q).h("a5<1>"))}}
A.px.prototype={
$1(a){return A.an(a)},
$S:35}
A.py.prototype={
$0(){this.a.aV(A.ve(B.D,this.b,[!0]))},
$S:0}
A.pz.prototype={
$0(){var s=this.c
this.b.aV(A.ve(B.D,s,[!1]))
this.a.b.I(0,s)},
$S:1}
A.q3.prototype={
bI(a,b,c){if("locks" in v.G.navigator)return this.d4(a,b,c)
else return this.a.bI(a,b,c)},
oo(a,b){return this.bI(a,null,b)},
d4(a,b,c){return this.mD(a,b,c,c)},
mD(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m=this,l,k
var $async$d4=A.d(function(e,f){if(e===1){o.push(f)
s=p}for(;;)switch(s){case 0:s=3
return A.c(m.lw(b),$async$d4)
case 3:k=f
p=4
s=7
return A.c(a.$0(),$async$d4)
case 7:l=f
q=l
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:n=[2]
case 5:p=2
k.a.N()
s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$d4,r)},
lw(a){var s,r=new A.l($.m,t.nI),q=new A.N(r,t.aP),p=v.G,o=new p.AbortController()
if(a!=null)a.J(new A.q5(this,q,o))
s={}
s.signal=o.signal
A.aq(p.navigator.locks.request(this.b,s,A.bB(new A.q7(q))),t.X).j1(new A.q6())
return r}}
A.q5.prototype={
$0(){var s=this.b
if((s.a.a&30)===0){s.a9(new A.cf("getWebLock("+this.a.b+")"))
this.c.abort("aborted in Dart")}},
$S:1}
A.q7.prototype={
$1(a){var s=new A.l($.m,t.D),r=new A.N(s,t.F),q=this.a
if((q.a.a&30)===0)q.W(new A.ff(r))
else r.N()
return A.wN(s)},
$S:47}
A.q6.prototype={
$1(a){return null},
$S:14}
A.ff.prototype={}
A.l9.prototype={
h6(a,b,c,d){return this.oA(a,b,c,d)},
oA(a,b,c,d){var s=0,r=A.i(t.u),q,p,o
var $async$h6=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:p=d==null?null:A.S(d)
o=a.oy(b,p!=null&&p.useMultipleCiphersVfs?"multipleciphers-"+c:c)
q=new A.hX(o,A.Bn(o),A.Z(t.eg,t.fK))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$h6,r)},
cq(a,b){throw A.b(A.vA(null))}}
A.hX.prototype={
ma(a,b){if(!a.a){a.a=!0
b.b.a.aQ(new A.la(a),t.P)}},
cq(a,b){return this.nV(a,b)},
nV(a,b){var s=0,r=A.i(t.X),q,p=this,o,n,m,l,k
var $async$cq=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:k=A.S(b.a)
case 3:switch(A.ih(B.a8,k.rawKind).a){case 0:s=5
break
case 4:s=6
break
case 1:s=7
break
case 2:s=8
break
case 3:s=9
break
default:s=4
break}break
case 5:case 6:throw A.b(A.Q("This is a response, not a request"))
case 7:o=p.a.b
q=o.a.d.sqlite3_get_autocommit(o.b)!==0
s=1
break
case 8:s=10
return A.c(b.c.$1$1(new A.lb(p,k),t.P),$async$cq)
case 10:s=4
break
case 9:o=k.rawParameters
n=A.aT(o[0])
o=k.rawSql
m=p.c.cD(a,A.EU())
if(n){m.hg()
p.ma(m,a)
l=A.xE()
l.b=m.b=p.b.a_(new A.lc(l,a,o))}else m.hg()
s=4
break
case 4:q={rawKind:"ok"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cq,r)},
gd8(){return this.a}}
A.la.prototype={
$1(a){this.a.hg()},
$S:9}
A.lb.prototype={
$0(){var s,r,q,p,o,n,m,l=null,k=this.b
if(k.requireTransaction){q=this.a.a.b
q=q.a.d.sqlite3_get_autocommit(q.b)!==0}else q=!1
if(q)throw A.b(A.ji(A.AE(A.uC(k,"rawSql")),l,0,"Transaction rolled back by earlier statement. Cannot execute",l,l,l))
s=this.a.a.oF(k.rawSql)
try{k=k.parameters
k=J.T(t.ip.b(k)?k:new A.al(k,A.a8(k).h("al<1,x>")))
while(k.l()){r=k.gp()
q=s
p=r
o=p.parameters
p=p.parameterTypes
p.toString
n=new Uint8Array(p,0)
if(q.r||q.b.r)A.v(A.D(u.f))
if(!q.f){m=q.a
m.c.d.sqlite3_reset(m.b)
q.f=!0}q.hG(new A.f5(new A.ci(o,p,n).giY()))
q.i_()}}finally{s.n()}},
$S:1}
A.lc.prototype={
$1(a){this.a.dQ().aG(this.b.aV(A.ve(B.E,this.c,a.ev(0))))},
$S:164}
A.em.prototype={
hg(){var s=this.b
if(s!=null){this.b=null
s.u()}}}
A.jm.prototype={
gdH(){return A.an(this.c)}}
A.p2.prototype={
gh1(){var s=this
if(s.c!==s.e)s.d=null
return s.d},
eK(a){var s,r=this,q=r.d=J.zO(a,r.b,r.c)
r.e=r.c
s=q!=null
if(s)r.e=r.c=q.gC()
return s},
je(a,b){var s
if(this.eK(a))return
if(b==null)if(a instanceof A.fj)b="/"+a.a+"/"
else{s=J.aU(a)
s=A.hL(s,"\\","\\\\")
b='"'+A.hL(s,'"','\\"')+'"'}this.i0(b)},
dc(a){return this.je(a,null)},
nG(){if(this.c===this.b.length)return
this.i0("no more input")},
nC(a,b,c){var s,r,q,p,o,n=this.b
if(c<0)A.v(A.ay("position must be greater than or equal to 0."))
else if(c>n.length)A.v(A.ay("position must be less than or equal to the string length."))
s=c+b>n.length
if(s)A.v(A.ay("position plus length must not go beyond the end of the string."))
s=this.a
r=A.u([0],t.t)
q=n.length
p=new A.oo(s,r,new Uint32Array(q))
p.kR(new A.bq(n),s)
o=c+b
if(o>q)A.v(A.ay("End "+o+u.D+p.gk(0)+"."))
else if(c<0)A.v(A.ay("Start may not be negative, was "+c+"."))
throw A.b(new A.jm(n,a,new A.er(p,c,o)))},
i0(a){this.nC("expected "+a+".",0,this.c)}}
A.eb.prototype={
gk(a){return this.b},
i(a,b){if(b>=this.b)throw A.b(A.wQ(b,this))
return this.a[b]},
m(a,b,c){var s
if(b>=this.b)throw A.b(A.wQ(b,this))
s=this.a
s.$flags&2&&A.C(s)
s[b]=c},
sk(a,b){var s,r,q,p,o=this,n=o.b
if(b<n)for(s=o.a,r=s.$flags|0,q=b;q<n;++q){r&2&&A.C(s)
s[q]=0}else{n=o.a.length
if(b>n){if(n===0)p=new Uint8Array(b)
else p=o.f3(b)
B.f.ai(p,0,o.b,o.a)
o.a=p}}o.b=b},
mz(a){var s,r=this,q=r.b
if(q===r.a.length)r.i8(q)
q=r.a
s=r.b++
q.$flags&2&&A.C(q)
q[s]=a},
q(a,b){var s,r=this,q=r.b
if(q===r.a.length)r.i8(q)
q=r.a
s=r.b++
q.$flags&2&&A.C(q)
q[s]=b},
hC(a,b,c){var s,r,q
if(t.j.b(a))c=c==null?J.aE(a):c
if(c!=null){this.lF(this.b,a,b,c)
return}for(s=J.T(a),r=0;s.l();){q=s.gp()
if(r>=b)this.mz(q);++r}if(r<b)throw A.b(A.D("Too few elements"))},
lF(a,b,c,d){var s,r,q,p,o=this
if(t.j.b(b)){s=J.a3(b)
if(c>s.gk(b)||d>s.gk(b))throw A.b(A.D("Too few elements"))}r=d-c
q=o.b+r
o.lq(q)
s=o.a
p=a+r
B.f.O(s,p,o.b+r,s,a)
B.f.O(o.a,a,p,b,c)
o.b=q},
lq(a){var s,r=this
if(a<=r.a.length)return
s=r.f3(a)
B.f.ai(s,0,r.b,r.a)
r.a=s},
f3(a){var s=this.a.length*2
if(a!=null&&s<a)s=a
else if(s<8)s=8
return new Uint8Array(s)},
i8(a){var s=this.f3(null)
B.f.ai(s,0,a,this.a)
this.a=s},
O(a,b,c,d,e){var s=this.b
if(c>s)throw A.b(A.ab(c,0,s,null,null))
s=this.a
if(d instanceof A.bf)B.f.O(s,b,c,d.a,e)
else B.f.O(s,b,c,d,e)},
ai(a,b,c,d){return this.O(0,b,c,d,0)}}
A.k2.prototype={}
A.bf.prototype={}
A.vf.prototype={}
A.ha.prototype={
gap(){return!0},
B(a,b,c,d){return A.aC(this.a,this.b,a,!1,this.$ti.c)},
a_(a){return this.B(a,null,null,null)},
aq(a,b,c){return this.B(a,null,b,c)},
bn(a,b,c){return this.B(a,b,c,null)}}
A.eq.prototype={
u(){var s=this,r=A.mS(null,t.H)
if(s.b==null)return r
s.fA()
s.d=s.b=null
return r},
bq(a){var s,r=this
if(r.b==null)throw A.b(A.D("Subscription has been canceled."))
r.fA()
s=A.yH(new A.rn(a),t.m)
s=s==null?null:A.bB(s)
r.d=s
r.fw()},
dq(a){},
aG(a){var s=this
if(s.b==null)return;++s.a
s.fA()
if(a!=null)a.J(s.gbM())},
ah(){return this.aG(null)},
aj(){var s=this
if(s.b==null||s.a<=0)return;--s.a
s.fw()},
fw(){var s=this,r=s.d
if(r!=null&&s.a<=0)s.b.addEventListener(s.c,r,!1)},
fA(){var s=this.d
if(s!=null)this.b.removeEventListener(this.c,s,!1)},
$iah:1}
A.rm.prototype={
$1(a){return this.a.$1(a)},
$S:2}
A.rn.prototype={
$1(a){return this.a.$1(a)},
$S:2};(function aliases(){var s=J.cm.prototype
s.kF=s.j
s=A.b_.prototype
s.kB=s.jr
s.kC=s.js
s.kE=s.ju
s.kD=s.jt
s=A.c8.prototype
s.kJ=s.bT
s=A.au.prototype
s.bS=s.M
s.eN=s.a8
s.hy=s.Y
s=A.ca.prototype
s.kK=s.hQ
s.kL=s.i5
s.kM=s.iC
s=A.A.prototype
s.hx=s.O
s=A.af.prototype
s.hw=s.bg
s=A.hv.prototype
s.kN=s.n
s=A.i_.prototype
s.hv=s.nJ
s=A.e7.prototype
s.kH=s.Z
s.kG=s.D
s=A.ac.prototype
s.kI=s.fK})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._instance_0u,q=hunkHelpers._instance_1u,p=hunkHelpers.installInstanceTearOff,o=hunkHelpers._static_1,n=hunkHelpers._static_0,m=hunkHelpers.installStaticTearOff,l=hunkHelpers._instance_2u,k=hunkHelpers._instance_1i
s(J,"D4","AB",31)
var j
r(j=A.dG.prototype,"ge3","u",20)
q(j,"gl3","l4",6)
p(j,"gen",0,0,null,["$1","$0"],["aG","ah"],50,0,0)
r(j,"gbM","aj",0)
o(A,"DL","BE",10)
o(A,"DM","BF",10)
o(A,"DN","BG",10)
o(A,"DO","Dk",16)
n(A,"yJ","DC",0)
o(A,"DP","Dl",13)
s(A,"DQ","Dn",4)
n(A,"ur","Dm",0)
m(A,"DU",5,null,["$5"],["Dv"],166,0)
m(A,"DZ",4,null,["$1$4","$4"],["ub",function(a,b,c,d){return A.ub(a,b,c,d,t.z)}],167,0)
m(A,"E0",5,null,["$2$5","$5"],["uc",function(a,b,c,d,e){var i=t.z
return A.uc(a,b,c,d,e,i,i)}],168,0)
m(A,"E_",6,null,["$3$6"],["w4"],169,0)
m(A,"DX",4,null,["$1$4","$4"],["yy",function(a,b,c,d){return A.yy(a,b,c,d,t.z)}],170,0)
m(A,"DY",4,null,["$2$4","$4"],["yz",function(a,b,c,d){var i=t.z
return A.yz(a,b,c,d,i,i)}],171,0)
m(A,"DW",4,null,["$3$4","$4"],["yx",function(a,b,c,d){var i=t.z
return A.yx(a,b,c,d,i,i,i)}],172,0)
m(A,"DS",5,null,["$5"],["Du"],173,0)
m(A,"E1",4,null,["$4"],["ud"],174,0)
m(A,"DR",5,null,["$5"],["Dt"],175,0)
m(A,"FU",5,null,["$5"],["Ds"],176,0)
m(A,"DV",4,null,["$4"],["Dw"],177,0)
m(A,"DT",5,null,["$5"],["yw"],178,0)
r(j=A.di.prototype,"gcW","b0",0)
r(j,"gcX","b1",0)
r(j=A.c8.prototype,"gaD","n",3)
q(j,"geQ","M",6)
l(j,"gdK","a8",4)
r(j,"geW","Y",0)
p(A.dj.prototype,"gn_",0,1,null,["$2","$1"],["b5","a9"],44,0,0)
l(A.l.prototype,"gf1","le",4)
k(j=A.cz.prototype,"ge_","q",6)
p(j,"gfE",0,1,null,["$2","$1"],["ae","mO"],44,0,0)
r(j,"gaD","n",20)
q(j,"geQ","M",6)
l(j,"gdK","a8",4)
r(j,"geW","Y",0)
r(j=A.cx.prototype,"gcW","b0",0)
r(j,"gcX","b1",0)
p(j=A.au.prototype,"gen",0,0,null,["$1","$0"],["aG","ah"],41,0,0)
r(j,"gbM","aj",0)
r(j,"ge3","u",20)
r(j,"gcW","b0",0)
r(j,"gcX","b1",0)
p(j=A.ep.prototype,"gen",0,0,null,["$1","$0"],["aG","ah"],41,0,0)
r(j,"gbM","aj",0)
r(j,"ge3","u",20)
r(j,"gii","m_",0)
q(j=A.bQ.prototype,"glS","lT",6)
l(j,"glW","lX",4)
r(j,"glU","lV",0)
r(j=A.es.prototype,"gcW","b0",0)
r(j,"gcX","b1",0)
q(j,"gfc","fd",6)
l(j,"gfg","fh",108)
r(j,"gfe","ff",0)
r(j=A.eA.prototype,"gcW","b0",0)
r(j,"gcX","b1",0)
q(j,"gfc","fd",6)
l(j,"gfg","fh",4)
r(j,"gfe","ff",0)
s(A,"w7","CS",29)
o(A,"w8","CT",25)
s(A,"E5","AI",31)
o(A,"E8","CU",45)
o(A,"E7","C5",179)
k(j=A.jP.prototype,"ge_","q",6)
r(j,"gaD","n",0)
o(A,"yM","En",25)
s(A,"yL","Em",29)
o(A,"E9","Bw",21)
m(A,"EC",2,null,["$1$2","$2"],["yU",function(a,b){return A.yU(a,b,t.q)}],180,0)
r(j=A.fI.prototype,"glY","lZ",0)
r(j,"gmv","mw",0)
r(j,"gmx","my",0)
r(j,"gmu","iG",39)
l(j=A.f6.prototype,"gnB","aM",29)
q(j,"go6","c4",25)
q(j,"goc","od",16)
o(A,"E3","zW",21)
o(A,"Et","Av",181)
o(A,"EN","BQ",182)
o(A,"EO","B1",183)
r(A.kk.prototype,"gnH","jf",0)
r(A.cg.prototype,"got","h3",0)
r(j=A.jD.prototype,"gn3","e6",85)
r(j,"goW","ex",3)
r(j,"gaD","n",3)
q(j=A.ib.prototype,"gor","os",7)
l(j,"gom","on",105)
p(j,"gpq",0,5,null,["$5"],["pr"],106,0,0)
p(j,"gpf",0,3,null,["$3"],["pg"],107,0,0)
p(j,"gp7",0,4,null,["$4"],["p8"],37,0,0)
p(j,"gpm",0,4,null,["$4"],["pn"],37,0,0)
p(j,"gps",0,3,null,["$3"],["pt"],109,0,0)
l(j,"gpx","py",38)
l(j,"gpd","pe",38)
q(j,"gpb","pc",27)
p(j,"gpu",0,4,null,["$4"],["pv"],40,0,0)
p(j,"gpF",0,4,null,["$4"],["pG"],40,0,0)
l(j,"gpB","pC",113)
l(j,"gpz","pA",12)
l(j,"gpk","pl",12)
l(j,"gpo","pp",12)
l(j,"gpD","pE",12)
l(j,"gp9","pa",12)
q(j,"geF","ph",27)
p(j,"gpi",0,3,null,["$3"],["pj"],115,0,0)
q(j,"geH","pw",27)
q(j,"gnj","nk",10)
q(j,"gne","nf",116)
p(j,"gnh",0,5,null,["$5"],["ni"],117,0,0)
p(j,"gnp",0,4,null,["$4"],["nq"],28,0,0)
p(j,"gnt",0,4,null,["$4"],["nu"],28,0,0)
p(j,"gnr",0,4,null,["$4"],["ns"],28,0,0)
l(j,"gnv","nw",55)
l(j,"gnn","no",55)
p(j,"gnl",0,5,null,["$5"],["nm"],120,0,0)
l(j,"gnc","nd",121)
l(j,"gna","nb",184)
p(j,"gn8",0,3,null,["$3"],["n9"],123,0,0)
r(j=A.ck.prototype,"gaD","n",3)
r(j,"gnL","nM",3)
r(A.e5.prototype,"gaD","n",0)
q(A.jE.prototype,"gjm","fS",2)
r(A.ic.prototype,"glB","lC",0)
q(A.ci.prototype,"giY","iZ",141)
q(A.ek.prototype,"gjm","fS",2)
r(A.dt.prototype,"gmQ","mR",0)
q(A.jv.prototype,"go2","fT",163)
n(A,"EU","BS",122)
r(j=A.eq.prototype,"ge3","u",3)
p(j,"gen",0,0,null,["$1","$0"],["aG","ah"],50,0,0)
r(j,"gbM","aj",0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.k,null)
q(A.k,[A.vn,J.iw,A.fB,J.dE,A.G,A.dG,A.n,A.i5,A.cP,A.J,A.V,A.A,A.ok,A.ar,A.bE,A.eg,A.il,A.jp,A.j8,A.ig,A.jC,A.iS,A.fd,A.js,A.jn,A.hn,A.f0,A.et,A.cr,A.ps,A.iU,A.f9,A.ht,A.nz,A.fn,A.bc,A.iI,A.fj,A.ex,A.jH,A.fK,A.tn,A.jQ,A.kC,A.bt,A.jZ,A.tu,A.ky,A.h_,A.jJ,A.he,A.kw,A.a1,A.au,A.c8,A.bj,A.dj,A.bi,A.l,A.jI,A.jj,A.cz,A.kx,A.jK,A.fZ,A.jU,A.ri,A.ey,A.ep,A.bQ,A.h9,A.tP,A.tR,A.tQ,A.tN,A.tO,A.tM,A.tJ,A.kH,A.tI,A.tH,A.tL,A.tK,A.kG,A.kI,A.kF,A.eH,A.fX,A.k_,A.t0,A.ev,A.k6,A.aG,A.kB,A.fq,A.k7,A.jl,A.i8,A.af,A.lu,A.qG,A.i7,A.dk,A.rW,A.to,A.kE,A.cD,A.az,A.jX,A.bb,A.aX,A.rj,A.iV,A.fG,A.jW,A.aR,A.iv,A.M,A.F,A.kv,A.X,A.hC,A.pE,A.bk,A.im,A.vE,A.iT,A.rQ,A.rR,A.ii,A.fT,A.fI,A.eB,A.U,A.f6,A.iJ,A.eE,A.ew,A.dW,A.iR,A.jt,A.l5,A.bU,A.hZ,A.i_,A.lk,A.fs,A.cn,A.dU,A.dV,A.lY,A.p3,A.nQ,A.iX,A.hP,A.bH,A.f4,A.f3,A.e0,A.d9,A.cW,A.ac,A.dH,A.lF,A.c9,A.fp,A.dN,A.lE,A.fQ,A.m1,A.mD,A.fb,A.dI,A.f7,A.fO,A.qP,A.fu,A.pc,A.fL,A.lD,A.dL,A.ei,A.oL,A.qk,A.cp,A.fS,A.fN,A.fe,A.f_,A.cu,A.nW,A.kk,A.vM,A.pe,A.cg,A.ea,A.fY,A.hr,A.h6,A.h3,A.jD,A.i6,A.rk,A.mk,A.nU,A.oo,A.jb,A.e7,A.mY,A.aN,A.by,A.bv,A.je,A.b4,A.d6,A.ml,A.cA,A.oq,A.cQ,A.aB,A.i0,A.m3,A.kp,A.kl,A.nm,A.f5,A.c5,A.fF,A.pT,A.pO,A.pV,A.pU,A.df,A.cv,A.ib,A.dl,A.pP,A.ld,A.hd,A.ro,A.k8,A.k1,A.t2,A.pJ,A.dJ,A.og,A.eZ,A.jR,A.j3,A.mj,A.ia,A.dg,A.io,A.mX,A.bV,A.ic,A.dX,A.cR,A.nV,A.d2,A.hu,A.el,A.id,A.qf,A.rh,A.tG,A.rf,A.tb,A.jf,A.cf,A.ju,A.fC,A.dt,A.jv,A.q3,A.ff,A.em,A.p2,A.vf,A.eq])
q(J.iw,[J.iz,J.dR,J.ag,J.aO,J.dT,J.dS,J.cl])
q(J.ag,[J.cm,J.t,A.dY,A.fw])
q(J.cm,[J.iY,J.db,J.aY])
r(J.iy,A.fB)
r(J.nv,J.t)
q(J.dS,[J.fi,J.iA])
q(A.G,[A.eY,A.eC,A.fJ,A.dm,A.bA,A.b6,A.c7,A.eV,A.ha])
q(A.n,[A.cw,A.w,A.bX,A.c6,A.fa,A.da,A.c0,A.fW,A.fz,A.hf,A.jG,A.ku,A.eD,A.cY])
q(A.cw,[A.cN,A.hF])
r(A.h8,A.cN)
r(A.h2,A.hF)
q(A.cP,[A.lJ,A.lB,A.lI,A.nn,A.pg,A.uF,A.uH,A.qx,A.qw,A.tU,A.tT,A.tp,A.tr,A.tq,A.mV,A.mN,A.mR,A.rr,A.rq,A.rC,A.rF,A.oB,A.oI,A.oG,A.oJ,A.oE,A.re,A.t9,A.rb,A.t_,A.nE,A.m0,A.mH,A.qL,A.mO,A.uJ,A.v_,A.v0,A.oy,A.ox,A.lx,A.lz,A.lj,A.lm,A.tW,A.lv,A.nJ,A.ux,A.lZ,A.m_,A.up,A.uY,A.uX,A.u6,A.lt,A.lr,A.ls,A.lo,A.lG,A.m2,A.nL,A.uQ,A.uO,A.us,A.v6,A.pH,A.oU,A.oV,A.oN,A.oO,A.oQ,A.oR,A.p0,A.p_,A.oW,A.oZ,A.oY,A.oS,A.ql,A.qs,A.qr,A.qq,A.qm,A.qn,A.qp,A.ns,A.nt,A.lW,A.p5,A.p7,A.p8,A.pa,A.pD,A.qe,A.uL,A.uM,A.uK,A.n_,A.mZ,A.n0,A.n2,A.n4,A.n1,A.ni,A.ou,A.mt,A.tk,A.uW,A.v1,A.v2,A.l8,A.r9,A.ra,A.lM,A.lN,A.lR,A.lS,A.lT,A.mJ,A.lg,A.le,A.rK,A.rN,A.rO,A.nl,A.nj,A.rJ,A.on,A.pK,A.pL,A.pM,A.pN,A.o0,A.o1,A.o_,A.nZ,A.nY,A.o9,A.o5,A.oc,A.od,A.o6,A.q1,A.mw,A.nM,A.mI,A.oh,A.oi,A.uu,A.lK,A.lL,A.lO,A.lP,A.lQ,A.u2,A.qW,A.qU,A.r_,A.r2,A.qS,A.tc,A.td,A.tf,A.ot,A.or,A.os,A.pB,A.pA,A.uj,A.um,A.po,A.pi,A.pj,A.pk,A.pp,A.pn,A.pY,A.q0,A.q_,A.pZ,A.pX,A.px,A.q7,A.q6,A.la,A.lc,A.rm,A.rn])
q(A.lJ,[A.qQ,A.lC,A.lX,A.nw,A.uG,A.tV,A.uq,A.mW,A.mM,A.rs,A.rD,A.rG,A.qu,A.tX,A.rH,A.nA,A.nG,A.mG,A.rX,A.qK,A.pF,A.mQ,A.mP,A.lw,A.ly,A.lA,A.li,A.nK,A.mE,A.v7,A.p1,A.qo,A.pd,A.vt,A.lV,A.p9,A.n3,A.rP,A.q2,A.r6,A.qi,A.pC,A.uo,A.u3])
r(A.al,A.h2)
q(A.J,[A.cO,A.b_,A.ca,A.k3])
q(A.V,[A.cX,A.c3,A.iB,A.jr,A.j5,A.jV,A.e_,A.fl,A.hV,A.a4,A.fP,A.jq,A.b5,A.i9,A.iK])
q(A.A,[A.ec,A.ef,A.ci,A.eb])
q(A.ec,[A.bq,A.dc])
q(A.lI,[A.uV,A.qy,A.qz,A.tt,A.ts,A.tS,A.qB,A.qC,A.qE,A.qF,A.qD,A.qA,A.mT,A.rt,A.ry,A.rx,A.rv,A.ru,A.rB,A.rA,A.rz,A.rE,A.oC,A.oH,A.oF,A.oK,A.oD,A.tj,A.ti,A.qt,A.qO,A.qN,A.t3,A.t1,A.tY,A.tZ,A.rd,A.rc,A.t8,A.t7,A.ua,A.tD,A.tC,A.u7,A.u5,A.oz,A.oA,A.ow,A.ll,A.u8,A.u9,A.nI,A.nD,A.l3,A.l4,A.uR,A.uP,A.uS,A.uT,A.uU,A.v5,A.pI,A.oT,A.oM,A.oP,A.oX,A.u1,A.oe,A.t5,A.pf,A.lU,A.pb,A.p6,A.qa,A.qb,A.qc,A.qd,A.nh,A.n5,A.nc,A.nd,A.ne,A.nf,A.na,A.nb,A.n6,A.n7,A.n8,A.n9,A.ng,A.rI,A.mu,A.mv,A.mr,A.mq,A.ms,A.mn,A.mm,A.mo,A.mp,A.tl,A.tm,A.v3,A.m8,A.m5,A.ma,A.mc,A.me,A.m7,A.md,A.mi,A.mg,A.mf,A.m9,A.mb,A.mh,A.m6,A.l6,A.l7,A.pQ,A.lf,A.rL,A.rM,A.rp,A.nk,A.o2,A.oa,A.ob,A.o7,A.o8,A.mx,A.my,A.nO,A.nN,A.r4,A.r8,A.r5,A.r7,A.qT,A.qZ,A.r1,A.qV,A.r0,A.r3,A.qX,A.qY,A.mB,A.mA,A.mz,A.qg,A.qh,A.tg,A.te,A.th,A.uk,A.ul,A.uf,A.ue,A.un,A.ug,A.uh,A.ui,A.pq,A.pl,A.pm,A.ph,A.pW,A.tA,A.tz,A.ty,A.tx,A.py,A.pz,A.q5,A.lb])
q(A.w,[A.W,A.cU,A.b0,A.bd,A.ax,A.hc])
q(A.W,[A.d8,A.aa,A.d4,A.fo,A.k4])
r(A.cT,A.bX)
r(A.f8,A.da)
r(A.dM,A.c0)
q(A.hn,[A.k9,A.ka,A.kb,A.kc])
r(A.ho,A.k9)
q(A.ka,[A.a2,A.hp,A.hq,A.kd,A.ez,A.ke,A.kf])
q(A.kb,[A.cy,A.kg,A.kh,A.ki])
r(A.kj,A.kc)
r(A.aW,A.f0)
q(A.cr,[A.f1,A.hs])
r(A.f2,A.f1)
r(A.fh,A.nn)
r(A.fA,A.c3)
q(A.pg,[A.ov,A.eW])
q(A.b_,[A.fk,A.hg])
r(A.bF,A.dY)
q(A.fw,[A.fv,A.dZ])
q(A.dZ,[A.hi,A.hk])
r(A.hj,A.hi)
r(A.co,A.hj)
r(A.hl,A.hk)
r(A.b2,A.hl)
q(A.co,[A.iL,A.iM])
q(A.b2,[A.iN,A.iO,A.iP,A.iQ,A.fx,A.fy,A.d_])
r(A.hw,A.jV)
r(A.a5,A.eC)
r(A.aJ,A.a5)
q(A.au,[A.cx,A.es,A.eA])
r(A.di,A.cx)
q(A.c8,[A.ds,A.h0])
q(A.dj,[A.ad,A.N])
q(A.cz,[A.bN,A.cB])
r(A.kt,A.fZ)
q(A.jU,[A.bx,A.eo])
r(A.hh,A.bN)
q(A.b6,[A.dv,A.bz])
q(A.jj,[A.ks,A.ny])
q(A.kF,[A.jS,A.ko])
q(A.ca,[A.dp,A.h4])
r(A.cb,A.hs)
r(A.hB,A.fq)
r(A.dd,A.hB)
q(A.jl,[A.hv,A.tv,A.rZ,A.dr])
r(A.rT,A.hv)
q(A.i8,[A.cV,A.lh,A.nx])
q(A.cV,[A.hS,A.iF,A.jy])
q(A.af,[A.kA,A.kz,A.hY,A.iE,A.iD,A.jA,A.jz])
q(A.kA,[A.hU,A.iH])
q(A.kz,[A.hT,A.iG])
q(A.lu,[A.rl,A.ta,A.qH,A.jO,A.jP,A.k5,A.kD])
r(A.qM,A.qG)
r(A.qv,A.qH)
r(A.iC,A.fl)
r(A.rU,A.i7)
r(A.rV,A.rW)
r(A.rY,A.k5)
r(A.eu,A.rZ)
r(A.kJ,A.kE)
r(A.tE,A.kJ)
q(A.a4,[A.e2,A.fg])
r(A.jT,A.hC)
r(A.d5,A.eE)
r(A.cq,A.bU)
q(A.hZ,[A.i2,A.e3])
r(A.cM,A.fJ)
r(A.of,A.i_)
r(A.jF,A.of)
r(A.hQ,A.jF)
q(A.lk,[A.e4,A.ct])
r(A.jk,A.ct)
r(A.eX,A.U)
r(A.nr,A.p3)
q(A.nr,[A.nR,A.pG,A.q9])
q(A.rj,[A.fR,A.jo,A.dK,A.am,A.e8,A.nP,A.dO,A.ft,A.cj,A.bw,A.fc,A.cs,A.ch])
r(A.be,A.ac)
q(A.c9,[A.hm,A.ej,A.h7])
q(A.lD,[A.fm,A.d3])
r(A.ix,A.nW)
q(A.mk,[A.l9,A.rg])
r(A.nS,A.l9)
r(A.iq,A.jb)
q(A.e7,[A.er,A.jd])
r(A.e6,A.je)
r(A.c1,A.jd)
r(A.e9,A.cQ)
r(A.i1,A.aB)
q(A.i1,[A.is,A.ck,A.e5])
q(A.i0,[A.k0,A.kr])
r(A.km,A.m3)
r(A.kn,A.km)
r(A.bI,A.kn)
r(A.kq,A.kp)
r(A.aS,A.kq)
q(A.aG,[A.dh,A.aD])
r(A.ee,A.oq)
q(A.aD,[A.hb,A.h5,A.en,A.eG])
r(A.nX,A.og)
q(A.nX,[A.jE,A.ek])
r(A.m4,A.ia)
r(A.bp,A.d2)
r(A.jg,A.jf)
r(A.jh,A.jg)
r(A.fD,A.fC)
r(A.jB,A.jh)
r(A.cc,A.ju)
r(A.hX,A.dg)
r(A.jm,A.e6)
r(A.k2,A.eb)
r(A.bf,A.k2)
s(A.ec,A.js)
s(A.hF,A.A)
s(A.hi,A.A)
s(A.hj,A.fd)
s(A.hk,A.A)
s(A.hl,A.fd)
s(A.bN,A.jK)
s(A.cB,A.kx)
s(A.hB,A.kB)
s(A.kJ,A.jl)
s(A.jF,A.l5)
s(A.km,A.A)
s(A.kn,A.iR)
s(A.kp,A.jt)
s(A.kq,A.J)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{a:"int",Y:"double",bS:"num",j:"String",I:"bool",F:"Null",r:"List",k:"Object",a_:"Map",x:"JSObject"},mangledNames:{},types:["~()","F()","~(x)","o<~>()","~(k,ae)","F(k,ae)","~(k?)","~(a)","~(fu)","F(~)","~(~())","F(x)","a(aM,a)","~(@)","F(@)","~(~)","I(k?)","o<bI>()","o<~>(hd)","x()","o<@>()","j(j)","I(j)","I(aN)","o<~>(o<~>)","a(k?)","a()","a(aM)","~(j2,a,a,a)","I(k?,k?)","o<j>(aI)","a(@,@)","@()","~(dU)","j(cZ)","j(k?)","~(k?,k?)","a(aB,a,a,a)","a(aB,a)","o<~>?()","a(aM,a,a,aO)","~([o<~>?])","~(j,j)","a(+atLast,priority,sinceLast,targetCount(a,a,a,a))","~(k[ae?])","@(@)","x(I)","x(k)","o<F>()","o<ah<~>>()","~([o<@>?])","~(b4)","I()","o<dg>()","~(dt)","~(j2,a)","0&(j,a?)","dL(k?)","M<j,+atLast,priority,sinceLast,targetCount(a,a,a,a)>(j,k?)","I(+hasSynced,lastSyncedAt,priority(I?,bb?,a))","o<~>(ah<~>)","o<+immediateRestart(I)>()","j(X)","a(a,a)","o<j>()","o<j>(o<~>)","o<e4>(o<~>)","o<dQ?>()","o<dQ?>(aI)","a_<j,@>(+name,parameters(j,j))","o<+immediateRestart(I)>(o<~>)","o<~>(aI)","G<aQ>?(ct)","F(bH?)","~(j,k?)","a(a)","ea()","o<+(k,F)>(am,k)","e3()","@(@,j)","x?()","o<bH?>({invalidate!I})","o<j?>(j,j)","~(cu)","+name,parameters(j,j)(k?)","o<bH?>()","o<~>(x)","o<+(F,F)>()","o<+(x,F)>()","o<+(bF?,t<k?>?)>()","+(k?,t<k?>?)/()","F(@,ae)","j?()","a(by)","F(aY,aY)","k(by)","k(aN)","a(aN,aN)","r<by>(M<k,r<aN>>)","k?(~)","c1()","k?(k?)","~(a,j,a)","~(a,@)","~(B,a9,B,~())","~(aO,a)","aM?(aB,a,a,a,a)","a(aB,a,a)","~(@,ae)","a(aB?,a,a)","l<@>?()","I(j,j)","a(j)","a(aM,aO)","F(j,j[k?])","a(aM,a,a)","a(a())","~(~(a,j,a),a,a,a,aO)","~(bY<r<a>>)","~(r<a>)","a(j2,a,a,a,a)","a(a(a),a)","em()","a(vv,a,a)","fs()","x(t<k?>)","~(@,@)","x(x?)","~(cL)","o<~>(a,bg)","o<~>(a)","bg()","o<x>(j)","F(bV)","o<F>(x)","F(~())","dV()","F(k?,ae)","j?(k?)","@(j)","j?(j?)","~(cQ)","x(x)","o<0^>(0^())<k?>","o<x>()","j(j?)","be(ac)","o<ah<b4>>()","I(be)","dk<@,@>(aj<@>)","I(el)","o<j?>(aA)","o<cR>()","0&(k?,ae)","o<bI>(aA)","o<aS?>(aA)","ac(ac,ac)","G<ac>(G<ac>)","I(ac)","o<I>(aI)","~(bY<bu<j>>)","X(X,j)","0&(bp,ae)","o<k?>(k?)","~(bu<j>)","I(c9)","~(B?,a9?,B,k,ae)","0^(B?,a9?,B,0^())<k?>","0^(B?,a9?,B,0^(1^),1^)<k?,k?>","0^(B?,a9?,B,0^(1^,2^),1^,2^)<k?,k?,k?>","0^()(B,a9,B,0^())<k?>","0^(1^)(B,a9,B,0^(1^))<k?,k?>","0^(1^,2^)(B,a9,B,0^(1^,2^))<k?,k?,k?>","a1?(B,a9,B,k,ae?)","~(B?,a9?,B,~())","fM(B,a9,B,aX,~())","fM(B,a9,B,aX,~(fM))","~(B,a9,B,j)","B(B?,a9?,B,fX?,a_<k?,k?>?)","eu(aj<j>)","0^(0^,0^)<bS>","aK(a_<j,k?>)","ei(aj<bg>)","cp(k)","a(vv,a)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"1;immediateRestart":a=>b=>b instanceof A.ho&&a.b(b.a),"2;":(a,b)=>c=>c instanceof A.a2&&a.b(c.a)&&b.b(c.b),"2;basicSupport,supportsReadWriteUnsafe":(a,b)=>c=>c instanceof A.hp&&a.b(c.a)&&b.b(c.b),"2;controller,sync":(a,b)=>c=>c instanceof A.hq&&a.b(c.a)&&b.b(c.b),"2;downloaded,total":(a,b)=>c=>c instanceof A.kd&&a.b(c.a)&&b.b(c.b),"2;file,outFlags":(a,b)=>c=>c instanceof A.ez&&a.b(c.a)&&b.b(c.b),"2;name,parameters":(a,b)=>c=>c instanceof A.ke&&a.b(c.a)&&b.b(c.b),"2;result,resultCode":(a,b)=>c=>c instanceof A.kf&&a.b(c.a)&&b.b(c.b),"3;":(a,b,c)=>d=>d instanceof A.cy&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"3;autocommit,lastInsertRowid,result":(a,b,c)=>d=>d instanceof A.kg&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"3;connectName,connectPort,lockName":(a,b,c)=>d=>d instanceof A.kh&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"3;hasSynced,lastSyncedAt,priority":(a,b,c)=>d=>d instanceof A.ki&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"4;atLast,priority,sinceLast,targetCount":a=>b=>b instanceof A.kj&&A.ED(a,b.a)}}
A.Cr(v.typeUniverse,JSON.parse('{"aY":"cm","iY":"cm","db":"cm","F7":"dY","t":{"r":["1"],"ag":[],"w":["1"],"x":[],"n":["1"],"aF":["1"]},"iz":{"I":[],"a0":[]},"dR":{"F":[],"a0":[]},"ag":{"x":[]},"cm":{"ag":[],"x":[]},"iy":{"fB":[]},"nv":{"t":["1"],"r":["1"],"ag":[],"w":["1"],"x":[],"n":["1"],"aF":["1"]},"dS":{"Y":[],"a7":["bS"]},"fi":{"Y":[],"a":[],"a7":["bS"],"a0":[]},"iA":{"Y":[],"a7":["bS"],"a0":[]},"cl":{"j":[],"a7":["j"],"aF":["@"],"a0":[]},"eY":{"G":["2"],"G.T":"2"},"dG":{"ah":["2"]},"cw":{"n":["2"]},"cN":{"cw":["1","2"],"n":["2"],"n.E":"2"},"h8":{"cN":["1","2"],"cw":["1","2"],"w":["2"],"n":["2"],"n.E":"2"},"h2":{"A":["2"],"r":["2"],"cw":["1","2"],"w":["2"],"n":["2"]},"al":{"h2":["1","2"],"A":["2"],"r":["2"],"cw":["1","2"],"w":["2"],"n":["2"],"A.E":"2","n.E":"2"},"cO":{"J":["3","4"],"a_":["3","4"],"J.V":"4","J.K":"3"},"cX":{"V":[]},"bq":{"A":["a"],"r":["a"],"w":["a"],"n":["a"],"A.E":"a"},"w":{"n":["1"]},"W":{"w":["1"],"n":["1"]},"d8":{"W":["1"],"w":["1"],"n":["1"],"W.E":"1","n.E":"1"},"bX":{"n":["2"],"n.E":"2"},"cT":{"bX":["1","2"],"w":["2"],"n":["2"],"n.E":"2"},"aa":{"W":["2"],"w":["2"],"n":["2"],"W.E":"2","n.E":"2"},"c6":{"n":["1"],"n.E":"1"},"fa":{"n":["2"],"n.E":"2"},"da":{"n":["1"],"n.E":"1"},"f8":{"da":["1"],"w":["1"],"n":["1"],"n.E":"1"},"c0":{"n":["1"],"n.E":"1"},"dM":{"c0":["1"],"w":["1"],"n":["1"],"n.E":"1"},"cU":{"w":["1"],"n":["1"],"n.E":"1"},"fW":{"n":["1"],"n.E":"1"},"fz":{"n":["1"],"n.E":"1"},"ec":{"A":["1"],"r":["1"],"w":["1"],"n":["1"]},"d4":{"W":["1"],"w":["1"],"n":["1"],"W.E":"1","n.E":"1"},"f0":{"a_":["1","2"]},"aW":{"f0":["1","2"],"a_":["1","2"]},"hf":{"n":["1"],"n.E":"1"},"f1":{"cr":["1"],"bu":["1"],"w":["1"],"n":["1"]},"f2":{"cr":["1"],"bu":["1"],"w":["1"],"n":["1"]},"fA":{"c3":[],"V":[]},"iB":{"V":[]},"jr":{"V":[]},"iU":{"P":[]},"ht":{"ae":[]},"j5":{"V":[]},"b_":{"J":["1","2"],"a_":["1","2"],"J.V":"2","J.K":"1"},"b0":{"w":["1"],"n":["1"],"n.E":"1"},"bd":{"w":["1"],"n":["1"],"n.E":"1"},"ax":{"w":["M<1,2>"],"n":["M<1,2>"],"n.E":"M<1,2>"},"fk":{"b_":["1","2"],"J":["1","2"],"a_":["1","2"],"J.V":"2","J.K":"1"},"ex":{"j1":[],"cZ":[]},"jG":{"n":["j1"],"n.E":"j1"},"fK":{"cZ":[]},"ku":{"n":["cZ"],"n.E":"cZ"},"bF":{"ag":[],"x":[],"cL":[],"a0":[]},"dY":{"ag":[],"x":[],"cL":[],"a0":[]},"fw":{"ag":[],"x":[]},"kC":{"cL":[]},"fv":{"ag":[],"vc":[],"x":[],"a0":[]},"dZ":{"aZ":["1"],"ag":[],"x":[],"aF":["1"]},"co":{"A":["Y"],"r":["Y"],"aZ":["Y"],"ag":[],"w":["Y"],"x":[],"aF":["Y"],"n":["Y"]},"b2":{"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"]},"iL":{"co":[],"mK":[],"A":["Y"],"r":["Y"],"aZ":["Y"],"ag":[],"w":["Y"],"x":[],"aF":["Y"],"n":["Y"],"a0":[],"A.E":"Y"},"iM":{"co":[],"mL":[],"A":["Y"],"r":["Y"],"aZ":["Y"],"ag":[],"w":["Y"],"x":[],"aF":["Y"],"n":["Y"],"a0":[],"A.E":"Y"},"iN":{"b2":[],"no":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"iO":{"b2":[],"np":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"iP":{"b2":[],"nq":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"iQ":{"b2":[],"pu":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"fx":{"b2":[],"pv":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"fy":{"b2":[],"pw":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"d_":{"b2":[],"bg":[],"A":["a"],"r":["a"],"aZ":["a"],"ag":[],"w":["a"],"x":[],"aF":["a"],"n":["a"],"a0":[],"A.E":"a"},"jV":{"V":[]},"hw":{"c3":[],"V":[]},"a1":{"V":[]},"l":{"o":["1"]},"bY":{"bJ":["1"],"aj":["1"]},"bJ":{"aj":["1"]},"au":{"ah":["1"],"au.T":"1"},"h_":{"cS":["1"]},"eD":{"n":["1"],"n.E":"1"},"aJ":{"a5":["1"],"eC":["1"],"G":["1"],"G.T":"1"},"di":{"cx":["1"],"au":["1"],"ah":["1"],"au.T":"1"},"c8":{"bJ":["1"],"aj":["1"]},"ds":{"c8":["1"],"bJ":["1"],"aj":["1"]},"h0":{"c8":["1"],"bJ":["1"],"aj":["1"]},"e_":{"V":[]},"dj":{"cS":["1"]},"ad":{"dj":["1"],"cS":["1"]},"N":{"dj":["1"],"cS":["1"]},"fJ":{"G":["1"]},"cz":{"bJ":["1"],"aj":["1"]},"bN":{"cz":["1"],"bJ":["1"],"aj":["1"]},"cB":{"cz":["1"],"bJ":["1"],"aj":["1"]},"a5":{"eC":["1"],"G":["1"],"G.T":"1"},"cx":{"au":["1"],"ah":["1"],"au.T":"1"},"eC":{"G":["1"]},"ep":{"ah":["1"]},"dm":{"G":["1"],"G.T":"1"},"bA":{"G":["1"],"G.T":"1"},"hh":{"bN":["1"],"cz":["1"],"bY":["1"],"bJ":["1"],"aj":["1"]},"b6":{"G":["2"]},"es":{"au":["2"],"ah":["2"],"au.T":"2"},"dv":{"b6":["1","1"],"G":["1"],"G.T":"1","b6.T":"1","b6.S":"1"},"bz":{"b6":["1","2"],"G":["2"],"G.T":"2","b6.T":"2","b6.S":"1"},"h9":{"aj":["1"]},"eA":{"au":["2"],"ah":["2"],"au.T":"2"},"c7":{"G":["2"],"G.T":"2"},"kF":{"B":[]},"jS":{"B":[]},"ko":{"B":[]},"eH":{"a9":[]},"ca":{"J":["1","2"],"a_":["1","2"],"J.V":"2","J.K":"1"},"dp":{"ca":["1","2"],"J":["1","2"],"a_":["1","2"],"J.V":"2","J.K":"1"},"h4":{"ca":["1","2"],"J":["1","2"],"a_":["1","2"],"J.V":"2","J.K":"1"},"hc":{"w":["1"],"n":["1"],"n.E":"1"},"hg":{"b_":["1","2"],"J":["1","2"],"a_":["1","2"],"J.V":"2","J.K":"1"},"cb":{"hs":["1"],"cr":["1"],"bu":["1"],"w":["1"],"n":["1"]},"dc":{"A":["1"],"r":["1"],"w":["1"],"n":["1"],"A.E":"1"},"cY":{"n":["1"],"n.E":"1"},"A":{"r":["1"],"w":["1"],"n":["1"]},"J":{"a_":["1","2"]},"fq":{"a_":["1","2"]},"dd":{"fq":["1","2"],"kB":["1","2"],"a_":["1","2"]},"fo":{"W":["1"],"w":["1"],"n":["1"],"W.E":"1","n.E":"1"},"cr":{"bu":["1"],"w":["1"],"n":["1"]},"hs":{"cr":["1"],"bu":["1"],"w":["1"],"n":["1"]},"dk":{"aj":["1"]},"eu":{"aj":["j"]},"k3":{"J":["j","@"],"a_":["j","@"],"J.V":"@","J.K":"j"},"k4":{"W":["j"],"w":["j"],"n":["j"],"W.E":"j","n.E":"j"},"hS":{"cV":[]},"kA":{"af":["j","r<a>"]},"hU":{"af":["j","r<a>"],"af.T":"r<a>"},"kz":{"af":["r<a>","j"]},"hT":{"af":["r<a>","j"],"af.T":"j"},"hY":{"af":["r<a>","j"],"af.T":"j"},"fl":{"V":[]},"iC":{"V":[]},"iE":{"af":["k?","j"],"af.T":"j"},"iD":{"af":["j","k?"],"af.T":"k?"},"iF":{"cV":[]},"iH":{"af":["j","r<a>"],"af.T":"r<a>"},"iG":{"af":["r<a>","j"],"af.T":"j"},"jy":{"cV":[]},"jA":{"af":["j","r<a>"],"af.T":"r<a>"},"jz":{"af":["r<a>","j"],"af.T":"j"},"wy":{"a7":["wy"]},"bb":{"a7":["bb"]},"Y":{"a7":["bS"]},"aX":{"a7":["aX"]},"a":{"a7":["bS"]},"r":{"w":["1"],"n":["1"]},"bS":{"a7":["bS"]},"j1":{"cZ":[]},"bu":{"w":["1"],"n":["1"]},"j":{"a7":["j"]},"az":{"a7":["wy"]},"hV":{"V":[]},"c3":{"V":[]},"a4":{"V":[]},"e2":{"V":[]},"fg":{"V":[]},"fP":{"V":[]},"jq":{"V":[]},"b5":{"V":[]},"i9":{"V":[]},"iV":{"V":[]},"fG":{"V":[]},"jW":{"P":[]},"aR":{"P":[]},"iv":{"P":[],"V":[]},"kv":{"ae":[]},"hC":{"jw":[]},"bk":{"jw":[]},"jT":{"jw":[]},"iT":{"P":[]},"U":{"a_":["2","3"]},"d5":{"eE":["1","bu<1>"],"eE.E":"1"},"cq":{"P":[]},"hZ":{"lH":[]},"i2":{"lH":[]},"cM":{"G":["r<a>"],"G.T":"r<a>"},"bU":{"P":[]},"jk":{"ct":[]},"eX":{"U":["j","j","1"],"a_":["j","1"],"U.K":"j","U.V":"1","U.C":"j"},"cn":{"a7":["cn"]},"iX":{"P":[]},"d9":{"P":[]},"f3":{"P":[]},"e0":{"P":[]},"cW":{"dQ":[]},"be":{"ac":[]},"dH":{"P":[]},"hm":{"c9":[]},"ej":{"c9":[]},"h7":{"c9":[]},"fp":{"c_":[],"aK":[]},"dN":{"aK":[]},"fQ":{"c_":[],"aK":[]},"fb":{"c_":[],"aK":[]},"dI":{"aK":[]},"f7":{"c_":[],"aK":[]},"fO":{"c_":[],"aK":[]},"ei":{"aj":["r<a>"]},"cp":{"aQ":[]},"dK":{"aQ":[]},"fS":{"aQ":[]},"fN":{"aQ":[]},"fe":{"aQ":[]},"f_":{"aQ":[]},"e3":{"lH":[]},"fY":{"bP":[]},"hr":{"bP":[]},"h6":{"bP":[]},"h3":{"bP":[]},"i6":{"P":[]},"iq":{"bv":[],"a7":["bv"]},"er":{"c1":[],"a7":["jc"]},"bv":{"a7":["bv"]},"jb":{"bv":[],"a7":["bv"]},"jc":{"a7":["jc"]},"jd":{"a7":["jc"]},"je":{"P":[]},"e6":{"aR":[],"P":[]},"e7":{"a7":["jc"]},"c1":{"a7":["jc"]},"d6":{"P":[]},"e9":{"cQ":[]},"is":{"aB":[]},"k0":{"fU":[],"aM":[]},"bI":{"A":["aS"],"r":["aS"],"w":["aS"],"n":["aS"],"A.E":"aS"},"aS":{"jt":["j","@"],"J":["j","@"],"a_":["j","@"],"J.V":"@","J.K":"j"},"c5":{"P":[]},"i1":{"aB":[]},"i0":{"fU":[],"aM":[]},"dh":{"aG":["dh"],"aG.E":"dh"},"ef":{"A":["cv"],"r":["cv"],"w":["cv"],"n":["cv"],"A.E":"cv"},"eV":{"G":["1"],"G.T":"1"},"ck":{"aB":[]},"aD":{"aG":["aD"]},"k1":{"fU":[],"aM":[]},"hb":{"aD":[],"aG":["aD"],"aG.E":"aD"},"h5":{"aD":[],"aG":["aD"],"aG.E":"aD"},"en":{"aD":[],"aG":["aD"],"aG.E":"aD"},"eG":{"aD":[],"aG":["aD"],"aG.E":"aD"},"e5":{"aB":[]},"kr":{"fU":[],"aM":[]},"eZ":{"P":[]},"j3":{"wG":[]},"ci":{"A":["k?"],"r":["k?"],"w":["k?"],"n":["k?"],"A.E":"k?"},"bp":{"P":[]},"d2":{"P":[]},"ek":{"wD":[]},"iK":{"V":[]},"jg":{"aI":[],"aA":[]},"jh":{"aI":[],"aA":[]},"cf":{"P":[]},"ju":{"aA":[]},"fC":{"aA":[]},"fD":{"aI":[],"aA":[]},"aI":{"aA":[]},"jf":{"aI":[],"aA":[]},"cc":{"aA":[]},"jB":{"vC":[],"aI":[],"aA":[]},"hX":{"dg":[]},"jm":{"aR":[],"P":[]},"bf":{"eb":["a"],"A":["a"],"r":["a"],"w":["a"],"n":["a"],"A.E":"a"},"eb":{"A":["1"],"r":["1"],"w":["1"],"n":["1"]},"k2":{"eb":["a"],"A":["a"],"r":["a"],"w":["a"],"n":["a"]},"ha":{"G":["1"],"G.T":"1"},"eq":{"ah":["1"]},"nq":{"r":["a"],"w":["a"],"n":["a"]},"bg":{"r":["a"],"w":["a"],"n":["a"]},"pw":{"r":["a"],"w":["a"],"n":["a"]},"no":{"r":["a"],"w":["a"],"n":["a"]},"pu":{"r":["a"],"w":["a"],"n":["a"]},"np":{"r":["a"],"w":["a"],"n":["a"]},"pv":{"r":["a"],"w":["a"],"n":["a"]},"mK":{"r":["Y"],"w":["Y"],"n":["Y"]},"mL":{"r":["Y"],"w":["Y"],"n":["Y"]},"vC":{"aI":[],"aA":[]}}'))
A.Cq(v.typeUniverse,JSON.parse('{"eg":1,"j8":1,"ig":1,"iS":1,"fd":1,"js":1,"ec":1,"hF":2,"f1":1,"fn":1,"bc":1,"dZ":1,"aj":1,"kw":1,"e_":2,"fJ":1,"jj":2,"kx":1,"jK":1,"fZ":1,"kt":1,"jU":1,"bx":1,"ey":1,"bQ":1,"h9":1,"ks":2,"hB":2,"dk":2,"i7":1,"i8":2,"hv":1,"im":1,"fT":1,"f6":1,"iR":1,"ft":1,"zT":1}'))
var u={S:"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\u03f6\x00\u0404\u03f4 \u03f4\u03f6\u01f6\u01f6\u03f6\u03fc\u01f4\u03ff\u03ff\u0584\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u05d4\u01f4\x00\u01f4\x00\u0504\u05c4\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u0400\x00\u0400\u0200\u03f7\u0200\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u0200\u0200\u0200\u03f7\x00",D:" must not be greater than the number of characters in the file, ",U:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",t:"Broadcast stream controllers do not support pause callbacks",O:"Cannot change the length of a fixed-length list",A:"Cannot extract a file path from a URI with a fragment component",z:"Cannot extract a file path from a URI with a query component",Q:"Cannot extract a non-Windows file path from a file URI with an authority",c:"Cannot fire new event. Controller is already firing an event",w:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",B:"SELECT seq FROM main.sqlite_sequence WHERE name = 'ps_crud'",f:"Tried to operate on a released prepared statement",y:"handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace.",E:"max must be in range 0 < max \u2264 2^32, was "}
var t=(function rtii(){var s=A.ai
return{fM:s("@<@>"),fN:s("bp"),ie:s("zT<k?>"),om:s("eV<t<k?>>"),lo:s("cL"),fW:s("vc"),kj:s("eX<j>"),eg:s("wD"),dF:s("lH()"),V:s("bq"),fw:s("cQ"),bP:s("a7<@>"),p6:s("cR"),br:s("cS<x>"),kn:s("cS<k?>"),oh:s("cS<~>"),hM:s("cg"),em:s("dL"),kS:s("wG"),lp:s("id"),O:s("w<@>"),C:s("V"),L:s("P"),eZ:s("io"),pk:s("mK"),kI:s("mL"),lW:s("aR"),gY:s("F2"),nW:s("o<x>"),mj:s("o<F>"),nK:s("o<+(k?,t<k?>?)>"),fP:s("o<bV?>"),cI:s("o<j?>"),jN:s("o<ee?>"),p8:s("o<~>"),cF:s("ck"),m6:s("no"),bW:s("np"),g2:s("dQ"),jx:s("nq"),ks:s("n<aK>"),e7:s("n<@>"),iw:s("t<o<~>>"),W:s("t<x>"),dO:s("t<r<k?>>"),hf:s("t<k>"),fU:s("t<+controller,sync(bY<b4>,I)>"),lw:s("t<+controller,sync(bY<~>,I)>"),kC:s("t<+(cs,j)>"),bN:s("t<+name,parameters(j,j)>"),cH:s("t<+hasSynced,lastSyncedAt,priority(I?,bb?,a)>"),lE:s("t<e9>"),bO:s("t<ah<~>>"),fu:s("t<G<aQ>>"),i3:s("t<G<~>>"),s:s("t<j>"),az:s("t<ek>"),ba:s("t<el>"),dB:s("t<bj<@>>"),g7:s("t<aN>"),dg:s("t<by>"),o6:s("t<k8>"),jI:s("t<dt>"),gk:s("t<Y>"),dG:s("t<@>"),t:s("t<a>"),b9:s("t<a1?>"),fT:s("t<t<k?>?>"),c:s("t<k?>"),mf:s("t<j?>"),iy:s("aF<@>"),v:s("dR"),m:s("x"),bJ:s("aO"),g:s("aY"),dX:s("aZ<@>"),d9:s("ag"),kk:s("cY<dh>"),p3:s("cY<aD>"),mu:s("r<t<k?>>"),ip:s("r<x>"),eL:s("r<+name,parameters(j,j)>"),o:s("r<j>"),j:s("r<@>"),f4:s("r<a>"),ia:s("r<k?>"),fi:s("r<j?>"),ag:s("dU"),I:s("dV"),gc:s("M<j,j>"),lx:s("M<j,+atLast,priority,sinceLast,targetCount(a,a,a,a)>"),ea:s("a_<j,@>"),dV:s("a_<j,a>"),av:s("a_<@,@>"),f:s("a_<j,k?>"),iZ:s("aa<j,@>"),jC:s("F6"),a:s("bF"),dQ:s("co"),aj:s("b2"),Z:s("d_"),M:s("c_"),bC:s("fz<o<~>>"),P:s("F"),K:s("k"),lZ:s("F9"),aK:s("+()"),U:s("+immediateRestart(I)"),ja:s("+(x,dJ)"),iS:s("+(x,F)"),lg:s("+(F,F)"),k0:s("+(k,F)"),cU:s("+(cs,j)"),E:s("+name,parameters(j,j)"),l4:s("+(am,k)"),mk:s("+(I,x)"),kO:s("+basicSupport,supportsReadWriteUnsafe(I,I)"),mt:s("+(x?,x)"),jc:s("+(bF?,t<k?>?)"),iu:s("+(k?,t<k?>?)"),ii:s("+autocommit,lastInsertRowid,result(I,a,bI)"),cV:s("+atLast,priority,sinceLast,targetCount(a,a,a,a)"),lu:s("j1"),Y:s("e4"),G:s("bI"),hF:s("d4<j>"),oy:s("aS"),g_:s("e5"),hq:s("bv"),ol:s("c1"),e1:s("b4"),l:s("ae"),ao:s("bJ<ac>"),a9:s("fI<bP>"),ha:s("ah<b4>"),ey:s("ah<~>"),ir:s("G<bP>"),n:s("ct"),N:s("j"),of:s("X"),k:s("aQ"),jM:s("d9"),mO:s("ea"),gs:s("cu"),hU:s("fM"),aJ:s("a0"),do:s("c3"),i7:s("pu"),mC:s("pv"),oR:s("bf"),nn:s("pw"),p:s("bg"),cx:s("db"),ph:s("dc<+hasSynced,lastSyncedAt,priority(I?,bb?,a)>"),oP:s("dd<j,j>"),en:s("ac"),R:s("jw"),e6:s("aB"),j2:s("fU"),w:s("ee"),m1:s("vC"),lS:s("fW<j>"),u:s("dg"),iq:s("ad<bg>"),ho:s("ad<a>"),if:s("ad<cg?>"),mE:s("ad<k?>"),h:s("ad<~>"),it:s("c7<@,j>"),jB:s("c7<@,bg>"),hi:s("c9"),fK:s("em"),Q:s("dl<x>"),hV:s("dm<ac>"),d4:s("ha<x>"),nI:s("l<ff>"),fV:s("l<bV>"),a7:s("l<x>"),e:s("l<0&>"),jz:s("l<bg>"),x:s("l<I>"),_:s("l<@>"),hy:s("l<a>"),iB:s("l<cg?>"),ny:s("l<k?>"),D:s("l<~>"),nf:s("aN"),mp:s("dp<k?,k?>"),fA:s("ew"),fb:s("bA<r<a>>"),cn:s("bA<bu<j>>"),pp:s("bP"),jy:s("cA<b4,~()>"),af:s("cA<~,I()>"),lU:s("cA<~,~()>"),aP:s("N<ff>"),l6:s("N<bV>"),h1:s("N<x>"),ex:s("N<I>"),gW:s("N<k?>"),F:s("N<~>"),y:s("I"),i:s("Y"),z:s("@"),mq:s("@(k)"),b:s("@(k,ae)"),S:s("a"),gO:s("cg?"),d_:s("f4?"),gK:s("o<F>?"),m2:s("o<~>?"),b3:s("bV?"),fo:s("dQ?"),A:s("x?"),h9:s("a_<j,k?>?"),aC:s("bF?"),X:s("k?"),B:s("bH?"),J:s("aS?"),mQ:s("ah<bP>?"),T:s("j?"),a_:s("bf?"),he:s("ee?"),dd:s("aN?"),o9:s("I?"),jX:s("Y?"),aV:s("a?"),jh:s("bS?"),q:s("bS"),H:s("~"),d:s("~()"),i6:s("~(k)"),r:s("~(k,ae)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.b5=J.iw.prototype
B.d=J.t.prototype
B.b=J.fi.prototype
B.H=J.dR.prototype
B.a6=J.dS.prototype
B.a=J.cl.prototype
B.b6=J.aY.prototype
B.b7=J.ag.prototype
B.ab=A.fv.prototype
B.M=A.fx.prototype
B.f=A.d_.prototype
B.ac=J.iY.prototype
B.V=J.db.prototype
B.A=new A.bp("Operation was cancelled",null)
B.X=new A.hT(!1,127)
B.av=new A.hU(127)
B.aP=new A.dm(A.ai("dm<r<a>>"))
B.aw=new A.cM(B.aP)
B.ax=new A.fh(A.EC(),A.ai("fh<a>"))
B.cb=new A.hY()
B.ay=new A.lh()
B.az=new A.i6()
B.B=new A.f6()
B.aA=new A.f7()
B.Y=new A.ig()
B.aB=new A.iv()
B.Z=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.aC=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.aH=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.aD=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.aG=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.aF=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.aE=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.a_=function(hooks) { return hooks; }

B.h=new A.nx()
B.j=new A.iF()
B.q=new A.fm()
B.aI=new A.ny()
B.x=new A.iJ(A.ai("iJ<k?>"))
B.y=new A.dW(A.ai("dW<j,@>"))
B.a0=new A.dW(A.ai("dW<k?,k?>"))
B.aJ=new A.iV()
B.c=new A.ok()
B.aL=new A.d5(A.ai("d5<j>"))
B.aK=new A.d5(A.ai("d5<+name,parameters(j,j)>"))
B.aM=new A.fN()
B.aN=new A.fS()
B.k=new A.jy()
B.n=new A.jA()
B.aO=new A.rg()
B.z=new A.ri()
B.a1=new A.h7()
B.aQ=new A.rQ()
B.C=new A.hm()
B.e=new A.ko()
B.r=new A.kv()
B.aR=new A.tG()
B.aS=new A.tH()
B.aT=new A.dH("The PowerSync service does not support checkpoint requests. Update to PowerSync service version 1.24.0 or later to use this API.")
B.aU=new A.dH("Cannot request checkpoints, sync client is disconnected")
B.aV=new A.dH("Connected with legacy checkpoint mode, cannot request checkpoints")
B.aW=new A.dK(0,"established")
B.aX=new A.dK(1,"end")
B.D=new A.ch(3,"updateSubscriptionManagement")
B.E=new A.ch(4,"notifyUpdates")
B.a2=new A.aX(0)
B.F=new A.aX(1e4)
B.u=new A.aX(5e6)
B.G=new A.cj("x",1,"opfsExternalLocks")
B.a3=new A.cj("y",2,"opfsExternalLocksWorkaround")
B.a4=new A.dO("/database",0,"database")
B.a5=new A.dO("/database-journal",1,"journal")
B.b8=new A.iD(null)
B.b9=new A.iE(null)
B.a7=new A.iG(!1,255)
B.ba=new A.iH(255)
B.t=new A.cn("FINE",500)
B.l=new A.cn("INFO",800)
B.m=new A.cn("WARNING",900)
B.bb=s([239,191,189],t.t)
B.w=new A.bw(0,"unknown")
B.P=new A.bw(1,"integer")
B.Q=new A.bw(2,"bigInt")
B.R=new A.bw(3,"float")
B.S=new A.bw(4,"text")
B.T=new A.bw(5,"blob")
B.U=new A.bw(6,"$null")
B.ap=new A.bw(7,"boolean")
B.I=s([B.w,B.P,B.Q,B.R,B.S,B.T,B.U,B.ap],A.ai("t<bw>"))
B.bc=s([65533],t.t)
B.aY=new A.ch(0,"ok")
B.aZ=new A.ch(1,"getAutoCommit")
B.b_=new A.ch(2,"executeBatch")
B.a8=s([B.aY,B.aZ,B.b_,B.D,B.E],A.ai("t<ch>"))
B.b3=new A.fc(0,"database")
B.b4=new A.fc(1,"journal")
B.a9=s([B.b3,B.b4],A.ai("t<fc>"))
B.b2=new A.cj("s",0,"opfsShared")
B.b0=new A.cj("i",3,"indexedDb")
B.b1=new A.cj("m",4,"inMemory")
B.bd=s([B.b2,B.G,B.a3,B.b0,B.b1],A.ai("t<cj>"))
B.O=new A.jo(0,"rust")
B.be=s([B.O],A.ai("t<jo>"))
B.af=new A.e8(0,"insert")
B.ag=new A.e8(1,"update")
B.ah=new A.e8(2,"delete")
B.bf=s([B.af,B.ag,B.ah],A.ai("t<e8>"))
B.J=s([],t.s)
B.bh=s([],t.t)
B.o=s([],t.c)
B.bg=s([],t.bN)
B.aa=s([],t.cH)
B.bi=s([B.a4,B.a5],A.ai("t<dO>"))
B.ai=new A.cs(0,"opfs")
B.aj=new A.cs(1,"indexedDb")
B.bs=new A.cs(2,"inMemory")
B.bj=s([B.ai,B.aj,B.bs],A.ai("t<cs>"))
B.ak=new A.am(0,"ping")
B.bv=new A.am(1,"startSynchronization")
B.bD=new A.am(2,"updateSubscriptions")
B.bE=new A.am(3,"abortSynchronization")
B.al=new A.am(4,"requestEndpoint")
B.am=new A.am(5,"uploadCrud")
B.bF=new A.am(6,"customCheckpointRequest")
B.bG=new A.am(7,"requestCheckpoint")
B.an=new A.am(8,"invalidCredentialsCallback")
B.ao=new A.am(9,"credentialsCallback")
B.bw=new A.am(10,"notifySyncStatus")
B.bx=new A.am(11,"logEvent")
B.by=new A.am(12,"sendHttpRequest")
B.bz=new A.am(13,"abortHttpRequest")
B.bA=new A.am(14,"readResponseChunk")
B.bB=new A.am(15,"okResponse")
B.bC=new A.am(16,"errorResponse")
B.bk=s([B.ak,B.bv,B.bD,B.bE,B.al,B.am,B.bF,B.bG,B.an,B.ao,B.bw,B.bx,B.by,B.bz,B.bA,B.bB,B.bC],A.ai("t<am>"))
B.bp={"iso_8859-1:1987":0,"iso-ir-100":1,"iso_8859-1":2,"iso-8859-1":3,latin1:4,l1:5,ibm819:6,cp819:7,csisolatin1:8,"iso-ir-6":9,"ansi_x3.4-1968":10,"ansi_x3.4-1986":11,"iso_646.irv:1991":12,"iso646-us":13,"us-ascii":14,us:15,ibm367:16,cp367:17,csascii:18,ascii:19,csutf8:20,"utf-8":21}
B.i=new A.hS()
B.bl=new A.aW(B.bp,[B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.i,B.i,B.i,B.i,B.i,B.i,B.i,B.i,B.i,B.i,B.i,B.k,B.k],A.ai("aW<j,cV>"))
B.v={}
B.L=new A.aW(B.v,[],A.ai("aW<j,j>"))
B.bm=new A.aW(B.v,[],A.ai("aW<j,a>"))
B.K=new A.aW(B.v,[],A.ai("aW<j,@>"))
B.p=new A.ft(11,"simpleSuccessResponse")
B.bo=new A.ft(13,"rowsResponse")
B.cc=new A.nP(2,"readWriteCreate")
B.ad=new A.ho(!1)
B.ae=new A.a2(null,null)
B.N=new A.hp(!1,!1)
B.bq=new A.cy("BEGIN IMMEDIATE","COMMIT","ROLLBACK")
B.br=new A.f2(B.v,0,A.ai("f2<j>"))
B.bt=new A.jn("_clientToken")
B.bu=new A.cu(!1,!1,!1,null,!1,null,null,null,null,B.aa,null,null)
B.bH=A.bo("cL")
B.bI=A.bo("vc")
B.bJ=A.bo("mK")
B.bK=A.bo("mL")
B.bL=A.bo("no")
B.bM=A.bo("np")
B.bN=A.bo("nq")
B.bO=A.bo("x")
B.bP=A.bo("k")
B.bQ=A.bo("pu")
B.bR=A.bo("pv")
B.bS=A.bo("pw")
B.bT=A.bo("bg")
B.bU=new A.fR("DELETE",2,"delete")
B.bV=new A.fR("PATCH",1,"patch")
B.bW=new A.fR("PUT",0,"put")
B.aq=new A.jz(!1)
B.bX=new A.c5(14)
B.bY=new A.c5(522)
B.bZ=new A.c5(778)
B.ar=new A.eB("canceled")
B.as=new A.eB("dormant")
B.at=new A.eB("listening")
B.au=new A.eB("paused")
B.c_=new A.tI(B.e,A.DR())
B.c0=new A.tJ(B.e,A.DS())
B.c1=new A.tK(B.e,A.DT())
B.c2=new A.kG(B.e,A.DU())
B.c3=new A.tL(B.e,A.DV())
B.c4=new A.tM(B.e,A.DW())
B.c5=new A.tN(B.e,A.DX())
B.c6=new A.tO(B.e,A.DY())
B.c7=new A.tQ(B.e,A.E_())
B.c8=new A.tR(B.e,A.E0())
B.c9=new A.tP(B.e,A.DZ())
B.ca=new A.kH(B.e,A.E1())
B.bn=new A.aW(B.v,[],A.ai("aW<k?,k?>"))
B.W=new A.kI(B.e,B.bn)})();(function staticFields(){$.rS=null
$.dx=A.u([],t.hf)
$.Do=null
$.x5=null
$.wB=null
$.wA=null
$.yP=null
$.yI=null
$.yZ=null
$.uw=null
$.uI=null
$.wd=null
$.t4=A.u([],A.ai("t<r<k>?>"))
$.eL=null
$.hH=null
$.hI=null
$.w3=!1
$.m=B.e
$.t6=null
$.xz=null
$.xA=null
$.xB=null
$.xC=null
$.vF=A.qR("_lastQuoRemDigits")
$.vG=A.qR("_lastQuoRemUsed")
$.h1=A.qR("_lastRemUsed")
$.vH=A.qR("_lastRem_nsh")
$.xu=""
$.xv=null
$.eK=0
$.eI=A.Z(t.N,t.S)
$.wZ=0
$.AM=A.Z(t.N,t.I)
$.yj=null
$.u0=null})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"F0","za",()=>A.uA("_$dart_dartClosure"))
s($,"F_","dC",()=>A.uA("_$dart_dartClosure_dartJSInterop"))
s($,"FZ","zG",()=>B.e.bs(new A.uV(),t.p8))
s($,"FS","zD",()=>A.u([new J.iy()],A.ai("t<fB>")))
s($,"Fh","ze",()=>A.c4(A.pt({
toString:function(){return"$receiver$"}})))
s($,"Fi","zf",()=>A.c4(A.pt({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"Fj","zg",()=>A.c4(A.pt(null)))
s($,"Fk","zh",()=>A.c4(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"Fn","zk",()=>A.c4(A.pt(void 0)))
s($,"Fo","zl",()=>A.c4(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"Fm","zj",()=>A.c4(A.xr(null)))
s($,"Fl","zi",()=>A.c4(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"Fq","zn",()=>A.c4(A.xr(void 0)))
s($,"Fp","zm",()=>A.c4(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"Ft","wk",()=>A.BD())
s($,"F4","cI",()=>$.zG())
s($,"F3","zb",()=>A.BV(!1,B.e,t.y))
s($,"FD","zt",()=>A.AR(4096))
s($,"FB","zr",()=>new A.tD().$0())
s($,"FC","zs",()=>new A.tC().$0())
s($,"Fu","zo",()=>A.AP(A.vZ(A.u([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.t))))
s($,"Fz","ce",()=>A.qI(0))
s($,"Fy","kY",()=>A.qI(1))
s($,"Fw","wm",()=>$.kY().bx(0))
s($,"Fv","wl",()=>A.qI(1e4))
r($,"Fx","zp",()=>A.at("^\\s*([+-]?)((0x[a-f0-9]+)|(\\d+)|([a-z0-9]+))\\s*$",!1))
s($,"FA","zq",()=>typeof FinalizationRegistry=="function"?FinalizationRegistry:null)
s($,"FG","bT",()=>A.kU(B.bP))
r($,"FN","kZ",()=>new A.u7().$0())
r($,"FK","zy",()=>new A.u5().$0())
s($,"FJ","zx",()=>Symbol("jsBoxedDartObjectProperty"))
s($,"F8","zc",()=>{var q=new A.rR(A.AN(8))
q.l_()
return q})
s($,"EY","z9",()=>A.at("^[\\w!#%&'*+\\-.^`|~]+$",!0))
s($,"FF","zu",()=>A.at('["\\x00-\\x1F\\x7F]',!0))
s($,"G_","zH",()=>A.at('[^()<>@,;:"\\\\/[\\]?={} \\t\\x00-\\x1F\\x7F]+',!0))
s($,"FM","zz",()=>A.at("(?:\\r\\n)?[ \\t]+",!0))
s($,"FP","zB",()=>A.at('"(?:[^"\\x00-\\x1F\\x7F\\\\]|\\\\.)*"',!0))
s($,"FO","zA",()=>A.at("\\\\(.)",!0))
s($,"FY","zF",()=>A.at('[()<>@,;:"\\\\/\\[\\]?={} \\t\\x00-\\x1F\\x7F]',!0))
s($,"G0","zI",()=>A.at("(?:"+$.zz().a+")*",!0))
s($,"F5","v9",()=>A.vr(""))
s($,"FW","wo",()=>new A.lY($.wi()))
s($,"Fe","zd",()=>new A.nR(A.at("/",!0),A.at("[^/]$",!0),A.at("^/",!0)))
s($,"Fg","kX",()=>new A.q9(A.at("[/\\\\]",!0),A.at("[^/\\\\]$",!0),A.at("^(\\\\\\\\[^\\\\]+\\\\[^\\\\/]+|[a-zA-Z]:[/\\\\])",!0),A.at("^[/\\\\](?![/\\\\])",!0)))
s($,"Ff","hM",()=>new A.pG(A.at("/",!0),A.at("(^[a-zA-Z][-+.a-zA-Z\\d]*://|[^/])$",!0),A.at("[a-zA-Z][-+.a-zA-Z\\d]*://[^/]*",!0),A.at("^/",!0)))
s($,"Fd","wi",()=>A.Bj())
s($,"FV","wn",()=>A.Di())
s($,"FL","dD",()=>$.wn())
s($,"FI","zw",()=>A.wU(A.yQ(),"SharedWorkerGlobalScope"))
s($,"FH","zv",()=>A.wU(A.yQ(),"DedicatedWorkerGlobalScope"))
s($,"EZ","kW",()=>$.zc())
s($,"Fr","wj",()=>new A.im(new WeakMap()))
s($,"FT","zE",()=>A.AK(A.u([A.vx("files"),A.vx("blocks")],t.s)))
s($,"F1","v8",()=>{var q,p,o=A.Z(t.N,A.ai("dO"))
for(q=0;q<2;++q){p=B.bi[q]
o.m(0,p.c,p)}return o})
s($,"FQ","zC",()=>A.B_())
r($,"Fs","hN",()=>{var q="navigator"
return A.AC(A.AD(A.uC(A.z1(),q),A.vx("locks")))?A.uC(A.uC(A.z1(),q),"locks"):null})})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({SharedArrayBuffer:A.dY,ArrayBuffer:A.bF,ArrayBufferView:A.fw,DataView:A.fv,Float32Array:A.iL,Float64Array:A.iM,Int16Array:A.iN,Int32Array:A.iO,Int8Array:A.iP,Uint16Array:A.iQ,Uint32Array:A.fx,Uint8ClampedArray:A.fy,CanvasPixelArray:A.fy,Uint8Array:A.d_})
hunkHelpers.setOrUpdateLeafTags({SharedArrayBuffer:true,ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.dZ.$nativeSuperclassTag="ArrayBufferView"
A.hi.$nativeSuperclassTag="ArrayBufferView"
A.hj.$nativeSuperclassTag="ArrayBufferView"
A.co.$nativeSuperclassTag="ArrayBufferView"
A.hk.$nativeSuperclassTag="ArrayBufferView"
A.hl.$nativeSuperclassTag="ArrayBufferView"
A.b2.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$2$2=function(a,b){return this(a,b)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$2$1=function(a){return this(a)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$3$1=function(a){return this(a)}
Function.prototype.$1$2=function(a,b){return this(a,b)}
Function.prototype.$2$0=function(){return this()}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$3$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$2$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$3$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
Function.prototype.$2$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$2$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$1$0=function(){return this()}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.EA
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=powersync_db.worker.js.map
