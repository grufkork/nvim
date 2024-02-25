local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("tex", {
    s("bgn", 
    {
        t'\\begin{', 
        i(1), 
        t({'}', ''}),
        t'\t',
        i(0),
        t({'', '\\end{'}),
        extras.rep(1), t'}'
    }),

    postfix(
    "hat",
    {
        f(function(_, parent) 
            return "\\hat{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
        end, 
        {}),

    }),
    postfix(
    ".bar",
    {
        f(function(_, parent) 
            return "\\bar{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
        end, 
        {}),

    }),
    s("mm", 
    {
        t'$', 
        i(1), 
        t'$'
    }),
    s("eq", 
    {
        t({'\\begin{equation}', '\t'}),
        i(0),
        t({'', '\\end{equation}'}),
    }),
    s("->",
    {
        t'\\to'
    }),

    s("/",{
        t'\\frac{',
        i(1),
        t'}{',
        i(2),
        t'}',
        i(0)
    }),

    s("part",{
        t'\\frac{\\partial ',
        i(1),
        t'}{\\partial ',
        i(2),
        t'}',
        i(0)
    }),

    s("fun",{
        t 'f: \\mathbb{R}^',
        i(1),
        t '\\to \\mathbb{R}'

    }),

    s("ln",
    {t('\\\\')}),

    s("dim", {
        t '\\mathbb{R}^', i(1)
    }),

    s("par", 
    {
        t'\\paragraph{',
        i(1),
        t '}', i(0)
    }),

    s("lim", 
    {
        t'\\lim _{',
        i(1),
        t '\\to',
        i(2),
        t '}', i(0)
    }),

})
