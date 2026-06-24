const f = function() {
  const n = typeof document < "u" && document.createElement("link").relList;
  return n && n.supports && n.supports("modulepreload") ? "modulepreload" : "preload";
}(), h = function(l, n) {
  return new URL(l, n).href;
}, u = {}, p = function(n, i, c) {
  if (!i || i.length === 0)
    return n();
  const a = document.getElementsByTagName("link");
  return Promise.all(i.map((e) => {
    if (e = h(e, c), e in u)
      return;
    u[e] = true;
    const t = e.endsWith(".css"), d = t ? '[rel="stylesheet"]' : "";
    if (!!c)
      for (let s = a.length - 1; s >= 0; s--) {
        const o = a[s];
        if (o.href === e && (!t || o.rel === "stylesheet"))
          return;
      }
    else if (document.querySelector(`link[href="${e}"]${d}`))
      return;
    const r = document.createElement("link");
    if (r.rel = t ? "stylesheet" : f, t || (r.as = "script", r.crossOrigin = ""), r.href = e, document.head.appendChild(r), t)
      return new Promise((s, o) => {
        r.addEventListener("load", s), r.addEventListener("error", () => o(new Error(`Unable to preload CSS for ${e}`)));
      });
  })).then(() => n()).catch((e) => {
    const t = new Event("vite:preloadError", { cancelable: true });
    if (t.payload = e, window.dispatchEvent(t), !t.defaultPrevented)
      throw e;
  });
};
export {
  p as _
};
