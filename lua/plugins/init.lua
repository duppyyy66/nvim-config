-- ============================================================
--  lazy.nvim — менеджер плагинов
--  ~/.config/nvim/lua/plugins/init.lua
-- ============================================================

-- Авто-установка lazy.nvim если нет
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ── Тема ──────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,    -- загрузить первым
    config   = function()
      require("catppuccin").setup({
        flavour = "mocha",   -- mocha = самый тёмный вариант
        integrations = {
          neo_tree    = true,
          telescope   = true,
          cmp         = true,
          gitsigns    = true,
          which_key   = true,
          native_lsp  = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Статус-бар ────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      require("lualine").setup({
        options = {
          theme = require("catppuccin.utils.lualine")("mocha"),
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },   -- относительный путь
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── Иконки ────────────────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ── Neo-tree — файловый менеджер ──────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = { width = 30 },
        filesystem = {
          filtered_items = {
            hide_dotfiles   = false,   -- показывать скрытые файлы
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true },
        },
      })
    end,
  },

  -- ── Telescope — fuzzy поиск ───────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- нативный сортер (быстрее, нужен make)
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ── Treesitter — продвинутая подсветка синтаксиса ─────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- nvim-treesitter 1.0+ — новый API через vim.treesitter
      require("nvim-treesitter").setup()

      -- Установить парсеры для нужных языков
      local parsers = { "c", "cpp", "java", "bash", "lua", "vim", "vimdoc", "json", "yaml" }
      for _, lang in ipairs(parsers) do
        vim.treesitter.language.add(lang)
      end

      -- Включить подсветку через autocmd
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "java", "bash", "sh", "lua", "json", "yaml" },
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if not ok then
            -- парсер ещё не установлен — молча пропустить
          end
        end,
      })

      -- Авто-установка парсеров при открытии файла
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang then
            pcall(function()
              vim.cmd("TSInstall " .. lang)
            end)
          end
        end,
      })
    end,
  },

  -- ── LSP + автокомплит ─────────────────────────────────────
  { import = "plugins.lsp" },

  -- ── Редактор — удобства ───────────────────────────────────
  { import = "plugins.editor" },

}, {
  -- Настройки lazy.nvim
  ui = { border = "rounded" },
  checker = { enabled = false },   -- не проверять обновления автоматически
})
