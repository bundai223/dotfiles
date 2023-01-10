return {
  s("modeline", {
    t({ "vim: " }),
    i(1, { "set ft=hoge ff=dos" }),
    t({ " :" }),
  }),
  s("all/shebang", {
    t({ "#! " }),
    i(0),
    t({ "", "" }),
    i(1)
  }),
  s({
    trig = "date",
    namr = "Date",
    dscr = "Date in the form of YYYY-MM-DD",
  }, {
    f(function(args)
      return { os.date('%Y-%m-%d') }
    end, {}),
  }),
}
