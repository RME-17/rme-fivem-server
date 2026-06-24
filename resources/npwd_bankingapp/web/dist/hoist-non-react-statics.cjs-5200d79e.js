import { g as D } from "./_commonjsHelpers-de833af9.js";
function g() {
  return g = Object.assign ? Object.assign.bind() : function(e) {
    for (var o = 1; o < arguments.length; o++) {
      var c = arguments[o];
      for (var f in c)
        ({}).hasOwnProperty.call(c, f) && (e[f] = c[f]);
    }
    return e;
  }, g.apply(null, arguments);
}
const k = Object.freeze(Object.defineProperty({ __proto__: null, get default() {
  return g;
} }, Symbol.toStringTag, { value: "Module" }));
var E = { exports: {} }, r = {};
/** @license React v16.13.1
* react-is.production.min.js
*
* Copyright (c) Facebook, Inc. and its affiliates.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
*/
var t = typeof Symbol == "function" && Symbol.for, P = t ? Symbol.for("react.element") : 60103, O = t ? Symbol.for("react.portal") : 60106, a = t ? Symbol.for("react.fragment") : 60107, i = t ? Symbol.for("react.strict_mode") : 60108, p = t ? Symbol.for("react.profiler") : 60114, y = t ? Symbol.for("react.provider") : 60109, l = t ? Symbol.for("react.context") : 60110, _ = t ? Symbol.for("react.async_mode") : 60111, m = t ? Symbol.for("react.concurrent_mode") : 60111, S = t ? Symbol.for("react.forward_ref") : 60112, d = t ? Symbol.for("react.suspense") : 60113, C = t ? Symbol.for("react.suspense_list") : 60120, b = t ? Symbol.for("react.memo") : 60115, v = t ? Symbol.for("react.lazy") : 60116, z = t ? Symbol.for("react.block") : 60121, L = t ? Symbol.for("react.fundamental") : 60117, W = t ? Symbol.for("react.responder") : 60118, q = t ? Symbol.for("react.scope") : 60119;
function n(e) {
  if (typeof e == "object" && e !== null) {
    var o = e.$$typeof;
    switch (o) {
      case P:
        switch (e = e.type, e) {
          case _:
          case m:
          case a:
          case p:
          case i:
          case d:
            return e;
          default:
            switch (e = e && e.$$typeof, e) {
              case l:
              case S:
              case v:
              case b:
              case y:
                return e;
              default:
                return o;
            }
        }
      case O:
        return o;
    }
  }
}
function F(e) {
  return n(e) === m;
}
r.AsyncMode = _;
r.ConcurrentMode = m;
r.ContextConsumer = l;
r.ContextProvider = y;
r.Element = P;
r.ForwardRef = S;
r.Fragment = a;
r.Lazy = v;
r.Memo = b;
r.Portal = O;
r.Profiler = p;
r.StrictMode = i;
r.Suspense = d;
r.isAsyncMode = function(e) {
  return F(e) || n(e) === _;
};
r.isConcurrentMode = F;
r.isContextConsumer = function(e) {
  return n(e) === l;
};
r.isContextProvider = function(e) {
  return n(e) === y;
};
r.isElement = function(e) {
  return typeof e == "object" && e !== null && e.$$typeof === P;
};
r.isForwardRef = function(e) {
  return n(e) === S;
};
r.isFragment = function(e) {
  return n(e) === a;
};
r.isLazy = function(e) {
  return n(e) === v;
};
r.isMemo = function(e) {
  return n(e) === b;
};
r.isPortal = function(e) {
  return n(e) === O;
};
r.isProfiler = function(e) {
  return n(e) === p;
};
r.isStrictMode = function(e) {
  return n(e) === i;
};
r.isSuspense = function(e) {
  return n(e) === d;
};
r.isValidElementType = function(e) {
  return typeof e == "string" || typeof e == "function" || e === a || e === m || e === p || e === i || e === d || e === C || typeof e == "object" && e !== null && (e.$$typeof === v || e.$$typeof === b || e.$$typeof === y || e.$$typeof === l || e.$$typeof === S || e.$$typeof === L || e.$$typeof === W || e.$$typeof === q || e.$$typeof === z);
};
r.typeOf = n;
E.exports = r;
var K = E.exports, T = K, V = { childContextTypes: true, contextType: true, contextTypes: true, defaultProps: true, displayName: true, getDefaultProps: true, getDerivedStateFromError: true, getDerivedStateFromProps: true, mixins: true, propTypes: true, type: true }, Y = { name: true, length: true, prototype: true, caller: true, callee: true, arguments: true, arity: true }, B = { $$typeof: true, render: true, defaultProps: true, displayName: true, propTypes: true }, I = { $$typeof: true, compare: true, defaultProps: true, displayName: true, propTypes: true, type: true }, x = {};
x[T.ForwardRef] = B;
x[T.Memo] = I;
function M(e) {
  return T.isMemo(e) ? I : x[e.$$typeof] || V;
}
var G = Object.defineProperty, H = Object.getOwnPropertyNames, h = Object.getOwnPropertySymbols, J = Object.getOwnPropertyDescriptor, Q = Object.getPrototypeOf, A = Object.prototype;
function N(e, o, c) {
  if (typeof o != "string") {
    if (A) {
      var f = Q(o);
      f && f !== A && N(e, f, c);
    }
    var s = H(o);
    h && (s = s.concat(h(o)));
    for (var j = M(e), w = M(o), $ = 0; $ < s.length; ++$) {
      var u = s[$];
      if (!Y[u] && !(c && c[u]) && !(w && w[u]) && !(j && j[u])) {
        var R = J(o, u);
        try {
          G(e, u, R);
        } catch {
        }
      }
    }
  }
  return e;
}
var U = N;
const ee = D(U);
export {
  g as _,
  k as a,
  ee as h
};
