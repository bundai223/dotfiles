-- [nvim-lsp-installerからmason.nvimへ移行する](https://zenn.dev/kawarimidoll/articles/367b78f7740e84)

-- https://github.com/yutkat/dotfiles/blob/91c57ee62856ea314093a52f3d47a627965877f5/.config/nvim/lua/rc/pluginconfig/nvim-lsp-installer.lua

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local navic = require('nvim-navic')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  navic.attach(client, bufnr)
end

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
local opts = { capabilities = default_capabilities, on_attach = on_attach }

-- vim.print(default_capabilities)

mason_lspconfig.setup_handlers({
  function(server_name)
    -- print(server_name)
    lspconfig[server_name].setup(opts)
  end,
  ['rust_analyzer'] = function(server_name)
    require("rust-tools").setup({ server = opts })
    lspconfig[server_name].setup(opts)
  end,
  ['jsonls'] = function(server_name)
    -- json-lsp
    local default_schemas = nil
    local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
    if status_ok then
      default_schemas = jsonls_settings.get_default_schemas()
    end

    local function extend(tab1, tab2)
      for _, value in ipairs(tab2 or {}) do
        table.insert(tab1, value)
      end
      return tab1
    end

    local schemas = {
      {
        description = "devcontainer/cli",
        fileMatch = {
          "devcontainer.json",
          ".devcontainer.json",
        },
        url = "https://raw.githubusercontent.com/devcontainers/spec/main/schemas/devContainer.schema.json",
      },
      {
        -- https://github.com/LuaLS/lua-language-server/wiki/Configuration-File#json-schema
        description = "luals",
        fileMatch = {
          ".luarc.json"
        },
        url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
      },
    }

    local extended_schemas = extend(schemas, default_schemas)

    lspconfig[server_name].setup({
      capabilities = default_capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = extended_schemas,
        },
      },
      -- setup = {
      --   commands = {
      --     Format = {
      --       function()
      --         vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
      --       end,
      --     },
      --   },
      -- },
    })
    -- lspconfig[server_name].setup(opts)

    -- local schemas = {
    --   {
    --     description = "TypeScript compiler configuration file",
    --     fileMatch = {
    --       "tsconfig.json",
    --       "tsconfig.*.json",
    --     },
    --     url = "https://json.schemastore.org/tsconfig.json",
    --   },
    --   {
    --     description = "Lerna config",
    --     fileMatch = { "lerna.json" },
    --     url = "https://json.schemastore.org/lerna.json",
    --   },
    --   {
    --     description = "Babel configuration",
    --     fileMatch = {
    --       ".babelrc.json",
    --       ".babelrc",
    --       "babel.config.json",
    --     },
    --     url = "https://json.schemastore.org/babelrc.json",
    --   },
    --   {
    --     description = "ESLint config",
    --     fileMatch = {
    --       ".eslintrc.json",
    --       ".eslintrc",
    --     },
    --     url = "https://json.schemastore.org/eslintrc.json",
    --   },
    --   {
    --     description = "Bucklescript config",
    --     fileMatch = { "bsconfig.json" },
    --     url = "https://raw.githubusercontent.com/rescript-lang/rescript-compiler/8.2.0/docs/docson/build-schema.json",
    --   },
    --   {
    --     description = "Prettier config",
    --     fileMatch = {
    --       ".prettierrc",
    --       ".prettierrc.json",
    --       "prettier.config.json",
    --     },
    --     url = "https://json.schemastore.org/prettierrc",
    --   },
    --   {
    --     description = "Vercel Now config",
    --     fileMatch = { "now.json" },
    --     url = "https://json.schemastore.org/now",
    --   },
    --   {
    --     description = "Stylelint config",
    --     fileMatch = {
    --       ".stylelintrc",
    --       ".stylelintrc.json",
    --       "stylelint.config.json",
    --     },
    --     url = "https://json.schemastore.org/stylelintrc",
    --   },
    --   {
    --     description = "A JSON schema for the ASP.NET LaunchSettings.json files",
    --     fileMatch = { "launchsettings.json" },
    --     url = "https://json.schemastore.org/launchsettings.json",
    --   },
    --   {
    --     description = "Schema for CMake Presets",
    --     fileMatch = {
    --       "CMakePresets.json",
    --       "CMakeUserPresets.json",
    --     },
    --     url = "https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json",
    --   },
    --   {
    --     description = "Configuration file as an alternative for configuring your repository in the settings page.",
    --     fileMatch = {
    --       ".codeclimate.json",
    --     },
    --     url = "https://json.schemastore.org/codeclimate.json",
    --   },
    --   {
    --     description = "LLVM compilation database",
    --     fileMatch = {
    --       "compile_commands.json",
    --     },
    --     url = "https://json.schemastore.org/compile-commands.json",
    --   },
    --   {
    --     description = "Config file for Command Task Runner",
    --     fileMatch = {
    --       "commands.json",
    --     },
    --     url = "https://json.schemastore.org/commands.json",
    --   },
    --   {
    --     description = "AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.",
    --     fileMatch = {
    --       "*.cf.json",
    --       "cloudformation.json",
    --     },
    --     url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json",
    --   },
    --   {
    --     description = "The AWS Serverless Application Model (AWS SAM, previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs, AWS Lambda functions, and Amazon DynamoDB tables needed by your serverless application.",
    --     fileMatch = {
    --       "serverless.template",
    --       "*.sam.json",
    --       "sam.json",
    --     },
    --     url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json",
    --   },
    --   {
    --     description = "Json schema for properties json file for a GitHub Workflow template",
    --     fileMatch = {
    --       ".github/workflow-templates/**.properties.json",
    --     },
    --     url = "https://json.schemastore.org/github-workflow-template-properties.json",
    --   },
    --   {
    --     description = "golangci-lint configuration file",
    --     fileMatch = {
    --       ".golangci.toml",
    --       ".golangci.json",
    --     },
    --     url = "https://json.schemastore.org/golangci-lint.json",
    --   },
    --   {
    --     description = "JSON schema for the JSON Feed format",
    --     fileMatch = {
    --       "feed.json",
    --     },
    --     url = "https://json.schemastore.org/feed.json",
    --     versions = {
    --       ["1"] = "https://json.schemastore.org/feed-1.json",
    --       ["1.1"] = "https://json.schemastore.org/feed.json",
    --     },
    --   },
    --   {
    --     description = "Packer template JSON configuration",
    --     fileMatch = {
    --       "packer.json",
    --     },
    --     url = "https://json.schemastore.org/packer.json",
    --   },
    --   {
    --     description = "NPM configuration file",
    --     fileMatch = {
    --       "package.json",
    --     },
    --     url = "https://json.schemastore.org/package.json",
    --   },
    --   {
    --     description = "JSON schema for Visual Studio component configuration files",
    --     fileMatch = {
    --       "*.vsconfig",
    --     },
    --     url = "https://json.schemastore.org/vsconfig.json",
    --   },
    --   {
    --     description = "Resume json",
    --     fileMatch = { "resume.json" },
    --     url = "https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json",
    --   },
    -- }
    -- return opts
  end,
  ['terraformls'] = function(server_name)
    -- terraform
    lspconfig[server_name].setup {
      capabilities = default_capabilities,
      on_attach = on_attach,
      settings = {
        terraform = {
          path = "/home/nishimura/repos/github.com/bundai223/terminal-tools/bin/terraform"
        }
      }
    }
  end,
  ['yamlls'] = function(server_name)
    -- yaml-language-server
    lspconfig[server_name].setup {
      capabilities = default_capabilities,
      on_attach = on_attach,
      settings = {
        yaml = {
          -- trace = {
          --   server = "verbose"
          -- },
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
            "!Or"
          },
          -- https://www.schemastore.org/json/
          schemas = {
            -- ["AWS CloudFormation"] = { "*.cf.{yml,yaml}", "*.{yml,yaml}", "cloud*formation/*.{yml,yaml}" },
            ["/home/nishimura/repos/github.com/bundai223/goformation/schema/cloudformation.schema.json"] = {
              "*.cf.{yml,yaml}",
              "cloud*formation/*.{yml,yaml}" },
            -- ["docker-compose.yml"] = { "docker-compose.{yml,yaml}", "docker-compose*.{yml,yaml}" },
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
              "docker-compose.yml",
              "docker-compose*.yml" },
            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.{yml,yaml}",
            ["openapi.json"] = "*api*.{yml,yaml}",
          },
        }
      }
    }
  end,
  ['volar'] = function(server_name)
    local opts = {
      capabilities = default_capabilities,
      on_attach = on_attach,
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
    }
    lspconfig[server_name].setup(opts)
  end,
  ['lua_ls'] = function(server_name)
    -- lua-language-server
    local has_lua_dev, neodev = pcall(require, "neodev")
    if has_lua_dev then
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      neodev.setup({})
    end
    local opts = {
      capabilities = default_capabilities,
      on_attach = on_attach,
      log_level = 1,
      settings = {
        Lua = {
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              "${3rd}/luv/library",
            },
          },
        }
      }
    }
    lspconfig[server_name].setup(opts)
  end
})
