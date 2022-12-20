-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md

return {
  s("isn2", {
    isn(1, t({ "//This is", "A multiline", "comment" }), "$PARENT_INDENT//")
  }),

  -- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
  -- \item as necessary by utilizing a choiceNode.
  s("usep", {
    isn(1,
      {
        t({ "use({", "  '" }),
        i(1, { "repo/name" }),
        t({ "',", "" }),
        c(2, { sn(1, { t({ "  event = '" }), i(1, { "VimEnter" }), t({ "', ", "" }) }), t({ "" }) }),
        c(3,
          {
            f(function(args)
              return "  config = function() require('plugin_config/"
                  .. string.gsub(args[1][1], "(.*/)(.*)", "%2")
                  .. "') end"
            end, { 1 }),
            t({ "" }),
          }
        ),
        t({ "})" }),
      },
      "$PARENT_INDENT"
    )
  }),
  s("luasnip", t(""))
}
