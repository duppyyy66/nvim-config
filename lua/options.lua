-- ============================================================
--  Базовые настройки
--  ~/.config/nvim/lua/options.lua
-- ============================================================

local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.termguicolors  = true        -- нужно для Catppuccin
opt.showmode       = false       -- режим показывает lualine
opt.cmdheight      = 1

-- Поиск
opt.ignorecase = true
opt.smartcase  = true
opt.incsearch  = true
opt.hlsearch   = true

-- Отступы
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true
opt.autoindent  = true

-- Буфер обмена (работает и на Linux и на Mac)
opt.clipboard = "unnamedplus"

-- Окна
opt.splitright = true
opt.splitbelow = true

-- Производительность
opt.updatetime  = 250
opt.timeoutlen  = 500
opt.lazyredraw  = false

-- Файлы
opt.encoding    = "utf-8"
opt.hidden      = true           -- переключаться между буферами без сохранения
opt.swapfile    = false
opt.backup      = false
opt.undofile    = true
opt.undodir     = vim.fn.expand("~/.vim/undo")
vim.fn.mkdir(vim.fn.expand("~/.vim/undo"), "p")

-- Мышь
opt.mouse = "a"

-- Заполнение символов
opt.fillchars = {
  eob    = " ",   -- скрыть ~ в конце файла
  fold   = " ",
  vert   = "│",
}

-- Fold (сворачивание кода) — раскрыто по умолчанию
opt.foldmethod = "indent"
opt.foldenable = false
opt.foldlevel  = 99

-- Автодополнение
opt.completeopt = { "menu", "menuone", "noselect" }

-- Bash синтаксис для .sh файлов
vim.g.is_bash = 1
