local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
        -- My plugins here
        use "wbthomason/packer.nvim" -- Have packer manage itself
        use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
        use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
        use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
        use "numToStr/Comment.nvim" -- Easily comment stuff
        --use "folke/todo-comments.nvim"
        use "opalmay/vim-smoothie"
        use "petertriho/nvim-scrollbar"
        use "christianchiarulli/nvim-ts-autotag"
        use "kyazdani42/nvim-web-devicons"
        use "kyazdani42/nvim-tree.lua"
        use 'nvim-lualine/lualine.nvim'
        use "lewis6991/impatient.nvim"
        use "akinsho/toggleterm.nvim"
        use "ghillb/cybu.nvim"
        use "folke/zen-mode.nvim"

        use "j-hui/fidget.nvim"
        use {
            "ggandor/leap.nvim",
            config = function() require("leap").set_default_keymaps() end
        }
        -- Show the help when navigate by f/F but takes the t/T which is not cool
        -- use {
        --     "jinh0/eyeliner.nvim",
        --     config = function()
        --         require("eyeliner").setup {
        --             highlight_on_key = true,
        --         }
        --     end,
        -- }
        use "MattesGroeger/vim-bookmarks"

        --Testing plugin
        -- use {
        --     "0x100101/lab.nvim",
        --     build = "cd js && npm ci",
        -- }

        -- Colorscheme
        -- use "marko-cerovac/material.nvim"
        use 'folke/tokyonight.nvim'
        -- use "tomasiser/vim-code-dark"

        -- cmp plugins
        use "hrsh7th/nvim-cmp" -- The completion plugin
        use "hrsh7th/cmp-buffer" -- buffer completions
        use "hrsh7th/cmp-path" -- path completions
        use "hrsh7th/cmp-cmdline" -- cmdline completions
        use "saadparwaiz1/cmp_luasnip" -- snippet completions
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-nvim-lua"

        -- snippets
        use "L3MON4D3/LuaSnip" --snippet engine
        use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

        -- LSP
        use "neovim/nvim-lspconfig" -- enable LSP
        use "williamboman/nvim-lsp-installer" -- simple to use language server installer
        use "williamboman/mason.nvim"
        use { "williamboman/mason-lspconfig.nvim" }
        use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
        use { "RRethy/vim-illuminate" }

        -- Formating
        use "sbdchd/neoformat";

        -- Telescope
        use "nvim-telescope/telescope.nvim"
        use 'nvim-telescope/telescope-media-files.nvim'

        -- Harpoon
        use "ThePrimeagen/harpoon"

        -- Treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
        }
        use "nvim-treesitter/playground"
        use "p00f/nvim-ts-rainbow"
        use 'JoosepAlviste/nvim-ts-context-commentstring'

        -- Git
        use "lewis6991/gitsigns.nvim"
        use "ThePrimeagen/git-worktree.nvim"
        use "tpope/vim-fugitive"
        -- use "TimUntersberger/neogit"
        use 'sindrets/diffview.nvim'


        -- Degugin
        use { "mfussenegger/nvim-dap" }
        use { "rcarriga/nvim-dap-ui" }
        use { "theHamsta/nvim-dap-virtual-text" }

        -- Quickfix bar
        use "kevinhwang91/nvim-bqf"

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if PACKER_BOOTSTRAP then
            require("packer").sync()
        end
    end)
