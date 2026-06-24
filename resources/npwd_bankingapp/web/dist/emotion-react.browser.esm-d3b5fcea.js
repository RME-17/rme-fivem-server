import { importShared as Y, __tla as __tla_0 } from "./__federation_fn_import-39357cc7.js";
import { h as ze, _ as Se } from "./hoist-non-react-statics.cjs-5200d79e.js";
let Xr, Jr, W, Fr, Nr, Lr, Cr, Dr, Gr, jr, Re, oe, Ce, Vr, Ge, ce, U, Ae, de;
let __tla = Promise.all([
  (() => {
    try {
      return __tla_0;
    } catch {
    }
  })()
]).then(async () => {
  function Le(e) {
    for (var r = 0, t, n = 0, a = e.length; a >= 4; ++n, a -= 4)
      t = e.charCodeAt(n) & 255 | (e.charCodeAt(++n) & 255) << 8 | (e.charCodeAt(++n) & 255) << 16 | (e.charCodeAt(++n) & 255) << 24, t = (t & 65535) * 1540483477 + ((t >>> 16) * 59797 << 16), t ^= t >>> 24, r = (t & 65535) * 1540483477 + ((t >>> 16) * 59797 << 16) ^ (r & 65535) * 1540483477 + ((r >>> 16) * 59797 << 16);
    switch (a) {
      case 3:
        r ^= (e.charCodeAt(n + 2) & 255) << 16;
      case 2:
        r ^= (e.charCodeAt(n + 1) & 255) << 8;
      case 1:
        r ^= e.charCodeAt(n) & 255, r = (r & 65535) * 1540483477 + ((r >>> 16) * 59797 << 16);
    }
    return r ^= r >>> 13, r = (r & 65535) * 1540483477 + ((r >>> 16) * 59797 << 16), ((r ^ r >>> 15) >>> 0).toString(36);
  }
  var Fe = {
    animationIterationCount: 1,
    aspectRatio: 1,
    borderImageOutset: 1,
    borderImageSlice: 1,
    borderImageWidth: 1,
    boxFlex: 1,
    boxFlexGroup: 1,
    boxOrdinalGroup: 1,
    columnCount: 1,
    columns: 1,
    flex: 1,
    flexGrow: 1,
    flexPositive: 1,
    flexShrink: 1,
    flexNegative: 1,
    flexOrder: 1,
    gridRow: 1,
    gridRowEnd: 1,
    gridRowSpan: 1,
    gridRowStart: 1,
    gridColumn: 1,
    gridColumnEnd: 1,
    gridColumnSpan: 1,
    gridColumnStart: 1,
    msGridRow: 1,
    msGridRowSpan: 1,
    msGridColumn: 1,
    msGridColumnSpan: 1,
    fontWeight: 1,
    lineHeight: 1,
    opacity: 1,
    order: 1,
    orphans: 1,
    scale: 1,
    tabSize: 1,
    widows: 1,
    zIndex: 1,
    zoom: 1,
    WebkitLineClamp: 1,
    fillOpacity: 1,
    floodOpacity: 1,
    stopOpacity: 1,
    strokeDasharray: 1,
    strokeDashoffset: 1,
    strokeMiterlimit: 1,
    strokeOpacity: 1,
    strokeWidth: 1
  };
  Ge = function(e) {
    var r = /* @__PURE__ */ Object.create(null);
    return function(t) {
      return r[t] === void 0 && (r[t] = e(t)), r[t];
    };
  };
  var De = false, je = /[A-Z]|^ms/g, Je = /_EMO_([^_]+?)_([^]*?)_EMO_/g, $e = function(r) {
    return r.charCodeAt(1) === 45;
  }, ve = function(r) {
    return r != null && typeof r != "boolean";
  }, re = Ge(function(e) {
    return $e(e) ? e : e.replace(je, "-$&").toLowerCase();
  }), ge = function(r, t) {
    switch (r) {
      case "animation":
      case "animationName":
        if (typeof t == "string")
          return t.replace(Je, function(n, a, i) {
            return T = {
              name: a,
              styles: i,
              next: T
            }, a;
          });
    }
    return Fe[r] !== 1 && !$e(r) && typeof t == "number" && t !== 0 ? t + "px" : t;
  }, Ve = "Component selectors can only be used in conjunction with @emotion/babel-plugin, the swc Emotion plugin, or another Emotion-aware compiler transform.";
  function G(e, r, t) {
    if (t == null)
      return "";
    var n = t;
    if (n.__emotion_styles !== void 0)
      return n;
    switch (typeof t) {
      case "boolean":
        return "";
      case "object": {
        var a = t;
        if (a.anim === 1)
          return T = {
            name: a.name,
            styles: a.styles,
            next: T
          }, a.name;
        var i = t;
        if (i.styles !== void 0) {
          var s = i.next;
          if (s !== void 0)
            for (; s !== void 0; )
              T = {
                name: s.name,
                styles: s.styles,
                next: T
              }, s = s.next;
          var c = i.styles + ";";
          return c;
        }
        return Xe(e, r, t);
      }
      case "function": {
        if (e !== void 0) {
          var o = T, f = t(e);
          return T = o, G(e, r, f);
        }
        break;
      }
    }
    var d = t;
    if (r == null)
      return d;
    var u = r[d];
    return u !== void 0 ? u : d;
  }
  function Xe(e, r, t) {
    var n = "";
    if (Array.isArray(t))
      for (var a = 0; a < t.length; a++)
        n += G(e, r, t[a]) + ";";
    else
      for (var i in t) {
        var s = t[i];
        if (typeof s != "object") {
          var c = s;
          r != null && r[c] !== void 0 ? n += i + "{" + r[c] + "}" : ve(c) && (n += re(i) + ":" + ge(i, c) + ";");
        } else {
          if (i === "NO_COMPONENT_SELECTOR" && De)
            throw new Error(Ve);
          if (Array.isArray(s) && typeof s[0] == "string" && (r == null || r[s[0]] === void 0))
            for (var o = 0; o < s.length; o++)
              ve(s[o]) && (n += re(i) + ":" + ge(i, s[o]) + ";");
          else {
            var f = G(e, r, s);
            switch (i) {
              case "animation":
              case "animationName": {
                n += re(i) + ":" + f + ";";
                break;
              }
              default:
                n += i + "{" + f + "}";
            }
          }
        }
      }
    return n;
  }
  var pe = /label:\s*([^\s;{]+)\s*(;|$)/g, T;
  U = function(e, r, t) {
    if (e.length === 1 && typeof e[0] == "object" && e[0] !== null && e[0].styles !== void 0)
      return e[0];
    var n = true, a = "";
    T = void 0;
    var i = e[0];
    if (i == null || i.raw === void 0)
      n = false, a += G(t, r, i);
    else {
      var s = i;
      a += s[0];
    }
    for (var c = 1; c < e.length; c++)
      if (a += G(t, r, e[c]), n) {
        var o = i;
        a += o[c];
      }
    pe.lastIndex = 0;
    for (var f = "", d; (d = pe.exec(a)) !== null; )
      f += "-" + d[1];
    var u = Le(a) + f;
    return {
      name: u,
      styles: a,
      next: T
    };
  };
  const te = await Y("react");
  let qe, ke, ye, Be;
  qe = function(r) {
    return r();
  };
  ke = te["useInsertionEffect"] ? te["useInsertionEffect"] : false;
  Ae = ke || qe;
  ye = ke || te.useLayoutEffect;
  Be = true;
  Re = function(e, r, t) {
    var n = "";
    return t.split(" ").forEach(function(a) {
      e[a] !== void 0 ? r.push(e[a] + ";") : a && (n += a + " ");
    }), n;
  };
  let He;
  ce = function(r, t, n) {
    var a = r.key + "-" + t.name;
    (n === false || Be === false) && r.registered[a] === void 0 && (r.registered[a] = t.styles);
  };
  oe = function(r, t, n) {
    ce(r, t, n);
    var a = r.key + "-" + t.name;
    if (r.inserted[t.name] === void 0) {
      var i = t;
      do
        r.insert(t === i ? "." + a : "", i, r.sheet, true), i = i.next;
      while (i !== void 0);
    }
  };
  He = false;
  function Ke(e) {
    if (e.sheet)
      return e.sheet;
    for (var r = 0; r < document.styleSheets.length; r++)
      if (document.styleSheets[r].ownerNode === e)
        return document.styleSheets[r];
  }
  function Ye(e) {
    var r = document.createElement("style");
    return r.setAttribute("data-emotion", e.key), e.nonce !== void 0 && r.setAttribute("nonce", e.nonce), r.appendChild(document.createTextNode("")), r.setAttribute("data-s", ""), r;
  }
  var Ue = function() {
    function e(t) {
      var n = this;
      this._insertTag = function(a) {
        var i;
        n.tags.length === 0 ? n.insertionPoint ? i = n.insertionPoint.nextSibling : n.prepend ? i = n.container.firstChild : i = n.before : i = n.tags[n.tags.length - 1].nextSibling, n.container.insertBefore(a, i), n.tags.push(a);
      }, this.isSpeedy = t.speedy === void 0 ? !He : t.speedy, this.tags = [], this.ctr = 0, this.nonce = t.nonce, this.key = t.key, this.container = t.container, this.prepend = t.prepend, this.insertionPoint = t.insertionPoint, this.before = null;
    }
    var r = e.prototype;
    return r.hydrate = function(n) {
      n.forEach(this._insertTag);
    }, r.insert = function(n) {
      this.ctr % (this.isSpeedy ? 65e3 : 1) === 0 && this._insertTag(Ye(this));
      var a = this.tags[this.tags.length - 1];
      if (this.isSpeedy) {
        var i = Ke(a);
        try {
          i.insertRule(n, i.cssRules.length);
        } catch {
        }
      } else
        a.appendChild(document.createTextNode(n));
      this.ctr++;
    }, r.flush = function() {
      this.tags.forEach(function(n) {
        var a;
        return (a = n.parentNode) == null ? void 0 : a.removeChild(n);
      }), this.tags = [], this.ctr = 0;
    }, e;
  }(), w = "-ms-", K = "-moz-", l = "-webkit-", Te = "comm", fe = "rule", ue = "decl", Ze = "@import", Oe = "@keyframes", Qe = "@layer", er = Math.abs, Z = String.fromCharCode, rr = Object.assign;
  function tr(e, r) {
    return y(e, 0) ^ 45 ? (((r << 2 ^ y(e, 0)) << 2 ^ y(e, 1)) << 2 ^ y(e, 2)) << 2 ^ y(e, 3) : 0;
  }
  function Pe(e) {
    return e.trim();
  }
  function nr(e, r) {
    return (e = r.exec(e)) ? e[0] : e;
  }
  function h(e, r, t) {
    return e.replace(r, t);
  }
  function ne(e, r) {
    return e.indexOf(r);
  }
  function y(e, r) {
    return e.charCodeAt(r) | 0;
  }
  function D(e, r, t) {
    return e.slice(r, t);
  }
  function O(e) {
    return e.length;
  }
  function le(e) {
    return e.length;
  }
  function X(e, r) {
    return r.push(e), e;
  }
  function ar(e, r) {
    return e.map(r).join("");
  }
  var Q = 1, z = 1, Ne = 0, E = 0, p = 0, L = "";
  function ee(e, r, t, n, a, i, s) {
    return {
      value: e,
      root: r,
      parent: t,
      type: n,
      props: a,
      children: i,
      line: Q,
      column: z,
      length: s,
      return: ""
    };
  }
  function F(e, r) {
    return rr(ee("", null, null, "", null, null, 0), e, {
      length: -e.length
    }, r);
  }
  function ir() {
    return p;
  }
  function sr() {
    return p = E > 0 ? y(L, --E) : 0, z--, p === 10 && (z = 1, Q--), p;
  }
  function k() {
    return p = E < Ne ? y(L, E++) : 0, z++, p === 10 && (z = 1, Q++), p;
  }
  function P() {
    return y(L, E);
  }
  function q() {
    return E;
  }
  function J(e, r) {
    return D(L, e, r);
  }
  function j(e) {
    switch (e) {
      case 0:
      case 9:
      case 10:
      case 13:
      case 32:
        return 5;
      case 33:
      case 43:
      case 44:
      case 47:
      case 62:
      case 64:
      case 126:
      case 59:
      case 123:
      case 125:
        return 4;
      case 58:
        return 3;
      case 34:
      case 39:
      case 40:
      case 91:
        return 2;
      case 41:
      case 93:
        return 1;
    }
    return 0;
  }
  function Ie(e) {
    return Q = z = 1, Ne = O(L = e), E = 0, [];
  }
  function Me(e) {
    return L = "", e;
  }
  function B(e) {
    return Pe(J(E - 1, ae(e === 91 ? e + 2 : e === 40 ? e + 1 : e)));
  }
  function cr(e) {
    for (; (p = P()) && p < 33; )
      k();
    return j(e) > 2 || j(p) > 3 ? "" : " ";
  }
  function or(e, r) {
    for (; --r && k() && !(p < 48 || p > 102 || p > 57 && p < 65 || p > 70 && p < 97); )
      ;
    return J(e, q() + (r < 6 && P() == 32 && k() == 32));
  }
  function ae(e) {
    for (; k(); )
      switch (p) {
        case e:
          return E;
        case 34:
        case 39:
          e !== 34 && e !== 39 && ae(p);
          break;
        case 40:
          e === 41 && ae(e);
          break;
        case 92:
          k();
          break;
      }
    return E;
  }
  function fr(e, r) {
    for (; k() && e + p !== 47 + 10; )
      if (e + p === 42 + 42 && P() === 47)
        break;
    return "/*" + J(r, E - 1) + "*" + Z(e === 47 ? e : k());
  }
  function ur(e) {
    for (; !j(P()); )
      k();
    return J(e, E);
  }
  function lr(e) {
    return Me(H("", null, null, null, [
      ""
    ], e = Ie(e), 0, [
      0
    ], e));
  }
  function H(e, r, t, n, a, i, s, c, o) {
    for (var f = 0, d = 0, u = s, C = 0, N = 0, S = 0, v = 1, x = 1, g = 1, b = 0, A = "", V = a, M = i, R = n, m = A; x; )
      switch (S = b, b = k()) {
        case 40:
          if (S != 108 && y(m, u - 1) == 58) {
            ne(m += h(B(b), "&", "&\f"), "&\f") != -1 && (g = -1);
            break;
          }
        case 34:
        case 39:
        case 91:
          m += B(b);
          break;
        case 9:
        case 10:
        case 13:
        case 32:
          m += cr(S);
          break;
        case 92:
          m += or(q() - 1, 7);
          continue;
        case 47:
          switch (P()) {
            case 42:
            case 47:
              X(hr(fr(k(), q()), r, t), o);
              break;
            default:
              m += "/";
          }
          break;
        case 123 * v:
          c[f++] = O(m) * g;
        case 125 * v:
        case 59:
        case 0:
          switch (b) {
            case 0:
            case 125:
              x = 0;
            case 59 + d:
              g == -1 && (m = h(m, /\f/g, "")), N > 0 && O(m) - u && X(N > 32 ? we(m + ";", n, t, u - 1) : we(h(m, " ", "") + ";", n, t, u - 2), o);
              break;
            case 59:
              m += ";";
            default:
              if (X(R = be(m, r, t, f, d, a, c, A, V = [], M = [], u), i), b === 123)
                if (d === 0)
                  H(m, r, R, R, V, i, u, c, M);
                else
                  switch (C === 99 && y(m, 3) === 110 ? 100 : C) {
                    case 100:
                    case 108:
                    case 109:
                    case 115:
                      H(e, R, R, n && X(be(e, R, R, 0, 0, a, c, A, a, V = [], u), M), a, M, u, c, n ? V : M);
                      break;
                    default:
                      H(m, R, R, R, [
                        ""
                      ], M, 0, c, M);
                  }
          }
          f = d = N = 0, v = g = 1, A = m = "", u = s;
          break;
        case 58:
          u = 1 + O(m), N = S;
        default:
          if (v < 1) {
            if (b == 123)
              --v;
            else if (b == 125 && v++ == 0 && sr() == 125)
              continue;
          }
          switch (m += Z(b), b * v) {
            case 38:
              g = d > 0 ? 1 : (m += "\f", -1);
              break;
            case 44:
              c[f++] = (O(m) - 1) * g, g = 1;
              break;
            case 64:
              P() === 45 && (m += B(k())), C = P(), d = u = O(A = m += ur(q())), b++;
              break;
            case 45:
              S === 45 && O(m) == 2 && (v = 0);
          }
      }
    return i;
  }
  function be(e, r, t, n, a, i, s, c, o, f, d) {
    for (var u = a - 1, C = a === 0 ? i : [
      ""
    ], N = le(C), S = 0, v = 0, x = 0; S < n; ++S)
      for (var g = 0, b = D(e, u + 1, u = er(v = s[S])), A = e; g < N; ++g)
        (A = Pe(v > 0 ? C[g] + " " + b : h(b, /&\f/g, C[g]))) && (o[x++] = A);
    return ee(e, r, t, a === 0 ? fe : c, o, f, d);
  }
  function hr(e, r, t) {
    return ee(e, r, t, Te, Z(ir()), D(e, 2, -2), 0);
  }
  function we(e, r, t, n) {
    return ee(e, r, t, ue, D(e, 0, n), D(e, n + 1, -1), n);
  }
  function _(e, r) {
    for (var t = "", n = le(e), a = 0; a < n; a++)
      t += r(e[a], a, e, r) || "";
    return t;
  }
  function dr(e, r, t, n) {
    switch (e.type) {
      case Qe:
        if (e.children.length)
          break;
      case Ze:
      case ue:
        return e.return = e.return || e.value;
      case Te:
        return "";
      case Oe:
        return e.return = e.value + "{" + _(e.children, n) + "}";
      case fe:
        e.value = e.props.join(",");
    }
    return O(t = _(e.children, n)) ? e.return = e.value + "{" + t + "}" : "";
  }
  function mr(e) {
    var r = le(e);
    return function(t, n, a, i) {
      for (var s = "", c = 0; c < r; c++)
        s += e[c](t, n, a, i) || "";
      return s;
    };
  }
  function vr(e) {
    return function(r) {
      r.root || (r = r.return) && e(r);
    };
  }
  var xe = function(r) {
    var t = /* @__PURE__ */ new WeakMap();
    return function(n) {
      if (t.has(n))
        return t.get(n);
      var a = r(n);
      return t.set(n, a), a;
    };
  }, gr = function(r, t, n) {
    for (var a = 0, i = 0; a = i, i = P(), a === 38 && i === 12 && (t[n] = 1), !j(i); )
      k();
    return J(r, E);
  }, pr = function(r, t) {
    var n = -1, a = 44;
    do
      switch (j(a)) {
        case 0:
          a === 38 && P() === 12 && (t[n] = 1), r[n] += gr(E - 1, t, n);
          break;
        case 2:
          r[n] += B(a);
          break;
        case 4:
          if (a === 44) {
            r[++n] = P() === 58 ? "&\f" : "", t[n] = r[n].length;
            break;
          }
        default:
          r[n] += Z(a);
      }
    while (a = k());
    return r;
  }, yr = function(r, t) {
    return Me(pr(Ie(r), t));
  }, Ee = /* @__PURE__ */ new WeakMap(), br = function(r) {
    if (!(r.type !== "rule" || !r.parent || r.length < 1)) {
      for (var t = r.value, n = r.parent, a = r.column === n.column && r.line === n.line; n.type !== "rule"; )
        if (n = n.parent, !n)
          return;
      if (!(r.props.length === 1 && t.charCodeAt(0) !== 58 && !Ee.get(n)) && !a) {
        Ee.set(r, true);
        for (var i = [], s = yr(t, i), c = n.props, o = 0, f = 0; o < s.length; o++)
          for (var d = 0; d < c.length; d++, f++)
            r.props[f] = i[o] ? s[o].replace(/&\f/g, c[d]) : c[d] + " " + s[o];
      }
    }
  }, wr = function(r) {
    if (r.type === "decl") {
      var t = r.value;
      t.charCodeAt(0) === 108 && t.charCodeAt(2) === 98 && (r.return = "", r.value = "");
    }
  };
  function We(e, r) {
    switch (tr(e, r)) {
      case 5103:
        return l + "print-" + e + e;
      case 5737:
      case 4201:
      case 3177:
      case 3433:
      case 1641:
      case 4457:
      case 2921:
      case 5572:
      case 6356:
      case 5844:
      case 3191:
      case 6645:
      case 3005:
      case 6391:
      case 5879:
      case 5623:
      case 6135:
      case 4599:
      case 4855:
      case 4215:
      case 6389:
      case 5109:
      case 5365:
      case 5621:
      case 3829:
        return l + e + e;
      case 5349:
      case 4246:
      case 4810:
      case 6968:
      case 2756:
        return l + e + K + e + w + e + e;
      case 6828:
      case 4268:
        return l + e + w + e + e;
      case 6165:
        return l + e + w + "flex-" + e + e;
      case 5187:
        return l + e + h(e, /(\w+).+(:[^]+)/, l + "box-$1$2" + w + "flex-$1$2") + e;
      case 5443:
        return l + e + w + "flex-item-" + h(e, /flex-|-self/, "") + e;
      case 4675:
        return l + e + w + "flex-line-pack" + h(e, /align-content|flex-|-self/, "") + e;
      case 5548:
        return l + e + w + h(e, "shrink", "negative") + e;
      case 5292:
        return l + e + w + h(e, "basis", "preferred-size") + e;
      case 6060:
        return l + "box-" + h(e, "-grow", "") + l + e + w + h(e, "grow", "positive") + e;
      case 4554:
        return l + h(e, /([^-])(transform)/g, "$1" + l + "$2") + e;
      case 6187:
        return h(h(h(e, /(zoom-|grab)/, l + "$1"), /(image-set)/, l + "$1"), e, "") + e;
      case 5495:
      case 3959:
        return h(e, /(image-set\([^]*)/, l + "$1$`$1");
      case 4968:
        return h(h(e, /(.+:)(flex-)?(.*)/, l + "box-pack:$3" + w + "flex-pack:$3"), /s.+-b[^;]+/, "justify") + l + e + e;
      case 4095:
      case 3583:
      case 4068:
      case 2532:
        return h(e, /(.+)-inline(.+)/, l + "$1$2") + e;
      case 8116:
      case 7059:
      case 5753:
      case 5535:
      case 5445:
      case 5701:
      case 4933:
      case 4677:
      case 5533:
      case 5789:
      case 5021:
      case 4765:
        if (O(e) - 1 - r > 6)
          switch (y(e, r + 1)) {
            case 109:
              if (y(e, r + 4) !== 45)
                break;
            case 102:
              return h(e, /(.+:)(.+)-([^]+)/, "$1" + l + "$2-$3$1" + K + (y(e, r + 3) == 108 ? "$3" : "$2-$3")) + e;
            case 115:
              return ~ne(e, "stretch") ? We(h(e, "stretch", "fill-available"), r) + e : e;
          }
        break;
      case 4949:
        if (y(e, r + 1) !== 115)
          break;
      case 6444:
        switch (y(e, O(e) - 3 - (~ne(e, "!important") && 10))) {
          case 107:
            return h(e, ":", ":" + l) + e;
          case 101:
            return h(e, /(.+:)([^;!]+)(;|!.+)?/, "$1" + l + (y(e, 14) === 45 ? "inline-" : "") + "box$3$1" + l + "$2$3$1" + w + "$2box$3") + e;
        }
        break;
      case 5936:
        switch (y(e, r + 11)) {
          case 114:
            return l + e + w + h(e, /[svh]\w+-[tblr]{2}/, "tb") + e;
          case 108:
            return l + e + w + h(e, /[svh]\w+-[tblr]{2}/, "tb-rl") + e;
          case 45:
            return l + e + w + h(e, /[svh]\w+-[tblr]{2}/, "lr") + e;
        }
        return l + e + w + e + e;
    }
    return e;
  }
  let xr, Er, Sr;
  xr = function(r, t, n, a) {
    if (r.length > -1 && !r.return)
      switch (r.type) {
        case ue:
          r.return = We(r.value, r.length);
          break;
        case Oe:
          return _([
            F(r, {
              value: h(r.value, "@", "@" + l)
            })
          ], a);
        case fe:
          if (r.length)
            return ar(r.props, function(i) {
              switch (nr(i, /(::plac\w+|:read-\w+)/)) {
                case ":read-only":
                case ":read-write":
                  return _([
                    F(r, {
                      props: [
                        h(i, /:(read-\w+)/, ":" + K + "$1")
                      ]
                    })
                  ], a);
                case "::placeholder":
                  return _([
                    F(r, {
                      props: [
                        h(i, /:(plac\w+)/, ":" + l + "input-$1")
                      ]
                    }),
                    F(r, {
                      props: [
                        h(i, /:(plac\w+)/, ":" + K + "$1")
                      ]
                    }),
                    F(r, {
                      props: [
                        h(i, /:(plac\w+)/, w + "input-$1")
                      ]
                    })
                  ], a);
              }
              return "";
            });
      }
  };
  Er = [
    xr
  ];
  Cr = function(r) {
    var t = r.key;
    if (t === "css") {
      var n = document.querySelectorAll("style[data-emotion]:not([data-s])");
      Array.prototype.forEach.call(n, function(v) {
        var x = v.getAttribute("data-emotion");
        x.indexOf(" ") !== -1 && (document.head.appendChild(v), v.setAttribute("data-s", ""));
      });
    }
    var a = r.stylisPlugins || Er, i = {}, s, c = [];
    s = r.container || document.head, Array.prototype.forEach.call(document.querySelectorAll('style[data-emotion^="' + t + ' "]'), function(v) {
      for (var x = v.getAttribute("data-emotion").split(" "), g = 1; g < x.length; g++)
        i[x[g]] = true;
      c.push(v);
    });
    var o, f = [
      br,
      wr
    ];
    {
      var d, u = [
        dr,
        vr(function(v) {
          d.insert(v);
        })
      ], C = mr(f.concat(a, u)), N = function(x) {
        return _(lr(x), C);
      };
      o = function(x, g, b, A) {
        d = b, N(x ? x + "{" + g.styles + "}" : g.styles), A && (S.inserted[g.name] = true);
      };
    }
    var S = {
      key: t,
      sheet: new Ue({
        key: t,
        container: s,
        nonce: r.nonce,
        speedy: r.speedy,
        prepend: r.prepend,
        insertionPoint: r.insertionPoint
      }),
      nonce: r.nonce,
      inserted: i,
      registered: {},
      insert: o
    };
    return S.sheet.hydrate(c), S;
  };
  Sr = function(e, r) {
    return ze(e, r);
  };
  const $ = await Y("react"), { useContext: _e, forwardRef: $r } = await Y("react");
  let ie, he, kr, Ar;
  ie = false;
  he = $.createContext(typeof HTMLElement < "u" ? Cr({
    key: "css"
  }) : null);
  Lr = he.Provider;
  Fr = function() {
    return _e(he);
  };
  de = function(r) {
    return $r(function(t, n) {
      var a = _e(he);
      return r(t, a, n);
    });
  };
  W = $.createContext({});
  Gr = function() {
    return $.useContext(W);
  };
  kr = function(r, t) {
    if (typeof t == "function") {
      var n = t(r);
      return n;
    }
    return Se({}, r, t);
  };
  Ar = xe(function(e) {
    return xe(function(r) {
      return kr(e, r);
    });
  });
  Dr = function(r) {
    var t = $.useContext(W);
    return r.theme !== t && (t = Ar(t)(r.theme)), $.createElement(W.Provider, {
      value: t
    }, r.children);
  };
  jr = function(e) {
    var r = e.displayName || e.name || "Component", t = $.forwardRef(function(a, i) {
      var s = $.useContext(W);
      return $.createElement(e, Se({
        theme: s,
        ref: i
      }, a));
    });
    return t.displayName = "WithTheme(" + r + ")", Sr(t, e);
  };
  var me = {}.hasOwnProperty, se = "__EMOTION_TYPE_PLEASE_DO_NOT_USE__", Rr = function(r, t) {
    var n = {};
    for (var a in t)
      me.call(t, a) && (n[a] = t[a]);
    return n[se] = r, n;
  }, Tr = function(r) {
    var t = r.cache, n = r.serialized, a = r.isStringTag;
    return ce(t, n, a), Ae(function() {
      return oe(t, n, a);
    }), null;
  }, Or = de(function(e, r, t) {
    var n = e.css;
    typeof n == "string" && r.registered[n] !== void 0 && (n = r.registered[n]);
    var a = e[se], i = [
      n
    ], s = "";
    typeof e.className == "string" ? s = Re(r.registered, i, e.className) : e.className != null && (s = e.className + " ");
    var c = U(i, void 0, $.useContext(W));
    s += r.key + "-" + c.name;
    var o = {};
    for (var f in e)
      me.call(e, f) && f !== "css" && f !== se && !ie && (o[f] = e[f]);
    return o.className = s, t && (o.ref = t), $.createElement($.Fragment, null, $.createElement(Tr, {
      cache: r,
      serialized: c,
      isStringTag: typeof a == "string"
    }), $.createElement(a, o));
  }), Pr = Or;
  const I = await Y("react");
  Ce = function(r, t) {
    var n = arguments;
    if (t == null || !me.call(t, "css"))
      return I.createElement.apply(void 0, n);
    var a = n.length, i = new Array(a);
    i[0] = Pr, i[1] = Rr(r, t);
    for (var s = 2; s < a; s++)
      i[s] = n[s];
    return I.createElement.apply(null, i);
  };
  (function(e) {
    var r;
    r || (r = e.JSX || (e.JSX = {}));
  })(Ce || (Ce = {}));
  Jr = de(function(e, r) {
    var t = e.styles, n = U([
      t
    ], void 0, I.useContext(W)), a = I.useRef();
    return ye(function() {
      var i = r.key + "-global", s = new r.sheet.constructor({
        key: i,
        nonce: r.sheet.nonce,
        container: r.sheet.container,
        speedy: r.sheet.isSpeedy
      }), c = false, o = document.querySelector('style[data-emotion="' + i + " " + n.name + '"]');
      return r.sheet.tags.length && (s.before = r.sheet.tags[0]), o !== null && (c = true, o.setAttribute("data-emotion", i), s.hydrate([
        o
      ])), a.current = [
        s,
        c
      ], function() {
        s.flush();
      };
    }, [
      r
    ]), ye(function() {
      var i = a.current, s = i[0], c = i[1];
      if (c) {
        i[1] = false;
        return;
      }
      if (n.next !== void 0 && oe(r, n.next, true), s.tags.length) {
        var o = s.tags[s.tags.length - 1].nextElementSibling;
        s.before = o, s.flush();
      }
      r.insert("", n, s, false);
    }, [
      r,
      n.name
    ]), null;
  });
  Nr = function() {
    for (var e = arguments.length, r = new Array(e), t = 0; t < e; t++)
      r[t] = arguments[t];
    return U(r);
  };
  Vr = function() {
    var e = Nr.apply(void 0, arguments), r = "animation-" + e.name;
    return {
      name: r,
      styles: "@keyframes " + r + "{" + e.styles + "}",
      anim: 1,
      toString: function() {
        return "_EMO_" + this.name + "_" + this.styles + "_EMO_";
      }
    };
  };
  var Ir = function e(r) {
    for (var t = r.length, n = 0, a = ""; n < t; n++) {
      var i = r[n];
      if (i != null) {
        var s = void 0;
        switch (typeof i) {
          case "boolean":
            break;
          case "object": {
            if (Array.isArray(i))
              s = e(i);
            else {
              s = "";
              for (var c in i)
                i[c] && c && (s && (s += " "), s += c);
            }
            break;
          }
          default:
            s = i;
        }
        s && (a && (a += " "), a += s);
      }
    }
    return a;
  };
  function Mr(e, r, t) {
    var n = [], a = Re(e, n, t);
    return n.length < 2 ? t : a + r(n);
  }
  let Wr;
  Wr = function(r) {
    var t = r.cache, n = r.serializedArr;
    return Ae(function() {
      for (var a = 0; a < n.length; a++)
        oe(t, n[a], false);
    }), null;
  };
  Xr = de(function(e, r) {
    var t = false, n = [], a = function() {
      if (t && ie)
        throw new Error("css can only be used during render");
      for (var f = arguments.length, d = new Array(f), u = 0; u < f; u++)
        d[u] = arguments[u];
      var C = U(d, r.registered);
      return n.push(C), ce(r, C, false), r.key + "-" + C.name;
    }, i = function() {
      if (t && ie)
        throw new Error("cx can only be used during render");
      for (var f = arguments.length, d = new Array(f), u = 0; u < f; u++)
        d[u] = arguments[u];
      return Mr(r.registered, a, Ir(d));
    }, s = {
      css: a,
      cx: i,
      theme: I.useContext(W)
    }, c = e.children(s);
    return t = true, I.createElement(I.Fragment, null, I.createElement(Wr, {
      cache: r,
      serializedArr: n
    }), c);
  });
});
export {
  Xr as C,
  Jr as G,
  W as T,
  Fr as _,
  __tla,
  Nr as a,
  Lr as b,
  Cr as c,
  Dr as d,
  Gr as e,
  jr as f,
  Re as g,
  oe as i,
  Ce as j,
  Vr as k,
  Ge as m,
  ce as r,
  U as s,
  Ae as u,
  de as w
};
