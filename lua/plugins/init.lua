local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "isort",
        "black",
        "markdownlint",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "custom.configs.conform"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        python = { "pylint" },
        markdown = { "markdownlint" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
      require("lint").linters.pylint.cmd = "python"
      require("lint").linters.pylint.args = { "-m", "pylint", "-f", "json" }
    end,
  },
  {
    "coffebar/neovim-project",
    opts = {
      last_session_on_startup = false,
      projects = { -- define project roots
        "~/DS-SCP*",
        "~/projects/*",
        "D:/projects/*",
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append "globals" -- save global variables that start with an uppercase letter and contain at least one lowercase letter.

      require("nvim-tree").setup {
        -- git = {
        --  cygwin_support = true,
        -- }
      }
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
  {
    "chentoast/marks.nvim",
    lazy = false,
    config = function()
      require("marks").setup {
        default_mappings = true,
        signs = true,
        mappings = {},
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function()
      local telescope = require "telescope"
      local lga_actions = require "telescope-live-grep-args.actions"

      telescope.setup {
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
                ["<C-t>"] = lga_actions.quote_prompt { postfix = " -t" },
              },
            },
          },
        },
      }
      require("telescope").load_extension "live_grep_args"
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "microsoft/debugpy",
    },
    init = function()
      require("dap-python").setup "python.exe"
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    init = function()
      local dap, dapui = require "dap", require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    requires = { "mfussenegger/nvim-dap" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- setup treesitter with config
    end,
    dependencies = {
      -- NOTE: additional parser
      { "nushell/tree-sitter-nu" },
    },
    build = ":TSUpdate",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = { "nvim-treesitter/nvim-treesitter" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["au"] = "@comment.outer",
              ["iu"] = "@comment.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      }
    end,
    lazy = false,
  },
  {
    "girishji/pythondoc.vim",
    config = function() end,
    lazy = false,
  },
  {
    "lervag/wiki.vim",
    config = function()
      vim.cmd "let g:wiki_root = '~/wiki'"
      vim.g.wiki_select_method = {
        pages = require("wiki.telescope").pages,
        tags = require("wiki.telescope").tags,
        toc = require("wiki.telescope").toc,
        links = require("wiki.telescope").links,
      }
    end,
    lazy = false,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "edshamis/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup {}
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
}
return plugins
