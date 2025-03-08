local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")
local notify_utils = require("enigama/notify-utils")

daptext.setup()
dapui.setup({
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
        icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            -- run_last = '▶▶',
            terminate = '',
            disconnect = "⏏",
        },
    },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    element_mappings = {},
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    force_buffers = true,
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 0.25, -- Can be float or integer > 1
                },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 10,
            position = "bottom", -- Can be "bottom" or "top"
        },
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            ["close"] = { "q", "<Esc>" },
        },
    },
    render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
        indent = 1,
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
    local notif_data = notify_utils.get_notif_data("dap", body.progressId)

    local message = notify_utils.format_message(body.message, body.percentage)
    notif_data.notification = vim.notify(message, "info", {
            title = notify_utils.format_title(body.title, session.config.type),
            icon = notify_utils.spinner_frames[1],
            timeout = false,
            hide_from_history = false,
        })

    notif_data.notification.spinner = 1,
        notify_utils.update_spinner("dap", body.progressId)
end

dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
    local notif_data = notify_utils.get_notif_data("dap", body.progressId)
    notif_data.notification = vim.notify(notify_utils.format_message(body.message, body.percentage), "info", {
            replace = notif_data.notification,
            hide_from_history = false,
        })
end

dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
    local notif_data = notify_utils.client_notifs["dap"][body.progressId]
    notif_data.notification = vim.notify(body.message and notify_utils.format_message(body.message) or "Complete", "info",
            {
                icon = "",
                replace = notif_data.notification,
                timeout = 3000
            })
    notif_data.spinner = nil
end

-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     pattern = "\\[dap-repl\\]",
--     callback = vim.schedule_wrap(function(args)
--         vim.api.nvim_set_current_win(vim.fn.bufwinid(args.buf))
--     end)
-- })

require("enigama.node");
