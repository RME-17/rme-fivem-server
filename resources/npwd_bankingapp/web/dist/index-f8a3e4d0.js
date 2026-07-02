import { importShared as B, __tla as __tla_0 } from "./__federation_fn_import-39357cc7.js";
import { j as pe } from "./jsx-runtime-dc228b70.js";
import { s as Z, __tla as __tla_1 } from "./App-0006d0cc.js";
Promise.all([
  (() => {
    try {
      return __tla_0;
    } catch {
    }
  })(),
  (() => {
    try {
      return __tla_1;
    } catch {
    }
  })()
]).then(async () => {
  const c = (n) => typeof n == "string", A = () => {
    let n, e;
    const t = new Promise((s, i) => {
      n = s, e = i;
    });
    return t.resolve = n, t.reject = e, t;
  }, ee = (n) => n == null ? "" : "" + n, me = (n, e, t) => {
    n.forEach((s) => {
      e[s] && (t[s] = e[s]);
    });
  }, xe = /###/g, te = (n) => n && n.indexOf("###") > -1 ? n.replace(xe, ".") : n, se = (n) => !n || c(n), D = (n, e, t) => {
    const s = c(e) ? e.split(".") : e;
    let i = 0;
    for (; i < s.length - 1; ) {
      if (se(n))
        return {};
      const r = te(s[i]);
      !n[r] && t && (n[r] = new t()), Object.prototype.hasOwnProperty.call(n, r) ? n = n[r] : n = {}, ++i;
    }
    return se(n) ? {} : {
      obj: n,
      k: te(s[i])
    };
  }, ie = (n, e, t) => {
    const { obj: s, k: i } = D(n, e, Object);
    if (s !== void 0 || e.length === 1) {
      s[i] = t;
      return;
    }
    let r = e[e.length - 1], a = e.slice(0, e.length - 1), o = D(n, a, Object);
    for (; o.obj === void 0 && a.length; )
      r = `${a[a.length - 1]}.${r}`, a = a.slice(0, a.length - 1), o = D(n, a, Object), o && o.obj && typeof o.obj[`${o.k}.${r}`] < "u" && (o.obj = void 0);
    o.obj[`${o.k}.${r}`] = t;
  }, be = (n, e, t, s) => {
    const { obj: i, k: r } = D(n, e, Object);
    i[r] = i[r] || [], i[r].push(t);
  }, M = (n, e) => {
    const { obj: t, k: s } = D(n, e);
    if (t)
      return t[s];
  }, ye = (n, e, t) => {
    const s = M(n, t);
    return s !== void 0 ? s : M(e, t);
  }, he = (n, e, t) => {
    for (const s in e)
      s !== "__proto__" && s !== "constructor" && (s in n ? c(n[s]) || n[s] instanceof String || c(e[s]) || e[s] instanceof String ? t && (n[s] = e[s]) : he(n[s], e[s], t) : n[s] = e[s]);
    return n;
  }, P = (n) => n.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
  var Se = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;",
    "/": "&#x2F;"
  };
  const ve = (n) => c(n) ? n.replace(/[&<>"'\/]/g, (e) => Se[e]) : n;
  class Le {
    constructor(e) {
      this.capacity = e, this.regExpMap = /* @__PURE__ */ new Map(), this.regExpQueue = [];
    }
    getRegExp(e) {
      const t = this.regExpMap.get(e);
      if (t !== void 0)
        return t;
      const s = new RegExp(e);
      return this.regExpQueue.length === this.capacity && this.regExpMap.delete(this.regExpQueue.shift()), this.regExpMap.set(e, s), this.regExpQueue.push(e), s;
    }
  }
  const Oe = [
    " ",
    ",",
    "?",
    "!",
    ";"
  ], we = new Le(20), Ce = (n, e, t) => {
    e = e || "", t = t || "";
    const s = Oe.filter((a) => e.indexOf(a) < 0 && t.indexOf(a) < 0);
    if (s.length === 0)
      return true;
    const i = we.getRegExp(`(${s.map((a) => a === "?" ? "\\?" : a).join("|")})`);
    let r = !i.test(n);
    if (!r) {
      const a = n.indexOf(t);
      a > 0 && !i.test(n.substring(0, a)) && (r = true);
    }
    return r;
  }, G = function(n, e) {
    let t = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : ".";
    if (!n)
      return;
    if (n[e])
      return n[e];
    const s = e.split(t);
    let i = n;
    for (let r = 0; r < s.length; ) {
      if (!i || typeof i != "object")
        return;
      let a, o = "";
      for (let l = r; l < s.length; ++l)
        if (l !== r && (o += t), o += s[l], a = i[o], a !== void 0) {
          if ([
            "string",
            "number",
            "boolean"
          ].indexOf(typeof a) > -1 && l < s.length - 1)
            continue;
          r += l - r + 1;
          break;
        }
      i = a;
    }
    return i;
  }, z = (n) => n && n.replace("_", "-"), Ne = {
    type: "logger",
    log(n) {
      this.output("log", n);
    },
    warn(n) {
      this.output("warn", n);
    },
    error(n) {
      this.output("error", n);
    },
    output(n, e) {
      console && console[n] && console[n].apply(console, e);
    }
  };
  class H {
    constructor(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      this.init(e, t);
    }
    init(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      this.prefix = t.prefix || "i18next:", this.logger = e || Ne, this.options = t, this.debug = t.debug;
    }
    log() {
      for (var e = arguments.length, t = new Array(e), s = 0; s < e; s++)
        t[s] = arguments[s];
      return this.forward(t, "log", "", true);
    }
    warn() {
      for (var e = arguments.length, t = new Array(e), s = 0; s < e; s++)
        t[s] = arguments[s];
      return this.forward(t, "warn", "", true);
    }
    error() {
      for (var e = arguments.length, t = new Array(e), s = 0; s < e; s++)
        t[s] = arguments[s];
      return this.forward(t, "error", "");
    }
    deprecate() {
      for (var e = arguments.length, t = new Array(e), s = 0; s < e; s++)
        t[s] = arguments[s];
      return this.forward(t, "warn", "WARNING DEPRECATED: ", true);
    }
    forward(e, t, s, i) {
      return i && !this.debug ? null : (c(e[0]) && (e[0] = `${s}${this.prefix} ${e[0]}`), this.logger[t](e));
    }
    create(e) {
      return new H(this.logger, {
        prefix: `${this.prefix}:${e}:`,
        ...this.options
      });
    }
    clone(e) {
      return e = e || this.options, e.prefix = e.prefix || this.prefix, new H(this.logger, e);
    }
  }
  var N = new H();
  class W {
    constructor() {
      this.observers = {};
    }
    on(e, t) {
      return e.split(" ").forEach((s) => {
        this.observers[s] || (this.observers[s] = /* @__PURE__ */ new Map());
        const i = this.observers[s].get(t) || 0;
        this.observers[s].set(t, i + 1);
      }), this;
    }
    off(e, t) {
      if (this.observers[e]) {
        if (!t) {
          delete this.observers[e];
          return;
        }
        this.observers[e].delete(t);
      }
    }
    emit(e) {
      for (var t = arguments.length, s = new Array(t > 1 ? t - 1 : 0), i = 1; i < t; i++)
        s[i - 1] = arguments[i];
      this.observers[e] && Array.from(this.observers[e].entries()).forEach((a) => {
        let [o, l] = a;
        for (let f = 0; f < l; f++)
          o(...s);
      }), this.observers["*"] && Array.from(this.observers["*"].entries()).forEach((a) => {
        let [o, l] = a;
        for (let f = 0; f < l; f++)
          o.apply(o, [
            e,
            ...s
          ]);
      });
    }
  }
  class ne extends W {
    constructor(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {
        ns: [
          "translation"
        ],
        defaultNS: "translation"
      };
      super(), this.data = e || {}, this.options = t, this.options.keySeparator === void 0 && (this.options.keySeparator = "."), this.options.ignoreJSONStructure === void 0 && (this.options.ignoreJSONStructure = true);
    }
    addNamespaces(e) {
      this.options.ns.indexOf(e) < 0 && this.options.ns.push(e);
    }
    removeNamespaces(e) {
      const t = this.options.ns.indexOf(e);
      t > -1 && this.options.ns.splice(t, 1);
    }
    getResource(e, t, s) {
      let i = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : {};
      const r = i.keySeparator !== void 0 ? i.keySeparator : this.options.keySeparator, a = i.ignoreJSONStructure !== void 0 ? i.ignoreJSONStructure : this.options.ignoreJSONStructure;
      let o;
      e.indexOf(".") > -1 ? o = e.split(".") : (o = [
        e,
        t
      ], s && (Array.isArray(s) ? o.push(...s) : c(s) && r ? o.push(...s.split(r)) : o.push(s)));
      const l = M(this.data, o);
      return !l && !t && !s && e.indexOf(".") > -1 && (e = o[0], t = o[1], s = o.slice(2).join(".")), l || !a || !c(s) ? l : G(this.data && this.data[e] && this.data[e][t], s, r);
    }
    addResource(e, t, s, i) {
      let r = arguments.length > 4 && arguments[4] !== void 0 ? arguments[4] : {
        silent: false
      };
      const a = r.keySeparator !== void 0 ? r.keySeparator : this.options.keySeparator;
      let o = [
        e,
        t
      ];
      s && (o = o.concat(a ? s.split(a) : s)), e.indexOf(".") > -1 && (o = e.split("."), i = t, t = o[1]), this.addNamespaces(t), ie(this.data, o, i), r.silent || this.emit("added", e, t, s, i);
    }
    addResources(e, t, s) {
      let i = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : {
        silent: false
      };
      for (const r in s)
        (c(s[r]) || Array.isArray(s[r])) && this.addResource(e, t, r, s[r], {
          silent: true
        });
      i.silent || this.emit("added", e, t, s);
    }
    addResourceBundle(e, t, s, i, r) {
      let a = arguments.length > 5 && arguments[5] !== void 0 ? arguments[5] : {
        silent: false,
        skipCopy: false
      }, o = [
        e,
        t
      ];
      e.indexOf(".") > -1 && (o = e.split("."), i = s, s = t, t = o[1]), this.addNamespaces(t);
      let l = M(this.data, o) || {};
      a.skipCopy || (s = JSON.parse(JSON.stringify(s))), i ? he(l, s, r) : l = {
        ...l,
        ...s
      }, ie(this.data, o, l), a.silent || this.emit("added", e, t, s);
    }
    removeResourceBundle(e, t) {
      this.hasResourceBundle(e, t) && delete this.data[e][t], this.removeNamespaces(t), this.emit("removed", e, t);
    }
    hasResourceBundle(e, t) {
      return this.getResource(e, t) !== void 0;
    }
    getResourceBundle(e, t) {
      return t || (t = this.options.defaultNS), this.options.compatibilityAPI === "v1" ? {
        ...this.getResource(e, t)
      } : this.getResource(e, t);
    }
    getDataByLanguage(e) {
      return this.data[e];
    }
    hasLanguageSomeTranslations(e) {
      const t = this.getDataByLanguage(e);
      return !!(t && Object.keys(t) || []).find((i) => t[i] && Object.keys(t[i]).length > 0);
    }
    toJSON() {
      return this.data;
    }
  }
  var ge = {
    processors: {},
    addPostProcessor(n) {
      this.processors[n.name] = n;
    },
    handle(n, e, t, s, i) {
      return n.forEach((r) => {
        this.processors[r] && (e = this.processors[r].process(e, t, s, i));
      }), e;
    }
  };
  const re = {};
  class J extends W {
    constructor(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      super(), me([
        "resourceStore",
        "languageUtils",
        "pluralResolver",
        "interpolator",
        "backendConnector",
        "i18nFormat",
        "utils"
      ], e, this), this.options = t, this.options.keySeparator === void 0 && (this.options.keySeparator = "."), this.logger = N.create("translator");
    }
    changeLanguage(e) {
      e && (this.language = e);
    }
    exists(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {
        interpolation: {}
      };
      if (e == null)
        return false;
      const s = this.resolve(e, t);
      return s && s.res !== void 0;
    }
    extractFromKey(e, t) {
      let s = t.nsSeparator !== void 0 ? t.nsSeparator : this.options.nsSeparator;
      s === void 0 && (s = ":");
      const i = t.keySeparator !== void 0 ? t.keySeparator : this.options.keySeparator;
      let r = t.ns || this.options.defaultNS || [];
      const a = s && e.indexOf(s) > -1, o = !this.options.userDefinedKeySeparator && !t.keySeparator && !this.options.userDefinedNsSeparator && !t.nsSeparator && !Ce(e, s, i);
      if (a && !o) {
        const l = e.match(this.interpolator.nestingRegexp);
        if (l && l.length > 0)
          return {
            key: e,
            namespaces: c(r) ? [
              r
            ] : r
          };
        const f = e.split(s);
        (s !== i || s === i && this.options.ns.indexOf(f[0]) > -1) && (r = f.shift()), e = f.join(i);
      }
      return {
        key: e,
        namespaces: c(r) ? [
          r
        ] : r
      };
    }
    translate(e, t, s) {
      if (typeof t != "object" && this.options.overloadTranslationOptionHandler && (t = this.options.overloadTranslationOptionHandler(arguments)), typeof t == "object" && (t = {
        ...t
      }), t || (t = {}), e == null)
        return "";
      Array.isArray(e) || (e = [
        String(e)
      ]);
      const i = t.returnDetails !== void 0 ? t.returnDetails : this.options.returnDetails, r = t.keySeparator !== void 0 ? t.keySeparator : this.options.keySeparator, { key: a, namespaces: o } = this.extractFromKey(e[e.length - 1], t), l = o[o.length - 1], f = t.lng || this.language, h = t.appendNamespaceToCIMode || this.options.appendNamespaceToCIMode;
      if (f && f.toLowerCase() === "cimode") {
        if (h) {
          const b = t.nsSeparator || this.options.nsSeparator;
          return i ? {
            res: `${l}${b}${a}`,
            usedKey: a,
            exactUsedKey: a,
            usedLng: f,
            usedNS: l,
            usedParams: this.getUsedParamsDetails(t)
          } : `${l}${b}${a}`;
        }
        return i ? {
          res: a,
          usedKey: a,
          exactUsedKey: a,
          usedLng: f,
          usedNS: l,
          usedParams: this.getUsedParamsDetails(t)
        } : a;
      }
      const g = this.resolve(e, t);
      let u = g && g.res;
      const d = g && g.usedKey || a, p = g && g.exactUsedKey || a, x = Object.prototype.toString.apply(u), m = [
        "[object Number]",
        "[object Function]",
        "[object RegExp]"
      ], L = t.joinArrays !== void 0 ? t.joinArrays : this.options.joinArrays, y = !this.i18nFormat || this.i18nFormat.handleAsObject, k = !c(u) && typeof u != "boolean" && typeof u != "number";
      if (y && u && k && m.indexOf(x) < 0 && !(c(L) && Array.isArray(u))) {
        if (!t.returnObjects && !this.options.returnObjects) {
          this.options.returnedObjectHandler || this.logger.warn("accessing an object - but returnObjects options is not enabled!");
          const b = this.options.returnedObjectHandler ? this.options.returnedObjectHandler(d, u, {
            ...t,
            ns: o
          }) : `key '${a} (${this.language})' returned an object instead of string.`;
          return i ? (g.res = b, g.usedParams = this.getUsedParamsDetails(t), g) : b;
        }
        if (r) {
          const b = Array.isArray(u), O = b ? [] : {}, C = b ? p : d;
          for (const S in u)
            if (Object.prototype.hasOwnProperty.call(u, S)) {
              const T = `${C}${r}${S}`;
              O[S] = this.translate(T, {
                ...t,
                joinArrays: false,
                ns: o
              }), O[S] === T && (O[S] = u[S]);
            }
          u = O;
        }
      } else if (y && c(L) && Array.isArray(u))
        u = u.join(L), u && (u = this.extendTranslation(u, e, t, s));
      else {
        let b = false, O = false;
        const C = t.count !== void 0 && !c(t.count), S = J.hasDefaultValue(t), T = C ? this.pluralResolver.getSuffix(f, t.count, t) : "", de = t.ordinal && C ? this.pluralResolver.getSuffix(f, t.count, {
          ordinal: false
        }) : "", X = C && !t.ordinal && t.count === 0 && this.pluralResolver.shouldUseIntlApi(), E = X && t[`defaultValue${this.options.pluralSeparator}zero`] || t[`defaultValue${T}`] || t[`defaultValue${de}`] || t.defaultValue;
        !this.isValidLookup(u) && S && (b = true, u = E), this.isValidLookup(u) || (O = true, u = a);
        const ce = (t.missingKeyNoValueFallbackToKey || this.options.missingKeyNoValueFallbackToKey) && O ? void 0 : u, F = S && E !== u && this.options.updateMissing;
        if (O || b || F) {
          if (this.logger.log(F ? "updateKey" : "missingKey", f, l, a, F ? E : u), r) {
            const w = this.resolve(a, {
              ...t,
              keySeparator: false
            });
            w && w.res && this.logger.warn("Seems the loaded translations were in flat JSON format instead of nested. Either set keySeparator: false on init or make sure your translations are published in nested format.");
          }
          let j = [];
          const K = this.languageUtils.getFallbackCodes(this.options.fallbackLng, t.lng || this.language);
          if (this.options.saveMissingTo === "fallback" && K && K[0])
            for (let w = 0; w < K.length; w++)
              j.push(K[w]);
          else
            this.options.saveMissingTo === "all" ? j = this.languageUtils.toResolveHierarchy(t.lng || this.language) : j.push(t.lng || this.language);
          const q = (w, R, I) => {
            const _ = S && I !== u ? I : ce;
            this.options.missingKeyHandler ? this.options.missingKeyHandler(w, l, R, _, F, t) : this.backendConnector && this.backendConnector.saveMissing && this.backendConnector.saveMissing(w, l, R, _, F, t), this.emit("missingKey", w, l, R, u);
          };
          this.options.saveMissing && (this.options.saveMissingPlurals && C ? j.forEach((w) => {
            const R = this.pluralResolver.getSuffixes(w, t);
            X && t[`defaultValue${this.options.pluralSeparator}zero`] && R.indexOf(`${this.options.pluralSeparator}zero`) < 0 && R.push(`${this.options.pluralSeparator}zero`), R.forEach((I) => {
              q([
                w
              ], a + I, t[`defaultValue${I}`] || E);
            });
          }) : q(j, a, E));
        }
        u = this.extendTranslation(u, e, t, g, s), O && u === a && this.options.appendNamespaceToMissingKey && (u = `${l}:${a}`), (O || b) && this.options.parseMissingKeyHandler && (this.options.compatibilityAPI !== "v1" ? u = this.options.parseMissingKeyHandler(this.options.appendNamespaceToMissingKey ? `${l}:${a}` : a, b ? u : void 0) : u = this.options.parseMissingKeyHandler(u));
      }
      return i ? (g.res = u, g.usedParams = this.getUsedParamsDetails(t), g) : u;
    }
    extendTranslation(e, t, s, i, r) {
      var a = this;
      if (this.i18nFormat && this.i18nFormat.parse)
        e = this.i18nFormat.parse(e, {
          ...this.options.interpolation.defaultVariables,
          ...s
        }, s.lng || this.language || i.usedLng, i.usedNS, i.usedKey, {
          resolved: i
        });
      else if (!s.skipInterpolation) {
        s.interpolation && this.interpolator.init({
          ...s,
          interpolation: {
            ...this.options.interpolation,
            ...s.interpolation
          }
        });
        const f = c(e) && (s && s.interpolation && s.interpolation.skipOnVariables !== void 0 ? s.interpolation.skipOnVariables : this.options.interpolation.skipOnVariables);
        let h;
        if (f) {
          const u = e.match(this.interpolator.nestingRegexp);
          h = u && u.length;
        }
        let g = s.replace && !c(s.replace) ? s.replace : s;
        if (this.options.interpolation.defaultVariables && (g = {
          ...this.options.interpolation.defaultVariables,
          ...g
        }), e = this.interpolator.interpolate(e, g, s.lng || this.language || i.usedLng, s), f) {
          const u = e.match(this.interpolator.nestingRegexp), d = u && u.length;
          h < d && (s.nest = false);
        }
        !s.lng && this.options.compatibilityAPI !== "v1" && i && i.res && (s.lng = this.language || i.usedLng), s.nest !== false && (e = this.interpolator.nest(e, function() {
          for (var u = arguments.length, d = new Array(u), p = 0; p < u; p++)
            d[p] = arguments[p];
          return r && r[0] === d[0] && !s.context ? (a.logger.warn(`It seems you are nesting recursively key: ${d[0]} in key: ${t[0]}`), null) : a.translate(...d, t);
        }, s)), s.interpolation && this.interpolator.reset();
      }
      const o = s.postProcess || this.options.postProcess, l = c(o) ? [
        o
      ] : o;
      return e != null && l && l.length && s.applyPostProcessor !== false && (e = ge.handle(l, e, t, this.options && this.options.postProcessPassResolved ? {
        i18nResolved: {
          ...i,
          usedParams: this.getUsedParamsDetails(s)
        },
        ...s
      } : s, this)), e;
    }
    resolve(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {}, s, i, r, a, o;
      return c(e) && (e = [
        e
      ]), e.forEach((l) => {
        if (this.isValidLookup(s))
          return;
        const f = this.extractFromKey(l, t), h = f.key;
        i = h;
        let g = f.namespaces;
        this.options.fallbackNS && (g = g.concat(this.options.fallbackNS));
        const u = t.count !== void 0 && !c(t.count), d = u && !t.ordinal && t.count === 0 && this.pluralResolver.shouldUseIntlApi(), p = t.context !== void 0 && (c(t.context) || typeof t.context == "number") && t.context !== "", x = t.lngs ? t.lngs : this.languageUtils.toResolveHierarchy(t.lng || this.language, t.fallbackLng);
        g.forEach((m) => {
          this.isValidLookup(s) || (o = m, !re[`${x[0]}-${m}`] && this.utils && this.utils.hasLoadedNamespace && !this.utils.hasLoadedNamespace(o) && (re[`${x[0]}-${m}`] = true, this.logger.warn(`key "${i}" for languages "${x.join(", ")}" won't get resolved as namespace "${o}" was not yet loaded`, "This means something IS WRONG in your setup. You access the t function before i18next.init / i18next.loadNamespace / i18next.changeLanguage was done. Wait for the callback or Promise to resolve before accessing it!!!")), x.forEach((L) => {
            if (this.isValidLookup(s))
              return;
            a = L;
            const y = [
              h
            ];
            if (this.i18nFormat && this.i18nFormat.addLookupKeys)
              this.i18nFormat.addLookupKeys(y, h, L, m, t);
            else {
              let b;
              u && (b = this.pluralResolver.getSuffix(L, t.count, t));
              const O = `${this.options.pluralSeparator}zero`, C = `${this.options.pluralSeparator}ordinal${this.options.pluralSeparator}`;
              if (u && (y.push(h + b), t.ordinal && b.indexOf(C) === 0 && y.push(h + b.replace(C, this.options.pluralSeparator)), d && y.push(h + O)), p) {
                const S = `${h}${this.options.contextSeparator}${t.context}`;
                y.push(S), u && (y.push(S + b), t.ordinal && b.indexOf(C) === 0 && y.push(S + b.replace(C, this.options.pluralSeparator)), d && y.push(S + O));
              }
            }
            let k;
            for (; k = y.pop(); )
              this.isValidLookup(s) || (r = k, s = this.getResource(L, m, k, t));
          }));
        });
      }), {
        res: s,
        usedKey: i,
        exactUsedKey: r,
        usedLng: a,
        usedNS: o
      };
    }
    isValidLookup(e) {
      return e !== void 0 && !(!this.options.returnNull && e === null) && !(!this.options.returnEmptyString && e === "");
    }
    getResource(e, t, s) {
      let i = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : {};
      return this.i18nFormat && this.i18nFormat.getResource ? this.i18nFormat.getResource(e, t, s, i) : this.resourceStore.getResource(e, t, s, i);
    }
    getUsedParamsDetails() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
      const t = [
        "defaultValue",
        "ordinal",
        "context",
        "replace",
        "lng",
        "lngs",
        "fallbackLng",
        "ns",
        "keySeparator",
        "nsSeparator",
        "returnObjects",
        "returnDetails",
        "joinArrays",
        "postProcess",
        "interpolation"
      ], s = e.replace && !c(e.replace);
      let i = s ? e.replace : e;
      if (s && typeof e.count < "u" && (i.count = e.count), this.options.interpolation.defaultVariables && (i = {
        ...this.options.interpolation.defaultVariables,
        ...i
      }), !s) {
        i = {
          ...i
        };
        for (const r of t)
          delete i[r];
      }
      return i;
    }
    static hasDefaultValue(e) {
      const t = "defaultValue";
      for (const s in e)
        if (Object.prototype.hasOwnProperty.call(e, s) && t === s.substring(0, t.length) && e[s] !== void 0)
          return true;
      return false;
    }
  }
  const Q = (n) => n.charAt(0).toUpperCase() + n.slice(1);
  class ae {
    constructor(e) {
      this.options = e, this.supportedLngs = this.options.supportedLngs || false, this.logger = N.create("languageUtils");
    }
    getScriptPartFromCode(e) {
      if (e = z(e), !e || e.indexOf("-") < 0)
        return null;
      const t = e.split("-");
      return t.length === 2 || (t.pop(), t[t.length - 1].toLowerCase() === "x") ? null : this.formatLanguageCode(t.join("-"));
    }
    getLanguagePartFromCode(e) {
      if (e = z(e), !e || e.indexOf("-") < 0)
        return e;
      const t = e.split("-");
      return this.formatLanguageCode(t[0]);
    }
    formatLanguageCode(e) {
      if (c(e) && e.indexOf("-") > -1) {
        if (typeof Intl < "u" && typeof Intl.getCanonicalLocales < "u")
          try {
            let i = Intl.getCanonicalLocales(e)[0];
            if (i && this.options.lowerCaseLng && (i = i.toLowerCase()), i)
              return i;
          } catch {
          }
        const t = [
          "hans",
          "hant",
          "latn",
          "cyrl",
          "cans",
          "mong",
          "arab"
        ];
        let s = e.split("-");
        return this.options.lowerCaseLng ? s = s.map((i) => i.toLowerCase()) : s.length === 2 ? (s[0] = s[0].toLowerCase(), s[1] = s[1].toUpperCase(), t.indexOf(s[1].toLowerCase()) > -1 && (s[1] = Q(s[1].toLowerCase()))) : s.length === 3 && (s[0] = s[0].toLowerCase(), s[1].length === 2 && (s[1] = s[1].toUpperCase()), s[0] !== "sgn" && s[2].length === 2 && (s[2] = s[2].toUpperCase()), t.indexOf(s[1].toLowerCase()) > -1 && (s[1] = Q(s[1].toLowerCase())), t.indexOf(s[2].toLowerCase()) > -1 && (s[2] = Q(s[2].toLowerCase()))), s.join("-");
      }
      return this.options.cleanCode || this.options.lowerCaseLng ? e.toLowerCase() : e;
    }
    isSupportedCode(e) {
      return (this.options.load === "languageOnly" || this.options.nonExplicitSupportedLngs) && (e = this.getLanguagePartFromCode(e)), !this.supportedLngs || !this.supportedLngs.length || this.supportedLngs.indexOf(e) > -1;
    }
    getBestMatchFromCodes(e) {
      if (!e)
        return null;
      let t;
      return e.forEach((s) => {
        if (t)
          return;
        const i = this.formatLanguageCode(s);
        (!this.options.supportedLngs || this.isSupportedCode(i)) && (t = i);
      }), !t && this.options.supportedLngs && e.forEach((s) => {
        if (t)
          return;
        const i = this.getLanguagePartFromCode(s);
        if (this.isSupportedCode(i))
          return t = i;
        t = this.options.supportedLngs.find((r) => {
          if (r === i)
            return r;
          if (!(r.indexOf("-") < 0 && i.indexOf("-") < 0) && (r.indexOf("-") > 0 && i.indexOf("-") < 0 && r.substring(0, r.indexOf("-")) === i || r.indexOf(i) === 0 && i.length > 1))
            return r;
        });
      }), t || (t = this.getFallbackCodes(this.options.fallbackLng)[0]), t;
    }
    getFallbackCodes(e, t) {
      if (!e)
        return [];
      if (typeof e == "function" && (e = e(t)), c(e) && (e = [
        e
      ]), Array.isArray(e))
        return e;
      if (!t)
        return e.default || [];
      let s = e[t];
      return s || (s = e[this.getScriptPartFromCode(t)]), s || (s = e[this.formatLanguageCode(t)]), s || (s = e[this.getLanguagePartFromCode(t)]), s || (s = e.default), s || [];
    }
    toResolveHierarchy(e, t) {
      const s = this.getFallbackCodes(t || this.options.fallbackLng || [], e), i = [], r = (a) => {
        a && (this.isSupportedCode(a) ? i.push(a) : this.logger.warn(`rejecting language code not found in supportedLngs: ${a}`));
      };
      return c(e) && (e.indexOf("-") > -1 || e.indexOf("_") > -1) ? (this.options.load !== "languageOnly" && r(this.formatLanguageCode(e)), this.options.load !== "languageOnly" && this.options.load !== "currentOnly" && r(this.getScriptPartFromCode(e)), this.options.load !== "currentOnly" && r(this.getLanguagePartFromCode(e))) : c(e) && r(this.formatLanguageCode(e)), s.forEach((a) => {
        i.indexOf(a) < 0 && r(this.formatLanguageCode(a));
      }), i;
    }
  }
  let Re = [
    {
      lngs: [
        "ach",
        "ak",
        "am",
        "arn",
        "br",
        "fil",
        "gun",
        "ln",
        "mfe",
        "mg",
        "mi",
        "oc",
        "pt",
        "pt-BR",
        "tg",
        "tl",
        "ti",
        "tr",
        "uz",
        "wa"
      ],
      nr: [
        1,
        2
      ],
      fc: 1
    },
    {
      lngs: [
        "af",
        "an",
        "ast",
        "az",
        "bg",
        "bn",
        "ca",
        "da",
        "de",
        "dev",
        "el",
        "en",
        "eo",
        "es",
        "et",
        "eu",
        "fi",
        "fo",
        "fur",
        "fy",
        "gl",
        "gu",
        "ha",
        "hi",
        "hu",
        "hy",
        "ia",
        "it",
        "kk",
        "kn",
        "ku",
        "lb",
        "mai",
        "ml",
        "mn",
        "mr",
        "nah",
        "nap",
        "nb",
        "ne",
        "nl",
        "nn",
        "no",
        "nso",
        "pa",
        "pap",
        "pms",
        "ps",
        "pt-PT",
        "rm",
        "sco",
        "se",
        "si",
        "so",
        "son",
        "sq",
        "sv",
        "sw",
        "ta",
        "te",
        "tk",
        "ur",
        "yo"
      ],
      nr: [
        1,
        2
      ],
      fc: 2
    },
    {
      lngs: [
        "ay",
        "bo",
        "cgg",
        "fa",
        "ht",
        "id",
        "ja",
        "jbo",
        "ka",
        "km",
        "ko",
        "ky",
        "lo",
        "ms",
        "sah",
        "su",
        "th",
        "tt",
        "ug",
        "vi",
        "wo",
        "zh"
      ],
      nr: [
        1
      ],
      fc: 3
    },
    {
      lngs: [
        "be",
        "bs",
        "cnr",
        "dz",
        "hr",
        "ru",
        "sr",
        "uk"
      ],
      nr: [
        1,
        2,
        5
      ],
      fc: 4
    },
    {
      lngs: [
        "ar"
      ],
      nr: [
        0,
        1,
        2,
        3,
        11,
        100
      ],
      fc: 5
    },
    {
      lngs: [
        "cs",
        "sk"
      ],
      nr: [
        1,
        2,
        5
      ],
      fc: 6
    },
    {
      lngs: [
        "csb",
        "pl"
      ],
      nr: [
        1,
        2,
        5
      ],
      fc: 7
    },
    {
      lngs: [
        "cy"
      ],
      nr: [
        1,
        2,
        3,
        8
      ],
      fc: 8
    },
    {
      lngs: [
        "fr"
      ],
      nr: [
        1,
        2
      ],
      fc: 9
    },
    {
      lngs: [
        "ga"
      ],
      nr: [
        1,
        2,
        3,
        7,
        11
      ],
      fc: 10
    },
    {
      lngs: [
        "gd"
      ],
      nr: [
        1,
        2,
        3,
        20
      ],
      fc: 11
    },
    {
      lngs: [
        "is"
      ],
      nr: [
        1,
        2
      ],
      fc: 12
    },
    {
      lngs: [
        "jv"
      ],
      nr: [
        0,
        1
      ],
      fc: 13
    },
    {
      lngs: [
        "kw"
      ],
      nr: [
        1,
        2,
        3,
        4
      ],
      fc: 14
    },
    {
      lngs: [
        "lt"
      ],
      nr: [
        1,
        2,
        10
      ],
      fc: 15
    },
    {
      lngs: [
        "lv"
      ],
      nr: [
        1,
        2,
        0
      ],
      fc: 16
    },
    {
      lngs: [
        "mk"
      ],
      nr: [
        1,
        2
      ],
      fc: 17
    },
    {
      lngs: [
        "mnk"
      ],
      nr: [
        0,
        1,
        2
      ],
      fc: 18
    },
    {
      lngs: [
        "mt"
      ],
      nr: [
        1,
        2,
        11,
        20
      ],
      fc: 19
    },
    {
      lngs: [
        "or"
      ],
      nr: [
        2,
        1
      ],
      fc: 2
    },
    {
      lngs: [
        "ro"
      ],
      nr: [
        1,
        2,
        20
      ],
      fc: 20
    },
    {
      lngs: [
        "sl"
      ],
      nr: [
        5,
        1,
        2,
        3
      ],
      fc: 21
    },
    {
      lngs: [
        "he",
        "iw"
      ],
      nr: [
        1,
        2,
        20,
        21
      ],
      fc: 22
    }
  ], Pe = {
    1: (n) => +(n > 1),
    2: (n) => +(n != 1),
    3: (n) => 0,
    4: (n) => n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2,
    5: (n) => n == 0 ? 0 : n == 1 ? 1 : n == 2 ? 2 : n % 100 >= 3 && n % 100 <= 10 ? 3 : n % 100 >= 11 ? 4 : 5,
    6: (n) => n == 1 ? 0 : n >= 2 && n <= 4 ? 1 : 2,
    7: (n) => n == 1 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2,
    8: (n) => n == 1 ? 0 : n == 2 ? 1 : n != 8 && n != 11 ? 2 : 3,
    9: (n) => +(n >= 2),
    10: (n) => n == 1 ? 0 : n == 2 ? 1 : n < 7 ? 2 : n < 11 ? 3 : 4,
    11: (n) => n == 1 || n == 11 ? 0 : n == 2 || n == 12 ? 1 : n > 2 && n < 20 ? 2 : 3,
    12: (n) => +(n % 10 != 1 || n % 100 == 11),
    13: (n) => +(n !== 0),
    14: (n) => n == 1 ? 0 : n == 2 ? 1 : n == 3 ? 2 : 3,
    15: (n) => n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2,
    16: (n) => n % 10 == 1 && n % 100 != 11 ? 0 : n !== 0 ? 1 : 2,
    17: (n) => n == 1 || n % 10 == 1 && n % 100 != 11 ? 0 : 1,
    18: (n) => n == 0 ? 0 : n == 1 ? 1 : 2,
    19: (n) => n == 1 ? 0 : n == 0 || n % 100 > 1 && n % 100 < 11 ? 1 : n % 100 > 10 && n % 100 < 20 ? 2 : 3,
    20: (n) => n == 1 ? 0 : n == 0 || n % 100 > 0 && n % 100 < 20 ? 1 : 2,
    21: (n) => n % 100 == 1 ? 1 : n % 100 == 2 ? 2 : n % 100 == 3 || n % 100 == 4 ? 3 : 0,
    22: (n) => n == 1 ? 0 : n == 2 ? 1 : (n < 0 || n > 10) && n % 10 == 0 ? 2 : 3
  };
  const $e = [
    "v1",
    "v2",
    "v3"
  ], ke = [
    "v4"
  ], oe = {
    zero: 0,
    one: 1,
    two: 2,
    few: 3,
    many: 4,
    other: 5
  }, Ee = () => {
    const n = {};
    return Re.forEach((e) => {
      e.lngs.forEach((t) => {
        n[t] = {
          numbers: e.nr,
          plurals: Pe[e.fc]
        };
      });
    }), n;
  };
  class Fe {
    constructor(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      this.languageUtils = e, this.options = t, this.logger = N.create("pluralResolver"), (!this.options.compatibilityJSON || ke.includes(this.options.compatibilityJSON)) && (typeof Intl > "u" || !Intl.PluralRules) && (this.options.compatibilityJSON = "v3", this.logger.error("Your environment seems not to be Intl API compatible, use an Intl.PluralRules polyfill. Will fallback to the compatibilityJSON v3 format handling.")), this.rules = Ee(), this.pluralRulesCache = {};
    }
    addRule(e, t) {
      this.rules[e] = t;
    }
    clearCache() {
      this.pluralRulesCache = {};
    }
    getRule(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      if (this.shouldUseIntlApi()) {
        const s = z(e === "dev" ? "en" : e), i = t.ordinal ? "ordinal" : "cardinal", r = JSON.stringify({
          cleanedCode: s,
          type: i
        });
        if (r in this.pluralRulesCache)
          return this.pluralRulesCache[r];
        let a;
        try {
          a = new Intl.PluralRules(s, {
            type: i
          });
        } catch {
          if (!e.match(/-|_/))
            return;
          const l = this.languageUtils.getLanguagePartFromCode(e);
          a = this.getRule(l, t);
        }
        return this.pluralRulesCache[r] = a, a;
      }
      return this.rules[e] || this.rules[this.languageUtils.getLanguagePartFromCode(e)];
    }
    needsPlural(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      const s = this.getRule(e, t);
      return this.shouldUseIntlApi() ? s && s.resolvedOptions().pluralCategories.length > 1 : s && s.numbers.length > 1;
    }
    getPluralFormsOfKey(e, t) {
      let s = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {};
      return this.getSuffixes(e, s).map((i) => `${t}${i}`);
    }
    getSuffixes(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      const s = this.getRule(e, t);
      return s ? this.shouldUseIntlApi() ? s.resolvedOptions().pluralCategories.sort((i, r) => oe[i] - oe[r]).map((i) => `${this.options.prepend}${t.ordinal ? `ordinal${this.options.prepend}` : ""}${i}`) : s.numbers.map((i) => this.getSuffix(e, i, t)) : [];
    }
    getSuffix(e, t) {
      let s = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {};
      const i = this.getRule(e, s);
      return i ? this.shouldUseIntlApi() ? `${this.options.prepend}${s.ordinal ? `ordinal${this.options.prepend}` : ""}${i.select(t)}` : this.getSuffixRetroCompatible(i, t) : (this.logger.warn(`no plural rule found for: ${e}`), "");
    }
    getSuffixRetroCompatible(e, t) {
      const s = e.noAbs ? e.plurals(t) : e.plurals(Math.abs(t));
      let i = e.numbers[s];
      this.options.simplifyPluralSuffix && e.numbers.length === 2 && e.numbers[0] === 1 && (i === 2 ? i = "plural" : i === 1 && (i = ""));
      const r = () => this.options.prepend && i.toString() ? this.options.prepend + i.toString() : i.toString();
      return this.options.compatibilityJSON === "v1" ? i === 1 ? "" : typeof i == "number" ? `_plural_${i.toString()}` : r() : this.options.compatibilityJSON === "v2" || this.options.simplifyPluralSuffix && e.numbers.length === 2 && e.numbers[0] === 1 ? r() : this.options.prepend && s.toString() ? this.options.prepend + s.toString() : s.toString();
    }
    shouldUseIntlApi() {
      return !$e.includes(this.options.compatibilityJSON);
    }
  }
  const le = function(n, e, t) {
    let s = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : ".", i = arguments.length > 4 && arguments[4] !== void 0 ? arguments[4] : true, r = ye(n, e, t);
    return !r && i && c(t) && (r = G(n, t, s), r === void 0 && (r = G(e, t, s))), r;
  }, Y = (n) => n.replace(/\$/g, "$$$$");
  class je {
    constructor() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
      this.logger = N.create("interpolator"), this.options = e, this.format = e.interpolation && e.interpolation.format || ((t) => t), this.init(e);
    }
    init() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
      e.interpolation || (e.interpolation = {
        escapeValue: true
      });
      const { escape: t, escapeValue: s, useRawValueToEscape: i, prefix: r, prefixEscaped: a, suffix: o, suffixEscaped: l, formatSeparator: f, unescapeSuffix: h, unescapePrefix: g, nestingPrefix: u, nestingPrefixEscaped: d, nestingSuffix: p, nestingSuffixEscaped: x, nestingOptionsSeparator: m, maxReplaces: L, alwaysFormat: y } = e.interpolation;
      this.escape = t !== void 0 ? t : ve, this.escapeValue = s !== void 0 ? s : true, this.useRawValueToEscape = i !== void 0 ? i : false, this.prefix = r ? P(r) : a || "{{", this.suffix = o ? P(o) : l || "}}", this.formatSeparator = f || ",", this.unescapePrefix = h ? "" : g || "-", this.unescapeSuffix = this.unescapePrefix ? "" : h || "", this.nestingPrefix = u ? P(u) : d || P("$t("), this.nestingSuffix = p ? P(p) : x || P(")"), this.nestingOptionsSeparator = m || ",", this.maxReplaces = L || 1e3, this.alwaysFormat = y !== void 0 ? y : false, this.resetRegExp();
    }
    reset() {
      this.options && this.init(this.options);
    }
    resetRegExp() {
      const e = (t, s) => t && t.source === s ? (t.lastIndex = 0, t) : new RegExp(s, "g");
      this.regexp = e(this.regexp, `${this.prefix}(.+?)${this.suffix}`), this.regexpUnescape = e(this.regexpUnescape, `${this.prefix}${this.unescapePrefix}(.+?)${this.unescapeSuffix}${this.suffix}`), this.nestingRegexp = e(this.nestingRegexp, `${this.nestingPrefix}(.+?)${this.nestingSuffix}`);
    }
    interpolate(e, t, s, i) {
      let r, a, o;
      const l = this.options && this.options.interpolation && this.options.interpolation.defaultVariables || {}, f = (d) => {
        if (d.indexOf(this.formatSeparator) < 0) {
          const L = le(t, l, d, this.options.keySeparator, this.options.ignoreJSONStructure);
          return this.alwaysFormat ? this.format(L, void 0, s, {
            ...i,
            ...t,
            interpolationkey: d
          }) : L;
        }
        const p = d.split(this.formatSeparator), x = p.shift().trim(), m = p.join(this.formatSeparator).trim();
        return this.format(le(t, l, x, this.options.keySeparator, this.options.ignoreJSONStructure), m, s, {
          ...i,
          ...t,
          interpolationkey: x
        });
      };
      this.resetRegExp();
      const h = i && i.missingInterpolationHandler || this.options.missingInterpolationHandler, g = i && i.interpolation && i.interpolation.skipOnVariables !== void 0 ? i.interpolation.skipOnVariables : this.options.interpolation.skipOnVariables;
      return [
        {
          regex: this.regexpUnescape,
          safeValue: (d) => Y(d)
        },
        {
          regex: this.regexp,
          safeValue: (d) => this.escapeValue ? Y(this.escape(d)) : Y(d)
        }
      ].forEach((d) => {
        for (o = 0; r = d.regex.exec(e); ) {
          const p = r[1].trim();
          if (a = f(p), a === void 0)
            if (typeof h == "function") {
              const m = h(e, r, i);
              a = c(m) ? m : "";
            } else if (i && Object.prototype.hasOwnProperty.call(i, p))
              a = "";
            else if (g) {
              a = r[0];
              continue;
            } else
              this.logger.warn(`missed to pass in variable ${p} for interpolating ${e}`), a = "";
          else
            !c(a) && !this.useRawValueToEscape && (a = ee(a));
          const x = d.safeValue(a);
          if (e = e.replace(r[0], x), g ? (d.regex.lastIndex += a.length, d.regex.lastIndex -= r[0].length) : d.regex.lastIndex = 0, o++, o >= this.maxReplaces)
            break;
        }
      }), e;
    }
    nest(e, t) {
      let s = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {}, i, r, a;
      const o = (l, f) => {
        const h = this.nestingOptionsSeparator;
        if (l.indexOf(h) < 0)
          return l;
        const g = l.split(new RegExp(`${h}[ ]*{`));
        let u = `{${g[1]}`;
        l = g[0], u = this.interpolate(u, a);
        const d = u.match(/'/g), p = u.match(/"/g);
        (d && d.length % 2 === 0 && !p || p.length % 2 !== 0) && (u = u.replace(/'/g, '"'));
        try {
          a = JSON.parse(u), f && (a = {
            ...f,
            ...a
          });
        } catch (x) {
          return this.logger.warn(`failed parsing options string in nesting for key ${l}`, x), `${l}${h}${u}`;
        }
        return a.defaultValue && a.defaultValue.indexOf(this.prefix) > -1 && delete a.defaultValue, l;
      };
      for (; i = this.nestingRegexp.exec(e); ) {
        let l = [];
        a = {
          ...s
        }, a = a.replace && !c(a.replace) ? a.replace : a, a.applyPostProcessor = false, delete a.defaultValue;
        let f = false;
        if (i[0].indexOf(this.formatSeparator) !== -1 && !/{.*}/.test(i[1])) {
          const h = i[1].split(this.formatSeparator).map((g) => g.trim());
          i[1] = h.shift(), l = h, f = true;
        }
        if (r = t(o.call(this, i[1].trim(), a), a), r && i[0] === e && !c(r))
          return r;
        c(r) || (r = ee(r)), r || (this.logger.warn(`missed to resolve ${i[1]} for nesting ${e}`), r = ""), f && (r = l.reduce((h, g) => this.format(h, g, s.lng, {
          ...s,
          interpolationkey: i[1].trim()
        }), r.trim())), e = e.replace(i[0], r), this.regexp.lastIndex = 0;
      }
      return e;
    }
  }
  const Ie = (n) => {
    let e = n.toLowerCase().trim();
    const t = {};
    if (n.indexOf("(") > -1) {
      const s = n.split("(");
      e = s[0].toLowerCase().trim();
      const i = s[1].substring(0, s[1].length - 1);
      e === "currency" && i.indexOf(":") < 0 ? t.currency || (t.currency = i.trim()) : e === "relativetime" && i.indexOf(":") < 0 ? t.range || (t.range = i.trim()) : i.split(";").forEach((a) => {
        if (a) {
          const [o, ...l] = a.split(":"), f = l.join(":").trim().replace(/^'+|'+$/g, ""), h = o.trim();
          t[h] || (t[h] = f), f === "false" && (t[h] = false), f === "true" && (t[h] = true), isNaN(f) || (t[h] = parseInt(f, 10));
        }
      });
    }
    return {
      formatName: e,
      formatOptions: t
    };
  }, $ = (n) => {
    const e = {};
    return (t, s, i) => {
      let r = i;
      i && i.interpolationkey && i.formatParams && i.formatParams[i.interpolationkey] && i[i.interpolationkey] && (r = {
        ...r,
        [i.interpolationkey]: void 0
      });
      const a = s + JSON.stringify(r);
      let o = e[a];
      return o || (o = n(z(s), i), e[a] = o), o(t);
    };
  };
  class Ae {
    constructor() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
      this.logger = N.create("formatter"), this.options = e, this.formats = {
        number: $((t, s) => {
          const i = new Intl.NumberFormat(t, {
            ...s
          });
          return (r) => i.format(r);
        }),
        currency: $((t, s) => {
          const i = new Intl.NumberFormat(t, {
            ...s,
            style: "currency"
          });
          return (r) => i.format(r);
        }),
        datetime: $((t, s) => {
          const i = new Intl.DateTimeFormat(t, {
            ...s
          });
          return (r) => i.format(r);
        }),
        relativetime: $((t, s) => {
          const i = new Intl.RelativeTimeFormat(t, {
            ...s
          });
          return (r) => i.format(r, s.range || "day");
        }),
        list: $((t, s) => {
          const i = new Intl.ListFormat(t, {
            ...s
          });
          return (r) => i.format(r);
        })
      }, this.init(e);
    }
    init(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {
        interpolation: {}
      };
      this.formatSeparator = t.interpolation.formatSeparator || ",";
    }
    add(e, t) {
      this.formats[e.toLowerCase().trim()] = t;
    }
    addCached(e, t) {
      this.formats[e.toLowerCase().trim()] = $(t);
    }
    format(e, t, s) {
      let i = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : {};
      const r = t.split(this.formatSeparator);
      if (r.length > 1 && r[0].indexOf("(") > 1 && r[0].indexOf(")") < 0 && r.find((o) => o.indexOf(")") > -1)) {
        const o = r.findIndex((l) => l.indexOf(")") > -1);
        r[0] = [
          r[0],
          ...r.splice(1, o)
        ].join(this.formatSeparator);
      }
      return r.reduce((o, l) => {
        const { formatName: f, formatOptions: h } = Ie(l);
        if (this.formats[f]) {
          let g = o;
          try {
            const u = i && i.formatParams && i.formatParams[i.interpolationkey] || {}, d = u.locale || u.lng || i.locale || i.lng || s;
            g = this.formats[f](o, d, {
              ...h,
              ...i,
              ...u
            });
          } catch (u) {
            this.logger.warn(u);
          }
          return g;
        } else
          this.logger.warn(`there was no format function for ${f}`);
        return o;
      }, e);
    }
  }
  const De = (n, e) => {
    n.pending[e] !== void 0 && (delete n.pending[e], n.pendingCount--);
  };
  class Ve extends W {
    constructor(e, t, s) {
      let i = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : {};
      super(), this.backend = e, this.store = t, this.services = s, this.languageUtils = s.languageUtils, this.options = i, this.logger = N.create("backendConnector"), this.waitingReads = [], this.maxParallelReads = i.maxParallelReads || 10, this.readingCalls = 0, this.maxRetries = i.maxRetries >= 0 ? i.maxRetries : 5, this.retryTimeout = i.retryTimeout >= 1 ? i.retryTimeout : 350, this.state = {}, this.queue = [], this.backend && this.backend.init && this.backend.init(s, i.backend, i);
    }
    queueLoad(e, t, s, i) {
      const r = {}, a = {}, o = {}, l = {};
      return e.forEach((f) => {
        let h = true;
        t.forEach((g) => {
          const u = `${f}|${g}`;
          !s.reload && this.store.hasResourceBundle(f, g) ? this.state[u] = 2 : this.state[u] < 0 || (this.state[u] === 1 ? a[u] === void 0 && (a[u] = true) : (this.state[u] = 1, h = false, a[u] === void 0 && (a[u] = true), r[u] === void 0 && (r[u] = true), l[g] === void 0 && (l[g] = true)));
        }), h || (o[f] = true);
      }), (Object.keys(r).length || Object.keys(a).length) && this.queue.push({
        pending: a,
        pendingCount: Object.keys(a).length,
        loaded: {},
        errors: [],
        callback: i
      }), {
        toLoad: Object.keys(r),
        pending: Object.keys(a),
        toLoadLanguages: Object.keys(o),
        toLoadNamespaces: Object.keys(l)
      };
    }
    loaded(e, t, s) {
      const i = e.split("|"), r = i[0], a = i[1];
      t && this.emit("failedLoading", r, a, t), !t && s && this.store.addResourceBundle(r, a, s, void 0, void 0, {
        skipCopy: true
      }), this.state[e] = t ? -1 : 2, t && s && (this.state[e] = 0);
      const o = {};
      this.queue.forEach((l) => {
        be(l.loaded, [
          r
        ], a), De(l, e), t && l.errors.push(t), l.pendingCount === 0 && !l.done && (Object.keys(l.loaded).forEach((f) => {
          o[f] || (o[f] = {});
          const h = l.loaded[f];
          h.length && h.forEach((g) => {
            o[f][g] === void 0 && (o[f][g] = true);
          });
        }), l.done = true, l.errors.length ? l.callback(l.errors) : l.callback());
      }), this.emit("loaded", o), this.queue = this.queue.filter((l) => !l.done);
    }
    read(e, t, s) {
      let i = arguments.length > 3 && arguments[3] !== void 0 ? arguments[3] : 0, r = arguments.length > 4 && arguments[4] !== void 0 ? arguments[4] : this.retryTimeout, a = arguments.length > 5 ? arguments[5] : void 0;
      if (!e.length)
        return a(null, {});
      if (this.readingCalls >= this.maxParallelReads) {
        this.waitingReads.push({
          lng: e,
          ns: t,
          fcName: s,
          tried: i,
          wait: r,
          callback: a
        });
        return;
      }
      this.readingCalls++;
      const o = (f, h) => {
        if (this.readingCalls--, this.waitingReads.length > 0) {
          const g = this.waitingReads.shift();
          this.read(g.lng, g.ns, g.fcName, g.tried, g.wait, g.callback);
        }
        if (f && h && i < this.maxRetries) {
          setTimeout(() => {
            this.read.call(this, e, t, s, i + 1, r * 2, a);
          }, r);
          return;
        }
        a(f, h);
      }, l = this.backend[s].bind(this.backend);
      if (l.length === 2) {
        try {
          const f = l(e, t);
          f && typeof f.then == "function" ? f.then((h) => o(null, h)).catch(o) : o(null, f);
        } catch (f) {
          o(f);
        }
        return;
      }
      return l(e, t, o);
    }
    prepareLoading(e, t) {
      let s = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {}, i = arguments.length > 3 ? arguments[3] : void 0;
      if (!this.backend)
        return this.logger.warn("No backend was added via i18next.use. Will not load resources."), i && i();
      c(e) && (e = this.languageUtils.toResolveHierarchy(e)), c(t) && (t = [
        t
      ]);
      const r = this.queueLoad(e, t, s, i);
      if (!r.toLoad.length)
        return r.pending.length || i(), null;
      r.toLoad.forEach((a) => {
        this.loadOne(a);
      });
    }
    load(e, t, s) {
      this.prepareLoading(e, t, {}, s);
    }
    reload(e, t, s) {
      this.prepareLoading(e, t, {
        reload: true
      }, s);
    }
    loadOne(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : "";
      const s = e.split("|"), i = s[0], r = s[1];
      this.read(i, r, "read", void 0, void 0, (a, o) => {
        a && this.logger.warn(`${t}loading namespace ${r} for language ${i} failed`, a), !a && o && this.logger.log(`${t}loaded namespace ${r} for language ${i}`, o), this.loaded(e, a, o);
      });
    }
    saveMissing(e, t, s, i, r) {
      let a = arguments.length > 5 && arguments[5] !== void 0 ? arguments[5] : {}, o = arguments.length > 6 && arguments[6] !== void 0 ? arguments[6] : () => {
      };
      if (this.services.utils && this.services.utils.hasLoadedNamespace && !this.services.utils.hasLoadedNamespace(t)) {
        this.logger.warn(`did not save key "${s}" as the namespace "${t}" was not yet loaded`, "This means something IS WRONG in your setup. You access the t function before i18next.init / i18next.loadNamespace / i18next.changeLanguage was done. Wait for the callback or Promise to resolve before accessing it!!!");
        return;
      }
      if (!(s == null || s === "")) {
        if (this.backend && this.backend.create) {
          const l = {
            ...a,
            isUpdate: r
          }, f = this.backend.create.bind(this.backend);
          if (f.length < 6)
            try {
              let h;
              f.length === 5 ? h = f(e, t, s, i, l) : h = f(e, t, s, i), h && typeof h.then == "function" ? h.then((g) => o(null, g)).catch(o) : o(null, h);
            } catch (h) {
              o(h);
            }
          else
            f(e, t, s, i, o, l);
        }
        !e || !e[0] || this.store.addResource(e[0], t, s, i);
      }
    }
  }
  const ue = () => ({
    debug: false,
    initImmediate: true,
    ns: [
      "translation"
    ],
    defaultNS: [
      "translation"
    ],
    fallbackLng: [
      "dev"
    ],
    fallbackNS: false,
    supportedLngs: false,
    nonExplicitSupportedLngs: false,
    load: "all",
    preload: false,
    simplifyPluralSuffix: true,
    keySeparator: ".",
    nsSeparator: ":",
    pluralSeparator: "_",
    contextSeparator: "_",
    partialBundledLanguages: false,
    saveMissing: false,
    updateMissing: false,
    saveMissingTo: "fallback",
    saveMissingPlurals: true,
    missingKeyHandler: false,
    missingInterpolationHandler: false,
    postProcess: false,
    postProcessPassResolved: false,
    returnNull: false,
    returnEmptyString: true,
    returnObjects: false,
    joinArrays: false,
    returnedObjectHandler: false,
    parseMissingKeyHandler: false,
    appendNamespaceToMissingKey: false,
    appendNamespaceToCIMode: false,
    overloadTranslationOptionHandler: (n) => {
      let e = {};
      if (typeof n[1] == "object" && (e = n[1]), c(n[1]) && (e.defaultValue = n[1]), c(n[2]) && (e.tDescription = n[2]), typeof n[2] == "object" || typeof n[3] == "object") {
        const t = n[3] || n[2];
        Object.keys(t).forEach((s) => {
          e[s] = t[s];
        });
      }
      return e;
    },
    interpolation: {
      escapeValue: true,
      format: (n) => n,
      prefix: "{{",
      suffix: "}}",
      formatSeparator: ",",
      unescapePrefix: "-",
      nestingPrefix: "$t(",
      nestingSuffix: ")",
      nestingOptionsSeparator: ",",
      maxReplaces: 1e3,
      skipOnVariables: true
    }
  }), fe = (n) => (c(n.ns) && (n.ns = [
    n.ns
  ]), c(n.fallbackLng) && (n.fallbackLng = [
    n.fallbackLng
  ]), c(n.fallbackNS) && (n.fallbackNS = [
    n.fallbackNS
  ]), n.supportedLngs && n.supportedLngs.indexOf("cimode") < 0 && (n.supportedLngs = n.supportedLngs.concat([
    "cimode"
  ])), n), U = () => {
  }, Te = (n) => {
    Object.getOwnPropertyNames(Object.getPrototypeOf(n)).forEach((t) => {
      typeof n[t] == "function" && (n[t] = n[t].bind(n));
    });
  };
  class V extends W {
    constructor() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {}, t = arguments.length > 1 ? arguments[1] : void 0;
      if (super(), this.options = fe(e), this.services = {}, this.logger = N, this.modules = {
        external: []
      }, Te(this), t && !this.isInitialized && !e.isClone) {
        if (!this.options.initImmediate)
          return this.init(e, t), this;
        setTimeout(() => {
          this.init(e, t);
        }, 0);
      }
    }
    init() {
      var e = this;
      let t = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {}, s = arguments.length > 1 ? arguments[1] : void 0;
      this.isInitializing = true, typeof t == "function" && (s = t, t = {}), !t.defaultNS && t.defaultNS !== false && t.ns && (c(t.ns) ? t.defaultNS = t.ns : t.ns.indexOf("translation") < 0 && (t.defaultNS = t.ns[0]));
      const i = ue();
      this.options = {
        ...i,
        ...this.options,
        ...fe(t)
      }, this.options.compatibilityAPI !== "v1" && (this.options.interpolation = {
        ...i.interpolation,
        ...this.options.interpolation
      }), t.keySeparator !== void 0 && (this.options.userDefinedKeySeparator = t.keySeparator), t.nsSeparator !== void 0 && (this.options.userDefinedNsSeparator = t.nsSeparator);
      const r = (h) => h ? typeof h == "function" ? new h() : h : null;
      if (!this.options.isClone) {
        this.modules.logger ? N.init(r(this.modules.logger), this.options) : N.init(null, this.options);
        let h;
        this.modules.formatter ? h = this.modules.formatter : typeof Intl < "u" && (h = Ae);
        const g = new ae(this.options);
        this.store = new ne(this.options.resources, this.options);
        const u = this.services;
        u.logger = N, u.resourceStore = this.store, u.languageUtils = g, u.pluralResolver = new Fe(g, {
          prepend: this.options.pluralSeparator,
          compatibilityJSON: this.options.compatibilityJSON,
          simplifyPluralSuffix: this.options.simplifyPluralSuffix
        }), h && (!this.options.interpolation.format || this.options.interpolation.format === i.interpolation.format) && (u.formatter = r(h), u.formatter.init(u, this.options), this.options.interpolation.format = u.formatter.format.bind(u.formatter)), u.interpolator = new je(this.options), u.utils = {
          hasLoadedNamespace: this.hasLoadedNamespace.bind(this)
        }, u.backendConnector = new Ve(r(this.modules.backend), u.resourceStore, u, this.options), u.backendConnector.on("*", function(d) {
          for (var p = arguments.length, x = new Array(p > 1 ? p - 1 : 0), m = 1; m < p; m++)
            x[m - 1] = arguments[m];
          e.emit(d, ...x);
        }), this.modules.languageDetector && (u.languageDetector = r(this.modules.languageDetector), u.languageDetector.init && u.languageDetector.init(u, this.options.detection, this.options)), this.modules.i18nFormat && (u.i18nFormat = r(this.modules.i18nFormat), u.i18nFormat.init && u.i18nFormat.init(this)), this.translator = new J(this.services, this.options), this.translator.on("*", function(d) {
          for (var p = arguments.length, x = new Array(p > 1 ? p - 1 : 0), m = 1; m < p; m++)
            x[m - 1] = arguments[m];
          e.emit(d, ...x);
        }), this.modules.external.forEach((d) => {
          d.init && d.init(this);
        });
      }
      if (this.format = this.options.interpolation.format, s || (s = U), this.options.fallbackLng && !this.services.languageDetector && !this.options.lng) {
        const h = this.services.languageUtils.getFallbackCodes(this.options.fallbackLng);
        h.length > 0 && h[0] !== "dev" && (this.options.lng = h[0]);
      }
      !this.services.languageDetector && !this.options.lng && this.logger.warn("init: no languageDetector is used and no lng is defined"), [
        "getResource",
        "hasResourceBundle",
        "getResourceBundle",
        "getDataByLanguage"
      ].forEach((h) => {
        this[h] = function() {
          return e.store[h](...arguments);
        };
      }), [
        "addResource",
        "addResources",
        "addResourceBundle",
        "removeResourceBundle"
      ].forEach((h) => {
        this[h] = function() {
          return e.store[h](...arguments), e;
        };
      });
      const l = A(), f = () => {
        const h = (g, u) => {
          this.isInitializing = false, this.isInitialized && !this.initializedStoreOnce && this.logger.warn("init: i18next is already initialized. You should call init just once!"), this.isInitialized = true, this.options.isClone || this.logger.log("initialized", this.options), this.emit("initialized", this.options), l.resolve(u), s(g, u);
        };
        if (this.languages && this.options.compatibilityAPI !== "v1" && !this.isInitialized)
          return h(null, this.t.bind(this));
        this.changeLanguage(this.options.lng, h);
      };
      return this.options.resources || !this.options.initImmediate ? f() : setTimeout(f, 0), l;
    }
    loadResources(e) {
      let s = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : U;
      const i = c(e) ? e : this.language;
      if (typeof e == "function" && (s = e), !this.options.resources || this.options.partialBundledLanguages) {
        if (i && i.toLowerCase() === "cimode" && (!this.options.preload || this.options.preload.length === 0))
          return s();
        const r = [], a = (o) => {
          if (!o || o === "cimode")
            return;
          this.services.languageUtils.toResolveHierarchy(o).forEach((f) => {
            f !== "cimode" && r.indexOf(f) < 0 && r.push(f);
          });
        };
        i ? a(i) : this.services.languageUtils.getFallbackCodes(this.options.fallbackLng).forEach((l) => a(l)), this.options.preload && this.options.preload.forEach((o) => a(o)), this.services.backendConnector.load(r, this.options.ns, (o) => {
          !o && !this.resolvedLanguage && this.language && this.setResolvedLanguage(this.language), s(o);
        });
      } else
        s(null);
    }
    reloadResources(e, t, s) {
      const i = A();
      return typeof e == "function" && (s = e, e = void 0), typeof t == "function" && (s = t, t = void 0), e || (e = this.languages), t || (t = this.options.ns), s || (s = U), this.services.backendConnector.reload(e, t, (r) => {
        i.resolve(), s(r);
      }), i;
    }
    use(e) {
      if (!e)
        throw new Error("You are passing an undefined module! Please check the object you are passing to i18next.use()");
      if (!e.type)
        throw new Error("You are passing a wrong module! Please check the object you are passing to i18next.use()");
      return e.type === "backend" && (this.modules.backend = e), (e.type === "logger" || e.log && e.warn && e.error) && (this.modules.logger = e), e.type === "languageDetector" && (this.modules.languageDetector = e), e.type === "i18nFormat" && (this.modules.i18nFormat = e), e.type === "postProcessor" && ge.addPostProcessor(e), e.type === "formatter" && (this.modules.formatter = e), e.type === "3rdParty" && this.modules.external.push(e), this;
    }
    setResolvedLanguage(e) {
      if (!(!e || !this.languages) && !([
        "cimode",
        "dev"
      ].indexOf(e) > -1))
        for (let t = 0; t < this.languages.length; t++) {
          const s = this.languages[t];
          if (!([
            "cimode",
            "dev"
          ].indexOf(s) > -1) && this.store.hasLanguageSomeTranslations(s)) {
            this.resolvedLanguage = s;
            break;
          }
        }
    }
    changeLanguage(e, t) {
      var s = this;
      this.isLanguageChangingTo = e;
      const i = A();
      this.emit("languageChanging", e);
      const r = (l) => {
        this.language = l, this.languages = this.services.languageUtils.toResolveHierarchy(l), this.resolvedLanguage = void 0, this.setResolvedLanguage(l);
      }, a = (l, f) => {
        f ? (r(f), this.translator.changeLanguage(f), this.isLanguageChangingTo = void 0, this.emit("languageChanged", f), this.logger.log("languageChanged", f)) : this.isLanguageChangingTo = void 0, i.resolve(function() {
          return s.t(...arguments);
        }), t && t(l, function() {
          return s.t(...arguments);
        });
      }, o = (l) => {
        !e && !l && this.services.languageDetector && (l = []);
        const f = c(l) ? l : this.services.languageUtils.getBestMatchFromCodes(l);
        f && (this.language || r(f), this.translator.language || this.translator.changeLanguage(f), this.services.languageDetector && this.services.languageDetector.cacheUserLanguage && this.services.languageDetector.cacheUserLanguage(f)), this.loadResources(f, (h) => {
          a(h, f);
        });
      };
      return !e && this.services.languageDetector && !this.services.languageDetector.async ? o(this.services.languageDetector.detect()) : !e && this.services.languageDetector && this.services.languageDetector.async ? this.services.languageDetector.detect.length === 0 ? this.services.languageDetector.detect().then(o) : this.services.languageDetector.detect(o) : o(e), i;
    }
    getFixedT(e, t, s) {
      var i = this;
      const r = function(a, o) {
        let l;
        if (typeof o != "object") {
          for (var f = arguments.length, h = new Array(f > 2 ? f - 2 : 0), g = 2; g < f; g++)
            h[g - 2] = arguments[g];
          l = i.options.overloadTranslationOptionHandler([
            a,
            o
          ].concat(h));
        } else
          l = {
            ...o
          };
        l.lng = l.lng || r.lng, l.lngs = l.lngs || r.lngs, l.ns = l.ns || r.ns, l.keyPrefix !== "" && (l.keyPrefix = l.keyPrefix || s || r.keyPrefix);
        const u = i.options.keySeparator || ".";
        let d;
        return l.keyPrefix && Array.isArray(a) ? d = a.map((p) => `${l.keyPrefix}${u}${p}`) : d = l.keyPrefix ? `${l.keyPrefix}${u}${a}` : a, i.t(d, l);
      };
      return c(e) ? r.lng = e : r.lngs = e, r.ns = t, r.keyPrefix = s, r;
    }
    t() {
      return this.translator && this.translator.translate(...arguments);
    }
    exists() {
      return this.translator && this.translator.exists(...arguments);
    }
    setDefaultNamespace(e) {
      this.options.defaultNS = e;
    }
    hasLoadedNamespace(e) {
      let t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {};
      if (!this.isInitialized)
        return this.logger.warn("hasLoadedNamespace: i18next was not initialized", this.languages), false;
      if (!this.languages || !this.languages.length)
        return this.logger.warn("hasLoadedNamespace: i18n.languages were undefined or empty", this.languages), false;
      const s = t.lng || this.resolvedLanguage || this.languages[0], i = this.options ? this.options.fallbackLng : false, r = this.languages[this.languages.length - 1];
      if (s.toLowerCase() === "cimode")
        return true;
      const a = (o, l) => {
        const f = this.services.backendConnector.state[`${o}|${l}`];
        return f === -1 || f === 0 || f === 2;
      };
      if (t.precheck) {
        const o = t.precheck(this, a);
        if (o !== void 0)
          return o;
      }
      return !!(this.hasResourceBundle(s, e) || !this.services.backendConnector.backend || this.options.resources && !this.options.partialBundledLanguages || a(s, e) && (!i || a(r, e)));
    }
    loadNamespaces(e, t) {
      const s = A();
      return this.options.ns ? (c(e) && (e = [
        e
      ]), e.forEach((i) => {
        this.options.ns.indexOf(i) < 0 && this.options.ns.push(i);
      }), this.loadResources((i) => {
        s.resolve(), t && t(i);
      }), s) : (t && t(), Promise.resolve());
    }
    loadLanguages(e, t) {
      const s = A();
      c(e) && (e = [
        e
      ]);
      const i = this.options.preload || [], r = e.filter((a) => i.indexOf(a) < 0 && this.services.languageUtils.isSupportedCode(a));
      return r.length ? (this.options.preload = i.concat(r), this.loadResources((a) => {
        s.resolve(), t && t(a);
      }), s) : (t && t(), Promise.resolve());
    }
    dir(e) {
      if (e || (e = this.resolvedLanguage || (this.languages && this.languages.length > 0 ? this.languages[0] : this.language)), !e)
        return "rtl";
      const t = [
        "ar",
        "shu",
        "sqr",
        "ssh",
        "xaa",
        "yhd",
        "yud",
        "aao",
        "abh",
        "abv",
        "acm",
        "acq",
        "acw",
        "acx",
        "acy",
        "adf",
        "ads",
        "aeb",
        "aec",
        "afb",
        "ajp",
        "apc",
        "apd",
        "arb",
        "arq",
        "ars",
        "ary",
        "arz",
        "auz",
        "avl",
        "ayh",
        "ayl",
        "ayn",
        "ayp",
        "bbz",
        "pga",
        "he",
        "iw",
        "ps",
        "pbt",
        "pbu",
        "pst",
        "prp",
        "prd",
        "ug",
        "ur",
        "ydd",
        "yds",
        "yih",
        "ji",
        "yi",
        "hbo",
        "men",
        "xmn",
        "fa",
        "jpr",
        "peo",
        "pes",
        "prs",
        "dv",
        "sam",
        "ckb"
      ], s = this.services && this.services.languageUtils || new ae(ue());
      return t.indexOf(s.getLanguagePartFromCode(e)) > -1 || e.toLowerCase().indexOf("-arab") > 1 ? "rtl" : "ltr";
    }
    static createInstance() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {}, t = arguments.length > 1 ? arguments[1] : void 0;
      return new V(e, t);
    }
    cloneInstance() {
      let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {}, t = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : U;
      const s = e.forkResourceStore;
      s && delete e.forkResourceStore;
      const i = {
        ...this.options,
        ...e,
        isClone: true
      }, r = new V(i);
      return (e.debug !== void 0 || e.prefix !== void 0) && (r.logger = r.logger.clone(e)), [
        "store",
        "services",
        "language"
      ].forEach((o) => {
        r[o] = this[o];
      }), r.services = {
        ...this.services
      }, r.services.utils = {
        hasLoadedNamespace: r.hasLoadedNamespace.bind(r)
      }, s && (r.store = new ne(this.store.data, i), r.services.resourceStore = r.store), r.translator = new J(r.services, i), r.translator.on("*", function(o) {
        for (var l = arguments.length, f = new Array(l > 1 ? l - 1 : 0), h = 1; h < l; h++)
          f[h - 1] = arguments[h];
        r.emit(o, ...f);
      }), r.init(i, t), r.translator.options = i, r.translator.backendConnector.services.utils = {
        hasLoadedNamespace: r.hasLoadedNamespace.bind(r)
      }, r;
    }
    toJSON() {
      return {
        options: this.options,
        store: this.store,
        language: this.language,
        languages: this.languages,
        resolvedLanguage: this.resolvedLanguage
      };
    }
  }
  const v = V.createInstance();
  v.createInstance = V.createInstance;
  v.createInstance;
  v.dir;
  v.init;
  v.loadResources;
  v.reloadResources;
  v.use;
  v.changeLanguage;
  v.getFixedT;
  v.t;
  v.exists;
  v.setDefaultNamespace;
  v.hasLoadedNamespace;
  v.loadNamespaces;
  v.loadLanguages;
  await B("react");
  const Ke = await B("react-dom");
  await B("react-router-dom");
  await B("fivem-nui-react-lib");
  Z.div`
  position: relative;
  width: 500px;
  height: 1000px;
`;
  Z.div`
  background: url(${({ src: n }) => n});
  position: absolute;
  z-index: 100;
  width: 500px;
  height: 1000px;
  pointer-events: none;
`;
  Z.div`
  z-index: 2;
  position: absolute;
  bottom: 100px;
  left: 50px;
  right: 50px;
  top: 100px;
  display: flex;
  flex-direction: column;
  background-position: center;
  background-size: cover;
  background-repeat: no-repeat;
  border-radius: 20px;
  overflow: hidden;
`;
  const Ue = () => null;
  Ke.render(pe.jsx(Ue, {}), document.getElementById("root"));
});
