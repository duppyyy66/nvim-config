-- ============================================================
--  Плагины редактора — удобства
--  ~/.config/nvim/lua/plugins/editor.lua
-- ============================================================

return {

  -- Git — знаки изменений в левой колонке
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "▎" },
          topdelete    = { text = "▎" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs  = package.loaded.gitsigns
          local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "Git: " .. desc })
          end
          map("n", "]c", gs.next_hunk,        "Следующее изменение")
          map("n", "[c", gs.prev_hunk,        "Предыдущее изменение")
          map("n", "<leader>gs", gs.stage_hunk,   "Stage hunk")
          map("n", "<leader>gr", gs.reset_hunk,   "Reset hunk")
          map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>gb", gs.blame_line,   "Blame строки")
        end,
      })
    end,
  },

  -- Git команды прямо в nvim
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiff", "Gblame", "Gpush", "Gpull" },
  },

  -- Автозакрытие скобок / кавычек
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({ check_ts = true })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Комментирование: gcc / gc + motion
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- Смена окружения: cs"' / ds" / ysiw"
  { "tpope/vim-surround" },

  -- Направляющие отступов
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })
    end,
  },

  -- which-key — подсказки горячих клавиш
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({ delay = 500 })
      require("which-key").add({
        { "<leader>g", group = "Git" },
        { "<leader>n", group = "Neo-tree" },
        { "<leader>r", group = "Refactor/Grep" },
        { "<leader>c", group = "Code" },
        { "<leader>j", group = "Java" },
      })
    end,
  },

  -- Подсветка TODO/FIXME/HACK/NOTE
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  -- Буферы как вкладки вверху экрана
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            { filetype = "neo-tree", text = "File Explorer", separator = true },
          },
        },
      })
    end,
  },

  -- Spring Boot — генерация классов (использует nvim-jdtls)
  {
    "elmcgill/springboot-nvim",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("springboot-nvim").setup({})
      local map = vim.keymap.set
      map("n", "<leader>jr", "<cmd>SpringBootRun<CR>",         { desc = "Spring: запустить проект" })
      map("n", "<leader>jn", "<cmd>SpringBootNewClass<CR>",    { desc = "Spring: новый класс" })
      map("n", "<leader>ji", "<cmd>SpringBootNewInterface<CR>",{ desc = "Spring: новый интерфейс" })
      map("n", "<leader>je", "<cmd>SpringBootNewEnum<CR>",     { desc = "Spring: новый enum" })
    end,
  },

}
