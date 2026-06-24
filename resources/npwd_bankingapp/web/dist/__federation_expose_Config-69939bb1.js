import { W as o, __tla as __tla_0 } from "./App-0006d0cc.js";
import { j as n } from "./jsx-runtime-dc228b70.js";
let x, i;
let __tla = Promise.all([
  (() => {
    try {
      return __tla_0;
    } catch {
    }
  })()
]).then(async () => {
  let e;
  e = () => n.jsxs("svg", {
    xmlns: "http://www.w3.org/2000/svg",
    width: "24",
    height: "24",
    fill: "none",
    viewBox: "0 0 24 24",
    stroke: "currentColor",
    strokeWidth: 2,
    children: [
      n.jsx("line", {
        x1: "6",
        y1: "10",
        x2: "6",
        y2: "17",
        strokeLinecap: "round"
      }),
      n.jsx("line", {
        x1: "10",
        y1: "10",
        x2: "10",
        y2: "17",
        strokeLinecap: "round"
      }),
      n.jsx("line", {
        x1: "14",
        y1: "10",
        x2: "14",
        y2: "17",
        strokeLinecap: "round"
      }),
      n.jsx("line", {
        x1: "18",
        y1: "10",
        x2: "18",
        y2: "17",
        strokeLinecap: "round"
      }),
      n.jsx("line", {
        x1: "4",
        y1: "17",
        x2: "20",
        y2: "17",
        strokeLinecap: "round"
      }),
      n.jsx("line", {
        x1: "3",
        y1: "20",
        x2: "21",
        y2: "20",
        strokeLinecap: "round",
        strokeWidth: 2.5
      }),
      n.jsx("polyline", {
        points: "2,10 12,3 22,10",
        strokeLinecap: "round",
        strokeLinejoin: "round"
      }),
      n.jsx("line", {
        x1: "4",
        y1: "10",
        x2: "20",
        y2: "10",
        strokeLinecap: "round"
      })
    ]
  });
  i = "/bankingapp";
  x = (r) => ({
    id: "BANKING_APP",
    path: i,
    nameLocale: "Banking App",
    color: "#E2F4ED",
    backgroundColor: "#0D3D2B",
    icon: e,
    app: o
  });
});
export {
  __tla,
  x as default,
  i as path
};
