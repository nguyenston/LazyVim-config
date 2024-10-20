local ls = require("luasnip")

local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local snippet_utils = require("util.snippet_utils")(vim.fn["vimtex#syntax#in_mathzone"])
local s = snippet_utils.snippet
local ms = snippet_utils.math_snippet
local ts = snippet_utils.text_snippet
local get_match = snippet_utils.get_match
local get_visual = snippet_utils.get_visual
local pfx_cmd = snippet_utils.postfix_command

return {}, {
  -- greek letters
  ms(";al", t("\\alpha")),
  ms(";be", t("\\beta")),
  ms(";ga", t("\\gamma")),
  ms(";Ga", t("\\Gamma")),
  ms(";om", t("\\omega")),
  ms(";Om", t("\\Omega")),
  ms(";si", t("\\sigma")),
  ms(";Si", t("\\Sigma")),
  ms(";th", t("\\theta")),
  ms(";Th", t("\\Theta")),
  ms(";de", t("\\delta")),
  ms(";De", t("\\Delta")),
  ms(";pi", t("\\pi")),
  ms(";Pi", t("\\Pi")),
  ms(";ph", t("\\phi")),
  ms(";Ph", t("\\Phi")),
  ms(";xi", t("\\xi")),
  ms(";Xi", t("\\Xi")),
  ms(";ps", t("\\psi")),
  ms(";Ps", t("\\Psi")),
  ms(";la", t("\\lambda")),
  ms(";La", t("\\Lambda")),
  ms(";rh", t("\\rho")),
  ms(";ep", t("\\epsilon")),
  ms("\\epsilonva", t("\\varepsilon")),
  ms(";mu", t("\\mu")),
  ms(";nu", t("\\nu")),
  ms(";et", t("\\eta")),
  ms(";ta", t("\\tau")),

  -- sub/super-script
  ms("^", fmta("^{<>}", i(1))),
  ms("rd", fmta("^{<>}", i(1))),
  ms("_", fmta("_{<>}", i(1))),
  ms("uu", fmta("_{<>}", i(1))),

  -- overhead scripts
  pfx_cmd("hat", { cmd = "hat" }),
  pfx_cmd("dot", { cmd = "dot" }),
  pfx_cmd("ddo", { cmd = "ddot" }),
  pfx_cmd("bar", { cmd = "overline" }),
  pfx_cmd("til", { cmd = "tilde" }),
  pfx_cmd("vm", { cmd = "vm" }), -- vector or matrix, basically bold upright
  pfx_cmd("bm", { cmd = "bm" }), -- bold but not upright
  pfx_cmd("und", { cmd = "underline" }),

  -- operations
  ms("tt", fmta("\\text{<>}", d(1, get_visual))),
  ms("srt", fmta("\\sqrt{<>}", d(1, get_visual))),
  ms("ff", fmta("\\frac{<>}{<>}", { i(1), i(2) })),
  ms("ee", fmta("e^{<>}", i(1))),
  ms("mrm", fmta("\\mathrm{<>}", d(1, get_visual))),
  ms("lim", c(1, { sn(nil, fmta("\\lim_{<>\\to<>}", { i(1, "n"), i(2, "\\infty") })), t("\\lim") })),
  ms("linf", c(1, { sn(nil, fmta("\\liminf_{<>\\to<>}", { i(1, "n"), i(2, "\\infty") })), t("\\liminf") })),
  ms("lsup", c(1, { sn(nil, fmta("\\limsup_{<>\\to<>}", { i(1, "n"), i(2, "\\infty") })), t("\\limsup") })),
  ms("int", c(1, { t("\\int"), sn(nil, fmta("\\int^{<>}_{<>}", { i(2, "\\infty"), i(1, "-\\infty") })) })),
  ms("det", t("\\det")),
  ms("tp", t("\\transpose")),
  ms("dag", t("\\dagg")),
  ms("inv", t("\\inv")),
  ms("tr", t("\\trace")),
  ms("idd", t("\\identity")),
  ms("mop", fmta("\\mop{<>}", d(1, get_visual))),

  ms("ubra", fmta("\\underbrace{<>}", { d(1, get_visual) })),
  ms("uset", fmta("\\underset{<>}{<>}", { i(2), d(1, get_visual) })),
  ms("canc", fmta("\\cancel{<>}", d(1, get_visual))),
  ms("canto", fmta("\\cancelto{<>}{<>}", { i(2), d(1, get_visual) })),

  -- symbols
  ms("oo", t("\\infty")),
  ms("sum", t("\\sum")),
  ms("prod", t("\\prod")),
  ms("pm", t("\\pm")),
  ms("mp", t("\\mp")),
  ms("...", t("\\dots")),
  ms("lrar", t("\\leftrightarrow")),
  ms("to", t("\\to")),
  ms("\\tom", t("\\mapsto")),
  ms("then", t("\\implies")),
  ms("when", t("\\impliedby")),
  ms("iff", t("\\iff")),
  ms("setminus", t("\\setminus")),
  ms("and", t("\\wedge")),
  ms("cap", t("\\cap")),
  ms("\\capb", t("\\bigcap")),
  ms("orr", t("\\vee")),
  ms("cup", t("\\cup")),
  ms("\\cupb", t("\\bigcup")),
  ms("inn", t("\\in")),
  ms("ss", t("\\subset")),
  ms("\\subsete", t("\\subseteq")),
  ms("===", t("\\equiv")),
  ms("neq", t("\\neq")),
  ms("geq", t("\\geq")),
  ms("leq", t("\\leq")),
  ms(">>", t("\\gg")),
  ms("<<", t("\\ll")),
  ms("xx", t("\\times")),
  ms("**", t("\\blank")),
  ms("\\blank*", t("\\cdot")),
  ms("sim", t("\\sim")),
  ms("\\simidd", t("\\overset{\\text{i.d.d.}}{\\sim}")),
  ms("prox", t("\\approx")),
  ms("nab", t("\\nabla")),
  ms("xis", t("\\exist")),
  ms("fral", t("\\forall")),
  ms("par", t("\\partial")),
  ms("ell", t("\\ell")),
  ms("hbar", t("\\hbar")),
  ms("pto", t("\\propto")),

  -- Caligraphy/Blackboard style
  pfx_cmd("cal", { cmd = "mathcal", patterns = "%u" }),
  pfx_cmd("bb", { cmd = "mathbb", patterns = "%w" }),
  ms("EE", t("\\mathbb{E}")),
  ms("RR", t("\\mathbb{R}")),
  ms("NN", t("\\mathbb{N}")),

  -- Surround
  ms("lrp", fmta("\\lrp{<>}", d(1, get_visual))),
  ms("lrb", fmta("\\lrb{<>}", d(1, get_visual))),
  ms("lrc", fmta("\\lrc{<>}", d(1, get_visual))),
  ms("lran", fmta("\\lra{<>}", d(1, get_visual))),
  ms("norm", fmta("\\norm{<>}", d(1, get_visual))),
  ms("abs", fmta("\\abs{<>}", d(1, get_visual))),

  -- stylua: ignore start

  -- Inline math
  ts({ trig = "mk", wordTrig = true },
    fmta("<>$<>$", {
        f(get_match(1)),
        d(1, get_visual)
      })),

  -- Display math
  ts({ trig = "dm", wordTrig = true },
    fmta([[
        \[
          <>
        \]
      ]], d(1, get_visual))),

  -- Environment block
  s(":beg",
    fmta([[
        \begin{<>}
          <>
        \end{<>}
      ]], {
        i(1),
        i(0),
        rep(1)
      })),

  -- Align env
  ts(":ali",
    fmta([[
        \begin{align*}
          <>
        \end{align*}
      ]], i(0))),

  ms(":ali",
    fmta([[
        \begin{aligned}
          <>
        \end{aligned}
      ]], i(0))),

  -- Equation env
  ts(":equ",
    fmta([[
        \begin{equation}
          <>
        \end{equation}
      ]], i(0))),

  -- itemize
  ts(":ite",
    fmta([[
        \begin{itemize}
          <>
        \end{itemize}
      ]], i(0))),

  -- enumerate
  ts(":enu",
    fmta([[
        \begin{enumerate}
          <>
        \end{enumerate}
      ]], i(0))),
  -- stylua: ignore end
}
