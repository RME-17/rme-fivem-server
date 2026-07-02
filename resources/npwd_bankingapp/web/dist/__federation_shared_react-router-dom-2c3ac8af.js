import { importShared as Fe, __tla as __tla_0 } from "./__federation_fn_import-39357cc7.js";
import { _ as G, a as re } from "./inheritsLoose-cd9c12f4.js";
import { g as ke } from "./_commonjsHelpers-de833af9.js";
import { _ as M, h as ot } from "./hoist-non-react-statics.cjs-5200d79e.js";
let mn, gn, Zt, on, yn, sn, cn, un, ce, fn, ln, _e, ue, pn, Xt, vn, dn, hn;
let __tla = Promise.all([
  (() => {
    try {
      return __tla_0;
    } catch {
    }
  })()
]).then(async () => {
  var qe = {
    exports: {}
  }, st = "SECRET_DO_NOT_PASS_THIS_OR_YOU_WILL_BE_FIRED", ct = st, ut = ct;
  function Ke() {
  }
  function Ge() {
  }
  Ge.resetWarningCache = Ke;
  var ft = function() {
    function e(i, r, a, c, s, f) {
      if (f !== ut) {
        var o = new Error("Calling PropTypes validators directly is not supported by the `prop-types` package. Use PropTypes.checkPropTypes() to call them. Read more at http://fb.me/use-check-prop-types");
        throw o.name = "Invariant Violation", o;
      }
    }
    e.isRequired = e;
    function t() {
      return e;
    }
    var n = {
      array: e,
      bigint: e,
      bool: e,
      func: e,
      number: e,
      object: e,
      string: e,
      symbol: e,
      any: e,
      arrayOf: t,
      element: e,
      elementType: e,
      instanceOf: t,
      node: e,
      objectOf: t,
      oneOf: t,
      oneOfType: t,
      shape: t,
      exact: t,
      checkPropTypes: Ge,
      resetWarningCache: Ke
    };
    return n.PropTypes = n, n;
  };
  qe.exports = ft();
  var lt = qe.exports;
  const Le = ke(lt);
  function ie(e) {
    return e.charAt(0) === "/";
  }
  function he(e, t) {
    for (var n = t, i = n + 1, r = e.length; i < r; n += 1, i += 1)
      e[n] = e[i];
    e.pop();
  }
  function ht(e, t) {
    t === void 0 && (t = "");
    var n = e && e.split("/") || [], i = t && t.split("/") || [], r = e && ie(e), a = t && ie(t), c = r || a;
    if (e && ie(e) ? i = n : n.length && (i.pop(), i = i.concat(n)), !i.length)
      return "/";
    var s;
    if (i.length) {
      var f = i[i.length - 1];
      s = f === "." || f === ".." || f === "";
    } else
      s = false;
    for (var o = 0, u = i.length; u >= 0; u--) {
      var l = i[u];
      l === "." ? he(i, u) : l === ".." ? (he(i, u), o++) : o && (he(i, u), o--);
    }
    if (!c)
      for (; o--; o)
        i.unshift("..");
    c && i[0] !== "" && (!i[0] || !ie(i[0])) && i.unshift("");
    var h = i.join("/");
    return s && h.substr(-1) !== "/" && (h += "/"), h;
  }
  function Ae(e) {
    return e.valueOf ? e.valueOf() : Object.prototype.valueOf.call(e);
  }
  function ae(e, t) {
    if (e === t)
      return true;
    if (e == null || t == null)
      return false;
    if (Array.isArray(e))
      return Array.isArray(t) && e.length === t.length && e.every(function(r, a) {
        return ae(r, t[a]);
      });
    if (typeof e == "object" || typeof t == "object") {
      var n = Ae(e), i = Ae(t);
      return n !== e || i !== t ? ae(n, i) : Object.keys(Object.assign({}, e, t)).every(function(r) {
        return ae(e[r], t[r]);
      });
    }
    return false;
  }
  var pt = true, pe = "Invariant failed";
  function V(e, t) {
    if (!e) {
      if (pt)
        throw new Error(pe);
      var n = typeof t == "function" ? t() : t, i = n ? "".concat(pe, ": ").concat(n) : pe;
      throw new Error(i);
    }
  }
  function ne(e) {
    return e.charAt(0) === "/" ? e : "/" + e;
  }
  function Oe(e) {
    return e.charAt(0) === "/" ? e.substr(1) : e;
  }
  function vt(e, t) {
    return e.toLowerCase().indexOf(t.toLowerCase()) === 0 && "/?#".indexOf(e.charAt(t.length)) !== -1;
  }
  function Ve(e, t) {
    return vt(e, t) ? e.substr(t.length) : e;
  }
  function ze(e) {
    return e.charAt(e.length - 1) === "/" ? e.slice(0, -1) : e;
  }
  function dt(e) {
    var t = e || "/", n = "", i = "", r = t.indexOf("#");
    r !== -1 && (i = t.substr(r), t = t.substr(0, r));
    var a = t.indexOf("?");
    return a !== -1 && (n = t.substr(a), t = t.substr(0, a)), {
      pathname: t,
      search: n === "?" ? "" : n,
      hash: i === "#" ? "" : i
    };
  }
  function B(e) {
    var t = e.pathname, n = e.search, i = e.hash, r = t || "/";
    return n && n !== "?" && (r += n.charAt(0) === "?" ? n : "?" + n), i && i !== "#" && (r += i.charAt(0) === "#" ? i : "#" + i), r;
  }
  function I(e, t, n, i) {
    var r;
    typeof e == "string" ? (r = dt(e), r.state = t) : (r = M({}, e), r.pathname === void 0 && (r.pathname = ""), r.search ? r.search.charAt(0) !== "?" && (r.search = "?" + r.search) : r.search = "", r.hash ? r.hash.charAt(0) !== "#" && (r.hash = "#" + r.hash) : r.hash = "", t !== void 0 && r.state === void 0 && (r.state = t));
    try {
      r.pathname = decodeURI(r.pathname);
    } catch (a) {
      throw a instanceof URIError ? new URIError('Pathname "' + r.pathname + '" could not be decoded. This is likely caused by an invalid percent-encoding.') : a;
    }
    return n && (r.key = n), i ? r.pathname ? r.pathname.charAt(0) !== "/" && (r.pathname = ht(r.pathname, i.pathname)) : r.pathname = i.pathname : r.pathname || (r.pathname = "/"), r;
  }
  function mt(e, t) {
    return e.pathname === t.pathname && e.search === t.search && e.hash === t.hash && e.key === t.key && ae(e.state, t.state);
  }
  function xe() {
    var e = null;
    function t(c) {
      return e = c, function() {
        e === c && (e = null);
      };
    }
    function n(c, s, f, o) {
      if (e != null) {
        var u = typeof e == "function" ? e(c, s) : e;
        typeof u == "string" ? typeof f == "function" ? f(u, o) : o(true) : o(u !== false);
      } else
        o(true);
    }
    var i = [];
    function r(c) {
      var s = true;
      function f() {
        s && c.apply(void 0, arguments);
      }
      return i.push(f), function() {
        s = false, i = i.filter(function(o) {
          return o !== f;
        });
      };
    }
    function a() {
      for (var c = arguments.length, s = new Array(c), f = 0; f < c; f++)
        s[f] = arguments[f];
      i.forEach(function(o) {
        return o.apply(void 0, s);
      });
    }
    return {
      setPrompt: t,
      confirmTransitionTo: n,
      appendListener: r,
      notifyListeners: a
    };
  }
  var Je = !!(typeof window < "u" && window.document && window.document.createElement);
  function Xe(e, t) {
    t(window.confirm(e));
  }
  function gt() {
    var e = window.navigator.userAgent;
    return (e.indexOf("Android 2.") !== -1 || e.indexOf("Android 4.0") !== -1) && e.indexOf("Mobile Safari") !== -1 && e.indexOf("Chrome") === -1 && e.indexOf("Windows Phone") === -1 ? false : window.history && "pushState" in window.history;
  }
  function yt() {
    return window.navigator.userAgent.indexOf("Trident") === -1;
  }
  function wt() {
    return window.navigator.userAgent.indexOf("Firefox") === -1;
  }
  function xt(e) {
    return e.state === void 0 && navigator.userAgent.indexOf("CriOS") === -1;
  }
  var Se = "popstate", Ue = "hashchange";
  function Me() {
    try {
      return window.history.state || {};
    } catch {
      return {};
    }
  }
  function Pt(e) {
    e === void 0 && (e = {}), Je || V(false);
    var t = window.history, n = gt(), i = !yt(), r = e, a = r.forceRefresh, c = a === void 0 ? false : a, s = r.getUserConfirmation, f = s === void 0 ? Xe : s, o = r.keyLength, u = o === void 0 ? 6 : o, l = e.basename ? ze(ne(e.basename)) : "";
    function h(d) {
      var p = d || {}, w = p.key, m = p.state, E = window.location, U = E.pathname, W = E.search, q = E.hash, F = U + W + q;
      return l && (F = Ve(F, l)), I(F, m, w);
    }
    function v() {
      return Math.random().toString(36).substr(2, u);
    }
    var g = xe();
    function C(d) {
      M(j, d), j.length = t.length, g.notifyListeners(j.location, j.action);
    }
    function T(d) {
      xt(d) || N(h(d.state));
    }
    function b() {
      N(h(Me()));
    }
    var S = false;
    function N(d) {
      if (S)
        S = false, C();
      else {
        var p = "POP";
        g.confirmTransitionTo(d, p, f, function(w) {
          w ? C({
            action: p,
            location: d
          }) : _(d);
        });
      }
    }
    function _(d) {
      var p = j.location, w = R.indexOf(p.key);
      w === -1 && (w = 0);
      var m = R.indexOf(d.key);
      m === -1 && (m = 0);
      var E = w - m;
      E && (S = true, L(E));
    }
    var H = h(Me()), R = [
      H.key
    ];
    function y(d) {
      return l + B(d);
    }
    function x(d, p) {
      var w = "PUSH", m = I(d, p, v(), j.location);
      g.confirmTransitionTo(m, w, f, function(E) {
        if (E) {
          var U = y(m), W = m.key, q = m.state;
          if (n)
            if (t.pushState({
              key: W,
              state: q
            }, null, U), c)
              window.location.href = U;
            else {
              var F = R.indexOf(j.location.key), X = R.slice(0, F + 1);
              X.push(m.key), R = X, C({
                action: w,
                location: m
              });
            }
          else
            window.location.href = U;
        }
      });
    }
    function O(d, p) {
      var w = "REPLACE", m = I(d, p, v(), j.location);
      g.confirmTransitionTo(m, w, f, function(E) {
        if (E) {
          var U = y(m), W = m.key, q = m.state;
          if (n)
            if (t.replaceState({
              key: W,
              state: q
            }, null, U), c)
              window.location.replace(U);
            else {
              var F = R.indexOf(j.location.key);
              F !== -1 && (R[F] = m.key), C({
                action: w,
                location: m
              });
            }
          else
            window.location.replace(U);
        }
      });
    }
    function L(d) {
      t.go(d);
    }
    function A() {
      L(-1);
    }
    function z() {
      L(1);
    }
    var J = 0;
    function D(d) {
      J += d, J === 1 && d === 1 ? (window.addEventListener(Se, T), i && window.addEventListener(Ue, b)) : J === 0 && (window.removeEventListener(Se, T), i && window.removeEventListener(Ue, b));
    }
    var $ = false;
    function Q(d) {
      d === void 0 && (d = false);
      var p = g.setPrompt(d);
      return $ || (D(1), $ = true), function() {
        return $ && ($ = false, D(-1)), p();
      };
    }
    function le(d) {
      var p = g.appendListener(d);
      return D(1), function() {
        D(-1), p();
      };
    }
    var j = {
      length: t.length,
      action: "POP",
      location: H,
      createHref: y,
      push: x,
      replace: O,
      go: L,
      goBack: A,
      goForward: z,
      block: Q,
      listen: le
    };
    return j;
  }
  var He = "hashchange", Et = {
    hashbang: {
      encodePath: function(t) {
        return t.charAt(0) === "!" ? t : "!/" + Oe(t);
      },
      decodePath: function(t) {
        return t.charAt(0) === "!" ? t.substr(1) : t;
      }
    },
    noslash: {
      encodePath: Oe,
      decodePath: ne
    },
    slash: {
      encodePath: ne,
      decodePath: ne
    }
  };
  function Ye(e) {
    var t = e.indexOf("#");
    return t === -1 ? e : e.slice(0, t);
  }
  function te() {
    var e = window.location.href, t = e.indexOf("#");
    return t === -1 ? "" : e.substring(t + 1);
  }
  function Ct(e) {
    window.location.hash = e;
  }
  function ve(e) {
    window.location.replace(Ye(window.location.href) + "#" + e);
  }
  function Tt(e) {
    e === void 0 && (e = {}), Je || V(false);
    var t = window.history;
    wt();
    var n = e, i = n.getUserConfirmation, r = i === void 0 ? Xe : i, a = n.hashType, c = a === void 0 ? "slash" : a, s = e.basename ? ze(ne(e.basename)) : "", f = Et[c], o = f.encodePath, u = f.decodePath;
    function l() {
      var p = u(te());
      return s && (p = Ve(p, s)), I(p);
    }
    var h = xe();
    function v(p) {
      M(d, p), d.length = t.length, h.notifyListeners(d.location, d.action);
    }
    var g = false, C = null;
    function T(p, w) {
      return p.pathname === w.pathname && p.search === w.search && p.hash === w.hash;
    }
    function b() {
      var p = te(), w = o(p);
      if (p !== w)
        ve(w);
      else {
        var m = l(), E = d.location;
        if (!g && T(E, m) || C === B(m))
          return;
        C = null, S(m);
      }
    }
    function S(p) {
      if (g)
        g = false, v();
      else {
        var w = "POP";
        h.confirmTransitionTo(p, w, r, function(m) {
          m ? v({
            action: w,
            location: p
          }) : N(p);
        });
      }
    }
    function N(p) {
      var w = d.location, m = y.lastIndexOf(B(w));
      m === -1 && (m = 0);
      var E = y.lastIndexOf(B(p));
      E === -1 && (E = 0);
      var U = m - E;
      U && (g = true, A(U));
    }
    var _ = te(), H = o(_);
    _ !== H && ve(H);
    var R = l(), y = [
      B(R)
    ];
    function x(p) {
      var w = document.querySelector("base"), m = "";
      return w && w.getAttribute("href") && (m = Ye(window.location.href)), m + "#" + o(s + B(p));
    }
    function O(p, w) {
      var m = "PUSH", E = I(p, void 0, void 0, d.location);
      h.confirmTransitionTo(E, m, r, function(U) {
        if (U) {
          var W = B(E), q = o(s + W), F = te() !== q;
          if (F) {
            C = W, Ct(q);
            var X = y.lastIndexOf(B(d.location)), be = y.slice(0, X + 1);
            be.push(W), y = be, v({
              action: m,
              location: E
            });
          } else
            v();
        }
      });
    }
    function L(p, w) {
      var m = "REPLACE", E = I(p, void 0, void 0, d.location);
      h.confirmTransitionTo(E, m, r, function(U) {
        if (U) {
          var W = B(E), q = o(s + W), F = te() !== q;
          F && (C = W, ve(q));
          var X = y.indexOf(B(d.location));
          X !== -1 && (y[X] = W), v({
            action: m,
            location: E
          });
        }
      });
    }
    function A(p) {
      t.go(p);
    }
    function z() {
      A(-1);
    }
    function J() {
      A(1);
    }
    var D = 0;
    function $(p) {
      D += p, D === 1 && p === 1 ? window.addEventListener(He, b) : D === 0 && window.removeEventListener(He, b);
    }
    var Q = false;
    function le(p) {
      p === void 0 && (p = false);
      var w = h.setPrompt(p);
      return Q || ($(1), Q = true), function() {
        return Q && (Q = false, $(-1)), w();
      };
    }
    function j(p) {
      var w = h.appendListener(p);
      return $(1), function() {
        $(-1), w();
      };
    }
    var d = {
      length: t.length,
      action: "POP",
      location: R,
      createHref: x,
      push: O,
      replace: L,
      go: A,
      goBack: z,
      goForward: J,
      block: le,
      listen: j
    };
    return d;
  }
  function $e(e, t, n) {
    return Math.min(Math.max(e, t), n);
  }
  function Rt(e) {
    e === void 0 && (e = {});
    var t = e, n = t.getUserConfirmation, i = t.initialEntries, r = i === void 0 ? [
      "/"
    ] : i, a = t.initialIndex, c = a === void 0 ? 0 : a, s = t.keyLength, f = s === void 0 ? 6 : s, o = xe();
    function u(x) {
      M(y, x), y.length = y.entries.length, o.notifyListeners(y.location, y.action);
    }
    function l() {
      return Math.random().toString(36).substr(2, f);
    }
    var h = $e(c, 0, r.length - 1), v = r.map(function(x) {
      return typeof x == "string" ? I(x, void 0, l()) : I(x, void 0, x.key || l());
    }), g = B;
    function C(x, O) {
      var L = "PUSH", A = I(x, O, l(), y.location);
      o.confirmTransitionTo(A, L, n, function(z) {
        if (z) {
          var J = y.index, D = J + 1, $ = y.entries.slice(0);
          $.length > D ? $.splice(D, $.length - D, A) : $.push(A), u({
            action: L,
            location: A,
            index: D,
            entries: $
          });
        }
      });
    }
    function T(x, O) {
      var L = "REPLACE", A = I(x, O, l(), y.location);
      o.confirmTransitionTo(A, L, n, function(z) {
        z && (y.entries[y.index] = A, u({
          action: L,
          location: A
        }));
      });
    }
    function b(x) {
      var O = $e(y.index + x, 0, y.entries.length - 1), L = "POP", A = y.entries[O];
      o.confirmTransitionTo(A, L, n, function(z) {
        z ? u({
          action: L,
          location: A,
          index: O
        }) : u();
      });
    }
    function S() {
      b(-1);
    }
    function N() {
      b(1);
    }
    function _(x) {
      var O = y.index + x;
      return O >= 0 && O < y.entries.length;
    }
    function H(x) {
      return x === void 0 && (x = false), o.setPrompt(x);
    }
    function R(x) {
      return o.appendListener(x);
    }
    var y = {
      length: v.length,
      action: "POP",
      location: v[h],
      index: h,
      entries: v,
      createHref: g,
      push: C,
      replace: T,
      go: b,
      goBack: S,
      goForward: N,
      canGo: _,
      block: H,
      listen: R
    };
    return y;
  }
  var ee = {
    exports: {}
  }, bt = Array.isArray || function(e) {
    return Object.prototype.toString.call(e) == "[object Array]";
  }, oe = bt;
  ee.exports = et;
  ee.exports.parse = Pe;
  ee.exports.compile = Ot;
  ee.exports.tokensToFunction = Qe;
  ee.exports.tokensToRegExp = Ze;
  var Lt = new RegExp([
    "(\\\\.)",
    "([\\/.])?(?:(?:\\:(\\w+)(?:\\(((?:\\\\.|[^\\\\()])+)\\))?|\\(((?:\\\\.|[^\\\\()])+)\\))([+*?])?|(\\*))"
  ].join("|"), "g");
  function Pe(e, t) {
    for (var n = [], i = 0, r = 0, a = "", c = t && t.delimiter || "/", s; (s = Lt.exec(e)) != null; ) {
      var f = s[0], o = s[1], u = s.index;
      if (a += e.slice(r, u), r = u + f.length, o) {
        a += o[1];
        continue;
      }
      var l = e[r], h = s[2], v = s[3], g = s[4], C = s[5], T = s[6], b = s[7];
      a && (n.push(a), a = "");
      var S = h != null && l != null && l !== h, N = T === "+" || T === "*", _ = T === "?" || T === "*", H = h || c, R = g || C, y = h || (typeof n[n.length - 1] == "string" ? n[n.length - 1] : "");
      n.push({
        name: v || i++,
        prefix: h || "",
        delimiter: H,
        optional: _,
        repeat: N,
        partial: S,
        asterisk: !!b,
        pattern: R ? Mt(R) : b ? ".*" : At(H, y)
      });
    }
    return r < e.length && (a += e.substr(r)), a && n.push(a), n;
  }
  function At(e, t) {
    return !t || t.indexOf(e) > -1 ? "[^" + Y(e) + "]+?" : Y(t) + "|(?:(?!" + Y(t) + ")[^" + Y(e) + "])+?";
  }
  function Ot(e, t) {
    return Qe(Pe(e, t), t);
  }
  function St(e) {
    return encodeURI(e).replace(/[\/?#]/g, function(t) {
      return "%" + t.charCodeAt(0).toString(16).toUpperCase();
    });
  }
  function Ut(e) {
    return encodeURI(e).replace(/[?#]/g, function(t) {
      return "%" + t.charCodeAt(0).toString(16).toUpperCase();
    });
  }
  function Qe(e, t) {
    for (var n = new Array(e.length), i = 0; i < e.length; i++)
      typeof e[i] == "object" && (n[i] = new RegExp("^(?:" + e[i].pattern + ")$", Ce(t)));
    return function(r, a) {
      for (var c = "", s = r || {}, f = a || {}, o = f.pretty ? St : encodeURIComponent, u = 0; u < e.length; u++) {
        var l = e[u];
        if (typeof l == "string") {
          c += l;
          continue;
        }
        var h = s[l.name], v;
        if (h == null)
          if (l.optional) {
            l.partial && (c += l.prefix);
            continue;
          } else
            throw new TypeError('Expected "' + l.name + '" to be defined');
        if (oe(h)) {
          if (!l.repeat)
            throw new TypeError('Expected "' + l.name + '" to not repeat, but received `' + JSON.stringify(h) + "`");
          if (h.length === 0) {
            if (l.optional)
              continue;
            throw new TypeError('Expected "' + l.name + '" to not be empty');
          }
          for (var g = 0; g < h.length; g++) {
            if (v = o(h[g]), !n[u].test(v))
              throw new TypeError('Expected all "' + l.name + '" to match "' + l.pattern + '", but received `' + JSON.stringify(v) + "`");
            c += (g === 0 ? l.prefix : l.delimiter) + v;
          }
          continue;
        }
        if (v = l.asterisk ? Ut(h) : o(h), !n[u].test(v))
          throw new TypeError('Expected "' + l.name + '" to match "' + l.pattern + '", but received "' + v + '"');
        c += l.prefix + v;
      }
      return c;
    };
  }
  function Y(e) {
    return e.replace(/([.+*?=^!:${}()[\]|\/\\])/g, "\\$1");
  }
  function Mt(e) {
    return e.replace(/([=!:$\/()])/g, "\\$1");
  }
  function Ee(e, t) {
    return e.keys = t, e;
  }
  function Ce(e) {
    return e && e.sensitive ? "" : "i";
  }
  function Ht(e, t) {
    var n = e.source.match(/\((?!\?)/g);
    if (n)
      for (var i = 0; i < n.length; i++)
        t.push({
          name: i,
          prefix: null,
          delimiter: null,
          optional: false,
          repeat: false,
          partial: false,
          asterisk: false,
          pattern: null
        });
    return Ee(e, t);
  }
  function $t(e, t, n) {
    for (var i = [], r = 0; r < e.length; r++)
      i.push(et(e[r], t, n).source);
    var a = new RegExp("(?:" + i.join("|") + ")", Ce(n));
    return Ee(a, t);
  }
  function It(e, t, n) {
    return Ze(Pe(e, n), t, n);
  }
  function Ze(e, t, n) {
    oe(t) || (n = t || n, t = []), n = n || {};
    for (var i = n.strict, r = n.end !== false, a = "", c = 0; c < e.length; c++) {
      var s = e[c];
      if (typeof s == "string")
        a += Y(s);
      else {
        var f = Y(s.prefix), o = "(?:" + s.pattern + ")";
        t.push(s), s.repeat && (o += "(?:" + f + o + ")*"), s.optional ? s.partial ? o = f + "(" + o + ")?" : o = "(?:" + f + "(" + o + "))?" : o = f + "(" + o + ")", a += o;
      }
    }
    var u = Y(n.delimiter || "/"), l = a.slice(-u.length) === u;
    return i || (a = (l ? a.slice(0, -u.length) : a) + "(?:" + u + "(?=$))?"), r ? a += "$" : a += i && l ? "" : "(?=" + u + "|$)", Ee(new RegExp("^" + a, Ce(n)), t);
  }
  function et(e, t, n) {
    return oe(t) || (n = t || n, t = []), n = n || {}, e instanceof RegExp ? Ht(e, t) : oe(e) ? $t(e, t, n) : It(e, t, n);
  }
  var Nt = ee.exports;
  const tt = ke(Nt), P = await Fe("react");
  var de = 1073741823, Ie = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : {};
  function _t() {
    var e = "__global_unique_id__";
    return Ie[e] = (Ie[e] || 0) + 1;
  }
  function Bt(e, t) {
    return e === t ? e !== 0 || 1 / e === 1 / t : e !== e && t !== t;
  }
  function Dt(e) {
    var t = [];
    return {
      on: function(i) {
        t.push(i);
      },
      off: function(i) {
        t = t.filter(function(r) {
          return r !== i;
        });
      },
      get: function() {
        return e;
      },
      set: function(i, r) {
        e = i, t.forEach(function(a) {
          return a(e, r);
        });
      }
    };
  }
  function Wt(e) {
    return Array.isArray(e) ? e[0] : e;
  }
  function jt(e, t) {
    var n, i, r = "__create-react-context-" + _t() + "__", a = function(s) {
      G(f, s);
      function f() {
        for (var u, l = arguments.length, h = new Array(l), v = 0; v < l; v++)
          h[v] = arguments[v];
        return u = s.call.apply(s, [
          this
        ].concat(h)) || this, u.emitter = Dt(u.props.value), u;
      }
      var o = f.prototype;
      return o.getChildContext = function() {
        var l;
        return l = {}, l[r] = this.emitter, l;
      }, o.componentWillReceiveProps = function(l) {
        if (this.props.value !== l.value) {
          var h = this.props.value, v = l.value, g;
          Bt(h, v) ? g = 0 : (g = typeof t == "function" ? t(h, v) : de, g |= 0, g !== 0 && this.emitter.set(l.value, g));
        }
      }, o.render = function() {
        return this.props.children;
      }, f;
    }(P.Component);
    a.childContextTypes = (n = {}, n[r] = Le.object.isRequired, n);
    var c = function(s) {
      G(f, s);
      function f() {
        for (var u, l = arguments.length, h = new Array(l), v = 0; v < l; v++)
          h[v] = arguments[v];
        return u = s.call.apply(s, [
          this
        ].concat(h)) || this, u.observedBits = void 0, u.state = {
          value: u.getValue()
        }, u.onUpdate = function(g, C) {
          var T = u.observedBits | 0;
          T & C && u.setState({
            value: u.getValue()
          });
        }, u;
      }
      var o = f.prototype;
      return o.componentWillReceiveProps = function(l) {
        var h = l.observedBits;
        this.observedBits = h ?? de;
      }, o.componentDidMount = function() {
        this.context[r] && this.context[r].on(this.onUpdate);
        var l = this.props.observedBits;
        this.observedBits = l ?? de;
      }, o.componentWillUnmount = function() {
        this.context[r] && this.context[r].off(this.onUpdate);
      }, o.getValue = function() {
        return this.context[r] ? this.context[r].get() : e;
      }, o.render = function() {
        return Wt(this.props.children)(this.state.value);
      }, f;
    }(P.Component);
    return c.contextTypes = (i = {}, i[r] = Le.object, i), {
      Provider: a,
      Consumer: c
    };
  }
  let Ft, nt, rt, k, it;
  Ft = P.createContext || jt;
  nt = function(t) {
    var n = Ft();
    return n.displayName = t, n;
  };
  rt = nt("Router-History");
  k = nt("Router");
  ce = function(e) {
    G(t, e), t.computeRootMatch = function(r) {
      return {
        path: "/",
        url: "/",
        params: {},
        isExact: r === "/"
      };
    };
    function t(i) {
      var r;
      return r = e.call(this, i) || this, r.state = {
        location: i.history.location
      }, r._isMounted = false, r._pendingLocation = null, i.staticContext || (r.unlisten = i.history.listen(function(a) {
        r._pendingLocation = a;
      })), r;
    }
    var n = t.prototype;
    return n.componentDidMount = function() {
      var r = this;
      this._isMounted = true, this.unlisten && this.unlisten(), this.props.staticContext || (this.unlisten = this.props.history.listen(function(a) {
        r._isMounted && r.setState({
          location: a
        });
      })), this._pendingLocation && this.setState({
        location: this._pendingLocation
      });
    }, n.componentWillUnmount = function() {
      this.unlisten && (this.unlisten(), this._isMounted = false, this._pendingLocation = null);
    }, n.render = function() {
      return P.createElement(k.Provider, {
        value: {
          history: this.props.history,
          location: this.state.location,
          match: t.computeRootMatch(this.state.location.pathname),
          staticContext: this.props.staticContext
        }
      }, P.createElement(rt.Provider, {
        children: this.props.children || null,
        value: this.props.history
      }));
    }, t;
  }(P.Component);
  on = function(e) {
    G(t, e);
    function t() {
      for (var i, r = arguments.length, a = new Array(r), c = 0; c < r; c++)
        a[c] = arguments[c];
      return i = e.call.apply(e, [
        this
      ].concat(a)) || this, i.history = Rt(i.props), i;
    }
    var n = t.prototype;
    return n.render = function() {
      return P.createElement(ce, {
        history: this.history,
        children: this.props.children
      });
    }, t;
  }(P.Component);
  it = function(e) {
    G(t, e);
    function t() {
      return e.apply(this, arguments) || this;
    }
    var n = t.prototype;
    return n.componentDidMount = function() {
      this.props.onMount && this.props.onMount.call(this, this);
    }, n.componentDidUpdate = function(r) {
      this.props.onUpdate && this.props.onUpdate.call(this, this, r);
    }, n.componentWillUnmount = function() {
      this.props.onUnmount && this.props.onUnmount.call(this, this);
    }, n.render = function() {
      return null;
    }, t;
  }(P.Component);
  sn = function(e) {
    var t = e.message, n = e.when, i = n === void 0 ? true : n;
    return P.createElement(k.Consumer, null, function(r) {
      if (r || V(false), !i || r.staticContext)
        return null;
      var a = r.history.block;
      return P.createElement(it, {
        onMount: function(s) {
          s.release = a(t);
        },
        onUpdate: function(s, f) {
          f.message !== t && (s.release(), s.release = a(t));
        },
        onUnmount: function(s) {
          s.release();
        },
        message: t
      });
    });
  };
  var me = {}, kt = 1e4, Ne = 0;
  function qt(e) {
    if (me[e])
      return me[e];
    var t = tt.compile(e);
    return Ne < kt && (me[e] = t, Ne++), t;
  }
  _e = function(e, t) {
    return e === void 0 && (e = "/"), t === void 0 && (t = {}), e === "/" ? e : qt(e)(t, {
      pretty: true
    });
  };
  cn = function(e) {
    var t = e.computedMatch, n = e.to, i = e.push, r = i === void 0 ? false : i;
    return P.createElement(k.Consumer, null, function(a) {
      a || V(false);
      var c = a.history, s = a.staticContext, f = r ? c.push : c.replace, o = I(t ? typeof n == "string" ? _e(n, t.params) : M({}, n, {
        pathname: _e(n.pathname, t.params)
      }) : n);
      return s ? (f(o), null) : P.createElement(it, {
        onMount: function() {
          f(o);
        },
        onUpdate: function(l, h) {
          var v = I(h.to);
          mt(v, M({}, o, {
            key: v.key
          })) || f(o);
        },
        to: n
      });
    });
  };
  var Be = {}, Kt = 1e4, De = 0;
  function Gt(e, t) {
    var n = "" + t.end + t.strict + t.sensitive, i = Be[n] || (Be[n] = {});
    if (i[e])
      return i[e];
    var r = [], a = tt(e, r, t), c = {
      regexp: a,
      keys: r
    };
    return De < Kt && (i[e] = c, De++), c;
  }
  ue = function(e, t) {
    t === void 0 && (t = {}), (typeof t == "string" || Array.isArray(t)) && (t = {
      path: t
    });
    var n = t, i = n.path, r = n.exact, a = r === void 0 ? false : r, c = n.strict, s = c === void 0 ? false : c, f = n.sensitive, o = f === void 0 ? false : f, u = [].concat(i);
    return u.reduce(function(l, h) {
      if (!h && h !== "")
        return null;
      if (l)
        return l;
      var v = Gt(h, {
        end: a,
        strict: s,
        sensitive: o
      }), g = v.regexp, C = v.keys, T = g.exec(e);
      if (!T)
        return null;
      var b = T[0], S = T.slice(1), N = e === b;
      return a && !N ? null : {
        path: h,
        url: h === "/" && b === "" ? "/" : b,
        isExact: N,
        params: C.reduce(function(_, H, R) {
          return _[H.name] = S[R], _;
        }, {})
      };
    }, null);
  };
  function Vt(e) {
    return P.Children.count(e) === 0;
  }
  un = function(e) {
    G(t, e);
    function t() {
      return e.apply(this, arguments) || this;
    }
    var n = t.prototype;
    return n.render = function() {
      var r = this;
      return P.createElement(k.Consumer, null, function(a) {
        a || V(false);
        var c = r.props.location || a.location, s = r.props.computedMatch ? r.props.computedMatch : r.props.path ? ue(c.pathname, r.props) : a.match, f = M({}, a, {
          location: c,
          match: s
        }), o = r.props, u = o.children, l = o.component, h = o.render;
        return Array.isArray(u) && Vt(u) && (u = null), P.createElement(k.Provider, {
          value: f
        }, f.match ? u ? typeof u == "function" ? u(f) : u : l ? P.createElement(l, f) : h ? h(f) : null : typeof u == "function" ? u(f) : null);
      });
    }, t;
  }(P.Component);
  function Te(e) {
    return e.charAt(0) === "/" ? e : "/" + e;
  }
  function zt(e, t) {
    return e ? M({}, t, {
      pathname: Te(e) + t.pathname
    }) : t;
  }
  function Jt(e, t) {
    if (!e)
      return t;
    var n = Te(e);
    return t.pathname.indexOf(n) !== 0 ? t : M({}, t, {
      pathname: t.pathname.substr(n.length)
    });
  }
  function We(e) {
    return typeof e == "string" ? e : B(e);
  }
  function ge(e) {
    return function() {
      V(false);
    };
  }
  function je() {
  }
  fn = function(e) {
    G(t, e);
    function t() {
      for (var i, r = arguments.length, a = new Array(r), c = 0; c < r; c++)
        a[c] = arguments[c];
      return i = e.call.apply(e, [
        this
      ].concat(a)) || this, i.handlePush = function(s) {
        return i.navigateTo(s, "PUSH");
      }, i.handleReplace = function(s) {
        return i.navigateTo(s, "REPLACE");
      }, i.handleListen = function() {
        return je;
      }, i.handleBlock = function() {
        return je;
      }, i;
    }
    var n = t.prototype;
    return n.navigateTo = function(r, a) {
      var c = this.props, s = c.basename, f = s === void 0 ? "" : s, o = c.context, u = o === void 0 ? {} : o;
      u.action = a, u.location = zt(f, I(r)), u.url = We(u.location);
    }, n.render = function() {
      var r = this.props, a = r.basename, c = a === void 0 ? "" : a, s = r.context, f = s === void 0 ? {} : s, o = r.location, u = o === void 0 ? "/" : o, l = re(r, [
        "basename",
        "context",
        "location"
      ]), h = {
        createHref: function(g) {
          return Te(c + We(g));
        },
        action: "POP",
        location: Jt(c, I(u)),
        push: this.handlePush,
        replace: this.handleReplace,
        go: ge(),
        goBack: ge(),
        goForward: ge(),
        listen: this.handleListen,
        block: this.handleBlock
      };
      return P.createElement(ce, M({}, l, {
        history: h,
        staticContext: f
      }));
    }, t;
  }(P.Component);
  ln = function(e) {
    G(t, e);
    function t() {
      return e.apply(this, arguments) || this;
    }
    var n = t.prototype;
    return n.render = function() {
      var r = this;
      return P.createElement(k.Consumer, null, function(a) {
        a || V(false);
        var c = r.props.location || a.location, s, f;
        return P.Children.forEach(r.props.children, function(o) {
          if (f == null && P.isValidElement(o)) {
            s = o;
            var u = o.props.path || o.props.from;
            f = u ? ue(c.pathname, M({}, o.props, {
              path: u
            })) : a.match;
          }
        }), f ? P.cloneElement(s, {
          location: c,
          computedMatch: f
        }) : null;
      });
    }, t;
  }(P.Component);
  hn = function(e) {
    var t = "withRouter(" + (e.displayName || e.name) + ")", n = function(r) {
      var a = r.wrappedComponentRef, c = re(r, [
        "wrappedComponentRef"
      ]);
      return P.createElement(k.Consumer, null, function(s) {
        return s || V(false), P.createElement(e, M({}, c, s, {
          ref: a
        }));
      });
    };
    return n.displayName = t, n.WrappedComponent = e, ot(n, e);
  };
  var fe = P.useContext;
  pn = function() {
    return fe(rt);
  };
  Xt = function() {
    return fe(k).location;
  };
  vn = function() {
    var e = fe(k).match;
    return e ? e.params : {};
  };
  dn = function(e) {
    var t = Xt(), n = fe(k).match;
    return e ? ue(t.pathname, e) : n;
  };
  const K = await Fe("react");
  let ye, we, Re, Z;
  mn = function(e) {
    G(t, e);
    function t() {
      for (var i, r = arguments.length, a = new Array(r), c = 0; c < r; c++)
        a[c] = arguments[c];
      return i = e.call.apply(e, [
        this
      ].concat(a)) || this, i.history = Pt(i.props), i;
    }
    var n = t.prototype;
    return n.render = function() {
      return K.createElement(ce, {
        history: this.history,
        children: this.props.children
      });
    }, t;
  }(K.Component);
  gn = function(e) {
    G(t, e);
    function t() {
      for (var i, r = arguments.length, a = new Array(r), c = 0; c < r; c++)
        a[c] = arguments[c];
      return i = e.call.apply(e, [
        this
      ].concat(a)) || this, i.history = Tt(i.props), i;
    }
    var n = t.prototype;
    return n.render = function() {
      return K.createElement(ce, {
        history: this.history,
        children: this.props.children
      });
    }, t;
  }(K.Component);
  ye = function(t, n) {
    return typeof t == "function" ? t(n) : t;
  };
  we = function(t, n) {
    return typeof t == "string" ? I(t, null, null, n) : t;
  };
  Re = function(t) {
    return t;
  };
  Z = K.forwardRef;
  typeof Z > "u" && (Z = Re);
  function Yt(e) {
    return !!(e.metaKey || e.altKey || e.ctrlKey || e.shiftKey);
  }
  let Qt, at, se;
  Qt = Z(function(e, t) {
    var n = e.innerRef, i = e.navigate, r = e.onClick, a = re(e, [
      "innerRef",
      "navigate",
      "onClick"
    ]), c = a.target, s = M({}, a, {
      onClick: function(o) {
        try {
          r && r(o);
        } catch (u) {
          throw o.preventDefault(), u;
        }
        !o.defaultPrevented && o.button === 0 && (!c || c === "_self") && !Yt(o) && (o.preventDefault(), i());
      }
    });
    return Re !== Z ? s.ref = t || n : s.ref = n, K.createElement("a", s);
  });
  Zt = Z(function(e, t) {
    var n = e.component, i = n === void 0 ? Qt : n, r = e.replace, a = e.to, c = e.innerRef, s = re(e, [
      "component",
      "replace",
      "to",
      "innerRef"
    ]);
    return K.createElement(k.Consumer, null, function(f) {
      f || V(false);
      var o = f.history, u = we(ye(a, f.location), f.location), l = u ? o.createHref(u) : "", h = M({}, s, {
        href: l,
        navigate: function() {
          var g = ye(a, f.location), C = B(f.location) === B(we(g)), T = r || C ? o.replace : o.push;
          T(g);
        }
      });
      return Re !== Z ? h.ref = t || c : h.innerRef = c, K.createElement(i, h);
    });
  });
  at = function(t) {
    return t;
  };
  se = K.forwardRef;
  typeof se > "u" && (se = at);
  function en() {
    for (var e = arguments.length, t = new Array(e), n = 0; n < e; n++)
      t[n] = arguments[n];
    return t.filter(function(i) {
      return i;
    }).join(" ");
  }
  yn = se(function(e, t) {
    var n = e["aria-current"], i = n === void 0 ? "page" : n, r = e.activeClassName, a = r === void 0 ? "active" : r, c = e.activeStyle, s = e.className, f = e.exact, o = e.isActive, u = e.location, l = e.sensitive, h = e.strict, v = e.style, g = e.to, C = e.innerRef, T = re(e, [
      "aria-current",
      "activeClassName",
      "activeStyle",
      "className",
      "exact",
      "isActive",
      "location",
      "sensitive",
      "strict",
      "style",
      "to",
      "innerRef"
    ]);
    return K.createElement(k.Consumer, null, function(b) {
      b || V(false);
      var S = u || b.location, N = we(ye(g, S), S), _ = N.pathname, H = _ && _.replace(/([.+*?=^!:${}()[\]|/\\])/g, "\\$1"), R = H ? ue(S.pathname, {
        path: H,
        exact: f,
        sensitive: l,
        strict: h
      }) : null, y = !!(o ? o(R, S) : R), x = typeof s == "function" ? s(y) : s, O = typeof v == "function" ? v(y) : v;
      y && (x = en(x, a), O = M({}, O, c));
      var L = M({
        "aria-current": y && i || null,
        className: x,
        style: O,
        to: N
      }, T);
      return at !== se ? L.ref = t || C : L.innerRef = C, K.createElement(Zt, L);
    });
  });
});
export {
  mn as BrowserRouter,
  gn as HashRouter,
  Zt as Link,
  on as MemoryRouter,
  yn as NavLink,
  sn as Prompt,
  cn as Redirect,
  un as Route,
  ce as Router,
  fn as StaticRouter,
  ln as Switch,
  __tla,
  _e as generatePath,
  ue as matchPath,
  pn as useHistory,
  Xt as useLocation,
  vn as useParams,
  dn as useRouteMatch,
  hn as withRouter
};
