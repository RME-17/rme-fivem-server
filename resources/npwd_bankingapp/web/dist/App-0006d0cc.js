import { importShared as M, __tla as __tla_0 } from "./__federation_fn_import-39357cc7.js";
import { j as u } from "./jsx-runtime-dc228b70.js";
import { _ as f, a as lp } from "./hoist-non-react-statics.cjs-5200d79e.js";
import { m as cp, g as up, s as fc, r as dp, u as pp, i as fp, c as hp, T as ti, a as ao, k as Gt, __tla as __tla_1 } from "./emotion-react.browser.esm-d3b5fcea.js";
import { a as ee, _ as hc } from "./inheritsLoose-cd9c12f4.js";
import { a as Ct } from "./_commonjsHelpers-de833af9.js";
let gk, X;
let __tla = Promise.all([
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
  const mp = {
    black: "#000",
    white: "#fff"
  }, io = mp, gp = {
    50: "#ffebee",
    100: "#ffcdd2",
    200: "#ef9a9a",
    300: "#e57373",
    400: "#ef5350",
    500: "#f44336",
    600: "#e53935",
    700: "#d32f2f",
    800: "#c62828",
    900: "#b71c1c",
    A100: "#ff8a80",
    A200: "#ff5252",
    A400: "#ff1744",
    A700: "#d50000"
  }, fn = gp, vp = {
    50: "#f3e5f5",
    100: "#e1bee7",
    200: "#ce93d8",
    300: "#ba68c8",
    400: "#ab47bc",
    500: "#9c27b0",
    600: "#8e24aa",
    700: "#7b1fa2",
    800: "#6a1b9a",
    900: "#4a148c",
    A100: "#ea80fc",
    A200: "#e040fb",
    A400: "#d500f9",
    A700: "#aa00ff"
  }, hn = vp, bp = {
    50: "#e3f2fd",
    100: "#bbdefb",
    200: "#90caf9",
    300: "#64b5f6",
    400: "#42a5f5",
    500: "#2196f3",
    600: "#1e88e5",
    700: "#1976d2",
    800: "#1565c0",
    900: "#0d47a1",
    A100: "#82b1ff",
    A200: "#448aff",
    A400: "#2979ff",
    A700: "#2962ff"
  }, mn = bp, yp = {
    50: "#e1f5fe",
    100: "#b3e5fc",
    200: "#81d4fa",
    300: "#4fc3f7",
    400: "#29b6f6",
    500: "#03a9f4",
    600: "#039be5",
    700: "#0288d1",
    800: "#0277bd",
    900: "#01579b",
    A100: "#80d8ff",
    A200: "#40c4ff",
    A400: "#00b0ff",
    A700: "#0091ea"
  }, gn = yp, xp = {
    50: "#e8f5e9",
    100: "#c8e6c9",
    200: "#a5d6a7",
    300: "#81c784",
    400: "#66bb6a",
    500: "#4caf50",
    600: "#43a047",
    700: "#388e3c",
    800: "#2e7d32",
    900: "#1b5e20",
    A100: "#b9f6ca",
    A200: "#69f0ae",
    A400: "#00e676",
    A700: "#00c853"
  }, vn = xp, Sp = {
    50: "#fff3e0",
    100: "#ffe0b2",
    200: "#ffcc80",
    300: "#ffb74d",
    400: "#ffa726",
    500: "#ff9800",
    600: "#fb8c00",
    700: "#f57c00",
    800: "#ef6c00",
    900: "#e65100",
    A100: "#ffd180",
    A200: "#ffab40",
    A400: "#ff9100",
    A700: "#ff6d00"
  }, jn = Sp, Rp = {
    50: "#fafafa",
    100: "#f5f5f5",
    200: "#eeeeee",
    300: "#e0e0e0",
    400: "#bdbdbd",
    500: "#9e9e9e",
    600: "#757575",
    700: "#616161",
    800: "#424242",
    900: "#212121",
    A100: "#f5f5f5",
    A200: "#eeeeee",
    A400: "#bdbdbd",
    A700: "#616161"
  }, _p = Rp;
  function Mt(e) {
    let t = "https://mui.com/production-error/?code=" + e;
    for (let n = 1; n < arguments.length; n += 1)
      t += "&args[]=" + encodeURIComponent(arguments[n]);
    return "Minified MUI error #" + e + "; visit " + t + " for the full message.";
  }
  const Cp = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: Mt
  }, Symbol.toStringTag, {
    value: "Module"
  })), Cn = "$$material";
  var wp = /^((children|dangerouslySetInnerHTML|key|ref|autoFocus|defaultValue|defaultChecked|innerHTML|suppressContentEditableWarning|suppressHydrationWarning|valueLink|abbr|accept|acceptCharset|accessKey|action|allow|allowUserMedia|allowPaymentRequest|allowFullScreen|allowTransparency|alt|async|autoComplete|autoPlay|capture|cellPadding|cellSpacing|challenge|charSet|checked|cite|classID|className|cols|colSpan|content|contentEditable|contextMenu|controls|controlsList|coords|crossOrigin|data|dateTime|decoding|default|defer|dir|disabled|disablePictureInPicture|disableRemotePlayback|download|draggable|encType|enterKeyHint|fetchpriority|fetchPriority|form|formAction|formEncType|formMethod|formNoValidate|formTarget|frameBorder|headers|height|hidden|high|href|hrefLang|htmlFor|httpEquiv|id|inputMode|integrity|is|keyParams|keyType|kind|label|lang|list|loading|loop|low|marginHeight|marginWidth|max|maxLength|media|mediaGroup|method|min|minLength|multiple|muted|name|nonce|noValidate|open|optimum|pattern|placeholder|playsInline|popover|popoverTarget|popoverTargetAction|poster|preload|profile|radioGroup|readOnly|referrerPolicy|rel|required|reversed|role|rows|rowSpan|sandbox|scope|scoped|scrolling|seamless|selected|shape|size|sizes|slot|span|spellCheck|src|srcDoc|srcLang|srcSet|start|step|style|summary|tabIndex|target|title|translate|type|useMap|value|width|wmode|wrap|about|datatype|inlist|prefix|property|resource|typeof|vocab|autoCapitalize|autoCorrect|autoSave|color|incremental|fallback|inert|itemProp|itemScope|itemType|itemID|itemRef|on|option|results|security|unselectable|accentHeight|accumulate|additive|alignmentBaseline|allowReorder|alphabetic|amplitude|arabicForm|ascent|attributeName|attributeType|autoReverse|azimuth|baseFrequency|baselineShift|baseProfile|bbox|begin|bias|by|calcMode|capHeight|clip|clipPathUnits|clipPath|clipRule|colorInterpolation|colorInterpolationFilters|colorProfile|colorRendering|contentScriptType|contentStyleType|cursor|cx|cy|d|decelerate|descent|diffuseConstant|direction|display|divisor|dominantBaseline|dur|dx|dy|edgeMode|elevation|enableBackground|end|exponent|externalResourcesRequired|fill|fillOpacity|fillRule|filter|filterRes|filterUnits|floodColor|floodOpacity|focusable|fontFamily|fontSize|fontSizeAdjust|fontStretch|fontStyle|fontVariant|fontWeight|format|from|fr|fx|fy|g1|g2|glyphName|glyphOrientationHorizontal|glyphOrientationVertical|glyphRef|gradientTransform|gradientUnits|hanging|horizAdvX|horizOriginX|ideographic|imageRendering|in|in2|intercept|k|k1|k2|k3|k4|kernelMatrix|kernelUnitLength|kerning|keyPoints|keySplines|keyTimes|lengthAdjust|letterSpacing|lightingColor|limitingConeAngle|local|markerEnd|markerMid|markerStart|markerHeight|markerUnits|markerWidth|mask|maskContentUnits|maskUnits|mathematical|mode|numOctaves|offset|opacity|operator|order|orient|orientation|origin|overflow|overlinePosition|overlineThickness|panose1|paintOrder|pathLength|patternContentUnits|patternTransform|patternUnits|pointerEvents|points|pointsAtX|pointsAtY|pointsAtZ|preserveAlpha|preserveAspectRatio|primitiveUnits|r|radius|refX|refY|renderingIntent|repeatCount|repeatDur|requiredExtensions|requiredFeatures|restart|result|rotate|rx|ry|scale|seed|shapeRendering|slope|spacing|specularConstant|specularExponent|speed|spreadMethod|startOffset|stdDeviation|stemh|stemv|stitchTiles|stopColor|stopOpacity|strikethroughPosition|strikethroughThickness|string|stroke|strokeDasharray|strokeDashoffset|strokeLinecap|strokeLinejoin|strokeMiterlimit|strokeOpacity|strokeWidth|surfaceScale|systemLanguage|tableValues|targetX|targetY|textAnchor|textDecoration|textRendering|textLength|to|transform|u1|u2|underlinePosition|underlineThickness|unicode|unicodeBidi|unicodeRange|unitsPerEm|vAlphabetic|vHanging|vIdeographic|vMathematical|values|vectorEffect|version|vertAdvY|vertOriginX|vertOriginY|viewBox|viewTarget|visibility|widths|wordSpacing|writingMode|x|xHeight|x1|x2|xChannelSelector|xlinkActuate|xlinkArcrole|xlinkHref|xlinkRole|xlinkShow|xlinkTitle|xlinkType|xmlBase|xmlns|xmlnsXlink|xmlLang|xmlSpace|y|y1|y2|yChannelSelector|z|zoomAndPan|for|class|autofocus)|(([Dd][Aa][Tt][Aa]|[Aa][Rr][Ii][Aa]|x)-.*))$/, $p = cp(function(e) {
    return wp.test(e) || e.charCodeAt(0) === 111 && e.charCodeAt(1) === 110 && e.charCodeAt(2) < 91;
  });
  const { withEmotionCache: Ep, ThemeContext: Tp } = await M("@emotion/react"), zn = await M("react");
  let kp, Ap, Mp, ss, ls, Pp, Lp, Ip;
  kp = false;
  Ap = $p;
  Mp = function(t) {
    return t !== "theme";
  };
  ss = function(t) {
    return typeof t == "string" && t.charCodeAt(0) > 96 ? Ap : Mp;
  };
  ls = function(t, n, o) {
    var r;
    if (n) {
      var a = n.shouldForwardProp;
      r = t.__emotion_forwardProp && a ? function(i) {
        return t.__emotion_forwardProp(i) && a(i);
      } : a;
    }
    return typeof r != "function" && o && (r = t.__emotion_forwardProp), r;
  };
  Pp = function(t) {
    var n = t.cache, o = t.serialized, r = t.isStringTag;
    return dp(n, o, r), pp(function() {
      return fp(n, o, r);
    }), null;
  };
  Lp = function e(t, n) {
    var o = t.__emotion_real === t, r = o && t.__emotion_base || t, a, i;
    n !== void 0 && (a = n.label, i = n.target);
    var s = ls(t, n, o), l = s || ss(r), c = !l("as");
    return function() {
      var d = arguments, p = o && t.__emotion_styles !== void 0 ? t.__emotion_styles.slice(0) : [];
      if (a !== void 0 && p.push("label:" + a + ";"), d[0] == null || d[0].raw === void 0)
        p.push.apply(p, d);
      else {
        var m = d[0];
        p.push(m[0]);
        for (var v = d.length, g = 1; g < v; g++)
          p.push(d[g], m[g]);
      }
      var h = Ep(function(C, $, R) {
        var b = c && C.as || r, y = "", E = [], w = C;
        if (C.theme == null) {
          w = {};
          for (var T in C)
            w[T] = C[T];
          w.theme = zn.useContext(Tp);
        }
        typeof C.className == "string" ? y = up($.registered, E, C.className) : C.className != null && (y = C.className + " ");
        var I = fc(p.concat(E), $.registered, w);
        y += $.key + "-" + I.name, i !== void 0 && (y += " " + i);
        var V = c && s === void 0 ? ss(b) : l, P = {};
        for (var U in C)
          c && U === "as" || V(U) && (P[U] = C[U]);
        return P.className = y, R && (P.ref = R), zn.createElement(zn.Fragment, null, zn.createElement(Pp, {
          cache: $,
          serialized: I,
          isStringTag: typeof b == "string"
        }), zn.createElement(b, P));
      });
      return h.displayName = a !== void 0 ? a : "Styled(" + (typeof r == "string" ? r : r.displayName || r.name || "Component") + ")", h.defaultProps = t.defaultProps, h.__emotion_real = h, h.__emotion_base = r, h.__emotion_styles = p, h.__emotion_forwardProp = s, Object.defineProperty(h, "toString", {
        value: function() {
          return i === void 0 && kp ? "NO_COMPONENT_SELECTOR" : "." + i;
        }
      }), h.withComponent = function(C, $) {
        var R = e(C, f({}, n, $, {
          shouldForwardProp: ls(h, $, true)
        }));
        return R.apply(void 0, p);
      }, h;
    };
  };
  Ip = [
    "a",
    "abbr",
    "address",
    "area",
    "article",
    "aside",
    "audio",
    "b",
    "base",
    "bdi",
    "bdo",
    "big",
    "blockquote",
    "body",
    "br",
    "button",
    "canvas",
    "caption",
    "cite",
    "code",
    "col",
    "colgroup",
    "data",
    "datalist",
    "dd",
    "del",
    "details",
    "dfn",
    "dialog",
    "div",
    "dl",
    "dt",
    "em",
    "embed",
    "fieldset",
    "figcaption",
    "figure",
    "footer",
    "form",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "head",
    "header",
    "hgroup",
    "hr",
    "html",
    "i",
    "iframe",
    "img",
    "input",
    "ins",
    "kbd",
    "keygen",
    "label",
    "legend",
    "li",
    "link",
    "main",
    "map",
    "mark",
    "marquee",
    "menu",
    "menuitem",
    "meta",
    "meter",
    "nav",
    "noscript",
    "object",
    "ol",
    "optgroup",
    "option",
    "output",
    "p",
    "param",
    "picture",
    "pre",
    "progress",
    "q",
    "rp",
    "rt",
    "ruby",
    "s",
    "samp",
    "script",
    "section",
    "select",
    "small",
    "source",
    "span",
    "strong",
    "style",
    "sub",
    "summary",
    "sup",
    "table",
    "tbody",
    "td",
    "textarea",
    "tfoot",
    "th",
    "thead",
    "time",
    "title",
    "tr",
    "track",
    "u",
    "ul",
    "var",
    "video",
    "wbr",
    "circle",
    "clipPath",
    "defs",
    "ellipse",
    "foreignObject",
    "g",
    "image",
    "line",
    "linearGradient",
    "mask",
    "path",
    "pattern",
    "polygon",
    "polyline",
    "radialGradient",
    "rect",
    "stop",
    "svg",
    "text",
    "tspan"
  ];
  X = Lp.bind(null);
  Ip.forEach(function(e) {
    X[e] = X(e);
  });
  const Np = await M("react"), { CacheProvider: Fp } = await M("@emotion/react");
  function Op(e, t) {
    const n = hp({
      key: "css",
      prepend: e
    });
    if (t) {
      const o = n.insert;
      n.insert = (...r) => (r[1].styles.match(/^@layer\s+[^{]*$/) || (r[1].styles = `@layer mui {${r[1].styles}}`), o(...r));
    }
    return n;
  }
  const oa = /* @__PURE__ */ new Map();
  function mc(e) {
    const { injectFirst: t, enableCssLayer: n, children: o } = e, r = Np.useMemo(() => {
      const a = `${t}-${n}`;
      if (typeof document == "object" && oa.has(a))
        return oa.get(a);
      const i = Op(t, n);
      return oa.set(a, i), i;
    }, [
      t,
      n
    ]);
    return t || n ? u.jsx(Fp, {
      value: r,
      children: o
    }) : o;
  }
  await M("react");
  const { Global: Bp } = await M("@emotion/react");
  function Dp(e) {
    return e == null || Object.keys(e).length === 0;
  }
  function gc(e) {
    const { styles: t, defaultTheme: n = {} } = e, o = typeof t == "function" ? (r) => t(Dp(r) ? n : r) : t;
    return u.jsx(Bp, {
      styles: o
    });
  }
  function vc(e, t) {
    return X(e, t);
  }
  const jp = (e, t) => {
    Array.isArray(e.__emotion_styles) && (e.__emotion_styles = t(e.__emotion_styles));
  }, cs = [];
  function bc(e) {
    return cs[0] = e, fc(cs);
  }
  const zp = Object.freeze(Object.defineProperty({
    __proto__: null,
    GlobalStyles: gc,
    StyledEngineProvider: mc,
    ThemeContext: ti,
    css: ao,
    default: vc,
    internal_processStyles: jp,
    internal_serializeStyles: bc,
    keyframes: Gt
  }, Symbol.toStringTag, {
    value: "Module"
  })), yc = await M("react");
  function Ut(e) {
    if (typeof e != "object" || e === null)
      return false;
    const t = Object.getPrototypeOf(e);
    return (t === null || t === Object.prototype || Object.getPrototypeOf(t) === null) && !(Symbol.toStringTag in e) && !(Symbol.iterator in e);
  }
  function xc(e) {
    if (yc.isValidElement(e) || !Ut(e))
      return e;
    const t = {};
    return Object.keys(e).forEach((n) => {
      t[n] = xc(e[n]);
    }), t;
  }
  function at(e, t, n = {
    clone: true
  }) {
    const o = n.clone ? f({}, e) : e;
    return Ut(e) && Ut(t) && Object.keys(t).forEach((r) => {
      yc.isValidElement(t[r]) ? o[r] = t[r] : Ut(t[r]) && Object.prototype.hasOwnProperty.call(e, r) && Ut(e[r]) ? o[r] = at(e[r], t[r], n) : n.clone ? o[r] = Ut(t[r]) ? xc(t[r]) : t[r] : o[r] = t[r];
    }), o;
  }
  const Vp = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: at,
    isPlainObject: Ut
  }, Symbol.toStringTag, {
    value: "Module"
  })), Up = [
    "values",
    "unit",
    "step"
  ], Wp = (e) => {
    const t = Object.keys(e).map((n) => ({
      key: n,
      val: e[n]
    })) || [];
    return t.sort((n, o) => n.val - o.val), t.reduce((n, o) => f({}, n, {
      [o.key]: o.val
    }), {});
  };
  function Sc(e) {
    const { values: t = {
      xs: 0,
      sm: 600,
      md: 900,
      lg: 1200,
      xl: 1536
    }, unit: n = "px", step: o = 5 } = e, r = ee(e, Up), a = Wp(t), i = Object.keys(a);
    function s(m) {
      return `@media (min-width:${typeof t[m] == "number" ? t[m] : m}${n})`;
    }
    function l(m) {
      return `@media (max-width:${(typeof t[m] == "number" ? t[m] : m) - o / 100}${n})`;
    }
    function c(m, v) {
      const g = i.indexOf(v);
      return `@media (min-width:${typeof t[m] == "number" ? t[m] : m}${n}) and (max-width:${(g !== -1 && typeof t[i[g]] == "number" ? t[i[g]] : v) - o / 100}${n})`;
    }
    function d(m) {
      return i.indexOf(m) + 1 < i.length ? c(m, i[i.indexOf(m) + 1]) : s(m);
    }
    function p(m) {
      const v = i.indexOf(m);
      return v === 0 ? s(i[1]) : v === i.length - 1 ? l(i[v]) : c(m, i[i.indexOf(m) + 1]).replace("@media", "@media not all and");
    }
    return f({
      keys: i,
      values: a,
      up: s,
      down: l,
      between: c,
      only: d,
      not: p,
      unit: n
    }, r);
  }
  const Hp = {
    borderRadius: 4
  }, Kp = Hp;
  function Qn(e, t) {
    return t ? at(e, t, {
      clone: false
    }) : e;
  }
  const ni = {
    xs: 0,
    sm: 600,
    md: 900,
    lg: 1200,
    xl: 1536
  }, us = {
    keys: [
      "xs",
      "sm",
      "md",
      "lg",
      "xl"
    ],
    up: (e) => `@media (min-width:${ni[e]}px)`
  };
  function Pt(e, t, n) {
    const o = e.theme || {};
    if (Array.isArray(t)) {
      const a = o.breakpoints || us;
      return t.reduce((i, s, l) => (i[a.up(a.keys[l])] = n(t[l]), i), {});
    }
    if (typeof t == "object") {
      const a = o.breakpoints || us;
      return Object.keys(t).reduce((i, s) => {
        if (Object.keys(a.values || ni).indexOf(s) !== -1) {
          const l = a.up(s);
          i[l] = n(t[s], s);
        } else {
          const l = s;
          i[l] = t[l];
        }
        return i;
      }, {});
    }
    return n(t);
  }
  function qp(e = {}) {
    var t;
    return ((t = e.keys) == null ? void 0 : t.reduce((o, r) => {
      const a = e.up(r);
      return o[a] = {}, o;
    }, {})) || {};
  }
  function ds(e, t) {
    return e.reduce((n, o) => {
      const r = n[o];
      return (!r || Object.keys(r).length === 0) && delete n[o], n;
    }, t);
  }
  function oe(e) {
    if (typeof e != "string")
      throw new Error(Mt(7));
    return e.charAt(0).toUpperCase() + e.slice(1);
  }
  const Gp = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: oe
  }, Symbol.toStringTag, {
    value: "Module"
  }));
  function sr(e, t, n = true) {
    if (!t || typeof t != "string")
      return null;
    if (e && e.vars && n) {
      const o = `vars.${t}`.split(".").reduce((r, a) => r && r[a] ? r[a] : null, e);
      if (o != null)
        return o;
    }
    return t.split(".").reduce((o, r) => o && o[r] != null ? o[r] : null, e);
  }
  function qo(e, t, n, o = n) {
    let r;
    return typeof e == "function" ? r = e(n) : Array.isArray(e) ? r = e[n] || o : r = sr(e, n) || o, t && (r = t(r, o, e)), r;
  }
  function De(e) {
    const { prop: t, cssProperty: n = e.prop, themeKey: o, transform: r } = e, a = (i) => {
      if (i[t] == null)
        return null;
      const s = i[t], l = i.theme, c = sr(l, o) || {};
      return Pt(i, s, (p) => {
        let m = qo(c, r, p);
        return p === m && typeof p == "string" && (m = qo(c, r, `${t}${p === "default" ? "" : oe(p)}`, p)), n === false ? m : {
          [n]: m
        };
      });
    };
    return a.propTypes = {}, a.filterProps = [
      t
    ], a;
  }
  function Yp(e) {
    const t = {};
    return (n) => (t[n] === void 0 && (t[n] = e(n)), t[n]);
  }
  const Xp = {
    m: "margin",
    p: "padding"
  }, Zp = {
    t: "Top",
    r: "Right",
    b: "Bottom",
    l: "Left",
    x: [
      "Left",
      "Right"
    ],
    y: [
      "Top",
      "Bottom"
    ]
  }, ps = {
    marginX: "mx",
    marginY: "my",
    paddingX: "px",
    paddingY: "py"
  }, Jp = Yp((e) => {
    if (e.length > 2)
      if (ps[e])
        e = ps[e];
      else
        return [
          e
        ];
    const [t, n] = e.split(""), o = Xp[t], r = Zp[n] || "";
    return Array.isArray(r) ? r.map((a) => o + a) : [
      o + r
    ];
  }), oi = [
    "m",
    "mt",
    "mr",
    "mb",
    "ml",
    "mx",
    "my",
    "margin",
    "marginTop",
    "marginRight",
    "marginBottom",
    "marginLeft",
    "marginX",
    "marginY",
    "marginInline",
    "marginInlineStart",
    "marginInlineEnd",
    "marginBlock",
    "marginBlockStart",
    "marginBlockEnd"
  ], ri = [
    "p",
    "pt",
    "pr",
    "pb",
    "pl",
    "px",
    "py",
    "padding",
    "paddingTop",
    "paddingRight",
    "paddingBottom",
    "paddingLeft",
    "paddingX",
    "paddingY",
    "paddingInline",
    "paddingInlineStart",
    "paddingInlineEnd",
    "paddingBlock",
    "paddingBlockStart",
    "paddingBlockEnd"
  ];
  [
    ...oi,
    ...ri
  ];
  function lo(e, t, n, o) {
    var r;
    const a = (r = sr(e, t, false)) != null ? r : n;
    return typeof a == "number" ? (i) => typeof i == "string" ? i : a * i : Array.isArray(a) ? (i) => typeof i == "string" ? i : a[i] : typeof a == "function" ? a : () => {
    };
  }
  function Rc(e) {
    return lo(e, "spacing", 8);
  }
  function co(e, t) {
    if (typeof t == "string" || t == null)
      return t;
    const n = Math.abs(t), o = e(n);
    return t >= 0 ? o : typeof o == "number" ? -o : `-${o}`;
  }
  function Qp(e, t) {
    return (n) => e.reduce((o, r) => (o[r] = co(t, n), o), {});
  }
  function ef(e, t, n, o) {
    if (t.indexOf(n) === -1)
      return null;
    const r = Jp(n), a = Qp(r, o), i = e[n];
    return Pt(e, i, a);
  }
  function _c(e, t) {
    const n = Rc(e.theme);
    return Object.keys(e).map((o) => ef(e, t, o, n)).reduce(Qn, {});
  }
  function Fe(e) {
    return _c(e, oi);
  }
  Fe.propTypes = {};
  Fe.filterProps = oi;
  function Oe(e) {
    return _c(e, ri);
  }
  Oe.propTypes = {};
  Oe.filterProps = ri;
  function tf(e = 8) {
    if (e.mui)
      return e;
    const t = Rc({
      spacing: e
    }), n = (...o) => (o.length === 0 ? [
      1
    ] : o).map((a) => {
      const i = t(a);
      return typeof i == "number" ? `${i}px` : i;
    }).join(" ");
    return n.mui = true, n;
  }
  function lr(...e) {
    const t = e.reduce((o, r) => (r.filterProps.forEach((a) => {
      o[a] = r;
    }), o), {}), n = (o) => Object.keys(o).reduce((r, a) => t[a] ? Qn(r, t[a](o)) : r, {});
    return n.propTypes = {}, n.filterProps = e.reduce((o, r) => o.concat(r.filterProps), []), n;
  }
  function ut(e) {
    return typeof e != "number" ? e : `${e}px solid`;
  }
  function pt(e, t) {
    return De({
      prop: e,
      themeKey: "borders",
      transform: t
    });
  }
  const nf = pt("border", ut), of = pt("borderTop", ut), rf = pt("borderRight", ut), af = pt("borderBottom", ut), sf = pt("borderLeft", ut), lf = pt("borderColor"), cf = pt("borderTopColor"), uf = pt("borderRightColor"), df = pt("borderBottomColor"), pf = pt("borderLeftColor"), ff = pt("outline", ut), hf = pt("outlineColor"), cr = (e) => {
    if (e.borderRadius !== void 0 && e.borderRadius !== null) {
      const t = lo(e.theme, "shape.borderRadius", 4), n = (o) => ({
        borderRadius: co(t, o)
      });
      return Pt(e, e.borderRadius, n);
    }
    return null;
  };
  cr.propTypes = {};
  cr.filterProps = [
    "borderRadius"
  ];
  lr(nf, of, rf, af, sf, lf, cf, uf, df, pf, cr, ff, hf);
  const ur = (e) => {
    if (e.gap !== void 0 && e.gap !== null) {
      const t = lo(e.theme, "spacing", 8), n = (o) => ({
        gap: co(t, o)
      });
      return Pt(e, e.gap, n);
    }
    return null;
  };
  ur.propTypes = {};
  ur.filterProps = [
    "gap"
  ];
  const dr = (e) => {
    if (e.columnGap !== void 0 && e.columnGap !== null) {
      const t = lo(e.theme, "spacing", 8), n = (o) => ({
        columnGap: co(t, o)
      });
      return Pt(e, e.columnGap, n);
    }
    return null;
  };
  dr.propTypes = {};
  dr.filterProps = [
    "columnGap"
  ];
  const pr = (e) => {
    if (e.rowGap !== void 0 && e.rowGap !== null) {
      const t = lo(e.theme, "spacing", 8), n = (o) => ({
        rowGap: co(t, o)
      });
      return Pt(e, e.rowGap, n);
    }
    return null;
  };
  pr.propTypes = {};
  pr.filterProps = [
    "rowGap"
  ];
  const mf = De({
    prop: "gridColumn"
  }), gf = De({
    prop: "gridRow"
  }), vf = De({
    prop: "gridAutoFlow"
  }), bf = De({
    prop: "gridAutoColumns"
  }), yf = De({
    prop: "gridAutoRows"
  }), xf = De({
    prop: "gridTemplateColumns"
  }), Sf = De({
    prop: "gridTemplateRows"
  }), Rf = De({
    prop: "gridTemplateAreas"
  }), _f = De({
    prop: "gridArea"
  });
  lr(ur, dr, pr, mf, gf, vf, bf, yf, xf, Sf, Rf, _f);
  function Rn(e, t) {
    return t === "grey" ? t : e;
  }
  const Cf = De({
    prop: "color",
    themeKey: "palette",
    transform: Rn
  }), wf = De({
    prop: "bgcolor",
    cssProperty: "backgroundColor",
    themeKey: "palette",
    transform: Rn
  }), $f = De({
    prop: "backgroundColor",
    themeKey: "palette",
    transform: Rn
  });
  lr(Cf, wf, $f);
  function ot(e) {
    return e <= 1 && e !== 0 ? `${e * 100}%` : e;
  }
  const Ef = De({
    prop: "width",
    transform: ot
  }), ai = (e) => {
    if (e.maxWidth !== void 0 && e.maxWidth !== null) {
      const t = (n) => {
        var o, r;
        const a = ((o = e.theme) == null || (o = o.breakpoints) == null || (o = o.values) == null ? void 0 : o[n]) || ni[n];
        return a ? ((r = e.theme) == null || (r = r.breakpoints) == null ? void 0 : r.unit) !== "px" ? {
          maxWidth: `${a}${e.theme.breakpoints.unit}`
        } : {
          maxWidth: a
        } : {
          maxWidth: ot(n)
        };
      };
      return Pt(e, e.maxWidth, t);
    }
    return null;
  };
  ai.filterProps = [
    "maxWidth"
  ];
  const Tf = De({
    prop: "minWidth",
    transform: ot
  }), kf = De({
    prop: "height",
    transform: ot
  }), Af = De({
    prop: "maxHeight",
    transform: ot
  }), Mf = De({
    prop: "minHeight",
    transform: ot
  });
  De({
    prop: "size",
    cssProperty: "width",
    transform: ot
  });
  De({
    prop: "size",
    cssProperty: "height",
    transform: ot
  });
  const Pf = De({
    prop: "boxSizing"
  });
  lr(Ef, ai, Tf, kf, Af, Mf, Pf);
  const Lf = {
    border: {
      themeKey: "borders",
      transform: ut
    },
    borderTop: {
      themeKey: "borders",
      transform: ut
    },
    borderRight: {
      themeKey: "borders",
      transform: ut
    },
    borderBottom: {
      themeKey: "borders",
      transform: ut
    },
    borderLeft: {
      themeKey: "borders",
      transform: ut
    },
    borderColor: {
      themeKey: "palette"
    },
    borderTopColor: {
      themeKey: "palette"
    },
    borderRightColor: {
      themeKey: "palette"
    },
    borderBottomColor: {
      themeKey: "palette"
    },
    borderLeftColor: {
      themeKey: "palette"
    },
    outline: {
      themeKey: "borders",
      transform: ut
    },
    outlineColor: {
      themeKey: "palette"
    },
    borderRadius: {
      themeKey: "shape.borderRadius",
      style: cr
    },
    color: {
      themeKey: "palette",
      transform: Rn
    },
    bgcolor: {
      themeKey: "palette",
      cssProperty: "backgroundColor",
      transform: Rn
    },
    backgroundColor: {
      themeKey: "palette",
      transform: Rn
    },
    p: {
      style: Oe
    },
    pt: {
      style: Oe
    },
    pr: {
      style: Oe
    },
    pb: {
      style: Oe
    },
    pl: {
      style: Oe
    },
    px: {
      style: Oe
    },
    py: {
      style: Oe
    },
    padding: {
      style: Oe
    },
    paddingTop: {
      style: Oe
    },
    paddingRight: {
      style: Oe
    },
    paddingBottom: {
      style: Oe
    },
    paddingLeft: {
      style: Oe
    },
    paddingX: {
      style: Oe
    },
    paddingY: {
      style: Oe
    },
    paddingInline: {
      style: Oe
    },
    paddingInlineStart: {
      style: Oe
    },
    paddingInlineEnd: {
      style: Oe
    },
    paddingBlock: {
      style: Oe
    },
    paddingBlockStart: {
      style: Oe
    },
    paddingBlockEnd: {
      style: Oe
    },
    m: {
      style: Fe
    },
    mt: {
      style: Fe
    },
    mr: {
      style: Fe
    },
    mb: {
      style: Fe
    },
    ml: {
      style: Fe
    },
    mx: {
      style: Fe
    },
    my: {
      style: Fe
    },
    margin: {
      style: Fe
    },
    marginTop: {
      style: Fe
    },
    marginRight: {
      style: Fe
    },
    marginBottom: {
      style: Fe
    },
    marginLeft: {
      style: Fe
    },
    marginX: {
      style: Fe
    },
    marginY: {
      style: Fe
    },
    marginInline: {
      style: Fe
    },
    marginInlineStart: {
      style: Fe
    },
    marginInlineEnd: {
      style: Fe
    },
    marginBlock: {
      style: Fe
    },
    marginBlockStart: {
      style: Fe
    },
    marginBlockEnd: {
      style: Fe
    },
    displayPrint: {
      cssProperty: false,
      transform: (e) => ({
        "@media print": {
          display: e
        }
      })
    },
    display: {},
    overflow: {},
    textOverflow: {},
    visibility: {},
    whiteSpace: {},
    flexBasis: {},
    flexDirection: {},
    flexWrap: {},
    justifyContent: {},
    alignItems: {},
    alignContent: {},
    order: {},
    flex: {},
    flexGrow: {},
    flexShrink: {},
    alignSelf: {},
    justifyItems: {},
    justifySelf: {},
    gap: {
      style: ur
    },
    rowGap: {
      style: pr
    },
    columnGap: {
      style: dr
    },
    gridColumn: {},
    gridRow: {},
    gridAutoFlow: {},
    gridAutoColumns: {},
    gridAutoRows: {},
    gridTemplateColumns: {},
    gridTemplateRows: {},
    gridTemplateAreas: {},
    gridArea: {},
    position: {},
    zIndex: {
      themeKey: "zIndex"
    },
    top: {},
    right: {},
    bottom: {},
    left: {},
    boxShadow: {
      themeKey: "shadows"
    },
    width: {
      transform: ot
    },
    maxWidth: {
      style: ai
    },
    minWidth: {
      transform: ot
    },
    height: {
      transform: ot
    },
    maxHeight: {
      transform: ot
    },
    minHeight: {
      transform: ot
    },
    boxSizing: {},
    fontFamily: {
      themeKey: "typography"
    },
    fontSize: {
      themeKey: "typography"
    },
    fontStyle: {
      themeKey: "typography"
    },
    fontWeight: {
      themeKey: "typography"
    },
    letterSpacing: {},
    textTransform: {},
    lineHeight: {},
    textAlign: {},
    typography: {
      cssProperty: false,
      themeKey: "typography"
    }
  }, uo = Lf;
  function If(...e) {
    const t = e.reduce((o, r) => o.concat(Object.keys(r)), []), n = new Set(t);
    return e.every((o) => n.size === Object.keys(o).length);
  }
  function Nf(e, t) {
    return typeof e == "function" ? e(t) : e;
  }
  function Cc() {
    function e(n, o, r, a) {
      const i = {
        [n]: o,
        theme: r
      }, s = a[n];
      if (!s)
        return {
          [n]: o
        };
      const { cssProperty: l = n, themeKey: c, transform: d, style: p } = s;
      if (o == null)
        return null;
      if (c === "typography" && o === "inherit")
        return {
          [n]: o
        };
      const m = sr(r, c) || {};
      return p ? p(i) : Pt(i, o, (g) => {
        let h = qo(m, d, g);
        return g === h && typeof g == "string" && (h = qo(m, d, `${n}${g === "default" ? "" : oe(g)}`, g)), l === false ? h : {
          [l]: h
        };
      });
    }
    function t(n) {
      var o;
      const { sx: r, theme: a = {}, nested: i } = n || {};
      if (!r)
        return null;
      const s = (o = a.unstable_sxConfig) != null ? o : uo;
      function l(c) {
        let d = c;
        if (typeof c == "function")
          d = c(a);
        else if (typeof c != "object")
          return c;
        if (!d)
          return null;
        const p = qp(a.breakpoints), m = Object.keys(p);
        let v = p;
        return Object.keys(d).forEach((g) => {
          const h = Nf(d[g], a);
          if (h != null)
            if (typeof h == "object")
              if (s[g])
                v = Qn(v, e(g, h, a, s));
              else {
                const C = Pt({
                  theme: a
                }, h, ($) => ({
                  [g]: $
                }));
                If(C, h) ? v[g] = t({
                  sx: h,
                  theme: a,
                  nested: true
                }) : v = Qn(v, C);
              }
            else
              v = Qn(v, e(g, h, a, s));
        }), !i && a.modularCssLayers ? {
          "@layer sx": ds(m, v)
        } : ds(m, v);
      }
      return Array.isArray(r) ? r.map(l) : l(r);
    }
    return t;
  }
  const wc = Cc();
  wc.filterProps = [
    "sx"
  ];
  const fr = wc;
  function $c(e, t) {
    const n = this;
    return n.vars && typeof n.getColorSchemeSelector == "function" ? {
      [n.getColorSchemeSelector(e).replace(/(\[[^\]]+\])/, "*:where($1)")]: t
    } : n.palette.mode === e ? t : {};
  }
  const Ff = [
    "breakpoints",
    "palette",
    "spacing",
    "shape"
  ];
  function ii(e = {}, ...t) {
    const { breakpoints: n = {}, palette: o = {}, spacing: r, shape: a = {} } = e, i = ee(e, Ff), s = Sc(n), l = tf(r);
    let c = at({
      breakpoints: s,
      direction: "ltr",
      components: {},
      palette: f({
        mode: "light"
      }, o),
      spacing: l,
      shape: f({}, Kp, a)
    }, i);
    return c.applyStyles = $c, c = t.reduce((d, p) => at(d, p), c), c.unstable_sxConfig = f({}, uo, i == null ? void 0 : i.unstable_sxConfig), c.unstable_sx = function(p) {
      return fr({
        sx: p,
        theme: this
      });
    }, c;
  }
  const Of = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: ii,
    private_createBreakpoints: Sc,
    unstable_applyStyles: $c
  }, Symbol.toStringTag, {
    value: "Module"
  })), Bf = await M("react");
  function Df(e) {
    return Object.keys(e).length === 0;
  }
  function si(e = null) {
    const t = Bf.useContext(ti);
    return !t || Df(t) ? e : t;
  }
  const jf = ii();
  function li(e = jf) {
    return si(e);
  }
  await M("react");
  function ra(e) {
    const t = bc(e);
    return e !== t && t.styles ? (t.styles.match(/^@layer\s+[^{]*$/) || (t.styles = `@layer global{${t.styles}}`), t) : e;
  }
  function Ec({ styles: e, themeId: t, defaultTheme: n = {} }) {
    const o = li(n), r = t && o[t] || o;
    let a = typeof e == "function" ? e(r) : e;
    return r.modularCssLayers && (Array.isArray(a) ? a = a.map((i) => ra(typeof i == "function" ? i(r) : i)) : a = ra(a)), u.jsx(gc, {
      styles: a
    });
  }
  const zf = [
    "sx"
  ], Vf = (e) => {
    var t, n;
    const o = {
      systemProps: {},
      otherProps: {}
    }, r = (t = e == null || (n = e.theme) == null ? void 0 : n.unstable_sxConfig) != null ? t : uo;
    return Object.keys(e).forEach((a) => {
      r[a] ? o.systemProps[a] = e[a] : o.otherProps[a] = e[a];
    }), o;
  };
  function ci(e) {
    const { sx: t } = e, n = ee(e, zf), { systemProps: o, otherProps: r } = Vf(n);
    let a;
    return Array.isArray(t) ? a = [
      o,
      ...t
    ] : typeof t == "function" ? a = (...i) => {
      const s = t(...i);
      return Ut(s) ? f({}, o, s) : o;
    } : a = f({}, o, t), f({}, r, {
      sx: a
    });
  }
  const Uf = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: fr,
    extendSxProp: ci,
    unstable_createStyleFunctionSx: Cc,
    unstable_defaultSxConfig: uo
  }, Symbol.toStringTag, {
    value: "Module"
  })), fs = (e) => e, Wf = () => {
    let e = fs;
    return {
      configure(t) {
        e = t;
      },
      generate(t) {
        return e(t);
      },
      reset() {
        e = fs;
      }
    };
  }, Hf = Wf(), ui = Hf;
  function Tc(e) {
    var t, n, o = "";
    if (typeof e == "string" || typeof e == "number")
      o += e;
    else if (typeof e == "object")
      if (Array.isArray(e)) {
        var r = e.length;
        for (t = 0; t < r; t++)
          e[t] && (n = Tc(e[t])) && (o && (o += " "), o += n);
      } else
        for (n in e)
          e[n] && (o && (o += " "), o += n);
    return o;
  }
  function ae() {
    for (var e, t, n = 0, o = "", r = arguments.length; n < r; n++)
      (e = arguments[n]) && (t = Tc(e)) && (o && (o += " "), o += t);
    return o;
  }
  const Kf = [
    "className",
    "component"
  ], qf = await M("react");
  function Gf(e = {}) {
    const { themeId: t, defaultTheme: n, defaultClassName: o = "MuiBox-root", generateClassName: r } = e, a = vc("div", {
      shouldForwardProp: (s) => s !== "theme" && s !== "sx" && s !== "as"
    })(fr);
    return qf.forwardRef(function(l, c) {
      const d = li(n), p = ci(l), { className: m, component: v = "div" } = p, g = ee(p, Kf);
      return u.jsx(a, f({
        as: v,
        ref: c,
        className: ae(m, r ? r(o) : o),
        theme: t && d[t] || d
      }, g));
    });
  }
  const Yf = {
    active: "active",
    checked: "checked",
    completed: "completed",
    disabled: "disabled",
    error: "error",
    expanded: "expanded",
    focused: "focused",
    focusVisible: "focusVisible",
    open: "open",
    readOnly: "readOnly",
    required: "required",
    selected: "selected"
  };
  function xe(e, t, n = "Mui") {
    const o = Yf[t];
    return o ? `${n}-${o}` : `${ui.generate(e)}-${t}`;
  }
  function ye(e, t, n = "Mui") {
    const o = {};
    return t.forEach((r) => {
      o[r] = xe(e, r, n);
    }), o;
  }
  var kc = {
    exports: {}
  }, Te = {};
  var di = Symbol.for("react.transitional.element"), pi = Symbol.for("react.portal"), hr = Symbol.for("react.fragment"), mr = Symbol.for("react.strict_mode"), gr = Symbol.for("react.profiler"), vr = Symbol.for("react.consumer"), br = Symbol.for("react.context"), yr = Symbol.for("react.forward_ref"), xr = Symbol.for("react.suspense"), Sr = Symbol.for("react.suspense_list"), Rr = Symbol.for("react.memo"), _r = Symbol.for("react.lazy"), Xf = Symbol.for("react.view_transition"), Zf = Symbol.for("react.client.reference");
  function ft(e) {
    if (typeof e == "object" && e !== null) {
      var t = e.$$typeof;
      switch (t) {
        case di:
          switch (e = e.type, e) {
            case hr:
            case gr:
            case mr:
            case xr:
            case Sr:
            case Xf:
              return e;
            default:
              switch (e = e && e.$$typeof, e) {
                case br:
                case yr:
                case _r:
                case Rr:
                  return e;
                case vr:
                  return e;
                default:
                  return t;
              }
          }
        case pi:
          return t;
      }
    }
  }
  Te.ContextConsumer = vr;
  Te.ContextProvider = br;
  Te.Element = di;
  Te.ForwardRef = yr;
  Te.Fragment = hr;
  Te.Lazy = _r;
  Te.Memo = Rr;
  Te.Portal = pi;
  Te.Profiler = gr;
  Te.StrictMode = mr;
  Te.Suspense = xr;
  Te.SuspenseList = Sr;
  Te.isContextConsumer = function(e) {
    return ft(e) === vr;
  };
  Te.isContextProvider = function(e) {
    return ft(e) === br;
  };
  Te.isElement = function(e) {
    return typeof e == "object" && e !== null && e.$$typeof === di;
  };
  Te.isForwardRef = function(e) {
    return ft(e) === yr;
  };
  Te.isFragment = function(e) {
    return ft(e) === hr;
  };
  Te.isLazy = function(e) {
    return ft(e) === _r;
  };
  Te.isMemo = function(e) {
    return ft(e) === Rr;
  };
  Te.isPortal = function(e) {
    return ft(e) === pi;
  };
  Te.isProfiler = function(e) {
    return ft(e) === gr;
  };
  Te.isStrictMode = function(e) {
    return ft(e) === mr;
  };
  Te.isSuspense = function(e) {
    return ft(e) === xr;
  };
  Te.isSuspenseList = function(e) {
    return ft(e) === Sr;
  };
  Te.isValidElementType = function(e) {
    return typeof e == "string" || typeof e == "function" || e === hr || e === gr || e === mr || e === xr || e === Sr || typeof e == "object" && e !== null && (e.$$typeof === _r || e.$$typeof === Rr || e.$$typeof === br || e.$$typeof === vr || e.$$typeof === yr || e.$$typeof === Zf || e.getModuleId !== void 0);
  };
  Te.typeOf = ft;
  kc.exports = Te;
  var hs = kc.exports;
  const Jf = /^\s*function(?:\s|\s*\/\*.*\*\/\s*)+([^(\s/]*)\s*/;
  function Ac(e) {
    const t = `${e}`.match(Jf);
    return t && t[1] || "";
  }
  function Mc(e, t = "") {
    return e.displayName || e.name || Ac(e) || t;
  }
  function ms(e, t, n) {
    const o = Mc(t);
    return e.displayName || (o !== "" ? `${n}(${o})` : n);
  }
  function Qf(e) {
    if (e != null) {
      if (typeof e == "string")
        return e;
      if (typeof e == "function")
        return Mc(e, "Component");
      if (typeof e == "object")
        switch (e.$$typeof) {
          case hs.ForwardRef:
            return ms(e, e.render, "ForwardRef");
          case hs.Memo:
            return ms(e, e.type, "memo");
          default:
            return;
        }
    }
  }
  const eh = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: Qf,
    getFunctionName: Ac
  }, Symbol.toStringTag, {
    value: "Module"
  }));
  function Go(e, t) {
    const n = f({}, t);
    return Object.keys(e).forEach((o) => {
      if (o.toString().match(/^(components|slots)$/))
        n[o] = f({}, e[o], n[o]);
      else if (o.toString().match(/^(componentsProps|slotProps)$/)) {
        const r = e[o] || {}, a = t[o];
        n[o] = {}, !a || !Object.keys(a) ? n[o] = r : !r || !Object.keys(r) ? n[o] = a : (n[o] = f({}, a), Object.keys(r).forEach((i) => {
          n[o][i] = Go(r[i], a[i]);
        }));
      } else
        n[o] === void 0 && (n[o] = e[o]);
    }), n;
  }
  const gs = await M("react"), th = typeof window < "u" ? gs.useLayoutEffect : gs.useEffect, Lt = th;
  function Pc(e, t = Number.MIN_SAFE_INTEGER, n = Number.MAX_SAFE_INTEGER) {
    return Math.max(t, Math.min(e, n));
  }
  const nh = Object.freeze(Object.defineProperty({
    __proto__: null,
    default: Pc
  }, Symbol.toStringTag, {
    value: "Module"
  }));
  function oh(e, t = 0, n = 1) {
    return Pc(e, t, n);
  }
  function rh(e) {
    e = e.slice(1);
    const t = new RegExp(`.{1,${e.length >= 6 ? 2 : 1}}`, "g");
    let n = e.match(t);
    return n && n[0].length === 1 && (n = n.map((o) => o + o)), n ? `rgb${n.length === 4 ? "a" : ""}(${n.map((o, r) => r < 3 ? parseInt(o, 16) : Math.round(parseInt(o, 16) / 255 * 1e3) / 1e3).join(", ")})` : "";
  }
  function Lc(e) {
    if (e.type)
      return e;
    if (e.charAt(0) === "#")
      return Lc(rh(e));
    const t = e.indexOf("("), n = e.substring(0, t);
    if ([
      "rgb",
      "rgba",
      "hsl",
      "hsla",
      "color"
    ].indexOf(n) === -1)
      throw new Error(Mt(9, e));
    let o = e.substring(t + 1, e.length - 1), r;
    if (n === "color") {
      if (o = o.split(" "), r = o.shift(), o.length === 4 && o[3].charAt(0) === "/" && (o[3] = o[3].slice(1)), [
        "srgb",
        "display-p3",
        "a98-rgb",
        "prophoto-rgb",
        "rec-2020"
      ].indexOf(r) === -1)
        throw new Error(Mt(10, r));
    } else
      o = o.split(",");
    return o = o.map((a) => parseFloat(a)), {
      type: n,
      values: o,
      colorSpace: r
    };
  }
  function ah(e) {
    const { type: t, colorSpace: n } = e;
    let { values: o } = e;
    return t.indexOf("rgb") !== -1 ? o = o.map((r, a) => a < 3 ? parseInt(r, 10) : r) : t.indexOf("hsl") !== -1 && (o[1] = `${o[1]}%`, o[2] = `${o[2]}%`), t.indexOf("color") !== -1 ? o = `${n} ${o.join(" ")}` : o = `${o.join(", ")}`, `${t}(${o})`;
  }
  function ih(e, t) {
    return e = Lc(e), t = oh(t), (e.type === "rgb" || e.type === "hsl") && (e.type += "a"), e.type === "color" ? e.values[3] = `/${t}` : e.values[3] = t, ah(e);
  }
  function La(...e) {
    return e.reduce((t, n) => n == null ? t : function(...r) {
      t.apply(this, r), n.apply(this, r);
    }, () => {
    });
  }
  function fi(e, t = 166) {
    let n;
    function o(...r) {
      const a = () => {
        e.apply(this, r);
      };
      clearTimeout(n), n = setTimeout(a, t);
    }
    return o.clear = () => {
      clearTimeout(n);
    }, o;
  }
  function sh(e, t) {
    return () => null;
  }
  const lh = await M("react");
  function zo(e, t) {
    var n, o;
    return lh.isValidElement(e) && t.indexOf((n = e.type.muiName) != null ? n : (o = e.type) == null || (o = o._payload) == null || (o = o.value) == null ? void 0 : o.muiName) !== -1;
  }
  function Xe(e) {
    return e && e.ownerDocument || document;
  }
  function qt(e) {
    return Xe(e).defaultView || window;
  }
  function ch(e, t) {
    return () => null;
  }
  function Yo(e, t) {
    typeof e == "function" ? e(t) : e && (e.current = t);
  }
  const Ia = await M("react");
  let vs = 0;
  function uh(e) {
    const [t, n] = Ia.useState(e), o = e || t;
    return Ia.useEffect(() => {
      t == null && (vs += 1, n(`mui-${vs}`));
    }, [
      t
    ]), o;
  }
  const bs = Ia["useId".toString()];
  function po(e) {
    if (bs !== void 0) {
      const t = bs();
      return e ?? t;
    }
    return uh(e);
  }
  function dh(e, t, n, o, r) {
    return null;
  }
  const aa = await M("react");
  function Na({ controlled: e, default: t, name: n, state: o = "value" }) {
    const { current: r } = aa.useRef(e !== void 0), [a, i] = aa.useState(t), s = r ? e : a, l = aa.useCallback((c) => {
      r || i(c);
    }, []);
    return [
      s,
      l
    ];
  }
  const ys = await M("react");
  function Wt(e) {
    const t = ys.useRef(e);
    return Lt(() => {
      t.current = e;
    }), ys.useRef((...n) => (0, t.current)(...n)).current;
  }
  const ph = await M("react");
  function Ve(...e) {
    return ph.useMemo(() => e.every((t) => t == null) ? null : (t) => {
      e.forEach((n) => {
        Yo(n, t);
      });
    }, e);
  }
  const fh = await M("react"), xs = {};
  function hh(e, t) {
    const n = fh.useRef(xs);
    return n.current === xs && (n.current = e(t)), n;
  }
  const mh = await M("react"), gh = [];
  function vh(e) {
    mh.useEffect(e, gh);
  }
  class Cr {
    constructor() {
      this.currentId = null, this.clear = () => {
        this.currentId !== null && (clearTimeout(this.currentId), this.currentId = null);
      }, this.disposeEffect = () => this.clear;
    }
    static create() {
      return new Cr();
    }
    start(t, n) {
      this.clear(), this.currentId = setTimeout(() => {
        this.currentId = null, n();
      }, t);
    }
  }
  function hi() {
    const e = hh(Cr.create).current;
    return vh(e.disposeEffect), e;
  }
  const Ss = await M("react");
  let wr = true, Fa = false;
  const bh = new Cr(), yh = {
    text: true,
    search: true,
    url: true,
    tel: true,
    email: true,
    password: true,
    number: true,
    date: true,
    month: true,
    week: true,
    time: true,
    datetime: true,
    "datetime-local": true
  };
  function xh(e) {
    const { type: t, tagName: n } = e;
    return !!(n === "INPUT" && yh[t] && !e.readOnly || n === "TEXTAREA" && !e.readOnly || e.isContentEditable);
  }
  function Sh(e) {
    e.metaKey || e.altKey || e.ctrlKey || (wr = true);
  }
  function ia() {
    wr = false;
  }
  function Rh() {
    this.visibilityState === "hidden" && Fa && (wr = true);
  }
  function _h(e) {
    e.addEventListener("keydown", Sh, true), e.addEventListener("mousedown", ia, true), e.addEventListener("pointerdown", ia, true), e.addEventListener("touchstart", ia, true), e.addEventListener("visibilitychange", Rh, true);
  }
  function Ch(e) {
    const { target: t } = e;
    try {
      return t.matches(":focus-visible");
    } catch {
    }
    return wr || xh(t);
  }
  function Ic() {
    const e = Ss.useCallback((r) => {
      r != null && _h(r.ownerDocument);
    }, []), t = Ss.useRef(false);
    function n() {
      return t.current ? (Fa = true, bh.start(100, () => {
        Fa = false;
      }), t.current = false, true) : false;
    }
    function o(r) {
      return Ch(r) ? (t.current = true, true) : false;
    }
    return {
      isFocusVisibleRef: t,
      onFocus: o,
      onBlur: n,
      ref: e
    };
  }
  function Nc(e) {
    const t = e.documentElement.clientWidth;
    return Math.abs(window.innerWidth - t);
  }
  function Se(e, t, n = void 0) {
    const o = {};
    return Object.keys(e).forEach((r) => {
      o[r] = e[r].reduce((a, i) => {
        if (i) {
          const s = t(i);
          s !== "" && a.push(s), n && n[i] && a.push(n[i]);
        }
        return a;
      }, []).join(" ");
    }), o;
  }
  function Xo(e) {
    return typeof e == "string";
  }
  function Fc(e, t, n) {
    return e === void 0 || Xo(e) ? t : f({}, t, {
      ownerState: f({}, t.ownerState, n)
    });
  }
  function Oc(e, t = []) {
    if (e === void 0)
      return {};
    const n = {};
    return Object.keys(e).filter((o) => o.match(/^on[A-Z]/) && typeof e[o] == "function" && !t.includes(o)).forEach((o) => {
      n[o] = e[o];
    }), n;
  }
  function Rs(e) {
    if (e === void 0)
      return {};
    const t = {};
    return Object.keys(e).filter((n) => !(n.match(/^on[A-Z]/) && typeof e[n] == "function")).forEach((n) => {
      t[n] = e[n];
    }), t;
  }
  function Bc(e) {
    const { getSlotProps: t, additionalProps: n, externalSlotProps: o, externalForwardedProps: r, className: a } = e;
    if (!t) {
      const v = ae(n == null ? void 0 : n.className, a, r == null ? void 0 : r.className, o == null ? void 0 : o.className), g = f({}, n == null ? void 0 : n.style, r == null ? void 0 : r.style, o == null ? void 0 : o.style), h = f({}, n, r, o);
      return v.length > 0 && (h.className = v), Object.keys(g).length > 0 && (h.style = g), {
        props: h,
        internalRef: void 0
      };
    }
    const i = Oc(f({}, r, o)), s = Rs(o), l = Rs(r), c = t(i), d = ae(c == null ? void 0 : c.className, n == null ? void 0 : n.className, a, r == null ? void 0 : r.className, o == null ? void 0 : o.className), p = f({}, c == null ? void 0 : c.style, n == null ? void 0 : n.style, r == null ? void 0 : r.style, o == null ? void 0 : o.style), m = f({}, c, n, l, s);
    return d.length > 0 && (m.className = d), Object.keys(p).length > 0 && (m.style = p), {
      props: m,
      internalRef: c.ref
    };
  }
  function Dc(e, t, n) {
    return typeof e == "function" ? e(t, n) : e;
  }
  const wh = [
    "elementType",
    "externalSlotProps",
    "ownerState",
    "skipResolvingSlotProps"
  ];
  function wn(e) {
    var t;
    const { elementType: n, externalSlotProps: o, ownerState: r, skipResolvingSlotProps: a = false } = e, i = ee(e, wh), s = a ? {} : Dc(o, r), { props: l, internalRef: c } = Bc(f({}, i, {
      externalSlotProps: s
    })), d = Ve(c, s == null ? void 0 : s.ref, (t = e.additionalProps) == null ? void 0 : t.ref);
    return Fc(n, f({}, l, {
      ref: d
    }), r);
  }
  const $h = await M("react");
  function fo(e) {
    if (parseInt($h.version, 10) >= 19) {
      var t;
      return (e == null || (t = e.props) == null ? void 0 : t.ref) || null;
    }
    return (e == null ? void 0 : e.ref) || null;
  }
  const Eh = await M("react"), Th = Eh.createContext(null), jc = Th, kh = await M("react");
  function zc() {
    return kh.useContext(jc);
  }
  const Ah = typeof Symbol == "function" && Symbol.for, Mh = Ah ? Symbol.for("mui.nested") : "__THEME_NESTED__", Ph = await M("react");
  function Lh(e, t) {
    return typeof t == "function" ? t(e) : f({}, e, t);
  }
  function Ih(e) {
    const { children: t, theme: n } = e, o = zc(), r = Ph.useMemo(() => {
      const a = o === null ? n : Lh(o, n);
      return a != null && (a[Mh] = o !== null), a;
    }, [
      n,
      o
    ]);
    return u.jsx(jc.Provider, {
      value: r,
      children: t
    });
  }
  const Nh = [
    "value"
  ], Vc = await M("react"), Uc = Vc.createContext();
  function Fh(e) {
    let { value: t } = e, n = ee(e, Nh);
    return u.jsx(Uc.Provider, f({
      value: t ?? true
    }, n));
  }
  const Oh = () => {
    const e = Vc.useContext(Uc);
    return e ?? false;
  }, Wc = await M("react"), Hc = Wc.createContext(void 0);
  function Bh({ value: e, children: t }) {
    return u.jsx(Hc.Provider, {
      value: e,
      children: t
    });
  }
  function Dh(e) {
    const { theme: t, name: n, props: o } = e;
    if (!t || !t.components || !t.components[n])
      return o;
    const r = t.components[n];
    return r.defaultProps ? Go(r.defaultProps, o) : !r.styleOverrides && !r.variants ? Go(r, o) : o;
  }
  function jh({ props: e, name: t }) {
    const n = Wc.useContext(Hc);
    return Dh({
      props: e,
      name: t,
      theme: {
        components: n
      }
    });
  }
  await M("react");
  function zh(e) {
    const t = si(), n = po() || "", { modularCssLayers: o } = e;
    let r = "mui.global, mui.components, mui.theme, mui.custom, mui.sx";
    return !o || t !== null ? r = "" : typeof o == "string" ? r = o.replace(/mui(?!\.)/g, r) : r = `@layer ${r};`, Lt(() => {
      const a = document.querySelector("head");
      if (!a)
        return;
      const i = a.firstChild;
      if (r) {
        var s;
        if (i && (s = i.hasAttribute) != null && s.call(i, "data-mui-layer-order") && i.getAttribute("data-mui-layer-order") === n)
          return;
        const c = document.createElement("style");
        c.setAttribute("data-mui-layer-order", n), c.textContent = r, a.prepend(c);
      } else {
        var l;
        (l = a.querySelector(`style[data-mui-layer-order="${n}"]`)) == null || l.remove();
      }
    }, [
      r,
      n
    ]), r ? u.jsx(Ec, {
      styles: r
    }) : null;
  }
  const Vh = await M("react"), _s = {};
  function Cs(e, t, n, o = false) {
    return Vh.useMemo(() => {
      const r = e && t[e] || t;
      if (typeof n == "function") {
        const a = n(r), i = e ? f({}, t, {
          [e]: a
        }) : a;
        return o ? () => i : i;
      }
      return e ? f({}, t, {
        [e]: n
      }) : f({}, t, n);
    }, [
      e,
      t,
      n,
      o
    ]);
  }
  function Uh(e) {
    const { children: t, theme: n, themeId: o } = e, r = si(_s), a = zc() || _s, i = Cs(o, r, n), s = Cs(o, a, n, true), l = i.direction === "rtl", c = zh(i);
    return u.jsx(Ih, {
      theme: s,
      children: u.jsx(ti.Provider, {
        value: i,
        children: u.jsx(Fh, {
          value: l,
          children: u.jsxs(Bh, {
            value: i == null ? void 0 : i.components,
            children: [
              c,
              t
            ]
          })
        })
      })
    });
  }
  function Wh(e, t) {
    return f({
      toolbar: {
        minHeight: 56,
        [e.up("xs")]: {
          "@media (orientation: landscape)": {
            minHeight: 48
          }
        },
        [e.up("sm")]: {
          minHeight: 64
        }
      }
    }, t);
  }
  var je = {}, Kc = {
    exports: {}
  };
  (function(e) {
    function t(n) {
      return n && n.__esModule ? n : {
        default: n
      };
    }
    e.exports = t, e.exports.__esModule = true, e.exports.default = e.exports;
  })(Kc);
  var He = Kc.exports;
  const Hh = Ct(Cp), Kh = Ct(nh);
  var qc = He;
  Object.defineProperty(je, "__esModule", {
    value: true
  });
  var Ht = je.alpha = Zc;
  je.blend = om;
  je.colorChannel = void 0;
  var Oa = je.darken = gi;
  je.decomposeColor = dt;
  je.emphasize = Jc;
  var qh = je.getContrastRatio = Jh;
  je.getLuminance = Zo;
  je.hexToRgb = Gc;
  je.hslToRgb = Xc;
  var Ba = je.lighten = vi;
  je.private_safeAlpha = Qh;
  je.private_safeColorChannel = void 0;
  je.private_safeDarken = em;
  je.private_safeEmphasize = nm;
  je.private_safeLighten = tm;
  je.recomposeColor = Ln;
  je.rgbToHex = Zh;
  var ws = qc(Hh), Gh = qc(Kh);
  function mi(e, t = 0, n = 1) {
    return (0, Gh.default)(e, t, n);
  }
  function Gc(e) {
    e = e.slice(1);
    const t = new RegExp(`.{1,${e.length >= 6 ? 2 : 1}}`, "g");
    let n = e.match(t);
    return n && n[0].length === 1 && (n = n.map((o) => o + o)), n ? `rgb${n.length === 4 ? "a" : ""}(${n.map((o, r) => r < 3 ? parseInt(o, 16) : Math.round(parseInt(o, 16) / 255 * 1e3) / 1e3).join(", ")})` : "";
  }
  function Yh(e) {
    const t = e.toString(16);
    return t.length === 1 ? `0${t}` : t;
  }
  function dt(e) {
    if (e.type)
      return e;
    if (e.charAt(0) === "#")
      return dt(Gc(e));
    const t = e.indexOf("("), n = e.substring(0, t);
    if ([
      "rgb",
      "rgba",
      "hsl",
      "hsla",
      "color"
    ].indexOf(n) === -1)
      throw new Error((0, ws.default)(9, e));
    let o = e.substring(t + 1, e.length - 1), r;
    if (n === "color") {
      if (o = o.split(" "), r = o.shift(), o.length === 4 && o[3].charAt(0) === "/" && (o[3] = o[3].slice(1)), [
        "srgb",
        "display-p3",
        "a98-rgb",
        "prophoto-rgb",
        "rec-2020"
      ].indexOf(r) === -1)
        throw new Error((0, ws.default)(10, r));
    } else
      o = o.split(",");
    return o = o.map((a) => parseFloat(a)), {
      type: n,
      values: o,
      colorSpace: r
    };
  }
  const Yc = (e) => {
    const t = dt(e);
    return t.values.slice(0, 3).map((n, o) => t.type.indexOf("hsl") !== -1 && o !== 0 ? `${n}%` : n).join(" ");
  };
  je.colorChannel = Yc;
  const Xh = (e, t) => {
    try {
      return Yc(e);
    } catch {
      return e;
    }
  };
  je.private_safeColorChannel = Xh;
  function Ln(e) {
    const { type: t, colorSpace: n } = e;
    let { values: o } = e;
    return t.indexOf("rgb") !== -1 ? o = o.map((r, a) => a < 3 ? parseInt(r, 10) : r) : t.indexOf("hsl") !== -1 && (o[1] = `${o[1]}%`, o[2] = `${o[2]}%`), t.indexOf("color") !== -1 ? o = `${n} ${o.join(" ")}` : o = `${o.join(", ")}`, `${t}(${o})`;
  }
  function Zh(e) {
    if (e.indexOf("#") === 0)
      return e;
    const { values: t } = dt(e);
    return `#${t.map((n, o) => Yh(o === 3 ? Math.round(255 * n) : n)).join("")}`;
  }
  function Xc(e) {
    e = dt(e);
    const { values: t } = e, n = t[0], o = t[1] / 100, r = t[2] / 100, a = o * Math.min(r, 1 - r), i = (c, d = (c + n / 30) % 12) => r - a * Math.max(Math.min(d - 3, 9 - d, 1), -1);
    let s = "rgb";
    const l = [
      Math.round(i(0) * 255),
      Math.round(i(8) * 255),
      Math.round(i(4) * 255)
    ];
    return e.type === "hsla" && (s += "a", l.push(t[3])), Ln({
      type: s,
      values: l
    });
  }
  function Zo(e) {
    e = dt(e);
    let t = e.type === "hsl" || e.type === "hsla" ? dt(Xc(e)).values : e.values;
    return t = t.map((n) => (e.type !== "color" && (n /= 255), n <= 0.03928 ? n / 12.92 : ((n + 0.055) / 1.055) ** 2.4)), Number((0.2126 * t[0] + 0.7152 * t[1] + 0.0722 * t[2]).toFixed(3));
  }
  function Jh(e, t) {
    const n = Zo(e), o = Zo(t);
    return (Math.max(n, o) + 0.05) / (Math.min(n, o) + 0.05);
  }
  function Zc(e, t) {
    return e = dt(e), t = mi(t), (e.type === "rgb" || e.type === "hsl") && (e.type += "a"), e.type === "color" ? e.values[3] = `/${t}` : e.values[3] = t, Ln(e);
  }
  function Qh(e, t, n) {
    try {
      return Zc(e, t);
    } catch {
      return e;
    }
  }
  function gi(e, t) {
    if (e = dt(e), t = mi(t), e.type.indexOf("hsl") !== -1)
      e.values[2] *= 1 - t;
    else if (e.type.indexOf("rgb") !== -1 || e.type.indexOf("color") !== -1)
      for (let n = 0; n < 3; n += 1)
        e.values[n] *= 1 - t;
    return Ln(e);
  }
  function em(e, t, n) {
    try {
      return gi(e, t);
    } catch {
      return e;
    }
  }
  function vi(e, t) {
    if (e = dt(e), t = mi(t), e.type.indexOf("hsl") !== -1)
      e.values[2] += (100 - e.values[2]) * t;
    else if (e.type.indexOf("rgb") !== -1)
      for (let n = 0; n < 3; n += 1)
        e.values[n] += (255 - e.values[n]) * t;
    else if (e.type.indexOf("color") !== -1)
      for (let n = 0; n < 3; n += 1)
        e.values[n] += (1 - e.values[n]) * t;
    return Ln(e);
  }
  function tm(e, t, n) {
    try {
      return vi(e, t);
    } catch {
      return e;
    }
  }
  function Jc(e, t = 0.15) {
    return Zo(e) > 0.5 ? gi(e, t) : vi(e, t);
  }
  function nm(e, t, n) {
    try {
      return Jc(e, t);
    } catch {
      return e;
    }
  }
  function om(e, t, n, o = 1) {
    const r = (l, c) => Math.round((l ** (1 / o) * (1 - n) + c ** (1 / o) * n) ** o), a = dt(e), i = dt(t), s = [
      r(a.values[0], i.values[0]),
      r(a.values[1], i.values[1]),
      r(a.values[2], i.values[2])
    ];
    return Ln({
      type: "rgb",
      values: s
    });
  }
  const rm = [
    "mode",
    "contrastThreshold",
    "tonalOffset"
  ], $s = {
    text: {
      primary: "rgba(0, 0, 0, 0.87)",
      secondary: "rgba(0, 0, 0, 0.6)",
      disabled: "rgba(0, 0, 0, 0.38)"
    },
    divider: "rgba(0, 0, 0, 0.12)",
    background: {
      paper: io.white,
      default: io.white
    },
    action: {
      active: "rgba(0, 0, 0, 0.54)",
      hover: "rgba(0, 0, 0, 0.04)",
      hoverOpacity: 0.04,
      selected: "rgba(0, 0, 0, 0.08)",
      selectedOpacity: 0.08,
      disabled: "rgba(0, 0, 0, 0.26)",
      disabledBackground: "rgba(0, 0, 0, 0.12)",
      disabledOpacity: 0.38,
      focus: "rgba(0, 0, 0, 0.12)",
      focusOpacity: 0.12,
      activatedOpacity: 0.12
    }
  }, sa = {
    text: {
      primary: io.white,
      secondary: "rgba(255, 255, 255, 0.7)",
      disabled: "rgba(255, 255, 255, 0.5)",
      icon: "rgba(255, 255, 255, 0.5)"
    },
    divider: "rgba(255, 255, 255, 0.12)",
    background: {
      paper: "#121212",
      default: "#121212"
    },
    action: {
      active: io.white,
      hover: "rgba(255, 255, 255, 0.08)",
      hoverOpacity: 0.08,
      selected: "rgba(255, 255, 255, 0.16)",
      selectedOpacity: 0.16,
      disabled: "rgba(255, 255, 255, 0.3)",
      disabledBackground: "rgba(255, 255, 255, 0.12)",
      disabledOpacity: 0.38,
      focus: "rgba(255, 255, 255, 0.12)",
      focusOpacity: 0.12,
      activatedOpacity: 0.24
    }
  };
  function Es(e, t, n, o) {
    const r = o.light || o, a = o.dark || o * 1.5;
    e[t] || (e.hasOwnProperty(n) ? e[t] = e[n] : t === "light" ? e.light = Ba(e.main, r) : t === "dark" && (e.dark = Oa(e.main, a)));
  }
  function am(e = "light") {
    return e === "dark" ? {
      main: mn[200],
      light: mn[50],
      dark: mn[400]
    } : {
      main: mn[700],
      light: mn[400],
      dark: mn[800]
    };
  }
  function im(e = "light") {
    return e === "dark" ? {
      main: hn[200],
      light: hn[50],
      dark: hn[400]
    } : {
      main: hn[500],
      light: hn[300],
      dark: hn[700]
    };
  }
  function sm(e = "light") {
    return e === "dark" ? {
      main: fn[500],
      light: fn[300],
      dark: fn[700]
    } : {
      main: fn[700],
      light: fn[400],
      dark: fn[800]
    };
  }
  function lm(e = "light") {
    return e === "dark" ? {
      main: gn[400],
      light: gn[300],
      dark: gn[700]
    } : {
      main: gn[700],
      light: gn[500],
      dark: gn[900]
    };
  }
  function cm(e = "light") {
    return e === "dark" ? {
      main: vn[400],
      light: vn[300],
      dark: vn[700]
    } : {
      main: vn[800],
      light: vn[500],
      dark: vn[900]
    };
  }
  function um(e = "light") {
    return e === "dark" ? {
      main: jn[400],
      light: jn[300],
      dark: jn[700]
    } : {
      main: "#ed6c02",
      light: jn[500],
      dark: jn[900]
    };
  }
  function dm(e) {
    const { mode: t = "light", contrastThreshold: n = 3, tonalOffset: o = 0.2 } = e, r = ee(e, rm), a = e.primary || am(t), i = e.secondary || im(t), s = e.error || sm(t), l = e.info || lm(t), c = e.success || cm(t), d = e.warning || um(t);
    function p(h) {
      return qh(h, sa.text.primary) >= n ? sa.text.primary : $s.text.primary;
    }
    const m = ({ color: h, name: C, mainShade: $ = 500, lightShade: R = 300, darkShade: b = 700 }) => {
      if (h = f({}, h), !h.main && h[$] && (h.main = h[$]), !h.hasOwnProperty("main"))
        throw new Error(Mt(11, C ? ` (${C})` : "", $));
      if (typeof h.main != "string")
        throw new Error(Mt(12, C ? ` (${C})` : "", JSON.stringify(h.main)));
      return Es(h, "light", R, o), Es(h, "dark", b, o), h.contrastText || (h.contrastText = p(h.main)), h;
    }, v = {
      dark: sa,
      light: $s
    };
    return at(f({
      common: f({}, io),
      mode: t,
      primary: m({
        color: a,
        name: "primary"
      }),
      secondary: m({
        color: i,
        name: "secondary",
        mainShade: "A400",
        lightShade: "A200",
        darkShade: "A700"
      }),
      error: m({
        color: s,
        name: "error"
      }),
      warning: m({
        color: d,
        name: "warning"
      }),
      info: m({
        color: l,
        name: "info"
      }),
      success: m({
        color: c,
        name: "success"
      }),
      grey: _p,
      contrastThreshold: n,
      getContrastText: p,
      augmentColor: m,
      tonalOffset: o
    }, v[t]), r);
  }
  const pm = [
    "fontFamily",
    "fontSize",
    "fontWeightLight",
    "fontWeightRegular",
    "fontWeightMedium",
    "fontWeightBold",
    "htmlFontSize",
    "allVariants",
    "pxToRem"
  ];
  function fm(e) {
    return Math.round(e * 1e5) / 1e5;
  }
  const Ts = {
    textTransform: "uppercase"
  }, ks = '"Roboto", "Helvetica", "Arial", sans-serif';
  function hm(e, t) {
    const n = typeof t == "function" ? t(e) : t, { fontFamily: o = ks, fontSize: r = 14, fontWeightLight: a = 300, fontWeightRegular: i = 400, fontWeightMedium: s = 500, fontWeightBold: l = 700, htmlFontSize: c = 16, allVariants: d, pxToRem: p } = n, m = ee(n, pm), v = r / 14, g = p || (($) => `${$ / c * v}rem`), h = ($, R, b, y, E) => f({
      fontFamily: o,
      fontWeight: $,
      fontSize: g(R),
      lineHeight: b
    }, o === ks ? {
      letterSpacing: `${fm(y / R)}em`
    } : {}, E, d), C = {
      h1: h(a, 96, 1.167, -1.5),
      h2: h(a, 60, 1.2, -0.5),
      h3: h(i, 48, 1.167, 0),
      h4: h(i, 34, 1.235, 0.25),
      h5: h(i, 24, 1.334, 0),
      h6: h(s, 20, 1.6, 0.15),
      subtitle1: h(i, 16, 1.75, 0.15),
      subtitle2: h(s, 14, 1.57, 0.1),
      body1: h(i, 16, 1.5, 0.15),
      body2: h(i, 14, 1.43, 0.15),
      button: h(s, 14, 1.75, 0.4, Ts),
      caption: h(i, 12, 1.66, 0.4),
      overline: h(i, 12, 2.66, 1, Ts),
      inherit: {
        fontFamily: "inherit",
        fontWeight: "inherit",
        fontSize: "inherit",
        lineHeight: "inherit",
        letterSpacing: "inherit"
      }
    };
    return at(f({
      htmlFontSize: c,
      pxToRem: g,
      fontFamily: o,
      fontSize: r,
      fontWeightLight: a,
      fontWeightRegular: i,
      fontWeightMedium: s,
      fontWeightBold: l
    }, C), m, {
      clone: false
    });
  }
  const mm = 0.2, gm = 0.14, vm = 0.12;
  function Le(...e) {
    return [
      `${e[0]}px ${e[1]}px ${e[2]}px ${e[3]}px rgba(0,0,0,${mm})`,
      `${e[4]}px ${e[5]}px ${e[6]}px ${e[7]}px rgba(0,0,0,${gm})`,
      `${e[8]}px ${e[9]}px ${e[10]}px ${e[11]}px rgba(0,0,0,${vm})`
    ].join(",");
  }
  const bm = [
    "none",
    Le(0, 2, 1, -1, 0, 1, 1, 0, 0, 1, 3, 0),
    Le(0, 3, 1, -2, 0, 2, 2, 0, 0, 1, 5, 0),
    Le(0, 3, 3, -2, 0, 3, 4, 0, 0, 1, 8, 0),
    Le(0, 2, 4, -1, 0, 4, 5, 0, 0, 1, 10, 0),
    Le(0, 3, 5, -1, 0, 5, 8, 0, 0, 1, 14, 0),
    Le(0, 3, 5, -1, 0, 6, 10, 0, 0, 1, 18, 0),
    Le(0, 4, 5, -2, 0, 7, 10, 1, 0, 2, 16, 1),
    Le(0, 5, 5, -3, 0, 8, 10, 1, 0, 3, 14, 2),
    Le(0, 5, 6, -3, 0, 9, 12, 1, 0, 3, 16, 2),
    Le(0, 6, 6, -3, 0, 10, 14, 1, 0, 4, 18, 3),
    Le(0, 6, 7, -4, 0, 11, 15, 1, 0, 4, 20, 3),
    Le(0, 7, 8, -4, 0, 12, 17, 2, 0, 5, 22, 4),
    Le(0, 7, 8, -4, 0, 13, 19, 2, 0, 5, 24, 4),
    Le(0, 7, 9, -4, 0, 14, 21, 2, 0, 5, 26, 4),
    Le(0, 8, 9, -5, 0, 15, 22, 2, 0, 6, 28, 5),
    Le(0, 8, 10, -5, 0, 16, 24, 2, 0, 6, 30, 5),
    Le(0, 8, 11, -5, 0, 17, 26, 2, 0, 6, 32, 5),
    Le(0, 9, 11, -5, 0, 18, 28, 2, 0, 7, 34, 6),
    Le(0, 9, 12, -6, 0, 19, 29, 2, 0, 7, 36, 6),
    Le(0, 10, 13, -6, 0, 20, 31, 3, 0, 8, 38, 7),
    Le(0, 10, 13, -6, 0, 21, 33, 3, 0, 8, 40, 7),
    Le(0, 10, 14, -6, 0, 22, 35, 3, 0, 8, 42, 7),
    Le(0, 11, 14, -7, 0, 23, 36, 3, 0, 9, 44, 8),
    Le(0, 11, 15, -7, 0, 24, 38, 3, 0, 9, 46, 8)
  ], ym = bm, xm = [
    "duration",
    "easing",
    "delay"
  ], Sm = {
    easeInOut: "cubic-bezier(0.4, 0, 0.2, 1)",
    easeOut: "cubic-bezier(0.0, 0, 0.2, 1)",
    easeIn: "cubic-bezier(0.4, 0, 1, 1)",
    sharp: "cubic-bezier(0.4, 0, 0.6, 1)"
  }, Qc = {
    shortest: 150,
    shorter: 200,
    short: 250,
    standard: 300,
    complex: 375,
    enteringScreen: 225,
    leavingScreen: 195
  };
  function As(e) {
    return `${Math.round(e)}ms`;
  }
  function Rm(e) {
    if (!e)
      return 0;
    const t = e / 36;
    return Math.round((4 + 15 * t ** 0.25 + t / 5) * 10);
  }
  function _m(e) {
    const t = f({}, Sm, e.easing), n = f({}, Qc, e.duration);
    return f({
      getAutoHeightDuration: Rm,
      create: (r = [
        "all"
      ], a = {}) => {
        const { duration: i = n.standard, easing: s = t.easeInOut, delay: l = 0 } = a;
        return ee(a, xm), (Array.isArray(r) ? r : [
          r
        ]).map((c) => `${c} ${typeof i == "string" ? i : As(i)} ${s} ${typeof l == "string" ? l : As(l)}`).join(",");
      }
    }, e, {
      easing: t,
      duration: n
    });
  }
  const Cm = {
    mobileStepper: 1e3,
    fab: 1050,
    speedDial: 1050,
    appBar: 1100,
    drawer: 1200,
    modal: 1300,
    snackbar: 1400,
    tooltip: 1500
  }, wm = Cm, $m = [
    "breakpoints",
    "mixins",
    "spacing",
    "palette",
    "transitions",
    "typography",
    "shape"
  ];
  function bi(e = {}, ...t) {
    const { mixins: n = {}, palette: o = {}, transitions: r = {}, typography: a = {} } = e, i = ee(e, $m);
    if (e.vars && e.generateCssVars === void 0)
      throw new Error(Mt(18));
    const s = dm(o), l = ii(e);
    let c = at(l, {
      mixins: Wh(l.breakpoints, n),
      palette: s,
      shadows: ym.slice(),
      typography: hm(s, a),
      transitions: _m(r),
      zIndex: f({}, wm)
    });
    return c = at(c, i), c = t.reduce((d, p) => at(d, p), c), c.unstable_sxConfig = f({}, uo, i == null ? void 0 : i.unstable_sxConfig), c.unstable_sx = function(p) {
      return fr({
        sx: p,
        theme: this
      });
    }, c;
  }
  function Em(e) {
    return String(e).match(/[\d.\-+]*\s*(.*)/)[1] || "";
  }
  function Tm(e) {
    return parseFloat(e);
  }
  const km = bi(), yi = km;
  await M("react");
  function $r() {
    const e = li(yi);
    return e[Cn] || e;
  }
  var ho = {};
  const Am = Ct(lp);
  var la = {
    exports: {}
  }, Ms;
  function Mm() {
    return Ms || (Ms = 1, function(e) {
      function t(n, o) {
        if (n == null)
          return {};
        var r = {};
        for (var a in n)
          if ({}.hasOwnProperty.call(n, a)) {
            if (o.indexOf(a) !== -1)
              continue;
            r[a] = n[a];
          }
        return r;
      }
      e.exports = t, e.exports.__esModule = true, e.exports.default = e.exports;
    }(la)), la.exports;
  }
  const Pm = Ct(zp), Lm = Ct(Vp), Im = Ct(Gp), Nm = Ct(eh), Fm = Ct(Of), Om = Ct(Uf);
  var In = He;
  Object.defineProperty(ho, "__esModule", {
    value: true
  });
  var Bm = ho.default = Zm;
  ho.shouldForwardProp = Vo;
  ho.systemDefaultTheme = void 0;
  var lt = In(Am), Da = In(Mm()), Jo = Hm(Pm), Dm = Lm;
  In(Im);
  In(Nm);
  var jm = In(Fm), zm = In(Om);
  const Vm = [
    "ownerState"
  ], Um = [
    "variants"
  ], Wm = [
    "name",
    "slot",
    "skipVariantsResolver",
    "skipSx",
    "overridesResolver"
  ];
  function eu(e) {
    if (typeof WeakMap != "function")
      return null;
    var t = /* @__PURE__ */ new WeakMap(), n = /* @__PURE__ */ new WeakMap();
    return (eu = function(o) {
      return o ? n : t;
    })(e);
  }
  function Hm(e, t) {
    if (!t && e && e.__esModule)
      return e;
    if (e === null || typeof e != "object" && typeof e != "function")
      return {
        default: e
      };
    var n = eu(t);
    if (n && n.has(e))
      return n.get(e);
    var o = {
      __proto__: null
    }, r = Object.defineProperty && Object.getOwnPropertyDescriptor;
    for (var a in e)
      if (a !== "default" && Object.prototype.hasOwnProperty.call(e, a)) {
        var i = r ? Object.getOwnPropertyDescriptor(e, a) : null;
        i && (i.get || i.set) ? Object.defineProperty(o, a, i) : o[a] = e[a];
      }
    return o.default = e, n && n.set(e, o), o;
  }
  function Km(e) {
    return Object.keys(e).length === 0;
  }
  function qm(e) {
    return typeof e == "string" && e.charCodeAt(0) > 96;
  }
  function Vo(e) {
    return e !== "ownerState" && e !== "theme" && e !== "sx" && e !== "as";
  }
  function Ps(e, t) {
    return t && e && typeof e == "object" && e.styles && !e.styles.startsWith("@layer") && (e.styles = `@layer ${t}{${String(e.styles)}}`), e;
  }
  const Gm = ho.systemDefaultTheme = (0, jm.default)(), Ym = (e) => e && e.charAt(0).toLowerCase() + e.slice(1);
  function wo({ defaultTheme: e, theme: t, themeId: n }) {
    return Km(t) ? e : t[n] || t;
  }
  function Xm(e) {
    return e ? (t, n) => n[e] : null;
  }
  function Uo(e, t, n) {
    let { ownerState: o } = t, r = (0, Da.default)(t, Vm);
    const a = typeof e == "function" ? e((0, lt.default)({
      ownerState: o
    }, r)) : e;
    if (Array.isArray(a))
      return a.flatMap((i) => Uo(i, (0, lt.default)({
        ownerState: o
      }, r), n));
    if (a && typeof a == "object" && Array.isArray(a.variants)) {
      const { variants: i = [] } = a;
      let l = (0, Da.default)(a, Um);
      return i.forEach((c) => {
        let d = true;
        if (typeof c.props == "function" ? d = c.props((0, lt.default)({
          ownerState: o
        }, r, o)) : Object.keys(c.props).forEach((p) => {
          (o == null ? void 0 : o[p]) !== c.props[p] && r[p] !== c.props[p] && (d = false);
        }), d) {
          Array.isArray(l) || (l = [
            l
          ]);
          const p = typeof c.style == "function" ? c.style((0, lt.default)({
            ownerState: o
          }, r, o)) : c.style;
          l.push(n ? Ps((0, Jo.internal_serializeStyles)(p), n) : p);
        }
      }), l;
    }
    return n ? Ps((0, Jo.internal_serializeStyles)(a), n) : a;
  }
  function Zm(e = {}) {
    const { themeId: t, defaultTheme: n = Gm, rootShouldForwardProp: o = Vo, slotShouldForwardProp: r = Vo } = e, a = (i) => (0, zm.default)((0, lt.default)({}, i, {
      theme: wo((0, lt.default)({}, i, {
        defaultTheme: n,
        themeId: t
      }))
    }));
    return a.__mui_systemSx = true, (i, s = {}) => {
      (0, Jo.internal_processStyles)(i, (w) => w.filter((T) => !(T != null && T.__mui_systemSx)));
      const { name: l, slot: c, skipVariantsResolver: d, skipSx: p, overridesResolver: m = Xm(Ym(c)) } = s, v = (0, Da.default)(s, Wm), g = l && l.startsWith("Mui") || c ? "components" : "custom", h = d !== void 0 ? d : c && c !== "Root" && c !== "root" || false, C = p || false;
      let $, R = Vo;
      c === "Root" || c === "root" ? R = o : c ? R = r : qm(i) && (R = void 0);
      const b = (0, Jo.default)(i, (0, lt.default)({
        shouldForwardProp: R,
        label: $
      }, v)), y = (w) => typeof w == "function" && w.__emotion_real !== w || (0, Dm.isPlainObject)(w) ? (T) => {
        const I = wo({
          theme: T.theme,
          defaultTheme: n,
          themeId: t
        });
        return Uo(w, (0, lt.default)({}, T, {
          theme: I
        }), I.modularCssLayers ? g : void 0);
      } : w, E = (w, ...T) => {
        let I = y(w);
        const V = T ? T.map(y) : [];
        l && m && V.push((F) => {
          const O = wo((0, lt.default)({}, F, {
            defaultTheme: n,
            themeId: t
          }));
          if (!O.components || !O.components[l] || !O.components[l].styleOverrides)
            return null;
          const B = O.components[l].styleOverrides, j = {};
          return Object.entries(B).forEach(([W, H]) => {
            j[W] = Uo(H, (0, lt.default)({}, F, {
              theme: O
            }), O.modularCssLayers ? "theme" : void 0);
          }), m(F, j);
        }), l && !h && V.push((F) => {
          var O;
          const B = wo((0, lt.default)({}, F, {
            defaultTheme: n,
            themeId: t
          })), j = B == null || (O = B.components) == null || (O = O[l]) == null ? void 0 : O.variants;
          return Uo({
            variants: j
          }, (0, lt.default)({}, F, {
            theme: B
          }), B.modularCssLayers ? "theme" : void 0);
        }), C || V.push(a);
        const P = V.length - T.length;
        if (Array.isArray(w) && P > 0) {
          const F = new Array(P).fill("");
          I = [
            ...w,
            ...F
          ], I.raw = [
            ...w.raw,
            ...F
          ];
        }
        const U = b(I, ...V);
        return i.muiName && (U.muiName = i.muiName), U;
      };
      return b.withConfig && (E.withConfig = b.withConfig), E;
    };
  }
  function tu(e) {
    return e !== "ownerState" && e !== "theme" && e !== "sx" && e !== "as";
  }
  const Jm = (e) => tu(e) && e !== "classes", xt = Jm, Qm = Bm({
    themeId: Cn,
    defaultTheme: yi,
    rootShouldForwardProp: xt
  }), G = Qm, eg = [
    "theme"
  ];
  await M("react");
  function tg(e) {
    let { theme: t } = e, n = ee(e, eg);
    const o = t[Cn];
    let r = o || t;
    return typeof t != "function" && (o && !o.vars ? r = f({}, o, {
      vars: null
    }) : t && !t.vars && (r = f({}, t, {
      vars: null
    }))), u.jsx(Uh, f({}, n, {
      themeId: o ? Cn : void 0,
      theme: r
    }));
  }
  const ng = (e) => {
    let t;
    return e < 1 ? t = 5.11916 * e ** 2 : t = 4.5 * Math.log(e + 1) + 2, (t / 100).toFixed(2);
  }, Ls = ng;
  await M("react");
  function Re(e) {
    return jh(e);
  }
  function og(e) {
    return xe("MuiSvgIcon", e);
  }
  ye("MuiSvgIcon", [
    "root",
    "colorPrimary",
    "colorSecondary",
    "colorAction",
    "colorError",
    "colorDisabled",
    "fontSizeInherit",
    "fontSizeSmall",
    "fontSizeMedium",
    "fontSizeLarge"
  ]);
  const rg = [
    "children",
    "className",
    "color",
    "component",
    "fontSize",
    "htmlColor",
    "inheritViewBox",
    "titleAccess",
    "viewBox"
  ], Is = await M("react"), ag = (e) => {
    const { color: t, fontSize: n, classes: o } = e, r = {
      root: [
        "root",
        t !== "inherit" && `color${oe(t)}`,
        `fontSize${oe(n)}`
      ]
    };
    return Se(r, og, o);
  }, ig = G("svg", {
    name: "MuiSvgIcon",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        n.color !== "inherit" && t[`color${oe(n.color)}`],
        t[`fontSize${oe(n.fontSize)}`]
      ];
    }
  })(({ theme: e, ownerState: t }) => {
    var n, o, r, a, i, s, l, c, d, p, m, v, g;
    return {
      userSelect: "none",
      width: "1em",
      height: "1em",
      display: "inline-block",
      fill: t.hasSvgAsChild ? void 0 : "currentColor",
      flexShrink: 0,
      transition: (n = e.transitions) == null || (o = n.create) == null ? void 0 : o.call(n, "fill", {
        duration: (r = e.transitions) == null || (r = r.duration) == null ? void 0 : r.shorter
      }),
      fontSize: {
        inherit: "inherit",
        small: ((a = e.typography) == null || (i = a.pxToRem) == null ? void 0 : i.call(a, 20)) || "1.25rem",
        medium: ((s = e.typography) == null || (l = s.pxToRem) == null ? void 0 : l.call(s, 24)) || "1.5rem",
        large: ((c = e.typography) == null || (d = c.pxToRem) == null ? void 0 : d.call(c, 35)) || "2.1875rem"
      }[t.fontSize],
      color: (p = (m = (e.vars || e).palette) == null || (m = m[t.color]) == null ? void 0 : m.main) != null ? p : {
        action: (v = (e.vars || e).palette) == null || (v = v.action) == null ? void 0 : v.active,
        disabled: (g = (e.vars || e).palette) == null || (g = g.action) == null ? void 0 : g.disabled,
        inherit: void 0
      }[t.color]
    };
  }), nu = Is.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiSvgIcon"
    }), { children: r, className: a, color: i = "inherit", component: s = "svg", fontSize: l = "medium", htmlColor: c, inheritViewBox: d = false, titleAccess: p, viewBox: m = "0 0 24 24" } = o, v = ee(o, rg), g = Is.isValidElement(r) && r.type === "svg", h = f({}, o, {
      color: i,
      component: s,
      fontSize: l,
      instanceFontSize: t.fontSize,
      inheritViewBox: d,
      viewBox: m,
      hasSvgAsChild: g
    }), C = {};
    d || (C.viewBox = m);
    const $ = ag(h);
    return u.jsxs(ig, f({
      as: s,
      className: ae($.root, a),
      focusable: "false",
      color: c,
      "aria-hidden": p ? void 0 : true,
      role: p ? "img" : void 0,
      ref: n
    }, C, v, g && r.props, {
      ownerState: h,
      children: [
        g ? r.props.children : r,
        p ? u.jsx("title", {
          children: p
        }) : null
      ]
    }));
  });
  nu.muiName = "SvgIcon";
  const ja = nu, Ns = await M("react");
  function It(e, t) {
    function n(o, r) {
      return u.jsx(ja, f({
        "data-testid": `${t}Icon`,
        ref: r
      }, o, {
        children: e
      }));
    }
    return n.muiName = ja.muiName, Ns.memo(Ns.forwardRef(n));
  }
  const sg = {
    configure: (e) => {
      ui.configure(e);
    }
  }, lg = Object.freeze(Object.defineProperty({
    __proto__: null,
    capitalize: oe,
    createChainedFunction: La,
    createSvgIcon: It,
    debounce: fi,
    deprecatedPropType: sh,
    isMuiElement: zo,
    ownerDocument: Xe,
    ownerWindow: qt,
    requirePropFactory: ch,
    setRef: Yo,
    unstable_ClassNameGenerator: sg,
    unstable_useEnhancedEffect: Lt,
    unstable_useId: po,
    unsupportedProp: dh,
    useControlled: Na,
    useEventCallback: Wt,
    useForkRef: Ve,
    useIsFocusVisible: Ic
  }, Symbol.toStringTag, {
    value: "Module"
  })), Fs = {
    disabled: false
  }, cg = await M("react"), Qo = cg.createContext(null);
  var ug = function(t) {
    return t.scrollTop;
  };
  const $o = await M("react"), Eo = await M("react-dom");
  var Zn = "unmounted", nn = "exited", on = "entering", Sn = "entered", za = "exiting", Nt = function(e) {
    hc(t, e);
    function t(o, r) {
      var a;
      a = e.call(this, o, r) || this;
      var i = r, s = i && !i.isMounting ? o.enter : o.appear, l;
      return a.appearStatus = null, o.in ? s ? (l = nn, a.appearStatus = on) : l = Sn : o.unmountOnExit || o.mountOnEnter ? l = Zn : l = nn, a.state = {
        status: l
      }, a.nextCallback = null, a;
    }
    t.getDerivedStateFromProps = function(r, a) {
      var i = r.in;
      return i && a.status === Zn ? {
        status: nn
      } : null;
    };
    var n = t.prototype;
    return n.componentDidMount = function() {
      this.updateStatus(true, this.appearStatus);
    }, n.componentDidUpdate = function(r) {
      var a = null;
      if (r !== this.props) {
        var i = this.state.status;
        this.props.in ? i !== on && i !== Sn && (a = on) : (i === on || i === Sn) && (a = za);
      }
      this.updateStatus(false, a);
    }, n.componentWillUnmount = function() {
      this.cancelNextCallback();
    }, n.getTimeouts = function() {
      var r = this.props.timeout, a, i, s;
      return a = i = s = r, r != null && typeof r != "number" && (a = r.exit, i = r.enter, s = r.appear !== void 0 ? r.appear : i), {
        exit: a,
        enter: i,
        appear: s
      };
    }, n.updateStatus = function(r, a) {
      if (r === void 0 && (r = false), a !== null)
        if (this.cancelNextCallback(), a === on) {
          if (this.props.unmountOnExit || this.props.mountOnEnter) {
            var i = this.props.nodeRef ? this.props.nodeRef.current : Eo.findDOMNode(this);
            i && ug(i);
          }
          this.performEnter(r);
        } else
          this.performExit();
      else
        this.props.unmountOnExit && this.state.status === nn && this.setState({
          status: Zn
        });
    }, n.performEnter = function(r) {
      var a = this, i = this.props.enter, s = this.context ? this.context.isMounting : r, l = this.props.nodeRef ? [
        s
      ] : [
        Eo.findDOMNode(this),
        s
      ], c = l[0], d = l[1], p = this.getTimeouts(), m = s ? p.appear : p.enter;
      if (!r && !i || Fs.disabled) {
        this.safeSetState({
          status: Sn
        }, function() {
          a.props.onEntered(c);
        });
        return;
      }
      this.props.onEnter(c, d), this.safeSetState({
        status: on
      }, function() {
        a.props.onEntering(c, d), a.onTransitionEnd(m, function() {
          a.safeSetState({
            status: Sn
          }, function() {
            a.props.onEntered(c, d);
          });
        });
      });
    }, n.performExit = function() {
      var r = this, a = this.props.exit, i = this.getTimeouts(), s = this.props.nodeRef ? void 0 : Eo.findDOMNode(this);
      if (!a || Fs.disabled) {
        this.safeSetState({
          status: nn
        }, function() {
          r.props.onExited(s);
        });
        return;
      }
      this.props.onExit(s), this.safeSetState({
        status: za
      }, function() {
        r.props.onExiting(s), r.onTransitionEnd(i.exit, function() {
          r.safeSetState({
            status: nn
          }, function() {
            r.props.onExited(s);
          });
        });
      });
    }, n.cancelNextCallback = function() {
      this.nextCallback !== null && (this.nextCallback.cancel(), this.nextCallback = null);
    }, n.safeSetState = function(r, a) {
      a = this.setNextCallback(a), this.setState(r, a);
    }, n.setNextCallback = function(r) {
      var a = this, i = true;
      return this.nextCallback = function(s) {
        i && (i = false, a.nextCallback = null, r(s));
      }, this.nextCallback.cancel = function() {
        i = false;
      }, this.nextCallback;
    }, n.onTransitionEnd = function(r, a) {
      this.setNextCallback(a);
      var i = this.props.nodeRef ? this.props.nodeRef.current : Eo.findDOMNode(this), s = r == null && !this.props.addEndListener;
      if (!i || s) {
        setTimeout(this.nextCallback, 0);
        return;
      }
      if (this.props.addEndListener) {
        var l = this.props.nodeRef ? [
          this.nextCallback
        ] : [
          i,
          this.nextCallback
        ], c = l[0], d = l[1];
        this.props.addEndListener(c, d);
      }
      r != null && setTimeout(this.nextCallback, r);
    }, n.render = function() {
      var r = this.state.status;
      if (r === Zn)
        return null;
      var a = this.props, i = a.children;
      a.in, a.mountOnEnter, a.unmountOnExit, a.appear, a.enter, a.exit, a.timeout, a.addEndListener, a.onEnter, a.onEntering, a.onEntered, a.onExit, a.onExiting, a.onExited, a.nodeRef;
      var s = ee(a, [
        "children",
        "in",
        "mountOnEnter",
        "unmountOnExit",
        "appear",
        "enter",
        "exit",
        "timeout",
        "addEndListener",
        "onEnter",
        "onEntering",
        "onEntered",
        "onExit",
        "onExiting",
        "onExited",
        "nodeRef"
      ]);
      return $o.createElement(Qo.Provider, {
        value: null
      }, typeof i == "function" ? i(r, s) : $o.cloneElement($o.Children.only(i), s));
    }, t;
  }($o.Component);
  Nt.contextType = Qo;
  Nt.propTypes = {};
  function bn() {
  }
  Nt.defaultProps = {
    in: false,
    mountOnEnter: false,
    unmountOnExit: false,
    appear: false,
    enter: true,
    exit: true,
    onEnter: bn,
    onEntering: bn,
    onEntered: bn,
    onExit: bn,
    onExiting: bn,
    onExited: bn
  };
  Nt.UNMOUNTED = Zn;
  Nt.EXITED = nn;
  Nt.ENTERING = on;
  Nt.ENTERED = Sn;
  Nt.EXITING = za;
  const xi = Nt;
  function dg(e) {
    if (e === void 0)
      throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    return e;
  }
  const { Children: pg, cloneElement: Wo, isValidElement: Ho } = await M("react");
  function Si(e, t) {
    var n = function(a) {
      return t && Ho(a) ? t(a) : a;
    }, o = /* @__PURE__ */ Object.create(null);
    return e && pg.map(e, function(r) {
      return r;
    }).forEach(function(r) {
      o[r.key] = n(r);
    }), o;
  }
  function fg(e, t) {
    e = e || {}, t = t || {};
    function n(d) {
      return d in t ? t[d] : e[d];
    }
    var o = /* @__PURE__ */ Object.create(null), r = [];
    for (var a in e)
      a in t ? r.length && (o[a] = r, r = []) : r.push(a);
    var i, s = {};
    for (var l in t) {
      if (o[l])
        for (i = 0; i < o[l].length; i++) {
          var c = o[l][i];
          s[o[l][i]] = n(c);
        }
      s[l] = n(l);
    }
    for (i = 0; i < r.length; i++)
      s[r[i]] = n(r[i]);
    return s;
  }
  function an(e, t, n) {
    return n[t] != null ? n[t] : e.props[t];
  }
  function hg(e, t) {
    return Si(e.children, function(n) {
      return Wo(n, {
        onExited: t.bind(null, n),
        in: true,
        appear: an(n, "appear", e),
        enter: an(n, "enter", e),
        exit: an(n, "exit", e)
      });
    });
  }
  function mg(e, t, n) {
    var o = Si(e.children), r = fg(t, o);
    return Object.keys(r).forEach(function(a) {
      var i = r[a];
      if (Ho(i)) {
        var s = a in t, l = a in o, c = t[a], d = Ho(c) && !c.props.in;
        l && (!s || d) ? r[a] = Wo(i, {
          onExited: n.bind(null, i),
          in: true,
          exit: an(i, "exit", e),
          enter: an(i, "enter", e)
        }) : !l && s && !d ? r[a] = Wo(i, {
          in: false
        }) : l && s && Ho(c) && (r[a] = Wo(i, {
          onExited: n.bind(null, i),
          in: c.props.in,
          exit: an(i, "exit", e),
          enter: an(i, "enter", e)
        }));
      }
    }), r;
  }
  const To = await M("react");
  var gg = Object.values || function(e) {
    return Object.keys(e).map(function(t) {
      return e[t];
    });
  }, vg = {
    component: "div",
    childFactory: function(t) {
      return t;
    }
  }, Ri = function(e) {
    hc(t, e);
    function t(o, r) {
      var a;
      a = e.call(this, o, r) || this;
      var i = a.handleExited.bind(dg(a));
      return a.state = {
        contextValue: {
          isMounting: true
        },
        handleExited: i,
        firstRender: true
      }, a;
    }
    var n = t.prototype;
    return n.componentDidMount = function() {
      this.mounted = true, this.setState({
        contextValue: {
          isMounting: false
        }
      });
    }, n.componentWillUnmount = function() {
      this.mounted = false;
    }, t.getDerivedStateFromProps = function(r, a) {
      var i = a.children, s = a.handleExited, l = a.firstRender;
      return {
        children: l ? hg(r, s) : mg(r, i, s),
        firstRender: false
      };
    }, n.handleExited = function(r, a) {
      var i = Si(this.props.children);
      r.key in i || (r.props.onExited && r.props.onExited(a), this.mounted && this.setState(function(s) {
        var l = f({}, s.children);
        return delete l[r.key], {
          children: l
        };
      }));
    }, n.render = function() {
      var r = this.props, a = r.component, i = r.childFactory, s = ee(r, [
        "component",
        "childFactory"
      ]), l = this.state.contextValue, c = gg(this.state.children).map(i);
      return delete s.appear, delete s.enter, delete s.exit, a === null ? To.createElement(Qo.Provider, {
        value: l
      }, c) : To.createElement(Qo.Provider, {
        value: l
      }, To.createElement(a, s, c));
    }, t;
  }(To.Component);
  Ri.propTypes = {};
  Ri.defaultProps = vg;
  const bg = Ri, ou = (e) => e.scrollTop;
  function $n(e, t) {
    var n, o;
    const { timeout: r, easing: a, style: i = {} } = e;
    return {
      duration: (n = i.transitionDuration) != null ? n : typeof r == "number" ? r : r[t.mode] || 0,
      easing: (o = i.transitionTimingFunction) != null ? o : typeof a == "object" ? a[t.mode] : a,
      delay: i.transitionDelay
    };
  }
  function yg(e) {
    return xe("MuiCollapse", e);
  }
  ye("MuiCollapse", [
    "root",
    "horizontal",
    "vertical",
    "entered",
    "hidden",
    "wrapper",
    "wrapperInner"
  ]);
  const xg = [
    "addEndListener",
    "children",
    "className",
    "collapsedSize",
    "component",
    "easing",
    "in",
    "onEnter",
    "onEntered",
    "onEntering",
    "onExit",
    "onExited",
    "onExiting",
    "orientation",
    "style",
    "timeout",
    "TransitionComponent"
  ], ko = await M("react"), Sg = (e) => {
    const { orientation: t, classes: n } = e, o = {
      root: [
        "root",
        `${t}`
      ],
      entered: [
        "entered"
      ],
      hidden: [
        "hidden"
      ],
      wrapper: [
        "wrapper",
        `${t}`
      ],
      wrapperInner: [
        "wrapperInner",
        `${t}`
      ]
    };
    return Se(o, yg, n);
  }, Rg = G("div", {
    name: "MuiCollapse",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.orientation],
        n.state === "entered" && t.entered,
        n.state === "exited" && !n.in && n.collapsedSize === "0px" && t.hidden
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    height: 0,
    overflow: "hidden",
    transition: e.transitions.create("height")
  }, t.orientation === "horizontal" && {
    height: "auto",
    width: 0,
    transition: e.transitions.create("width")
  }, t.state === "entered" && f({
    height: "auto",
    overflow: "visible"
  }, t.orientation === "horizontal" && {
    width: "auto"
  }), t.state === "exited" && !t.in && t.collapsedSize === "0px" && {
    visibility: "hidden"
  })), _g = G("div", {
    name: "MuiCollapse",
    slot: "Wrapper",
    overridesResolver: (e, t) => t.wrapper
  })(({ ownerState: e }) => f({
    display: "flex",
    width: "100%"
  }, e.orientation === "horizontal" && {
    width: "auto",
    height: "100%"
  })), Cg = G("div", {
    name: "MuiCollapse",
    slot: "WrapperInner",
    overridesResolver: (e, t) => t.wrapperInner
  })(({ ownerState: e }) => f({
    width: "100%"
  }, e.orientation === "horizontal" && {
    width: "auto",
    height: "100%"
  })), ru = ko.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiCollapse"
    }), { addEndListener: r, children: a, className: i, collapsedSize: s = "0px", component: l, easing: c, in: d, onEnter: p, onEntered: m, onEntering: v, onExit: g, onExited: h, onExiting: C, orientation: $ = "vertical", style: R, timeout: b = Qc.standard, TransitionComponent: y = xi } = o, E = ee(o, xg), w = f({}, o, {
      orientation: $,
      collapsedSize: s
    }), T = Sg(w), I = $r(), V = hi(), P = ko.useRef(null), U = ko.useRef(), F = typeof s == "number" ? `${s}px` : s, O = $ === "horizontal", B = O ? "width" : "height", j = ko.useRef(null), W = Ve(n, j), H = (k) => (Z) => {
      if (k) {
        const Q = j.current;
        Z === void 0 ? k(Q) : k(Q, Z);
      }
    }, D = () => P.current ? P.current[O ? "clientWidth" : "clientHeight"] : 0, me = H((k, Z) => {
      P.current && O && (P.current.style.position = "absolute"), k.style[B] = F, p && p(k, Z);
    }), ne = H((k, Z) => {
      const Q = D();
      P.current && O && (P.current.style.position = "");
      const { duration: z, easing: fe } = $n({
        style: R,
        timeout: b,
        easing: c
      }, {
        mode: "enter"
      });
      if (b === "auto") {
        const re = I.transitions.getAutoHeightDuration(Q);
        k.style.transitionDuration = `${re}ms`, U.current = re;
      } else
        k.style.transitionDuration = typeof z == "string" ? z : `${z}ms`;
      k.style[B] = `${Q}px`, k.style.transitionTimingFunction = fe, v && v(k, Z);
    }), de = H((k, Z) => {
      k.style[B] = "auto", m && m(k, Z);
    }), _ = H((k) => {
      k.style[B] = `${D()}px`, g && g(k);
    }), L = H(h), A = H((k) => {
      const Z = D(), { duration: Q, easing: z } = $n({
        style: R,
        timeout: b,
        easing: c
      }, {
        mode: "exit"
      });
      if (b === "auto") {
        const fe = I.transitions.getAutoHeightDuration(Z);
        k.style.transitionDuration = `${fe}ms`, U.current = fe;
      } else
        k.style.transitionDuration = typeof Q == "string" ? Q : `${Q}ms`;
      k.style[B] = F, k.style.transitionTimingFunction = z, C && C(k);
    }), Y = (k) => {
      b === "auto" && V.start(U.current || 0, k), r && r(j.current, k);
    };
    return u.jsx(y, f({
      in: d,
      onEnter: me,
      onEntered: de,
      onEntering: ne,
      onExit: _,
      onExited: L,
      onExiting: A,
      addEndListener: Y,
      nodeRef: j,
      timeout: b === "auto" ? null : b
    }, E, {
      children: (k, Z) => u.jsx(Rg, f({
        as: l,
        className: ae(T.root, i, {
          entered: T.entered,
          exited: !d && F === "0px" && T.hidden
        }[k]),
        style: f({
          [O ? "minWidth" : "minHeight"]: F
        }, R),
        ref: W
      }, Z, {
        ownerState: f({}, w, {
          state: k
        }),
        children: u.jsx(_g, {
          ownerState: f({}, w, {
            state: k
          }),
          className: T.wrapper,
          ref: P,
          children: u.jsx(Cg, {
            ownerState: f({}, w, {
              state: k
            }),
            className: T.wrapperInner,
            children: a
          })
        })
      }))
    }));
  });
  ru.muiSupportAuto = true;
  const wg = ru;
  function $g(e) {
    return xe("MuiPaper", e);
  }
  ye("MuiPaper", [
    "root",
    "rounded",
    "outlined",
    "elevation",
    "elevation0",
    "elevation1",
    "elevation2",
    "elevation3",
    "elevation4",
    "elevation5",
    "elevation6",
    "elevation7",
    "elevation8",
    "elevation9",
    "elevation10",
    "elevation11",
    "elevation12",
    "elevation13",
    "elevation14",
    "elevation15",
    "elevation16",
    "elevation17",
    "elevation18",
    "elevation19",
    "elevation20",
    "elevation21",
    "elevation22",
    "elevation23",
    "elevation24"
  ]);
  const Eg = [
    "className",
    "component",
    "elevation",
    "square",
    "variant"
  ], Tg = await M("react"), kg = (e) => {
    const { square: t, elevation: n, variant: o, classes: r } = e, a = {
      root: [
        "root",
        o,
        !t && "rounded",
        o === "elevation" && `elevation${n}`
      ]
    };
    return Se(a, $g, r);
  }, Ag = G("div", {
    name: "MuiPaper",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.variant],
        !n.square && t.rounded,
        n.variant === "elevation" && t[`elevation${n.elevation}`]
      ];
    }
  })(({ theme: e, ownerState: t }) => {
    var n;
    return f({
      backgroundColor: (e.vars || e).palette.background.paper,
      color: (e.vars || e).palette.text.primary,
      transition: e.transitions.create("box-shadow")
    }, !t.square && {
      borderRadius: e.shape.borderRadius
    }, t.variant === "outlined" && {
      border: `1px solid ${(e.vars || e).palette.divider}`
    }, t.variant === "elevation" && f({
      boxShadow: (e.vars || e).shadows[t.elevation]
    }, !e.vars && e.palette.mode === "dark" && {
      backgroundImage: `linear-gradient(${Ht("#fff", Ls(t.elevation))}, ${Ht("#fff", Ls(t.elevation))})`
    }, e.vars && {
      backgroundImage: (n = e.vars.overlays) == null ? void 0 : n[t.elevation]
    }));
  }), Mg = Tg.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiPaper"
    }), { className: r, component: a = "div", elevation: i = 1, square: s = false, variant: l = "elevation" } = o, c = ee(o, Eg), d = f({}, o, {
      component: a,
      elevation: i,
      square: s,
      variant: l
    }), p = kg(d);
    return u.jsx(Ag, f({
      as: a,
      ownerState: d,
      className: ae(p.root, r),
      ref: n
    }, c));
  }), Er = Mg, Pg = [
    "className",
    "elementType",
    "ownerState",
    "externalForwardedProps",
    "getSlotOwnerState",
    "internalForwardedProps"
  ], Lg = [
    "component",
    "slots",
    "slotProps"
  ], Ig = [
    "component"
  ];
  function Os(e, t) {
    const { className: n, elementType: o, ownerState: r, externalForwardedProps: a, getSlotOwnerState: i, internalForwardedProps: s } = t, l = ee(t, Pg), { component: c, slots: d = {
      [e]: void 0
    }, slotProps: p = {
      [e]: void 0
    } } = a, m = ee(a, Lg), v = d[e] || o, g = Dc(p[e], r), h = Bc(f({
      className: n
    }, l, {
      externalForwardedProps: e === "root" ? m : void 0,
      externalSlotProps: g
    })), { props: { component: C }, internalRef: $ } = h, R = ee(h.props, Ig), b = Ve($, g == null ? void 0 : g.ref, t.ref), y = i ? i(R) : {}, E = f({}, r, y), w = e === "root" ? C || c : C, T = Fc(v, f({}, e === "root" && !c && !d[e] && s, e !== "root" && !d[e] && s, R, w && {
      as: w
    }, {
      ref: b
    }), E);
    return Object.keys(y).forEach((I) => {
      delete T[I];
    }), [
      v,
      T
    ];
  }
  const Bs = await M("react");
  function Ng(e) {
    const { className: t, classes: n, pulsate: o = false, rippleX: r, rippleY: a, rippleSize: i, in: s, onExited: l, timeout: c } = e, [d, p] = Bs.useState(false), m = ae(t, n.ripple, n.rippleVisible, o && n.ripplePulsate), v = {
      width: i,
      height: i,
      top: -(i / 2) + a,
      left: -(i / 2) + r
    }, g = ae(n.child, d && n.childLeaving, o && n.childPulsate);
    return !s && !d && p(true), Bs.useEffect(() => {
      if (!s && l != null) {
        const h = setTimeout(l, c);
        return () => {
          clearTimeout(h);
        };
      }
    }, [
      l,
      s,
      c
    ]), u.jsx("span", {
      className: m,
      style: v,
      children: u.jsx("span", {
        className: g
      })
    });
  }
  const Fg = ye("MuiTouchRipple", [
    "root",
    "ripple",
    "rippleVisible",
    "ripplePulsate",
    "child",
    "childLeaving",
    "childPulsate"
  ]), ct = Fg, Og = [
    "center",
    "classes",
    "className"
  ];
  let Tr = (e) => e, Ds, js, zs, Vs;
  const tt = await M("react"), Va = 550, Bg = 80, Dg = Gt(Ds || (Ds = Tr`
  0% {
    transform: scale(0);
    opacity: 0.1;
  }

  100% {
    transform: scale(1);
    opacity: 0.3;
  }
`)), jg = Gt(js || (js = Tr`
  0% {
    opacity: 1;
  }

  100% {
    opacity: 0;
  }
`)), zg = Gt(zs || (zs = Tr`
  0% {
    transform: scale(1);
  }

  50% {
    transform: scale(0.92);
  }

  100% {
    transform: scale(1);
  }
`)), Vg = G("span", {
    name: "MuiTouchRipple",
    slot: "Root"
  })({
    overflow: "hidden",
    pointerEvents: "none",
    position: "absolute",
    zIndex: 0,
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    borderRadius: "inherit"
  }), Ug = G(Ng, {
    name: "MuiTouchRipple",
    slot: "Ripple"
  })(Vs || (Vs = Tr`
  opacity: 0;
  position: absolute;

  &.${0} {
    opacity: 0.3;
    transform: scale(1);
    animation-name: ${0};
    animation-duration: ${0}ms;
    animation-timing-function: ${0};
  }

  &.${0} {
    animation-duration: ${0}ms;
  }

  & .${0} {
    opacity: 1;
    display: block;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background-color: currentColor;
  }

  & .${0} {
    opacity: 0;
    animation-name: ${0};
    animation-duration: ${0}ms;
    animation-timing-function: ${0};
  }

  & .${0} {
    position: absolute;
    /* @noflip */
    left: 0px;
    top: 0;
    animation-name: ${0};
    animation-duration: 2500ms;
    animation-timing-function: ${0};
    animation-iteration-count: infinite;
    animation-delay: 200ms;
  }
`), ct.rippleVisible, Dg, Va, ({ theme: e }) => e.transitions.easing.easeInOut, ct.ripplePulsate, ({ theme: e }) => e.transitions.duration.shorter, ct.child, ct.childLeaving, jg, Va, ({ theme: e }) => e.transitions.easing.easeInOut, ct.childPulsate, zg, ({ theme: e }) => e.transitions.easing.easeInOut), Wg = tt.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiTouchRipple"
    }), { center: r = false, classes: a = {}, className: i } = o, s = ee(o, Og), [l, c] = tt.useState([]), d = tt.useRef(0), p = tt.useRef(null);
    tt.useEffect(() => {
      p.current && (p.current(), p.current = null);
    }, [
      l
    ]);
    const m = tt.useRef(false), v = hi(), g = tt.useRef(null), h = tt.useRef(null), C = tt.useCallback((y) => {
      const { pulsate: E, rippleX: w, rippleY: T, rippleSize: I, cb: V } = y;
      c((P) => [
        ...P,
        u.jsx(Ug, {
          classes: {
            ripple: ae(a.ripple, ct.ripple),
            rippleVisible: ae(a.rippleVisible, ct.rippleVisible),
            ripplePulsate: ae(a.ripplePulsate, ct.ripplePulsate),
            child: ae(a.child, ct.child),
            childLeaving: ae(a.childLeaving, ct.childLeaving),
            childPulsate: ae(a.childPulsate, ct.childPulsate)
          },
          timeout: Va,
          pulsate: E,
          rippleX: w,
          rippleY: T,
          rippleSize: I
        }, d.current)
      ]), d.current += 1, p.current = V;
    }, [
      a
    ]), $ = tt.useCallback((y = {}, E = {}, w = () => {
    }) => {
      const { pulsate: T = false, center: I = r || E.pulsate, fakeElement: V = false } = E;
      if ((y == null ? void 0 : y.type) === "mousedown" && m.current) {
        m.current = false;
        return;
      }
      (y == null ? void 0 : y.type) === "touchstart" && (m.current = true);
      const P = V ? null : h.current, U = P ? P.getBoundingClientRect() : {
        width: 0,
        height: 0,
        left: 0,
        top: 0
      };
      let F, O, B;
      if (I || y === void 0 || y.clientX === 0 && y.clientY === 0 || !y.clientX && !y.touches)
        F = Math.round(U.width / 2), O = Math.round(U.height / 2);
      else {
        const { clientX: j, clientY: W } = y.touches && y.touches.length > 0 ? y.touches[0] : y;
        F = Math.round(j - U.left), O = Math.round(W - U.top);
      }
      if (I)
        B = Math.sqrt((2 * U.width ** 2 + U.height ** 2) / 3), B % 2 === 0 && (B += 1);
      else {
        const j = Math.max(Math.abs((P ? P.clientWidth : 0) - F), F) * 2 + 2, W = Math.max(Math.abs((P ? P.clientHeight : 0) - O), O) * 2 + 2;
        B = Math.sqrt(j ** 2 + W ** 2);
      }
      y != null && y.touches ? g.current === null && (g.current = () => {
        C({
          pulsate: T,
          rippleX: F,
          rippleY: O,
          rippleSize: B,
          cb: w
        });
      }, v.start(Bg, () => {
        g.current && (g.current(), g.current = null);
      })) : C({
        pulsate: T,
        rippleX: F,
        rippleY: O,
        rippleSize: B,
        cb: w
      });
    }, [
      r,
      C,
      v
    ]), R = tt.useCallback(() => {
      $({}, {
        pulsate: true
      });
    }, [
      $
    ]), b = tt.useCallback((y, E) => {
      if (v.clear(), (y == null ? void 0 : y.type) === "touchend" && g.current) {
        g.current(), g.current = null, v.start(0, () => {
          b(y, E);
        });
        return;
      }
      g.current = null, c((w) => w.length > 0 ? w.slice(1) : w), p.current = E;
    }, [
      v
    ]);
    return tt.useImperativeHandle(n, () => ({
      pulsate: R,
      start: $,
      stop: b
    }), [
      R,
      $,
      b
    ]), u.jsx(Vg, f({
      className: ae(ct.root, a.root, i),
      ref: h
    }, s, {
      children: u.jsx(bg, {
        component: null,
        exit: true,
        children: l
      })
    }));
  }), Hg = Wg;
  function Kg(e) {
    return xe("MuiButtonBase", e);
  }
  const qg = ye("MuiButtonBase", [
    "root",
    "disabled",
    "focusVisible"
  ]), Gg = qg, Yg = [
    "action",
    "centerRipple",
    "children",
    "className",
    "component",
    "disabled",
    "disableRipple",
    "disableTouchRipple",
    "focusRipple",
    "focusVisibleClassName",
    "LinkComponent",
    "onBlur",
    "onClick",
    "onContextMenu",
    "onDragLeave",
    "onFocus",
    "onFocusVisible",
    "onKeyDown",
    "onKeyUp",
    "onMouseDown",
    "onMouseLeave",
    "onMouseUp",
    "onTouchEnd",
    "onTouchMove",
    "onTouchStart",
    "tabIndex",
    "TouchRippleProps",
    "touchRippleRef",
    "type"
  ], Et = await M("react"), Xg = (e) => {
    const { disabled: t, focusVisible: n, focusVisibleClassName: o, classes: r } = e, i = Se({
      root: [
        "root",
        t && "disabled",
        n && "focusVisible"
      ]
    }, Kg, r);
    return n && o && (i.root += ` ${o}`), i;
  }, Zg = G("button", {
    name: "MuiButtonBase",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })({
    display: "inline-flex",
    alignItems: "center",
    justifyContent: "center",
    position: "relative",
    boxSizing: "border-box",
    WebkitTapHighlightColor: "transparent",
    backgroundColor: "transparent",
    outline: 0,
    border: 0,
    margin: 0,
    borderRadius: 0,
    padding: 0,
    cursor: "pointer",
    userSelect: "none",
    verticalAlign: "middle",
    MozAppearance: "none",
    WebkitAppearance: "none",
    textDecoration: "none",
    color: "inherit",
    "&::-moz-focus-inner": {
      borderStyle: "none"
    },
    [`&.${Gg.disabled}`]: {
      pointerEvents: "none",
      cursor: "default"
    },
    "@media print": {
      colorAdjust: "exact"
    }
  }), Jg = Et.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiButtonBase"
    }), { action: r, centerRipple: a = false, children: i, className: s, component: l = "button", disabled: c = false, disableRipple: d = false, disableTouchRipple: p = false, focusRipple: m = false, LinkComponent: v = "a", onBlur: g, onClick: h, onContextMenu: C, onDragLeave: $, onFocus: R, onFocusVisible: b, onKeyDown: y, onKeyUp: E, onMouseDown: w, onMouseLeave: T, onMouseUp: I, onTouchEnd: V, onTouchMove: P, onTouchStart: U, tabIndex: F = 0, TouchRippleProps: O, touchRippleRef: B, type: j } = o, W = ee(o, Yg), H = Et.useRef(null), D = Et.useRef(null), me = Ve(D, B), { isFocusVisibleRef: ne, onFocus: de, onBlur: _, ref: L } = Ic(), [A, Y] = Et.useState(false);
    c && A && Y(false), Et.useImperativeHandle(r, () => ({
      focusVisible: () => {
        Y(true), H.current.focus();
      }
    }), []);
    const [k, Z] = Et.useState(false);
    Et.useEffect(() => {
      Z(true);
    }, []);
    const Q = k && !d && !c;
    Et.useEffect(() => {
      A && m && !d && k && D.current.pulsate();
    }, [
      d,
      m,
      A,
      k
    ]);
    function z(le, mt, Zt = p) {
      return Wt((Ot) => (mt && mt(Ot), !Zt && D.current && D.current[le](Ot), true));
    }
    const fe = z("start", w), re = z("stop", C), ie = z("stop", $), te = z("stop", I), ge = z("stop", (le) => {
      A && le.preventDefault(), T && T(le);
    }), _e = z("start", U), Be = z("stop", V), ke = z("stop", P), Ke = z("stop", (le) => {
      _(le), ne.current === false && Y(false), g && g(le);
    }, false), et = Wt((le) => {
      H.current || (H.current = le.currentTarget), de(le), ne.current === true && (Y(true), b && b(le)), R && R(le);
    }), Ue = () => {
      const le = H.current;
      return l && l !== "button" && !(le.tagName === "A" && le.href);
    }, Ae = Et.useRef(false), it = Wt((le) => {
      m && !Ae.current && A && D.current && le.key === " " && (Ae.current = true, D.current.stop(le, () => {
        D.current.start(le);
      })), le.target === le.currentTarget && Ue() && le.key === " " && le.preventDefault(), y && y(le), le.target === le.currentTarget && Ue() && le.key === "Enter" && !c && (le.preventDefault(), h && h(le));
    }), We = Wt((le) => {
      m && le.key === " " && D.current && A && !le.defaultPrevented && (Ae.current = false, D.current.stop(le, () => {
        D.current.pulsate(le);
      })), E && E(le), h && le.target === le.currentTarget && Ue() && le.key === " " && !le.defaultPrevented && h(le);
    });
    let Ce = l;
    Ce === "button" && (W.href || W.to) && (Ce = v);
    const Ge = {};
    Ce === "button" ? (Ge.type = j === void 0 ? "button" : j, Ge.disabled = c) : (!W.href && !W.to && (Ge.role = "button"), c && (Ge["aria-disabled"] = c));
    const Rt = Ve(n, L, H), ht = f({}, o, {
      centerRipple: a,
      component: l,
      disabled: c,
      disableRipple: d,
      disableTouchRipple: p,
      focusRipple: m,
      tabIndex: F,
      focusVisible: A
    }), we = Xg(ht);
    return u.jsxs(Zg, f({
      as: Ce,
      className: ae(we.root, s),
      ownerState: ht,
      onBlur: Ke,
      onClick: h,
      onContextMenu: re,
      onFocus: et,
      onKeyDown: it,
      onKeyUp: We,
      onMouseDown: fe,
      onMouseLeave: ge,
      onMouseUp: te,
      onDragLeave: ie,
      onTouchEnd: Be,
      onTouchMove: ke,
      onTouchStart: _e,
      ref: Rt,
      tabIndex: c ? -1 : F,
      type: j
    }, Ge, W, {
      children: [
        i,
        Q ? u.jsx(Hg, f({
          ref: me,
          center: a
        }, O)) : null
      ]
    }));
  }), au = Jg;
  function Qg(e) {
    return xe("MuiAlert", e);
  }
  const ev = ye("MuiAlert", [
    "root",
    "action",
    "icon",
    "message",
    "filled",
    "colorSuccess",
    "colorInfo",
    "colorWarning",
    "colorError",
    "filledSuccess",
    "filledInfo",
    "filledWarning",
    "filledError",
    "outlined",
    "outlinedSuccess",
    "outlinedInfo",
    "outlinedWarning",
    "outlinedError",
    "standard",
    "standardSuccess",
    "standardInfo",
    "standardWarning",
    "standardError"
  ]), Us = ev;
  function tv(e) {
    return xe("MuiIconButton", e);
  }
  const nv = ye("MuiIconButton", [
    "root",
    "disabled",
    "colorInherit",
    "colorPrimary",
    "colorSecondary",
    "colorError",
    "colorInfo",
    "colorSuccess",
    "colorWarning",
    "edgeStart",
    "edgeEnd",
    "sizeSmall",
    "sizeMedium",
    "sizeLarge"
  ]), ov = nv, rv = [
    "edge",
    "children",
    "className",
    "color",
    "disabled",
    "disableFocusRipple",
    "size"
  ], av = await M("react"), iv = (e) => {
    const { classes: t, disabled: n, color: o, edge: r, size: a } = e, i = {
      root: [
        "root",
        n && "disabled",
        o !== "default" && `color${oe(o)}`,
        r && `edge${oe(r)}`,
        `size${oe(a)}`
      ]
    };
    return Se(i, tv, t);
  }, sv = G(au, {
    name: "MuiIconButton",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        n.color !== "default" && t[`color${oe(n.color)}`],
        n.edge && t[`edge${oe(n.edge)}`],
        t[`size${oe(n.size)}`]
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    textAlign: "center",
    flex: "0 0 auto",
    fontSize: e.typography.pxToRem(24),
    padding: 8,
    borderRadius: "50%",
    overflow: "visible",
    color: (e.vars || e).palette.action.active,
    transition: e.transitions.create("background-color", {
      duration: e.transitions.duration.shortest
    })
  }, !t.disableRipple && {
    "&:hover": {
      backgroundColor: e.vars ? `rgba(${e.vars.palette.action.activeChannel} / ${e.vars.palette.action.hoverOpacity})` : Ht(e.palette.action.active, e.palette.action.hoverOpacity),
      "@media (hover: none)": {
        backgroundColor: "transparent"
      }
    }
  }, t.edge === "start" && {
    marginLeft: t.size === "small" ? -3 : -12
  }, t.edge === "end" && {
    marginRight: t.size === "small" ? -3 : -12
  }), ({ theme: e, ownerState: t }) => {
    var n;
    const o = (n = (e.vars || e).palette) == null ? void 0 : n[t.color];
    return f({}, t.color === "inherit" && {
      color: "inherit"
    }, t.color !== "inherit" && t.color !== "default" && f({
      color: o == null ? void 0 : o.main
    }, !t.disableRipple && {
      "&:hover": f({}, o && {
        backgroundColor: e.vars ? `rgba(${o.mainChannel} / ${e.vars.palette.action.hoverOpacity})` : Ht(o.main, e.palette.action.hoverOpacity)
      }, {
        "@media (hover: none)": {
          backgroundColor: "transparent"
        }
      })
    }), t.size === "small" && {
      padding: 5,
      fontSize: e.typography.pxToRem(18)
    }, t.size === "large" && {
      padding: 12,
      fontSize: e.typography.pxToRem(28)
    }, {
      [`&.${ov.disabled}`]: {
        backgroundColor: "transparent",
        color: (e.vars || e).palette.action.disabled
      }
    });
  }), lv = av.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiIconButton"
    }), { edge: r = false, children: a, className: i, color: s = "default", disabled: l = false, disableFocusRipple: c = false, size: d = "medium" } = o, p = ee(o, rv), m = f({}, o, {
      edge: r,
      color: s,
      disabled: l,
      disableFocusRipple: c,
      size: d
    }), v = iv(m);
    return u.jsx(sv, f({
      className: ae(v.root, i),
      centerRipple: true,
      focusRipple: !c,
      disabled: l,
      ref: n
    }, p, {
      ownerState: m,
      children: a
    }));
  }), cv = lv;
  await M("react");
  const uv = It(u.jsx("path", {
    d: "M20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4C12.76,4 13.5,4.11 14.2, 4.31L15.77,2.74C14.61,2.26 13.34,2 12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0, 0 22,12M7.91,10.08L6.5,11.5L11,16L21,6L19.59,4.58L11,13.17L7.91,10.08Z"
  }), "SuccessOutlined");
  await M("react");
  const dv = It(u.jsx("path", {
    d: "M12 5.99L19.53 19H4.47L12 5.99M12 2L1 21h22L12 2zm1 14h-2v2h2v-2zm0-6h-2v4h2v-4z"
  }), "ReportProblemOutlined");
  await M("react");
  const pv = It(u.jsx("path", {
    d: "M11 15h2v2h-2zm0-8h2v6h-2zm.99-5C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"
  }), "ErrorOutline");
  await M("react");
  const fv = It(u.jsx("path", {
    d: "M11,9H13V7H11M12,20C7.59,20 4,16.41 4,12C4,7.59 7.59,4 12,4C16.41,4 20,7.59 20, 12C20,16.41 16.41,20 12,20M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10, 10 0 0,0 12,2M11,17H13V11H11V17Z"
  }), "InfoOutlined");
  await M("react");
  const hv = It(u.jsx("path", {
    d: "M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"
  }), "Close"), mv = [
    "action",
    "children",
    "className",
    "closeText",
    "color",
    "components",
    "componentsProps",
    "icon",
    "iconMapping",
    "onClose",
    "role",
    "severity",
    "slotProps",
    "slots",
    "variant"
  ], gv = await M("react"), vv = (e) => {
    const { variant: t, color: n, severity: o, classes: r } = e, a = {
      root: [
        "root",
        `color${oe(n || o)}`,
        `${t}${oe(n || o)}`,
        `${t}`
      ],
      icon: [
        "icon"
      ],
      message: [
        "message"
      ],
      action: [
        "action"
      ]
    };
    return Se(a, Qg, r);
  }, bv = G(Er, {
    name: "MuiAlert",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.variant],
        t[`${n.variant}${oe(n.color || n.severity)}`]
      ];
    }
  })(({ theme: e }) => {
    const t = e.palette.mode === "light" ? Oa : Ba, n = e.palette.mode === "light" ? Ba : Oa;
    return f({}, e.typography.body2, {
      backgroundColor: "transparent",
      display: "flex",
      padding: "6px 16px",
      variants: [
        ...Object.entries(e.palette).filter(([, o]) => o.main && o.light).map(([o]) => ({
          props: {
            colorSeverity: o,
            variant: "standard"
          },
          style: {
            color: e.vars ? e.vars.palette.Alert[`${o}Color`] : t(e.palette[o].light, 0.6),
            backgroundColor: e.vars ? e.vars.palette.Alert[`${o}StandardBg`] : n(e.palette[o].light, 0.9),
            [`& .${Us.icon}`]: e.vars ? {
              color: e.vars.palette.Alert[`${o}IconColor`]
            } : {
              color: e.palette[o].main
            }
          }
        })),
        ...Object.entries(e.palette).filter(([, o]) => o.main && o.light).map(([o]) => ({
          props: {
            colorSeverity: o,
            variant: "outlined"
          },
          style: {
            color: e.vars ? e.vars.palette.Alert[`${o}Color`] : t(e.palette[o].light, 0.6),
            border: `1px solid ${(e.vars || e).palette[o].light}`,
            [`& .${Us.icon}`]: e.vars ? {
              color: e.vars.palette.Alert[`${o}IconColor`]
            } : {
              color: e.palette[o].main
            }
          }
        })),
        ...Object.entries(e.palette).filter(([, o]) => o.main && o.dark).map(([o]) => ({
          props: {
            colorSeverity: o,
            variant: "filled"
          },
          style: f({
            fontWeight: e.typography.fontWeightMedium
          }, e.vars ? {
            color: e.vars.palette.Alert[`${o}FilledColor`],
            backgroundColor: e.vars.palette.Alert[`${o}FilledBg`]
          } : {
            backgroundColor: e.palette.mode === "dark" ? e.palette[o].dark : e.palette[o].main,
            color: e.palette.getContrastText(e.palette[o].main)
          })
        }))
      ]
    });
  }), yv = G("div", {
    name: "MuiAlert",
    slot: "Icon",
    overridesResolver: (e, t) => t.icon
  })({
    marginRight: 12,
    padding: "7px 0",
    display: "flex",
    fontSize: 22,
    opacity: 0.9
  }), xv = G("div", {
    name: "MuiAlert",
    slot: "Message",
    overridesResolver: (e, t) => t.message
  })({
    padding: "8px 0",
    minWidth: 0,
    overflow: "auto"
  }), Ws = G("div", {
    name: "MuiAlert",
    slot: "Action",
    overridesResolver: (e, t) => t.action
  })({
    display: "flex",
    alignItems: "flex-start",
    padding: "4px 0 0 16px",
    marginLeft: "auto",
    marginRight: -8
  }), Hs = {
    success: u.jsx(uv, {
      fontSize: "inherit"
    }),
    warning: u.jsx(dv, {
      fontSize: "inherit"
    }),
    error: u.jsx(pv, {
      fontSize: "inherit"
    }),
    info: u.jsx(fv, {
      fontSize: "inherit"
    })
  }, Sv = gv.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiAlert"
    }), { action: r, children: a, className: i, closeText: s = "Close", color: l, components: c = {}, componentsProps: d = {}, icon: p, iconMapping: m = Hs, onClose: v, role: g = "alert", severity: h = "success", slotProps: C = {}, slots: $ = {}, variant: R = "standard" } = o, b = ee(o, mv), y = f({}, o, {
      color: l,
      severity: h,
      variant: R,
      colorSeverity: l || h
    }), E = vv(y), w = {
      slots: f({
        closeButton: c.CloseButton,
        closeIcon: c.CloseIcon
      }, $),
      slotProps: f({}, d, C)
    }, [T, I] = Os("closeButton", {
      elementType: cv,
      externalForwardedProps: w,
      ownerState: y
    }), [V, P] = Os("closeIcon", {
      elementType: hv,
      externalForwardedProps: w,
      ownerState: y
    });
    return u.jsxs(bv, f({
      role: g,
      elevation: 0,
      ownerState: y,
      className: ae(E.root, i),
      ref: n
    }, b, {
      children: [
        p !== false ? u.jsx(yv, {
          ownerState: y,
          className: E.icon,
          children: p || m[h] || Hs[h]
        }) : null,
        u.jsx(xv, {
          ownerState: y,
          className: E.message,
          children: a
        }),
        r != null ? u.jsx(Ws, {
          ownerState: y,
          className: E.action,
          children: r
        }) : null,
        r == null && v ? u.jsx(Ws, {
          ownerState: y,
          className: E.action,
          children: u.jsx(T, f({
            size: "small",
            "aria-label": s,
            title: s,
            color: "inherit",
            onClick: v
          }, I, {
            children: u.jsx(V, f({
              fontSize: "small"
            }, P))
          }))
        }) : null
      ]
    }));
  }), Rv = Sv;
  function _v(e) {
    return xe("MuiTypography", e);
  }
  ye("MuiTypography", [
    "root",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "subtitle1",
    "subtitle2",
    "body1",
    "body2",
    "inherit",
    "button",
    "caption",
    "overline",
    "alignLeft",
    "alignRight",
    "alignCenter",
    "alignJustify",
    "noWrap",
    "gutterBottom",
    "paragraph"
  ]);
  const Cv = [
    "align",
    "className",
    "component",
    "gutterBottom",
    "noWrap",
    "paragraph",
    "variant",
    "variantMapping"
  ], wv = await M("react"), $v = (e) => {
    const { align: t, gutterBottom: n, noWrap: o, paragraph: r, variant: a, classes: i } = e, s = {
      root: [
        "root",
        a,
        e.align !== "inherit" && `align${oe(t)}`,
        n && "gutterBottom",
        o && "noWrap",
        r && "paragraph"
      ]
    };
    return Se(s, _v, i);
  }, Ev = G("span", {
    name: "MuiTypography",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        n.variant && t[n.variant],
        n.align !== "inherit" && t[`align${oe(n.align)}`],
        n.noWrap && t.noWrap,
        n.gutterBottom && t.gutterBottom,
        n.paragraph && t.paragraph
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    margin: 0
  }, t.variant === "inherit" && {
    font: "inherit"
  }, t.variant !== "inherit" && e.typography[t.variant], t.align !== "inherit" && {
    textAlign: t.align
  }, t.noWrap && {
    overflow: "hidden",
    textOverflow: "ellipsis",
    whiteSpace: "nowrap"
  }, t.gutterBottom && {
    marginBottom: "0.35em"
  }, t.paragraph && {
    marginBottom: 16
  })), Ks = {
    h1: "h1",
    h2: "h2",
    h3: "h3",
    h4: "h4",
    h5: "h5",
    h6: "h6",
    subtitle1: "h6",
    subtitle2: "h6",
    body1: "p",
    body2: "p",
    inherit: "p"
  }, Tv = {
    primary: "primary.main",
    textPrimary: "text.primary",
    secondary: "secondary.main",
    textSecondary: "text.secondary",
    error: "error.main"
  }, kv = (e) => Tv[e] || e, Av = wv.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiTypography"
    }), r = kv(o.color), a = ci(f({}, o, {
      color: r
    })), { align: i = "inherit", className: s, component: l, gutterBottom: c = false, noWrap: d = false, paragraph: p = false, variant: m = "body1", variantMapping: v = Ks } = a, g = ee(a, Cv), h = f({}, a, {
      align: i,
      color: r,
      className: s,
      component: l,
      gutterBottom: c,
      noWrap: d,
      paragraph: p,
      variant: m,
      variantMapping: v
    }), C = l || (p ? "p" : v[m] || Ks[m]) || "span", $ = $v(h);
    return u.jsx(Ev, f({
      as: C,
      ref: n,
      ownerState: h,
      className: ae($.root, s)
    }, g));
  }), er = Av, Jt = await M("react"), Mv = await M("react-dom");
  function Pv(e) {
    return typeof e == "function" ? e() : e;
  }
  const Lv = Jt.forwardRef(function(t, n) {
    const { children: o, container: r, disablePortal: a = false } = t, [i, s] = Jt.useState(null), l = Ve(Jt.isValidElement(o) ? fo(o) : null, n);
    if (Lt(() => {
      a || s(Pv(r) || document.body);
    }, [
      r,
      a
    ]), Lt(() => {
      if (i && !a)
        return Yo(n, i), () => {
          Yo(n, null);
        };
    }, [
      n,
      i,
      a
    ]), a) {
      if (Jt.isValidElement(o)) {
        const c = {
          ref: l
        };
        return Jt.cloneElement(o, c);
      }
      return u.jsx(Jt.Fragment, {
        children: o
      });
    }
    return u.jsx(Jt.Fragment, {
      children: i && Mv.createPortal(o, i)
    });
  }), Iv = Lv, Nv = [
    "onChange",
    "maxRows",
    "minRows",
    "style",
    "value"
  ], Tt = await M("react");
  function Ao(e) {
    return parseInt(e, 10) || 0;
  }
  const Fv = {
    shadow: {
      visibility: "hidden",
      position: "absolute",
      overflow: "hidden",
      height: 0,
      top: 0,
      left: 0,
      transform: "translateZ(0)"
    }
  };
  function Ov(e) {
    for (const t in e)
      return false;
    return true;
  }
  function qs(e) {
    return Ov(e) || e.outerHeightStyle === 0 && !e.overflowing;
  }
  const Bv = Tt.forwardRef(function(t, n) {
    const { onChange: o, maxRows: r, minRows: a = 1, style: i, value: s } = t, l = ee(t, Nv), { current: c } = Tt.useRef(s != null), d = Tt.useRef(null), p = Ve(n, d), m = Tt.useRef(null), v = Tt.useRef(null), g = Tt.useCallback(() => {
      const b = d.current, y = v.current;
      if (!b || !y)
        return;
      const w = qt(b).getComputedStyle(b);
      if (w.width === "0px")
        return {
          outerHeightStyle: 0,
          overflowing: false
        };
      y.style.width = w.width, y.value = b.value || t.placeholder || "x", y.value.slice(-1) === `
` && (y.value += " ");
      const T = w.boxSizing, I = Ao(w.paddingBottom) + Ao(w.paddingTop), V = Ao(w.borderBottomWidth) + Ao(w.borderTopWidth), P = y.scrollHeight;
      y.value = "x";
      const U = y.scrollHeight;
      let F = P;
      a && (F = Math.max(Number(a) * U, F)), r && (F = Math.min(Number(r) * U, F)), F = Math.max(F, U);
      const O = F + (T === "border-box" ? I + V : 0), B = Math.abs(F - P) <= 1;
      return {
        outerHeightStyle: O,
        overflowing: B
      };
    }, [
      r,
      a,
      t.placeholder
    ]), h = Wt(() => {
      const b = d.current, y = g();
      if (!b || !y || qs(y))
        return false;
      const E = y.outerHeightStyle;
      return m.current != null && m.current !== E;
    }), C = Tt.useCallback(() => {
      const b = d.current, y = g();
      if (!b || !y || qs(y))
        return;
      const E = y.outerHeightStyle;
      m.current !== E && (m.current = E, b.style.height = `${E}px`), b.style.overflow = y.overflowing ? "hidden" : "";
    }, [
      g
    ]), $ = Tt.useRef(-1);
    Lt(() => {
      const b = fi(C), y = d == null ? void 0 : d.current;
      if (!y)
        return;
      const E = qt(y);
      E.addEventListener("resize", b);
      let w;
      return typeof ResizeObserver < "u" && (w = new ResizeObserver(() => {
        h() && (w.unobserve(y), cancelAnimationFrame($.current), C(), $.current = requestAnimationFrame(() => {
          w.observe(y);
        }));
      }), w.observe(y)), () => {
        b.clear(), cancelAnimationFrame($.current), E.removeEventListener("resize", b), w && w.disconnect();
      };
    }, [
      g,
      C,
      h
    ]), Lt(() => {
      C();
    });
    const R = (b) => {
      c || C(), o && o(b);
    };
    return u.jsxs(Tt.Fragment, {
      children: [
        u.jsx("textarea", f({
          value: s,
          onChange: R,
          ref: p,
          rows: a,
          style: i
        }, l)),
        u.jsx("textarea", {
          "aria-hidden": true,
          className: t.className,
          readOnly: true,
          ref: v,
          tabIndex: -1,
          style: f({}, Fv.shadow, i, {
            paddingTop: 0,
            paddingBottom: 0
          })
        })
      ]
    });
  }), Dv = Bv;
  function Nn({ props: e, states: t, muiFormControl: n }) {
    return t.reduce((o, r) => (o[r] = e[r], n && typeof e[r] > "u" && (o[r] = n[r]), o), {});
  }
  const jv = await M("react"), zv = jv.createContext(void 0), kr = zv, Vv = await M("react");
  function cn() {
    return Vv.useContext(kr);
  }
  await M("react");
  function Uv(e) {
    return u.jsx(Ec, f({}, e, {
      defaultTheme: yi,
      themeId: Cn
    }));
  }
  function Gs(e) {
    return e != null && !(Array.isArray(e) && e.length === 0);
  }
  function tr(e, t = false) {
    return e && (Gs(e.value) && e.value !== "" || t && Gs(e.defaultValue) && e.defaultValue !== "");
  }
  function Wv(e) {
    return e.startAdornment;
  }
  function Hv(e) {
    return xe("MuiInputBase", e);
  }
  const Kv = ye("MuiInputBase", [
    "root",
    "formControl",
    "focused",
    "disabled",
    "adornedStart",
    "adornedEnd",
    "error",
    "sizeSmall",
    "multiline",
    "colorSecondary",
    "fullWidth",
    "hiddenLabel",
    "readOnly",
    "input",
    "inputSizeSmall",
    "inputMultiline",
    "inputTypeSearch",
    "inputAdornedStart",
    "inputAdornedEnd",
    "inputHiddenLabel"
  ]), En = Kv, qv = [
    "aria-describedby",
    "autoComplete",
    "autoFocus",
    "className",
    "color",
    "components",
    "componentsProps",
    "defaultValue",
    "disabled",
    "disableInjectingGlobalStyles",
    "endAdornment",
    "error",
    "fullWidth",
    "id",
    "inputComponent",
    "inputProps",
    "inputRef",
    "margin",
    "maxRows",
    "minRows",
    "multiline",
    "name",
    "onBlur",
    "onChange",
    "onClick",
    "onFocus",
    "onKeyDown",
    "onKeyUp",
    "placeholder",
    "readOnly",
    "renderSuffix",
    "rows",
    "size",
    "slotProps",
    "slots",
    "startAdornment",
    "type",
    "value"
  ], _t = await M("react"), Ar = (e, t) => {
    const { ownerState: n } = e;
    return [
      t.root,
      n.formControl && t.formControl,
      n.startAdornment && t.adornedStart,
      n.endAdornment && t.adornedEnd,
      n.error && t.error,
      n.size === "small" && t.sizeSmall,
      n.multiline && t.multiline,
      n.color && t[`color${oe(n.color)}`],
      n.fullWidth && t.fullWidth,
      n.hiddenLabel && t.hiddenLabel
    ];
  }, Mr = (e, t) => {
    const { ownerState: n } = e;
    return [
      t.input,
      n.size === "small" && t.inputSizeSmall,
      n.multiline && t.inputMultiline,
      n.type === "search" && t.inputTypeSearch,
      n.startAdornment && t.inputAdornedStart,
      n.endAdornment && t.inputAdornedEnd,
      n.hiddenLabel && t.inputHiddenLabel
    ];
  }, Gv = (e) => {
    const { classes: t, color: n, disabled: o, error: r, endAdornment: a, focused: i, formControl: s, fullWidth: l, hiddenLabel: c, multiline: d, readOnly: p, size: m, startAdornment: v, type: g } = e, h = {
      root: [
        "root",
        `color${oe(n)}`,
        o && "disabled",
        r && "error",
        l && "fullWidth",
        i && "focused",
        s && "formControl",
        m && m !== "medium" && `size${oe(m)}`,
        d && "multiline",
        v && "adornedStart",
        a && "adornedEnd",
        c && "hiddenLabel",
        p && "readOnly"
      ],
      input: [
        "input",
        o && "disabled",
        g === "search" && "inputTypeSearch",
        d && "inputMultiline",
        m === "small" && "inputSizeSmall",
        c && "inputHiddenLabel",
        v && "inputAdornedStart",
        a && "inputAdornedEnd",
        p && "readOnly"
      ]
    };
    return Se(h, Hv, t);
  }, Pr = G("div", {
    name: "MuiInputBase",
    slot: "Root",
    overridesResolver: Ar
  })(({ theme: e, ownerState: t }) => f({}, e.typography.body1, {
    color: (e.vars || e).palette.text.primary,
    lineHeight: "1.4375em",
    boxSizing: "border-box",
    position: "relative",
    cursor: "text",
    display: "inline-flex",
    alignItems: "center",
    [`&.${En.disabled}`]: {
      color: (e.vars || e).palette.text.disabled,
      cursor: "default"
    }
  }, t.multiline && f({
    padding: "4px 0 5px"
  }, t.size === "small" && {
    paddingTop: 1
  }), t.fullWidth && {
    width: "100%"
  })), Lr = G("input", {
    name: "MuiInputBase",
    slot: "Input",
    overridesResolver: Mr
  })(({ theme: e, ownerState: t }) => {
    const n = e.palette.mode === "light", o = f({
      color: "currentColor"
    }, e.vars ? {
      opacity: e.vars.opacity.inputPlaceholder
    } : {
      opacity: n ? 0.42 : 0.5
    }, {
      transition: e.transitions.create("opacity", {
        duration: e.transitions.duration.shorter
      })
    }), r = {
      opacity: "0 !important"
    }, a = e.vars ? {
      opacity: e.vars.opacity.inputPlaceholder
    } : {
      opacity: n ? 0.42 : 0.5
    };
    return f({
      font: "inherit",
      letterSpacing: "inherit",
      color: "currentColor",
      padding: "4px 0 5px",
      border: 0,
      boxSizing: "content-box",
      background: "none",
      height: "1.4375em",
      margin: 0,
      WebkitTapHighlightColor: "transparent",
      display: "block",
      minWidth: 0,
      width: "100%",
      animationName: "mui-auto-fill-cancel",
      animationDuration: "10ms",
      "&::-webkit-input-placeholder": o,
      "&::-moz-placeholder": o,
      "&:-ms-input-placeholder": o,
      "&::-ms-input-placeholder": o,
      "&:focus": {
        outline: 0
      },
      "&:invalid": {
        boxShadow: "none"
      },
      "&::-webkit-search-decoration": {
        WebkitAppearance: "none"
      },
      [`label[data-shrink=false] + .${En.formControl} &`]: {
        "&::-webkit-input-placeholder": r,
        "&::-moz-placeholder": r,
        "&:-ms-input-placeholder": r,
        "&::-ms-input-placeholder": r,
        "&:focus::-webkit-input-placeholder": a,
        "&:focus::-moz-placeholder": a,
        "&:focus:-ms-input-placeholder": a,
        "&:focus::-ms-input-placeholder": a
      },
      [`&.${En.disabled}`]: {
        opacity: 1,
        WebkitTextFillColor: (e.vars || e).palette.text.disabled
      },
      "&:-webkit-autofill": {
        animationDuration: "5000s",
        animationName: "mui-auto-fill"
      }
    }, t.size === "small" && {
      paddingTop: 1
    }, t.multiline && {
      height: "auto",
      resize: "none",
      padding: 0,
      paddingTop: 0
    }, t.type === "search" && {
      MozAppearance: "textfield"
    });
  }), Yv = u.jsx(Uv, {
    styles: {
      "@keyframes mui-auto-fill": {
        from: {
          display: "block"
        }
      },
      "@keyframes mui-auto-fill-cancel": {
        from: {
          display: "block"
        }
      }
    }
  }), Xv = _t.forwardRef(function(t, n) {
    var o;
    const r = Re({
      props: t,
      name: "MuiInputBase"
    }), { "aria-describedby": a, autoComplete: i, autoFocus: s, className: l, components: c = {}, componentsProps: d = {}, defaultValue: p, disabled: m, disableInjectingGlobalStyles: v, endAdornment: g, fullWidth: h = false, id: C, inputComponent: $ = "input", inputProps: R = {}, inputRef: b, maxRows: y, minRows: E, multiline: w = false, name: T, onBlur: I, onChange: V, onClick: P, onFocus: U, onKeyDown: F, onKeyUp: O, placeholder: B, readOnly: j, renderSuffix: W, rows: H, slotProps: D = {}, slots: me = {}, startAdornment: ne, type: de = "text", value: _ } = r, L = ee(r, qv), A = R.value != null ? R.value : _, { current: Y } = _t.useRef(A != null), k = _t.useRef(), Z = _t.useCallback((we) => {
    }, []), Q = Ve(k, b, R.ref, Z), [z, fe] = _t.useState(false), re = cn(), ie = Nn({
      props: r,
      muiFormControl: re,
      states: [
        "color",
        "disabled",
        "error",
        "hiddenLabel",
        "size",
        "required",
        "filled"
      ]
    });
    ie.focused = re ? re.focused : z, _t.useEffect(() => {
      !re && m && z && (fe(false), I && I());
    }, [
      re,
      m,
      z,
      I
    ]);
    const te = re && re.onFilled, ge = re && re.onEmpty, _e = _t.useCallback((we) => {
      tr(we) ? te && te() : ge && ge();
    }, [
      te,
      ge
    ]);
    Lt(() => {
      Y && _e({
        value: A
      });
    }, [
      A,
      _e,
      Y
    ]);
    const Be = (we) => {
      if (ie.disabled) {
        we.stopPropagation();
        return;
      }
      U && U(we), R.onFocus && R.onFocus(we), re && re.onFocus ? re.onFocus(we) : fe(true);
    }, ke = (we) => {
      I && I(we), R.onBlur && R.onBlur(we), re && re.onBlur ? re.onBlur(we) : fe(false);
    }, Ke = (we, ...le) => {
      if (!Y) {
        const mt = we.target || k.current;
        if (mt == null)
          throw new Error(Mt(1));
        _e({
          value: mt.value
        });
      }
      R.onChange && R.onChange(we, ...le), V && V(we, ...le);
    };
    _t.useEffect(() => {
      _e(k.current);
    }, []);
    const et = (we) => {
      k.current && we.currentTarget === we.target && k.current.focus(), P && P(we);
    };
    let Ue = $, Ae = R;
    w && Ue === "input" && (H ? Ae = f({
      type: void 0,
      minRows: H,
      maxRows: H
    }, Ae) : Ae = f({
      type: void 0,
      maxRows: y,
      minRows: E
    }, Ae), Ue = Dv);
    const it = (we) => {
      _e(we.animationName === "mui-auto-fill-cancel" ? k.current : {
        value: "x"
      });
    };
    _t.useEffect(() => {
      re && re.setAdornedStart(!!ne);
    }, [
      re,
      ne
    ]);
    const We = f({}, r, {
      color: ie.color || "primary",
      disabled: ie.disabled,
      endAdornment: g,
      error: ie.error,
      focused: ie.focused,
      formControl: re,
      fullWidth: h,
      hiddenLabel: ie.hiddenLabel,
      multiline: w,
      size: ie.size,
      startAdornment: ne,
      type: de
    }), Ce = Gv(We), Ge = me.root || c.Root || Pr, Rt = D.root || d.root || {}, ht = me.input || c.Input || Lr;
    return Ae = f({}, Ae, (o = D.input) != null ? o : d.input), u.jsxs(_t.Fragment, {
      children: [
        !v && Yv,
        u.jsxs(Ge, f({}, Rt, !Xo(Ge) && {
          ownerState: f({}, We, Rt.ownerState)
        }, {
          ref: n,
          onClick: et
        }, L, {
          className: ae(Ce.root, Rt.className, l, j && "MuiInputBase-readOnly"),
          children: [
            ne,
            u.jsx(kr.Provider, {
              value: null,
              children: u.jsx(ht, f({
                ownerState: We,
                "aria-invalid": ie.error,
                "aria-describedby": a,
                autoComplete: i,
                autoFocus: s,
                defaultValue: p,
                disabled: ie.disabled,
                id: C,
                onAnimationStart: it,
                name: T,
                placeholder: B,
                readOnly: j,
                required: ie.required,
                rows: H,
                value: A,
                onKeyDown: F,
                onKeyUp: O,
                type: de
              }, Ae, !Xo(ht) && {
                as: Ue,
                ownerState: f({}, We, Ae.ownerState)
              }, {
                ref: Q,
                className: ae(Ce.input, Ae.className, j && "MuiInputBase-readOnly"),
                onBlur: ke,
                onChange: Ke,
                onFocus: Be
              }))
            }),
            g,
            W ? W(f({}, ie, {
              startAdornment: ne
            })) : null
          ]
        }))
      ]
    });
  }), _i = Xv;
  function Zv(e) {
    return xe("MuiInput", e);
  }
  const Jv = f({}, En, ye("MuiInput", [
    "root",
    "underline",
    "input"
  ])), Vn = Jv;
  function Qv(e) {
    return xe("MuiOutlinedInput", e);
  }
  const eb = f({}, En, ye("MuiOutlinedInput", [
    "root",
    "notchedOutline",
    "input"
  ])), Bt = eb;
  function tb(e) {
    return xe("MuiFilledInput", e);
  }
  const nb = f({}, En, ye("MuiFilledInput", [
    "root",
    "underline",
    "input"
  ])), Qt = nb;
  await M("react");
  const ob = It(u.jsx("path", {
    d: "M7 10l5 5 5-5z"
  }), "ArrowDropDown"), rb = [
    "addEndListener",
    "appear",
    "children",
    "easing",
    "in",
    "onEnter",
    "onEntered",
    "onEntering",
    "onExit",
    "onExited",
    "onExiting",
    "style",
    "timeout",
    "TransitionComponent"
  ], ca = await M("react"), ab = {
    entering: {
      opacity: 1
    },
    entered: {
      opacity: 1
    }
  }, ib = ca.forwardRef(function(t, n) {
    const o = $r(), r = {
      enter: o.transitions.duration.enteringScreen,
      exit: o.transitions.duration.leavingScreen
    }, { addEndListener: a, appear: i = true, children: s, easing: l, in: c, onEnter: d, onEntered: p, onEntering: m, onExit: v, onExited: g, onExiting: h, style: C, timeout: $ = r, TransitionComponent: R = xi } = t, b = ee(t, rb), y = ca.useRef(null), E = Ve(y, fo(s), n), w = (B) => (j) => {
      if (B) {
        const W = y.current;
        j === void 0 ? B(W) : B(W, j);
      }
    }, T = w(m), I = w((B, j) => {
      ou(B);
      const W = $n({
        style: C,
        timeout: $,
        easing: l
      }, {
        mode: "enter"
      });
      B.style.webkitTransition = o.transitions.create("opacity", W), B.style.transition = o.transitions.create("opacity", W), d && d(B, j);
    }), V = w(p), P = w(h), U = w((B) => {
      const j = $n({
        style: C,
        timeout: $,
        easing: l
      }, {
        mode: "exit"
      });
      B.style.webkitTransition = o.transitions.create("opacity", j), B.style.transition = o.transitions.create("opacity", j), v && v(B);
    }), F = w(g), O = (B) => {
      a && a(y.current, B);
    };
    return u.jsx(R, f({
      appear: i,
      in: c,
      nodeRef: y,
      onEnter: I,
      onEntered: V,
      onEntering: T,
      onExit: U,
      onExited: F,
      onExiting: P,
      addEndListener: O,
      timeout: $
    }, b, {
      children: (B, j) => ca.cloneElement(s, f({
        style: f({
          opacity: 0,
          visibility: B === "exited" && !c ? "hidden" : void 0
        }, ab[B], C, s.props.style),
        ref: E
      }, j))
    }));
  }), iu = ib;
  function sb(e) {
    return xe("MuiBackdrop", e);
  }
  ye("MuiBackdrop", [
    "root",
    "invisible"
  ]);
  const lb = [
    "children",
    "className",
    "component",
    "components",
    "componentsProps",
    "invisible",
    "open",
    "slotProps",
    "slots",
    "TransitionComponent",
    "transitionDuration"
  ], cb = await M("react"), ub = (e) => {
    const { classes: t, invisible: n } = e;
    return Se({
      root: [
        "root",
        n && "invisible"
      ]
    }, sb, t);
  }, db = G("div", {
    name: "MuiBackdrop",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        n.invisible && t.invisible
      ];
    }
  })(({ ownerState: e }) => f({
    position: "fixed",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    right: 0,
    bottom: 0,
    top: 0,
    left: 0,
    backgroundColor: "rgba(0, 0, 0, 0.5)",
    WebkitTapHighlightColor: "transparent"
  }, e.invisible && {
    backgroundColor: "transparent"
  })), pb = cb.forwardRef(function(t, n) {
    var o, r, a;
    const i = Re({
      props: t,
      name: "MuiBackdrop"
    }), { children: s, className: l, component: c = "div", components: d = {}, componentsProps: p = {}, invisible: m = false, open: v, slotProps: g = {}, slots: h = {}, TransitionComponent: C = iu, transitionDuration: $ } = i, R = ee(i, lb), b = f({}, i, {
      component: c,
      invisible: m
    }), y = ub(b), E = (o = g.root) != null ? o : p.root;
    return u.jsx(C, f({
      in: v,
      timeout: $
    }, R, {
      children: u.jsx(db, f({
        "aria-hidden": true
      }, E, {
        as: (r = (a = h.root) != null ? a : d.Root) != null ? r : c,
        className: ae(y.root, l, E == null ? void 0 : E.className),
        ownerState: f({}, b, E == null ? void 0 : E.ownerState),
        classes: y,
        ref: n,
        children: s
      }))
    }));
  }), su = pb, fb = ye("MuiBox", [
    "root"
  ]), hb = fb, mb = bi(), gb = Gf({
    themeId: Cn,
    defaultTheme: mb,
    defaultClassName: hb.root,
    generateClassName: ui.generate
  }), ua = gb;
  function vb(e) {
    return xe("MuiButton", e);
  }
  const bb = ye("MuiButton", [
    "root",
    "text",
    "textInherit",
    "textPrimary",
    "textSecondary",
    "textSuccess",
    "textError",
    "textInfo",
    "textWarning",
    "outlined",
    "outlinedInherit",
    "outlinedPrimary",
    "outlinedSecondary",
    "outlinedSuccess",
    "outlinedError",
    "outlinedInfo",
    "outlinedWarning",
    "contained",
    "containedInherit",
    "containedPrimary",
    "containedSecondary",
    "containedSuccess",
    "containedError",
    "containedInfo",
    "containedWarning",
    "disableElevation",
    "focusVisible",
    "disabled",
    "colorInherit",
    "colorPrimary",
    "colorSecondary",
    "colorSuccess",
    "colorError",
    "colorInfo",
    "colorWarning",
    "textSizeSmall",
    "textSizeMedium",
    "textSizeLarge",
    "outlinedSizeSmall",
    "outlinedSizeMedium",
    "outlinedSizeLarge",
    "containedSizeSmall",
    "containedSizeMedium",
    "containedSizeLarge",
    "sizeMedium",
    "sizeSmall",
    "sizeLarge",
    "fullWidth",
    "startIcon",
    "endIcon",
    "icon",
    "iconSizeSmall",
    "iconSizeMedium",
    "iconSizeLarge"
  ]), Mo = bb, yb = await M("react"), xb = yb.createContext({}), Sb = xb, Rb = await M("react"), _b = Rb.createContext(void 0), Cb = _b, wb = [
    "children",
    "color",
    "component",
    "className",
    "disabled",
    "disableElevation",
    "disableFocusRipple",
    "endIcon",
    "focusVisibleClassName",
    "fullWidth",
    "size",
    "startIcon",
    "type",
    "variant"
  ], da = await M("react"), $b = (e) => {
    const { color: t, disableElevation: n, fullWidth: o, size: r, variant: a, classes: i } = e, s = {
      root: [
        "root",
        a,
        `${a}${oe(t)}`,
        `size${oe(r)}`,
        `${a}Size${oe(r)}`,
        `color${oe(t)}`,
        n && "disableElevation",
        o && "fullWidth"
      ],
      label: [
        "label"
      ],
      startIcon: [
        "icon",
        "startIcon",
        `iconSize${oe(r)}`
      ],
      endIcon: [
        "icon",
        "endIcon",
        `iconSize${oe(r)}`
      ]
    }, l = Se(s, vb, i);
    return f({}, i, l);
  }, lu = (e) => f({}, e.size === "small" && {
    "& > *:nth-of-type(1)": {
      fontSize: 18
    }
  }, e.size === "medium" && {
    "& > *:nth-of-type(1)": {
      fontSize: 20
    }
  }, e.size === "large" && {
    "& > *:nth-of-type(1)": {
      fontSize: 22
    }
  }), Eb = G(au, {
    shouldForwardProp: (e) => xt(e) || e === "classes",
    name: "MuiButton",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.variant],
        t[`${n.variant}${oe(n.color)}`],
        t[`size${oe(n.size)}`],
        t[`${n.variant}Size${oe(n.size)}`],
        n.color === "inherit" && t.colorInherit,
        n.disableElevation && t.disableElevation,
        n.fullWidth && t.fullWidth
      ];
    }
  })(({ theme: e, ownerState: t }) => {
    var n, o;
    const r = e.palette.mode === "light" ? e.palette.grey[300] : e.palette.grey[800], a = e.palette.mode === "light" ? e.palette.grey.A100 : e.palette.grey[700];
    return f({}, e.typography.button, {
      minWidth: 64,
      padding: "6px 16px",
      borderRadius: (e.vars || e).shape.borderRadius,
      transition: e.transitions.create([
        "background-color",
        "box-shadow",
        "border-color",
        "color"
      ], {
        duration: e.transitions.duration.short
      }),
      "&:hover": f({
        textDecoration: "none",
        backgroundColor: e.vars ? `rgba(${e.vars.palette.text.primaryChannel} / ${e.vars.palette.action.hoverOpacity})` : Ht(e.palette.text.primary, e.palette.action.hoverOpacity),
        "@media (hover: none)": {
          backgroundColor: "transparent"
        }
      }, t.variant === "text" && t.color !== "inherit" && {
        backgroundColor: e.vars ? `rgba(${e.vars.palette[t.color].mainChannel} / ${e.vars.palette.action.hoverOpacity})` : Ht(e.palette[t.color].main, e.palette.action.hoverOpacity),
        "@media (hover: none)": {
          backgroundColor: "transparent"
        }
      }, t.variant === "outlined" && t.color !== "inherit" && {
        border: `1px solid ${(e.vars || e).palette[t.color].main}`,
        backgroundColor: e.vars ? `rgba(${e.vars.palette[t.color].mainChannel} / ${e.vars.palette.action.hoverOpacity})` : Ht(e.palette[t.color].main, e.palette.action.hoverOpacity),
        "@media (hover: none)": {
          backgroundColor: "transparent"
        }
      }, t.variant === "contained" && {
        backgroundColor: e.vars ? e.vars.palette.Button.inheritContainedHoverBg : a,
        boxShadow: (e.vars || e).shadows[4],
        "@media (hover: none)": {
          boxShadow: (e.vars || e).shadows[2],
          backgroundColor: (e.vars || e).palette.grey[300]
        }
      }, t.variant === "contained" && t.color !== "inherit" && {
        backgroundColor: (e.vars || e).palette[t.color].dark,
        "@media (hover: none)": {
          backgroundColor: (e.vars || e).palette[t.color].main
        }
      }),
      "&:active": f({}, t.variant === "contained" && {
        boxShadow: (e.vars || e).shadows[8]
      }),
      [`&.${Mo.focusVisible}`]: f({}, t.variant === "contained" && {
        boxShadow: (e.vars || e).shadows[6]
      }),
      [`&.${Mo.disabled}`]: f({
        color: (e.vars || e).palette.action.disabled
      }, t.variant === "outlined" && {
        border: `1px solid ${(e.vars || e).palette.action.disabledBackground}`
      }, t.variant === "contained" && {
        color: (e.vars || e).palette.action.disabled,
        boxShadow: (e.vars || e).shadows[0],
        backgroundColor: (e.vars || e).palette.action.disabledBackground
      })
    }, t.variant === "text" && {
      padding: "6px 8px"
    }, t.variant === "text" && t.color !== "inherit" && {
      color: (e.vars || e).palette[t.color].main
    }, t.variant === "outlined" && {
      padding: "5px 15px",
      border: "1px solid currentColor"
    }, t.variant === "outlined" && t.color !== "inherit" && {
      color: (e.vars || e).palette[t.color].main,
      border: e.vars ? `1px solid rgba(${e.vars.palette[t.color].mainChannel} / 0.5)` : `1px solid ${Ht(e.palette[t.color].main, 0.5)}`
    }, t.variant === "contained" && {
      color: e.vars ? e.vars.palette.text.primary : (n = (o = e.palette).getContrastText) == null ? void 0 : n.call(o, e.palette.grey[300]),
      backgroundColor: e.vars ? e.vars.palette.Button.inheritContainedBg : r,
      boxShadow: (e.vars || e).shadows[2]
    }, t.variant === "contained" && t.color !== "inherit" && {
      color: (e.vars || e).palette[t.color].contrastText,
      backgroundColor: (e.vars || e).palette[t.color].main
    }, t.color === "inherit" && {
      color: "inherit",
      borderColor: "currentColor"
    }, t.size === "small" && t.variant === "text" && {
      padding: "4px 5px",
      fontSize: e.typography.pxToRem(13)
    }, t.size === "large" && t.variant === "text" && {
      padding: "8px 11px",
      fontSize: e.typography.pxToRem(15)
    }, t.size === "small" && t.variant === "outlined" && {
      padding: "3px 9px",
      fontSize: e.typography.pxToRem(13)
    }, t.size === "large" && t.variant === "outlined" && {
      padding: "7px 21px",
      fontSize: e.typography.pxToRem(15)
    }, t.size === "small" && t.variant === "contained" && {
      padding: "4px 10px",
      fontSize: e.typography.pxToRem(13)
    }, t.size === "large" && t.variant === "contained" && {
      padding: "8px 22px",
      fontSize: e.typography.pxToRem(15)
    }, t.fullWidth && {
      width: "100%"
    });
  }, ({ ownerState: e }) => e.disableElevation && {
    boxShadow: "none",
    "&:hover": {
      boxShadow: "none"
    },
    [`&.${Mo.focusVisible}`]: {
      boxShadow: "none"
    },
    "&:active": {
      boxShadow: "none"
    },
    [`&.${Mo.disabled}`]: {
      boxShadow: "none"
    }
  }), Tb = G("span", {
    name: "MuiButton",
    slot: "StartIcon",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.startIcon,
        t[`iconSize${oe(n.size)}`]
      ];
    }
  })(({ ownerState: e }) => f({
    display: "inherit",
    marginRight: 8,
    marginLeft: -4
  }, e.size === "small" && {
    marginLeft: -2
  }, lu(e))), kb = G("span", {
    name: "MuiButton",
    slot: "EndIcon",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.endIcon,
        t[`iconSize${oe(n.size)}`]
      ];
    }
  })(({ ownerState: e }) => f({
    display: "inherit",
    marginRight: -4,
    marginLeft: 8
  }, e.size === "small" && {
    marginRight: -2
  }, lu(e))), Ab = da.forwardRef(function(t, n) {
    const o = da.useContext(Sb), r = da.useContext(Cb), a = Go(o, t), i = Re({
      props: a,
      name: "MuiButton"
    }), { children: s, color: l = "primary", component: c = "button", className: d, disabled: p = false, disableElevation: m = false, disableFocusRipple: v = false, endIcon: g, focusVisibleClassName: h, fullWidth: C = false, size: $ = "medium", startIcon: R, type: b, variant: y = "text" } = i, E = ee(i, wb), w = f({}, i, {
      color: l,
      component: c,
      disabled: p,
      disableElevation: m,
      disableFocusRipple: v,
      fullWidth: C,
      size: $,
      type: b,
      variant: y
    }), T = $b(w), I = R && u.jsx(Tb, {
      className: T.startIcon,
      ownerState: w,
      children: R
    }), V = g && u.jsx(kb, {
      className: T.endIcon,
      ownerState: w,
      children: g
    }), P = r || "";
    return u.jsxs(Eb, f({
      ownerState: w,
      className: ae(o.className, T.root, d, P),
      component: c,
      disabled: p,
      focusRipple: !v,
      focusVisibleClassName: ae(T.focusVisible, h),
      ref: n,
      type: b
    }, E, {
      classes: T,
      children: [
        I,
        s,
        V
      ]
    }));
  }), yn = Ab;
  function Mb(e) {
    return xe("MuiCircularProgress", e);
  }
  ye("MuiCircularProgress", [
    "root",
    "determinate",
    "indeterminate",
    "colorPrimary",
    "colorSecondary",
    "svg",
    "circle",
    "circleDeterminate",
    "circleIndeterminate",
    "circleDisableShrink"
  ]);
  const Pb = [
    "className",
    "color",
    "disableShrink",
    "size",
    "style",
    "thickness",
    "value",
    "variant"
  ];
  let Ir = (e) => e, Ys, Xs, Zs, Js;
  const Lb = await M("react"), Dt = 44, Ib = Gt(Ys || (Ys = Ir`
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
`)), Nb = Gt(Xs || (Xs = Ir`
  0% {
    stroke-dasharray: 1px, 200px;
    stroke-dashoffset: 0;
  }

  50% {
    stroke-dasharray: 100px, 200px;
    stroke-dashoffset: -15px;
  }

  100% {
    stroke-dasharray: 100px, 200px;
    stroke-dashoffset: -125px;
  }
`)), Fb = (e) => {
    const { classes: t, variant: n, color: o, disableShrink: r } = e, a = {
      root: [
        "root",
        n,
        `color${oe(o)}`
      ],
      svg: [
        "svg"
      ],
      circle: [
        "circle",
        `circle${oe(n)}`,
        r && "circleDisableShrink"
      ]
    };
    return Se(a, Mb, t);
  }, Ob = G("span", {
    name: "MuiCircularProgress",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.variant],
        t[`color${oe(n.color)}`]
      ];
    }
  })(({ ownerState: e, theme: t }) => f({
    display: "inline-block"
  }, e.variant === "determinate" && {
    transition: t.transitions.create("transform")
  }, e.color !== "inherit" && {
    color: (t.vars || t).palette[e.color].main
  }), ({ ownerState: e }) => e.variant === "indeterminate" && ao(Zs || (Zs = Ir`
      animation: ${0} 1.4s linear infinite;
    `), Ib)), Bb = G("svg", {
    name: "MuiCircularProgress",
    slot: "Svg",
    overridesResolver: (e, t) => t.svg
  })({
    display: "block"
  }), Db = G("circle", {
    name: "MuiCircularProgress",
    slot: "Circle",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.circle,
        t[`circle${oe(n.variant)}`],
        n.disableShrink && t.circleDisableShrink
      ];
    }
  })(({ ownerState: e, theme: t }) => f({
    stroke: "currentColor"
  }, e.variant === "determinate" && {
    transition: t.transitions.create("stroke-dashoffset")
  }, e.variant === "indeterminate" && {
    strokeDasharray: "80px, 200px",
    strokeDashoffset: 0
  }), ({ ownerState: e }) => e.variant === "indeterminate" && !e.disableShrink && ao(Js || (Js = Ir`
      animation: ${0} 1.4s ease-in-out infinite;
    `), Nb)), jb = Lb.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiCircularProgress"
    }), { className: r, color: a = "primary", disableShrink: i = false, size: s = 40, style: l, thickness: c = 3.6, value: d = 0, variant: p = "indeterminate" } = o, m = ee(o, Pb), v = f({}, o, {
      color: a,
      disableShrink: i,
      size: s,
      thickness: c,
      value: d,
      variant: p
    }), g = Fb(v), h = {}, C = {}, $ = {};
    if (p === "determinate") {
      const R = 2 * Math.PI * ((Dt - c) / 2);
      h.strokeDasharray = R.toFixed(3), $["aria-valuenow"] = Math.round(d), h.strokeDashoffset = `${((100 - d) / 100 * R).toFixed(3)}px`, C.transform = "rotate(-90deg)";
    }
    return u.jsx(Ob, f({
      className: ae(g.root, r),
      style: f({
        width: s,
        height: s
      }, C, l),
      ownerState: v,
      ref: n,
      role: "progressbar"
    }, $, m, {
      children: u.jsx(Bb, {
        className: g.svg,
        ownerState: v,
        viewBox: `${Dt / 2} ${Dt / 2} ${Dt} ${Dt}`,
        children: u.jsx(Db, {
          className: g.circle,
          style: h,
          ownerState: v,
          cx: Dt,
          cy: Dt,
          r: (Dt - c) / 2,
          fill: "none",
          strokeWidth: c
        })
      })
    }));
  }), Qs = jb;
  function zb(e) {
    const t = Xe(e);
    return t.body === e ? qt(e).innerWidth > t.documentElement.clientWidth : e.scrollHeight > e.clientHeight;
  }
  function eo(e, t) {
    t ? e.setAttribute("aria-hidden", "true") : e.removeAttribute("aria-hidden");
  }
  function el(e) {
    return parseInt(qt(e).getComputedStyle(e).paddingRight, 10) || 0;
  }
  function Vb(e) {
    const n = [
      "TEMPLATE",
      "SCRIPT",
      "STYLE",
      "LINK",
      "MAP",
      "META",
      "NOSCRIPT",
      "PICTURE",
      "COL",
      "COLGROUP",
      "PARAM",
      "SLOT",
      "SOURCE",
      "TRACK"
    ].indexOf(e.tagName) !== -1, o = e.tagName === "INPUT" && e.getAttribute("type") === "hidden";
    return n || o;
  }
  function tl(e, t, n, o, r) {
    const a = [
      t,
      n,
      ...o
    ];
    [].forEach.call(e.children, (i) => {
      const s = a.indexOf(i) === -1, l = !Vb(i);
      s && l && eo(i, r);
    });
  }
  function pa(e, t) {
    let n = -1;
    return e.some((o, r) => t(o) ? (n = r, true) : false), n;
  }
  function Ub(e, t) {
    const n = [], o = e.container;
    if (!t.disableScrollLock) {
      if (zb(o)) {
        const i = Nc(Xe(o));
        n.push({
          value: o.style.paddingRight,
          property: "padding-right",
          el: o
        }), o.style.paddingRight = `${el(o) + i}px`;
        const s = Xe(o).querySelectorAll(".mui-fixed");
        [].forEach.call(s, (l) => {
          n.push({
            value: l.style.paddingRight,
            property: "padding-right",
            el: l
          }), l.style.paddingRight = `${el(l) + i}px`;
        });
      }
      let a;
      if (o.parentNode instanceof DocumentFragment)
        a = Xe(o).body;
      else {
        const i = o.parentElement, s = qt(o);
        a = (i == null ? void 0 : i.nodeName) === "HTML" && s.getComputedStyle(i).overflowY === "scroll" ? i : o;
      }
      n.push({
        value: a.style.overflow,
        property: "overflow",
        el: a
      }, {
        value: a.style.overflowX,
        property: "overflow-x",
        el: a
      }, {
        value: a.style.overflowY,
        property: "overflow-y",
        el: a
      }), a.style.overflow = "hidden";
    }
    return () => {
      n.forEach(({ value: a, el: i, property: s }) => {
        a ? i.style.setProperty(s, a) : i.style.removeProperty(s);
      });
    };
  }
  function Wb(e) {
    const t = [];
    return [].forEach.call(e.children, (n) => {
      n.getAttribute("aria-hidden") === "true" && t.push(n);
    }), t;
  }
  class Hb {
    constructor() {
      this.containers = void 0, this.modals = void 0, this.modals = [], this.containers = [];
    }
    add(t, n) {
      let o = this.modals.indexOf(t);
      if (o !== -1)
        return o;
      o = this.modals.length, this.modals.push(t), t.modalRef && eo(t.modalRef, false);
      const r = Wb(n);
      tl(n, t.mount, t.modalRef, r, true);
      const a = pa(this.containers, (i) => i.container === n);
      return a !== -1 ? (this.containers[a].modals.push(t), o) : (this.containers.push({
        modals: [
          t
        ],
        container: n,
        restore: null,
        hiddenSiblings: r
      }), o);
    }
    mount(t, n) {
      const o = pa(this.containers, (a) => a.modals.indexOf(t) !== -1), r = this.containers[o];
      r.restore || (r.restore = Ub(r, n));
    }
    remove(t, n = true) {
      const o = this.modals.indexOf(t);
      if (o === -1)
        return o;
      const r = pa(this.containers, (i) => i.modals.indexOf(t) !== -1), a = this.containers[r];
      if (a.modals.splice(a.modals.indexOf(t), 1), this.modals.splice(o, 1), a.modals.length === 0)
        a.restore && a.restore(), t.modalRef && eo(t.modalRef, n), tl(a.container, t.mount, t.modalRef, a.hiddenSiblings, false), this.containers.splice(r, 1);
      else {
        const i = a.modals[a.modals.length - 1];
        i.modalRef && eo(i.modalRef, false);
      }
      return o;
    }
    isTopModal(t) {
      return this.modals.length > 0 && this.modals[this.modals.length - 1] === t;
    }
  }
  const nt = await M("react"), Kb = [
    "input",
    "select",
    "textarea",
    "a[href]",
    "button",
    "[tabindex]",
    "audio[controls]",
    "video[controls]",
    '[contenteditable]:not([contenteditable="false"])'
  ].join(",");
  function qb(e) {
    const t = parseInt(e.getAttribute("tabindex") || "", 10);
    return Number.isNaN(t) ? e.contentEditable === "true" || (e.nodeName === "AUDIO" || e.nodeName === "VIDEO" || e.nodeName === "DETAILS") && e.getAttribute("tabindex") === null ? 0 : e.tabIndex : t;
  }
  function Gb(e) {
    if (e.tagName !== "INPUT" || e.type !== "radio" || !e.name)
      return false;
    const t = (o) => e.ownerDocument.querySelector(`input[type="radio"]${o}`);
    let n = t(`[name="${e.name}"]:checked`);
    return n || (n = t(`[name="${e.name}"]`)), n !== e;
  }
  function Yb(e) {
    return !(e.disabled || e.tagName === "INPUT" && e.type === "hidden" || Gb(e));
  }
  function Xb(e) {
    const t = [], n = [];
    return Array.from(e.querySelectorAll(Kb)).forEach((o, r) => {
      const a = qb(o);
      a === -1 || !Yb(o) || (a === 0 ? t.push(o) : n.push({
        documentOrder: r,
        tabIndex: a,
        node: o
      }));
    }), n.sort((o, r) => o.tabIndex === r.tabIndex ? o.documentOrder - r.documentOrder : o.tabIndex - r.tabIndex).map((o) => o.node).concat(t);
  }
  function Zb() {
    return true;
  }
  function Jb(e) {
    const { children: t, disableAutoFocus: n = false, disableEnforceFocus: o = false, disableRestoreFocus: r = false, getTabbable: a = Xb, isEnabled: i = Zb, open: s } = e, l = nt.useRef(false), c = nt.useRef(null), d = nt.useRef(null), p = nt.useRef(null), m = nt.useRef(null), v = nt.useRef(false), g = nt.useRef(null), h = Ve(fo(t), g), C = nt.useRef(null);
    nt.useEffect(() => {
      !s || !g.current || (v.current = !n);
    }, [
      n,
      s
    ]), nt.useEffect(() => {
      if (!s || !g.current)
        return;
      const b = Xe(g.current);
      return g.current.contains(b.activeElement) || (g.current.hasAttribute("tabIndex") || g.current.setAttribute("tabIndex", "-1"), v.current && g.current.focus()), () => {
        r || (p.current && p.current.focus && (l.current = true, p.current.focus()), p.current = null);
      };
    }, [
      s
    ]), nt.useEffect(() => {
      if (!s || !g.current)
        return;
      const b = Xe(g.current), y = (T) => {
        C.current = T, !(o || !i() || T.key !== "Tab") && b.activeElement === g.current && T.shiftKey && (l.current = true, d.current && d.current.focus());
      }, E = () => {
        const T = g.current;
        if (T === null)
          return;
        if (!b.hasFocus() || !i() || l.current) {
          l.current = false;
          return;
        }
        if (T.contains(b.activeElement) || o && b.activeElement !== c.current && b.activeElement !== d.current)
          return;
        if (b.activeElement !== m.current)
          m.current = null;
        else if (m.current !== null)
          return;
        if (!v.current)
          return;
        let I = [];
        if ((b.activeElement === c.current || b.activeElement === d.current) && (I = a(g.current)), I.length > 0) {
          var V, P;
          const U = !!((V = C.current) != null && V.shiftKey && ((P = C.current) == null ? void 0 : P.key) === "Tab"), F = I[0], O = I[I.length - 1];
          typeof F != "string" && typeof O != "string" && (U ? O.focus() : F.focus());
        } else
          T.focus();
      };
      b.addEventListener("focusin", E), b.addEventListener("keydown", y, true);
      const w = setInterval(() => {
        b.activeElement && b.activeElement.tagName === "BODY" && E();
      }, 50);
      return () => {
        clearInterval(w), b.removeEventListener("focusin", E), b.removeEventListener("keydown", y, true);
      };
    }, [
      n,
      o,
      r,
      i,
      s,
      a
    ]);
    const $ = (b) => {
      p.current === null && (p.current = b.relatedTarget), v.current = true, m.current = b.target;
      const y = t.props.onFocus;
      y && y(b);
    }, R = (b) => {
      p.current === null && (p.current = b.relatedTarget), v.current = true;
    };
    return u.jsxs(nt.Fragment, {
      children: [
        u.jsx("div", {
          tabIndex: s ? 0 : -1,
          onFocus: R,
          ref: c,
          "data-testid": "sentinelStart"
        }),
        nt.cloneElement(t, {
          ref: h,
          onFocus: $
        }),
        u.jsx("div", {
          tabIndex: s ? 0 : -1,
          onFocus: R,
          ref: d,
          "data-testid": "sentinelEnd"
        })
      ]
    });
  }
  const jt = await M("react");
  function Qb(e) {
    return typeof e == "function" ? e() : e;
  }
  function e0(e) {
    return e ? e.props.hasOwnProperty("in") : false;
  }
  const t0 = new Hb();
  function n0(e) {
    const { container: t, disableEscapeKeyDown: n = false, disableScrollLock: o = false, manager: r = t0, closeAfterTransition: a = false, onTransitionEnter: i, onTransitionExited: s, children: l, onClose: c, open: d, rootRef: p } = e, m = jt.useRef({}), v = jt.useRef(null), g = jt.useRef(null), h = Ve(g, p), [C, $] = jt.useState(!d), R = e0(l);
    let b = true;
    (e["aria-hidden"] === "false" || e["aria-hidden"] === false) && (b = false);
    const y = () => Xe(v.current), E = () => (m.current.modalRef = g.current, m.current.mount = v.current, m.current), w = () => {
      r.mount(E(), {
        disableScrollLock: o
      }), g.current && (g.current.scrollTop = 0);
    }, T = Wt(() => {
      const W = Qb(t) || y().body;
      r.add(E(), W), g.current && w();
    }), I = jt.useCallback(() => r.isTopModal(E()), [
      r
    ]), V = Wt((W) => {
      v.current = W, W && (d && I() ? w() : g.current && eo(g.current, b));
    }), P = jt.useCallback(() => {
      r.remove(E(), b);
    }, [
      b,
      r
    ]);
    jt.useEffect(() => () => {
      P();
    }, [
      P
    ]), jt.useEffect(() => {
      d ? T() : (!R || !a) && P();
    }, [
      d,
      P,
      R,
      a,
      T
    ]);
    const U = (W) => (H) => {
      var D;
      (D = W.onKeyDown) == null || D.call(W, H), !(H.key !== "Escape" || H.which === 229 || !I()) && (n || (H.stopPropagation(), c && c(H, "escapeKeyDown")));
    }, F = (W) => (H) => {
      var D;
      (D = W.onClick) == null || D.call(W, H), H.target === H.currentTarget && c && c(H, "backdropClick");
    };
    return {
      getRootProps: (W = {}) => {
        const H = Oc(e);
        delete H.onTransitionEnter, delete H.onTransitionExited;
        const D = f({}, H, W);
        return f({
          role: "presentation"
        }, D, {
          onKeyDown: U(D),
          ref: h
        });
      },
      getBackdropProps: (W = {}) => {
        const H = W;
        return f({
          "aria-hidden": true
        }, H, {
          onClick: F(H),
          open: d
        });
      },
      getTransitionProps: () => {
        const W = () => {
          $(false), i && i();
        }, H = () => {
          $(true), s && s(), a && P();
        };
        return {
          onEnter: La(W, l == null ? void 0 : l.props.onEnter),
          onExited: La(H, l == null ? void 0 : l.props.onExited)
        };
      },
      rootRef: h,
      portalRef: V,
      isTopModal: I,
      exited: C,
      hasTransition: R
    };
  }
  function o0(e) {
    return xe("MuiModal", e);
  }
  ye("MuiModal", [
    "root",
    "hidden",
    "backdrop"
  ]);
  const r0 = [
    "BackdropComponent",
    "BackdropProps",
    "classes",
    "className",
    "closeAfterTransition",
    "children",
    "container",
    "component",
    "components",
    "componentsProps",
    "disableAutoFocus",
    "disableEnforceFocus",
    "disableEscapeKeyDown",
    "disablePortal",
    "disableRestoreFocus",
    "disableScrollLock",
    "hideBackdrop",
    "keepMounted",
    "onBackdropClick",
    "onClose",
    "onTransitionEnter",
    "onTransitionExited",
    "open",
    "slotProps",
    "slots",
    "theme"
  ], nl = await M("react"), a0 = (e) => {
    const { open: t, exited: n, classes: o } = e;
    return Se({
      root: [
        "root",
        !t && n && "hidden"
      ],
      backdrop: [
        "backdrop"
      ]
    }, o0, o);
  }, i0 = G("div", {
    name: "MuiModal",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        !n.open && n.exited && t.hidden
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    position: "fixed",
    zIndex: (e.vars || e).zIndex.modal,
    right: 0,
    bottom: 0,
    top: 0,
    left: 0
  }, !t.open && t.exited && {
    visibility: "hidden"
  })), s0 = G(su, {
    name: "MuiModal",
    slot: "Backdrop",
    overridesResolver: (e, t) => t.backdrop
  })({
    zIndex: -1
  }), l0 = nl.forwardRef(function(t, n) {
    var o, r, a, i, s, l;
    const c = Re({
      name: "MuiModal",
      props: t
    }), { BackdropComponent: d = s0, BackdropProps: p, className: m, closeAfterTransition: v = false, children: g, container: h, component: C, components: $ = {}, componentsProps: R = {}, disableAutoFocus: b = false, disableEnforceFocus: y = false, disableEscapeKeyDown: E = false, disablePortal: w = false, disableRestoreFocus: T = false, disableScrollLock: I = false, hideBackdrop: V = false, keepMounted: P = false, onBackdropClick: U, open: F, slotProps: O, slots: B } = c, j = ee(c, r0), W = f({}, c, {
      closeAfterTransition: v,
      disableAutoFocus: b,
      disableEnforceFocus: y,
      disableEscapeKeyDown: E,
      disablePortal: w,
      disableRestoreFocus: T,
      disableScrollLock: I,
      hideBackdrop: V,
      keepMounted: P
    }), { getRootProps: H, getBackdropProps: D, getTransitionProps: me, portalRef: ne, isTopModal: de, exited: _, hasTransition: L } = n0(f({}, W, {
      rootRef: n
    })), A = f({}, W, {
      exited: _
    }), Y = a0(A), k = {};
    if (g.props.tabIndex === void 0 && (k.tabIndex = "-1"), L) {
      const { onEnter: te, onExited: ge } = me();
      k.onEnter = te, k.onExited = ge;
    }
    const Z = (o = (r = B == null ? void 0 : B.root) != null ? r : $.Root) != null ? o : i0, Q = (a = (i = B == null ? void 0 : B.backdrop) != null ? i : $.Backdrop) != null ? a : d, z = (s = O == null ? void 0 : O.root) != null ? s : R.root, fe = (l = O == null ? void 0 : O.backdrop) != null ? l : R.backdrop, re = wn({
      elementType: Z,
      externalSlotProps: z,
      externalForwardedProps: j,
      getSlotProps: H,
      additionalProps: {
        ref: n,
        as: C
      },
      ownerState: A,
      className: ae(m, z == null ? void 0 : z.className, Y == null ? void 0 : Y.root, !A.open && A.exited && (Y == null ? void 0 : Y.hidden))
    }), ie = wn({
      elementType: Q,
      externalSlotProps: fe,
      additionalProps: p,
      getSlotProps: (te) => D(f({}, te, {
        onClick: (ge) => {
          U && U(ge), te != null && te.onClick && te.onClick(ge);
        }
      })),
      className: ae(fe == null ? void 0 : fe.className, p == null ? void 0 : p.className, Y == null ? void 0 : Y.backdrop),
      ownerState: A
    });
    return !P && !F && (!L || _) ? null : u.jsx(Iv, {
      ref: ne,
      container: h,
      disablePortal: w,
      children: u.jsxs(Z, f({}, re, {
        children: [
          !V && d ? u.jsx(Q, f({}, ie)) : null,
          u.jsx(Jb, {
            disableEnforceFocus: y,
            disableAutoFocus: b,
            disableRestoreFocus: T,
            isEnabled: de,
            open: F,
            children: nl.cloneElement(g, k)
          })
        ]
      }))
    });
  }), cu = l0;
  function c0(e) {
    return xe("MuiDialog", e);
  }
  const u0 = ye("MuiDialog", [
    "root",
    "scrollPaper",
    "scrollBody",
    "container",
    "paper",
    "paperScrollPaper",
    "paperScrollBody",
    "paperWidthFalse",
    "paperWidthXs",
    "paperWidthSm",
    "paperWidthMd",
    "paperWidthLg",
    "paperWidthXl",
    "paperFullWidth",
    "paperFullScreen"
  ]), fa = u0, d0 = await M("react"), p0 = d0.createContext({}), uu = p0, f0 = [
    "aria-describedby",
    "aria-labelledby",
    "BackdropComponent",
    "BackdropProps",
    "children",
    "className",
    "disableEscapeKeyDown",
    "fullScreen",
    "fullWidth",
    "maxWidth",
    "onBackdropClick",
    "onClick",
    "onClose",
    "open",
    "PaperComponent",
    "PaperProps",
    "scroll",
    "TransitionComponent",
    "transitionDuration",
    "TransitionProps"
  ], ha = await M("react"), h0 = G(su, {
    name: "MuiDialog",
    slot: "Backdrop",
    overrides: (e, t) => t.backdrop
  })({
    zIndex: -1
  }), m0 = (e) => {
    const { classes: t, scroll: n, maxWidth: o, fullWidth: r, fullScreen: a } = e, i = {
      root: [
        "root"
      ],
      container: [
        "container",
        `scroll${oe(n)}`
      ],
      paper: [
        "paper",
        `paperScroll${oe(n)}`,
        `paperWidth${oe(String(o))}`,
        r && "paperFullWidth",
        a && "paperFullScreen"
      ]
    };
    return Se(i, c0, t);
  }, g0 = G(cu, {
    name: "MuiDialog",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })({
    "@media print": {
      position: "absolute !important"
    }
  }), v0 = G("div", {
    name: "MuiDialog",
    slot: "Container",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.container,
        t[`scroll${oe(n.scroll)}`]
      ];
    }
  })(({ ownerState: e }) => f({
    height: "100%",
    "@media print": {
      height: "auto"
    },
    outline: 0
  }, e.scroll === "paper" && {
    display: "flex",
    justifyContent: "center",
    alignItems: "center"
  }, e.scroll === "body" && {
    overflowY: "auto",
    overflowX: "hidden",
    textAlign: "center",
    "&::after": {
      content: '""',
      display: "inline-block",
      verticalAlign: "middle",
      height: "100%",
      width: "0"
    }
  })), b0 = G(Er, {
    name: "MuiDialog",
    slot: "Paper",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.paper,
        t[`scrollPaper${oe(n.scroll)}`],
        t[`paperWidth${oe(String(n.maxWidth))}`],
        n.fullWidth && t.paperFullWidth,
        n.fullScreen && t.paperFullScreen
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    margin: 32,
    position: "relative",
    overflowY: "auto",
    "@media print": {
      overflowY: "visible",
      boxShadow: "none"
    }
  }, t.scroll === "paper" && {
    display: "flex",
    flexDirection: "column",
    maxHeight: "calc(100% - 64px)"
  }, t.scroll === "body" && {
    display: "inline-block",
    verticalAlign: "middle",
    textAlign: "left"
  }, !t.maxWidth && {
    maxWidth: "calc(100% - 64px)"
  }, t.maxWidth === "xs" && {
    maxWidth: e.breakpoints.unit === "px" ? Math.max(e.breakpoints.values.xs, 444) : `max(${e.breakpoints.values.xs}${e.breakpoints.unit}, 444px)`,
    [`&.${fa.paperScrollBody}`]: {
      [e.breakpoints.down(Math.max(e.breakpoints.values.xs, 444) + 32 * 2)]: {
        maxWidth: "calc(100% - 64px)"
      }
    }
  }, t.maxWidth && t.maxWidth !== "xs" && {
    maxWidth: `${e.breakpoints.values[t.maxWidth]}${e.breakpoints.unit}`,
    [`&.${fa.paperScrollBody}`]: {
      [e.breakpoints.down(e.breakpoints.values[t.maxWidth] + 32 * 2)]: {
        maxWidth: "calc(100% - 64px)"
      }
    }
  }, t.fullWidth && {
    width: "calc(100% - 64px)"
  }, t.fullScreen && {
    margin: 0,
    width: "100%",
    maxWidth: "100%",
    height: "100%",
    maxHeight: "none",
    borderRadius: 0,
    [`&.${fa.paperScrollBody}`]: {
      margin: 0,
      maxWidth: "100%"
    }
  })), y0 = ha.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiDialog"
    }), r = $r(), a = {
      enter: r.transitions.duration.enteringScreen,
      exit: r.transitions.duration.leavingScreen
    }, { "aria-describedby": i, "aria-labelledby": s, BackdropComponent: l, BackdropProps: c, children: d, className: p, disableEscapeKeyDown: m = false, fullScreen: v = false, fullWidth: g = false, maxWidth: h = "sm", onBackdropClick: C, onClick: $, onClose: R, open: b, PaperComponent: y = Er, PaperProps: E = {}, scroll: w = "paper", TransitionComponent: T = iu, transitionDuration: I = a, TransitionProps: V } = o, P = ee(o, f0), U = f({}, o, {
      disableEscapeKeyDown: m,
      fullScreen: v,
      fullWidth: g,
      maxWidth: h,
      scroll: w
    }), F = m0(U), O = ha.useRef(), B = (D) => {
      O.current = D.target === D.currentTarget;
    }, j = (D) => {
      $ && $(D), O.current && (O.current = null, C && C(D), R && R(D, "backdropClick"));
    }, W = po(s), H = ha.useMemo(() => ({
      titleId: W
    }), [
      W
    ]);
    return u.jsx(g0, f({
      className: ae(F.root, p),
      closeAfterTransition: true,
      components: {
        Backdrop: h0
      },
      componentsProps: {
        backdrop: f({
          transitionDuration: I,
          as: l
        }, c)
      },
      disableEscapeKeyDown: m,
      onClose: R,
      open: b,
      ref: n,
      onClick: j,
      ownerState: U
    }, P, {
      children: u.jsx(T, f({
        appear: true,
        in: b,
        timeout: I,
        role: "presentation"
      }, V, {
        children: u.jsx(v0, {
          className: ae(F.container),
          onMouseDown: B,
          ownerState: U,
          children: u.jsx(b0, f({
            as: y,
            elevation: 24,
            role: "dialog",
            "aria-describedby": i,
            "aria-labelledby": W
          }, E, {
            className: ae(F.paper, E.className),
            ownerState: U,
            children: u.jsx(uu.Provider, {
              value: H,
              children: d
            })
          }))
        })
      }))
    }));
  }), x0 = y0;
  function S0(e) {
    return xe("MuiDialogActions", e);
  }
  ye("MuiDialogActions", [
    "root",
    "spacing"
  ]);
  const R0 = [
    "className",
    "disableSpacing"
  ], _0 = await M("react"), C0 = (e) => {
    const { classes: t, disableSpacing: n } = e;
    return Se({
      root: [
        "root",
        !n && "spacing"
      ]
    }, S0, t);
  }, w0 = G("div", {
    name: "MuiDialogActions",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        !n.disableSpacing && t.spacing
      ];
    }
  })(({ ownerState: e }) => f({
    display: "flex",
    alignItems: "center",
    padding: 8,
    justifyContent: "flex-end",
    flex: "0 0 auto"
  }, !e.disableSpacing && {
    "& > :not(style) ~ :not(style)": {
      marginLeft: 8
    }
  })), $0 = _0.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiDialogActions"
    }), { className: r, disableSpacing: a = false } = o, i = ee(o, R0), s = f({}, o, {
      disableSpacing: a
    }), l = C0(s);
    return u.jsx(w0, f({
      className: ae(l.root, r),
      ownerState: s,
      ref: n
    }, i));
  }), E0 = $0;
  function T0(e) {
    return xe("MuiDialogContent", e);
  }
  ye("MuiDialogContent", [
    "root",
    "dividers"
  ]);
  function k0(e) {
    return xe("MuiDialogTitle", e);
  }
  const A0 = ye("MuiDialogTitle", [
    "root"
  ]), M0 = A0, P0 = [
    "className",
    "dividers"
  ], L0 = await M("react"), I0 = (e) => {
    const { classes: t, dividers: n } = e;
    return Se({
      root: [
        "root",
        n && "dividers"
      ]
    }, T0, t);
  }, N0 = G("div", {
    name: "MuiDialogContent",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        n.dividers && t.dividers
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    flex: "1 1 auto",
    WebkitOverflowScrolling: "touch",
    overflowY: "auto",
    padding: "20px 24px"
  }, t.dividers ? {
    padding: "16px 24px",
    borderTop: `1px solid ${(e.vars || e).palette.divider}`,
    borderBottom: `1px solid ${(e.vars || e).palette.divider}`
  } : {
    [`.${M0.root} + &`]: {
      paddingTop: 0
    }
  })), F0 = L0.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiDialogContent"
    }), { className: r, dividers: a = false } = o, i = ee(o, P0), s = f({}, o, {
      dividers: a
    }), l = I0(s);
    return u.jsx(N0, f({
      className: ae(l.root, r),
      ownerState: s,
      ref: n
    }, i));
  }), O0 = F0, B0 = [
    "className",
    "id"
  ], ol = await M("react"), D0 = (e) => {
    const { classes: t } = e;
    return Se({
      root: [
        "root"
      ]
    }, k0, t);
  }, j0 = G(er, {
    name: "MuiDialogTitle",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })({
    padding: "16px 24px",
    flex: "0 0 auto"
  }), z0 = ol.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiDialogTitle"
    }), { className: r, id: a } = o, i = ee(o, B0), s = o, l = D0(s), { titleId: c = a } = ol.useContext(uu);
    return u.jsx(j0, f({
      component: "h2",
      className: ae(l.root, r),
      ownerState: s,
      ref: n,
      variant: "h6",
      id: a ?? c
    }, i));
  }), V0 = z0, U0 = [
    "disableUnderline",
    "components",
    "componentsProps",
    "fullWidth",
    "hiddenLabel",
    "inputComponent",
    "multiline",
    "slotProps",
    "slots",
    "type"
  ], W0 = await M("react"), H0 = (e) => {
    const { classes: t, disableUnderline: n } = e, r = Se({
      root: [
        "root",
        !n && "underline"
      ],
      input: [
        "input"
      ]
    }, tb, t);
    return f({}, t, r);
  }, K0 = G(Pr, {
    shouldForwardProp: (e) => xt(e) || e === "classes",
    name: "MuiFilledInput",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        ...Ar(e, t),
        !n.disableUnderline && t.underline
      ];
    }
  })(({ theme: e, ownerState: t }) => {
    var n;
    const o = e.palette.mode === "light", r = o ? "rgba(0, 0, 0, 0.42)" : "rgba(255, 255, 255, 0.7)", a = o ? "rgba(0, 0, 0, 0.06)" : "rgba(255, 255, 255, 0.09)", i = o ? "rgba(0, 0, 0, 0.09)" : "rgba(255, 255, 255, 0.13)", s = o ? "rgba(0, 0, 0, 0.12)" : "rgba(255, 255, 255, 0.12)";
    return f({
      position: "relative",
      backgroundColor: e.vars ? e.vars.palette.FilledInput.bg : a,
      borderTopLeftRadius: (e.vars || e).shape.borderRadius,
      borderTopRightRadius: (e.vars || e).shape.borderRadius,
      transition: e.transitions.create("background-color", {
        duration: e.transitions.duration.shorter,
        easing: e.transitions.easing.easeOut
      }),
      "&:hover": {
        backgroundColor: e.vars ? e.vars.palette.FilledInput.hoverBg : i,
        "@media (hover: none)": {
          backgroundColor: e.vars ? e.vars.palette.FilledInput.bg : a
        }
      },
      [`&.${Qt.focused}`]: {
        backgroundColor: e.vars ? e.vars.palette.FilledInput.bg : a
      },
      [`&.${Qt.disabled}`]: {
        backgroundColor: e.vars ? e.vars.palette.FilledInput.disabledBg : s
      }
    }, !t.disableUnderline && {
      "&::after": {
        borderBottom: `2px solid ${(n = (e.vars || e).palette[t.color || "primary"]) == null ? void 0 : n.main}`,
        left: 0,
        bottom: 0,
        content: '""',
        position: "absolute",
        right: 0,
        transform: "scaleX(0)",
        transition: e.transitions.create("transform", {
          duration: e.transitions.duration.shorter,
          easing: e.transitions.easing.easeOut
        }),
        pointerEvents: "none"
      },
      [`&.${Qt.focused}:after`]: {
        transform: "scaleX(1) translateX(0)"
      },
      [`&.${Qt.error}`]: {
        "&::before, &::after": {
          borderBottomColor: (e.vars || e).palette.error.main
        }
      },
      "&::before": {
        borderBottom: `1px solid ${e.vars ? `rgba(${e.vars.palette.common.onBackgroundChannel} / ${e.vars.opacity.inputUnderline})` : r}`,
        left: 0,
        bottom: 0,
        content: '"\\00a0"',
        position: "absolute",
        right: 0,
        transition: e.transitions.create("border-bottom-color", {
          duration: e.transitions.duration.shorter
        }),
        pointerEvents: "none"
      },
      [`&:hover:not(.${Qt.disabled}, .${Qt.error}):before`]: {
        borderBottom: `1px solid ${(e.vars || e).palette.text.primary}`
      },
      [`&.${Qt.disabled}:before`]: {
        borderBottomStyle: "dotted"
      }
    }, t.startAdornment && {
      paddingLeft: 12
    }, t.endAdornment && {
      paddingRight: 12
    }, t.multiline && f({
      padding: "25px 12px 8px"
    }, t.size === "small" && {
      paddingTop: 21,
      paddingBottom: 4
    }, t.hiddenLabel && {
      paddingTop: 16,
      paddingBottom: 17
    }, t.hiddenLabel && t.size === "small" && {
      paddingTop: 8,
      paddingBottom: 9
    }));
  }), q0 = G(Lr, {
    name: "MuiFilledInput",
    slot: "Input",
    overridesResolver: Mr
  })(({ theme: e, ownerState: t }) => f({
    paddingTop: 25,
    paddingRight: 12,
    paddingBottom: 8,
    paddingLeft: 12
  }, !e.vars && {
    "&:-webkit-autofill": {
      WebkitBoxShadow: e.palette.mode === "light" ? null : "0 0 0 100px #266798 inset",
      WebkitTextFillColor: e.palette.mode === "light" ? null : "#fff",
      caretColor: e.palette.mode === "light" ? null : "#fff",
      borderTopLeftRadius: "inherit",
      borderTopRightRadius: "inherit"
    }
  }, e.vars && {
    "&:-webkit-autofill": {
      borderTopLeftRadius: "inherit",
      borderTopRightRadius: "inherit"
    },
    [e.getColorSchemeSelector("dark")]: {
      "&:-webkit-autofill": {
        WebkitBoxShadow: "0 0 0 100px #266798 inset",
        WebkitTextFillColor: "#fff",
        caretColor: "#fff"
      }
    }
  }, t.size === "small" && {
    paddingTop: 21,
    paddingBottom: 4
  }, t.hiddenLabel && {
    paddingTop: 16,
    paddingBottom: 17
  }, t.startAdornment && {
    paddingLeft: 0
  }, t.endAdornment && {
    paddingRight: 0
  }, t.hiddenLabel && t.size === "small" && {
    paddingTop: 8,
    paddingBottom: 9
  }, t.multiline && {
    paddingTop: 0,
    paddingBottom: 0,
    paddingLeft: 0,
    paddingRight: 0
  })), du = W0.forwardRef(function(t, n) {
    var o, r, a, i;
    const s = Re({
      props: t,
      name: "MuiFilledInput"
    }), { components: l = {}, componentsProps: c, fullWidth: d = false, inputComponent: p = "input", multiline: m = false, slotProps: v, slots: g = {}, type: h = "text" } = s, C = ee(s, U0), $ = f({}, s, {
      fullWidth: d,
      inputComponent: p,
      multiline: m,
      type: h
    }), R = H0(s), b = {
      root: {
        ownerState: $
      },
      input: {
        ownerState: $
      }
    }, y = v ?? c ? at(b, v ?? c) : b, E = (o = (r = g.root) != null ? r : l.Root) != null ? o : K0, w = (a = (i = g.input) != null ? i : l.Input) != null ? a : q0;
    return u.jsx(_i, f({
      slots: {
        root: E,
        input: w
      },
      componentsProps: y,
      fullWidth: d,
      inputComponent: p,
      multiline: m,
      ref: n,
      type: h
    }, C, {
      classes: R
    }));
  });
  du.muiName = "Input";
  const pu = du;
  function G0(e) {
    return xe("MuiFormControl", e);
  }
  ye("MuiFormControl", [
    "root",
    "marginNone",
    "marginNormal",
    "marginDense",
    "fullWidth",
    "disabled"
  ]);
  const Y0 = [
    "children",
    "className",
    "color",
    "component",
    "disabled",
    "error",
    "focused",
    "fullWidth",
    "hiddenLabel",
    "margin",
    "required",
    "size",
    "variant"
  ], en = await M("react"), X0 = (e) => {
    const { classes: t, margin: n, fullWidth: o } = e, r = {
      root: [
        "root",
        n !== "none" && `margin${oe(n)}`,
        o && "fullWidth"
      ]
    };
    return Se(r, G0, t);
  }, Z0 = G("div", {
    name: "MuiFormControl",
    slot: "Root",
    overridesResolver: ({ ownerState: e }, t) => f({}, t.root, t[`margin${oe(e.margin)}`], e.fullWidth && t.fullWidth)
  })(({ ownerState: e }) => f({
    display: "inline-flex",
    flexDirection: "column",
    position: "relative",
    minWidth: 0,
    padding: 0,
    margin: 0,
    border: 0,
    verticalAlign: "top"
  }, e.margin === "normal" && {
    marginTop: 16,
    marginBottom: 8
  }, e.margin === "dense" && {
    marginTop: 8,
    marginBottom: 4
  }, e.fullWidth && {
    width: "100%"
  })), J0 = en.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiFormControl"
    }), { children: r, className: a, color: i = "primary", component: s = "div", disabled: l = false, error: c = false, focused: d, fullWidth: p = false, hiddenLabel: m = false, margin: v = "none", required: g = false, size: h = "medium", variant: C = "outlined" } = o, $ = ee(o, Y0), R = f({}, o, {
      color: i,
      component: s,
      disabled: l,
      error: c,
      fullWidth: p,
      hiddenLabel: m,
      margin: v,
      required: g,
      size: h,
      variant: C
    }), b = X0(R), [y, E] = en.useState(() => {
      let O = false;
      return r && en.Children.forEach(r, (B) => {
        if (!zo(B, [
          "Input",
          "Select"
        ]))
          return;
        const j = zo(B, [
          "Select"
        ]) ? B.props.input : B;
        j && Wv(j.props) && (O = true);
      }), O;
    }), [w, T] = en.useState(() => {
      let O = false;
      return r && en.Children.forEach(r, (B) => {
        zo(B, [
          "Input",
          "Select"
        ]) && (tr(B.props, true) || tr(B.props.inputProps, true)) && (O = true);
      }), O;
    }), [I, V] = en.useState(false);
    l && I && V(false);
    const P = d !== void 0 && !l ? d : I;
    let U;
    const F = en.useMemo(() => ({
      adornedStart: y,
      setAdornedStart: E,
      color: i,
      disabled: l,
      error: c,
      filled: w,
      focused: P,
      fullWidth: p,
      hiddenLabel: m,
      size: h,
      onBlur: () => {
        V(false);
      },
      onEmpty: () => {
        T(false);
      },
      onFilled: () => {
        T(true);
      },
      onFocus: () => {
        V(true);
      },
      registerEffect: U,
      required: g,
      variant: C
    }), [
      y,
      i,
      l,
      c,
      w,
      P,
      p,
      m,
      U,
      g,
      h,
      C
    ]);
    return u.jsx(kr.Provider, {
      value: F,
      children: u.jsx(Z0, f({
        as: s,
        ownerState: R,
        className: ae(b.root, a),
        ref: n
      }, $, {
        children: r
      }))
    });
  }), Q0 = J0;
  function ey(e) {
    return xe("MuiFormHelperText", e);
  }
  const ty = ye("MuiFormHelperText", [
    "root",
    "error",
    "disabled",
    "sizeSmall",
    "sizeMedium",
    "contained",
    "focused",
    "filled",
    "required"
  ]), rl = ty;
  var al;
  const ny = [
    "children",
    "className",
    "component",
    "disabled",
    "error",
    "filled",
    "focused",
    "margin",
    "required",
    "variant"
  ], oy = await M("react"), ry = (e) => {
    const { classes: t, contained: n, size: o, disabled: r, error: a, filled: i, focused: s, required: l } = e, c = {
      root: [
        "root",
        r && "disabled",
        a && "error",
        o && `size${oe(o)}`,
        n && "contained",
        s && "focused",
        i && "filled",
        l && "required"
      ]
    };
    return Se(c, ey, t);
  }, ay = G("p", {
    name: "MuiFormHelperText",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        n.size && t[`size${oe(n.size)}`],
        n.contained && t.contained,
        n.filled && t.filled
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    color: (e.vars || e).palette.text.secondary
  }, e.typography.caption, {
    textAlign: "left",
    marginTop: 3,
    marginRight: 0,
    marginBottom: 0,
    marginLeft: 0,
    [`&.${rl.disabled}`]: {
      color: (e.vars || e).palette.text.disabled
    },
    [`&.${rl.error}`]: {
      color: (e.vars || e).palette.error.main
    }
  }, t.size === "small" && {
    marginTop: 4
  }, t.contained && {
    marginLeft: 14,
    marginRight: 14
  })), iy = oy.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiFormHelperText"
    }), { children: r, className: a, component: i = "p" } = o, s = ee(o, ny), l = cn(), c = Nn({
      props: o,
      muiFormControl: l,
      states: [
        "variant",
        "size",
        "disabled",
        "error",
        "filled",
        "focused",
        "required"
      ]
    }), d = f({}, o, {
      component: i,
      contained: c.variant === "filled" || c.variant === "outlined",
      variant: c.variant,
      size: c.size,
      disabled: c.disabled,
      error: c.error,
      filled: c.filled,
      focused: c.focused,
      required: c.required
    }), p = ry(d);
    return u.jsx(ay, f({
      as: i,
      ownerState: d,
      className: ae(p.root, a),
      ref: n
    }, s, {
      children: r === " " ? al || (al = u.jsx("span", {
        className: "notranslate",
        children: "\u200B"
      })) : r
    }));
  }), sy = iy;
  function ly(e) {
    return xe("MuiFormLabel", e);
  }
  const cy = ye("MuiFormLabel", [
    "root",
    "colorSecondary",
    "focused",
    "disabled",
    "error",
    "filled",
    "required",
    "asterisk"
  ]), to = cy, uy = [
    "children",
    "className",
    "color",
    "component",
    "disabled",
    "error",
    "filled",
    "focused",
    "required"
  ], dy = await M("react"), py = (e) => {
    const { classes: t, color: n, focused: o, disabled: r, error: a, filled: i, required: s } = e, l = {
      root: [
        "root",
        `color${oe(n)}`,
        r && "disabled",
        a && "error",
        i && "filled",
        o && "focused",
        s && "required"
      ],
      asterisk: [
        "asterisk",
        a && "error"
      ]
    };
    return Se(l, ly, t);
  }, fy = G("label", {
    name: "MuiFormLabel",
    slot: "Root",
    overridesResolver: ({ ownerState: e }, t) => f({}, t.root, e.color === "secondary" && t.colorSecondary, e.filled && t.filled)
  })(({ theme: e, ownerState: t }) => f({
    color: (e.vars || e).palette.text.secondary
  }, e.typography.body1, {
    lineHeight: "1.4375em",
    padding: 0,
    position: "relative",
    [`&.${to.focused}`]: {
      color: (e.vars || e).palette[t.color].main
    },
    [`&.${to.disabled}`]: {
      color: (e.vars || e).palette.text.disabled
    },
    [`&.${to.error}`]: {
      color: (e.vars || e).palette.error.main
    }
  })), hy = G("span", {
    name: "MuiFormLabel",
    slot: "Asterisk",
    overridesResolver: (e, t) => t.asterisk
  })(({ theme: e }) => ({
    [`&.${to.error}`]: {
      color: (e.vars || e).palette.error.main
    }
  })), my = dy.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiFormLabel"
    }), { children: r, className: a, component: i = "label" } = o, s = ee(o, uy), l = cn(), c = Nn({
      props: o,
      muiFormControl: l,
      states: [
        "color",
        "required",
        "focused",
        "disabled",
        "error",
        "filled"
      ]
    }), d = f({}, o, {
      color: c.color || "primary",
      component: i,
      disabled: c.disabled,
      error: c.error,
      filled: c.filled,
      focused: c.focused,
      required: c.required
    }), p = py(d);
    return u.jsxs(fy, f({
      as: i,
      ownerState: d,
      className: ae(p.root, a),
      ref: n
    }, s, {
      children: [
        r,
        c.required && u.jsxs(hy, {
          ownerState: d,
          "aria-hidden": true,
          className: p.asterisk,
          children: [
            "\u2009",
            "*"
          ]
        })
      ]
    }));
  }), gy = my, vy = [
    "addEndListener",
    "appear",
    "children",
    "easing",
    "in",
    "onEnter",
    "onEntered",
    "onEntering",
    "onExit",
    "onExited",
    "onExiting",
    "style",
    "timeout",
    "TransitionComponent"
  ], Po = await M("react");
  function Ua(e) {
    return `scale(${e}, ${e ** 2})`;
  }
  const by = {
    entering: {
      opacity: 1,
      transform: Ua(1)
    },
    entered: {
      opacity: 1,
      transform: "none"
    }
  }, ma = typeof navigator < "u" && /^((?!chrome|android).)*(safari|mobile)/i.test(navigator.userAgent) && /(os |version\/)15(.|_)4/i.test(navigator.userAgent), fu = Po.forwardRef(function(t, n) {
    const { addEndListener: o, appear: r = true, children: a, easing: i, in: s, onEnter: l, onEntered: c, onEntering: d, onExit: p, onExited: m, onExiting: v, style: g, timeout: h = "auto", TransitionComponent: C = xi } = t, $ = ee(t, vy), R = hi(), b = Po.useRef(), y = $r(), E = Po.useRef(null), w = Ve(E, fo(a), n), T = (j) => (W) => {
      if (j) {
        const H = E.current;
        W === void 0 ? j(H) : j(H, W);
      }
    }, I = T(d), V = T((j, W) => {
      ou(j);
      const { duration: H, delay: D, easing: me } = $n({
        style: g,
        timeout: h,
        easing: i
      }, {
        mode: "enter"
      });
      let ne;
      h === "auto" ? (ne = y.transitions.getAutoHeightDuration(j.clientHeight), b.current = ne) : ne = H, j.style.transition = [
        y.transitions.create("opacity", {
          duration: ne,
          delay: D
        }),
        y.transitions.create("transform", {
          duration: ma ? ne : ne * 0.666,
          delay: D,
          easing: me
        })
      ].join(","), l && l(j, W);
    }), P = T(c), U = T(v), F = T((j) => {
      const { duration: W, delay: H, easing: D } = $n({
        style: g,
        timeout: h,
        easing: i
      }, {
        mode: "exit"
      });
      let me;
      h === "auto" ? (me = y.transitions.getAutoHeightDuration(j.clientHeight), b.current = me) : me = W, j.style.transition = [
        y.transitions.create("opacity", {
          duration: me,
          delay: H
        }),
        y.transitions.create("transform", {
          duration: ma ? me : me * 0.666,
          delay: ma ? H : H || me * 0.333,
          easing: D
        })
      ].join(","), j.style.opacity = 0, j.style.transform = Ua(0.75), p && p(j);
    }), O = T(m), B = (j) => {
      h === "auto" && R.start(b.current || 0, j), o && o(E.current, j);
    };
    return u.jsx(C, f({
      appear: r,
      in: s,
      nodeRef: E,
      onEnter: V,
      onEntered: P,
      onEntering: I,
      onExit: F,
      onExited: O,
      onExiting: U,
      addEndListener: B,
      timeout: h === "auto" ? null : h
    }, $, {
      children: (j, W) => Po.cloneElement(a, f({
        style: f({
          opacity: 0,
          transform: Ua(0.75),
          visibility: j === "exited" && !s ? "hidden" : void 0
        }, by[j], g, a.props.style),
        ref: w
      }, W))
    }));
  });
  fu.muiSupportAuto = true;
  const yy = fu, xy = [
    "disableUnderline",
    "components",
    "componentsProps",
    "fullWidth",
    "inputComponent",
    "multiline",
    "slotProps",
    "slots",
    "type"
  ], Sy = await M("react"), Ry = (e) => {
    const { classes: t, disableUnderline: n } = e, r = Se({
      root: [
        "root",
        !n && "underline"
      ],
      input: [
        "input"
      ]
    }, Zv, t);
    return f({}, t, r);
  }, _y = G(Pr, {
    shouldForwardProp: (e) => xt(e) || e === "classes",
    name: "MuiInput",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        ...Ar(e, t),
        !n.disableUnderline && t.underline
      ];
    }
  })(({ theme: e, ownerState: t }) => {
    let o = e.palette.mode === "light" ? "rgba(0, 0, 0, 0.42)" : "rgba(255, 255, 255, 0.7)";
    return e.vars && (o = `rgba(${e.vars.palette.common.onBackgroundChannel} / ${e.vars.opacity.inputUnderline})`), f({
      position: "relative"
    }, t.formControl && {
      "label + &": {
        marginTop: 16
      }
    }, !t.disableUnderline && {
      "&::after": {
        borderBottom: `2px solid ${(e.vars || e).palette[t.color].main}`,
        left: 0,
        bottom: 0,
        content: '""',
        position: "absolute",
        right: 0,
        transform: "scaleX(0)",
        transition: e.transitions.create("transform", {
          duration: e.transitions.duration.shorter,
          easing: e.transitions.easing.easeOut
        }),
        pointerEvents: "none"
      },
      [`&.${Vn.focused}:after`]: {
        transform: "scaleX(1) translateX(0)"
      },
      [`&.${Vn.error}`]: {
        "&::before, &::after": {
          borderBottomColor: (e.vars || e).palette.error.main
        }
      },
      "&::before": {
        borderBottom: `1px solid ${o}`,
        left: 0,
        bottom: 0,
        content: '"\\00a0"',
        position: "absolute",
        right: 0,
        transition: e.transitions.create("border-bottom-color", {
          duration: e.transitions.duration.shorter
        }),
        pointerEvents: "none"
      },
      [`&:hover:not(.${Vn.disabled}, .${Vn.error}):before`]: {
        borderBottom: `2px solid ${(e.vars || e).palette.text.primary}`,
        "@media (hover: none)": {
          borderBottom: `1px solid ${o}`
        }
      },
      [`&.${Vn.disabled}:before`]: {
        borderBottomStyle: "dotted"
      }
    });
  }), Cy = G(Lr, {
    name: "MuiInput",
    slot: "Input",
    overridesResolver: Mr
  })({}), hu = Sy.forwardRef(function(t, n) {
    var o, r, a, i;
    const s = Re({
      props: t,
      name: "MuiInput"
    }), { disableUnderline: l, components: c = {}, componentsProps: d, fullWidth: p = false, inputComponent: m = "input", multiline: v = false, slotProps: g, slots: h = {}, type: C = "text" } = s, $ = ee(s, xy), R = Ry(s), y = {
      root: {
        ownerState: {
          disableUnderline: l
        }
      }
    }, E = g ?? d ? at(g ?? d, y) : y, w = (o = (r = h.root) != null ? r : c.Root) != null ? o : _y, T = (a = (i = h.input) != null ? i : c.Input) != null ? a : Cy;
    return u.jsx(_i, f({
      slots: {
        root: w,
        input: T
      },
      slotProps: E,
      fullWidth: p,
      inputComponent: m,
      multiline: v,
      ref: n,
      type: C
    }, $, {
      classes: R
    }));
  });
  hu.muiName = "Input";
  const mu = hu;
  function wy(e) {
    return xe("MuiInputAdornment", e);
  }
  const $y = ye("MuiInputAdornment", [
    "root",
    "filled",
    "standard",
    "outlined",
    "positionStart",
    "positionEnd",
    "disablePointerEvents",
    "hiddenLabel",
    "sizeSmall"
  ]), il = $y;
  var sl;
  const Ey = [
    "children",
    "className",
    "component",
    "disablePointerEvents",
    "disableTypography",
    "position",
    "variant"
  ], ll = await M("react"), Ty = (e, t) => {
    const { ownerState: n } = e;
    return [
      t.root,
      t[`position${oe(n.position)}`],
      n.disablePointerEvents === true && t.disablePointerEvents,
      t[n.variant]
    ];
  }, ky = (e) => {
    const { classes: t, disablePointerEvents: n, hiddenLabel: o, position: r, size: a, variant: i } = e, s = {
      root: [
        "root",
        n && "disablePointerEvents",
        r && `position${oe(r)}`,
        i,
        o && "hiddenLabel",
        a && `size${oe(a)}`
      ]
    };
    return Se(s, wy, t);
  }, Ay = G("div", {
    name: "MuiInputAdornment",
    slot: "Root",
    overridesResolver: Ty
  })(({ theme: e, ownerState: t }) => f({
    display: "flex",
    height: "0.01em",
    maxHeight: "2em",
    alignItems: "center",
    whiteSpace: "nowrap",
    color: (e.vars || e).palette.action.active
  }, t.variant === "filled" && {
    [`&.${il.positionStart}&:not(.${il.hiddenLabel})`]: {
      marginTop: 16
    }
  }, t.position === "start" && {
    marginRight: 8
  }, t.position === "end" && {
    marginLeft: 8
  }, t.disablePointerEvents === true && {
    pointerEvents: "none"
  })), My = ll.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiInputAdornment"
    }), { children: r, className: a, component: i = "div", disablePointerEvents: s = false, disableTypography: l = false, position: c, variant: d } = o, p = ee(o, Ey), m = cn() || {};
    let v = d;
    d && m.variant, m && !v && (v = m.variant);
    const g = f({}, o, {
      hiddenLabel: m.hiddenLabel,
      size: m.size,
      disablePointerEvents: s,
      position: c,
      variant: v
    }), h = ky(g);
    return u.jsx(kr.Provider, {
      value: null,
      children: u.jsx(Ay, f({
        as: i,
        ownerState: g,
        className: ae(h.root, a),
        ref: n
      }, p, {
        children: typeof r == "string" && !l ? u.jsx(er, {
          color: "text.secondary",
          children: r
        }) : u.jsxs(ll.Fragment, {
          children: [
            c === "start" ? sl || (sl = u.jsx("span", {
              className: "notranslate",
              children: "\u200B"
            })) : null,
            r
          ]
        })
      }))
    });
  }), Py = My;
  function Ly(e) {
    return xe("MuiInputLabel", e);
  }
  ye("MuiInputLabel", [
    "root",
    "focused",
    "disabled",
    "error",
    "required",
    "asterisk",
    "formControl",
    "sizeSmall",
    "shrink",
    "animated",
    "standard",
    "filled",
    "outlined"
  ]);
  const Iy = [
    "disableAnimation",
    "margin",
    "shrink",
    "variant",
    "className"
  ], Ny = await M("react"), Fy = (e) => {
    const { classes: t, formControl: n, size: o, shrink: r, disableAnimation: a, variant: i, required: s } = e, l = {
      root: [
        "root",
        n && "formControl",
        !a && "animated",
        r && "shrink",
        o && o !== "normal" && `size${oe(o)}`,
        i
      ],
      asterisk: [
        s && "asterisk"
      ]
    }, c = Se(l, Ly, t);
    return f({}, t, c);
  }, Oy = G(gy, {
    shouldForwardProp: (e) => xt(e) || e === "classes",
    name: "MuiInputLabel",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        {
          [`& .${to.asterisk}`]: t.asterisk
        },
        t.root,
        n.formControl && t.formControl,
        n.size === "small" && t.sizeSmall,
        n.shrink && t.shrink,
        !n.disableAnimation && t.animated,
        n.focused && t.focused,
        t[n.variant]
      ];
    }
  })(({ theme: e, ownerState: t }) => f({
    display: "block",
    transformOrigin: "top left",
    whiteSpace: "nowrap",
    overflow: "hidden",
    textOverflow: "ellipsis",
    maxWidth: "100%"
  }, t.formControl && {
    position: "absolute",
    left: 0,
    top: 0,
    transform: "translate(0, 20px) scale(1)"
  }, t.size === "small" && {
    transform: "translate(0, 17px) scale(1)"
  }, t.shrink && {
    transform: "translate(0, -1.5px) scale(0.75)",
    transformOrigin: "top left",
    maxWidth: "133%"
  }, !t.disableAnimation && {
    transition: e.transitions.create([
      "color",
      "transform",
      "max-width"
    ], {
      duration: e.transitions.duration.shorter,
      easing: e.transitions.easing.easeOut
    })
  }, t.variant === "filled" && f({
    zIndex: 1,
    pointerEvents: "none",
    transform: "translate(12px, 16px) scale(1)",
    maxWidth: "calc(100% - 24px)"
  }, t.size === "small" && {
    transform: "translate(12px, 13px) scale(1)"
  }, t.shrink && f({
    userSelect: "none",
    pointerEvents: "auto",
    transform: "translate(12px, 7px) scale(0.75)",
    maxWidth: "calc(133% - 24px)"
  }, t.size === "small" && {
    transform: "translate(12px, 4px) scale(0.75)"
  })), t.variant === "outlined" && f({
    zIndex: 1,
    pointerEvents: "none",
    transform: "translate(14px, 16px) scale(1)",
    maxWidth: "calc(100% - 24px)"
  }, t.size === "small" && {
    transform: "translate(14px, 9px) scale(1)"
  }, t.shrink && {
    userSelect: "none",
    pointerEvents: "auto",
    maxWidth: "calc(133% - 32px)",
    transform: "translate(14px, -9px) scale(0.75)"
  }))), By = Ny.forwardRef(function(t, n) {
    const o = Re({
      name: "MuiInputLabel",
      props: t
    }), { disableAnimation: r = false, shrink: a, className: i } = o, s = ee(o, Iy), l = cn();
    let c = a;
    typeof c > "u" && l && (c = l.filled || l.focused || l.adornedStart);
    const d = Nn({
      props: o,
      muiFormControl: l,
      states: [
        "size",
        "variant",
        "required",
        "focused"
      ]
    }), p = f({}, o, {
      disableAnimation: r,
      formControl: l,
      shrink: c,
      size: d.size,
      variant: d.variant,
      required: d.required,
      focused: d.focused
    }), m = Fy(p);
    return u.jsx(Oy, f({
      "data-shrink": c,
      ownerState: p,
      ref: n,
      className: ae(m.root, i)
    }, s, {
      classes: m
    }));
  }), Dy = By, jy = await M("react"), zy = jy.createContext({}), Vy = zy;
  function Uy(e) {
    return xe("MuiList", e);
  }
  ye("MuiList", [
    "root",
    "padding",
    "dense",
    "subheader"
  ]);
  const Wy = [
    "children",
    "className",
    "component",
    "dense",
    "disablePadding",
    "subheader"
  ], cl = await M("react"), Hy = (e) => {
    const { classes: t, disablePadding: n, dense: o, subheader: r } = e;
    return Se({
      root: [
        "root",
        !n && "padding",
        o && "dense",
        r && "subheader"
      ]
    }, Uy, t);
  }, Ky = G("ul", {
    name: "MuiList",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        !n.disablePadding && t.padding,
        n.dense && t.dense,
        n.subheader && t.subheader
      ];
    }
  })(({ ownerState: e }) => f({
    listStyle: "none",
    margin: 0,
    padding: 0,
    position: "relative"
  }, !e.disablePadding && {
    paddingTop: 8,
    paddingBottom: 8
  }, e.subheader && {
    paddingTop: 0
  })), qy = cl.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiList"
    }), { children: r, className: a, component: i = "ul", dense: s = false, disablePadding: l = false, subheader: c } = o, d = ee(o, Wy), p = cl.useMemo(() => ({
      dense: s
    }), [
      s
    ]), m = f({}, o, {
      component: i,
      dense: s,
      disablePadding: l
    }), v = Hy(m);
    return u.jsx(Vy.Provider, {
      value: p,
      children: u.jsxs(Ky, f({
        as: i,
        className: ae(v.root, a),
        ref: n,
        ownerState: m
      }, d, {
        children: [
          c,
          r
        ]
      }))
    });
  }), Gy = qy, Yy = [
    "actions",
    "autoFocus",
    "autoFocusItem",
    "children",
    "className",
    "disabledItemsFocusable",
    "disableListWrap",
    "onKeyDown",
    "variant"
  ], zt = await M("react");
  function ga(e, t, n) {
    return e === t ? e.firstChild : t && t.nextElementSibling ? t.nextElementSibling : n ? null : e.firstChild;
  }
  function ul(e, t, n) {
    return e === t ? n ? e.firstChild : e.lastChild : t && t.previousElementSibling ? t.previousElementSibling : n ? null : e.lastChild;
  }
  function gu(e, t) {
    if (t === void 0)
      return true;
    let n = e.innerText;
    return n === void 0 && (n = e.textContent), n = n.trim().toLowerCase(), n.length === 0 ? false : t.repeating ? n[0] === t.keys[0] : n.indexOf(t.keys.join("")) === 0;
  }
  function Un(e, t, n, o, r, a) {
    let i = false, s = r(e, t, t ? n : false);
    for (; s; ) {
      if (s === e.firstChild) {
        if (i)
          return false;
        i = true;
      }
      const l = o ? false : s.disabled || s.getAttribute("aria-disabled") === "true";
      if (!s.hasAttribute("tabindex") || !gu(s, a) || l)
        s = r(e, s, n);
      else
        return s.focus(), true;
    }
    return false;
  }
  const Xy = zt.forwardRef(function(t, n) {
    const { actions: o, autoFocus: r = false, autoFocusItem: a = false, children: i, className: s, disabledItemsFocusable: l = false, disableListWrap: c = false, onKeyDown: d, variant: p = "selectedMenu" } = t, m = ee(t, Yy), v = zt.useRef(null), g = zt.useRef({
      keys: [],
      repeating: true,
      previousKeyMatched: true,
      lastTime: null
    });
    Lt(() => {
      r && v.current.focus();
    }, [
      r
    ]), zt.useImperativeHandle(o, () => ({
      adjustStyleForScrollbar: (b, { direction: y }) => {
        const E = !v.current.style.width;
        if (b.clientHeight < v.current.clientHeight && E) {
          const w = `${Nc(Xe(b))}px`;
          v.current.style[y === "rtl" ? "paddingLeft" : "paddingRight"] = w, v.current.style.width = `calc(100% + ${w})`;
        }
        return v.current;
      }
    }), []);
    const h = (b) => {
      const y = v.current, E = b.key, w = Xe(y).activeElement;
      if (E === "ArrowDown")
        b.preventDefault(), Un(y, w, c, l, ga);
      else if (E === "ArrowUp")
        b.preventDefault(), Un(y, w, c, l, ul);
      else if (E === "Home")
        b.preventDefault(), Un(y, null, c, l, ga);
      else if (E === "End")
        b.preventDefault(), Un(y, null, c, l, ul);
      else if (E.length === 1) {
        const T = g.current, I = E.toLowerCase(), V = performance.now();
        T.keys.length > 0 && (V - T.lastTime > 500 ? (T.keys = [], T.repeating = true, T.previousKeyMatched = true) : T.repeating && I !== T.keys[0] && (T.repeating = false)), T.lastTime = V, T.keys.push(I);
        const P = w && !T.repeating && gu(w, T);
        T.previousKeyMatched && (P || Un(y, w, false, l, ga, T)) ? b.preventDefault() : T.previousKeyMatched = false;
      }
      d && d(b);
    }, C = Ve(v, n);
    let $ = -1;
    zt.Children.forEach(i, (b, y) => {
      if (!zt.isValidElement(b)) {
        $ === y && ($ += 1, $ >= i.length && ($ = -1));
        return;
      }
      b.props.disabled || (p === "selectedMenu" && b.props.selected || $ === -1) && ($ = y), $ === y && (b.props.disabled || b.props.muiSkipListHighlight || b.type.muiSkipListHighlight) && ($ += 1, $ >= i.length && ($ = -1));
    });
    const R = zt.Children.map(i, (b, y) => {
      if (y === $) {
        const E = {};
        return a && (E.autoFocus = true), b.props.tabIndex === void 0 && p === "selectedMenu" && (E.tabIndex = 0), zt.cloneElement(b, E);
      }
      return b;
    });
    return u.jsx(Gy, f({
      role: "menu",
      ref: C,
      className: s,
      onKeyDown: h,
      tabIndex: r ? 0 : -1
    }, m, {
      children: R
    }));
  }), Zy = Xy;
  function Jy(e) {
    return xe("MuiPopover", e);
  }
  ye("MuiPopover", [
    "root",
    "paper"
  ]);
  const Qy = [
    "onEntering"
  ], e1 = [
    "action",
    "anchorEl",
    "anchorOrigin",
    "anchorPosition",
    "anchorReference",
    "children",
    "className",
    "container",
    "elevation",
    "marginThreshold",
    "open",
    "PaperProps",
    "slots",
    "slotProps",
    "transformOrigin",
    "TransitionComponent",
    "transitionDuration",
    "TransitionProps",
    "disableScrollLock"
  ], t1 = [
    "slotProps"
  ], vt = await M("react");
  function dl(e, t) {
    let n = 0;
    return typeof t == "number" ? n = t : t === "center" ? n = e.height / 2 : t === "bottom" && (n = e.height), n;
  }
  function pl(e, t) {
    let n = 0;
    return typeof t == "number" ? n = t : t === "center" ? n = e.width / 2 : t === "right" && (n = e.width), n;
  }
  function fl(e) {
    return [
      e.horizontal,
      e.vertical
    ].map((t) => typeof t == "number" ? `${t}px` : t).join(" ");
  }
  function va(e) {
    return typeof e == "function" ? e() : e;
  }
  const n1 = (e) => {
    const { classes: t } = e;
    return Se({
      root: [
        "root"
      ],
      paper: [
        "paper"
      ]
    }, Jy, t);
  }, o1 = G(cu, {
    name: "MuiPopover",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })({}), vu = G(Er, {
    name: "MuiPopover",
    slot: "Paper",
    overridesResolver: (e, t) => t.paper
  })({
    position: "absolute",
    overflowY: "auto",
    overflowX: "hidden",
    minWidth: 16,
    minHeight: 16,
    maxWidth: "calc(100% - 32px)",
    maxHeight: "calc(100% - 32px)",
    outline: 0
  }), r1 = vt.forwardRef(function(t, n) {
    var o, r, a;
    const i = Re({
      props: t,
      name: "MuiPopover"
    }), { action: s, anchorEl: l, anchorOrigin: c = {
      vertical: "top",
      horizontal: "left"
    }, anchorPosition: d, anchorReference: p = "anchorEl", children: m, className: v, container: g, elevation: h = 8, marginThreshold: C = 16, open: $, PaperProps: R = {}, slots: b, slotProps: y, transformOrigin: E = {
      vertical: "top",
      horizontal: "left"
    }, TransitionComponent: w = yy, transitionDuration: T = "auto", TransitionProps: { onEntering: I } = {}, disableScrollLock: V = false } = i, P = ee(i.TransitionProps, Qy), U = ee(i, e1), F = (o = y == null ? void 0 : y.paper) != null ? o : R, O = vt.useRef(), B = Ve(O, F.ref), j = f({}, i, {
      anchorOrigin: c,
      anchorReference: p,
      elevation: h,
      marginThreshold: C,
      externalPaperSlotProps: F,
      transformOrigin: E,
      TransitionComponent: w,
      transitionDuration: T,
      TransitionProps: P
    }), W = n1(j), H = vt.useCallback(() => {
      if (p === "anchorPosition")
        return d;
      const te = va(l), _e = (te && te.nodeType === 1 ? te : Xe(O.current).body).getBoundingClientRect();
      return {
        top: _e.top + dl(_e, c.vertical),
        left: _e.left + pl(_e, c.horizontal)
      };
    }, [
      l,
      c.horizontal,
      c.vertical,
      d,
      p
    ]), D = vt.useCallback((te) => ({
      vertical: dl(te, E.vertical),
      horizontal: pl(te, E.horizontal)
    }), [
      E.horizontal,
      E.vertical
    ]), me = vt.useCallback((te) => {
      const ge = {
        width: te.offsetWidth,
        height: te.offsetHeight
      }, _e = D(ge);
      if (p === "none")
        return {
          top: null,
          left: null,
          transformOrigin: fl(_e)
        };
      const Be = H();
      let ke = Be.top - _e.vertical, Ke = Be.left - _e.horizontal;
      const et = ke + ge.height, Ue = Ke + ge.width, Ae = qt(va(l)), it = Ae.innerHeight - C, We = Ae.innerWidth - C;
      if (C !== null && ke < C) {
        const Ce = ke - C;
        ke -= Ce, _e.vertical += Ce;
      } else if (C !== null && et > it) {
        const Ce = et - it;
        ke -= Ce, _e.vertical += Ce;
      }
      if (C !== null && Ke < C) {
        const Ce = Ke - C;
        Ke -= Ce, _e.horizontal += Ce;
      } else if (Ue > We) {
        const Ce = Ue - We;
        Ke -= Ce, _e.horizontal += Ce;
      }
      return {
        top: `${Math.round(ke)}px`,
        left: `${Math.round(Ke)}px`,
        transformOrigin: fl(_e)
      };
    }, [
      l,
      p,
      H,
      D,
      C
    ]), [ne, de] = vt.useState($), _ = vt.useCallback(() => {
      const te = O.current;
      if (!te)
        return;
      const ge = me(te);
      ge.top !== null && (te.style.top = ge.top), ge.left !== null && (te.style.left = ge.left), te.style.transformOrigin = ge.transformOrigin, de(true);
    }, [
      me
    ]);
    vt.useEffect(() => (V && window.addEventListener("scroll", _), () => window.removeEventListener("scroll", _)), [
      l,
      V,
      _
    ]);
    const L = (te, ge) => {
      I && I(te, ge), _();
    }, A = () => {
      de(false);
    };
    vt.useEffect(() => {
      $ && _();
    }), vt.useImperativeHandle(s, () => $ ? {
      updatePosition: () => {
        _();
      }
    } : null, [
      $,
      _
    ]), vt.useEffect(() => {
      if (!$)
        return;
      const te = fi(() => {
        _();
      }), ge = qt(l);
      return ge.addEventListener("resize", te), () => {
        te.clear(), ge.removeEventListener("resize", te);
      };
    }, [
      l,
      $,
      _
    ]);
    let Y = T;
    T === "auto" && !w.muiSupportAuto && (Y = void 0);
    const k = g || (l ? Xe(va(l)).body : void 0), Z = (r = b == null ? void 0 : b.root) != null ? r : o1, Q = (a = b == null ? void 0 : b.paper) != null ? a : vu, z = wn({
      elementType: Q,
      externalSlotProps: f({}, F, {
        style: ne ? F.style : f({}, F.style, {
          opacity: 0
        })
      }),
      additionalProps: {
        elevation: h,
        ref: B
      },
      ownerState: j,
      className: ae(W.paper, F == null ? void 0 : F.className)
    }), fe = wn({
      elementType: Z,
      externalSlotProps: (y == null ? void 0 : y.root) || {},
      externalForwardedProps: U,
      additionalProps: {
        ref: n,
        slotProps: {
          backdrop: {
            invisible: true
          }
        },
        container: k,
        open: $
      },
      ownerState: j,
      className: ae(W.root, v)
    }), { slotProps: re } = fe, ie = ee(fe, t1);
    return u.jsx(Z, f({}, ie, !Xo(Z) && {
      slotProps: re,
      disableScrollLock: V
    }, {
      children: u.jsx(w, f({
        appear: true,
        in: $,
        onEntering: L,
        onExited: A,
        timeout: Y
      }, P, {
        children: u.jsx(Q, f({}, z, {
          children: m
        }))
      }))
    }));
  }), a1 = r1;
  function i1(e) {
    return xe("MuiMenu", e);
  }
  ye("MuiMenu", [
    "root",
    "paper",
    "list"
  ]);
  const s1 = [
    "onEntering"
  ], l1 = [
    "autoFocus",
    "children",
    "className",
    "disableAutoFocusItem",
    "MenuListProps",
    "onClose",
    "open",
    "PaperProps",
    "PopoverClasses",
    "transitionDuration",
    "TransitionProps",
    "variant",
    "slots",
    "slotProps"
  ], Lo = await M("react"), c1 = {
    vertical: "top",
    horizontal: "right"
  }, u1 = {
    vertical: "top",
    horizontal: "left"
  }, d1 = (e) => {
    const { classes: t } = e;
    return Se({
      root: [
        "root"
      ],
      paper: [
        "paper"
      ],
      list: [
        "list"
      ]
    }, i1, t);
  }, p1 = G(a1, {
    shouldForwardProp: (e) => xt(e) || e === "classes",
    name: "MuiMenu",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })({}), f1 = G(vu, {
    name: "MuiMenu",
    slot: "Paper",
    overridesResolver: (e, t) => t.paper
  })({
    maxHeight: "calc(100% - 96px)",
    WebkitOverflowScrolling: "touch"
  }), h1 = G(Zy, {
    name: "MuiMenu",
    slot: "List",
    overridesResolver: (e, t) => t.list
  })({
    outline: 0
  }), m1 = Lo.forwardRef(function(t, n) {
    var o, r;
    const a = Re({
      props: t,
      name: "MuiMenu"
    }), { autoFocus: i = true, children: s, className: l, disableAutoFocusItem: c = false, MenuListProps: d = {}, onClose: p, open: m, PaperProps: v = {}, PopoverClasses: g, transitionDuration: h = "auto", TransitionProps: { onEntering: C } = {}, variant: $ = "selectedMenu", slots: R = {}, slotProps: b = {} } = a, y = ee(a.TransitionProps, s1), E = ee(a, l1), w = Oh(), T = f({}, a, {
      autoFocus: i,
      disableAutoFocusItem: c,
      MenuListProps: d,
      onEntering: C,
      PaperProps: v,
      transitionDuration: h,
      TransitionProps: y,
      variant: $
    }), I = d1(T), V = i && !c && m, P = Lo.useRef(null), U = (D, me) => {
      P.current && P.current.adjustStyleForScrollbar(D, {
        direction: w ? "rtl" : "ltr"
      }), C && C(D, me);
    }, F = (D) => {
      D.key === "Tab" && (D.preventDefault(), p && p(D, "tabKeyDown"));
    };
    let O = -1;
    Lo.Children.map(s, (D, me) => {
      Lo.isValidElement(D) && (D.props.disabled || ($ === "selectedMenu" && D.props.selected || O === -1) && (O = me));
    });
    const B = (o = R.paper) != null ? o : f1, j = (r = b.paper) != null ? r : v, W = wn({
      elementType: R.root,
      externalSlotProps: b.root,
      ownerState: T,
      className: [
        I.root,
        l
      ]
    }), H = wn({
      elementType: B,
      externalSlotProps: j,
      ownerState: T,
      className: I.paper
    });
    return u.jsx(p1, f({
      onClose: p,
      anchorOrigin: {
        vertical: "bottom",
        horizontal: w ? "right" : "left"
      },
      transformOrigin: w ? c1 : u1,
      slots: {
        paper: B,
        root: R.root
      },
      slotProps: {
        root: W,
        paper: H
      },
      open: m,
      ref: n,
      transitionDuration: h,
      TransitionProps: f({
        onEntering: U
      }, y),
      ownerState: T
    }, E, {
      classes: g,
      children: u.jsx(h1, f({
        onKeyDown: F,
        actions: P,
        autoFocus: i && (O === -1 || c),
        autoFocusItem: V,
        variant: $
      }, d, {
        className: ae(I.list, d.className),
        children: s
      }))
    }));
  }), g1 = m1;
  function v1(e) {
    return xe("MuiNativeSelect", e);
  }
  const b1 = ye("MuiNativeSelect", [
    "root",
    "select",
    "multiple",
    "filled",
    "outlined",
    "standard",
    "disabled",
    "icon",
    "iconOpen",
    "iconFilled",
    "iconOutlined",
    "iconStandard",
    "nativeInput",
    "error"
  ]), Ci = b1, y1 = [
    "className",
    "disabled",
    "error",
    "IconComponent",
    "inputRef",
    "variant"
  ], hl = await M("react"), x1 = (e) => {
    const { classes: t, variant: n, disabled: o, multiple: r, open: a, error: i } = e, s = {
      select: [
        "select",
        n,
        o && "disabled",
        r && "multiple",
        i && "error"
      ],
      icon: [
        "icon",
        `icon${oe(n)}`,
        a && "iconOpen",
        o && "disabled"
      ]
    };
    return Se(s, v1, t);
  }, bu = ({ ownerState: e, theme: t }) => f({
    MozAppearance: "none",
    WebkitAppearance: "none",
    userSelect: "none",
    borderRadius: 0,
    cursor: "pointer",
    "&:focus": f({}, t.vars ? {
      backgroundColor: `rgba(${t.vars.palette.common.onBackgroundChannel} / 0.05)`
    } : {
      backgroundColor: t.palette.mode === "light" ? "rgba(0, 0, 0, 0.05)" : "rgba(255, 255, 255, 0.05)"
    }, {
      borderRadius: 0
    }),
    "&::-ms-expand": {
      display: "none"
    },
    [`&.${Ci.disabled}`]: {
      cursor: "default"
    },
    "&[multiple]": {
      height: "auto"
    },
    "&:not([multiple]) option, &:not([multiple]) optgroup": {
      backgroundColor: (t.vars || t).palette.background.paper
    },
    "&&&": {
      paddingRight: 24,
      minWidth: 16
    }
  }, e.variant === "filled" && {
    "&&&": {
      paddingRight: 32
    }
  }, e.variant === "outlined" && {
    borderRadius: (t.vars || t).shape.borderRadius,
    "&:focus": {
      borderRadius: (t.vars || t).shape.borderRadius
    },
    "&&&": {
      paddingRight: 32
    }
  }), S1 = G("select", {
    name: "MuiNativeSelect",
    slot: "Select",
    shouldForwardProp: xt,
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.select,
        t[n.variant],
        n.error && t.error,
        {
          [`&.${Ci.multiple}`]: t.multiple
        }
      ];
    }
  })(bu), yu = ({ ownerState: e, theme: t }) => f({
    position: "absolute",
    right: 0,
    top: "calc(50% - .5em)",
    pointerEvents: "none",
    color: (t.vars || t).palette.action.active,
    [`&.${Ci.disabled}`]: {
      color: (t.vars || t).palette.action.disabled
    }
  }, e.open && {
    transform: "rotate(180deg)"
  }, e.variant === "filled" && {
    right: 7
  }, e.variant === "outlined" && {
    right: 7
  }), R1 = G("svg", {
    name: "MuiNativeSelect",
    slot: "Icon",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.icon,
        n.variant && t[`icon${oe(n.variant)}`],
        n.open && t.iconOpen
      ];
    }
  })(yu), _1 = hl.forwardRef(function(t, n) {
    const { className: o, disabled: r, error: a, IconComponent: i, inputRef: s, variant: l = "standard" } = t, c = ee(t, y1), d = f({}, t, {
      disabled: r,
      variant: l,
      error: a
    }), p = x1(d);
    return u.jsxs(hl.Fragment, {
      children: [
        u.jsx(S1, f({
          ownerState: d,
          className: ae(p.select, o),
          disabled: r,
          ref: s || n
        }, c)),
        t.multiple ? null : u.jsx(R1, {
          as: i,
          ownerState: d,
          className: p.icon
        })
      ]
    });
  }), C1 = _1;
  var ml;
  const w1 = [
    "children",
    "classes",
    "className",
    "label",
    "notched"
  ];
  await M("react");
  const $1 = G("fieldset", {
    name: "MuiNotchedOutlined",
    shouldForwardProp: xt
  })({
    textAlign: "left",
    position: "absolute",
    bottom: 0,
    right: 0,
    top: -5,
    left: 0,
    margin: 0,
    padding: "0 8px",
    pointerEvents: "none",
    borderRadius: "inherit",
    borderStyle: "solid",
    borderWidth: 1,
    overflow: "hidden",
    minWidth: "0%"
  }), E1 = G("legend", {
    name: "MuiNotchedOutlined",
    shouldForwardProp: xt
  })(({ ownerState: e, theme: t }) => f({
    float: "unset",
    width: "auto",
    overflow: "hidden"
  }, !e.withLabel && {
    padding: 0,
    lineHeight: "11px",
    transition: t.transitions.create("width", {
      duration: 150,
      easing: t.transitions.easing.easeOut
    })
  }, e.withLabel && f({
    display: "block",
    padding: 0,
    height: 11,
    fontSize: "0.75em",
    visibility: "hidden",
    maxWidth: 0.01,
    transition: t.transitions.create("max-width", {
      duration: 50,
      easing: t.transitions.easing.easeOut
    }),
    whiteSpace: "nowrap",
    "& > span": {
      paddingLeft: 5,
      paddingRight: 5,
      display: "inline-block",
      opacity: 0,
      visibility: "visible"
    }
  }, e.notched && {
    maxWidth: "100%",
    transition: t.transitions.create("max-width", {
      duration: 100,
      easing: t.transitions.easing.easeOut,
      delay: 50
    })
  })));
  function T1(e) {
    const { className: t, label: n, notched: o } = e, r = ee(e, w1), a = n != null && n !== "", i = f({}, e, {
      notched: o,
      withLabel: a
    });
    return u.jsx($1, f({
      "aria-hidden": true,
      className: t,
      ownerState: i
    }, r, {
      children: u.jsx(E1, {
        ownerState: i,
        children: a ? u.jsx("span", {
          children: n
        }) : ml || (ml = u.jsx("span", {
          className: "notranslate",
          children: "\u200B"
        }))
      })
    }));
  }
  const k1 = [
    "components",
    "fullWidth",
    "inputComponent",
    "label",
    "multiline",
    "notched",
    "slots",
    "type"
  ], gl = await M("react"), A1 = (e) => {
    const { classes: t } = e, o = Se({
      root: [
        "root"
      ],
      notchedOutline: [
        "notchedOutline"
      ],
      input: [
        "input"
      ]
    }, Qv, t);
    return f({}, t, o);
  }, M1 = G(Pr, {
    shouldForwardProp: (e) => xt(e) || e === "classes",
    name: "MuiOutlinedInput",
    slot: "Root",
    overridesResolver: Ar
  })(({ theme: e, ownerState: t }) => {
    const n = e.palette.mode === "light" ? "rgba(0, 0, 0, 0.23)" : "rgba(255, 255, 255, 0.23)";
    return f({
      position: "relative",
      borderRadius: (e.vars || e).shape.borderRadius,
      [`&:hover .${Bt.notchedOutline}`]: {
        borderColor: (e.vars || e).palette.text.primary
      },
      "@media (hover: none)": {
        [`&:hover .${Bt.notchedOutline}`]: {
          borderColor: e.vars ? `rgba(${e.vars.palette.common.onBackgroundChannel} / 0.23)` : n
        }
      },
      [`&.${Bt.focused} .${Bt.notchedOutline}`]: {
        borderColor: (e.vars || e).palette[t.color].main,
        borderWidth: 2
      },
      [`&.${Bt.error} .${Bt.notchedOutline}`]: {
        borderColor: (e.vars || e).palette.error.main
      },
      [`&.${Bt.disabled} .${Bt.notchedOutline}`]: {
        borderColor: (e.vars || e).palette.action.disabled
      }
    }, t.startAdornment && {
      paddingLeft: 14
    }, t.endAdornment && {
      paddingRight: 14
    }, t.multiline && f({
      padding: "16.5px 14px"
    }, t.size === "small" && {
      padding: "8.5px 14px"
    }));
  }), P1 = G(T1, {
    name: "MuiOutlinedInput",
    slot: "NotchedOutline",
    overridesResolver: (e, t) => t.notchedOutline
  })(({ theme: e }) => {
    const t = e.palette.mode === "light" ? "rgba(0, 0, 0, 0.23)" : "rgba(255, 255, 255, 0.23)";
    return {
      borderColor: e.vars ? `rgba(${e.vars.palette.common.onBackgroundChannel} / 0.23)` : t
    };
  }), L1 = G(Lr, {
    name: "MuiOutlinedInput",
    slot: "Input",
    overridesResolver: Mr
  })(({ theme: e, ownerState: t }) => f({
    padding: "16.5px 14px"
  }, !e.vars && {
    "&:-webkit-autofill": {
      WebkitBoxShadow: e.palette.mode === "light" ? null : "0 0 0 100px #266798 inset",
      WebkitTextFillColor: e.palette.mode === "light" ? null : "#fff",
      caretColor: e.palette.mode === "light" ? null : "#fff",
      borderRadius: "inherit"
    }
  }, e.vars && {
    "&:-webkit-autofill": {
      borderRadius: "inherit"
    },
    [e.getColorSchemeSelector("dark")]: {
      "&:-webkit-autofill": {
        WebkitBoxShadow: "0 0 0 100px #266798 inset",
        WebkitTextFillColor: "#fff",
        caretColor: "#fff"
      }
    }
  }, t.size === "small" && {
    padding: "8.5px 14px"
  }, t.multiline && {
    padding: 0
  }, t.startAdornment && {
    paddingLeft: 0
  }, t.endAdornment && {
    paddingRight: 0
  })), xu = gl.forwardRef(function(t, n) {
    var o, r, a, i, s;
    const l = Re({
      props: t,
      name: "MuiOutlinedInput"
    }), { components: c = {}, fullWidth: d = false, inputComponent: p = "input", label: m, multiline: v = false, notched: g, slots: h = {}, type: C = "text" } = l, $ = ee(l, k1), R = A1(l), b = cn(), y = Nn({
      props: l,
      muiFormControl: b,
      states: [
        "color",
        "disabled",
        "error",
        "focused",
        "hiddenLabel",
        "size",
        "required"
      ]
    }), E = f({}, l, {
      color: y.color || "primary",
      disabled: y.disabled,
      error: y.error,
      focused: y.focused,
      formControl: b,
      fullWidth: d,
      hiddenLabel: y.hiddenLabel,
      multiline: v,
      size: y.size,
      type: C
    }), w = (o = (r = h.root) != null ? r : c.Root) != null ? o : M1, T = (a = (i = h.input) != null ? i : c.Input) != null ? a : L1;
    return u.jsx(_i, f({
      slots: {
        root: w,
        input: T
      },
      renderSuffix: (I) => u.jsx(P1, {
        ownerState: E,
        className: R.notchedOutline,
        label: m != null && m !== "" && y.required ? s || (s = u.jsxs(gl.Fragment, {
          children: [
            m,
            "\u2009",
            "*"
          ]
        })) : m,
        notched: typeof g < "u" ? g : !!(I.startAdornment || I.filled || I.focused)
      }),
      fullWidth: d,
      inputComponent: p,
      multiline: v,
      ref: n,
      type: C
    }, $, {
      classes: f({}, R, {
        notchedOutline: null
      })
    }));
  });
  xu.muiName = "Input";
  const Su = xu;
  function I1(e) {
    return xe("MuiSelect", e);
  }
  const N1 = ye("MuiSelect", [
    "root",
    "select",
    "multiple",
    "filled",
    "outlined",
    "standard",
    "disabled",
    "focused",
    "icon",
    "iconOpen",
    "iconFilled",
    "iconOutlined",
    "iconStandard",
    "nativeInput",
    "error"
  ]), Wn = N1;
  var vl;
  const F1 = [
    "aria-describedby",
    "aria-label",
    "autoFocus",
    "autoWidth",
    "children",
    "className",
    "defaultOpen",
    "defaultValue",
    "disabled",
    "displayEmpty",
    "error",
    "IconComponent",
    "inputRef",
    "labelId",
    "MenuProps",
    "multiple",
    "name",
    "onBlur",
    "onChange",
    "onClose",
    "onFocus",
    "onOpen",
    "open",
    "readOnly",
    "renderValue",
    "SelectDisplayProps",
    "tabIndex",
    "type",
    "value",
    "variant"
  ], qe = await M("react"), O1 = G("div", {
    name: "MuiSelect",
    slot: "Select",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        {
          [`&.${Wn.select}`]: t.select
        },
        {
          [`&.${Wn.select}`]: t[n.variant]
        },
        {
          [`&.${Wn.error}`]: t.error
        },
        {
          [`&.${Wn.multiple}`]: t.multiple
        }
      ];
    }
  })(bu, {
    [`&.${Wn.select}`]: {
      height: "auto",
      minHeight: "1.4375em",
      textOverflow: "ellipsis",
      whiteSpace: "nowrap",
      overflow: "hidden"
    }
  }), B1 = G("svg", {
    name: "MuiSelect",
    slot: "Icon",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.icon,
        n.variant && t[`icon${oe(n.variant)}`],
        n.open && t.iconOpen
      ];
    }
  })(yu), D1 = G("input", {
    shouldForwardProp: (e) => tu(e) && e !== "classes",
    name: "MuiSelect",
    slot: "NativeInput",
    overridesResolver: (e, t) => t.nativeInput
  })({
    bottom: 0,
    left: 0,
    position: "absolute",
    opacity: 0,
    pointerEvents: "none",
    width: "100%",
    boxSizing: "border-box"
  });
  function bl(e, t) {
    return typeof t == "object" && t !== null ? e === t : String(e) === String(t);
  }
  function j1(e) {
    return e == null || typeof e == "string" && !e.trim();
  }
  const z1 = (e) => {
    const { classes: t, variant: n, disabled: o, multiple: r, open: a, error: i } = e, s = {
      select: [
        "select",
        n,
        o && "disabled",
        r && "multiple",
        i && "error"
      ],
      icon: [
        "icon",
        `icon${oe(n)}`,
        a && "iconOpen",
        o && "disabled"
      ],
      nativeInput: [
        "nativeInput"
      ]
    };
    return Se(s, I1, t);
  }, V1 = qe.forwardRef(function(t, n) {
    var o;
    const { "aria-describedby": r, "aria-label": a, autoFocus: i, autoWidth: s, children: l, className: c, defaultOpen: d, defaultValue: p, disabled: m, displayEmpty: v, error: g = false, IconComponent: h, inputRef: C, labelId: $, MenuProps: R = {}, multiple: b, name: y, onBlur: E, onChange: w, onClose: T, onFocus: I, onOpen: V, open: P, readOnly: U, renderValue: F, SelectDisplayProps: O = {}, tabIndex: B, value: j, variant: W = "standard" } = t, H = ee(t, F1), [D, me] = Na({
      controlled: j,
      default: p,
      name: "Select"
    }), [ne, de] = Na({
      controlled: P,
      default: d,
      name: "Select"
    }), _ = qe.useRef(null), L = qe.useRef(null), [A, Y] = qe.useState(null), { current: k } = qe.useRef(P != null), [Z, Q] = qe.useState(), z = Ve(n, C), fe = qe.useCallback((se) => {
      L.current = se, se && Y(se);
    }, []), re = A == null ? void 0 : A.parentNode;
    qe.useImperativeHandle(z, () => ({
      focus: () => {
        L.current.focus();
      },
      node: _.current,
      value: D
    }), [
      D
    ]), qe.useEffect(() => {
      d && ne && A && !k && (Q(s ? null : re.clientWidth), L.current.focus());
    }, [
      A,
      s
    ]), qe.useEffect(() => {
      i && L.current.focus();
    }, [
      i
    ]), qe.useEffect(() => {
      if (!$)
        return;
      const se = Xe(L.current).getElementById($);
      if (se) {
        const $e = () => {
          getSelection().isCollapsed && L.current.focus();
        };
        return se.addEventListener("click", $e), () => {
          se.removeEventListener("click", $e);
        };
      }
    }, [
      $
    ]);
    const ie = (se, $e) => {
      se ? V && V($e) : T && T($e), k || (Q(s ? null : re.clientWidth), de(se));
    }, te = (se) => {
      se.button === 0 && (se.preventDefault(), L.current.focus(), ie(true, se));
    }, ge = (se) => {
      ie(false, se);
    }, _e = qe.Children.toArray(l), Be = (se) => {
      const $e = _e.find((S) => S.props.value === se.target.value);
      $e !== void 0 && (me($e.props.value), w && w(se, $e));
    }, ke = (se) => ($e) => {
      let S;
      if ($e.currentTarget.hasAttribute("tabindex")) {
        if (b) {
          S = Array.isArray(D) ? D.slice() : [];
          const x = D.indexOf(se.props.value);
          x === -1 ? S.push(se.props.value) : S.splice(x, 1);
        } else
          S = se.props.value;
        if (se.props.onClick && se.props.onClick($e), D !== S && (me(S), w)) {
          const x = $e.nativeEvent || $e, N = new x.constructor(x.type, x);
          Object.defineProperty(N, "target", {
            writable: true,
            value: {
              value: S,
              name: y
            }
          }), w(N, se);
        }
        b || ie(false, $e);
      }
    }, Ke = (se) => {
      U || [
        " ",
        "ArrowUp",
        "ArrowDown",
        "Enter"
      ].indexOf(se.key) !== -1 && (se.preventDefault(), ie(true, se));
    }, et = A !== null && ne, Ue = (se) => {
      !et && E && (Object.defineProperty(se, "target", {
        writable: true,
        value: {
          value: D,
          name: y
        }
      }), E(se));
    };
    delete H["aria-invalid"];
    let Ae, it;
    const We = [];
    let Ce = false;
    (tr({
      value: D
    }) || v) && (F ? Ae = F(D) : Ce = true);
    const Ge = _e.map((se) => {
      if (!qe.isValidElement(se))
        return null;
      let $e;
      if (b) {
        if (!Array.isArray(D))
          throw new Error(Mt(2));
        $e = D.some((S) => bl(S, se.props.value)), $e && Ce && We.push(se.props.children);
      } else
        $e = bl(D, se.props.value), $e && Ce && (it = se.props.children);
      return qe.cloneElement(se, {
        "aria-selected": $e ? "true" : "false",
        onClick: ke(se),
        onKeyUp: (S) => {
          S.key === " " && S.preventDefault(), se.props.onKeyUp && se.props.onKeyUp(S);
        },
        role: "option",
        selected: $e,
        value: void 0,
        "data-value": se.props.value
      });
    });
    Ce && (b ? We.length === 0 ? Ae = null : Ae = We.reduce((se, $e, S) => (se.push($e), S < We.length - 1 && se.push(", "), se), []) : Ae = it);
    let Rt = Z;
    !s && k && A && (Rt = re.clientWidth);
    let ht;
    typeof B < "u" ? ht = B : ht = m ? null : 0;
    const we = O.id || (y ? `mui-component-select-${y}` : void 0), le = f({}, t, {
      variant: W,
      value: D,
      open: et,
      error: g
    }), mt = z1(le), Zt = f({}, R.PaperProps, (o = R.slotProps) == null ? void 0 : o.paper), Ot = po();
    return u.jsxs(qe.Fragment, {
      children: [
        u.jsx(O1, f({
          ref: fe,
          tabIndex: ht,
          role: "combobox",
          "aria-controls": Ot,
          "aria-disabled": m ? "true" : void 0,
          "aria-expanded": et ? "true" : "false",
          "aria-haspopup": "listbox",
          "aria-label": a,
          "aria-labelledby": [
            $,
            we
          ].filter(Boolean).join(" ") || void 0,
          "aria-describedby": r,
          onKeyDown: Ke,
          onMouseDown: m || U ? null : te,
          onBlur: Ue,
          onFocus: I
        }, O, {
          ownerState: le,
          className: ae(O.className, mt.select, c),
          id: we,
          children: j1(Ae) ? vl || (vl = u.jsx("span", {
            className: "notranslate",
            children: "\u200B"
          })) : Ae
        })),
        u.jsx(D1, f({
          "aria-invalid": g,
          value: Array.isArray(D) ? D.join(",") : D,
          name: y,
          ref: _,
          "aria-hidden": true,
          onChange: Be,
          tabIndex: -1,
          disabled: m,
          className: mt.nativeInput,
          autoFocus: i,
          ownerState: le
        }, H)),
        u.jsx(B1, {
          as: h,
          className: mt.icon,
          ownerState: le
        }),
        u.jsx(g1, f({
          id: `menu-${y || ""}`,
          anchorEl: re,
          open: et,
          onClose: ge,
          anchorOrigin: {
            vertical: "bottom",
            horizontal: "center"
          },
          transformOrigin: {
            vertical: "top",
            horizontal: "center"
          }
        }, R, {
          MenuListProps: f({
            "aria-labelledby": $,
            role: "listbox",
            "aria-multiselectable": b ? "true" : void 0,
            disableListWrap: true,
            id: Ot
          }, R.MenuListProps),
          slotProps: f({}, R.slotProps, {
            paper: f({}, Zt, {
              style: f({
                minWidth: Rt
              }, Zt != null ? Zt.style : null)
            })
          }),
          children: Ge
        }))
      ]
    });
  }), U1 = V1, W1 = [
    "autoWidth",
    "children",
    "classes",
    "className",
    "defaultOpen",
    "displayEmpty",
    "IconComponent",
    "id",
    "input",
    "inputProps",
    "label",
    "labelId",
    "MenuProps",
    "multiple",
    "native",
    "onClose",
    "onOpen",
    "open",
    "renderValue",
    "SelectDisplayProps",
    "variant"
  ], H1 = [
    "root"
  ], ba = await M("react"), K1 = (e) => {
    const { classes: t } = e;
    return t;
  }, wi = {
    name: "MuiSelect",
    overridesResolver: (e, t) => t.root,
    shouldForwardProp: (e) => xt(e) && e !== "variant",
    slot: "Root"
  }, q1 = G(mu, wi)(""), G1 = G(Su, wi)(""), Y1 = G(pu, wi)(""), Ru = ba.forwardRef(function(t, n) {
    const o = Re({
      name: "MuiSelect",
      props: t
    }), { autoWidth: r = false, children: a, classes: i = {}, className: s, defaultOpen: l = false, displayEmpty: c = false, IconComponent: d = ob, id: p, input: m, inputProps: v, label: g, labelId: h, MenuProps: C, multiple: $ = false, native: R = false, onClose: b, onOpen: y, open: E, renderValue: w, SelectDisplayProps: T, variant: I = "outlined" } = o, V = ee(o, W1), P = R ? C1 : U1, U = cn(), F = Nn({
      props: o,
      muiFormControl: U,
      states: [
        "variant",
        "error"
      ]
    }), O = F.variant || I, B = f({}, o, {
      variant: O,
      classes: i
    }), j = K1(B), W = ee(j, H1), H = m || {
      standard: u.jsx(q1, {
        ownerState: B
      }),
      outlined: u.jsx(G1, {
        label: g,
        ownerState: B
      }),
      filled: u.jsx(Y1, {
        ownerState: B
      })
    }[O], D = Ve(n, fo(H));
    return u.jsx(ba.Fragment, {
      children: ba.cloneElement(H, f({
        inputComponent: P,
        inputProps: f({
          children: a,
          error: F.error,
          IconComponent: d,
          variant: O,
          type: void 0,
          multiple: $
        }, R ? {
          id: p
        } : {
          autoWidth: r,
          defaultOpen: l,
          displayEmpty: c,
          labelId: h,
          MenuProps: C,
          onClose: b,
          onOpen: y,
          open: E,
          renderValue: w,
          SelectDisplayProps: f({
            id: p
          }, T)
        }, v, {
          classes: v ? at(W, v.classes) : W
        }, m ? m.props.inputProps : {})
      }, ($ && R || c) && O === "outlined" ? {
        notched: true
      } : {}, {
        ref: D,
        className: ae(H.props.className, s, j.root)
      }, !m && {
        variant: O
      }, V))
    });
  });
  Ru.muiName = "Select";
  const X1 = Ru;
  function Z1(e) {
    return xe("MuiSkeleton", e);
  }
  ye("MuiSkeleton", [
    "root",
    "text",
    "rectangular",
    "rounded",
    "circular",
    "pulse",
    "wave",
    "withChildren",
    "fitContent",
    "heightAuto"
  ]);
  const J1 = [
    "animation",
    "className",
    "component",
    "height",
    "style",
    "variant",
    "width"
  ];
  let nr = (e) => e, yl, xl, Sl, Rl;
  const Q1 = await M("react"), ex = (e) => {
    const { classes: t, variant: n, animation: o, hasChildren: r, width: a, height: i } = e;
    return Se({
      root: [
        "root",
        n,
        o,
        r && "withChildren",
        r && !a && "fitContent",
        r && !i && "heightAuto"
      ]
    }, Z1, t);
  }, tx = Gt(yl || (yl = nr`
  0% {
    opacity: 1;
  }

  50% {
    opacity: 0.4;
  }

  100% {
    opacity: 1;
  }
`)), nx = Gt(xl || (xl = nr`
  0% {
    transform: translateX(-100%);
  }

  50% {
    /* +0.5s of delay between each loop */
    transform: translateX(100%);
  }

  100% {
    transform: translateX(100%);
  }
`)), ox = G("span", {
    name: "MuiSkeleton",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.variant],
        n.animation !== false && t[n.animation],
        n.hasChildren && t.withChildren,
        n.hasChildren && !n.width && t.fitContent,
        n.hasChildren && !n.height && t.heightAuto
      ];
    }
  })(({ theme: e, ownerState: t }) => {
    const n = Em(e.shape.borderRadius) || "px", o = Tm(e.shape.borderRadius);
    return f({
      display: "block",
      backgroundColor: e.vars ? e.vars.palette.Skeleton.bg : ih(e.palette.text.primary, e.palette.mode === "light" ? 0.11 : 0.13),
      height: "1.2em"
    }, t.variant === "text" && {
      marginTop: 0,
      marginBottom: 0,
      height: "auto",
      transformOrigin: "0 55%",
      transform: "scale(1, 0.60)",
      borderRadius: `${o}${n}/${Math.round(o / 0.6 * 10) / 10}${n}`,
      "&:empty:before": {
        content: '"\\00a0"'
      }
    }, t.variant === "circular" && {
      borderRadius: "50%"
    }, t.variant === "rounded" && {
      borderRadius: (e.vars || e).shape.borderRadius
    }, t.hasChildren && {
      "& > *": {
        visibility: "hidden"
      }
    }, t.hasChildren && !t.width && {
      maxWidth: "fit-content"
    }, t.hasChildren && !t.height && {
      height: "auto"
    });
  }, ({ ownerState: e }) => e.animation === "pulse" && ao(Sl || (Sl = nr`
      animation: ${0} 2s ease-in-out 0.5s infinite;
    `), tx), ({ ownerState: e, theme: t }) => e.animation === "wave" && ao(Rl || (Rl = nr`
      position: relative;
      overflow: hidden;

      /* Fix bug in Safari https://bugs.webkit.org/show_bug.cgi?id=68196 */
      -webkit-mask-image: -webkit-radial-gradient(white, black);

      &::after {
        animation: ${0} 2s linear 0.5s infinite;
        background: linear-gradient(
          90deg,
          transparent,
          ${0},
          transparent
        );
        content: '';
        position: absolute;
        transform: translateX(-100%); /* Avoid flash during server-side hydration */
        bottom: 0;
        left: 0;
        right: 0;
        top: 0;
      }
    `), nx, (t.vars || t).palette.action.hover)), rx = Q1.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiSkeleton"
    }), { animation: r = "pulse", className: a, component: i = "span", height: s, style: l, variant: c = "text", width: d } = o, p = ee(o, J1), m = f({}, o, {
      animation: r,
      component: i,
      variant: c,
      hasChildren: !!p.children
    }), v = ex(m);
    return u.jsx(ox, f({
      as: i,
      ref: n,
      className: ae(v.root, a),
      ownerState: m
    }, p, {
      style: f({
        width: d,
        height: s
      }, l)
    }));
  }), kt = rx, ax = await M("react"), ix = ax.createContext({}), Nr = ix, sx = await M("react"), lx = sx.createContext({}), $i = lx;
  function cx(e) {
    return xe("MuiStep", e);
  }
  ye("MuiStep", [
    "root",
    "horizontal",
    "vertical",
    "alternativeLabel",
    "completed"
  ]);
  const ux = [
    "active",
    "children",
    "className",
    "component",
    "completed",
    "disabled",
    "expanded",
    "index",
    "last"
  ], Io = await M("react"), dx = (e) => {
    const { classes: t, orientation: n, alternativeLabel: o, completed: r } = e;
    return Se({
      root: [
        "root",
        n,
        o && "alternativeLabel",
        r && "completed"
      ]
    }, cx, t);
  }, px = G("div", {
    name: "MuiStep",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.orientation],
        n.alternativeLabel && t.alternativeLabel,
        n.completed && t.completed
      ];
    }
  })(({ ownerState: e }) => f({}, e.orientation === "horizontal" && {
    paddingLeft: 8,
    paddingRight: 8
  }, e.alternativeLabel && {
    flex: 1,
    position: "relative"
  })), fx = Io.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiStep"
    }), { active: r, children: a, className: i, component: s = "div", completed: l, disabled: c, expanded: d = false, index: p, last: m } = o, v = ee(o, ux), { activeStep: g, connector: h, alternativeLabel: C, orientation: $, nonLinear: R } = Io.useContext(Nr);
    let [b = false, y = false, E = false] = [
      r,
      l,
      c
    ];
    g === p ? b = r !== void 0 ? r : true : !R && g > p ? y = l !== void 0 ? l : true : !R && g < p && (E = c !== void 0 ? c : true);
    const w = Io.useMemo(() => ({
      index: p,
      last: m,
      expanded: d,
      icon: p + 1,
      active: b,
      completed: y,
      disabled: E
    }), [
      p,
      m,
      d,
      b,
      y,
      E
    ]), T = f({}, o, {
      active: b,
      orientation: $,
      alternativeLabel: C,
      completed: y,
      disabled: E,
      expanded: d,
      component: s
    }), I = dx(T), V = u.jsxs(px, f({
      as: s,
      className: ae(I.root, i),
      ref: n,
      ownerState: T
    }, v, {
      children: [
        h && C && p !== 0 ? h : null,
        a
      ]
    }));
    return u.jsx($i.Provider, {
      value: w,
      children: h && !C && p !== 0 ? u.jsxs(Io.Fragment, {
        children: [
          h,
          V
        ]
      }) : V
    });
  }), hx = fx;
  await M("react");
  const mx = It(u.jsx("path", {
    d: "M12 0a12 12 0 1 0 0 24 12 12 0 0 0 0-24zm-2 17l-5-5 1.4-1.4 3.6 3.6 7.6-7.6L19 8l-9 9z"
  }), "CheckCircle");
  await M("react");
  const gx = It(u.jsx("path", {
    d: "M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"
  }), "Warning");
  function vx(e) {
    return xe("MuiStepIcon", e);
  }
  const bx = ye("MuiStepIcon", [
    "root",
    "active",
    "completed",
    "error",
    "text"
  ]), ya = bx;
  var _l;
  const yx = [
    "active",
    "className",
    "completed",
    "error",
    "icon"
  ], xx = await M("react"), Sx = (e) => {
    const { classes: t, active: n, completed: o, error: r } = e;
    return Se({
      root: [
        "root",
        n && "active",
        o && "completed",
        r && "error"
      ],
      text: [
        "text"
      ]
    }, vx, t);
  }, xa = G(ja, {
    name: "MuiStepIcon",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })(({ theme: e }) => ({
    display: "block",
    transition: e.transitions.create("color", {
      duration: e.transitions.duration.shortest
    }),
    color: (e.vars || e).palette.text.disabled,
    [`&.${ya.completed}`]: {
      color: (e.vars || e).palette.primary.main
    },
    [`&.${ya.active}`]: {
      color: (e.vars || e).palette.primary.main
    },
    [`&.${ya.error}`]: {
      color: (e.vars || e).palette.error.main
    }
  })), Rx = G("text", {
    name: "MuiStepIcon",
    slot: "Text",
    overridesResolver: (e, t) => t.text
  })(({ theme: e }) => ({
    fill: (e.vars || e).palette.primary.contrastText,
    fontSize: e.typography.caption.fontSize,
    fontFamily: e.typography.fontFamily
  })), _x = xx.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiStepIcon"
    }), { active: r = false, className: a, completed: i = false, error: s = false, icon: l } = o, c = ee(o, yx), d = f({}, o, {
      active: r,
      completed: i,
      error: s
    }), p = Sx(d);
    if (typeof l == "number" || typeof l == "string") {
      const m = ae(a, p.root);
      return s ? u.jsx(xa, f({
        as: gx,
        className: m,
        ref: n,
        ownerState: d
      }, c)) : i ? u.jsx(xa, f({
        as: mx,
        className: m,
        ref: n,
        ownerState: d
      }, c)) : u.jsxs(xa, f({
        className: m,
        ref: n,
        ownerState: d
      }, c, {
        children: [
          _l || (_l = u.jsx("circle", {
            cx: "12",
            cy: "12",
            r: "12"
          })),
          u.jsx(Rx, {
            className: p.text,
            x: "12",
            y: "12",
            textAnchor: "middle",
            dominantBaseline: "central",
            ownerState: d,
            children: l
          })
        ]
      }));
    }
    return l;
  }), Cx = _x;
  function wx(e) {
    return xe("MuiStepLabel", e);
  }
  const $x = ye("MuiStepLabel", [
    "root",
    "horizontal",
    "vertical",
    "label",
    "active",
    "completed",
    "error",
    "disabled",
    "iconContainer",
    "alternativeLabel",
    "labelContainer"
  ]), Kt = $x, Ex = [
    "children",
    "className",
    "componentsProps",
    "error",
    "icon",
    "optional",
    "slotProps",
    "StepIconComponent",
    "StepIconProps"
  ], Sa = await M("react"), Tx = (e) => {
    const { classes: t, orientation: n, active: o, completed: r, error: a, disabled: i, alternativeLabel: s } = e;
    return Se({
      root: [
        "root",
        n,
        a && "error",
        i && "disabled",
        s && "alternativeLabel"
      ],
      label: [
        "label",
        o && "active",
        r && "completed",
        a && "error",
        i && "disabled",
        s && "alternativeLabel"
      ],
      iconContainer: [
        "iconContainer",
        o && "active",
        r && "completed",
        a && "error",
        i && "disabled",
        s && "alternativeLabel"
      ],
      labelContainer: [
        "labelContainer",
        s && "alternativeLabel"
      ]
    }, wx, t);
  }, kx = G("span", {
    name: "MuiStepLabel",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.orientation]
      ];
    }
  })(({ ownerState: e }) => f({
    display: "flex",
    alignItems: "center",
    [`&.${Kt.alternativeLabel}`]: {
      flexDirection: "column"
    },
    [`&.${Kt.disabled}`]: {
      cursor: "default"
    }
  }, e.orientation === "vertical" && {
    textAlign: "left",
    padding: "8px 0"
  })), Ax = G("span", {
    name: "MuiStepLabel",
    slot: "Label",
    overridesResolver: (e, t) => t.label
  })(({ theme: e }) => f({}, e.typography.body2, {
    display: "block",
    transition: e.transitions.create("color", {
      duration: e.transitions.duration.shortest
    }),
    [`&.${Kt.active}`]: {
      color: (e.vars || e).palette.text.primary,
      fontWeight: 500
    },
    [`&.${Kt.completed}`]: {
      color: (e.vars || e).palette.text.primary,
      fontWeight: 500
    },
    [`&.${Kt.alternativeLabel}`]: {
      marginTop: 16
    },
    [`&.${Kt.error}`]: {
      color: (e.vars || e).palette.error.main
    }
  })), Mx = G("span", {
    name: "MuiStepLabel",
    slot: "IconContainer",
    overridesResolver: (e, t) => t.iconContainer
  })(() => ({
    flexShrink: 0,
    display: "flex",
    paddingRight: 8,
    [`&.${Kt.alternativeLabel}`]: {
      paddingRight: 0
    }
  })), Px = G("span", {
    name: "MuiStepLabel",
    slot: "LabelContainer",
    overridesResolver: (e, t) => t.labelContainer
  })(({ theme: e }) => ({
    width: "100%",
    color: (e.vars || e).palette.text.secondary,
    [`&.${Kt.alternativeLabel}`]: {
      textAlign: "center"
    }
  })), _u = Sa.forwardRef(function(t, n) {
    var o;
    const r = Re({
      props: t,
      name: "MuiStepLabel"
    }), { children: a, className: i, componentsProps: s = {}, error: l = false, icon: c, optional: d, slotProps: p = {}, StepIconComponent: m, StepIconProps: v } = r, g = ee(r, Ex), { alternativeLabel: h, orientation: C } = Sa.useContext(Nr), { active: $, disabled: R, completed: b, icon: y } = Sa.useContext($i), E = c || y;
    let w = m;
    E && !w && (w = Cx);
    const T = f({}, r, {
      active: $,
      alternativeLabel: h,
      completed: b,
      disabled: R,
      error: l,
      orientation: C
    }), I = Tx(T), V = (o = p.label) != null ? o : s.label;
    return u.jsxs(kx, f({
      className: ae(I.root, i),
      ref: n,
      ownerState: T
    }, g, {
      children: [
        E || w ? u.jsx(Mx, {
          className: I.iconContainer,
          ownerState: T,
          children: u.jsx(w, f({
            completed: b,
            active: $,
            error: l,
            icon: E
          }, v))
        }) : null,
        u.jsxs(Px, {
          className: I.labelContainer,
          ownerState: T,
          children: [
            a ? u.jsx(Ax, f({
              ownerState: T
            }, V, {
              className: ae(I.label, V == null ? void 0 : V.className),
              children: a
            })) : null,
            d
          ]
        })
      ]
    }));
  });
  _u.muiName = "StepLabel";
  const Lx = _u;
  function Ix(e) {
    return xe("MuiStepConnector", e);
  }
  ye("MuiStepConnector", [
    "root",
    "horizontal",
    "vertical",
    "alternativeLabel",
    "active",
    "completed",
    "disabled",
    "line",
    "lineHorizontal",
    "lineVertical"
  ]);
  const Nx = [
    "className"
  ], Ra = await M("react"), Fx = (e) => {
    const { classes: t, orientation: n, alternativeLabel: o, active: r, completed: a, disabled: i } = e, s = {
      root: [
        "root",
        n,
        o && "alternativeLabel",
        r && "active",
        a && "completed",
        i && "disabled"
      ],
      line: [
        "line",
        `line${oe(n)}`
      ]
    };
    return Se(s, Ix, t);
  }, Ox = G("div", {
    name: "MuiStepConnector",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.orientation],
        n.alternativeLabel && t.alternativeLabel,
        n.completed && t.completed
      ];
    }
  })(({ ownerState: e }) => f({
    flex: "1 1 auto"
  }, e.orientation === "vertical" && {
    marginLeft: 12
  }, e.alternativeLabel && {
    position: "absolute",
    top: 8 + 4,
    left: "calc(-50% + 20px)",
    right: "calc(50% + 20px)"
  })), Bx = G("span", {
    name: "MuiStepConnector",
    slot: "Line",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.line,
        t[`line${oe(n.orientation)}`]
      ];
    }
  })(({ ownerState: e, theme: t }) => {
    const n = t.palette.mode === "light" ? t.palette.grey[400] : t.palette.grey[600];
    return f({
      display: "block",
      borderColor: t.vars ? t.vars.palette.StepConnector.border : n
    }, e.orientation === "horizontal" && {
      borderTopStyle: "solid",
      borderTopWidth: 1
    }, e.orientation === "vertical" && {
      borderLeftStyle: "solid",
      borderLeftWidth: 1,
      minHeight: 24
    });
  }), Dx = Ra.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiStepConnector"
    }), { className: r } = o, a = ee(o, Nx), { alternativeLabel: i, orientation: s = "horizontal" } = Ra.useContext(Nr), { active: l, disabled: c, completed: d } = Ra.useContext($i), p = f({}, o, {
      alternativeLabel: i,
      orientation: s,
      active: l,
      completed: d,
      disabled: c
    }), m = Fx(p);
    return u.jsx(Ox, f({
      className: ae(m.root, r),
      ref: n,
      ownerState: p
    }, a, {
      children: u.jsx(Bx, {
        className: m.line,
        ownerState: p
      })
    }));
  }), jx = Dx;
  function zx(e) {
    return xe("MuiStepper", e);
  }
  ye("MuiStepper", [
    "root",
    "horizontal",
    "vertical",
    "nonLinear",
    "alternativeLabel"
  ]);
  const Vx = [
    "activeStep",
    "alternativeLabel",
    "children",
    "className",
    "component",
    "connector",
    "nonLinear",
    "orientation"
  ], No = await M("react"), Ux = (e) => {
    const { orientation: t, nonLinear: n, alternativeLabel: o, classes: r } = e;
    return Se({
      root: [
        "root",
        t,
        n && "nonLinear",
        o && "alternativeLabel"
      ]
    }, zx, r);
  }, Wx = G("div", {
    name: "MuiStepper",
    slot: "Root",
    overridesResolver: (e, t) => {
      const { ownerState: n } = e;
      return [
        t.root,
        t[n.orientation],
        n.alternativeLabel && t.alternativeLabel,
        n.nonLinear && t.nonLinear
      ];
    }
  })(({ ownerState: e }) => f({
    display: "flex"
  }, e.orientation === "horizontal" && {
    flexDirection: "row",
    alignItems: "center"
  }, e.orientation === "vertical" && {
    flexDirection: "column"
  }, e.alternativeLabel && {
    alignItems: "flex-start"
  })), Hx = u.jsx(jx, {}), Kx = No.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiStepper"
    }), { activeStep: r = 0, alternativeLabel: a = false, children: i, className: s, component: l = "div", connector: c = Hx, nonLinear: d = false, orientation: p = "horizontal" } = o, m = ee(o, Vx), v = f({}, o, {
      nonLinear: d,
      alternativeLabel: a,
      orientation: p,
      component: l
    }), g = Ux(v), h = No.Children.toArray(i).filter(Boolean), C = h.map((R, b) => No.cloneElement(R, f({
      index: b,
      last: b + 1 === h.length
    }, R.props))), $ = No.useMemo(() => ({
      activeStep: r,
      alternativeLabel: a,
      connector: c,
      nonLinear: d,
      orientation: p
    }), [
      r,
      a,
      c,
      d,
      p
    ]);
    return u.jsx(Nr.Provider, {
      value: $,
      children: u.jsx(Wx, f({
        as: l,
        ownerState: v,
        className: ae(g.root, s),
        ref: n
      }, m, {
        children: C
      }))
    });
  }), qx = Kx;
  function Gx(e) {
    return xe("MuiTextField", e);
  }
  ye("MuiTextField", [
    "root"
  ]);
  const Yx = [
    "autoComplete",
    "autoFocus",
    "children",
    "className",
    "color",
    "defaultValue",
    "disabled",
    "error",
    "FormHelperTextProps",
    "fullWidth",
    "helperText",
    "id",
    "InputLabelProps",
    "inputProps",
    "InputProps",
    "inputRef",
    "label",
    "maxRows",
    "minRows",
    "multiline",
    "name",
    "onBlur",
    "onChange",
    "onFocus",
    "placeholder",
    "required",
    "rows",
    "select",
    "SelectProps",
    "type",
    "value",
    "variant"
  ], Xx = await M("react"), Zx = {
    standard: mu,
    filled: pu,
    outlined: Su
  }, Jx = (e) => {
    const { classes: t } = e;
    return Se({
      root: [
        "root"
      ]
    }, Gx, t);
  }, Qx = G(Q0, {
    name: "MuiTextField",
    slot: "Root",
    overridesResolver: (e, t) => t.root
  })({}), eS = Xx.forwardRef(function(t, n) {
    const o = Re({
      props: t,
      name: "MuiTextField"
    }), { autoComplete: r, autoFocus: a = false, children: i, className: s, color: l = "primary", defaultValue: c, disabled: d = false, error: p = false, FormHelperTextProps: m, fullWidth: v = false, helperText: g, id: h, InputLabelProps: C, inputProps: $, InputProps: R, inputRef: b, label: y, maxRows: E, minRows: w, multiline: T = false, name: I, onBlur: V, onChange: P, onFocus: U, placeholder: F, required: O = false, rows: B, select: j = false, SelectProps: W, type: H, value: D, variant: me = "outlined" } = o, ne = ee(o, Yx), de = f({}, o, {
      autoFocus: a,
      color: l,
      disabled: d,
      error: p,
      fullWidth: v,
      multiline: T,
      required: O,
      select: j,
      variant: me
    }), _ = Jx(de), L = {};
    me === "outlined" && (C && typeof C.shrink < "u" && (L.notched = C.shrink), L.label = y), j && ((!W || !W.native) && (L.id = void 0), L["aria-describedby"] = void 0);
    const A = po(h), Y = g && A ? `${A}-helper-text` : void 0, k = y && A ? `${A}-label` : void 0, Z = Zx[me], Q = u.jsx(Z, f({
      "aria-describedby": Y,
      autoComplete: r,
      autoFocus: a,
      defaultValue: c,
      fullWidth: v,
      multiline: T,
      name: I,
      rows: B,
      maxRows: E,
      minRows: w,
      type: H,
      value: D,
      id: A,
      inputRef: b,
      onBlur: V,
      onChange: P,
      onFocus: U,
      placeholder: F,
      inputProps: $
    }, L, R));
    return u.jsxs(Qx, f({
      className: ae(_.root, s),
      disabled: d,
      error: p,
      fullWidth: v,
      ref: n,
      required: O,
      color: l,
      variant: me,
      ownerState: de
    }, ne, {
      children: [
        y != null && y !== "" && u.jsx(Dy, f({
          htmlFor: A,
          id: k
        }, C, {
          children: y
        })),
        j ? u.jsx(X1, f({
          "aria-describedby": Y,
          id: A,
          labelId: k,
          value: D,
          input: Q
        }, W, {
          children: i
        })) : Q,
        g && u.jsx(sy, f({
          id: Y
        }, m, {
          children: g
        }))
      ]
    }));
  }), Cl = eS, Ne = await M("react"), tS = await M("react-dom");
  function nS(e) {
    const t = new Error(e);
    if (t.stack === void 0)
      try {
        throw t;
      } catch {
      }
    return t;
  }
  var oS = nS, ve = oS;
  function rS(e) {
    return !!e && typeof e.then == "function";
  }
  var Me = rS;
  function aS(e, t) {
    if (e != null)
      return e;
    throw ve(t ?? "Got unexpected null or undefined");
  }
  var Ie = aS;
  function he(e, t, n) {
    return t in e ? Object.defineProperty(e, t, {
      value: n,
      enumerable: true,
      configurable: true,
      writable: true
    }) : e[t] = n, e;
  }
  class Fr {
    getValue() {
      throw ve("BaseLoadable");
    }
    toPromise() {
      throw ve("BaseLoadable");
    }
    valueMaybe() {
      throw ve("BaseLoadable");
    }
    valueOrThrow() {
      throw ve(`Loadable expected value, but in "${this.state}" state`);
    }
    promiseMaybe() {
      throw ve("BaseLoadable");
    }
    promiseOrThrow() {
      throw ve(`Loadable expected promise, but in "${this.state}" state`);
    }
    errorMaybe() {
      throw ve("BaseLoadable");
    }
    errorOrThrow() {
      throw ve(`Loadable expected error, but in "${this.state}" state`);
    }
    is(t) {
      return t.state === this.state && t.contents === this.contents;
    }
    map(t) {
      throw ve("BaseLoadable");
    }
  }
  class iS extends Fr {
    constructor(t) {
      super(), he(this, "state", "hasValue"), he(this, "contents", void 0), this.contents = t;
    }
    getValue() {
      return this.contents;
    }
    toPromise() {
      return Promise.resolve(this.contents);
    }
    valueMaybe() {
      return this.contents;
    }
    valueOrThrow() {
      return this.contents;
    }
    promiseMaybe() {
    }
    errorMaybe() {
    }
    map(t) {
      try {
        const n = t(this.contents);
        return Me(n) ? sn(n) : Tn(n) ? n : mo(n);
      } catch (n) {
        return Me(n) ? sn(n.next(() => this.map(t))) : Or(n);
      }
    }
  }
  class sS extends Fr {
    constructor(t) {
      super(), he(this, "state", "hasError"), he(this, "contents", void 0), this.contents = t;
    }
    getValue() {
      throw this.contents;
    }
    toPromise() {
      return Promise.reject(this.contents);
    }
    valueMaybe() {
    }
    promiseMaybe() {
    }
    errorMaybe() {
      return this.contents;
    }
    errorOrThrow() {
      return this.contents;
    }
    map(t) {
      return this;
    }
  }
  class Cu extends Fr {
    constructor(t) {
      super(), he(this, "state", "loading"), he(this, "contents", void 0), this.contents = t;
    }
    getValue() {
      throw this.contents;
    }
    toPromise() {
      return this.contents;
    }
    valueMaybe() {
    }
    promiseMaybe() {
      return this.contents;
    }
    promiseOrThrow() {
      return this.contents;
    }
    errorMaybe() {
    }
    map(t) {
      return sn(this.contents.then((n) => {
        const o = t(n);
        if (Tn(o)) {
          const r = o;
          switch (r.state) {
            case "hasValue":
              return r.contents;
            case "hasError":
              throw r.contents;
            case "loading":
              return r.contents;
          }
        }
        return o;
      }).catch((n) => {
        if (Me(n))
          return n.then(() => this.map(t).contents);
        throw n;
      }));
    }
  }
  function mo(e) {
    return Object.freeze(new iS(e));
  }
  function Or(e) {
    return Object.freeze(new sS(e));
  }
  function sn(e) {
    return Object.freeze(new Cu(e));
  }
  function wu() {
    return Object.freeze(new Cu(new Promise(() => {
    })));
  }
  function lS(e) {
    return e.every((t) => t.state === "hasValue") ? mo(e.map((t) => t.contents)) : e.some((t) => t.state === "hasError") ? Or(Ie(e.find((t) => t.state === "hasError"), "Invalid loadable passed to loadableAll").contents) : sn(Promise.all(e.map((t) => t.contents)));
  }
  function $u(e) {
    const n = (Array.isArray(e) ? e : Object.getOwnPropertyNames(e).map((r) => e[r])).map((r) => Tn(r) ? r : Me(r) ? sn(r) : mo(r)), o = lS(n);
    return Array.isArray(e) ? o : o.map((r) => Object.getOwnPropertyNames(e).reduce((a, i, s) => ({
      ...a,
      [i]: r[s]
    }), {}));
  }
  function Tn(e) {
    return e instanceof Fr;
  }
  const cS = {
    of: (e) => Me(e) ? sn(e) : Tn(e) ? e : mo(e),
    error: (e) => Or(e),
    loading: () => wu(),
    all: $u,
    isLoadable: Tn
  };
  var un = {
    loadableWithValue: mo,
    loadableWithError: Or,
    loadableWithPromise: sn,
    loadableLoading: wu,
    loadableAll: $u,
    isLoadable: Tn,
    RecoilLoadable: cS
  }, uS = un.loadableWithValue, dS = un.loadableWithError, pS = un.loadableWithPromise, fS = un.loadableLoading, hS = un.loadableAll, mS = un.isLoadable, gS = un.RecoilLoadable, go = Object.freeze({
    __proto__: null,
    loadableWithValue: uS,
    loadableWithError: dS,
    loadableWithPromise: pS,
    loadableLoading: fS,
    loadableAll: hS,
    isLoadable: mS,
    RecoilLoadable: gS
  });
  const Wa = {
    RECOIL_DUPLICATE_ATOM_KEY_CHECKING_ENABLED: true,
    RECOIL_GKS_ENABLED: /* @__PURE__ */ new Set([
      "recoil_hamt_2020",
      "recoil_sync_external_store",
      "recoil_suppress_rerender_in_callback",
      "recoil_memory_managament_2020"
    ])
  };
  function vS(e, t) {
    var n, o;
    const r = (n = {}[e]) === null || n === void 0 || (o = n.toLowerCase()) === null || o === void 0 ? void 0 : o.trim();
    if (r == null || r === "")
      return;
    if (![
      "true",
      "false"
    ].includes(r))
      throw ve(`{"env":{}}.env.${e} value must be 'true', 'false', or empty: ${r}`);
    t(r === "true");
  }
  function bS(e, t) {
    var n;
    const o = (n = {}[e]) === null || n === void 0 ? void 0 : n.trim();
    o == null || o === "" || t(o.split(/\s*,\s*|\s+/));
  }
  function yS() {
    var e;
    typeof {
      env: {}
    } > "u" || ((e = {
      env: {}
    }) === null || e === void 0 ? void 0 : e.env) != null && (vS("RECOIL_DUPLICATE_ATOM_KEY_CHECKING_ENABLED", (t) => {
      Wa.RECOIL_DUPLICATE_ATOM_KEY_CHECKING_ENABLED = t;
    }), bS("RECOIL_GKS_ENABLED", (t) => {
      t.forEach((n) => {
        Wa.RECOIL_GKS_ENABLED.add(n);
      });
    }));
  }
  yS();
  var Fn = Wa;
  function Br(e) {
    return Fn.RECOIL_GKS_ENABLED.has(e);
  }
  Br.setPass = (e) => {
    Fn.RECOIL_GKS_ENABLED.add(e);
  };
  Br.setFail = (e) => {
    Fn.RECOIL_GKS_ENABLED.delete(e);
  };
  Br.clear = () => {
    Fn.RECOIL_GKS_ENABLED.clear();
  };
  var Ee = Br;
  function xS(e, t, { error: n } = {}) {
    return null;
  }
  var SS = xS, Ei = SS, _a, Ca, wa;
  const RS = (_a = Ne.createMutableSource) !== null && _a !== void 0 ? _a : Ne.unstable_createMutableSource, Eu = (Ca = Ne.useMutableSource) !== null && Ca !== void 0 ? Ca : Ne.unstable_useMutableSource, Tu = (wa = Ne.useSyncExternalStore) !== null && wa !== void 0 ? wa : Ne.unstable_useSyncExternalStore;
  function _S() {
    var e;
    const { ReactCurrentDispatcher: t, ReactCurrentOwner: n } = Ne.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED;
    return ((e = t == null ? void 0 : t.current) !== null && e !== void 0 ? e : n.currentDispatcher).useSyncExternalStore != null;
  }
  function CS() {
    return Ee("recoil_transition_support") ? {
      mode: "TRANSITION_SUPPORT",
      early: true,
      concurrent: true
    } : Ee("recoil_sync_external_store") && Tu != null ? {
      mode: "SYNC_EXTERNAL_STORE",
      early: true,
      concurrent: false
    } : Ee("recoil_mutable_source") && Eu != null && typeof window < "u" && !window.$disableRecoilValueMutableSource_TEMP_HACK_DO_NOT_USE ? Ee("recoil_suppress_rerender_in_callback") ? {
      mode: "MUTABLE_SOURCE",
      early: true,
      concurrent: true
    } : {
      mode: "MUTABLE_SOURCE",
      early: false,
      concurrent: false
    } : Ee("recoil_suppress_rerender_in_callback") ? {
      mode: "LEGACY",
      early: true,
      concurrent: false
    } : {
      mode: "LEGACY",
      early: false,
      concurrent: false
    };
  }
  function wS() {
    return false;
  }
  var vo = {
    createMutableSource: RS,
    useMutableSource: Eu,
    useSyncExternalStore: Tu,
    currentRendererSupportsUseSyncExternalStore: _S,
    reactMode: CS,
    isFastRefreshEnabled: wS
  };
  class Ti {
    constructor(t) {
      he(this, "key", void 0), this.key = t;
    }
    toJSON() {
      return {
        key: this.key
      };
    }
  }
  class ku extends Ti {
  }
  class Au extends Ti {
  }
  function $S(e) {
    return e instanceof ku || e instanceof Au;
  }
  var Dr = {
    AbstractRecoilValue: Ti,
    RecoilState: ku,
    RecoilValueReadOnly: Au,
    isRecoilValue: $S
  }, ES = Dr.AbstractRecoilValue, TS = Dr.RecoilState, kS = Dr.RecoilValueReadOnly, AS = Dr.isRecoilValue, kn = Object.freeze({
    __proto__: null,
    AbstractRecoilValue: ES,
    RecoilState: TS,
    RecoilValueReadOnly: kS,
    isRecoilValue: AS
  });
  function MS(e, t) {
    return function* () {
      let n = 0;
      for (const o of e)
        yield t(o, n++);
    }();
  }
  var jr = MS;
  class Mu {
  }
  const PS = new Mu(), ln = /* @__PURE__ */ new Map(), ki = /* @__PURE__ */ new Map();
  function LS(e) {
    return jr(e, (t) => Ie(ki.get(t)));
  }
  function IS(e) {
    if (ln.has(e)) {
      const t = `Duplicate atom key "${e}". This is a FATAL ERROR in
      production. But it is safe to ignore this warning if it occurred because of
      hot module replacement.`;
      console.warn(t);
    }
  }
  function NS(e) {
    Fn.RECOIL_DUPLICATE_ATOM_KEY_CHECKING_ENABLED && IS(e.key), ln.set(e.key, e);
    const t = e.set == null ? new kn.RecoilValueReadOnly(e.key) : new kn.RecoilState(e.key);
    return ki.set(e.key, t), t;
  }
  class Pu extends Error {
  }
  function FS(e) {
    const t = ln.get(e);
    if (t == null)
      throw new Pu(`Missing definition for RecoilValue: "${e}""`);
    return t;
  }
  function OS(e) {
    return ln.get(e);
  }
  const or = /* @__PURE__ */ new Map();
  function BS(e) {
    var t;
    if (!Ee("recoil_memory_managament_2020"))
      return;
    const n = ln.get(e);
    if (n != null && (t = n.shouldDeleteConfigOnRelease) !== null && t !== void 0 && t.call(n)) {
      var o;
      ln.delete(e), (o = Lu(e)) === null || o === void 0 || o(), or.delete(e);
    }
  }
  function DS(e, t) {
    Ee("recoil_memory_managament_2020") && (t === void 0 ? or.delete(e) : or.set(e, t));
  }
  function Lu(e) {
    return or.get(e);
  }
  var Je = {
    nodes: ln,
    recoilValues: ki,
    registerNode: NS,
    getNode: FS,
    getNodeMaybe: OS,
    deleteNodeConfigIfPossible: BS,
    setConfigDeletionHandler: DS,
    getConfigDeletionHandler: Lu,
    recoilValuesForKeys: LS,
    NodeMissingError: Pu,
    DefaultValue: Mu,
    DEFAULT_VALUE: PS
  };
  function jS(e, t) {
    t();
  }
  var zS = {
    enqueueExecution: jS
  };
  function VS(e, t) {
    return t = {
      exports: {}
    }, e(t, t.exports), t.exports;
  }
  var US = VS(function(e) {
    var t = typeof Symbol == "function" && typeof Symbol.iterator == "symbol" ? function(S) {
      return typeof S;
    } : function(S) {
      return S && typeof Symbol == "function" && S.constructor === Symbol && S !== Symbol.prototype ? "symbol" : typeof S;
    }, n = {}, o = 5, r = Math.pow(2, o), a = r - 1, i = r / 2, s = r / 4, l = {}, c = function(x) {
      return function() {
        return x;
      };
    }, d = n.hash = function(S) {
      var x = typeof S > "u" ? "undefined" : t(S);
      if (x === "number")
        return S;
      x !== "string" && (S += "");
      for (var N = 0, K = 0, q = S.length; K < q; ++K) {
        var J = S.charCodeAt(K);
        N = (N << 5) - N + J | 0;
      }
      return N;
    }, p = function(x) {
      return x -= x >> 1 & 1431655765, x = (x & 858993459) + (x >> 2 & 858993459), x = x + (x >> 4) & 252645135, x += x >> 8, x += x >> 16, x & 127;
    }, m = function(x, N) {
      return N >>> x & a;
    }, v = function(x) {
      return 1 << x;
    }, g = function(x, N) {
      return p(x & N - 1);
    }, h = function(x, N, K, q) {
      var J = q;
      if (!x) {
        var pe = q.length;
        J = new Array(pe);
        for (var ce = 0; ce < pe; ++ce)
          J[ce] = q[ce];
      }
      return J[N] = K, J;
    }, C = function(x, N, K) {
      var q = K.length - 1, J = 0, pe = 0, ce = K;
      if (x)
        J = pe = N;
      else
        for (ce = new Array(q); J < N; )
          ce[pe++] = K[J++];
      for (++J; J <= q; )
        ce[pe++] = K[J++];
      return x && (ce.length = q), ce;
    }, $ = function(x, N, K, q) {
      var J = q.length;
      if (x) {
        for (var pe = J; pe >= N; )
          q[pe--] = q[pe];
        return q[N] = K, q;
      }
      for (var ce = 0, ue = 0, be = new Array(J + 1); ce < N; )
        be[ue++] = q[ce++];
      for (be[N] = K; ce < J; )
        be[++ue] = q[ce++];
      return be;
    }, R = 1, b = 2, y = 3, E = 4, w = {
      __hamt_isEmpty: true
    }, T = function(x) {
      return x === w || x && x.__hamt_isEmpty;
    }, I = function(x, N, K, q) {
      return {
        type: R,
        edit: x,
        hash: N,
        key: K,
        value: q,
        _modify: D
      };
    }, V = function(x, N, K) {
      return {
        type: b,
        edit: x,
        hash: N,
        children: K,
        _modify: me
      };
    }, P = function(x, N, K) {
      return {
        type: y,
        edit: x,
        mask: N,
        children: K,
        _modify: ne
      };
    }, U = function(x, N, K) {
      return {
        type: E,
        edit: x,
        size: N,
        children: K,
        _modify: de
      };
    }, F = function(x) {
      return x === w || x.type === R || x.type === b;
    }, O = function(x, N, K, q, J) {
      for (var pe = [], ce = q, ue = 0, be = 0; ce; ++be)
        ce & 1 && (pe[be] = J[ue++]), ce >>>= 1;
      return pe[N] = K, U(x, ue + 1, pe);
    }, B = function(x, N, K, q) {
      for (var J = new Array(N - 1), pe = 0, ce = 0, ue = 0, be = q.length; ue < be; ++ue)
        if (ue !== K) {
          var Pe = q[ue];
          Pe && !T(Pe) && (J[pe++] = Pe, ce |= 1 << ue);
        }
      return P(x, ce, J);
    }, j = function S(x, N, K, q, J, pe) {
      if (K === J)
        return V(x, K, [
          pe,
          q
        ]);
      var ce = m(N, K), ue = m(N, J);
      return P(x, v(ce) | v(ue), ce === ue ? [
        S(x, N + o, K, q, J, pe)
      ] : ce < ue ? [
        q,
        pe
      ] : [
        pe,
        q
      ]);
    }, W = function(x, N, K, q, J, pe, ce, ue) {
      for (var be = J.length, Pe = 0; Pe < be; ++Pe) {
        var Ye = J[Pe];
        if (K(ce, Ye.key)) {
          var ze = Ye.value, st = pe(ze);
          return st === ze ? J : st === l ? (--ue.value, C(x, Pe, J)) : h(x, Pe, I(N, q, ce, st), J);
        }
      }
      var gt = pe();
      return gt === l ? J : (++ue.value, h(x, be, I(N, q, ce, gt), J));
    }, H = function(x, N) {
      return x === N.edit;
    }, D = function(x, N, K, q, J, pe, ce) {
      if (N(pe, this.key)) {
        var ue = q(this.value);
        return ue === this.value ? this : ue === l ? (--ce.value, w) : H(x, this) ? (this.value = ue, this) : I(x, J, pe, ue);
      }
      var be = q();
      return be === l ? this : (++ce.value, j(x, K, this.hash, this, J, I(x, J, pe, be)));
    }, me = function(x, N, K, q, J, pe, ce) {
      if (J === this.hash) {
        var ue = H(x, this), be = W(ue, x, N, this.hash, this.children, q, pe, ce);
        return be === this.children ? this : be.length > 1 ? V(x, this.hash, be) : be[0];
      }
      var Pe = q();
      return Pe === l ? this : (++ce.value, j(x, K, this.hash, this, J, I(x, J, pe, Pe)));
    }, ne = function(x, N, K, q, J, pe, ce) {
      var ue = this.mask, be = this.children, Pe = m(K, J), Ye = v(Pe), ze = g(ue, Ye), st = ue & Ye, gt = st ? be[ze] : w, pn = gt._modify(x, N, K + o, q, J, pe, ce);
      if (gt === pn)
        return this;
      var Co = H(x, this), Bn = ue, Dn = void 0;
      if (st && T(pn)) {
        if (Bn &= ~Ye, !Bn)
          return w;
        if (be.length <= 2 && F(be[ze ^ 1]))
          return be[ze ^ 1];
        Dn = C(Co, ze, be);
      } else if (!st && !T(pn)) {
        if (be.length >= i)
          return O(x, Pe, pn, ue, be);
        Bn |= Ye, Dn = $(Co, ze, pn, be);
      } else
        Dn = h(Co, ze, pn, be);
      return Co ? (this.mask = Bn, this.children = Dn, this) : P(x, Bn, Dn);
    }, de = function(x, N, K, q, J, pe, ce) {
      var ue = this.size, be = this.children, Pe = m(K, J), Ye = be[Pe], ze = (Ye || w)._modify(x, N, K + o, q, J, pe, ce);
      if (Ye === ze)
        return this;
      var st = H(x, this), gt = void 0;
      if (T(Ye) && !T(ze))
        ++ue, gt = h(st, Pe, ze, be);
      else if (!T(Ye) && T(ze)) {
        if (--ue, ue <= s)
          return B(x, ue, Pe, be);
        gt = h(st, Pe, w, be);
      } else
        gt = h(st, Pe, ze, be);
      return st ? (this.size = ue, this.children = gt, this) : U(x, ue, gt);
    };
    w._modify = function(S, x, N, K, q, J, pe) {
      var ce = K();
      return ce === l ? w : (++pe.value, I(S, q, J, ce));
    };
    function _(S, x, N, K, q) {
      this._editable = S, this._edit = x, this._config = N, this._root = K, this._size = q;
    }
    _.prototype.setTree = function(S, x) {
      return this._editable ? (this._root = S, this._size = x, this) : S === this._root ? this : new _(this._editable, this._edit, this._config, S, x);
    };
    var L = n.tryGetHash = function(S, x, N, K) {
      for (var q = K._root, J = 0, pe = K._config.keyEq; ; )
        switch (q.type) {
          case R:
            return pe(N, q.key) ? q.value : S;
          case b: {
            if (x === q.hash)
              for (var ce = q.children, ue = 0, be = ce.length; ue < be; ++ue) {
                var Pe = ce[ue];
                if (pe(N, Pe.key))
                  return Pe.value;
              }
            return S;
          }
          case y: {
            var Ye = m(J, x), ze = v(Ye);
            if (q.mask & ze) {
              q = q.children[g(q.mask, ze)], J += o;
              break;
            }
            return S;
          }
          case E: {
            if (q = q.children[m(J, x)], q) {
              J += o;
              break;
            }
            return S;
          }
          default:
            return S;
        }
    };
    _.prototype.tryGetHash = function(S, x, N) {
      return L(S, x, N, this);
    };
    var A = n.tryGet = function(S, x, N) {
      return L(S, N._config.hash(x), x, N);
    };
    _.prototype.tryGet = function(S, x) {
      return A(S, x, this);
    };
    var Y = n.getHash = function(S, x, N) {
      return L(void 0, S, x, N);
    };
    _.prototype.getHash = function(S, x) {
      return Y(S, x, this);
    }, n.get = function(S, x) {
      return L(void 0, x._config.hash(S), S, x);
    }, _.prototype.get = function(S, x) {
      return A(x, S, this);
    };
    var k = n.has = function(S, x, N) {
      return L(l, S, x, N) !== l;
    };
    _.prototype.hasHash = function(S, x) {
      return k(S, x, this);
    };
    var Z = n.has = function(S, x) {
      return k(x._config.hash(S), S, x);
    };
    _.prototype.has = function(S) {
      return Z(S, this);
    };
    var Q = function(x, N) {
      return x === N;
    };
    n.make = function(S) {
      return new _(0, 0, {
        keyEq: S && S.keyEq || Q,
        hash: S && S.hash || d
      }, w, 0);
    }, n.empty = n.make();
    var z = n.isEmpty = function(S) {
      return S && !!T(S._root);
    };
    _.prototype.isEmpty = function() {
      return z(this);
    };
    var fe = n.modifyHash = function(S, x, N, K) {
      var q = {
        value: K._size
      }, J = K._root._modify(K._editable ? K._edit : NaN, K._config.keyEq, 0, S, x, N, q);
      return K.setTree(J, q.value);
    };
    _.prototype.modifyHash = function(S, x, N) {
      return fe(N, S, x, this);
    };
    var re = n.modify = function(S, x, N) {
      return fe(S, N._config.hash(x), x, N);
    };
    _.prototype.modify = function(S, x) {
      return re(x, S, this);
    };
    var ie = n.setHash = function(S, x, N, K) {
      return fe(c(N), S, x, K);
    };
    _.prototype.setHash = function(S, x, N) {
      return ie(S, x, N, this);
    };
    var te = n.set = function(S, x, N) {
      return ie(N._config.hash(S), S, x, N);
    };
    _.prototype.set = function(S, x) {
      return te(S, x, this);
    };
    var ge = c(l), _e = n.removeHash = function(S, x, N) {
      return fe(ge, S, x, N);
    };
    _.prototype.removeHash = _.prototype.deleteHash = function(S, x) {
      return _e(S, x, this);
    };
    var Be = n.remove = function(S, x) {
      return _e(x._config.hash(S), S, x);
    };
    _.prototype.remove = _.prototype.delete = function(S) {
      return Be(S, this);
    };
    var ke = n.beginMutation = function(S) {
      return new _(S._editable + 1, S._edit + 1, S._config, S._root, S._size);
    };
    _.prototype.beginMutation = function() {
      return ke(this);
    };
    var Ke = n.endMutation = function(S) {
      return S._editable = S._editable && S._editable - 1, S;
    };
    _.prototype.endMutation = function() {
      return Ke(this);
    };
    var et = n.mutate = function(S, x) {
      var N = ke(x);
      return S(N), Ke(N);
    };
    _.prototype.mutate = function(S) {
      return et(S, this);
    };
    var Ue = function(x) {
      return x && Ae(x[0], x[1], x[2], x[3], x[4]);
    }, Ae = function(x, N, K, q, J) {
      for (; K < x; ) {
        var pe = N[K++];
        if (pe && !T(pe))
          return it(pe, q, [
            x,
            N,
            K,
            q,
            J
          ]);
      }
      return Ue(J);
    }, it = function(x, N, K) {
      switch (x.type) {
        case R:
          return {
            value: N(x),
            rest: K
          };
        case b:
        case E:
        case y:
          var q = x.children;
          return Ae(q.length, q, 0, N, K);
        default:
          return Ue(K);
      }
    }, We = {
      done: true
    };
    function Ce(S) {
      this.v = S;
    }
    Ce.prototype.next = function() {
      if (!this.v)
        return We;
      var S = this.v;
      return this.v = Ue(S.rest), S;
    }, Ce.prototype[Symbol.iterator] = function() {
      return this;
    };
    var Ge = function(x, N) {
      return new Ce(it(x._root, N));
    }, Rt = function(x) {
      return [
        x.key,
        x.value
      ];
    }, ht = n.entries = function(S) {
      return Ge(S, Rt);
    };
    _.prototype.entries = _.prototype[Symbol.iterator] = function() {
      return ht(this);
    };
    var we = function(x) {
      return x.key;
    }, le = n.keys = function(S) {
      return Ge(S, we);
    };
    _.prototype.keys = function() {
      return le(this);
    };
    var mt = function(x) {
      return x.value;
    }, Zt = n.values = _.prototype.values = function(S) {
      return Ge(S, mt);
    };
    _.prototype.values = function() {
      return Zt(this);
    };
    var Ot = n.fold = function(S, x, N) {
      var K = N._root;
      if (K.type === R)
        return S(x, K.value, K.key);
      for (var q = [
        K.children
      ], J = void 0; J = q.pop(); )
        for (var pe = 0, ce = J.length; pe < ce; ) {
          var ue = J[pe++];
          ue && ue.type && (ue.type === R ? x = S(x, ue.value, ue.key) : q.push(ue.children));
        }
      return x;
    };
    _.prototype.fold = function(S, x) {
      return Ot(S, x, this);
    };
    var se = n.forEach = function(S, x) {
      return Ot(function(N, K, q) {
        return S(K, q, x);
      }, null, x);
    };
    _.prototype.forEach = function(S) {
      return se(S, this);
    };
    var $e = n.count = function(S) {
      return S._size;
    };
    _.prototype.count = function() {
      return $e(this);
    }, Object.defineProperty(_.prototype, "size", {
      get: _.prototype.count
    }), e.exports ? e.exports = n : (void 0).hamt = n;
  });
  class WS {
    constructor(t) {
      he(this, "_map", void 0), this._map = new Map(t == null ? void 0 : t.entries());
    }
    keys() {
      return this._map.keys();
    }
    entries() {
      return this._map.entries();
    }
    get(t) {
      return this._map.get(t);
    }
    has(t) {
      return this._map.has(t);
    }
    set(t, n) {
      return this._map.set(t, n), this;
    }
    delete(t) {
      return this._map.delete(t), this;
    }
    clone() {
      return Mi(this);
    }
    toMap() {
      return new Map(this._map);
    }
  }
  class Ai {
    constructor(t) {
      if (he(this, "_hamt", US.empty.beginMutation()), t instanceof Ai) {
        const n = t._hamt.endMutation();
        t._hamt = n.beginMutation(), this._hamt = n.beginMutation();
      } else if (t)
        for (const [n, o] of t.entries())
          this._hamt.set(n, o);
    }
    keys() {
      return this._hamt.keys();
    }
    entries() {
      return this._hamt.entries();
    }
    get(t) {
      return this._hamt.get(t);
    }
    has(t) {
      return this._hamt.has(t);
    }
    set(t, n) {
      return this._hamt.set(t, n), this;
    }
    delete(t) {
      return this._hamt.delete(t), this;
    }
    clone() {
      return Mi(this);
    }
    toMap() {
      return new Map(this._hamt);
    }
  }
  function Mi(e) {
    return Ee("recoil_hamt_2020") ? new Ai(e) : new WS(e);
  }
  var HS = {
    persistentMap: Mi
  }, KS = HS.persistentMap, qS = Object.freeze({
    __proto__: null,
    persistentMap: KS
  });
  function GS(e, ...t) {
    const n = /* @__PURE__ */ new Set();
    e:
      for (const o of e) {
        for (const r of t)
          if (r.has(o))
            continue e;
        n.add(o);
      }
    return n;
  }
  var no = GS;
  function YS(e, t) {
    const n = /* @__PURE__ */ new Map();
    return e.forEach((o, r) => {
      n.set(r, t(o, r));
    }), n;
  }
  var rr = YS;
  function XS() {
    return {
      nodeDeps: /* @__PURE__ */ new Map(),
      nodeToNodeSubscriptions: /* @__PURE__ */ new Map()
    };
  }
  function ZS(e) {
    return {
      nodeDeps: rr(e.nodeDeps, (t) => new Set(t)),
      nodeToNodeSubscriptions: rr(e.nodeToNodeSubscriptions, (t) => new Set(t))
    };
  }
  function $a(e, t, n, o) {
    const { nodeDeps: r, nodeToNodeSubscriptions: a } = n, i = r.get(e);
    if (i && o && i !== o.nodeDeps.get(e))
      return;
    r.set(e, t);
    const s = i == null ? t : no(t, i);
    for (const l of s)
      a.has(l) || a.set(l, /* @__PURE__ */ new Set()), Ie(a.get(l)).add(e);
    if (i) {
      const l = no(i, t);
      for (const c of l) {
        if (!a.has(c))
          return;
        const d = Ie(a.get(c));
        d.delete(e), d.size === 0 && a.delete(c);
      }
    }
  }
  function JS(e, t, n, o) {
    var r, a, i, s;
    const l = n.getState();
    o === l.currentTree.version || o === ((r = l.nextTree) === null || r === void 0 ? void 0 : r.version) || ((a = l.previousTree) === null || a === void 0 || a.version);
    const c = n.getGraph(o);
    if ($a(e, t, c), o === ((i = l.previousTree) === null || i === void 0 ? void 0 : i.version)) {
      const p = n.getGraph(l.currentTree.version);
      $a(e, t, p, c);
    }
    if (o === ((s = l.previousTree) === null || s === void 0 ? void 0 : s.version) || o === l.currentTree.version) {
      var d;
      const p = (d = l.nextTree) === null || d === void 0 ? void 0 : d.version;
      if (p !== void 0) {
        const m = n.getGraph(p);
        $a(e, t, m, c);
      }
    }
  }
  var bo = {
    cloneGraph: ZS,
    graph: XS,
    saveDepsToStore: JS
  };
  let QS = 0;
  const eR = () => QS++;
  let tR = 0;
  const nR = () => tR++;
  let oR = 0;
  const rR = () => oR++;
  var zr = {
    getNextTreeStateVersion: eR,
    getNextStoreID: nR,
    getNextComponentID: rR
  };
  const { persistentMap: wl } = qS, { graph: aR } = bo, { getNextTreeStateVersion: Iu } = zr;
  function Nu() {
    const e = Iu();
    return {
      version: e,
      stateID: e,
      transactionMetadata: {},
      dirtyAtoms: /* @__PURE__ */ new Set(),
      atomValues: wl(),
      nonvalidatedAtoms: wl()
    };
  }
  function iR() {
    const e = Nu();
    return {
      currentTree: e,
      nextTree: null,
      previousTree: null,
      commitDepth: 0,
      knownAtoms: /* @__PURE__ */ new Set(),
      knownSelectors: /* @__PURE__ */ new Set(),
      transactionSubscriptions: /* @__PURE__ */ new Map(),
      nodeTransactionSubscriptions: /* @__PURE__ */ new Map(),
      nodeToComponentSubscriptions: /* @__PURE__ */ new Map(),
      queuedComponentCallbacks_DEPRECATED: [],
      suspendedComponentResolvers: /* @__PURE__ */ new Set(),
      graphsByVersion: (/* @__PURE__ */ new Map()).set(e.version, aR()),
      retention: {
        referenceCounts: /* @__PURE__ */ new Map(),
        nodesRetainedByZone: /* @__PURE__ */ new Map(),
        retainablesToCheckForRelease: /* @__PURE__ */ new Set()
      },
      nodeCleanupFunctions: /* @__PURE__ */ new Map()
    };
  }
  var Fu = {
    makeEmptyTreeState: Nu,
    makeEmptyStoreState: iR,
    getNextTreeStateVersion: Iu
  };
  class Ou {
  }
  function sR() {
    return new Ou();
  }
  var Vr = {
    RetentionZone: Ou,
    retentionZone: sR
  };
  function lR(e, t) {
    const n = new Set(e);
    return n.add(t), n;
  }
  function cR(e, t) {
    const n = new Set(e);
    return n.delete(t), n;
  }
  function uR(e, t, n) {
    const o = new Map(e);
    return o.set(t, n), o;
  }
  function dR(e, t, n) {
    const o = new Map(e);
    return o.set(t, n(o.get(t))), o;
  }
  function pR(e, t) {
    const n = new Map(e);
    return n.delete(t), n;
  }
  function fR(e, t) {
    const n = new Map(e);
    return t.forEach((o) => n.delete(o)), n;
  }
  var Bu = {
    setByAddingToSet: lR,
    setByDeletingFromSet: cR,
    mapBySettingInMap: uR,
    mapByUpdatingInMap: dR,
    mapByDeletingFromMap: pR,
    mapByDeletingMultipleFromMap: fR
  };
  function* hR(e, t) {
    let n = 0;
    for (const o of e)
      t(o, n++) && (yield o);
  }
  var Pi = hR;
  function mR(e, t) {
    return new Proxy(e, {
      get: (o, r) => (!(r in o) && r in t && (o[r] = t[r]()), o[r]),
      ownKeys: (o) => Object.keys(o)
    });
  }
  var Du = mR;
  const { getNode: yo, getNodeMaybe: gR, recoilValuesForKeys: $l } = Je, { RetentionZone: El } = Vr, { setByAddingToSet: vR } = Bu, bR = Object.freeze(/* @__PURE__ */ new Set());
  class yR extends Error {
  }
  function xR(e, t, n) {
    if (!Ee("recoil_memory_managament_2020"))
      return () => {
      };
    const { nodesRetainedByZone: o } = e.getState().retention;
    function r(a) {
      let i = o.get(a);
      i || o.set(a, i = /* @__PURE__ */ new Set()), i.add(t);
    }
    if (n instanceof El)
      r(n);
    else if (Array.isArray(n))
      for (const a of n)
        r(a);
    return () => {
      if (!Ee("recoil_memory_managament_2020"))
        return;
      const { retention: a } = e.getState();
      function i(s) {
        const l = a.nodesRetainedByZone.get(s);
        l == null ? void 0 : l.delete(t), l && l.size === 0 && a.nodesRetainedByZone.delete(s);
      }
      if (n instanceof El)
        i(n);
      else if (Array.isArray(n))
        for (const s of n)
          i(s);
    };
  }
  function Li(e, t, n, o) {
    const r = e.getState();
    if (r.nodeCleanupFunctions.has(n))
      return;
    const a = yo(n), i = xR(e, n, a.retainedBy), s = a.init(e, t, o);
    r.nodeCleanupFunctions.set(n, () => {
      s(), i();
    });
  }
  function SR(e, t, n) {
    Li(e, e.getState().currentTree, t, n);
  }
  function RR(e, t) {
    var n;
    const o = e.getState();
    (n = o.nodeCleanupFunctions.get(t)) === null || n === void 0 || n(), o.nodeCleanupFunctions.delete(t);
  }
  function _R(e, t, n) {
    return Li(e, t, n, "get"), yo(n).get(e, t);
  }
  function ju(e, t, n) {
    return yo(n).peek(e, t);
  }
  function CR(e, t, n) {
    var o;
    const r = gR(t);
    return r == null || (o = r.invalidate) === null || o === void 0 || o.call(r, e), {
      ...e,
      atomValues: e.atomValues.clone().delete(t),
      nonvalidatedAtoms: e.nonvalidatedAtoms.clone().set(t, n),
      dirtyAtoms: vR(e.dirtyAtoms, t)
    };
  }
  function wR(e, t, n, o) {
    const r = yo(n);
    if (r.set == null)
      throw new yR(`Attempt to set read-only RecoilValue: ${n}`);
    const a = r.set;
    return Li(e, t, n, "set"), a(e, t, o);
  }
  function $R(e, t, n) {
    const o = e.getState(), r = e.getGraph(t.version), a = yo(n).nodeType;
    return Du({
      type: a
    }, {
      loadable: () => ju(e, t, n),
      isActive: () => o.knownAtoms.has(n) || o.knownSelectors.has(n),
      isSet: () => a === "selector" ? false : t.atomValues.has(n),
      isModified: () => t.dirtyAtoms.has(n),
      deps: () => {
        var i;
        return $l((i = r.nodeDeps.get(n)) !== null && i !== void 0 ? i : []);
      },
      subscribers: () => {
        var i, s;
        return {
          nodes: $l(Pi(zu(e, t, /* @__PURE__ */ new Set([
            n
          ])), (l) => l !== n)),
          components: jr((i = (s = o.nodeToComponentSubscriptions.get(n)) === null || s === void 0 ? void 0 : s.values()) !== null && i !== void 0 ? i : [], ([l]) => ({
            name: l
          }))
        };
      }
    });
  }
  function zu(e, t, n) {
    const o = /* @__PURE__ */ new Set(), r = Array.from(n), a = e.getGraph(t.version);
    for (let s = r.pop(); s; s = r.pop()) {
      var i;
      o.add(s);
      const l = (i = a.nodeToNodeSubscriptions.get(s)) !== null && i !== void 0 ? i : bR;
      for (const c of l)
        o.has(c) || r.push(c);
    }
    return o;
  }
  var Yt = {
    getNodeLoadable: _R,
    peekNodeLoadable: ju,
    setNodeValue: wR,
    initializeNode: SR,
    cleanUpNode: RR,
    setUnvalidatedAtomValue_DEPRECATED: CR,
    peekNodeInfo: $R,
    getDownstreamNodes: zu
  };
  let Vu = null;
  function ER(e) {
    Vu = e;
  }
  function TR() {
    var e;
    (e = Vu) === null || e === void 0 || e();
  }
  var Uu = {
    setInvalidateMemoizedSnapshot: ER,
    invalidateMemoizedSnapshot: TR
  };
  const { getDownstreamNodes: kR, getNodeLoadable: Wu, setNodeValue: AR } = Yt, { getNextComponentID: MR } = zr, { getNode: PR, getNodeMaybe: Hu } = Je, { DefaultValue: Ii } = Je, { reactMode: LR } = vo, { AbstractRecoilValue: IR, RecoilState: NR, RecoilValueReadOnly: FR, isRecoilValue: OR } = kn, { invalidateMemoizedSnapshot: BR } = Uu;
  function DR(e, { key: t }, n = e.getState().currentTree) {
    var o, r;
    const a = e.getState();
    n.version === a.currentTree.version || n.version === ((o = a.nextTree) === null || o === void 0 ? void 0 : o.version) || (n.version, (r = a.previousTree) === null || r === void 0 || r.version);
    const i = Wu(e, n, t);
    return i.state === "loading" && i.contents.catch(() => {
    }), i;
  }
  function jR(e, t) {
    const n = e.clone();
    return t.forEach((o, r) => {
      o.state === "hasValue" && o.contents instanceof Ii ? n.delete(r) : n.set(r, o);
    }), n;
  }
  function zR(e, t, { key: n }, o) {
    if (typeof o == "function") {
      const r = Wu(e, t, n);
      if (r.state === "loading") {
        const a = `Tried to set atom or selector "${n}" using an updater function while the current state is pending, this is not currently supported.`;
        throw ve(a);
      } else if (r.state === "hasError")
        throw r.contents;
      return o(r.contents);
    } else
      return o;
  }
  function VR(e, t, n) {
    if (n.type === "set") {
      const { recoilValue: r, valueOrUpdater: a } = n, i = zR(e, t, r, a), s = AR(e, t, r.key, i);
      for (const [l, c] of s.entries())
        Ha(t, l, c);
    } else if (n.type === "setLoadable") {
      const { recoilValue: { key: r }, loadable: a } = n;
      Ha(t, r, a);
    } else if (n.type === "markModified") {
      const { recoilValue: { key: r } } = n;
      t.dirtyAtoms.add(r);
    } else if (n.type === "setUnvalidated") {
      var o;
      const { recoilValue: { key: r }, unvalidatedValue: a } = n, i = Hu(r);
      i == null || (o = i.invalidate) === null || o === void 0 || o.call(i, t), t.atomValues.delete(r), t.nonvalidatedAtoms.set(r, a), t.dirtyAtoms.add(r);
    } else
      Ei(`Unknown action ${n.type}`);
  }
  function Ha(e, t, n) {
    n.state === "hasValue" && n.contents instanceof Ii ? e.atomValues.delete(t) : e.atomValues.set(t, n), e.dirtyAtoms.add(t), e.nonvalidatedAtoms.delete(t);
  }
  function Ku(e, t) {
    e.replaceState((n) => {
      const o = qu(n);
      for (const r of t)
        VR(e, o, r);
      return Gu(e, o), BR(), o;
    });
  }
  function Ur(e, t) {
    if (oo.length) {
      const n = oo[oo.length - 1];
      let o = n.get(e);
      o || n.set(e, o = []), o.push(t);
    } else
      Ku(e, [
        t
      ]);
  }
  const oo = [];
  function UR() {
    const e = /* @__PURE__ */ new Map();
    return oo.push(e), () => {
      for (const [t, n] of e)
        Ku(t, n);
      oo.pop();
    };
  }
  function qu(e) {
    return {
      ...e,
      atomValues: e.atomValues.clone(),
      nonvalidatedAtoms: e.nonvalidatedAtoms.clone(),
      dirtyAtoms: new Set(e.dirtyAtoms)
    };
  }
  function Gu(e, t) {
    const n = kR(e, t, t.dirtyAtoms);
    for (const a of n) {
      var o, r;
      (o = Hu(a)) === null || o === void 0 || (r = o.invalidate) === null || r === void 0 || r.call(o, t);
    }
  }
  function Yu(e, t, n) {
    Ur(e, {
      type: "set",
      recoilValue: t,
      valueOrUpdater: n
    });
  }
  function WR(e, t, n) {
    if (n instanceof Ii)
      return Yu(e, t, n);
    Ur(e, {
      type: "setLoadable",
      recoilValue: t,
      loadable: n
    });
  }
  function HR(e, t) {
    Ur(e, {
      type: "markModified",
      recoilValue: t
    });
  }
  function KR(e, t, n) {
    Ur(e, {
      type: "setUnvalidated",
      recoilValue: t,
      unvalidatedValue: n
    });
  }
  function qR(e, { key: t }, n, o = null) {
    const r = MR(), a = e.getState();
    a.nodeToComponentSubscriptions.has(t) || a.nodeToComponentSubscriptions.set(t, /* @__PURE__ */ new Map()), Ie(a.nodeToComponentSubscriptions.get(t)).set(r, [
      o ?? "<not captured>",
      n
    ]);
    const i = LR();
    if (i.early && (i.mode === "LEGACY" || i.mode === "MUTABLE_SOURCE")) {
      const s = e.getState().nextTree;
      s && s.dirtyAtoms.has(t) && n(s);
    }
    return {
      release: () => {
        const s = e.getState(), l = s.nodeToComponentSubscriptions.get(t);
        l === void 0 || !l.has(r) || (l.delete(r), l.size === 0 && s.nodeToComponentSubscriptions.delete(t));
      }
    };
  }
  function GR(e, t) {
    var n;
    const { currentTree: o } = e.getState(), r = PR(t.key);
    (n = r.clearCache) === null || n === void 0 || n.call(r, e, o);
  }
  var wt = {
    RecoilValueReadOnly: FR,
    AbstractRecoilValue: IR,
    RecoilState: NR,
    getRecoilValueAsLoadable: DR,
    setRecoilValue: Yu,
    setRecoilValueLoadable: WR,
    markRecoilValueModified: HR,
    setUnvalidatedRecoilValue: KR,
    subscribeToRecoilValue: qR,
    isRecoilValue: OR,
    applyAtomValueWrites: jR,
    batchStart: UR,
    writeLoadableToTreeState: Ha,
    invalidateDownstreams: Gu,
    copyTreeState: qu,
    refreshRecoilValue: GR
  };
  function YR(e, t, n) {
    const o = e.entries();
    let r = o.next();
    for (; !r.done; ) {
      const a = r.value;
      if (t.call(n, a[1], a[0], e))
        return true;
      r = o.next();
    }
    return false;
  }
  var XR = YR;
  const { cleanUpNode: ZR } = Yt, { deleteNodeConfigIfPossible: JR, getNode: Xu } = Je, { RetentionZone: Zu } = Vr, QR = 12e4, Ju = /* @__PURE__ */ new Set();
  function Qu(e, t) {
    const n = e.getState(), o = n.currentTree;
    if (n.nextTree)
      return;
    const r = /* @__PURE__ */ new Set();
    for (const i of t)
      if (i instanceof Zu)
        for (const s of o_(n, i))
          r.add(s);
      else
        r.add(i);
    const a = e_(e, r);
    for (const i of a)
      n_(e, o, i);
  }
  function e_(e, t) {
    const n = e.getState(), o = n.currentTree, r = e.getGraph(o.version), a = /* @__PURE__ */ new Set(), i = /* @__PURE__ */ new Set();
    return s(t), a;
    function s(l) {
      const c = /* @__PURE__ */ new Set(), d = t_(e, o, l, a, i);
      for (const g of d) {
        var p;
        if (Xu(g).retainedBy === "recoilRoot") {
          i.add(g);
          continue;
        }
        if (((p = n.retention.referenceCounts.get(g)) !== null && p !== void 0 ? p : 0) > 0) {
          i.add(g);
          continue;
        }
        if (ed(g).some((C) => n.retention.referenceCounts.get(C))) {
          i.add(g);
          continue;
        }
        const h = r.nodeToNodeSubscriptions.get(g);
        if (h && XR(h, (C) => i.has(C))) {
          i.add(g);
          continue;
        }
        a.add(g), c.add(g);
      }
      const m = /* @__PURE__ */ new Set();
      for (const g of c)
        for (const h of (v = r.nodeDeps.get(g)) !== null && v !== void 0 ? v : Ju) {
          var v;
          a.has(h) || m.add(h);
        }
      m.size && s(m);
    }
  }
  function t_(e, t, n, o, r) {
    const a = e.getGraph(t.version), i = [], s = /* @__PURE__ */ new Set();
    for (; n.size > 0; )
      l(Ie(n.values().next().value));
    return i;
    function l(c) {
      if (o.has(c) || r.has(c)) {
        n.delete(c);
        return;
      }
      if (s.has(c))
        return;
      const d = a.nodeToNodeSubscriptions.get(c);
      if (d)
        for (const p of d)
          l(p);
      s.add(c), n.delete(c), i.push(c);
    }
  }
  function n_(e, t, n) {
    if (!Ee("recoil_memory_managament_2020"))
      return;
    ZR(e, n);
    const o = e.getState();
    o.knownAtoms.delete(n), o.knownSelectors.delete(n), o.nodeTransactionSubscriptions.delete(n), o.retention.referenceCounts.delete(n);
    const r = ed(n);
    for (const l of r) {
      var a;
      (a = o.retention.nodesRetainedByZone.get(l)) === null || a === void 0 || a.delete(n);
    }
    t.atomValues.delete(n), t.dirtyAtoms.delete(n), t.nonvalidatedAtoms.delete(n);
    const i = o.graphsByVersion.get(t.version);
    if (i) {
      const l = i.nodeDeps.get(n);
      if (l !== void 0) {
        i.nodeDeps.delete(n);
        for (const c of l) {
          var s;
          (s = i.nodeToNodeSubscriptions.get(c)) === null || s === void 0 || s.delete(n);
        }
      }
      i.nodeToNodeSubscriptions.delete(n);
    }
    JR(n);
  }
  function o_(e, t) {
    var n;
    return (n = e.retention.nodesRetainedByZone.get(t)) !== null && n !== void 0 ? n : Ju;
  }
  function ed(e) {
    const t = Xu(e).retainedBy;
    return t === void 0 || t === "components" || t === "recoilRoot" ? [] : t instanceof Zu ? [
      t
    ] : t;
  }
  function r_(e, t) {
    const n = e.getState();
    n.nextTree ? n.retention.retainablesToCheckForRelease.add(t) : Qu(e, /* @__PURE__ */ new Set([
      t
    ]));
  }
  function a_(e, t, n) {
    var o;
    if (!Ee("recoil_memory_managament_2020"))
      return;
    const r = e.getState().retention.referenceCounts, a = ((o = r.get(t)) !== null && o !== void 0 ? o : 0) + n;
    a === 0 ? td(e, t) : r.set(t, a);
  }
  function td(e, t) {
    if (!Ee("recoil_memory_managament_2020"))
      return;
    e.getState().retention.referenceCounts.delete(t), r_(e, t);
  }
  function i_(e) {
    if (!Ee("recoil_memory_managament_2020"))
      return;
    const t = e.getState();
    Qu(e, t.retention.retainablesToCheckForRelease), t.retention.retainablesToCheckForRelease.clear();
  }
  function s_(e) {
    return e === void 0 ? "recoilRoot" : e;
  }
  var dn = {
    SUSPENSE_TIMEOUT_MS: QR,
    updateRetainCount: a_,
    updateRetainCountToZero: td,
    releaseScheduledRetainablesNow: i_,
    retainedByOptionWithDefault: s_
  };
  const { unstable_batchedUpdates: l_ } = tS;
  var c_ = {
    unstable_batchedUpdates: l_
  };
  const { unstable_batchedUpdates: u_ } = c_;
  var d_ = {
    unstable_batchedUpdates: u_
  };
  const { batchStart: p_ } = wt, { unstable_batchedUpdates: f_ } = d_;
  let Ni = f_ || ((e) => e());
  const h_ = (e) => {
    Ni = e;
  }, m_ = () => Ni, g_ = (e) => {
    Ni(() => {
      let t = () => {
      };
      try {
        t = p_(), e();
      } finally {
        t();
      }
    });
  };
  var Wr = {
    getBatcher: m_,
    setBatcher: h_,
    batchUpdates: g_
  };
  function* v_(e) {
    for (const t of e)
      for (const n of t)
        yield n;
  }
  var nd = v_;
  const od = typeof Window > "u" || typeof window > "u", b_ = (e) => !od && (e === window || e instanceof Window), y_ = typeof navigator < "u" && navigator.product === "ReactNative";
  var Hr = {
    isSSR: od,
    isReactNative: y_,
    isWindow: b_
  };
  function x_(e, t) {
    let n;
    return (...o) => {
      n || (n = {});
      const r = t(...o);
      return Object.hasOwnProperty.call(n, r) || (n[r] = e(...o)), n[r];
    };
  }
  function S_(e, t) {
    let n, o;
    return (...r) => {
      const a = t(...r);
      return n === a || (n = a, o = e(...r)), o;
    };
  }
  function R_(e, t) {
    let n, o;
    return [
      (...i) => {
        const s = t(...i);
        return n === s || (n = s, o = e(...i)), o;
      },
      () => {
        n = null;
      }
    ];
  }
  var __ = {
    memoizeWithArgsHash: x_,
    memoizeOneWithArgsHash: S_,
    memoizeOneWithArgsHashAndInvalidation: R_
  };
  const { batchUpdates: Ka } = Wr, { initializeNode: C_, peekNodeInfo: w_ } = Yt, { graph: $_ } = bo, { getNextStoreID: E_ } = zr, { DEFAULT_VALUE: T_, recoilValues: Tl, recoilValuesForKeys: kl } = Je, { AbstractRecoilValue: k_, getRecoilValueAsLoadable: A_, setRecoilValue: Al, setUnvalidatedRecoilValue: M_ } = wt, { updateRetainCount: Ko } = dn, { setInvalidateMemoizedSnapshot: P_ } = Uu, { getNextTreeStateVersion: L_, makeEmptyStoreState: I_ } = Fu, { isSSR: N_ } = Hr, { memoizeOneWithArgsHashAndInvalidation: F_ } = __;
  class Kr {
    constructor(t, n) {
      he(this, "_store", void 0), he(this, "_refCount", 1), he(this, "getLoadable", (o) => (this.checkRefCount_INTERNAL(), A_(this._store, o))), he(this, "getPromise", (o) => (this.checkRefCount_INTERNAL(), this.getLoadable(o).toPromise())), he(this, "getNodes_UNSTABLE", (o) => {
        if (this.checkRefCount_INTERNAL(), (o == null ? void 0 : o.isModified) === true) {
          if ((o == null ? void 0 : o.isInitialized) === false)
            return [];
          const i = this._store.getState().currentTree;
          return kl(i.dirtyAtoms);
        }
        const r = this._store.getState().knownAtoms, a = this._store.getState().knownSelectors;
        return (o == null ? void 0 : o.isInitialized) == null ? Tl.values() : o.isInitialized === true ? kl(nd([
          r,
          a
        ])) : Pi(Tl.values(), ({ key: i }) => !r.has(i) && !a.has(i));
      }), he(this, "getInfo_UNSTABLE", ({ key: o }) => (this.checkRefCount_INTERNAL(), w_(this._store, this._store.getState().currentTree, o))), he(this, "map", (o) => {
        this.checkRefCount_INTERNAL();
        const r = new qa(this, Ka);
        return o(r), r;
      }), he(this, "asyncMap", async (o) => {
        this.checkRefCount_INTERNAL();
        const r = new qa(this, Ka);
        return r.retain(), await o(r), r.autoRelease_INTERNAL(), r;
      }), this._store = {
        storeID: E_(),
        parentStoreID: n,
        getState: () => t,
        replaceState: (o) => {
          t.currentTree = o(t.currentTree);
        },
        getGraph: (o) => {
          const r = t.graphsByVersion;
          if (r.has(o))
            return Ie(r.get(o));
          const a = $_();
          return r.set(o, a), a;
        },
        subscribeToTransactions: () => ({
          release: () => {
          }
        }),
        addTransactionMetadata: () => {
          throw ve("Cannot subscribe to Snapshots");
        }
      };
      for (const o of this._store.getState().knownAtoms)
        C_(this._store, o, "get"), Ko(this._store, o, 1);
      this.autoRelease_INTERNAL();
    }
    retain() {
      this._refCount <= 0, this._refCount++;
      let t = false;
      return () => {
        t || (t = true, this._release());
      };
    }
    autoRelease_INTERNAL() {
      N_ || window.setTimeout(() => this._release(), 10);
    }
    _release() {
      if (this._refCount--, this._refCount === 0) {
        if (this._store.getState().nodeCleanupFunctions.forEach((t) => t()), this._store.getState().nodeCleanupFunctions.clear(), !Ee("recoil_memory_managament_2020"))
          return;
      } else
        this._refCount < 0;
    }
    isRetained() {
      return this._refCount > 0;
    }
    checkRefCount_INTERNAL() {
      Ee("recoil_memory_managament_2020") && this._refCount <= 0;
    }
    getStore_INTERNAL() {
      return this.checkRefCount_INTERNAL(), this._store;
    }
    getID() {
      return this.checkRefCount_INTERNAL(), this._store.getState().currentTree.stateID;
    }
    getStoreID() {
      return this.checkRefCount_INTERNAL(), this._store.storeID;
    }
  }
  function rd(e, t, n = false) {
    const o = e.getState(), r = n ? L_() : t.version;
    return {
      currentTree: {
        version: n ? r : t.version,
        stateID: n ? r : t.stateID,
        transactionMetadata: {
          ...t.transactionMetadata
        },
        dirtyAtoms: new Set(t.dirtyAtoms),
        atomValues: t.atomValues.clone(),
        nonvalidatedAtoms: t.nonvalidatedAtoms.clone()
      },
      commitDepth: 0,
      nextTree: null,
      previousTree: null,
      knownAtoms: new Set(o.knownAtoms),
      knownSelectors: new Set(o.knownSelectors),
      transactionSubscriptions: /* @__PURE__ */ new Map(),
      nodeTransactionSubscriptions: /* @__PURE__ */ new Map(),
      nodeToComponentSubscriptions: /* @__PURE__ */ new Map(),
      queuedComponentCallbacks_DEPRECATED: [],
      suspendedComponentResolvers: /* @__PURE__ */ new Set(),
      graphsByVersion: (/* @__PURE__ */ new Map()).set(r, e.getGraph(t.version)),
      retention: {
        referenceCounts: /* @__PURE__ */ new Map(),
        nodesRetainedByZone: /* @__PURE__ */ new Map(),
        retainablesToCheckForRelease: /* @__PURE__ */ new Set()
      },
      nodeCleanupFunctions: new Map(jr(o.nodeCleanupFunctions.entries(), ([a]) => [
        a,
        () => {
        }
      ]))
    };
  }
  function O_(e) {
    const t = new Kr(I_());
    return e != null ? t.map(e) : t;
  }
  const [Ml, ad] = F_((e, t) => {
    var n;
    const o = e.getState(), r = t === "latest" ? (n = o.nextTree) !== null && n !== void 0 ? n : o.currentTree : Ie(o.previousTree);
    return new Kr(rd(e, r), e.storeID);
  }, (e, t) => {
    var n, o;
    return String(t) + String(e.storeID) + String((n = e.getState().nextTree) === null || n === void 0 ? void 0 : n.version) + String(e.getState().currentTree.version) + String((o = e.getState().previousTree) === null || o === void 0 ? void 0 : o.version);
  });
  P_(ad);
  function B_(e, t = "latest") {
    const n = Ml(e, t);
    return n.isRetained() ? n : (ad(), Ml(e, t));
  }
  class qa extends Kr {
    constructor(t, n) {
      super(rd(t.getStore_INTERNAL(), t.getStore_INTERNAL().getState().currentTree, true), t.getStoreID()), he(this, "_batch", void 0), he(this, "set", (o, r) => {
        this.checkRefCount_INTERNAL();
        const a = this.getStore_INTERNAL();
        this._batch(() => {
          Ko(a, o.key, 1), Al(this.getStore_INTERNAL(), o, r);
        });
      }), he(this, "reset", (o) => {
        this.checkRefCount_INTERNAL();
        const r = this.getStore_INTERNAL();
        this._batch(() => {
          Ko(r, o.key, 1), Al(this.getStore_INTERNAL(), o, T_);
        });
      }), he(this, "setUnvalidatedAtomValues_DEPRECATED", (o) => {
        this.checkRefCount_INTERNAL();
        const r = this.getStore_INTERNAL();
        Ka(() => {
          for (const [a, i] of o.entries())
            Ko(r, a, 1), M_(r, new k_(a), i);
        });
      }), this._batch = n;
    }
  }
  var qr = {
    Snapshot: Kr,
    MutableSnapshot: qa,
    freshSnapshot: O_,
    cloneSnapshot: B_
  }, D_ = qr.Snapshot, j_ = qr.MutableSnapshot, z_ = qr.freshSnapshot, V_ = qr.cloneSnapshot, Gr = Object.freeze({
    __proto__: null,
    Snapshot: D_,
    MutableSnapshot: j_,
    freshSnapshot: z_,
    cloneSnapshot: V_
  });
  function U_(...e) {
    const t = /* @__PURE__ */ new Set();
    for (const n of e)
      for (const o of n)
        t.add(o);
    return t;
  }
  var W_ = U_;
  const { useRef: H_ } = Ne;
  function K_(e) {
    const t = H_(e);
    return t.current === e && typeof e == "function" && (t.current = e()), t;
  }
  var Pl = K_;
  const { getNextTreeStateVersion: q_, makeEmptyStoreState: id } = Fu, { cleanUpNode: G_, getDownstreamNodes: Y_, initializeNode: X_, setNodeValue: Z_, setUnvalidatedAtomValue_DEPRECATED: J_ } = Yt, { graph: Q_ } = bo, { cloneGraph: e2 } = bo, { getNextStoreID: sd } = zr, { createMutableSource: Ea, reactMode: ld } = vo, { applyAtomValueWrites: t2 } = wt, { releaseScheduledRetainablesNow: cd } = dn, { freshSnapshot: n2 } = Gr, { useCallback: o2, useContext: ud, useEffect: Ga, useMemo: r2, useRef: a2, useState: i2 } = Ne;
  function Hn() {
    throw ve("This component must be used inside a <RecoilRoot> component.");
  }
  const dd = Object.freeze({
    storeID: sd(),
    getState: Hn,
    replaceState: Hn,
    getGraph: Hn,
    subscribeToTransactions: Hn,
    addTransactionMetadata: Hn
  });
  let Ya = false;
  function Ll(e) {
    if (Ya)
      throw ve("An atom update was triggered within the execution of a state updater function. State updater functions provided to Recoil must be pure functions.");
    const t = e.getState();
    if (t.nextTree === null) {
      Ee("recoil_memory_managament_2020") && Ee("recoil_release_on_cascading_update_killswitch_2021") && t.commitDepth > 0 && cd(e);
      const n = t.currentTree.version, o = q_();
      t.nextTree = {
        ...t.currentTree,
        version: o,
        stateID: o,
        dirtyAtoms: /* @__PURE__ */ new Set(),
        transactionMetadata: {}
      }, t.graphsByVersion.set(o, e2(Ie(t.graphsByVersion.get(n))));
    }
  }
  const pd = Ne.createContext({
    current: dd
  }), Yr = () => ud(pd), fd = Ne.createContext(null);
  function s2() {
    return ud(fd);
  }
  function Fi(e, t, n) {
    const o = Y_(e, n, n.dirtyAtoms);
    for (const r of o) {
      const a = t.nodeToComponentSubscriptions.get(r);
      if (a)
        for (const [i, [s, l]] of a)
          l(n);
    }
  }
  function hd(e) {
    const t = e.getState(), n = t.currentTree, o = n.dirtyAtoms;
    if (o.size) {
      for (const [r, a] of t.nodeTransactionSubscriptions)
        if (o.has(r))
          for (const [i, s] of a)
            s(e);
      for (const [r, a] of t.transactionSubscriptions)
        a(e);
      (!ld().early || t.suspendedComponentResolvers.size > 0) && (Fi(e, t, n), t.suspendedComponentResolvers.forEach((r) => r()), t.suspendedComponentResolvers.clear());
    }
    t.queuedComponentCallbacks_DEPRECATED.forEach((r) => r(n)), t.queuedComponentCallbacks_DEPRECATED.splice(0, t.queuedComponentCallbacks_DEPRECATED.length);
  }
  function l2(e) {
    const t = e.getState();
    t.commitDepth++;
    try {
      const { nextTree: n } = t;
      if (n == null)
        return;
      t.previousTree = t.currentTree, t.currentTree = n, t.nextTree = null, hd(e), t.previousTree != null ? t.graphsByVersion.delete(t.previousTree.version) : Ei("Ended batch with no previous state, which is unexpected", "recoil"), t.previousTree = null, Ee("recoil_memory_managament_2020") && n == null && cd(e);
    } finally {
      t.commitDepth--;
    }
  }
  function c2({ setNotifyBatcherOfChange: e }) {
    const t = Yr(), [, n] = i2([]);
    return e(() => n({})), Ga(() => (e(() => n({})), () => {
      e(() => {
      });
    }), [
      e
    ]), Ga(() => {
      zS.enqueueExecution("Batcher", () => {
        l2(t.current);
      });
    }), null;
  }
  function u2(e, t) {
    const n = id();
    return t({
      set: (o, r) => {
        const a = n.currentTree, i = Z_(e, a, o.key, r), s = new Set(i.keys()), l = a.nonvalidatedAtoms.clone();
        for (const c of s)
          l.delete(c);
        n.currentTree = {
          ...a,
          dirtyAtoms: W_(a.dirtyAtoms, s),
          atomValues: t2(a.atomValues, i),
          nonvalidatedAtoms: l
        };
      },
      setUnvalidatedAtomValues: (o) => {
        o.forEach((r, a) => {
          n.currentTree = J_(n.currentTree, a, r);
        });
      }
    }), n;
  }
  function d2(e) {
    const t = n2(e), n = t.getStore_INTERNAL().getState();
    return t.retain(), n.nodeCleanupFunctions.forEach((o) => o()), n.nodeCleanupFunctions.clear(), n;
  }
  let Il = 0;
  function p2({ initializeState_DEPRECATED: e, initializeState: t, store_INTERNAL: n, children: o }) {
    let r;
    const a = (v) => {
      const g = r.current.graphsByVersion;
      if (g.has(v))
        return Ie(g.get(v));
      const h = Q_();
      return g.set(v, h), h;
    }, i = (v, g) => {
      if (g == null) {
        const { transactionSubscriptions: h } = p.current.getState(), C = Il++;
        return h.set(C, v), {
          release: () => {
            h.delete(C);
          }
        };
      } else {
        const { nodeTransactionSubscriptions: h } = p.current.getState();
        h.has(g) || h.set(g, /* @__PURE__ */ new Map());
        const C = Il++;
        return Ie(h.get(g)).set(C, v), {
          release: () => {
            const $ = h.get(g);
            $ && ($.delete(C), $.size === 0 && h.delete(g));
          }
        };
      }
    }, s = (v) => {
      Ll(p.current);
      for (const g of Object.keys(v))
        Ie(p.current.getState().nextTree).transactionMetadata[g] = v[g];
    }, l = (v) => {
      Ll(p.current);
      const g = Ie(r.current.nextTree);
      let h;
      try {
        Ya = true, h = v(g);
      } finally {
        Ya = false;
      }
      h !== g && (r.current.nextTree = h, ld().early && Fi(p.current, r.current, h), Ie(c.current)());
    }, c = a2(null), d = o2((v) => {
      c.current = v;
    }, [
      c
    ]), p = Pl(() => n ?? {
      storeID: sd(),
      getState: () => r.current,
      replaceState: l,
      getGraph: a,
      subscribeToTransactions: i,
      addTransactionMetadata: s
    });
    n != null && (p.current = n), r = Pl(() => e != null ? u2(p.current, e) : t != null ? d2(t) : id());
    const m = r2(() => Ea == null ? void 0 : Ea(r, () => r.current.currentTree.version), [
      r
    ]);
    return Ga(() => {
      const v = p.current;
      for (const g of new Set(v.getState().knownAtoms))
        X_(v, g, "get");
      return () => {
        for (const g of v.getState().knownAtoms)
          G_(v, g);
      };
    }, [
      p
    ]), Ne.createElement(pd.Provider, {
      value: p
    }, Ne.createElement(fd.Provider, {
      value: m
    }, Ne.createElement(c2, {
      setNotifyBatcherOfChange: d
    }), o));
  }
  function f2(e) {
    const { override: t, ...n } = e, o = Yr();
    return t === false && o.current !== dd ? e.children : Ne.createElement(p2, n);
  }
  function h2() {
    return Yr().current.storeID;
  }
  var Ft = {
    RecoilRoot: f2,
    useStoreRef: Yr,
    useRecoilMutableSource: s2,
    useRecoilStoreID: h2,
    notifyComponents_FOR_TESTING: Fi,
    sendEndOfBatchNotifications_FOR_TESTING: hd
  };
  function m2(e, t) {
    if (e === t)
      return true;
    if (e.length !== t.length)
      return false;
    for (let n = 0, o = e.length; n < o; n++)
      if (e[n] !== t[n])
        return false;
    return true;
  }
  var g2 = m2;
  const { useEffect: v2, useRef: b2 } = Ne;
  function y2(e) {
    const t = b2();
    return v2(() => {
      t.current = e;
    }), t.current;
  }
  var md = y2;
  const { useStoreRef: x2 } = Ft, { SUSPENSE_TIMEOUT_MS: S2 } = dn, { updateRetainCount: Kn } = dn, { RetentionZone: R2 } = Vr, { useEffect: _2, useRef: C2 } = Ne, { isSSR: Nl } = Hr;
  function w2(e) {
    if (Ee("recoil_memory_managament_2020"))
      return $2(e);
  }
  function $2(e) {
    const n = (Array.isArray(e) ? e : [
      e
    ]).map((i) => i instanceof R2 ? i : i.key), o = x2();
    _2(() => {
      if (!Ee("recoil_memory_managament_2020"))
        return;
      const i = o.current;
      if (r.current && !Nl)
        window.clearTimeout(r.current), r.current = null;
      else
        for (const s of n)
          Kn(i, s, 1);
      return () => {
        for (const s of n)
          Kn(i, s, -1);
      };
    }, [
      o,
      ...n
    ]);
    const r = C2(), a = md(n);
    if (!Nl && (a === void 0 || !g2(a, n))) {
      const i = o.current;
      for (const s of n)
        Kn(i, s, 1);
      if (a)
        for (const s of a)
          Kn(i, s, -1);
      r.current && window.clearTimeout(r.current), r.current = window.setTimeout(() => {
        r.current = null;
        for (const s of n)
          Kn(i, s, -1);
      }, S2);
    }
  }
  var Oi = w2;
  function E2() {
    return "<component name not available>";
  }
  var xo = E2;
  const { batchUpdates: T2 } = Wr, { DEFAULT_VALUE: gd } = Je, { currentRendererSupportsUseSyncExternalStore: k2, reactMode: On, useMutableSource: A2, useSyncExternalStore: M2 } = vo, { useRecoilMutableSource: P2, useStoreRef: $t } = Ft, { AbstractRecoilValue: Xa, getRecoilValueAsLoadable: So, setRecoilValue: ar, setUnvalidatedRecoilValue: L2, subscribeToRecoilValue: An } = wt, { useCallback: Ze, useEffect: Mn, useMemo: vd, useRef: ro, useState: Bi } = Ne, { setByAddingToSet: I2 } = Bu, { isSSR: N2 } = Hr;
  function Di(e, t, n) {
    if (e.state === "hasValue")
      return e.contents;
    throw e.state === "loading" ? new Promise((r) => {
      const a = n.current.getState().suspendedComponentResolvers;
      a.add(r), N2 && Me(e.contents) && e.contents.finally(() => {
        a.delete(r);
      });
    }) : e.state === "hasError" ? e.contents : ve(`Invalid value of loadable atom "${t.key}"`);
  }
  function F2() {
    const e = xo(), t = $t(), [, n] = Bi([]), o = ro(/* @__PURE__ */ new Set());
    o.current = /* @__PURE__ */ new Set();
    const r = ro(/* @__PURE__ */ new Set()), a = ro(/* @__PURE__ */ new Map()), i = Ze((l) => {
      const c = a.current.get(l);
      c && (c.release(), a.current.delete(l));
    }, [
      a
    ]), s = Ze((l, c) => {
      a.current.has(c) && n([]);
    }, []);
    return Mn(() => {
      const l = t.current;
      no(o.current, r.current).forEach((c) => {
        if (a.current.has(c))
          return;
        const d = An(l, new Xa(c), (m) => s(m, c), e);
        a.current.set(c, d), l.getState().nextTree ? l.getState().queuedComponentCallbacks_DEPRECATED.push(() => {
          s(l.getState(), c);
        }) : s(l.getState(), c);
      }), no(r.current, o.current).forEach((c) => {
        i(c);
      }), r.current = o.current;
    }), Mn(() => {
      const l = a.current;
      return no(o.current, new Set(l.keys())).forEach((c) => {
        const d = An(t.current, new Xa(c), (p) => s(p, c), e);
        l.set(c, d);
      }), () => l.forEach((c, d) => i(d));
    }, [
      e,
      t,
      i,
      s
    ]), vd(() => {
      function l(g) {
        return (h) => {
          ar(t.current, g, h);
        };
      }
      function c(g) {
        return () => ar(t.current, g, gd);
      }
      function d(g) {
        var h;
        o.current.has(g.key) || (o.current = I2(o.current, g.key));
        const C = t.current.getState();
        return So(t.current, g, On().early && (h = C.nextTree) !== null && h !== void 0 ? h : C.currentTree);
      }
      function p(g) {
        const h = d(g);
        return Di(h, g, t);
      }
      function m(g) {
        return [
          p(g),
          l(g)
        ];
      }
      function v(g) {
        return [
          d(g),
          l(g)
        ];
      }
      return {
        getRecoilValue: p,
        getRecoilValueLoadable: d,
        getRecoilState: m,
        getRecoilStateLoadable: v,
        getSetRecoilState: l,
        getResetRecoilState: c
      };
    }, [
      o,
      t
    ]);
  }
  const O2 = {
    current: 0
  };
  function B2(e) {
    const t = $t(), n = xo(), o = Ze(() => {
      var s;
      const l = t.current, c = l.getState(), d = On().early && (s = c.nextTree) !== null && s !== void 0 ? s : c.currentTree;
      return {
        loadable: So(l, e, d),
        key: e.key
      };
    }, [
      t,
      e
    ]), r = Ze((s) => {
      let l;
      return () => {
        var c, d;
        const p = s();
        return (c = l) !== null && c !== void 0 && c.loadable.is(p.loadable) && ((d = l) === null || d === void 0 ? void 0 : d.key) === p.key ? l : (l = p, p);
      };
    }, []), a = vd(() => r(o), [
      o,
      r
    ]), i = Ze((s) => {
      const l = t.current;
      return An(l, e, s, n).release;
    }, [
      t,
      e,
      n
    ]);
    return M2(i, a, a).loadable;
  }
  function D2(e) {
    const t = $t(), n = Ze(() => {
      var c;
      const d = t.current, p = d.getState(), m = On().early && (c = p.nextTree) !== null && c !== void 0 ? c : p.currentTree;
      return So(d, e, m);
    }, [
      t,
      e
    ]), o = Ze(() => n(), [
      n
    ]), r = xo(), a = Ze((c, d) => {
      const p = t.current;
      return An(p, e, () => {
        if (!Ee("recoil_suppress_rerender_in_callback"))
          return d();
        const v = n();
        l.current.is(v) || d(), l.current = v;
      }, r).release;
    }, [
      t,
      e,
      r,
      n
    ]), i = P2();
    if (i == null)
      throw ve("Recoil hooks must be used in components contained within a <RecoilRoot> component.");
    const s = A2(i, o, a), l = ro(s);
    return Mn(() => {
      l.current = s;
    }), s;
  }
  function Za(e) {
    const t = $t(), n = xo(), o = Ze(() => {
      var l;
      const c = t.current, d = c.getState(), p = On().early && (l = d.nextTree) !== null && l !== void 0 ? l : d.currentTree;
      return So(c, e, p);
    }, [
      t,
      e
    ]), r = Ze(() => ({
      loadable: o(),
      key: e.key
    }), [
      o,
      e.key
    ]), a = Ze((l) => {
      const c = r();
      return l.loadable.is(c.loadable) && l.key === c.key ? l : c;
    }, [
      r
    ]);
    Mn(() => {
      const l = An(t.current, e, (c) => {
        s(a);
      }, n);
      return s(a), l.release;
    }, [
      n,
      e,
      t,
      a
    ]);
    const [i, s] = Bi(r);
    return i.key !== e.key ? r().loadable : i.loadable;
  }
  function j2(e) {
    const t = $t(), [, n] = Bi([]), o = xo(), r = Ze(() => {
      var s;
      const l = t.current, c = l.getState(), d = On().early && (s = c.nextTree) !== null && s !== void 0 ? s : c.currentTree;
      return So(l, e, d);
    }, [
      t,
      e
    ]), a = r(), i = ro(a);
    return Mn(() => {
      i.current = a;
    }), Mn(() => {
      const s = t.current, l = s.getState(), c = An(s, e, (p) => {
        var m;
        if (!Ee("recoil_suppress_rerender_in_callback"))
          return n([]);
        const v = r();
        (m = i.current) !== null && m !== void 0 && m.is(v) || n(v), i.current = v;
      }, o);
      if (l.nextTree)
        s.getState().queuedComponentCallbacks_DEPRECATED.push(() => {
          i.current = null, n([]);
        });
      else {
        var d;
        if (!Ee("recoil_suppress_rerender_in_callback"))
          return n([]);
        const p = r();
        (d = i.current) !== null && d !== void 0 && d.is(p) || n(p), i.current = p;
      }
      return c.release;
    }, [
      o,
      r,
      e,
      t
    ]), a;
  }
  function ji(e) {
    return Ee("recoil_memory_managament_2020") && Oi(e), {
      TRANSITION_SUPPORT: Za,
      SYNC_EXTERNAL_STORE: k2() ? B2 : Za,
      MUTABLE_SOURCE: D2,
      LEGACY: j2
    }[On().mode](e);
  }
  function bd(e) {
    const t = $t(), n = ji(e);
    return Di(n, e, t);
  }
  function Xr(e) {
    const t = $t();
    return Ze((n) => {
      ar(t.current, e, n);
    }, [
      t,
      e
    ]);
  }
  function z2(e) {
    const t = $t();
    return Ze(() => {
      ar(t.current, e, gd);
    }, [
      t,
      e
    ]);
  }
  function V2(e) {
    return [
      bd(e),
      Xr(e)
    ];
  }
  function U2(e) {
    return [
      ji(e),
      Xr(e)
    ];
  }
  function W2() {
    const e = $t();
    return (t, n = {}) => {
      T2(() => {
        e.current.addTransactionMetadata(n), t.forEach((o, r) => L2(e.current, new Xa(r), o));
      });
    };
  }
  function yd(e) {
    return Ee("recoil_memory_managament_2020") && Oi(e), Za(e);
  }
  function xd(e) {
    const t = $t(), n = yd(e);
    return Di(n, e, t);
  }
  function H2(e) {
    return [
      xd(e),
      Xr(e)
    ];
  }
  var K2 = {
    recoilComponentGetRecoilValueCount_FOR_TESTING: O2,
    useRecoilInterface: F2,
    useRecoilState: V2,
    useRecoilStateLoadable: U2,
    useRecoilValue: bd,
    useRecoilValueLoadable: ji,
    useResetRecoilState: z2,
    useSetRecoilState: Xr,
    useSetUnvalidatedAtomValues: W2,
    useRecoilValueLoadable_TRANSITION_SUPPORT_UNSTABLE: yd,
    useRecoilValue_TRANSITION_SUPPORT_UNSTABLE: xd,
    useRecoilState_TRANSITION_SUPPORT_UNSTABLE: H2
  };
  function q2(e, t) {
    const n = /* @__PURE__ */ new Map();
    for (const [o, r] of e)
      t(r, o) && n.set(o, r);
    return n;
  }
  var G2 = q2;
  function Y2(e, t) {
    const n = /* @__PURE__ */ new Set();
    for (const o of e)
      t(o) && n.add(o);
    return n;
  }
  var X2 = Y2;
  function Z2(...e) {
    const t = /* @__PURE__ */ new Map();
    for (let n = 0; n < e.length; n++) {
      const o = e[n].keys();
      let r;
      for (; !(r = o.next()).done; )
        t.set(r.value, e[n].get(r.value));
    }
    return t;
  }
  var J2 = Z2;
  const { batchUpdates: Q2 } = Wr, { DEFAULT_VALUE: eC, getNode: Sd, nodes: tC } = Je, { useStoreRef: zi } = Ft, { AbstractRecoilValue: nC, setRecoilValueLoadable: oC } = wt, { SUSPENSE_TIMEOUT_MS: rC } = dn, { cloneSnapshot: ir } = Gr, { useCallback: Zr, useEffect: Rd, useRef: Fl, useState: aC } = Ne, { isSSR: Ol } = Hr;
  function Jr(e) {
    const t = zi();
    Rd(() => t.current.subscribeToTransactions(e).release, [
      e,
      t
    ]);
  }
  function Bl(e) {
    const t = e.atomValues.toMap(), n = rr(G2(t, (o, r) => {
      const i = Sd(r).persistence_UNSTABLE;
      return i != null && i.type !== "none" && o.state === "hasValue";
    }), (o) => o.contents);
    return J2(e.nonvalidatedAtoms.toMap(), n);
  }
  function iC(e) {
    Jr(Zr((t) => {
      let n = t.getState().previousTree;
      const o = t.getState().currentTree;
      n || (n = t.getState().currentTree);
      const r = Bl(o), a = Bl(n), i = rr(tC, (l) => {
        var c, d, p, m;
        return {
          persistence_UNSTABLE: {
            type: (c = (d = l.persistence_UNSTABLE) === null || d === void 0 ? void 0 : d.type) !== null && c !== void 0 ? c : "none",
            backButton: (p = (m = l.persistence_UNSTABLE) === null || m === void 0 ? void 0 : m.backButton) !== null && p !== void 0 ? p : false
          }
        };
      }), s = X2(o.dirtyAtoms, (l) => r.has(l) || a.has(l));
      e({
        atomValues: r,
        previousAtomValues: a,
        atomInfo: i,
        modifiedAtoms: s,
        transactionMetadata: {
          ...o.transactionMetadata
        }
      });
    }, [
      e
    ]));
  }
  function sC(e) {
    Jr(Zr((t) => {
      const n = ir(t, "latest"), o = ir(t, "previous");
      e({
        snapshot: n,
        previousSnapshot: o
      });
    }, [
      e
    ]));
  }
  function lC() {
    const e = zi(), [t, n] = aC(() => ir(e.current)), o = md(t), r = Fl(), a = Fl();
    if (Jr(Zr((s) => n(ir(s)), [])), Rd(() => {
      const s = t.retain();
      if (r.current && !Ol) {
        var l;
        window.clearTimeout(r.current), r.current = null, (l = a.current) === null || l === void 0 || l.call(a), a.current = null;
      }
      return () => {
        window.setTimeout(s, 10);
      };
    }, [
      t
    ]), o !== t && !Ol) {
      if (r.current) {
        var i;
        window.clearTimeout(r.current), r.current = null, (i = a.current) === null || i === void 0 || i.call(a), a.current = null;
      }
      a.current = t.retain(), r.current = window.setTimeout(() => {
        var s;
        r.current = null, (s = a.current) === null || s === void 0 || s.call(a), a.current = null;
      }, rC);
    }
    return t;
  }
  function _d(e, t) {
    var n;
    const o = e.getState(), r = (n = o.nextTree) !== null && n !== void 0 ? n : o.currentTree, a = t.getStore_INTERNAL().getState().currentTree;
    Q2(() => {
      const i = /* @__PURE__ */ new Set();
      for (const c of [
        r.atomValues.keys(),
        a.atomValues.keys()
      ])
        for (const d of c) {
          var s, l;
          ((s = r.atomValues.get(d)) === null || s === void 0 ? void 0 : s.contents) !== ((l = a.atomValues.get(d)) === null || l === void 0 ? void 0 : l.contents) && Sd(d).shouldRestoreFromSnapshots && i.add(d);
        }
      i.forEach((c) => {
        oC(e, new nC(c), a.atomValues.has(c) ? Ie(a.atomValues.get(c)) : eC);
      }), e.replaceState((c) => ({
        ...c,
        stateID: t.getID()
      }));
    });
  }
  function cC() {
    const e = zi();
    return Zr((t) => _d(e.current, t), [
      e
    ]);
  }
  var Cd = {
    useRecoilSnapshot: lC,
    gotoSnapshot: _d,
    useGotoRecoilSnapshot: cC,
    useRecoilTransactionObserver: sC,
    useTransactionObservation_DEPRECATED: iC,
    useTransactionSubscription_DEPRECATED: Jr
  };
  const { peekNodeInfo: uC } = Yt, { useStoreRef: dC } = Ft;
  function pC() {
    const e = dC();
    return ({ key: t }) => uC(e.current, e.current.getState().currentTree, t);
  }
  var fC = pC;
  const { reactMode: hC } = vo, { RecoilRoot: mC, useStoreRef: gC } = Ft, { useMemo: vC } = Ne;
  function bC() {
    hC().mode === "MUTABLE_SOURCE" && console.warn("Warning: There are known issues using useRecoilBridgeAcrossReactRoots() in recoil_mutable_source rendering mode.  Please consider upgrading to recoil_sync_external_store mode.");
    const e = gC().current;
    return vC(() => {
      function t({ children: n }) {
        return Ne.createElement(mC, {
          store_INTERNAL: e
        }, n);
      }
      return t;
    }, [
      e
    ]);
  }
  var yC = bC;
  const { loadableWithValue: xC } = go, { initializeNode: SC } = Yt, { DEFAULT_VALUE: RC, getNode: _C } = Je, { copyTreeState: CC, getRecoilValueAsLoadable: wC, invalidateDownstreams: $C, writeLoadableToTreeState: EC } = wt;
  function Dl(e) {
    return _C(e.key).nodeType === "atom";
  }
  class TC {
    constructor(t, n) {
      he(this, "_store", void 0), he(this, "_treeState", void 0), he(this, "_changes", void 0), he(this, "get", (o) => {
        if (this._changes.has(o.key))
          return this._changes.get(o.key);
        if (!Dl(o))
          throw ve("Reading selectors within atomicUpdate is not supported");
        const r = wC(this._store, o, this._treeState);
        if (r.state === "hasValue")
          return r.contents;
        throw r.state === "hasError" ? r.contents : ve(`Expected Recoil atom ${o.key} to have a value, but it is in a loading state.`);
      }), he(this, "set", (o, r) => {
        if (!Dl(o))
          throw ve("Setting selectors within atomicUpdate is not supported");
        if (typeof r == "function") {
          const a = this.get(o);
          this._changes.set(o.key, r(a));
        } else
          SC(this._store, o.key, "set"), this._changes.set(o.key, r);
      }), he(this, "reset", (o) => {
        this.set(o, RC);
      }), this._store = t, this._treeState = n, this._changes = /* @__PURE__ */ new Map();
    }
    newTreeState_INTERNAL() {
      if (this._changes.size === 0)
        return this._treeState;
      const t = CC(this._treeState);
      for (const [n, o] of this._changes)
        EC(t, n, xC(o));
      return $C(this._store, t), t;
    }
  }
  function kC(e) {
    return (t) => {
      e.replaceState((n) => {
        const o = new TC(e, n);
        return t(o), o.newTreeState_INTERNAL();
      });
    };
  }
  var AC = {
    atomicUpdater: kC
  }, MC = AC.atomicUpdater, wd = Object.freeze({
    __proto__: null,
    atomicUpdater: MC
  });
  function PC(e, t) {
    if (!e)
      throw new Error(t);
  }
  var LC = PC, Jn = LC;
  const { atomicUpdater: IC } = wd, { batchUpdates: NC } = Wr, { DEFAULT_VALUE: FC } = Je, { useStoreRef: OC } = Ft, { refreshRecoilValue: BC, setRecoilValue: jl } = wt, { cloneSnapshot: DC } = Gr, { gotoSnapshot: jC } = Cd, { useCallback: zC } = Ne;
  class $d {
  }
  const VC = new $d();
  function Ed(e, t, n, o) {
    let r = VC, a;
    if (NC(() => {
      const s = "useRecoilCallback() expects a function that returns a function: it accepts a function of the type (RecoilInterface) => (Args) => ReturnType and returns a callback function (Args) => ReturnType, where RecoilInterface is an object {snapshot, set, ...} and Args and ReturnType are the argument and return types of the callback you want to create.  Please see the docs at recoiljs.org for details.";
      if (typeof t != "function")
        throw ve(s);
      const l = Du({
        ...o ?? {},
        set: (d, p) => jl(e, d, p),
        reset: (d) => jl(e, d, FC),
        refresh: (d) => BC(e, d),
        gotoSnapshot: (d) => jC(e, d),
        transact_UNSTABLE: (d) => IC(e)(d)
      }, {
        snapshot: () => {
          const d = DC(e);
          return a = d.retain(), d;
        }
      }), c = t(l);
      if (typeof c != "function")
        throw ve(s);
      r = c(...n);
    }), r instanceof $d && Jn(false), Me(r))
      r = r.finally(() => {
        var s;
        (s = a) === null || s === void 0 || s();
      });
    else {
      var i;
      (i = a) === null || i === void 0 || i();
    }
    return r;
  }
  function UC(e, t) {
    const n = OC();
    return zC((...o) => Ed(n.current, e, o), t != null ? [
      ...t,
      n
    ] : void 0);
  }
  var Td = {
    recoilCallback: Ed,
    useRecoilCallback: UC
  };
  const { useStoreRef: WC } = Ft, { refreshRecoilValue: HC } = wt, { useCallback: KC } = Ne;
  function qC(e) {
    const t = WC();
    return KC(() => {
      const n = t.current;
      HC(n, e);
    }, [
      e,
      t
    ]);
  }
  var GC = qC;
  const { atomicUpdater: YC } = wd, { useStoreRef: XC } = Ft, { useMemo: ZC } = Ne;
  function JC(e, t) {
    const n = XC();
    return ZC(() => (...o) => {
      YC(n.current)((a) => {
        e(a)(...o);
      });
    }, t != null ? [
      ...t,
      n
    ] : void 0);
  }
  var QC = JC;
  class ew {
    constructor(t) {
      he(this, "value", void 0), this.value = t;
    }
  }
  var tw = {
    WrappedValue: ew
  }, nw = tw.WrappedValue, kd = Object.freeze({
    __proto__: null,
    WrappedValue: nw
  });
  const { isFastRefreshEnabled: ow } = vo;
  class zl extends Error {
  }
  class rw {
    constructor(t) {
      var n, o, r;
      he(this, "_name", void 0), he(this, "_numLeafs", void 0), he(this, "_root", void 0), he(this, "_onHit", void 0), he(this, "_onSet", void 0), he(this, "_mapNodeValue", void 0), this._name = t == null ? void 0 : t.name, this._numLeafs = 0, this._root = null, this._onHit = (n = t == null ? void 0 : t.onHit) !== null && n !== void 0 ? n : () => {
      }, this._onSet = (o = t == null ? void 0 : t.onSet) !== null && o !== void 0 ? o : () => {
      }, this._mapNodeValue = (r = t == null ? void 0 : t.mapNodeValue) !== null && r !== void 0 ? r : (a) => a;
    }
    size() {
      return this._numLeafs;
    }
    root() {
      return this._root;
    }
    get(t, n) {
      var o;
      return (o = this.getLeafNode(t, n)) === null || o === void 0 ? void 0 : o.value;
    }
    getLeafNode(t, n) {
      if (this._root == null)
        return;
      let o = this._root;
      for (; o; ) {
        if (n == null ? void 0 : n.onNodeVisit(o), o.type === "leaf")
          return this._onHit(o), o;
        const r = this._mapNodeValue(t(o.nodeKey));
        o = o.branches.get(r);
      }
    }
    set(t, n, o) {
      const r = () => {
        var a, i, s, l;
        let c, d;
        for (const [C, $] of t) {
          var p, m, v;
          const R = this._root;
          if ((R == null ? void 0 : R.type) === "leaf")
            throw this.invalidCacheError();
          const b = c;
          if (c = b ? b.branches.get(d) : R, c = (p = c) !== null && p !== void 0 ? p : {
            type: "branch",
            nodeKey: C,
            parent: b,
            branches: /* @__PURE__ */ new Map(),
            branchKey: d
          }, c.type !== "branch" || c.nodeKey !== C)
            throw this.invalidCacheError();
          b == null ? void 0 : b.branches.set(d, c), o == null || (m = o.onNodeVisit) === null || m === void 0 || m.call(o, c), d = this._mapNodeValue($), this._root = (v = this._root) !== null && v !== void 0 ? v : c;
        }
        const g = c ? (a = c) === null || a === void 0 ? void 0 : a.branches.get(d) : this._root;
        if (g != null && (g.type !== "leaf" || g.branchKey !== d))
          throw this.invalidCacheError();
        const h = {
          type: "leaf",
          value: n,
          parent: c,
          branchKey: d
        };
        (i = c) === null || i === void 0 || i.branches.set(d, h), this._root = (s = this._root) !== null && s !== void 0 ? s : h, this._numLeafs++, this._onSet(h), o == null || (l = o.onNodeVisit) === null || l === void 0 || l.call(o, h);
      };
      try {
        r();
      } catch (a) {
        if (a instanceof zl)
          this.clear(), r();
        else
          throw a;
      }
    }
    delete(t) {
      const n = this.root();
      if (!n)
        return false;
      if (t === n)
        return this._root = null, this._numLeafs = 0, true;
      let o = t.parent, r = t.branchKey;
      for (; o; ) {
        var a;
        if (o.branches.delete(r), o === n)
          return o.branches.size === 0 ? (this._root = null, this._numLeafs = 0) : this._numLeafs--, true;
        if (o.branches.size > 0)
          break;
        r = (a = o) === null || a === void 0 ? void 0 : a.branchKey, o = o.parent;
      }
      for (; o !== n; o = o.parent)
        if (o == null)
          return false;
      return this._numLeafs--, true;
    }
    clear() {
      this._numLeafs = 0, this._root = null;
    }
    invalidCacheError() {
      const t = ow() ? "Possible Fast Refresh module reload detected.  This may also be caused by an selector returning inconsistent values. Resetting cache." : "Invalid cache values.  This happens when selectors do not return consistent values for the same input dependency values.  That may also be caused when using Fast Refresh to change a selector implementation.  Resetting cache.";
      throw Ei(t + (this._name != null ? ` - ${this._name}` : "")), new zl();
    }
  }
  var aw = {
    TreeCache: rw
  }, iw = aw.TreeCache, Ad = Object.freeze({
    __proto__: null,
    TreeCache: iw
  });
  class sw {
    constructor(t) {
      var n;
      he(this, "_maxSize", void 0), he(this, "_size", void 0), he(this, "_head", void 0), he(this, "_tail", void 0), he(this, "_map", void 0), he(this, "_keyMapper", void 0), this._maxSize = t.maxSize, this._size = 0, this._head = null, this._tail = null, this._map = /* @__PURE__ */ new Map(), this._keyMapper = (n = t.mapKey) !== null && n !== void 0 ? n : (o) => o;
    }
    head() {
      return this._head;
    }
    tail() {
      return this._tail;
    }
    size() {
      return this._size;
    }
    maxSize() {
      return this._maxSize;
    }
    has(t) {
      return this._map.has(this._keyMapper(t));
    }
    get(t) {
      const n = this._keyMapper(t), o = this._map.get(n);
      if (o)
        return this.set(t, o.value), o.value;
    }
    set(t, n) {
      const o = this._keyMapper(t);
      this._map.get(o) && this.delete(t);
      const a = this.head(), i = {
        key: t,
        right: a,
        left: null,
        value: n
      };
      a ? a.left = i : this._tail = i, this._map.set(o, i), this._head = i, this._size++, this._maybeDeleteLRU();
    }
    _maybeDeleteLRU() {
      this.size() > this.maxSize() && this.deleteLru();
    }
    deleteLru() {
      const t = this.tail();
      t && this.delete(t.key);
    }
    delete(t) {
      const n = this._keyMapper(t);
      if (!this._size || !this._map.has(n))
        return;
      const o = Ie(this._map.get(n)), r = o.right, a = o.left;
      r && (r.left = o.left), a && (a.right = o.right), o === this.head() && (this._head = r), o === this.tail() && (this._tail = a), this._map.delete(n), this._size--;
    }
    clear() {
      this._size = 0, this._head = null, this._tail = null, this._map = /* @__PURE__ */ new Map();
    }
  }
  var lw = {
    LRUCache: sw
  }, cw = lw.LRUCache, Md = Object.freeze({
    __proto__: null,
    LRUCache: cw
  });
  const { LRUCache: uw } = Md, { TreeCache: dw } = Ad;
  function pw({ name: e, maxSize: t, mapNodeValue: n = (o) => o }) {
    const o = new uw({
      maxSize: t
    }), r = new dw({
      name: e,
      mapNodeValue: n,
      onHit: (a) => {
        o.set(a, true);
      },
      onSet: (a) => {
        const i = o.tail();
        o.set(a, true), i && r.size() > t && r.delete(i.key);
      }
    });
    return r;
  }
  var Vl = pw;
  function bt(e, t, n) {
    if (typeof e == "string" && !e.includes('"') && !e.includes("\\"))
      return `"${e}"`;
    switch (typeof e) {
      case "undefined":
        return "";
      case "boolean":
        return e ? "true" : "false";
      case "number":
      case "symbol":
        return String(e);
      case "string":
        return JSON.stringify(e);
      case "function":
        if ((t == null ? void 0 : t.allowFunctions) !== true)
          throw ve("Attempt to serialize function in a Recoil cache key");
        return `__FUNCTION(${e.name})__`;
    }
    if (e === null)
      return "null";
    if (typeof e != "object") {
      var o;
      return (o = JSON.stringify(e)) !== null && o !== void 0 ? o : "";
    }
    if (Me(e))
      return "__PROMISE__";
    if (Array.isArray(e))
      return `[${e.map((r, a) => bt(r, t, a.toString()))}]`;
    if (typeof e.toJSON == "function")
      return bt(e.toJSON(n), t, n);
    if (e instanceof Map) {
      const r = {};
      for (const [a, i] of e)
        r[typeof a == "string" ? a : bt(a, t)] = i;
      return bt(r, t, n);
    }
    return e instanceof Set ? bt(Array.from(e).sort((r, a) => bt(r, t).localeCompare(bt(a, t))), t, n) : Symbol !== void 0 && e[Symbol.iterator] != null && typeof e[Symbol.iterator] == "function" ? bt(Array.from(e), t, n) : `{${Object.keys(e).filter((r) => e[r] !== void 0).sort().map((r) => `${bt(r, t)}:${bt(e[r], t, r)}`).join(",")}}`;
  }
  function fw(e, t = {
    allowFunctions: false
  }) {
    return bt(e, t);
  }
  var Qr = fw;
  const { TreeCache: hw } = Ad, Fo = {
    equality: "reference",
    eviction: "keep-all",
    maxSize: 1 / 0
  };
  function mw({ equality: e = Fo.equality, eviction: t = Fo.eviction, maxSize: n = Fo.maxSize } = Fo, o) {
    const r = gw(e);
    return vw(t, n, r, o);
  }
  function gw(e) {
    switch (e) {
      case "reference":
        return (t) => t;
      case "value":
        return (t) => Qr(t);
    }
    throw ve(`Unrecognized equality policy ${e}`);
  }
  function vw(e, t, n, o) {
    switch (e) {
      case "keep-all":
        return new hw({
          name: o,
          mapNodeValue: n
        });
      case "lru":
        return Vl({
          name: o,
          maxSize: Ie(t),
          mapNodeValue: n
        });
      case "most-recent":
        return Vl({
          name: o,
          maxSize: 1,
          mapNodeValue: n
        });
    }
    throw ve(`Unrecognized eviction policy ${e}`);
  }
  var bw = mw;
  function yw(e) {
    return () => null;
  }
  var xw = {
    startPerfBlock: yw
  };
  const { isLoadable: Sw, loadableWithError: Oo, loadableWithPromise: Rw, loadableWithValue: Ta } = go, { WrappedValue: Pd } = kd, { getNodeLoadable: Bo, peekNodeLoadable: _w, setNodeValue: Cw } = Yt, { saveDepsToStore: ww } = bo, { DEFAULT_VALUE: $w, getConfigDeletionHandler: Ew, getNode: Tw, registerNode: Ul } = Je, { isRecoilValue: kw } = kn, { markRecoilValueModified: Wl } = wt, { retainedByOptionWithDefault: Aw } = dn, { recoilCallback: Mw } = Td, { startPerfBlock: Pw } = xw;
  class Ld {
  }
  const qn = new Ld(), Gn = [], Do = /* @__PURE__ */ new Map(), Lw = (() => {
    let e = 0;
    return () => e++;
  })();
  function Id(e) {
    let t = null;
    const { key: n, get: o, cachePolicy_UNSTABLE: r } = e, a = e.set != null ? e.set : void 0, i = /* @__PURE__ */ new Set(), s = bw(r ?? {
      equality: "reference",
      eviction: "keep-all"
    }, n), l = Aw(e.retainedBy_UNSTABLE), c = /* @__PURE__ */ new Map();
    let d = 0;
    function p() {
      return !Ee("recoil_memory_managament_2020") || d > 0;
    }
    function m(_) {
      return _.getState().knownSelectors.add(n), d++, () => {
        d--;
      };
    }
    function v() {
      return Ew(n) !== void 0 && !p();
    }
    function g(_, L, A, Y, k) {
      W(L, Y, k), h(_, A);
    }
    function h(_, L) {
      B(_, L) && O(_), $(L, true);
    }
    function C(_, L) {
      B(_, L) && (Ie(P(_)).stateVersions.clear(), $(L, false));
    }
    function $(_, L) {
      const A = Do.get(_);
      if (A != null) {
        for (const Y of A)
          Wl(Y, Ie(t));
        L && Do.delete(_);
      }
    }
    function R(_, L) {
      let A = Do.get(L);
      A == null && Do.set(L, A = /* @__PURE__ */ new Set()), A.add(_);
    }
    function b(_, L, A, Y, k, Z) {
      return L.then((Q) => {
        if (!p())
          throw O(_), qn;
        const z = Ta(Q);
        return g(_, A, k, z, Y), Q;
      }).catch((Q) => {
        if (!p())
          throw O(_), qn;
        if (Me(Q))
          return y(_, Q, A, Y, k, Z);
        const z = Oo(Q);
        throw g(_, A, k, z, Y), Q;
      });
    }
    function y(_, L, A, Y, k, Z) {
      return L.then((Q) => {
        if (!p())
          throw O(_), qn;
        Z.loadingDepKey != null && Z.loadingDepPromise === L ? A.atomValues.set(Z.loadingDepKey, Ta(Q)) : _.getState().knownSelectors.forEach((ie) => {
          A.atomValues.delete(ie);
        });
        const z = T(_, A);
        if (z && z.state !== "loading") {
          if ((B(_, k) || P(_) == null) && h(_, k), z.state === "hasValue")
            return z.contents;
          throw z.contents;
        }
        if (!B(_, k)) {
          const ie = V(_, A);
          if (ie != null)
            return ie.loadingLoadable.contents;
        }
        const [fe, re] = w(_, A, k);
        if (fe.state !== "loading" && g(_, A, k, fe, re), fe.state === "hasError")
          throw fe.contents;
        return fe.contents;
      }).catch((Q) => {
        if (Q instanceof Ld)
          throw qn;
        if (!p())
          throw O(_), qn;
        const z = Oo(Q);
        throw g(_, A, k, z, Y), Q;
      });
    }
    function E(_, L, A, Y) {
      var k, Z, Q, z;
      if (B(_, Y) || L.version === ((k = _.getState()) === null || k === void 0 || (Z = k.currentTree) === null || Z === void 0 ? void 0 : Z.version) || L.version === ((Q = _.getState()) === null || Q === void 0 || (z = Q.nextTree) === null || z === void 0 ? void 0 : z.version)) {
        var fe, re, ie;
        ww(n, A, _, (fe = (re = _.getState()) === null || re === void 0 || (ie = re.nextTree) === null || ie === void 0 ? void 0 : ie.version) !== null && fe !== void 0 ? fe : _.getState().currentTree.version);
      }
      for (const te of A)
        i.add(te);
    }
    function w(_, L, A) {
      const Y = Pw(n);
      let k = true, Z = true;
      const Q = () => {
        Y(), Z = false;
      };
      let z, fe = false, re;
      const ie = {
        loadingDepKey: null,
        loadingDepPromise: null
      }, te = /* @__PURE__ */ new Map();
      function ge({ key: Be }) {
        const ke = Bo(_, L, Be);
        switch (te.set(Be, ke), k || (E(_, L, new Set(te.keys()), A), C(_, A)), ke.state) {
          case "hasValue":
            return ke.contents;
          case "hasError":
            throw ke.contents;
          case "loading":
            throw ie.loadingDepKey = Be, ie.loadingDepPromise = ke.contents, ke.contents;
        }
        throw ve("Invalid Loadable state");
      }
      const _e = (Be) => (...ke) => {
        if (Z)
          throw ve("Callbacks from getCallback() should only be called asynchronously after the selector is evalutated.  It can be used for selectors to return objects with callbacks that can work with Recoil state without a subscription.");
        return t == null && Jn(false), Mw(_, Be, ke, {
          node: t
        });
      };
      try {
        z = o({
          get: ge,
          getCallback: _e
        }), z = kw(z) ? ge(z) : z, Sw(z) && (z.state === "hasError" && (fe = true), z = z.contents), Me(z) ? z = b(_, z, L, te, A, ie).finally(Q) : Q(), z = z instanceof Pd ? z.value : z;
      } catch (Be) {
        z = Be, Me(z) ? z = y(_, z, L, te, A, ie).finally(Q) : (fe = true, Q());
      }
      return fe ? re = Oo(z) : Me(z) ? re = Rw(z) : re = Ta(z), k = false, F(_, A, te), E(_, L, new Set(te.keys()), A), [
        re,
        te
      ];
    }
    function T(_, L) {
      let A = L.atomValues.get(n);
      if (A != null)
        return A;
      const Y = /* @__PURE__ */ new Set();
      try {
        A = s.get((Z) => (typeof Z != "string" && Jn(false), Bo(_, L, Z).contents), {
          onNodeVisit: (Z) => {
            Z.type === "branch" && Z.nodeKey !== n && Y.add(Z.nodeKey);
          }
        });
      } catch (Z) {
        throw ve(`Problem with cache lookup for selector "${n}": ${Z.message}`);
      }
      if (A) {
        var k;
        L.atomValues.set(n, A), E(_, L, Y, (k = P(_)) === null || k === void 0 ? void 0 : k.executionID);
      }
      return A;
    }
    function I(_, L) {
      const A = T(_, L);
      if (A != null)
        return O(_), A;
      const Y = V(_, L);
      if (Y != null) {
        var k;
        return ((k = Y.loadingLoadable) === null || k === void 0 ? void 0 : k.state) === "loading" && R(_, Y.executionID), Y.loadingLoadable;
      }
      const Z = Lw(), [Q, z] = w(_, L, Z);
      return Q.state === "loading" ? (U(_, Z, Q, z, L), R(_, Z)) : (O(_), W(L, Q, z)), Q;
    }
    function V(_, L) {
      const A = nd([
        c.has(_) ? [
          Ie(c.get(_))
        ] : [],
        jr(Pi(c, ([k]) => k !== _), ([, k]) => k)
      ]);
      function Y(k) {
        for (const [Z, Q] of k)
          if (!Bo(_, L, Z).is(Q))
            return true;
        return false;
      }
      for (const k of A) {
        if (k.stateVersions.get(L.version) || !Y(k.depValuesDiscoveredSoFarDuringAsyncWork))
          return k.stateVersions.set(L.version, true), k;
        k.stateVersions.set(L.version, false);
      }
    }
    function P(_) {
      return c.get(_);
    }
    function U(_, L, A, Y, k) {
      c.set(_, {
        depValuesDiscoveredSoFarDuringAsyncWork: Y,
        executionID: L,
        loadingLoadable: A,
        stateVersions: /* @__PURE__ */ new Map([
          [
            k.version,
            true
          ]
        ])
      });
    }
    function F(_, L, A) {
      if (B(_, L)) {
        const Y = P(_);
        Y != null && (Y.depValuesDiscoveredSoFarDuringAsyncWork = A);
      }
    }
    function O(_) {
      c.delete(_);
    }
    function B(_, L) {
      var A;
      return L === ((A = P(_)) === null || A === void 0 ? void 0 : A.executionID);
    }
    function j(_) {
      return Array.from(_.entries()).map(([L, A]) => [
        L,
        A.contents
      ]);
    }
    function W(_, L, A) {
      _.atomValues.set(n, L);
      try {
        s.set(j(A), L);
      } catch (Y) {
        throw ve(`Problem with setting cache for selector "${n}": ${Y.message}`);
      }
    }
    function H(_) {
      if (Gn.includes(n)) {
        const L = `Recoil selector has circular dependencies: ${Gn.slice(Gn.indexOf(n)).join(" \u2192 ")}`;
        return Oo(ve(L));
      }
      Gn.push(n);
      try {
        return _();
      } finally {
        Gn.pop();
      }
    }
    function D(_, L) {
      const A = L.atomValues.get(n);
      return A ?? s.get((Y) => {
        var k;
        return typeof Y != "string" && Jn(false), (k = _w(_, L, Y)) === null || k === void 0 ? void 0 : k.contents;
      });
    }
    function me(_, L) {
      return H(() => I(_, L));
    }
    function ne(_) {
      _.atomValues.delete(n);
    }
    function de(_, L) {
      t == null && Jn(false);
      for (const Y of i) {
        var A;
        const k = Tw(Y);
        (A = k.clearCache) === null || A === void 0 || A.call(k, _, L);
      }
      i.clear(), ne(L), s.clear(), Wl(_, t);
    }
    return a != null ? t = Ul({
      key: n,
      nodeType: "selector",
      peek: D,
      get: me,
      set: (L, A, Y) => {
        let k = false;
        const Z = /* @__PURE__ */ new Map();
        function Q({ key: ie }) {
          if (k)
            throw ve("Recoil: Async selector sets are not currently supported.");
          const te = Bo(L, A, ie);
          if (te.state === "hasValue")
            return te.contents;
          if (te.state === "loading") {
            const ge = `Getting value of asynchronous atom or selector "${ie}" in a pending state while setting selector "${n}" is not yet supported.`;
            throw ve(ge);
          } else
            throw te.contents;
        }
        function z(ie, te) {
          if (k)
            throw ve("Recoil: Async selector sets are not currently supported.");
          const ge = typeof te == "function" ? te(Q(ie)) : te;
          Cw(L, A, ie.key, ge).forEach((Be, ke) => Z.set(ke, Be));
        }
        function fe(ie) {
          z(ie, $w);
        }
        const re = a({
          set: z,
          get: Q,
          reset: fe
        }, Y);
        if (re !== void 0)
          throw Me(re) ? ve("Recoil: Async selector sets are not currently supported.") : ve("Recoil: selector set should be a void function.");
        return k = true, Z;
      },
      init: m,
      invalidate: ne,
      clearCache: de,
      shouldDeleteConfigOnRelease: v,
      dangerouslyAllowMutability: e.dangerouslyAllowMutability,
      shouldRestoreFromSnapshots: false,
      retainedBy: l
    }) : t = Ul({
      key: n,
      nodeType: "selector",
      peek: D,
      get: me,
      init: m,
      invalidate: ne,
      clearCache: de,
      shouldDeleteConfigOnRelease: v,
      dangerouslyAllowMutability: e.dangerouslyAllowMutability,
      shouldRestoreFromSnapshots: false,
      retainedBy: l
    });
  }
  Id.value = (e) => new Pd(e);
  var Pn = Id;
  const { isLoadable: Iw, loadableWithError: ka, loadableWithPromise: Aa, loadableWithValue: xn } = go, { WrappedValue: Nd } = kd, { peekNodeInfo: Nw } = Yt, { DEFAULT_VALUE: rn, DefaultValue: Vt, getConfigDeletionHandler: Fd, registerNode: Fw, setConfigDeletionHandler: Ow } = Je, { isRecoilValue: Bw } = kn, { getRecoilValueAsLoadable: Dw, markRecoilValueModified: jw, setRecoilValue: Hl, setRecoilValueLoadable: zw } = wt, { retainedByOptionWithDefault: Vw } = dn, Yn = (e) => e instanceof Nd ? e.value : e;
  function Uw(e) {
    const { key: t, persistence_UNSTABLE: n } = e, o = Vw(e.retainedBy_UNSTABLE);
    let r = 0;
    function a(R) {
      return Aa(R.then((b) => (i = xn(b), b)).catch((b) => {
        throw i = ka(b), b;
      }));
    }
    let i = Me(e.default) ? a(e.default) : Iw(e.default) ? e.default.state === "loading" ? a(e.default.contents) : e.default : xn(Yn(e.default));
    i.contents;
    let s;
    const l = /* @__PURE__ */ new Map();
    function c(R) {
      return R;
    }
    function d(R, b) {
      const y = b.then((E) => {
        var w, T;
        return ((T = ((w = R.getState().nextTree) !== null && w !== void 0 ? w : R.getState().currentTree).atomValues.get(t)) === null || T === void 0 ? void 0 : T.contents) === y && Hl(R, $, E), E;
      }).catch((E) => {
        var w, T;
        throw ((T = ((w = R.getState().nextTree) !== null && w !== void 0 ? w : R.getState().currentTree).atomValues.get(t)) === null || T === void 0 ? void 0 : T.contents) === y && zw(R, $, ka(E)), E;
      });
      return y;
    }
    function p(R, b, y) {
      var E;
      r++;
      const w = () => {
        var P;
        r--, (P = l.get(R)) === null || P === void 0 || P.forEach((U) => U()), l.delete(R);
      };
      if (R.getState().knownAtoms.add(t), i.state === "loading") {
        const P = () => {
          var U;
          ((U = R.getState().nextTree) !== null && U !== void 0 ? U : R.getState().currentTree).atomValues.has(t) || jw(R, $);
        };
        i.contents.finally(P);
      }
      const T = (E = e.effects) !== null && E !== void 0 ? E : e.effects_UNSTABLE;
      if (T != null) {
        let B = function(ne) {
          if (U && ne.key === t) {
            const de = P;
            return de instanceof Vt ? m(R, b) : Me(de) ? Aa(de.then((_) => _ instanceof Vt ? i.toPromise() : _)) : xn(de);
          }
          return Dw(R, ne);
        }, j = function(ne) {
          return B(ne).toPromise();
        }, W = function(ne) {
          var de;
          const _ = Nw(R, (de = R.getState().nextTree) !== null && de !== void 0 ? de : R.getState().currentTree, ne.key);
          return U && ne.key === t && !(P instanceof Vt) ? {
            ..._,
            isSet: true,
            loadable: B(ne)
          } : _;
        }, P = rn, U = true, F = false, O = null;
        const H = (ne) => (de) => {
          if (U) {
            const _ = B($), L = _.state === "hasValue" ? _.contents : rn;
            P = typeof de == "function" ? de(L) : de, Me(P) && (P = P.then((A) => (O = {
              effect: ne,
              value: A
            }, A)));
          } else {
            if (Me(de))
              throw ve("Setting atoms to async values is not implemented.");
            typeof de != "function" && (O = {
              effect: ne,
              value: Yn(de)
            }), Hl(R, $, typeof de == "function" ? (_) => {
              const L = Yn(de(_));
              return O = {
                effect: ne,
                value: L
              }, L;
            } : Yn(de));
          }
        }, D = (ne) => () => H(ne)(rn), me = (ne) => (de) => {
          var _;
          const { release: L } = R.subscribeToTransactions((A) => {
            var Y;
            let { currentTree: k, previousTree: Z } = A.getState();
            Z || (Z = k);
            const Q = (Y = k.atomValues.get(t)) !== null && Y !== void 0 ? Y : i;
            if (Q.state === "hasValue") {
              var z, fe, re, ie;
              const te = Q.contents, ge = (z = Z.atomValues.get(t)) !== null && z !== void 0 ? z : i, _e = ge.state === "hasValue" ? ge.contents : rn;
              ((fe = O) === null || fe === void 0 ? void 0 : fe.effect) !== ne || ((re = O) === null || re === void 0 ? void 0 : re.value) !== te ? de(te, _e, !k.atomValues.has(t)) : ((ie = O) === null || ie === void 0 ? void 0 : ie.effect) === ne && (O = null);
            }
          }, t);
          l.set(R, [
            ...(_ = l.get(R)) !== null && _ !== void 0 ? _ : [],
            L
          ]);
        };
        for (const ne of T)
          try {
            const de = ne({
              node: $,
              storeID: R.storeID,
              parentStoreID_UNSTABLE: R.parentStoreID,
              trigger: y,
              setSelf: H(ne),
              resetSelf: D(ne),
              onSet: me(ne),
              getPromise: j,
              getLoadable: B,
              getInfo_UNSTABLE: W
            });
            if (de != null) {
              var I;
              l.set(R, [
                ...(I = l.get(R)) !== null && I !== void 0 ? I : [],
                de
              ]);
            }
          } catch (de) {
            P = de, F = true;
          }
        if (U = false, !(P instanceof Vt)) {
          var V;
          const ne = F ? ka(P) : Me(P) ? Aa(d(R, P)) : xn(Yn(P));
          ne.contents, b.atomValues.set(t, ne), (V = R.getState().nextTree) === null || V === void 0 || V.atomValues.set(t, ne);
        }
      }
      return w;
    }
    function m(R, b) {
      var y, E;
      return (y = (E = b.atomValues.get(t)) !== null && E !== void 0 ? E : s) !== null && y !== void 0 ? y : i;
    }
    function v(R, b) {
      if (b.atomValues.has(t))
        return Ie(b.atomValues.get(t));
      if (b.nonvalidatedAtoms.has(t)) {
        if (s != null)
          return s;
        if (n == null)
          return i;
        const y = b.nonvalidatedAtoms.get(t), E = n.validator(y, rn);
        return s = E instanceof Vt ? i : xn(E), s;
      } else
        return i;
    }
    function g() {
      s = void 0;
    }
    function h(R, b, y) {
      if (b.atomValues.has(t)) {
        const E = Ie(b.atomValues.get(t));
        if (E.state === "hasValue" && y === E.contents)
          return /* @__PURE__ */ new Map();
      } else if (!b.nonvalidatedAtoms.has(t) && y instanceof Vt)
        return /* @__PURE__ */ new Map();
      return s = void 0, (/* @__PURE__ */ new Map()).set(t, xn(y));
    }
    function C() {
      return Fd(t) !== void 0 && r <= 0;
    }
    const $ = Fw({
      key: t,
      nodeType: "atom",
      peek: m,
      get: v,
      set: h,
      init: p,
      invalidate: g,
      shouldDeleteConfigOnRelease: C,
      dangerouslyAllowMutability: e.dangerouslyAllowMutability,
      persistence_UNSTABLE: e.persistence_UNSTABLE ? {
        type: e.persistence_UNSTABLE.type,
        backButton: e.persistence_UNSTABLE.backButton
      } : void 0,
      shouldRestoreFromSnapshots: true,
      retainedBy: o
    });
    return $;
  }
  function Vi(e) {
    const { ...t } = e, n = "default" in e ? e.default : new Promise(() => {
    });
    return Bw(n) ? Ww({
      ...t,
      default: n
    }) : Uw({
      ...t,
      default: n
    });
  }
  function Ww(e) {
    const t = Vi({
      ...e,
      default: rn,
      persistence_UNSTABLE: e.persistence_UNSTABLE === void 0 ? void 0 : {
        ...e.persistence_UNSTABLE,
        validator: (o) => o instanceof Vt ? o : Ie(e.persistence_UNSTABLE).validator(o, rn)
      },
      effects: e.effects,
      effects_UNSTABLE: e.effects_UNSTABLE
    }), n = Pn({
      key: `${e.key}__withFallback`,
      get: ({ get: o }) => {
        const r = o(t);
        return r instanceof Vt ? e.default : r;
      },
      set: ({ set: o }, r) => o(t, r),
      cachePolicy_UNSTABLE: {
        eviction: "most-recent"
      },
      dangerouslyAllowMutability: e.dangerouslyAllowMutability
    });
    return Ow(n.key, Fd(e.key)), n;
  }
  Vi.value = (e) => new Nd(e);
  var Od = Vi;
  class Hw {
    constructor(t) {
      var n;
      he(this, "_map", void 0), he(this, "_keyMapper", void 0), this._map = /* @__PURE__ */ new Map(), this._keyMapper = (n = t == null ? void 0 : t.mapKey) !== null && n !== void 0 ? n : (o) => o;
    }
    size() {
      return this._map.size;
    }
    has(t) {
      return this._map.has(this._keyMapper(t));
    }
    get(t) {
      return this._map.get(this._keyMapper(t));
    }
    set(t, n) {
      this._map.set(this._keyMapper(t), n);
    }
    delete(t) {
      this._map.delete(this._keyMapper(t));
    }
    clear() {
      this._map.clear();
    }
  }
  var Kw = {
    MapCache: Hw
  }, qw = Kw.MapCache, Gw = Object.freeze({
    __proto__: null,
    MapCache: qw
  });
  const { LRUCache: Kl } = Md, { MapCache: Yw } = Gw, jo = {
    equality: "reference",
    eviction: "none",
    maxSize: 1 / 0
  };
  function Xw({ equality: e = jo.equality, eviction: t = jo.eviction, maxSize: n = jo.maxSize } = jo) {
    const o = Zw(e);
    return Jw(t, n, o);
  }
  function Zw(e) {
    switch (e) {
      case "reference":
        return (t) => t;
      case "value":
        return (t) => Qr(t);
    }
    throw ve(`Unrecognized equality policy ${e}`);
  }
  function Jw(e, t, n) {
    switch (e) {
      case "keep-all":
        return new Yw({
          mapKey: n
        });
      case "lru":
        return new Kl({
          mapKey: n,
          maxSize: Ie(t)
        });
      case "most-recent":
        return new Kl({
          mapKey: n,
          maxSize: 1
        });
    }
    throw ve(`Unrecognized eviction policy ${e}`);
  }
  var Bd = Xw;
  const { setConfigDeletionHandler: Qw } = Je;
  function e$(e) {
    var t, n;
    const o = Bd({
      equality: (t = (n = e.cachePolicyForParams_UNSTABLE) === null || n === void 0 ? void 0 : n.equality) !== null && t !== void 0 ? t : "value",
      eviction: "keep-all"
    });
    return (r) => {
      var a, i;
      const s = o.get(r);
      if (s != null)
        return s;
      const { cachePolicyForParams_UNSTABLE: l, ...c } = e, d = "default" in e ? e.default : new Promise(() => {
      }), p = Od({
        ...c,
        key: `${e.key}__${(a = Qr(r)) !== null && a !== void 0 ? a : "void"}`,
        default: typeof d == "function" ? d(r) : d,
        retainedBy_UNSTABLE: typeof e.retainedBy_UNSTABLE == "function" ? e.retainedBy_UNSTABLE(r) : e.retainedBy_UNSTABLE,
        effects: typeof e.effects == "function" ? e.effects(r) : typeof e.effects_UNSTABLE == "function" ? e.effects_UNSTABLE(r) : (i = e.effects) !== null && i !== void 0 ? i : e.effects_UNSTABLE
      });
      return o.set(r, p), Qw(p.key, () => {
        o.delete(r);
      }), p;
    };
  }
  var t$ = e$;
  const { setConfigDeletionHandler: n$ } = Je;
  let o$ = 0;
  function r$(e) {
    var t, n;
    const o = Bd({
      equality: (t = (n = e.cachePolicyForParams_UNSTABLE) === null || n === void 0 ? void 0 : n.equality) !== null && t !== void 0 ? t : "value",
      eviction: "keep-all"
    });
    return (r) => {
      var a;
      let i;
      try {
        i = o.get(r);
      } catch (m) {
        throw ve(`Problem with cache lookup for selector ${e.key}: ${m.message}`);
      }
      if (i != null)
        return i;
      const s = `${e.key}__selectorFamily/${(a = Qr(r, {
        allowFunctions: true
      })) !== null && a !== void 0 ? a : "void"}/${o$++}`, l = (m) => e.get(r)(m), c = e.cachePolicy_UNSTABLE, d = typeof e.retainedBy_UNSTABLE == "function" ? e.retainedBy_UNSTABLE(r) : e.retainedBy_UNSTABLE;
      let p;
      if (e.set != null) {
        const m = e.set;
        p = Pn({
          key: s,
          get: l,
          set: (g, h) => m(r)(g, h),
          cachePolicy_UNSTABLE: c,
          dangerouslyAllowMutability: e.dangerouslyAllowMutability,
          retainedBy_UNSTABLE: d
        });
      } else
        p = Pn({
          key: s,
          get: l,
          cachePolicy_UNSTABLE: c,
          dangerouslyAllowMutability: e.dangerouslyAllowMutability,
          retainedBy_UNSTABLE: d
        });
      return o.set(r, p), n$(p.key, () => {
        o.delete(r);
      }), p;
    };
  }
  var Xt = r$;
  const a$ = Xt({
    key: "__constant",
    get: (e) => () => e,
    cachePolicyForParams_UNSTABLE: {
      equality: "reference"
    }
  });
  function i$(e) {
    return a$(e);
  }
  var s$ = i$;
  const l$ = Xt({
    key: "__error",
    get: (e) => () => {
      throw ve(e);
    },
    cachePolicyForParams_UNSTABLE: {
      equality: "reference"
    }
  });
  function c$(e) {
    return l$(e);
  }
  var u$ = c$;
  function d$(e) {
    return e;
  }
  var p$ = d$;
  const { loadableWithError: Dd, loadableWithPromise: jd, loadableWithValue: zd } = go;
  function ea(e, t) {
    const n = Array(t.length).fill(void 0), o = Array(t.length).fill(void 0);
    for (const [r, a] of t.entries())
      try {
        n[r] = e(a);
      } catch (i) {
        o[r] = i;
      }
    return [
      n,
      o
    ];
  }
  function f$(e) {
    return e != null && !Me(e);
  }
  function ta(e) {
    return Array.isArray(e) ? e : Object.getOwnPropertyNames(e).map((t) => e[t]);
  }
  function Ja(e, t) {
    return Array.isArray(e) ? t : Object.getOwnPropertyNames(e).reduce((n, o, r) => ({
      ...n,
      [o]: t[r]
    }), {});
  }
  function _n(e, t, n) {
    const o = n.map((r, a) => r == null ? zd(t[a]) : Me(r) ? jd(r) : Dd(r));
    return Ja(e, o);
  }
  function h$(e, t) {
    return t.map((n, o) => n === void 0 ? e[o] : n);
  }
  const m$ = Xt({
    key: "__waitForNone",
    get: (e) => ({ get: t }) => {
      const n = ta(e), [o, r] = ea(t, n);
      return _n(e, o, r);
    },
    dangerouslyAllowMutability: true
  }), g$ = Xt({
    key: "__waitForAny",
    get: (e) => ({ get: t }) => {
      const n = ta(e), [o, r] = ea(t, n);
      return r.some((a) => !Me(a)) ? _n(e, o, r) : new Promise((a) => {
        for (const [i, s] of r.entries())
          Me(s) && s.then((l) => {
            o[i] = l, r[i] = void 0, a(_n(e, o, r));
          }).catch((l) => {
            r[i] = l, a(_n(e, o, r));
          });
      });
    },
    dangerouslyAllowMutability: true
  }), v$ = Xt({
    key: "__waitForAll",
    get: (e) => ({ get: t }) => {
      const n = ta(e), [o, r] = ea(t, n);
      if (r.every((i) => i == null))
        return Ja(e, o);
      const a = r.find(f$);
      if (a != null)
        throw a;
      return Promise.all(r).then((i) => Ja(e, h$(o, i)));
    },
    dangerouslyAllowMutability: true
  }), b$ = Xt({
    key: "__waitForAllSettled",
    get: (e) => ({ get: t }) => {
      const n = ta(e), [o, r] = ea(t, n);
      return r.every((a) => !Me(a)) ? _n(e, o, r) : Promise.all(r.map((a, i) => Me(a) ? a.then((s) => {
        o[i] = s, r[i] = void 0;
      }).catch((s) => {
        o[i] = void 0, r[i] = s;
      }) : null)).then(() => _n(e, o, r));
    },
    dangerouslyAllowMutability: true
  }), y$ = Xt({
    key: "__noWait",
    get: (e) => ({ get: t }) => {
      try {
        return Pn.value(zd(t(e)));
      } catch (n) {
        return Pn.value(Me(n) ? jd(n) : Dd(n));
      }
    },
    dangerouslyAllowMutability: true
  });
  var x$ = {
    waitForNone: m$,
    waitForAny: g$,
    waitForAll: v$,
    waitForAllSettled: b$,
    noWait: y$
  };
  const { RecoilLoadable: S$ } = go, { DefaultValue: R$ } = Je, { RecoilRoot: _$, useRecoilStoreID: C$ } = Ft, { isRecoilValue: w$ } = kn, { retentionZone: $$ } = Vr, { freshSnapshot: E$ } = Gr, { useRecoilState: T$, useRecoilState_TRANSITION_SUPPORT_UNSTABLE: k$, useRecoilStateLoadable: A$, useRecoilValue: M$, useRecoilValue_TRANSITION_SUPPORT_UNSTABLE: P$, useRecoilValueLoadable: L$, useRecoilValueLoadable_TRANSITION_SUPPORT_UNSTABLE: I$, useResetRecoilState: N$, useSetRecoilState: F$ } = K2, { useGotoRecoilSnapshot: O$, useRecoilSnapshot: B$, useRecoilTransactionObserver: D$ } = Cd, { useRecoilCallback: j$ } = Td, { noWait: z$, waitForAll: V$, waitForAllSettled: U$, waitForAny: W$, waitForNone: H$ } = x$;
  var Ro = {
    DefaultValue: R$,
    isRecoilValue: w$,
    RecoilLoadable: S$,
    RecoilEnv: Fn,
    RecoilRoot: _$,
    useRecoilStoreID: C$,
    useRecoilBridgeAcrossReactRoots_UNSTABLE: yC,
    atom: Od,
    selector: Pn,
    atomFamily: t$,
    selectorFamily: Xt,
    constSelector: s$,
    errorSelector: u$,
    readOnlySelector: p$,
    noWait: z$,
    waitForNone: H$,
    waitForAny: W$,
    waitForAll: V$,
    waitForAllSettled: U$,
    useRecoilValue: M$,
    useRecoilValueLoadable: L$,
    useRecoilState: T$,
    useRecoilStateLoadable: A$,
    useSetRecoilState: F$,
    useResetRecoilState: N$,
    useGetRecoilValueInfo_UNSTABLE: fC,
    useRecoilRefresher_UNSTABLE: GC,
    useRecoilValueLoadable_TRANSITION_SUPPORT_UNSTABLE: I$,
    useRecoilValue_TRANSITION_SUPPORT_UNSTABLE: P$,
    useRecoilState_TRANSITION_SUPPORT_UNSTABLE: k$,
    useRecoilCallback: j$,
    useRecoilTransaction_UNSTABLE: QC,
    useGotoRecoilSnapshot: O$,
    useRecoilSnapshot: B$,
    useRecoilTransactionObserver_UNSTABLE: D$,
    snapshot_UNSTABLE: E$,
    useRetain: Oi,
    retentionZone: $$
  }, K$ = Ro.RecoilRoot, St = Ro.atom, rt = Ro.useRecoilValue, so = Ro.useRecoilState, yt = Ro.useSetRecoilState;
  const q$ = {
    palette: {
      mode: "dark",
      primary: {
        main: "#F07B1F",
        light: "#F5A623",
        dark: "#C05A0F",
        contrastText: "#1C1208"
      },
      secondary: {
        main: "#F5A623",
        light: "#f7b74a",
        dark: "#c17f10",
        contrastText: "#1C1208"
      },
      error: {
        main: "#E03E2D",
        light: "#e96b5e",
        dark: "#b02d1f",
        contrastText: "#FFF5E6"
      },
      success: {
        main: "#F5A623",
        light: "#f7b74a",
        dark: "#c17f10",
        contrastText: "#1C1208"
      },
      warning: {
        main: "#F5A623",
        contrastText: "#1C1208"
      },
      background: {
        default: "#1C1208",
        paper: "#2A1A0A"
      },
      text: {
        primary: "#FFF5E6",
        secondary: "#A87E52",
        disabled: "#4A3020"
      },
      divider: "#3D2510",
      action: {
        active: "#F07B1F",
        hover: "rgba(240,123,31,0.08)",
        selected: "rgba(240,123,31,0.12)",
        disabled: "#4A3020",
        disabledBackground: "rgba(240,123,31,0.06)"
      }
    },
    shape: {
      borderRadius: 12
    },
    components: {
      MuiPaper: {
        styleOverrides: {
          root: {
            backgroundImage: "none"
          }
        }
      },
      MuiDialog: {
        styleOverrides: {
          paper: {
            backgroundColor: "#2A1A0A",
            border: "1px solid #3D2510",
            boxShadow: "0 0 40px rgba(240,123,31,0.08), 0 8px 32px rgba(0,0,0,0.7)",
            borderRadius: "16px"
          }
        }
      },
      MuiDialogTitle: {
        styleOverrides: {
          root: {
            color: "#FFF5E6",
            borderBottom: "1px solid #3D2510",
            fontWeight: 700
          }
        }
      },
      MuiDialogContent: {
        styleOverrides: {
          root: {
            paddingTop: "16px !important"
          }
        }
      },
      MuiTextField: {
        styleOverrides: {
          root: {
            "& .MuiOutlinedInput-root": {
              backgroundColor: "#1C1208",
              borderRadius: "8px",
              "& fieldset": {
                borderColor: "#3D2510"
              },
              "&:hover fieldset": {
                borderColor: "#F07B1F"
              },
              "&.Mui-focused fieldset": {
                borderColor: "#F07B1F",
                borderWidth: "2px"
              }
            },
            "& .MuiInputLabel-root": {
              color: "#A87E52"
            },
            "& .MuiInputLabel-root.Mui-focused": {
              color: "#F07B1F"
            },
            "& .MuiInputBase-input": {
              color: "#FFF5E6"
            },
            "& .MuiFormHelperText-root": {
              color: "#A87E52"
            },
            "& .MuiFormHelperText-root.Mui-error": {
              color: "#E03E2D"
            }
          }
        }
      },
      MuiButton: {
        styleOverrides: {
          root: {
            borderRadius: "8px",
            textTransform: "none",
            fontWeight: 600,
            transition: "all 0.2s"
          },
          containedPrimary: {
            background: "linear-gradient(135deg, #F07B1F, #F5A623)",
            color: "#1C1208",
            "&:hover": {
              background: "linear-gradient(135deg, #f28b35, #f7b74a)",
              transform: "scale(1.02)",
              boxShadow: "0 2px 10px rgba(240,123,31,0.3)"
            },
            "&.Mui-disabled": {
              background: "rgba(240,123,31,0.12)",
              color: "#4A3020"
            }
          },
          text: {
            color: "#A87E52",
            "&:hover": {
              color: "#F5A623",
              backgroundColor: "rgba(240,123,31,0.08)"
            }
          }
        }
      },
      MuiStepIcon: {
        styleOverrides: {
          root: {
            color: "#3D2510",
            "&.Mui-active": {
              color: "#F07B1F"
            },
            "&.Mui-completed": {
              color: "#F5A623"
            }
          }
        }
      },
      MuiStepLabel: {
        styleOverrides: {
          label: {
            color: "#A87E52",
            "&.Mui-active": {
              color: "#F07B1F"
            },
            "&.Mui-completed": {
              color: "#F5A623"
            }
          }
        }
      },
      MuiStepConnector: {
        styleOverrides: {
          line: {
            borderColor: "#3D2510"
          }
        }
      },
      MuiAlert: {
        styleOverrides: {
          root: {
            borderRadius: "8px"
          },
          filledSuccess: {
            backgroundColor: "rgba(245,166,35,0.15)",
            border: "1px solid rgba(245,166,35,0.3)",
            color: "#FFF5E6"
          },
          filledError: {
            backgroundColor: "rgba(224,62,45,0.15)",
            border: "1px solid rgba(224,62,45,0.3)",
            color: "#FFF5E6"
          },
          standardError: {
            backgroundColor: "rgba(224,62,45,0.1)",
            border: "1px solid rgba(224,62,45,0.25)",
            color: "#FFF5E6"
          }
        }
      },
      MuiIconButton: {
        styleOverrides: {
          root: {
            color: "#A87E52",
            transition: "all 0.2s",
            "&:hover": {
              color: "#F5A623",
              backgroundColor: "rgba(240,123,31,0.08)"
            }
          }
        }
      },
      MuiSkeleton: {
        styleOverrides: {
          root: {
            backgroundColor: "rgba(240,123,31,0.08)"
          }
        }
      },
      MuiBackdrop: {
        styleOverrides: {
          root: {
            backgroundColor: "rgba(0,0,0,0.8)"
          }
        }
      },
      MuiInputAdornment: {
        styleOverrides: {
          root: {
            color: "#A87E52"
          }
        }
      }
    }
  }, G$ = {
    palette: {
      mode: "dark",
      primary: {
        main: "#58A6FF",
        light: "#79C0FF",
        dark: "#1F6FEB",
        contrastText: "#0D1117"
      },
      secondary: {
        main: "#79C0FF",
        light: "#a5d3ff",
        dark: "#1F6FEB",
        contrastText: "#0D1117"
      },
      error: {
        main: "#F85149",
        light: "#ff7b75",
        dark: "#da3633",
        contrastText: "#E6EDF3"
      },
      success: {
        main: "#3FB950",
        light: "#56d364",
        dark: "#238636",
        contrastText: "#0D1117"
      },
      warning: {
        main: "#E3B341",
        contrastText: "#0D1117"
      },
      background: {
        default: "#0D1117",
        paper: "#161B22"
      },
      text: {
        primary: "#E6EDF3",
        secondary: "#8B949E",
        disabled: "#30363D"
      },
      divider: "#21262D",
      action: {
        active: "#58A6FF",
        hover: "rgba(88,166,255,0.08)",
        selected: "rgba(88,166,255,0.12)",
        disabled: "#30363D",
        disabledBackground: "rgba(88,166,255,0.06)"
      }
    },
    shape: {
      borderRadius: 12
    },
    components: {
      MuiPaper: {
        styleOverrides: {
          root: {
            backgroundImage: "none"
          }
        }
      },
      MuiDialog: {
        styleOverrides: {
          paper: {
            backgroundColor: "#161B22",
            border: "1px solid #21262D",
            boxShadow: "0 0 40px rgba(88,166,255,0.06), 0 8px 32px rgba(0,0,0,0.6)",
            borderRadius: "16px"
          }
        }
      },
      MuiDialogTitle: {
        styleOverrides: {
          root: {
            color: "#E6EDF3",
            borderBottom: "1px solid #21262D",
            fontWeight: 700
          }
        }
      },
      MuiDialogContent: {
        styleOverrides: {
          root: {
            paddingTop: "16px !important"
          }
        }
      },
      MuiTextField: {
        styleOverrides: {
          root: {
            "& .MuiOutlinedInput-root": {
              backgroundColor: "#0D1117",
              borderRadius: "8px",
              "& fieldset": {
                borderColor: "#21262D"
              },
              "&:hover fieldset": {
                borderColor: "#58A6FF"
              },
              "&.Mui-focused fieldset": {
                borderColor: "#58A6FF",
                borderWidth: "2px"
              }
            },
            "& .MuiInputLabel-root": {
              color: "#8B949E"
            },
            "& .MuiInputLabel-root.Mui-focused": {
              color: "#58A6FF"
            },
            "& .MuiInputBase-input": {
              color: "#E6EDF3"
            },
            "& .MuiFormHelperText-root": {
              color: "#8B949E"
            },
            "& .MuiFormHelperText-root.Mui-error": {
              color: "#F85149"
            }
          }
        }
      },
      MuiButton: {
        styleOverrides: {
          root: {
            borderRadius: "8px",
            textTransform: "none",
            fontWeight: 600,
            transition: "all 0.2s"
          },
          containedPrimary: {
            background: "linear-gradient(135deg, #1F6FEB, #58A6FF)",
            color: "#0D1117",
            "&:hover": {
              background: "linear-gradient(135deg, #388bfd, #79C0FF)",
              transform: "scale(1.02)",
              boxShadow: "0 2px 10px rgba(88,166,255,0.3)"
            },
            "&.Mui-disabled": {
              background: "rgba(88,166,255,0.12)",
              color: "#30363D"
            }
          },
          text: {
            color: "#8B949E",
            "&:hover": {
              color: "#58A6FF",
              backgroundColor: "rgba(88,166,255,0.08)"
            }
          }
        }
      },
      MuiStepIcon: {
        styleOverrides: {
          root: {
            color: "#21262D",
            "&.Mui-active": {
              color: "#1F6FEB"
            },
            "&.Mui-completed": {
              color: "#58A6FF"
            }
          }
        }
      },
      MuiStepLabel: {
        styleOverrides: {
          label: {
            color: "#8B949E",
            "&.Mui-active": {
              color: "#1F6FEB"
            },
            "&.Mui-completed": {
              color: "#58A6FF"
            }
          }
        }
      },
      MuiStepConnector: {
        styleOverrides: {
          line: {
            borderColor: "#21262D"
          }
        }
      },
      MuiAlert: {
        styleOverrides: {
          root: {
            borderRadius: "8px"
          },
          filledSuccess: {
            backgroundColor: "rgba(63,185,80,0.15)",
            border: "1px solid rgba(63,185,80,0.3)",
            color: "#E6EDF3"
          },
          filledError: {
            backgroundColor: "rgba(248,81,73,0.15)",
            border: "1px solid rgba(248,81,73,0.3)",
            color: "#E6EDF3"
          },
          standardError: {
            backgroundColor: "rgba(248,81,73,0.10)",
            border: "1px solid rgba(248,81,73,0.25)",
            color: "#E6EDF3"
          }
        }
      },
      MuiIconButton: {
        styleOverrides: {
          root: {
            color: "#8B949E",
            transition: "all 0.2s",
            "&:hover": {
              color: "#58A6FF",
              backgroundColor: "rgba(88,166,255,0.08)"
            }
          }
        }
      },
      MuiSkeleton: {
        styleOverrides: {
          root: {
            backgroundColor: "rgba(88,166,255,0.08)"
          }
        }
      },
      MuiBackdrop: {
        styleOverrides: {
          root: {
            backgroundColor: "rgba(0,0,0,0.8)"
          }
        }
      },
      MuiInputAdornment: {
        styleOverrides: {
          root: {
            color: "#8B949E"
          }
        }
      }
    }
  }, Y$ = {
    bhrp: q$,
    default: G$
  }, X$ = "bhrp", Z$ = ({ children: e }) => {
    const t = bi(Y$[X$]);
    return u.jsx(tg, {
      theme: t,
      children: e
    });
  }, Vd = (e, t) => ({ setSelf: n, onSet: o }) => {
    try {
      const r = localStorage.getItem(e);
      r != null && n(JSON.parse(r));
    } catch {
    }
    o((r, a, i) => {
      i ? localStorage.removeItem(e) : localStorage.setItem(e, JSON.stringify(r));
    });
  }, Ui = St({
    key: "bankingapp_theme",
    default: "bhrp",
    effects: [
      Vd("bankingapp_theme")
    ]
  }), Ud = St({
    key: "bankingapp_balanceHidden",
    default: false,
    effects: [
      Vd("bankingapp_balanceHidden")
    ]
  }), na = St({
    key: "bankingapp_balance",
    default: null
  }), Wd = St({
    key: "bankingapp_balanceLoading",
    default: false
  }), Hd = St({
    key: "bankingapp_transactions",
    default: []
  }), Kd = St({
    key: "bankingapp_transactionsLoading",
    default: false
  }), qd = St({
    key: "bankingapp_atmLocations",
    default: []
  }), Gd = St({
    key: "bankingapp_atmLoading",
    default: false
  }), Qa = St({
    key: "bankingapp_toasts",
    default: []
  }), _o = St({
    key: "bankingapp_activeModal",
    default: null
  }), Yd = St({
    key: "bankingapp_activeTab",
    default: "transactions"
  });
  var Wi = {}, Ma = {};
  const J$ = Ct(lg);
  var ql;
  function Qe() {
    return ql || (ql = 1, function(e) {
      "use client";
      Object.defineProperty(e, "__esModule", {
        value: true
      }), Object.defineProperty(e, "default", {
        enumerable: true,
        get: function() {
          return t.createSvgIcon;
        }
      });
      var t = J$;
    }(Ma)), Ma;
  }
  var Q$ = He;
  Object.defineProperty(Wi, "__esModule", {
    value: true
  });
  var Xd = Wi.default = void 0, eE = Q$(Qe()), tE = u;
  Xd = Wi.default = (0, eE.default)((0, tE.jsx)("path", {
    d: "M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2m0 16H8V7h11z"
  }), "ContentCopy");
  var Hi = {}, nE = He;
  Object.defineProperty(Hi, "__esModule", {
    value: true
  });
  var Zd = Hi.default = void 0, oE = nE(Qe()), rE = u;
  Zd = Hi.default = (0, oE.default)((0, rE.jsx)("path", {
    d: "M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"
  }), "Check");
  var Ki = {}, aE = He;
  Object.defineProperty(Ki, "__esModule", {
    value: true
  });
  var Jd = Ki.default = void 0, iE = aE(Qe()), sE = u;
  Jd = Ki.default = (0, iE.default)((0, sE.jsx)("path", {
    d: "M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6"
  }), "Settings");
  const lE = "" + new URL("bhrplogo-cfa4bc97.png", import.meta.url).href, { useState: cE } = await M("react"), Qd = "3.5rem", uE = X.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: ${Qd};
  padding: 0 0.875rem 0 1rem;
  background-color: var(--bk-surface);
  border-bottom: 1px solid var(--bk-border);
  flex-shrink: 0;
`, dE = X.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
`, pE = X.div`
  width: 26px;
  height: 26px;
  background: var(--bk-grad);
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.68rem;
  font-weight: 800;
  color: var(--bk-bg);
  flex-shrink: 0;
`, fE = X.span`
  font-weight: 700;
  font-size: 0.88rem;
  color: var(--bk-text);
  letter-spacing: 0.01em;
`, hE = X.div`
  display: flex;
  align-items: center;
  gap: 0.3rem;
`, mE = X.span`
  font-size: 0.66rem;
  color: var(--bk-muted);
  font-family: monospace;
  letter-spacing: 0.04em;
`, Gl = X.button`
  background: none;
  border: none;
  padding: 3px;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  border-radius: 4px;
  transition: all 0.2s;
  position: relative;

  &:hover {
    color: var(--bk-alt);
    background: var(--bk-p-a10);
  }
`, gE = X.span`
  position: absolute;
  bottom: calc(100% + 4px);
  right: 0;
  background: var(--bk-alt);
  color: var(--bk-bg);
  font-size: 0.62rem;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
  white-space: nowrap;
  pointer-events: none;
  opacity: ${({ visible: e }) => e ? 1 : 0};
  transition: opacity 0.15s;
`, vE = () => {
    const e = rt(na), t = rt(Ui), n = yt(_o), o = e == null ? void 0 : e.citizenid, [r, a] = cE(false), i = () => {
      o && (navigator.clipboard.writeText(o).catch(() => {
      }), a(true), setTimeout(() => a(false), 1800));
    };
    return u.jsxs(uE, {
      children: [
        u.jsxs(dE, {
          children: [
            t === "bhrp" ? u.jsx("img", {
              src: lE,
              alt: "BHRP",
              style: {
                height: "32px",
                width: "32px",
                objectFit: "contain"
              }
            }) : u.jsx(pE, {
              children: "B"
            }),
            u.jsx(fE, {
              children: t === "bhrp" ? "BeehiveRP Banking" : "Banking"
            })
          ]
        }),
        u.jsxs(hE, {
          children: [
            o && u.jsxs(u.Fragment, {
              children: [
                u.jsxs(mE, {
                  children: [
                    "#",
                    o
                  ]
                }),
                u.jsxs(Gl, {
                  onClick: i,
                  title: "Copy account ID",
                  children: [
                    r ? u.jsx(Zd, {
                      sx: {
                        fontSize: "0.82rem",
                        color: "var(--bk-alt)"
                      }
                    }) : u.jsx(Xd, {
                      sx: {
                        fontSize: "0.82rem"
                      }
                    }),
                    u.jsx(gE, {
                      visible: r,
                      children: "Copied!"
                    })
                  ]
                })
              ]
            }),
            u.jsx(Gl, {
              onClick: () => n("settings"),
              title: "Settings",
              children: u.jsx(Jd, {
                sx: {
                  fontSize: "0.9rem"
                }
              })
            })
          ]
        })
      ]
    });
  }, At = (e) => new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
    maximumFractionDigits: 0
  }).format(e), bE = X.div`
  position: relative;
  padding: 1.125rem 1.25rem 1rem;
  background: var(--bk-surface);
  border-radius: 16px;
  margin-bottom: 0.75rem;
  flex-shrink: 0;
  overflow: hidden;
  box-shadow:
    0 0 0 1px var(--bk-border),
    0 0 28px var(--bk-p-a10),
    0 2px 8px rgba(0,0,0,0.5);
  border-bottom: 2px solid var(--bk-alt);
`, yE = X.div`
  position: absolute;
  right: -20px;
  bottom: -22px;
  width: 120px;
  height: 120px;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  background: var(--bk-p-a06);
  pointer-events: none;
`, xE = X.div`
  position: absolute;
  right: 72px;
  bottom: 16px;
  width: 44px;
  height: 44px;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  background: var(--bk-p-a06);
  pointer-events: none;
`, SE = X.div`
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--bk-muted);
  margin-bottom: 0.15rem;
`, RE = X.div`
  background: var(--bk-grad-text);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 800;
  font-size: 2rem;
  line-height: 1.15;
  letter-spacing: -0.01em;
`, _E = X.div`
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--bk-border) 30%, var(--bk-border) 70%, transparent);
  margin: 0.75rem 0;
`, CE = X.div`
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
`, wE = X.span`
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--bk-muted);
`, $E = X.span`
  font-size: 1rem;
  font-weight: 600;
  color: var(--bk-muted);
`, Yl = "\u2022\u2022\u2022\u2022\u2022", EE = () => {
    const e = rt(na), t = rt(Wd), n = rt(Ud), o = !t && e !== null;
    return u.jsxs(bE, {
      children: [
        u.jsx(yE, {}),
        u.jsx(xE, {}),
        u.jsx(SE, {
          children: "Bank Balance"
        }),
        o ? u.jsx(RE, {
          children: n ? Yl : At(e.bank)
        }) : u.jsx(kt, {
          variant: "text",
          width: 150,
          height: 46
        }),
        u.jsx(_E, {}),
        u.jsxs(CE, {
          children: [
            u.jsx(wE, {
              children: "Cash on Hand"
            }),
            o ? u.jsx($E, {
              children: n ? Yl : At(e.cash)
            }) : u.jsx(kt, {
              variant: "text",
              width: 80,
              height: 22
            })
          ]
        })
      ]
    });
  };
  var qi = {}, TE = He;
  Object.defineProperty(qi, "__esModule", {
    value: true
  });
  var ep = qi.default = void 0, kE = TE(Qe()), Xl = u;
  ep = qi.default = (0, kE.default)([
    (0, Xl.jsx)("path", {
      d: "M19.5 3.5 18 2l-1.5 1.5L15 2l-1.5 1.5L12 2l-1.5 1.5L9 2 7.5 3.5 6 2v14H3v3c0 1.66 1.34 3 3 3h12c1.66 0 3-1.34 3-3V2zM19 19c0 .55-.45 1-1 1s-1-.45-1-1v-3H8V5h11z"
    }, "0"),
    (0, Xl.jsx)("path", {
      d: "M9 7h6v2H9zm7 0h2v2h-2zm-7 3h6v2H9zm7 0h2v2h-2z"
    }, "1")
  ], "ReceiptLong");
  var Gi = {}, AE = He;
  Object.defineProperty(Gi, "__esModule", {
    value: true
  });
  var tp = Gi.default = void 0, ME = AE(Qe()), PE = u;
  tp = Gi.default = (0, ME.default)((0, PE.jsx)("path", {
    d: "M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7m0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5"
  }), "LocationOn");
  var Yi = {}, LE = He;
  Object.defineProperty(Yi, "__esModule", {
    value: true
  });
  var Xi = Yi.default = void 0, IE = LE(Qe()), NE = u;
  Xi = Yi.default = (0, IE.default)((0, NE.jsx)("path", {
    d: "M2.01 21 23 12 2.01 3 2 10l15 2-15 2z"
  }), "Send");
  const FE = X.div`
  display: flex;
  gap: 0.4rem;
  margin-bottom: 0.75rem;
  flex-shrink: 0;
`, Zl = X.button`
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.28rem;
  padding: 0.52rem 0;
  border-radius: 8px;
  border: 1px solid ${({ active: e }) => e ? "var(--bk-primary)" : "var(--bk-border)"};
  background: ${({ active: e }) => e ? "var(--bk-p-a12)" : "transparent"};
  color: ${({ active: e, isDisabled: t }) => t ? "var(--bk-disabled)" : e ? "var(--bk-primary)" : "var(--bk-muted)"};
  cursor: ${({ isDisabled: e }) => e ? "not-allowed" : "pointer"};
  font-weight: 600;
  font-size: 0.7rem;
  letter-spacing: 0.01em;
  transition: all 0.18s;

  &:hover {
    ${({ isDisabled: e, active: t }) => !e && !t && "border-color: var(--bk-primary); color: var(--bk-primary); background: var(--bk-p-a08);"}
  }
`, OE = X.button`
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.3rem;
  padding: 0.56rem 0;
  border-radius: 10px;
  border: 1px solid ${({ isDisabled: e }) => e ? "transparent" : "var(--bk-p-a30)"};
  background: ${({ isDisabled: e }) => e ? "var(--bk-p-a10)" : "var(--bk-grad)"};
  color: ${({ isDisabled: e }) => e ? "var(--bk-disabled)" : "#ffffff"};
  cursor: ${({ isDisabled: e }) => e ? "not-allowed" : "pointer"};
  font-weight: 700;
  font-size: 0.7rem;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  box-shadow: ${({ isDisabled: e }) => e ? "none" : "0 2px 8px var(--bk-p-a30)"};
  transition: all 0.18s ease;

  &:hover {
    ${({ isDisabled: e }) => !e && "background: var(--bk-grad-h); transform: translateY(-1px); box-shadow: 0 4px 14px var(--bk-p-a30);"}
  }

  &:active {
    ${({ isDisabled: e }) => !e && "transform: translateY(0); box-shadow: 0 1px 4px var(--bk-p-a30);"}
  }
`, BE = ({ disabled: e = false }) => {
    const [t, n] = so(Yd), o = yt(_o);
    return u.jsxs(FE, {
      children: [
        u.jsxs(Zl, {
          active: t === "transactions",
          isDisabled: e,
          onClick: () => !e && n("transactions"),
          children: [
            u.jsx(ep, {
              style: {
                fontSize: "0.9rem"
              }
            }),
            "History"
          ]
        }),
        u.jsxs(Zl, {
          active: t === "atm",
          isDisabled: e,
          onClick: () => !e && n("atm"),
          children: [
            u.jsx(tp, {
              style: {
                fontSize: "0.9rem"
              }
            }),
            "ATM Locator"
          ]
        }),
        u.jsxs(OE, {
          isDisabled: e,
          onClick: () => !e && o("transfer"),
          children: [
            u.jsx(Xi, {
              style: {
                fontSize: "0.85rem"
              }
            }),
            "Transfer"
          ]
        })
      ]
    });
  };
  var Zi = {}, DE = He;
  Object.defineProperty(Zi, "__esModule", {
    value: true
  });
  var ei = Zi.default = void 0, jE = DE(Qe()), zE = u;
  ei = Zi.default = (0, jE.default)((0, zE.jsx)("path", {
    d: "M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4z"
  }), "Refresh");
  var Ji = {}, VE = He;
  Object.defineProperty(Ji, "__esModule", {
    value: true
  });
  var np = Ji.default = void 0, UE = VE(Qe()), WE = u;
  np = Ji.default = (0, UE.default)((0, WE.jsx)("path", {
    d: "M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7m0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5"
  }), "Room");
  const HE = {
    deposit: {
      label: "Deposit",
      incoming: true
    },
    withdrawal: {
      label: "Withdrawal",
      incoming: false
    },
    transfer_in: {
      label: "Transfer In",
      incoming: true
    },
    transfer_out: {
      label: "Transfer Out",
      incoming: false
    }
  }, KE = (e) => new Date(e).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit"
  }), qE = X.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.575rem 0;
  border-bottom: 1px solid var(--bk-border);

  &:last-of-type {
    border-bottom: none;
  }
`, GE = X.div`
  display: flex;
  flex-direction: column;
  gap: 0.18rem;
  min-width: 0;
`, YE = X.span`
  display: inline-block;
  align-self: flex-start;
  font-size: 0.58rem;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  padding: 2px 7px;
  border-radius: 999px;
  background: ${({ incoming: e }) => e ? "var(--bk-crd-a13)" : "var(--bk-dbt-a13)"};
  color:      ${({ incoming: e }) => e ? "var(--bk-credit)" : "var(--bk-debit)"};
  border: 1px solid ${({ incoming: e }) => e ? "var(--bk-crd-a22)" : "var(--bk-dbt-a22)"};
`, XE = X.span`
  font-size: 0.73rem;
  color: var(--bk-muted);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 175px;
  display: block;
`, ZE = X.span`
  font-size: 0.6rem;
  color: var(--bk-dim);
`, JE = X.span`
  font-size: 0.86rem;
  font-weight: 700;
  white-space: nowrap;
  margin-left: 0.5rem;
  flex-shrink: 0;
  color: ${({ incoming: e }) => e ? "var(--bk-credit)" : "var(--bk-debit)"};
`, QE = ({ tx: e }) => {
    const { label: t, incoming: n } = HE[e.type];
    return u.jsxs(qE, {
      children: [
        u.jsxs(GE, {
          children: [
            u.jsx(YE, {
              incoming: n,
              children: t
            }),
            u.jsx(XE, {
              children: e.description
            }),
            u.jsx(ZE, {
              children: KE(e.timestamp)
            })
          ]
        }),
        u.jsxs(JE, {
          incoming: n,
          children: [
            n ? "+" : "\u2212",
            At(e.amount)
          ]
        })
      ]
    });
  }, eT = () => !window.invokeNative, tT = "npwd_bankingapp";
  async function Xn(e, t, n) {
    const o = {
      method: "post",
      headers: {
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: JSON.stringify(t)
    };
    return eT() && n ? n : await (await fetch(`https://${tT}/${e}`, o)).json();
  }
  let nT = 0;
  const oT = {
    bank: 24750,
    cash: 1250
  }, rT = [
    {
      id: 4,
      type: "transfer_out",
      amount: 3e3,
      description: "Transfer to Jane Smith",
      other_party: "Jane Smith",
      timestamp: new Date(Date.now() - 1728e5).toISOString()
    },
    {
      id: 3,
      type: "withdrawal",
      amount: 1e3,
      description: "Cash withdrawal",
      other_party: null,
      timestamp: new Date(Date.now() - 864e5).toISOString()
    },
    {
      id: 2,
      type: "transfer_in",
      amount: 2500,
      description: "Transfer from John Doe",
      other_party: "John Doe",
      timestamp: new Date(Date.now() - 72e5).toISOString()
    },
    {
      id: 1,
      type: "deposit",
      amount: 5e3,
      description: "Cash deposit",
      other_party: null,
      timestamp: new Date(Date.now() - 36e5).toISOString()
    }
  ], aT = [
    {
      id: 1,
      name: "Legion Square",
      area: "Downtown LS",
      distance: 42
    },
    {
      id: 2,
      name: "Pillbox Hill",
      area: "Medical Center",
      distance: 180
    },
    {
      id: 3,
      name: "Vinewood Blvd",
      area: "Vinewood",
      distance: 340
    }
  ];
  function Qi() {
    const [e, t] = so(na), n = yt(Wd), o = yt(Hd), r = yt(Kd), a = yt(qd), i = yt(Gd), s = yt(Qa), l = (h, C) => {
      const $ = ++nT;
      s((R) => [
        ...R,
        {
          id: $,
          message: h,
          type: C
        }
      ]), setTimeout(() => s((R) => R.filter((b) => b.id !== $)), 3500);
    };
    return {
      balance: e,
      fetchBalance: async () => {
        n(true);
        try {
          const h = await Xn("getBalance", {}, {
            ok: true,
            data: oT
          });
          h.ok && h.data ? t(h.data) : l(h.error ?? "Failed to load balance", "error");
        } catch {
          l("Failed to load balance", "error");
        } finally {
          n(false);
        }
      },
      fetchTransactions: async () => {
        r(true);
        try {
          const h = await Xn("getTransactions", {}, {
            ok: true,
            data: rT
          });
          h.ok && h.data ? o(h.data) : l(h.error ?? "Failed to load transactions", "error");
        } catch {
          l("Failed to load transactions", "error");
        } finally {
          r(false);
        }
      },
      fetchAtmLocations: async () => {
        i(true);
        try {
          const h = await Xn("getAtmLocations", {}, {
            ok: true,
            data: aT
          });
          h.ok && h.data ? a(h.data) : l(h.error ?? "Failed to fetch ATM locations", "error");
        } catch {
          l("Failed to fetch ATM locations", "error");
        } finally {
          i(false);
        }
      },
      transfer: async (h) => {
        try {
          const C = await Xn("transfer", h, {
            ok: true,
            data: {
              bank: Math.max(0, ((e == null ? void 0 : e.bank) ?? 0) - h.amount),
              cash: (e == null ? void 0 : e.cash) ?? 0
            }
          });
          return C.ok && C.data ? (t(C.data), l(`Transferred ${At(h.amount)}`, "success"), true) : (l(C.error ?? "Transfer failed", "error"), false);
        } catch {
          return l("Transfer failed", "error"), false;
        }
      },
      lookupPhone: async (h) => {
        try {
          const C = await Xn("getPlayerByPhone", {
            phoneNumber: h
          }, {
            ok: true,
            data: {
              name: "John Doe"
            }
          });
          return C.ok && C.data ? {
            ok: true,
            name: C.data.name
          } : {
            ok: false,
            error: C.error ?? "Player not found"
          };
        } catch {
          return {
            ok: false,
            error: "Lookup failed"
          };
        }
      },
      showToast: l,
      dismissToast: (h) => s((C) => C.filter(($) => $.id !== h))
    };
  }
  const { useEffect: iT } = await M("react"), sT = X.div`
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
`, Jl = X.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.4rem;
  flex-shrink: 0;
`, Ql = X.span`
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: var(--bk-muted);
`, ec = X.button`
  background: none;
  border: none;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  padding: 3px;
  border-radius: 6px;
  transition: all 0.2s;

  & svg {
    transition: transform 0.4s;
    ${({ spinning: e }) => e && "transform: rotate(180deg);"}
  }

  &:hover {
    color: var(--bk-alt);
    background: var(--bk-p-a08);
  }
`, tc = X.div`
  flex: 1;
  overflow-y: auto;
  min-height: 0;
`, nc = X.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem 1rem;
  gap: 0.625rem;
`, oc = X.div`
  width: 36px;
  height: 36px;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  background: var(--bk-p-a10);
`, rc = X.p`
  color: var(--bk-muted);
  font-size: 0.78rem;
  margin: 0;
  text-align: center;
`, lT = X.div`
  display: flex;
  gap: 0.5rem;
  padding-top: 0.5rem;
  margin-top: 0.375rem;
  border-top: 1px solid var(--bk-border);
  flex-shrink: 0;
`, ac = X.div`
  flex: 1;
  background: var(--bk-surface);
  border: 1px solid var(--bk-border);
  border-radius: 10px;
  padding: 0.45rem 0.625rem;
`, ic = X.div`
  font-size: 0.58rem;
  font-weight: 700;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: var(--bk-muted);
  margin-bottom: 0.1rem;
`, sc = X.div`
  font-size: 0.85rem;
  font-weight: 700;
  color: ${({ credit: e }) => e ? "var(--bk-credit)" : "var(--bk-debit)"};
`, cT = X.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.625rem 0.25rem;
  border-bottom: 1px solid var(--bk-border);

  &:last-of-type {
    border-bottom: none;
  }
`, uT = X.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
`, dT = X.div`
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: var(--bk-p-a10);
  border: 1px solid var(--bk-p-a14);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: var(--bk-primary);
`, pT = X.div`
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--bk-text);
`, fT = X.div`
  font-size: 0.66rem;
  color: var(--bk-muted);
  margin-top: 0.1rem;
`, hT = X.div`
  font-size: 0.72rem;
  font-weight: 700;
  color: ${({ near: e }) => e ? "var(--bk-credit)" : "var(--bk-muted)"};
  background: ${({ near: e }) => e ? "var(--bk-crd-a10)" : "var(--bk-p-a08)"};
  border: 1px solid ${({ near: e }) => e ? "var(--bk-crd-a22)" : "var(--bk-border)"};
  padding: 2px 8px;
  border-radius: 999px;
  flex-shrink: 0;
`, mT = () => u.jsxs("div", {
    style: {
      padding: "0.55rem 0",
      borderBottom: "1px solid var(--bk-border)"
    },
    children: [
      u.jsx(kt, {
        variant: "rounded",
        width: 66,
        height: 15,
        sx: {
          mb: 0.5
        }
      }),
      u.jsx(kt, {
        variant: "text",
        width: 140,
        height: 14
      }),
      u.jsx(kt, {
        variant: "text",
        width: 80,
        height: 12
      })
    ]
  }), gT = ({ onRefresh: e }) => {
    const t = rt(Hd), n = rt(Kd), o = rt(qd), r = rt(Gd), [a] = so(Yd), { fetchAtmLocations: i } = Qi();
    iT(() => {
      a === "atm" && o.length === 0 && i();
    }, [
      a
    ]);
    const s = t.filter((c) => c.type === "deposit" || c.type === "transfer_in").reduce((c, d) => c + d.amount, 0), l = t.filter((c) => c.type === "withdrawal" || c.type === "transfer_out").reduce((c, d) => c + d.amount, 0);
    return u.jsx(sT, {
      children: a === "transactions" ? u.jsxs(u.Fragment, {
        children: [
          u.jsxs(Jl, {
            children: [
              u.jsx(Ql, {
                children: "Recent Transactions"
              }),
              u.jsx(ec, {
                spinning: n,
                onClick: n ? void 0 : e,
                title: "Refresh",
                children: u.jsx(ei, {
                  style: {
                    fontSize: "1rem"
                  }
                })
              })
            ]
          }),
          u.jsx(tc, {
            children: n ? Array.from({
              length: 4
            }).map((c, d) => u.jsx(mT, {}, d)) : t.length === 0 ? u.jsxs(nc, {
              children: [
                u.jsx(oc, {}),
                u.jsx(rc, {
                  children: "No transactions yet"
                })
              ]
            }) : t.map((c) => u.jsx(QE, {
              tx: c
            }, c.id))
          }),
          !n && t.length > 0 && u.jsxs(lT, {
            children: [
              u.jsxs(ac, {
                children: [
                  u.jsx(ic, {
                    children: "Received"
                  }),
                  u.jsxs(sc, {
                    credit: true,
                    children: [
                      "+",
                      At(s)
                    ]
                  })
                ]
              }),
              u.jsxs(ac, {
                children: [
                  u.jsx(ic, {
                    children: "Spent"
                  }),
                  u.jsxs(sc, {
                    children: [
                      "\u2212",
                      At(l)
                    ]
                  })
                ]
              })
            ]
          })
        ]
      }) : u.jsxs(u.Fragment, {
        children: [
          u.jsxs(Jl, {
            children: [
              u.jsx(Ql, {
                children: "Nearest ATMs"
              }),
              u.jsx(ec, {
                onClick: r ? void 0 : i,
                title: "Refresh distances",
                children: u.jsx(ei, {
                  style: {
                    fontSize: "1rem"
                  }
                })
              })
            ]
          }),
          u.jsx(tc, {
            children: r ? Array.from({
              length: 5
            }).map((c, d) => u.jsxs("div", {
              style: {
                padding: "0.625rem 0",
                borderBottom: "1px solid var(--bk-border)",
                display: "flex",
                alignItems: "center",
                gap: "0.5rem"
              },
              children: [
                u.jsx(kt, {
                  variant: "rounded",
                  width: 28,
                  height: 28,
                  sx: {
                    borderRadius: "8px",
                    flexShrink: 0
                  }
                }),
                u.jsxs("div", {
                  style: {
                    flex: 1
                  },
                  children: [
                    u.jsx(kt, {
                      variant: "text",
                      width: 120,
                      height: 16
                    }),
                    u.jsx(kt, {
                      variant: "text",
                      width: 80,
                      height: 13
                    })
                  ]
                }),
                u.jsx(kt, {
                  variant: "rounded",
                  width: 55,
                  height: 22,
                  sx: {
                    borderRadius: "999px"
                  }
                })
              ]
            }, d)) : o.length === 0 ? u.jsxs(nc, {
              children: [
                u.jsx(oc, {}),
                u.jsx(rc, {
                  children: "No ATMs found"
                })
              ]
            }) : o.map((c) => u.jsxs(cT, {
              children: [
                u.jsxs(uT, {
                  children: [
                    u.jsx(dT, {
                      children: u.jsx(np, {
                        style: {
                          fontSize: "0.9rem"
                        }
                      })
                    }),
                    u.jsxs("div", {
                      children: [
                        u.jsx(pT, {
                          children: c.name
                        }),
                        u.jsx(fT, {
                          children: c.area
                        })
                      ]
                    })
                  ]
                }),
                u.jsxs(hT, {
                  near: c.distance <= 100,
                  children: [
                    c.distance,
                    "m"
                  ]
                })
              ]
            }, c.id))
          })
        ]
      })
    });
  }, { useState: tn } = await M("react"), vT = [
    "Recipient",
    "Amount",
    "Confirm"
  ], bT = {
    phone: 0,
    amount: 1,
    confirm: 2
  }, Pa = {
    borderColor: "var(--bk-border)",
    color: "var(--bk-muted)",
    "&:hover": {
      borderColor: "var(--bk-alt)",
      color: "var(--bk-alt)",
      bgcolor: "var(--bk-p-a06)"
    }
  }, yT = () => {
    const e = yt(_o), { balance: t, transfer: n, lookupPhone: o, fetchTransactions: r } = Qi(), [a, i] = tn("phone"), [s, l] = tn(""), [c, d] = tn(""), [p, m] = tn(""), [v, g] = tn(false), [h, C] = tn(false), [$, R] = tn(""), b = parseInt(c, 10), y = (t == null ? void 0 : t.bank) ?? 0, E = !isNaN(b) && b > 0 && b <= y, w = c !== "" && !isNaN(b) && b > y, T = () => {
      h || v || e(null);
    }, I = () => {
      s.trim() && (R(""), i("amount"));
    }, V = async () => {
      if (!E)
        return;
      g(true), R("");
      const F = await o(s.trim());
      g(false), F.ok && F.name ? (m(F.name), i("confirm")) : R(F.error ?? "Player not found");
    }, P = async () => {
      C(true);
      const F = await n({
        phoneNumber: s.trim(),
        amount: b
      });
      F && await r(), C(false), F && e(null);
    }, U = (F) => {
      F.key === "Enter" && (a === "phone" && I(), a === "amount" && V(), a === "confirm" && P());
    };
    return u.jsxs(x0, {
      open: true,
      onClose: T,
      fullWidth: true,
      maxWidth: "xs",
      children: [
        u.jsx(V0, {
          sx: {
            pb: 1
          },
          children: "Transfer Funds"
        }),
        u.jsxs(O0, {
          children: [
            u.jsx(qx, {
              activeStep: bT[a],
              sx: {
                mb: 2.5,
                mt: 0.5
              },
              alternativeLabel: true,
              children: vT.map((F) => u.jsx(hx, {
                children: u.jsx(Lx, {
                  children: F
                })
              }, F))
            }),
            a === "phone" && u.jsx(Cl, {
              autoFocus: true,
              label: "Recipient Phone Number",
              fullWidth: true,
              value: s,
              onChange: (F) => {
                l(F.target.value), R("");
              },
              onKeyDown: U,
              margin: "dense",
              inputMode: "tel",
              placeholder: "e.g. 555-1234",
              helperText: "Enter the recipient's phone number"
            }),
            a === "amount" && u.jsxs(u.Fragment, {
              children: [
                u.jsx(Cl, {
                  autoFocus: true,
                  label: "Amount",
                  fullWidth: true,
                  value: c,
                  onChange: (F) => {
                    d(F.target.value.replace(/\D/g, "")), R("");
                  },
                  onKeyDown: U,
                  margin: "dense",
                  inputMode: "numeric",
                  error: w,
                  helperText: w ? `Maximum is ${At(y)}` : t !== null ? `Available bank: ${At(y)}` : " ",
                  InputProps: {
                    startAdornment: u.jsx(Py, {
                      position: "start",
                      children: "$"
                    })
                  }
                }),
                $ && u.jsx(Rv, {
                  severity: "error",
                  sx: {
                    mt: 1,
                    py: 0.25
                  },
                  children: $
                })
              ]
            }),
            a === "confirm" && u.jsxs(ua, {
              py: 0.5,
              children: [
                u.jsxs(er, {
                  variant: "body1",
                  gutterBottom: true,
                  sx: {
                    color: "var(--bk-text)"
                  },
                  children: [
                    "Send",
                    " ",
                    u.jsx(ua, {
                      component: "span",
                      fontWeight: 700,
                      sx: {
                        color: "var(--bk-primary)"
                      },
                      children: At(b)
                    }),
                    " ",
                    "to",
                    " ",
                    u.jsx(ua, {
                      component: "span",
                      fontWeight: 700,
                      sx: {
                        color: "var(--bk-text)"
                      },
                      children: p
                    }),
                    "?"
                  ]
                }),
                u.jsx(er, {
                  variant: "caption",
                  sx: {
                    color: "var(--bk-muted)"
                  },
                  children: "This amount will be deducted from your bank balance. Transfers cannot be reversed."
                })
              ]
            })
          ]
        }),
        u.jsxs(E0, {
          sx: {
            px: 2.5,
            pb: 2,
            gap: 0.75
          },
          children: [
            a === "phone" && u.jsxs(u.Fragment, {
              children: [
                u.jsx(yn, {
                  onClick: T,
                  variant: "outlined",
                  sx: Pa,
                  children: "Cancel"
                }),
                u.jsx(yn, {
                  variant: "contained",
                  color: "primary",
                  onClick: I,
                  disabled: !s.trim(),
                  children: "Next"
                })
              ]
            }),
            a === "amount" && u.jsxs(u.Fragment, {
              children: [
                u.jsx(yn, {
                  onClick: () => {
                    i("phone"), R("");
                  },
                  disabled: v,
                  variant: "outlined",
                  sx: Pa,
                  children: "Back"
                }),
                u.jsx(yn, {
                  variant: "contained",
                  color: "primary",
                  onClick: V,
                  disabled: !E || v,
                  startIcon: v ? u.jsx(Qs, {
                    size: 16,
                    color: "inherit"
                  }) : void 0,
                  children: v ? "Looking up\u2026" : "Next"
                })
              ]
            }),
            a === "confirm" && u.jsxs(u.Fragment, {
              children: [
                u.jsx(yn, {
                  onClick: () => i("amount"),
                  disabled: h,
                  variant: "outlined",
                  sx: Pa,
                  children: "Back"
                }),
                u.jsx(yn, {
                  variant: "contained",
                  color: "primary",
                  onClick: P,
                  disabled: h,
                  startIcon: h ? u.jsx(Qs, {
                    size: 16,
                    color: "inherit"
                  }) : u.jsx(Xi, {}),
                  children: h ? "Sending\u2026" : "Send Money"
                })
              ]
            })
          ]
        })
      ]
    });
  };
  var es = {}, xT = He;
  Object.defineProperty(es, "__esModule", {
    value: true
  });
  var ts = es.default = void 0, ST = xT(Qe()), RT = u;
  ts = es.default = (0, ST.default)((0, RT.jsx)("path", {
    d: "M19 6.41 17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"
  }), "Close");
  var ns = {}, _T = He;
  Object.defineProperty(ns, "__esModule", {
    value: true
  });
  var op = ns.default = void 0, CT = _T(Qe()), wT = u;
  op = ns.default = (0, CT.default)((0, wT.jsx)("path", {
    d: "M12 2C6.49 2 2 6.49 2 12s4.49 10 10 10c1.38 0 2.5-1.12 2.5-2.5 0-.61-.23-1.2-.64-1.67-.08-.1-.13-.21-.13-.33 0-.28.22-.5.5-.5H16c3.31 0 6-2.69 6-6 0-4.96-4.49-9-10-9m5.5 11c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5m-3-4c-.83 0-1.5-.67-1.5-1.5S13.67 6 14.5 6s1.5.67 1.5 1.5S15.33 9 14.5 9M5 11.5c0-.83.67-1.5 1.5-1.5s1.5.67 1.5 1.5S7.33 13 6.5 13 5 12.33 5 11.5m6-4c0 .83-.67 1.5-1.5 1.5S8 8.33 8 7.5 8.67 6 9.5 6s1.5.67 1.5 1.5"
  }), "Palette");
  var os = {}, $T = He;
  Object.defineProperty(os, "__esModule", {
    value: true
  });
  var rp = os.default = void 0, ET = $T(Qe()), TT = u;
  rp = os.default = (0, ET.default)((0, TT.jsx)("path", {
    d: "M12 7c2.76 0 5 2.24 5 5 0 .65-.13 1.26-.36 1.83l2.92 2.92c1.51-1.26 2.7-2.89 3.43-4.75-1.73-4.39-6-7.5-11-7.5-1.4 0-2.74.25-3.98.7l2.16 2.16C10.74 7.13 11.35 7 12 7M2 4.27l2.28 2.28.46.46C3.08 8.3 1.78 10.02 1 12c1.73 4.39 6 7.5 11 7.5 1.55 0 3.03-.3 4.38-.84l.42.42L19.73 22 21 20.73 3.27 3zM7.53 9.8l1.55 1.55c-.05.21-.08.43-.08.65 0 1.66 1.34 3 3 3 .22 0 .44-.03.65-.08l1.55 1.55c-.67.33-1.41.53-2.2.53-2.76 0-5-2.24-5-5 0-.79.2-1.53.53-2.2m4.31-.78 3.15 3.15.02-.16c0-1.66-1.34-3-3-3z"
  }), "VisibilityOff");
  var rs = {}, kT = He;
  Object.defineProperty(rs, "__esModule", {
    value: true
  });
  var ap = rs.default = void 0, AT = kT(Qe()), MT = u;
  ap = rs.default = (0, AT.default)((0, MT.jsx)("path", {
    d: "M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5M12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5m0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3"
  }), "Visibility");
  const PT = X.div`
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.55);
  z-index: 100;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
`, LT = X.div`
  background: var(--bk-surface);
  border-top: 1px solid var(--bk-border);
  border-radius: 18px 18px 0 0;
  padding: 0 1rem 1.25rem;
  box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.4);
`, IT = X.div`
  width: 36px;
  height: 4px;
  background: var(--bk-border);
  border-radius: 2px;
  margin: 0.65rem auto 1rem;
`, NT = X.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.25rem;
`, FT = X.span`
  font-weight: 700;
  font-size: 0.88rem;
  color: var(--bk-text);
  letter-spacing: 0.01em;
`, OT = X.button`
  background: none;
  border: none;
  padding: 4px;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  border-radius: 6px;
  transition: all 0.15s;
  &:hover { color: var(--bk-text); background: var(--bk-p-a10); }
`, lc = X.div`
  margin-bottom: 1.1rem;
`, cc = X.div`
  font-size: 0.6rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--bk-muted);
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.35rem;
`, BT = X.div`
  display: flex;
  gap: 0.5rem;
`, uc = X.button`
  flex: 1;
  padding: 0.6rem 0.5rem;
  border-radius: 10px;
  border: 2px solid ${({ active: e, accent: t }) => e ? t : "var(--bk-border)"};
  background: ${({ active: e, accent: t }) => e ? `${t}18` : "transparent"};
  color: ${({ active: e, accent: t }) => e ? t : "var(--bk-muted)"};
  cursor: pointer;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.02em;
  transition: all 0.18s;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.3rem;

  &:hover {
    border-color: ${({ accent: e }) => e};
    color: ${({ accent: e }) => e};
    background: ${({ accent: e }) => `${e}10`};
  }
`, dc = X.div`
  width: 28px;
  height: 10px;
  border-radius: 5px;
  background: ${({ gradient: e }) => e};
`, DT = X.button`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: var(--bk-bg);
  border: 1px solid var(--bk-border);
  border-radius: 10px;
  padding: 0.65rem 0.875rem;
  cursor: pointer;
  transition: border-color 0.18s;
  &:hover { border-color: var(--bk-primary); }
`, jT = X.span`
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--bk-text);
`, zT = X.div`
  width: 36px;
  height: 20px;
  border-radius: 10px;
  background: ${({ on: e }) => e ? "var(--bk-grad)" : "var(--bk-border)"};
  position: relative;
  transition: background 0.2s;
  flex-shrink: 0;

  &::after {
    content: '';
    position: absolute;
    top: 3px;
    left: ${({ on: e }) => e ? "19px" : "3px"};
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: #fff;
    transition: left 0.2s;
  }
`, VT = () => {
    const e = yt(_o), [t, n] = so(Ui), [o, r] = so(Ud);
    return u.jsx(PT, {
      onClick: () => e(null),
      children: u.jsxs(LT, {
        onClick: (a) => a.stopPropagation(),
        children: [
          u.jsx(IT, {}),
          u.jsxs(NT, {
            children: [
              u.jsx(FT, {
                children: "Settings"
              }),
              u.jsx(OT, {
                onClick: () => e(null),
                children: u.jsx(ts, {
                  sx: {
                    fontSize: "1rem"
                  }
                })
              })
            ]
          }),
          u.jsxs(lc, {
            children: [
              u.jsxs(cc, {
                children: [
                  u.jsx(op, {
                    sx: {
                      fontSize: "0.72rem"
                    }
                  }),
                  "Theme"
                ]
              }),
              u.jsxs(BT, {
                children: [
                  u.jsxs(uc, {
                    active: t === "bhrp",
                    accent: "#F07B1F",
                    onClick: () => n("bhrp"),
                    children: [
                      u.jsx(dc, {
                        gradient: "linear-gradient(135deg, #F07B1F, #F5A623)"
                      }),
                      "BHRP"
                    ]
                  }),
                  u.jsxs(uc, {
                    active: t === "default",
                    accent: "#1F6FEB",
                    onClick: () => n("default"),
                    children: [
                      u.jsx(dc, {
                        gradient: "linear-gradient(135deg, #0A2463, #1F6FEB)"
                      }),
                      "Navy Blue"
                    ]
                  })
                ]
              })
            ]
          }),
          u.jsxs(lc, {
            children: [
              u.jsxs(cc, {
                children: [
                  o ? u.jsx(rp, {
                    sx: {
                      fontSize: "0.72rem"
                    }
                  }) : u.jsx(ap, {
                    sx: {
                      fontSize: "0.72rem"
                    }
                  }),
                  "Privacy"
                ]
              }),
              u.jsxs(DT, {
                onClick: () => r((a) => !a),
                children: [
                  u.jsx(jT, {
                    children: "Hide Balance"
                  }),
                  u.jsx(zT, {
                    on: o
                  })
                ]
              })
            ]
          })
        ]
      })
    });
  };
  var as = {}, UT = He;
  Object.defineProperty(as, "__esModule", {
    value: true
  });
  var ip = as.default = void 0, WT = UT(Qe()), HT = u;
  ip = as.default = (0, WT.default)((0, HT.jsx)("path", {
    d: "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2m-2 15-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8z"
  }), "CheckCircle");
  var is = {}, KT = He;
  Object.defineProperty(is, "__esModule", {
    value: true
  });
  var sp = is.default = void 0, qT = KT(Qe()), GT = u;
  sp = is.default = (0, qT.default)((0, GT.jsx)("path", {
    d: "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2m1 15h-2v-2h2zm0-4h-2V7h2z"
  }), "Error");
  const YT = X.div`
  position: absolute;
  top: calc(3.5rem + 0.5rem);
  left: 0.625rem;
  right: 0.625rem;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  pointer-events: none;
`, XT = X.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.625rem 0.5rem 0.75rem;
  border-radius: 8px;
  font-size: 0.78rem;
  font-weight: 500;
  color: var(--bk-text);
  pointer-events: all;
  background: var(--bk-surface);
  border: 1px solid ${({ toastType: e }) => e === "success" ? "var(--bk-crd-a30)" : "var(--bk-dbt-a22)"};
  box-shadow: 0 4px 16px rgba(0,0,0,0.4);
`, ZT = X.span`
  color: ${({ toastType: e }) => e === "success" ? "var(--bk-credit)" : "var(--bk-debit)"};
  display: flex;
  align-items: center;
  flex-shrink: 0;
`, JT = X.span`
  flex: 1;
`, QT = X.button`
  background: none;
  border: none;
  cursor: pointer;
  color: var(--bk-muted);
  display: flex;
  align-items: center;
  padding: 2px;
  border-radius: 4px;
  transition: all 0.15s;
  flex-shrink: 0;

  &:hover {
    color: var(--bk-text);
  }
`, ek = () => {
    const e = rt(Qa), t = yt(Qa), n = (o) => t((r) => r.filter((a) => a.id !== o));
    return e.length === 0 ? null : u.jsx(YT, {
      children: e.map((o) => u.jsx(wg, {
        in: true,
        appear: true,
        timeout: 200,
        children: u.jsxs(XT, {
          toastType: o.type,
          children: [
            u.jsx(ZT, {
              toastType: o.type,
              children: o.type === "success" ? u.jsx(ip, {
                style: {
                  fontSize: "1rem"
                }
              }) : u.jsx(sp, {
                style: {
                  fontSize: "1rem"
                }
              })
            }),
            u.jsx(JT, {
              children: o.message
            }),
            u.jsx(QT, {
              onClick: () => n(o.id),
              children: u.jsx(ts, {
                style: {
                  fontSize: "0.85rem"
                }
              })
            })
          ]
        })
      }, o.id))
    });
  }, { useEffect: pc, useRef: tk } = await M("react"), nk = (e, t, n) => {
    const o = tk();
    pc(() => {
      o.current = n;
    }, [
      n
    ]), pc(() => {
      const r = (a) => {
        const { method: i, app: s, data: l } = a.data;
        o.current && o.current.call && i === t && s === e && o.current(l);
      };
      return window.addEventListener("message", r), () => window.removeEventListener("message", r);
    }, [
      t,
      e
    ]);
  }, ok = {
    bhrp: {
      "--bk-bg": "#1C1208",
      "--bk-surface": "#2A1A0A",
      "--bk-border": "#3D2510",
      "--bk-primary": "#F07B1F",
      "--bk-alt": "#F5A623",
      "--bk-text": "#FFF5E6",
      "--bk-muted": "#A87E52",
      "--bk-credit": "#F5A623",
      "--bk-debit": "#E03E2D",
      "--bk-disabled": "#4A3020",
      "--bk-dim": "#5a3a1a",
      "--bk-grad": "linear-gradient(135deg, #F07B1F, #F5A623)",
      "--bk-grad-h": "linear-gradient(135deg, #f28b35, #f7b74a)",
      "--bk-grad-text": "linear-gradient(135deg, #F07B1F 0%, #F5A623 100%)",
      "--bk-p-a06": "rgba(240,123,31,0.06)",
      "--bk-p-a08": "rgba(240,123,31,0.08)",
      "--bk-p-a10": "rgba(240,123,31,0.10)",
      "--bk-p-a12": "rgba(240,123,31,0.12)",
      "--bk-p-a14": "rgba(240,123,31,0.14)",
      "--bk-p-a30": "rgba(240,123,31,0.30)",
      "--bk-crd-a10": "rgba(245,166,35,0.10)",
      "--bk-crd-a13": "rgba(245,166,35,0.13)",
      "--bk-crd-a15": "rgba(245,166,35,0.15)",
      "--bk-crd-a22": "rgba(245,166,35,0.22)",
      "--bk-crd-a30": "rgba(245,166,35,0.30)",
      "--bk-dbt-a10": "rgba(224,62,45,0.10)",
      "--bk-dbt-a13": "rgba(224,62,45,0.13)",
      "--bk-dbt-a15": "rgba(224,62,45,0.15)",
      "--bk-dbt-a22": "rgba(224,62,45,0.22)",
      "--bk-dbt-a25": "rgba(224,62,45,0.25)"
    },
    default: {
      "--bk-bg": "#0D1117",
      "--bk-surface": "#161B22",
      "--bk-border": "#21262D",
      "--bk-primary": "#58A6FF",
      "--bk-alt": "#79C0FF",
      "--bk-text": "#E6EDF3",
      "--bk-muted": "#8B949E",
      "--bk-credit": "#3FB950",
      "--bk-debit": "#F85149",
      "--bk-disabled": "#30363D",
      "--bk-dim": "#484F58",
      "--bk-grad": "linear-gradient(135deg, #0A2463, #1F6FEB)",
      "--bk-grad-h": "linear-gradient(135deg, #1F6FEB, #58A6FF)",
      "--bk-grad-text": "linear-gradient(135deg, #58A6FF 0%, #79C0FF 100%)",
      "--bk-p-a06": "rgba(88,166,255,0.06)",
      "--bk-p-a08": "rgba(88,166,255,0.08)",
      "--bk-p-a10": "rgba(88,166,255,0.10)",
      "--bk-p-a12": "rgba(88,166,255,0.12)",
      "--bk-p-a14": "rgba(88,166,255,0.14)",
      "--bk-p-a30": "rgba(88,166,255,0.30)",
      "--bk-crd-a10": "rgba(63,185,80,0.10)",
      "--bk-crd-a13": "rgba(63,185,80,0.13)",
      "--bk-crd-a15": "rgba(63,185,80,0.15)",
      "--bk-crd-a22": "rgba(63,185,80,0.22)",
      "--bk-crd-a30": "rgba(63,185,80,0.30)",
      "--bk-dbt-a10": "rgba(248,81,73,0.10)",
      "--bk-dbt-a13": "rgba(248,81,73,0.13)",
      "--bk-dbt-a15": "rgba(248,81,73,0.15)",
      "--bk-dbt-a22": "rgba(248,81,73,0.22)",
      "--bk-dbt-a25": "rgba(248,81,73,0.25)"
    }
  };
  const { useEffect: rk } = await M("react"), ak = X.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  max-height: 100%;
  position: relative;
  overflow: hidden;
  background-color: var(--bk-bg);
`, ik = X.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  padding: 0.875rem;
  max-height: calc(100% - ${Qd});
  overflow: hidden;
`, sk = X.div`
  background: linear-gradient(135deg, rgba(224,62,45,0.95), rgba(176,45,31,0.95));
  color: #FFF5E6;
  padding: 0.45rem 1rem;
  text-align: center;
  font-weight: 700;
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  border-bottom: 1px solid var(--bk-debit);
  flex-shrink: 0;
`;
  function lk() {
    const e = rt(_o), t = rt(na), n = rt(Ui), { fetchBalance: o, fetchTransactions: r } = Qi(), a = (t == null ? void 0 : t.isFrozen) ?? false;
    return rk(() => {
      o(), r();
    }, []), nk("BANKING_APP", "incomingTransfer", (i) => {
      o(), r();
    }), u.jsxs(ak, {
      style: ok[n],
      children: [
        u.jsx(vE, {}),
        a && u.jsx(sk, {
          children: "\u26A0 Account Frozen \u2014 Contact Support"
        }),
        u.jsx(ek, {}),
        u.jsxs(ik, {
          children: [
            u.jsx(EE, {}),
            u.jsx(BE, {
              disabled: a
            }),
            u.jsx(gT, {
              onRefresh: () => {
                o(), r();
              }
            })
          ]
        }),
        e === "transfer" && u.jsx(yT, {}),
        e === "settings" && u.jsx(VT, {})
      ]
    });
  }
  function ck(e) {
    return u.jsx(mc, {
      injectFirst: true,
      children: u.jsx(Z$, {
        mode: e.theme.palette.mode,
        children: u.jsx(lk, {})
      })
    });
  }
  gk = function(e) {
    return u.jsx(K$, {
      override: true,
      children: u.jsx(ck, {
        ...e
      })
    }, "bankingapp");
  };
});
export {
  gk as W,
  __tla,
  X as s
};
