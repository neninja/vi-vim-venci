-- Helpers -------------------------------------------------------------------
local fullpath = debug.getinfo(1, "S").source:sub(2)
fullpath = io.popen("realpath '" .. fullpath .. "'", 'r'):read('*all'):gsub('[\n\r]*$', '')
DOTFILES_FULLPATH_NVIM, _ = fullpath:match('^(.*/)([^/]-)$')
vim.cmd('source ' .. DOTFILES_FULLPATH_NVIM .. 'vimrc')

-- Packer --------------------------------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  print('Installing packer close and reopen Neovim...')
end

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})

-- Plugins --------------------------------------------------------------------
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme 'tokyonight'
    end,
  }

  use {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.pairs').setup()
      local editDotfiles = 'e ' .. DOTFILES_FULLPATH_NVIM .. '/vimrc | call NN_SetGitDir()'

      require('mini.starter').setup {
        autoopen = true,
        evaluate_single = true,
        items = {
          { name = 'Empty buffer',       action = 'enew!',                section = '' },
          { name = 'Dotfiles',           action = editDotfiles,           section = '' },
          { name = 'Update all plugins', action = 'PackerSync',           section = '' },
          { name = 'Quit',               action = 'q',                    section = '' },
          { name = 'Git status',         action = 'Gedit :',              section = 'Projeto' },
          { name = 'Find files',         action = 'Telescope find_files', section = 'Projeto' },
        },
        header = table.concat({
          [[    ███╗   ███╗ █████╗ ██╗  ██╗███████╗   ]],
          [[    ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝   ]],
          [[    ██╔████╔██║███████║█████╔╝ █████╗     ]],
          [[    ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝     ]],
          [[    ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗   ]],
          [[    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ]],
          [[      ██████╗ ██████╗  ██████╗ ██╗        ]],
          [[     ██╔════╝██╔═══██╗██╔═══██╗██║        ]],
          [[     ██║     ██║   ██║██║   ██║██║        ]],
          [[     ██║     ██║   ██║██║   ██║██║        ]],
          [[     ╚██████╗╚██████╔╝╚██████╔╝███████╗   ]],
          [[      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝   ]],
          [[███████╗████████╗██╗   ██╗███████╗███████╗]],
          [[██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝]],
          [[███████╗   ██║   ██║   ██║█████╗  █████╗  ]],
          [[╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝  ]],
          [[███████║   ██║   ╚██████╔╝██║     ██║     ]],
          [[╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝     ]],

        }, "\n"),
        footer = table.concat({
          'Perfer et obdura',
          'dolor hic tibi proderit olim;',
          'Sê paciente e resistente',
          'um dia esta dôr ser-te-á útil'
        }, "\n"),
        query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
      }
    end,
  }

  use 'folke/flash.nvim'

  use 'tpope/vim-fugitive'

  use {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 0,
        files = 0,
        folder_arrows = 0,
      }

      require("nvim-tree").setup {
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
          mappings = {
            list = {
              { key = "u", action = "dir_up" },
            },
          },
          float = {
            enable = true,
            quit_on_focus_loss = true,
          },
        },
        renderer = {
          icons = {
            git_placement = "before",
            modified_placement = "after",
            padding = " ",
            symlink_arrow = "",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = false,
              modified = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              modified = "",
              folder = {
                default = "",
                open = "",
                arrow_closed = "",
                arrow_open = "",

                empty = "",
                empty_open = "",

                symlink = "",
                symlink_open = "",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      }
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        float = {
          border = 'rounded',
        },
      })

      local servers = {
        -- intelephense = {},
        -- eslint = {},
        -- tsserver = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      require('neodev').setup()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument = {
        completion = {
          completionItem = {
            -- snippetSupport = false
          }
        }
      }

      require('mason').setup()

      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            settings = servers[server_name],
          }
        end,
      }

      local lspconfig = require('lspconfig')

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities,
        }
      end
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup {}
      require("luasnip.loaders.from_snipmate").load()

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require("nvim-treesitter.install").update()
      require("nvim-treesitter.configs").setup {
        modules = {},
        ensure_installed = { "c", "vim", "vimdoc", "query", "lua", "php", "dart", "markdown" },
        auto_install = true,
        ignore_install = { "all" },
        sync_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "lua", "php", "dart", "markdown" },
        },
        indent = {
          enable = false,
        },
      }

      local aucmd_dict = {
        FileType = {
          {
            pattern = "php",
            callback = function()
              vim.opt_local.foldenable = false
              vim.opt_local.foldmethod = "expr"
              vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
            end,
          },
          {
            pattern = "lua",
            callback = function()
              vim.cmd([[TSBufEnable indent]])
            end,
          },
        }
      }

      for event, opt_tbls in pairs(aucmd_dict) do
        for _, opt_tbl in pairs(opt_tbls) do
          vim.api.nvim_create_autocmd(event, opt_tbl)
        end
      end
    end,
    -- tag = "v0.9.0", -- pin if some update broken your env
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'stevearc/aerial.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      local actions = require("telescope.actions")
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ["<c-up>"] = actions.cycle_history_prev,
              ["<c-down>"] = actions.cycle_history_next,
              ["<esc>"] = actions.close,
              ["<c-k>"] = actions.move_selection_previous,
              ["<c-j>"] = actions.move_selection_next,
              ["<c-h>"] = actions.file_split,
              ["<c-v>"] = actions.file_vsplit,
              ["<C-/>"] = "which_key"
            },
          },
        },
      }

      require('aerial').setup()
      require('telescope').load_extension "aerial"
    end,
  }
end)

-- Filetypes ------------------------------------------------------------------
local function settab(tabsize)
  vim.bo.tabstop = tabsize
  vim.bo.softtabstop = tabsize
  vim.bo.shiftwidth = tabsize
end

local aucmd_dict = {
  FileType = {
    {
      pattern = "go,php",
      callback = function()
        settab(4)
      end,
    },
    {
      pattern = "lua,dart,rust,javascript,javascriptreact,typescript,typescriptreact",
      callback = function()
        settab(2)
      end,
    },
    {
      pattern = "html,javascriptreact,typescriptreact",
      callback = function()
        local function i(trig, cb)
          vim.cmd("inoremap <buffer> " .. trig .. " " .. cb)
        end
        i('<c-d>', '<esc>"tyiwi<<esc>ea></<esc>"tpa><esc>cit')
        i('<c-d><c-s>', '<esc>bi<<esc>ea /><esc>hi')
        i('<c-d><c-d>', '<esc>"tyiwi<<esc>ea></<esc>"tpa><esc>cit<cr><esc>O')
      end,
    },
    {
      pattern = "markdown,txt,gitcommit",
      callback = function()
        vim.opt_local.iskeyword:append("-")
      end,
    },
    {
      pattern = "php",
      callback = function()
        vim.opt_local.iskeyword:append("$")
      end,
    },
    {
      pattern = "help,lspinfo,qf,startuptime",
      callback = function(opts)
        vim.keymap.set("n", "q", [[<cmd>close<CR>]], { noremap = true, silent = true, buffer = opts.buf })
      end,
    },
  },
}

for event, opt_tbls in pairs(aucmd_dict) do
  for _, opt_tbl in pairs(opt_tbls) do
    vim.api.nvim_create_autocmd(event, opt_tbl)
  end
end

-- Atalhos -------------------------------------------------------------------
local map = function(modes, keys, func)
  vim.keymap.set(modes, keys, func, { noremap = true, silent = true })
end

local nmap = function(keys, func)
  map('n', keys, func)
end

nmap('[d', vim.diagnostic.goto_prev)
nmap(']d', vim.diagnostic.goto_next)

nmap('<c-f>', [[<cmd>Telescope live_grep<CR>]])

nmap('<leader>-', [[<cmd>NvimTreeFindFileToggle<CR>]])
nmap('<leader>=', function()
  if vim.lsp.buf.format then
    vim.lsp.buf.format()
  elseif vim.lsp.buf.formatting then
    vim.lsp.buf.formatting()
  end
end)
nmap('<leader>b', [[<cmd>Telescope buffers<CR>]])
nmap('<leader>ca', vim.lsp.buf.code_action)
nmap('<leader>ee', vim.diagnostic.open_float)
nmap('<leader>eq', vim.diagnostic.setloclist)
nmap('<leader>gg', [[:G<CR>]])
nmap('<leader>f', [[<cmd>Telescope find_files<CR>]])
nmap('<leader>m', [[<cmd>Telescope oldfiles<CR>]])

nmap('gd', vim.lsp.buf.definition)
nmap('gr', function() require('telescope.builtin').lsp_references() end)
nmap('K', vim.lsp.buf.hover)
map({ 'n', 'x', 'o' }, 's', function() require("flash").jump() end)
