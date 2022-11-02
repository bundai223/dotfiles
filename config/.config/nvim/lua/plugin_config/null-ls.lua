local null_ls = require("null-ls")

-- local function file_exists(fname)
--   local stat = vim.loop.fs_stat(vim.fn.expand(fname))
--   return (stat and stat.type) or false
-- end
local ignored_filetypes = {
  "TelescopePrompt",
  "diff",
  "gitcommit",
  "unite",
  "qf",
  "help",
  "markdown",
  "minimap",
  "packer",
  "dashboard",
  "telescope",
  "lsp-installer",
  "lspinfo",
  "NeogitCommitMessage",
  "NeogitCommitView",
  "NeogitGitCommandHistory",
  "NeogitLogView",
  "NeogitNotification",
  "NeogitPopup",
  "NeogitStatus",
  "NeogitStatusNew",
  "aerial",
  "null-ls-info",
}

local sources = {
  -- diagnostics
  null_ls.builtins.diagnostics.cfn_lint.with({
    condition = function()
      return vim.fn.executable("cfn_lint") > 0
    end,
  }),
  null_ls.builtins.diagnostics.yamllint.with({
    condition = function()
      return vim.fn.executable("yamllint") > 0
    end,
  }),
  null_ls.builtins.diagnostics.zsh.with({
    condition = function()
      return vim.fn.executable("zsh") > 0
    end,
  }),
  null_ls.builtins.diagnostics.vint.with({
    condition = function()
      return vim.fn.executable("vint") > 0
    end,
  }),
  -- null_ls.builtins.diagnostics.rubocop,
  null_ls.builtins.diagnostics.eslint.with({
    condition = function()
      return vim.fn.executable("eslint") > 0
    end,
  }),
  null_ls.builtins.diagnostics.shellcheck.with({
    condition = function()
      return vim.fn.executable("shellcheck") > 0
    end,
  }),

  -- formatter
  null_ls.builtins.formatting.trim_whitespace.with({
    disabled_filetypes = ignored_filetypes,
    runtime_condition = function()
      local count = tonumber(vim.api.nvim_exec("execute 'silent! %s/\\v\\s+$//gn'", true):match("%w+"))
      if count then
        return vim.fn.confirm("Whitespace found, delete it?", "&No\n&Yes", 1, "Question") == 2
      end
    end,
  }),
  null_ls.builtins.formatting.prismaFmt.with({
    condition = function()
      return vim.fn.executable("prisma-fmt") > 0
    end,
  }),
  null_ls.builtins.formatting.prettier.with({
    condition = function()
      return vim.fn.executable("prettier") > 0
    end,
  }),
  null_ls.builtins.formatting.shfmt.with({
    condition = function()
      return vim.fn.executable("shfmt") > 0
    end,
  }),
  null_ls.builtins.formatting.markdownlint.with({
    condition = function()
      return vim.fn.executable("markdownlint") > 0
    end,
  }),
}

------------------------------------------
-- attach
------------------------------------------
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name ~= "tsserver"
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
      once = false,
    })
  end
end

------------------------------------------
-- setup
------------------------------------------
null_ls.setup({
  debug = true,
  sources = sources,
  on_attach = on_attach
})
