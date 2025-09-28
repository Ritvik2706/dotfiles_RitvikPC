-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-lspconfig.lua
-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-lspconfig.lua
--
-- https://github.com/neovim/nvim-lspconfig

return {
  "neovim/nvim-lspconfig",
  opts = {

    -- This disables inlay hints
    -- When programming in Go, these made my experience feel like shit, because were
    -- very intrusive and I never got used to them.
    --
    -- Folke has a keymap to toggle inaly hints with <leader>uh
    inlay_hints = { enabled = false },

    -- Global setup to suppress LSP progress notifications
    setup = {
      jdtls = function(_, opts)
        -- Suppress noisy Java LSP notifications globally
        vim.lsp.handlers["$/progress"] = function() end
        vim.lsp.handlers["window/showMessage"] = function() end
        vim.lsp.handlers["window/logMessage"] = function() end
        return false -- Use default setup
      end,
    },

    servers = {
      -- C/C++ Language Server for syntax checking and diagnostics
      clangd = {
        enabled = true,
        filetypes = { "c", "cpp", "objc", "objcpp" },
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
        settings = {},
      },
      
      -- Python Language Server
      pyright = {
        enabled = true,
        filetypes = { "python" },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      },
      
      -- Java Language Server
      jdtls = {
        enabled = true,
        filetypes = { "java" },
        settings = {
          java = {
            configuration = {
              runtimes = {
                -- Add your Java runtime configurations here if needed
              },
            },
            -- Reduce verbosity and disable unnecessary notifications
            trace = { server = "off" },
            import = { exclusions = {} },
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            completion = {
              favoriteStaticMembers = {},
              importOrder = {},
            },
            -- Only disable the problematic auto-formatting features
            format = {
              enabled = true, -- Keep manual formatting available
              settings = {
                url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
                profile = "GoogleStyle",
              },
              onType = {
                enabled = false, -- THIS stops auto-formatting while typing
              },
            },
            saveActions = {
              organizeImports = false, -- Stop auto-organizing imports on save
            },
          },
        },
        -- Only disable on-type formatting capability (the problematic one)
        capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
          textDocument = {
            onTypeFormatting = { dynamicRegistration = false }, -- Only disable this one
          },
        }),
        -- Custom handler to disable only the disruptive auto-changes
        handlers = {
          ["textDocument/onTypeFormatting"] = function() end, -- Disable on-type formatting
        },
      },
      
      -- Rust Language Server
      rust_analyzer = {
        enabled = true,
        filetypes = { "rust" },
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      },
      
      -- Go Language Server
      gopls = {
        enabled = true,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      },
      
      -- TypeScript/JavaScript Language Server
      tsserver = {
        enabled = true,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      },
      
      -- JSON Language Server
      jsonls = {
        enabled = true,
        filetypes = { "json", "jsonc" },
      },
      
      -- YAML Language Server
      yamlls = {
        enabled = true,
        filetypes = { "yaml", "yml" },
      },
      
      -- Bash Language Server
      bashls = {
        enabled = true,
        filetypes = { "sh", "bash" },
      },
      
      -- Lua Language Server
      lua_ls = {
        enabled = true,
        filetypes = { "lua" },
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
      
      -- SQL Language Server
      sqlls = {
        enabled = true,
        filetypes = { "sql", "mysql", "plsql" },
      },
      
      -- https://www.reddit.com/r/neovim/comments/1j7ookn/comment/mgysste/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      -- The hover window configuration for the diagnostics is done in lamw26wmal
      -- ~/github/dotfiles-latest/neovim/neobean/lua/config/autocmds.lua
      harper_ls = {
        enabled = true,
        filetypes = { "markdown" },
        settings = {
          ["harper-ls"] = {
            userDictPath = "~/github/dotfiles-latest/neovim/neobean/spell/en.utf-8.add",
            linters = {
              ToDoHyphen = false,
              SpellCheck = false, -- Disable spell checking to avoid French word issues
              -- SentenceCapitalization = true,
            },
            isolateEnglish = false, -- Allow multilingual content
            markdown = {
              -- [ignores this part]()
              -- [[ also ignores my marksman links ]]
              IgnoreLinkTitle = true,
            },
          },
        },
      },
    },
  },
}
