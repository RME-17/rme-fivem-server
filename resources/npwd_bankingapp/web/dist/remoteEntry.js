let y, j, x;
let __tla = (async () => {
  const E = (n) => n();
  const g = {}, w = /* @__PURE__ */ new Set([
    "Module",
    "__esModule",
    "default",
    "_export_sfc"
  ]);
  let p = {
    "./config": () => (y([
      "App-ce5ec729.css"
    ], false, "./config"), T("./__federation_expose_Config-69939bb1.js").then((e) => Object.keys(e).every((s) => w.has(s)) ? () => e.default : () => e))
  };
  let m;
  m = {};
  y = (e, s, l) => {
    const r = document.currentScript && document.currentScript.src || "";
    if (typeof r > "u") {
      console.warn('The remote style takes effect only when the build.target option in the vite.config.ts file is higher than that of "es2020".');
      return;
    }
    const i = r.substring(0, r.lastIndexOf("remoteEntry.js")), _ = "./";
    "", e.forEach((a) => {
      let n = "";
      const c = _ || i;
      if (c) {
        const o = {
          trailing: (t) => t.endsWith("/") ? t.slice(0, -1) : t,
          leading: (t) => t.startsWith("/") ? t.slice(1) : t
        }, b = (t) => t.startsWith("http") || t.startsWith("//"), d = o.trailing(c), h = o.leading(a), u = o.trailing(i);
        b(c) ? n = [
          d,
          h
        ].filter(Boolean).join("/") : u.includes(d) ? n = [
          u,
          h
        ].filter(Boolean).join("/") : n = [
          u + d,
          h
        ].filter(Boolean).join("/");
      } else
        n = a;
      if (s) {
        const o = "css__mockapp__" + l;
        window[o] = window[o] || [], window[o].push(n);
        return;
      }
      if (n in m)
        return;
      m[n] = true;
      const f = document.createElement("link");
      f.rel = "stylesheet", f.href = n, document.head.appendChild(f);
    });
  };
  async function T(e) {
    return g[e] ?? (g[e] = E(() => import(e).then(async (m2) => {
      await m2.__tla;
      return m2;
    }), [], document.currentScript && document.currentScript.src || "")), g[e];
  }
  j = (e) => {
    if (!p[e])
      throw new Error("Can not find remote module " + e);
    return p[e]();
  };
  x = (e) => {
    globalThis.__federation_shared__ = globalThis.__federation_shared__ || {}, Object.entries(e).forEach(([s, l]) => {
      for (const [r, i] of Object.entries(l)) {
        const _ = i.scope || "default";
        globalThis.__federation_shared__[_] = globalThis.__federation_shared__[_] || {};
        const a = globalThis.__federation_shared__[_];
        (a[s] = a[s] || {})[r] = i;
      }
    });
  };
})();
export {
  __tla,
  y as dynamicLoadingCss,
  j as get,
  x as init
};
