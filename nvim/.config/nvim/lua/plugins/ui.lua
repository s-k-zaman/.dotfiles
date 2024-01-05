return {
  -- lua line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
      local icons = require("utils.icons_lazynvim").icons
      opts.options.theme = "auto"
      opts.options.component_separators = {
        left = "",
        right = "",
      }
      opts.options.section_separators = {
        left = "",
        right = "",
      }
      opts.sections = {
        -- left sections
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
        },
        lualine_c = {

          -- "diff",
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filename", path = 1, symbols = { modified = "󰛓", readonly = "", unnamed = "[No Name]" } },
			-- for nvim-navic
			-- stylua: ignore
			-- {
			--   function() return require("nvim-navic").get_location() end,
			--   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
			-- },
			{
				function()
					return require("modules.ui").python_venv(false, false)
				end,
			},
          {
            function()
              return require("modules.ui").python_venv_selector(false, false)
            end,
          },
        },
        -- right sections
        lualine_x = {
          {
            function()
              return require("modules.ui.lsp-info").get_lsps()
            end,
          },
          { "filetype", icon = { align = "right" } },
          "encoding",
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%I:%M, %a")
          end,
        },
      }
    end,
  },
  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  -- filename
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  -- zen mode
  {
    "folke/zen-mode.nvim",
    event = { "VeryLazy" },
    config = function()
      require("zen-mode").setup({
        window = {
          width = 100,
          options = {
            number = true,
            relativenumber = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").toggle()
        vim.wo.wrap = false
      end)
    end,
  },

  -- notification, messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    enabled = false,
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
      -- set the views of ui items
      opts.views = {
        cmdline_popup = {
          position = {
            row = "80%",
            col = "50%",
          },
        },
      }
    end,
  },
}
