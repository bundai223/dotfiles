return {
  s("Host", {
    t("Host "), i(1, { "example.com" }, ""), t({ "", "" }),
    t({ "  HostName " }), i(2, { "192.168.0.1" }), t({ "", "" }),
    t({ "  User " }), i(3, { "nishimura.daiji" }), t({ "", "" }),
    t({ "  Port " }), i(4, { "23" }), t({ "", "" }),
    t({ "  IdentityFile " }), i(5, { "~/.ssh/id_rsa" }), t({ "", "" }),
    -- t("UserKnownHostsFile "), i(1, { "/dev/null" }), t({ "", "" }),
    -- t("StrictHostKeyChecking "), i(1, { "no" }), t("", ""),
  }),
}
