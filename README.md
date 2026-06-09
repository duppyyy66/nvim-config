# nvim-config

Конфигурация Neovim для разработки на Java / Spring Boot, C/C++ и Bash.

## Возможности

- **LSP** — автокомплит, переход к определению, рефакторинг для Java, C/C++, Bash, Lua
- **Java / Spring Boot** — полная поддержка через `nvim-jdtls`: генерация классов, организация импортов, запуск тестов, Spring Boot расширения
- **Treesitter** — продвинутая подсветка синтаксиса
- **Telescope** — fuzzy-поиск файлов и grep по проекту
- **Neo-tree** — боковая панель файлового менеджера
- **lazy.nvim** — менеджер плагинов с ленивой загрузкой
- **Catppuccin Mocha** — тёмная тема
- **Git** — gitsigns + fugitive

## Требования

| Зависимость | Версия | Зачем |
|---|---|---|
| Neovim | 0.10+ | основа |
| Node.js + npm | LTS | bashls, tree-sitter-cli |
| clangd | любая | LSP для C/C++ |
| ripgrep | любая | grep в Telescope |
| SDKMAN + JDK | 17 или 21 | Java LSP (jdtls) |
| Nerd Font | любая | иконки в терминале |

## Установка

### Быстрая (Debian/Ubuntu)

```bash
curl -sL https://raw.githubusercontent.com/duppyyy66/nvim-config/main/install.sh | bash
```

Скрипт автоматически:
- создаёт бэкап существующего конфига
- клонирует репозиторий в `~/.config/nvim`
- устанавливает Node.js, bash-language-server, tree-sitter-cli
- добавляет alias `vi=nvim` в `.bashrc` / `.zshrc`
- устанавливает все плагины через lazy.nvim

### Ручная

```bash
# 1. Клонировать конфиг
git clone https://github.com/duppyyy66/nvim-config.git ~/.config/nvim

# 2. Установить зависимости
sudo apt install -y clangd ripgrep

# Node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
npm install -g bash-language-server tree-sitter-cli

# SDKMAN + Java
curl -s "https://get.sdkman.io" | bash
source ~/.bashrc
sdk install java 17.0.11-tem

# 3. Открыть nvim — плагины установятся автоматически
nvim
```

### macOS

```bash
brew install neovim ripgrep
brew install --cask font-jetbrains-mono-nerd-font iterm2

# Конфиг
git clone https://github.com/duppyyy66/nvim-config.git ~/.config/nvim

# SDKMAN (работает так же как на Linux)
curl -s "https://get.sdkman.io" | bash
```

## Структура

```
~/.config/nvim/
├── init.lua                  # точка входа
├── install.sh                # установочный скрипт
└── lua/
    ├── options.lua           # базовые настройки
    ├── keymaps.lua           # горячие клавиши
    └── plugins/
        ├── init.lua          # lazy.nvim, тема, telescope, treesitter
        ├── lsp.lua           # LSP, автокомплит, Java/Spring Boot
        └── editor.lua        # git, autopairs, which-key, springboot-nvim
```

## Горячие клавиши

> `<leader>` = пробел

### Навигация

| Клавиши | Действие |
|---|---|
| `Ctrl+N` | Открыть / закрыть Neo-tree |
| `Space+nf` | Найти текущий файл в дереве |
| `Ctrl+P` | Поиск файлов (Telescope) |
| `Space+rg` | Grep по проекту |
| `Space+b` | Список буферов |
| `Space+h` | Последние файлы |
| `Ctrl+H/J/K/L` | Навигация между окнами |
| `Space+]` / `Space+[` | Следующий / предыдущий буфер |

### LSP

| Клавиши | Действие |
|---|---|
| `gd` | Перейти к определению |
| `gr` | Найти все ссылки |
| `gi` | Перейти к реализации |
| `K` | Документация |
| `Space+rn` | Переименовать символ |
| `Space+ca` | Code actions (авто-импорт) |
| `Space+f` | Форматировать файл |
| `[g` / `]g` | Предыдущая / следующая ошибка |

### Java / Spring Boot

| Клавиши | Действие |
|---|---|
| `Space+jo` | Организовать импорты |
| `Space+jv` | Извлечь переменную |
| `Space+jm` | Извлечь метод |
| `Space+jc` | Извлечь константу |
| `Space+jt` | Запустить ближайший тест |
| `Space+jT` | Запустить все тесты класса |
| `Space+jr` | Запустить Spring Boot проект |
| `Space+jn` | Новый класс (Controller/Service/...) |
| `Space+ji` | Новый интерфейс |
| `Space+je` | Новый enum |

### Git

| Клавиши | Действие |
|---|---|
| `]c` / `[c` | Следующее / предыдущее изменение |
| `Space+gs` | Stage hunk |
| `Space+gp` | Preview hunk |
| `Space+gb` | Blame строки |

## Переключение версий Java

Конфиг автоматически использует активную версию JDK из SDKMAN.

```bash
# Переключить глобально
sdk default java 21.0.3-tem

# Переключить для текущей сессии
sdk use java 17.0.11-tem
```

Для автоматического переключения в проекте создай `.sdkmanrc` в корне:

```
java=17.0.11-tem
```

И включи автопереключение:

```bash
sed -i 's/sdkman_auto_env=false/sdkman_auto_env=true/' ~/.sdkman/etc/config
```

## Обновление конфига

```bash
cd ~/.config/nvim
git pull
nvim --headless "+Lazy sync" +qa
```
