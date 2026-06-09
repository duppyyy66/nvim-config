-- ============================================================
--  Горячие клавиши
--  ~/.config/nvim/lua/keymaps.lua
-- ============================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader = пробел
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Базовое ─────────────────────────────────────────────────
map("n", "<leader>w", ":w<CR>",           { desc = "Сохранить файл" })
map("n", "<leader>q", ":q<CR>",           { desc = "Закрыть окно" })
map("n", "<leader>Q", ":qa!<CR>",         { desc = "Выйти без сохранения" })
map("n", "<Esc>",     ":nohlsearch<CR>",  { desc = "Убрать подсветку поиска" })

-- Y ведёт себя как D и C (до конца строки)
map("n", "Y", "y$", opts)

-- Центрировать экран при поиске и прокрутке
map("n", "n",     "nzzzv", opts)
map("n", "N",     "Nzzzv", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- ── Окна ────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Окно влево" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно вправо" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно вниз" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно вверх" })

-- Изменение размера окна
map("n", "<C-Up>",    ":resize +2<CR>",          opts)
map("n", "<C-Down>",  ":resize -2<CR>",          opts)
map("n", "<C-Left>",  ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- ── Буферы ──────────────────────────────────────────────────
map("n", "<leader>]", ":bnext<CR>",     { desc = "Следующий буфер" })
map("n", "<leader>[", ":bprevious<CR>", { desc = "Предыдущий буфер" })
map("n", "<leader>d", ":bdelete<CR>",   { desc = "Закрыть буфер" })

-- ── Терминал ────────────────────────────────────────────────
map("n", "<leader>t", ":terminal<CR>",  { desc = "Открыть терминал" })
map("t", "<Esc>",     "<C-\\><C-n>",    { desc = "Выйти из терминала в normal mode" })

-- ── Визуальный режим ────────────────────────────────────────
-- Перемещать выделенные строки вверх/вниз
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Не перезаписывать буфер при вставке поверх выделения
map("v", "p", '"_dP', opts)

-- ── Neo-tree ────────────────────────────────────────────────
map("n", "<C-n>",      ":Neotree toggle<CR>",       { desc = "Файловый менеджер" })
map("n", "<leader>nf", ":Neotree reveal<CR>",        { desc = "Найти файл в дереве" })

-- ── Telescope ───────────────────────────────────────────────
map("n", "<C-p>",      "<cmd>Telescope find_files<CR>",  { desc = "Поиск файлов" })
map("n", "<leader>rg", "<cmd>Telescope live_grep<CR>",   { desc = "Grep по проекту" })
map("n", "<leader>b",  "<cmd>Telescope buffers<CR>",     { desc = "Список буферов" })
map("n", "<leader>h",  "<cmd>Telescope oldfiles<CR>",    { desc = "Последние файлы" })
map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Символы в файле" })

-- ── LSP (назначаются в lsp.lua через on_attach) ─────────────
-- gd  — перейти к определению
-- gr  — ссылки
-- K   — документация
-- и т.д. — см. plugins/lsp.lua
