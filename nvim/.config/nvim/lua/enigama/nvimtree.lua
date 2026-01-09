local M = {
    "nvim-tree/nvim-tree.lua",
    -- event = "VeryLazy",
}

function M.config()
    local wk = require("which-key")
    wk.add({
        { "<leader>e",  "<cmd>NvimTreeToggle<CR>",         desc = "Explorer" },
        { "<leader>lf", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Explorer focuse on file" },
        { "<leader>lr", "<cmd>NvimTreeRefresh<CR>",        desc = "Explorer refresh" },
        { "<leader>lo", "<cmd>NvimTreeFocus<CR>",          desc = "Explorer focuse" },
    })

    local icons = require("enigama.icons")

    local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Apply all default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom overrides for vim-style navigation
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
    end

    require("nvim-tree").setup({
        on_attach = on_attach,
        hijack_netrw = false,
        sync_root_with_cwd = true,
        view = {
            width = 60,
            relativenumber = true,
        },
        live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = false, -- Turn into false from true by default
        },
        renderer = {
            add_trailing = false,
            group_empty = false,
            highlight_git = false,
            full_name = false,
            highlight_opened_files = "none", -- `"none"`, `"icon"`, `"name"` or `"all"`.
            root_folder_label = ":t",
            indent_width = 2,
            indent_markers = {
                enable = false,
                inline_arrows = true,
                icons = {
                    corner = "└",
                    edge = "│",
                    item = "│",
                    none = " ",
                },
            },
            icons = {
                git_placement = "before",
                padding = " ",
                symlink_arrow = " ➛ ",
                glyphs = {
                    default = icons.ui.Text,
                    symlink = icons.ui.FileSymlink,
                    bookmark = icons.ui.BookMark,
                    folder = {
                        arrow_closed = icons.ui.ChevronRight,
                        arrow_open = icons.ui.ChevronShortDown,
                        default = icons.ui.Folder,
                        open = icons.ui.FolderOpen,
                        empty = icons.ui.EmptyFolder,
                        empty_open = icons.ui.EmptyFolderOpen,
                        symlink = icons.ui.FolderSymlink,
                        symlink_open = icons.ui.FolderOpen,
                    },
                    git = {
                        unstaged = icons.git.FileUnstaged,
                        staged = icons.git.FileStaged,
                        unmerged = icons.git.FileUnmerged,
                        renamed = icons.git.FileRenamed,
                        untracked = icons.git.FileUntracked,
                        deleted = icons.git.FileDeleted,
                        ignored = icons.git.FileIgnored,
                    },
                },
            },
            special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
            symlink_destination = true,
        },
        update_focused_file = {
            enable = true,
            debounce_delay = 15,
            update_root = true,
            ignore_list = {},
        },

        diagnostics = {
            enable = true,
            show_on_dirs = false,
            show_on_open_dirs = true,
            debounce_delay = 50,
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
            icons = {
                hint = icons.diagnostics.BoldHint,
                info = icons.diagnostics.BoldInformation,
                warning = icons.diagnostics.BoldWarning,
                error = icons.diagnostics.BoldError,
            },
        },
    })
end

return M
