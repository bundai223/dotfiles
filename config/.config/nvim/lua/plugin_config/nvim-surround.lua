require("nvim-surround").setup({
  move_cursor = false,
  --   keymaps = { -- vim-surround style keymaps
  --     insert = "<C-s>",
  --     insert_line = "<C-s><C-s>",
  --     normal = "sa",
  --     normal_line = "saa",
  --     normal_cur_line = "sS",
  --     visual = "s",
  --     delete = "sd",
  --     change = "sr",
  --   },
  --   aliases = {
  --     ["a"] = "a",
  --     ["b"] = "b",
  --     ["B"] = "B",
  --     ["r"] = "r",
  --     ["q"] = { '"', "'", "`" }, -- Any quote character
  --     [";"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
  --   },
  highlight = { -- Highlight before inserting/changing surrounds
    duration = 0,
  },
})
