import { _ as N } from "./preload-helper-a2192bf4.js";
let Te, Le, ge;
let __tla = (async () => {
  const E = "[0-9A-Za-z-]+", x = `(?:\\+(${E}(?:\\.${E})*))`, R = "0|[1-9]\\d*", V = "[0-9]+", k = "\\d*[a-zA-Z-][a-zA-Z0-9-]*", S = `(?:${V}|${k})`, J = `(?:-?(${S}(?:\\.${S})*))`, X = `(?:${R}|${k})`, F = `(?:-(${X}(?:\\.${X})*))`, L = `${R}|x|X|\\*`, d = `[v=\\s]*(${L})(?:\\.(${L})(?:\\.(${L})(?:${F})?${x}?)?)?`, Q = `^\\s*(${d})\\s+-\\s+(${d})\\s*$`, W = `(${V})\\.(${V})\\.(${V})`, Y = `[v=\\s]*${W}${J}?${x}?`, y = "((?:<|>)?=?)", j = `(\\s*)${y}\\s*(${Y}|${d})`, K = "(?:~>?)", A = `(\\s*)${K}\\s+`, B = "(?:\\^)", m = `(\\s*)${B}\\s+`, ee = "(<|>)?=?\\s*\\*", re = `^${B}${d}$`, te = `(${R})\\.(${R})\\.(${R})`, ne = `v?${te}${F}?${x}?`, se = `^${K}${d}$`, ie = `^${y}\\s*${d}$`, ue = `^${y}\\s*(${ne})$|^$`, $e = "^\\s*>=\\s*0.0.0\\s*$";
  function l(e) {
    return new RegExp(e);
  }
  function c(e) {
    return !e || e.toLowerCase() === "x" || e === "*";
  }
  function D(...e) {
    return (n) => e.reduce((s, r) => r(s), n);
  }
  function U(e) {
    return e.match(l(ue));
  }
  function z(e, n, s, r) {
    const t = `${e}.${n}.${s}`;
    return r ? `${t}-${r}` : t;
  }
  function ce(e) {
    return e.replace(l(Q), (n, s, r, t, i, u, $, a, f, o, h, p) => (c(r) ? s = "" : c(t) ? s = `>=${r}.0.0` : c(i) ? s = `>=${r}.${t}.0` : s = `>=${s}`, c(f) ? a = "" : c(o) ? a = `<${+f + 1}.0.0-0` : c(h) ? a = `<${f}.${+o + 1}.0-0` : p ? a = `<=${f}.${o}.${h}-${p}` : a = `<=${a}`, `${s} ${a}`.trim()));
  }
  function ae(e) {
    return e.replace(l(j), "$1$2$3");
  }
  function fe(e) {
    return e.replace(l(A), "$1~");
  }
  function oe(e) {
    return e.replace(l(m), "$1^");
  }
  function le(e) {
    return e.trim().split(/\s+/).map((n) => n.replace(l(re), (s, r, t, i, u) => c(r) ? "" : c(t) ? `>=${r}.0.0 <${+r + 1}.0.0-0` : c(i) ? r === "0" ? `>=${r}.${t}.0 <${r}.${+t + 1}.0-0` : `>=${r}.${t}.0 <${+r + 1}.0.0-0` : u ? r === "0" ? t === "0" ? `>=${r}.${t}.${i}-${u} <${r}.${t}.${+i + 1}-0` : `>=${r}.${t}.${i}-${u} <${r}.${+t + 1}.0-0` : `>=${r}.${t}.${i}-${u} <${+r + 1}.0.0-0` : r === "0" ? t === "0" ? `>=${r}.${t}.${i} <${r}.${t}.${+i + 1}-0` : `>=${r}.${t}.${i} <${r}.${+t + 1}.0-0` : `>=${r}.${t}.${i} <${+r + 1}.0.0-0`)).join(" ");
  }
  function pe(e) {
    return e.trim().split(/\s+/).map((n) => n.replace(l(se), (s, r, t, i, u) => c(r) ? "" : c(t) ? `>=${r}.0.0 <${+r + 1}.0.0-0` : c(i) ? `>=${r}.${t}.0 <${r}.${+t + 1}.0-0` : u ? `>=${r}.${t}.${i}-${u} <${r}.${+t + 1}.0-0` : `>=${r}.${t}.${i} <${r}.${+t + 1}.0-0`)).join(" ");
  }
  function de(e) {
    return e.split(/\s+/).map((n) => n.trim().replace(l(ie), (s, r, t, i, u, $) => {
      const a = c(t), f = a || c(i), o = f || c(u);
      return r === "=" && o && (r = ""), $ = "", a ? r === ">" || r === "<" ? "<0.0.0-0" : "*" : r && o ? (f && (i = 0), u = 0, r === ">" ? (r = ">=", f ? (t = +t + 1, i = 0, u = 0) : (i = +i + 1, u = 0)) : r === "<=" && (r = "<", f ? t = +t + 1 : i = +i + 1), r === "<" && ($ = "-0"), `${r + t}.${i}.${u}${$}`) : f ? `>=${t}.0.0${$} <${+t + 1}.0.0-0` : o ? `>=${t}.${i}.0${$} <${t}.${+i + 1}.0-0` : s;
    })).join(" ");
  }
  function _e(e) {
    return e.trim().replace(l(ee), "");
  }
  function Re(e) {
    return e.trim().replace(l($e), "");
  }
  function w(e, n) {
    return e = +e || e, n = +n || n, e > n ? 1 : e === n ? 0 : -1;
  }
  function he(e, n) {
    const { preRelease: s } = e, { preRelease: r } = n;
    if (s === void 0 && r)
      return 1;
    if (s && r === void 0)
      return -1;
    if (s === void 0 && r === void 0)
      return 0;
    for (let t = 0, i = s.length; t <= i; t++) {
      const u = s[t], $ = r[t];
      if (u !== $)
        return u === void 0 && $ === void 0 ? 0 : u ? $ ? w(u, $) : -1 : 1;
    }
    return 0;
  }
  function v(e, n) {
    return w(e.major, n.major) || w(e.minor, n.minor) || w(e.patch, n.patch) || he(e, n);
  }
  function P(e, n) {
    return e.version === n.version;
  }
  function ve(e, n) {
    switch (e.operator) {
      case "":
      case "=":
        return P(e, n);
      case ">":
        return v(e, n) < 0;
      case ">=":
        return P(e, n) || v(e, n) < 0;
      case "<":
        return v(e, n) > 0;
      case "<=":
        return P(e, n) || v(e, n) > 0;
      case void 0:
        return true;
      default:
        return false;
    }
  }
  function Ve(e) {
    return D(le, pe, de, _e)(e);
  }
  function we(e) {
    return D(ce, ae, fe, oe)(e.trim()).split(/\s+/).join(" ");
  }
  function be(e, n) {
    if (!e)
      return false;
    const t = we(n).split(" ").map((p) => Ve(p)).join(" ").split(/\s+/).map((p) => Re(p)), i = U(e);
    if (!i)
      return false;
    const [, u, , $, a, f, o] = i, h = {
      operator: u,
      version: z($, a, f, o),
      major: $,
      minor: a,
      patch: f,
      preRelease: o == null ? void 0 : o.split(".")
    };
    for (const p of t) {
      const C = U(p);
      if (!C)
        return false;
      const [, H, , I, O, q, g] = C, M = {
        operator: H,
        version: z(I, O, q, g),
        major: I,
        minor: O,
        patch: q,
        preRelease: g == null ? void 0 : g.split(".")
      };
      if (!ve(M, h))
        return false;
    }
    return true;
  }
  const Z = {}, T = {
    react: {
      get: () => () => _(new URL("__federation_shared_react-4c3735b8.js", import.meta.url).href),
      import: true
    },
    "react-dom": {
      get: () => () => _(new URL("__federation_shared_react-dom-241c8faf.js", import.meta.url).href),
      import: true
    },
    "@emotion/react": {
      get: () => () => _(new URL("__federation_shared_@emotion/react-fb379a26.js", import.meta.url).href),
      import: true
    },
    "react-router-dom": {
      get: () => () => _(new URL("__federation_shared_react-router-dom-2c3ac8af.js", import.meta.url).href),
      import: true
    },
    "fivem-nui-react-lib": {
      get: () => () => _(new URL("__federation_shared_fivem-nui-react-lib-ef4409b9.js", import.meta.url).href),
      import: true
    }
  }, b = /* @__PURE__ */ Object.create(null);
  Te = async function(e, n = "default") {
    return b[e] ? new Promise((s) => s(b[e])) : await ge(e, n) || Le(e);
  };
  async function _(e) {
    return Z[e] ?? (Z[e] = N(() => import(e).then(async (m2) => {
      await m2.__tla;
      return m2;
    }), [], import.meta.url)), Z[e];
  }
  ge = async function(e, n) {
    var _a, _b, _c;
    let s = null;
    if ((_b = (_a = globalThis == null ? void 0 : globalThis.__federation_shared__) == null ? void 0 : _a[n]) == null ? void 0 : _b[e]) {
      const r = globalThis.__federation_shared__[n][e], t = (_c = T[e]) == null ? void 0 : _c.requiredVersion;
      if (!!t) {
        const u = Object.keys(r).find(($) => be($, t));
        u ? s = await (await r[u].get())() : console.log(`provider support ${e}(${u}) is not satisfied requiredVersion(\${moduleMap[name].requiredVersion})`);
      } else {
        const u = Object.keys(r)[0];
        s = await (await r[u].get())();
      }
    }
    if (s)
      return G(s, e);
  };
  Le = async function(e) {
    var _a;
    if ((_a = T[e]) == null ? void 0 : _a.import) {
      let n = await (await T[e].get())();
      return G(n, e);
    } else
      console.error("consumer config import=false,so cant use callback shared module");
  };
  function G(e, n) {
    return typeof e.default == "function" ? (Object.keys(e).forEach((s) => {
      s !== "default" && (e.default[s] = e[s]);
    }), b[n] = e.default, e.default) : (e.default && (e = Object.assign({}, e.default, e)), b[n] = e, e);
  }
})();
export {
  __tla,
  Te as importShared,
  Le as importSharedLocal,
  ge as importSharedRuntime
};
