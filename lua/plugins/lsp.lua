-- ============================================================
--  LSP + автокомплит — nvim 0.11+ native API
--  ~/.config/nvim/lua/plugins/lsp.lua
-- ============================================================

return {

  -- Mason — установщик LSP-серверов
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })
    end,
  },

  -- Связка mason <-> нативный vim.lsp.config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",   -- C / C++
          "jdtls",    -- Java
          "bashls",   -- Bash
          "lua_ls",   -- Lua
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig — для всех языков кроме Java
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Диагностика — иконки и стиль
      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✗",
            [vim.diagnostic.severity.WARN]  = "⚠",
            [vim.diagnostic.severity.HINT]  = "➤",
            [vim.diagnostic.severity.INFO]  = "ℹ",
          },
        },
        update_in_insert = false,
        float = { border = "rounded" },
      })

      -- Горячие клавиши при подключении LSP к буферу
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeys", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd",         vim.lsp.buf.definition,      "Перейти к определению")
          map("gr",         vim.lsp.buf.references,      "Найти все ссылки")
          map("gi",         vim.lsp.buf.implementation,  "Перейти к реализации")
          map("gt",         vim.lsp.buf.type_definition, "Тип переменной")
          map("K",          vim.lsp.buf.hover,           "Документация")
          map("<leader>rn", vim.lsp.buf.rename,          "Переименовать символ")
          map("<leader>ca", vim.lsp.buf.code_action,     "Code actions")
          map("[g",         vim.diagnostic.goto_prev,    "Предыдущая ошибка")
          map("]g",         vim.diagnostic.goto_next,    "Следующая ошибка")
          map("<leader>e",  vim.diagnostic.open_float,   "Показать ошибку")
          map("<leader>f",  function()
            vim.lsp.buf.format({ async = true })
          end, "Форматировать файл")
        end,
      })

      -- ── C / C++ ───────────────────────────────────────────
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })
      vim.lsp.enable("clangd")

      -- ── Bash ──────────────────────────────────────────────
      vim.lsp.config("bashls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("bashls")

      -- ── Lua ───────────────────────────────────────────────
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })
      vim.lsp.enable("lua_ls")

    end,
  },

  -- ── Java — nvim-jdtls (полноценная поддержка) ─────────────
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local jdtls      = require("jdtls")
      local mason_data = vim.fn.stdpath("data") .. "/mason"
      local jdtls_path = mason_data .. "/packages/jdtls"
      local launcher   = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

      local config_dir = jdtls_path .. "/config_linux"
      if vim.fn.has("mac") == 1 then
        config_dir = jdtls_path .. "/config_mac"
      end

      -- Уникальный workspace для каждого проекта
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace    = vim.fn.expand("~/.cache/jdtls/workspace/") .. project_name

      -- JDK из SDKMAN
      local sdkman_java = vim.fn.expand("~/.sdkman/candidates/java/current/bin/java")
      local java_bin    = vim.fn.executable(sdkman_java) == 1 and sdkman_java or "java"

      -- Spring Boot Tools bundles
      local spring_ext = mason_data .. "/packages/spring-boot-tools/extension"
      local bundles    = {}
      for _, jar in ipairs(vim.fn.glob(spring_ext .. "/**/jars/*.jar", true, true)) do
        table.insert(bundles, jar)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local config = {
        cmd = {
          java_bin,
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.level=ALL",
          "-Xmx2g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", launcher,
          "-configuration", config_dir,
          "-data", workspace,
        },
        root_dir = vim.fs.root(0, {
          "pom.xml", "build.gradle", ".git", "mvnw", "gradlew",
        }),
        capabilities = capabilities,
        settings = {
          java = {
            eclipse    = { downloadSources = true },
            maven      = { downloadSources = true },
            references = { includeDecompiledSources = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            format     = { enabled = true },
            saveActions = { organizeImports = true },
            completion = {
              favoriteStaticMembers = {
                "org.junit.Assert.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
                "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
              },
            },
          },
        },
        init_options = {
          bundles = bundles,
        },
        on_attach = function(_, bufnr)
          -- Стандартные горячие клавиши уже назначены через LspAttach выше
          -- Дополнительные Java-специфичные биндинги:
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Java: " .. desc })
          end
          -- Рефакторинг
          map("<leader>jo", jdtls.organize_imports,                     "Организовать импорты")
          map("<leader>jv", jdtls.extract_variable,                     "Извлечь переменную")
          map("<leader>jm", jdtls.extract_method,                       "Извлечь метод")
          map("<leader>jc", jdtls.extract_constant,                     "Извлечь константу")
          -- Тесты
          map("<leader>jt", jdtls.test_nearest_method,                  "Запустить ближайший тест")
          map("<leader>jT", jdtls.test_class,                           "Запустить все тесты класса")
          -- Визуальный режим — извлечение
          vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end,
            { buffer = bufnr, desc = "Java: Извлечь переменную (выделение)" })
          vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end,
            { buffer = bufnr, desc = "Java: Извлечь метод (выделение)" })
        end,
      }

      -- Запустить jdtls
      jdtls.start_or_attach(config)

      -- Перезапускать при смене проекта
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern  = "*.java",
        callback = function()
          jdtls.start_or_attach(config)
        end,
      })
    end,
  },

  -- Автокомплит — nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
