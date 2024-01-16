-- [x]gcc comment lines
-- s[char] select parenthesis

vim.loader.enable()

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.linebreak = true
vim.wo.number = true
vim.wo.relativenumber = true
-- vim.wo.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.diagnostic.config{
    update_in_insert = true
}

vim.cmd([[
nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>w :wa<CR>
nnoremap <Leader>W :wa<CR>:q<CR>
nnoremap <Leader>r :!cargo r<CR>
autocmd InsertEnter * set norelativenumber
autocmd InsertLeave * set relativenumber
]])

-- vim.diagnostic.update_in_inser = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


--vim.opt.laststatus = 0
require("lazy").setup({
    'nvim-lualine/lualine.nvim',
    'arkav/lualine-lsp-progress',

    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    {'simrat39/rust-tools.nvim', lazy = true},

    'lervag/vimtex',

    'hrsh7th/nvim-cmp', --Engine
    'hrsh7th/cmp-path', --Paths
    'hrsh7th/cmp-nvim-lsp', --From LSP
    'hrsh7th/cmp-nvim-lsp-signature-help', --Inlay hints
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer', -- From surrounding text,
    --'hrsh7th/cmp-vsnip',
    --'hrsh7th/vim-vsnip',
    'micangl/cmp-vimtex',

    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip"},
    },


    {
        'folke/trouble.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons'
    },

    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {}
    },

    {
        'ray-x/lsp_signature.nvim'
    },

    'numToStr/Comment.nvim',
    --'tpope/vim-surround',

    'nvim-treesitter/nvim-treesitter',

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    --{ "ellisonleao/gruvbox.nvim", priority = 1000 },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "hard",
                palette_overrides = {
                    dark0_hard = "#000000",
                },
            })
        end,
    },
    "vimoxide/vim-cinnabar",
    "sainnhe/gruvbox-material"
    -- 'simrat39/inlay-hints.nvim'
})


-- Mason Setup
require("mason").setup({
    --    ui = {
        --        icons = {
            --            package_installed = "",
            --            package_pending = "",
            --            package_uninstalled = "",
            --        },
            --    }
})
require("mason-lspconfig").setup{
    ensure_installed = {"rust_analyzer", "vtsls", "html"}
}
require("lspconfig").vtsls.setup{}
require("lspconfig").html.setup{}
require("lspconfig").omnisharp.setup{}

--Autocomplete
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}

local cmp = require('cmp')


cmp.setup({
    sources = {
        
        { name = 'luasnip', option = { use_show_condition = false } },
        --{name = "luasnip"},
        {name = "path"},
        {name = "nvim_lsp"},
        {name = "nvim_lsp_signature_help"},
        {name = "nvim_lua"},
        --{name = "buffer"},
        --{name = "vsnip"}
    },
    mapping = {
        --['<C-p>'] = cmp.mapping.select_prev_item(),
        --['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                vsnip = '󱘢',
                buffer = '󰊄',
                path = '󰡰',
                nvim_lua = ""
            }
            item.menu = menu_icon[entry.source.name] or "X"
            return item
        end,
    },
    snippet = {
        expand = function(args)
            require'luasnip'.lsp_expand(args.body)
            --vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- completion = {'+'},
        documentation = cmp.config.window.bordered(),
    },
})
--cmp.setup.filetype("tex", {
--    sources = {
--        {name = 'vimtex'},
        --{name = 'buffer'},
 --       {name = 'luasnip'}
--    }
--})

vim.opt.updatetime = 100
vim.cmd([[
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

]])


require "lsp_signature".setup(cfg)



local rt = require("rust-tools")

rt.setup({
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>aa", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<Leader>ar', vim.lsp.buf.rename, {})

local trouble = require("trouble")
vim.keymap.set('n', '<Leader>t', trouble.toggle, {})

--Cosmetic 

require('nvim-treesitter.configs').setup {
    ensure_installed = { "lua", "rust", "toml" },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting=false,
        disable = {"latex"}
    },
    ident = { enable = true }, 
}

require("lualine").setup {
    options = {
        theme = "gruvbox_dark"
    },
    sections = { 
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename', {"lsp_progress"}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}
-- require("inlay-hints").setup()

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#202020 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#101010 gui=nocombine]]

local highlight = {
    "CursorColumn",
    "Whitespace",
}
require("ibl").setup {
}

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

require("Comment").setup()




vim.opt.conceallevel=2
require("luasnip.loaders.from_vscode").lazy_load()

local ls = require'luasnip'
-- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

-- vim.keymap.set({"i", "s"}, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, {silent = true})
