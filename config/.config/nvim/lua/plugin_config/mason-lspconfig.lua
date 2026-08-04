local mason_lspconfig = require("mason-lspconfig")

local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
  capabilities = default_capabilities,
  on_attach = on_attach,
})

local my_json_schemas = {
  {
    description = "devcontainer/cli",
    fileMatch = {
      "devcontainer.json",
      ".devcontainer.json",
    },
    url = "https://raw.githubusercontent.com/devcontainers/spec/main/schemas/devContainer.base.schema.json",
  },
  {
    description = "luals",
    fileMatch = {
      ".luarc.json",
    },
    url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
  },
}

local catalog_schemas = require("plugin_config/schema-store-catalog").schemas
local json_schemas = vim.list_extend(vim.deepcopy(catalog_schemas), my_json_schemas)

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = json_schemas,
    },
  },
})

vim.lsp.config("terraformls", {
  settings = {
    terraform = {
      path = "/home/nishimura/repos/github.com/bundai223/terminal-tools/bin/terraform",
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      customTags = {
        "!Ref",
        "!Sub scalar",
        "!Sub sequence",
        "!Join sequence",
        "!FindInMap sequence",
        "!GetAtt scalar",
        "!GetAtt sequence",
        "!Base64 mapping",
        "!GetAZs",
        "!Select scalar",
        "!Select sequence",
        "!Split sequence",
        "!ImportValue",
        "!ImportValue sequence",
        "!Condition",
        "!Equals sequence",
        "!And",
        "!If",
        "!Not",
        "!Or",
      },
      schemas = {
        ["/home/nishimura/repos/github.com/bundai223/goformation/schema/cloudformation.schema.json"] = {
          "*.cf.{yml,yaml}",
          "cloud*formation/*.{yml,yaml}",
        },
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose.yml",
          "docker-compose*.yml",
        },
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
        ".gitlab-ci.{yml,yaml}",
        ["openapi.json"] = "*api*.{yml,yaml}",
      },
    },
  },
})

vim.lsp.config("volar", {
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "json",
  },
})

local has_neodev, neodev = pcall(require, "neodev")
if has_neodev then
  neodev.setup({})
end

vim.lsp.config("lua_ls", {
  log_level = 1,
  settings = {
    Lua = {
      workspace = {
        -- 配列とハッシュを混ぜるとnvimがLspNotifyのdataへ変換できず
        -- 「Invalid 'data': Cannot convert given Lua table」で落ちるため、
        -- lua_lsが受け付ける配列形式に統一する。
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          "${3rd}/luv/library",
        },
      },
    },
  },
})

mason_lspconfig.setup()
