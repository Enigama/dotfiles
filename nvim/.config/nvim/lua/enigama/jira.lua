return {
    "Enigama/jira.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "3rd/image.nvim",
    },
    config = function()
        local jira = require("jira")
        local jira_handlers = require("enigama.jira_handlers")

        -- Read Jira URL from environment variable (set by fish config)
        local jira_url = os.getenv("JIRA_URL")

        -- Fallback: read from file if env var not set
        if not jira_url or jira_url == "" then
            local url_file = io.open(vim.fn.expand("~/.config/JIRA_URL"), "r")
            if url_file then
                jira_url = url_file:read("*a"):match("^%s*(.-)%s*$")
                url_file:close()
            end
        end

        -- Only setup if URL is available (work environment)
        if not jira_url or jira_url == "" then
            return
        end

        jira.setup({
            jira_url = jira_url, -- INFO: No need to place hardcoded URL here anymore
            cache_dir = vim.fn.stdpath("cache") .. "/jira",
            default_project = nil,
            max_results = 10,
            auto_refresh_interval = 300, -- 5 minutes
            status_filters = {
                "Blocked",
                "Backlog",
                "Ready for Dev",
                "In Progress",
                "In Review",
                "Merged",
                "Ready for QA",
                "All",
            },
            default_status = "In Progress",
            -- Custom telescope mappings
            telescope_mappings = {
                ["<C-x>"] = jira_handlers.create_worktree,
            },
        })
    end,
    lazy = true,
    cmd = {
        "JiraAuth",
        "JiraSearch",
        "JiraIssue",
        "JiraMyIssues",
        "JiraProject",
        "JiraProjects",
        "JiraLogout",
        "JiraClearCache",
        "JiraTestAuth",
        "JiraRecent",
    },
    keys = {
        { "<leader>js", "<cmd>JiraSearch<cr>",     desc = "Jira: Search" },
        { "<leader>ji", "<cmd>JiraMyIssues<cr>",   desc = "Jira: My Issues" },
        { "<leader>jp", "<cmd>JiraProjects<cr>",   desc = "Jira: Projects" },
        { "<leader>ja", "<cmd>JiraAuth<cr>",       desc = "Jira: Authenticate" },
        { "<leader>jl", "<cmd>JiraLogout<cr>",     desc = "Jira: Logout" },
        { "<leader>jc", "<cmd>JiraClearCache<cr>", desc = "Jira: Clear Cache" },
        { "<leader>jr", "<cmd>JiraRecent<cr>",     desc = "Jira: Recent" },
    },
}
