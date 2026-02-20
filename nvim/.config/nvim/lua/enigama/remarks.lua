local M = {
    "https://github.com/Enigama/remarks.nvim",
    -- branch = "attach-context",
    -- dir = "~/Personal/remarks.nvim",
}

--- Create telescope picker for remarks
---@param remarks table[] List of remarks
---@param opts { commit: string|nil } Options
local function telescope_picker(remarks, opts)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local previewers = require("telescope.previewers")

    pickers
        .new({}, {
            prompt_title = "Remarks",
            finder = finders.new_table({
                results = remarks,
                entry_maker = function(remark)
                    -- Extract first line of body as preview
                    local preview = remark.body:match("^[^\r\n]+") or ""
                    if #preview > 50 then
                        preview = preview:sub(1, 47) .. "..."
                    end

                    local display = string.format(
                        "[%s] %s: %s%s",
                        remark.id,
                        remark.type,
                        preview,
                        remark.is_head and " (HEAD)" or ""
                    )
                    return {
                        value = remark,
                        display = display,
                        ordinal = display,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            previewer = previewers.new_buffer_previewer({
                title = "Remark",
                define_preview = function(self, entry)
                    local remark = entry.value
                    local lines = {
                        "id: " .. remark.id,
                        "type: " .. remark.type,
                        "commit: " .. remark.sha,
                        "age: " .. remark.age,
                        "",
                        "---",
                        "",
                    }
                    for line in remark.body:gmatch("[^\r\n]+") do
                        table.insert(lines, line)
                    end
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                    vim.bo[self.state.bufnr].filetype = "yaml"
                end,
            }),
            attach_mappings = function(prompt_bufnr, map)
                -- <CR> - Edit selected remark
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        require("remarks.buffer").edit_remark(selection.value)
                    end
                end)

                -- d / x - Resolve (delete) selected remark
                local resolve_action = function()
                    local selection = action_state.get_selected_entry()
                    if selection then
                        local remark = selection.value
                        vim.ui.select({ "Yes", "No" }, {
                            prompt = "Resolve remark [" .. remark.id .. "]?",
                        }, function(choice)
                            if choice == "Yes" then
                                local result = require("remarks.git").resolve(remark.id)
                                if result.success then
                                    vim.notify("Resolved [" .. remark.id .. "]", vim.log.levels.INFO)
                                    actions.close(prompt_bufnr)
                                    -- Reopen picker to refresh
                                    vim.schedule(function()
                                        require("remarks.picker").pick_remarks(opts)
                                    end)
                                else
                                    vim.notify(
                                        "Failed to resolve: " .. (result.error or "unknown"),
                                        vim.log.levels.ERROR
                                    )
                                end
                            end
                        end)
                    end
                end

                map("i", "<C-d>", resolve_action)
                map("n", "d", resolve_action)
                map("n", "x", resolve_action)

                -- a - Add new remark
                local add_action = function()
                    actions.close(prompt_bufnr)
                    require("remarks.buffer").quick_add()
                end

                map("i", "<C-a>", add_action)
                map("n", "a", add_action)

                -- <C-t> - Edit in new tab
                local edit_in_tab = function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        require("remarks.buffer").edit_remark(selection.value, { style = "tab" })
                    end
                end

                map("i", "<C-t>", edit_in_tab)
                map("n", "<C-t>", edit_in_tab)

                -- <C-e> - Edit with visual selection context
                local edit_with_context = function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        require("remarks.buffer").edit_remark(selection.value, { include_visual_context = true })
                    end
                end

                map("i", "<C-e>", edit_with_context)
                map("n", "<C-e>", edit_with_context)

                return true
            end,
        })
        :find()
end

local function fzf_picker(remarks, opts)
    local fzf = require("fzf-lua")
    local builtin = require("fzf-lua.previewer.builtin")

    local entries = {}
    local remark_map = {}
    for _, remark in ipairs(remarks) do
        local display = string.format(
            "[%s] %s · %s · %s%s",
            remark.id,
            remark.type,
            remark.age,
            remark.sha,
            remark.is_head and " (HEAD)" or ""
        )
        table.insert(entries, display)
        remark_map[display] = remark
    end

    -- Custom previewer using fzf-lua's builtin base
    local RemarksPreviewer = builtin.base:extend()

    function RemarksPreviewer:new(o, fzf_opts, fzf_win)
        RemarksPreviewer.super.new(self, o, fzf_opts, fzf_win)
        setmetatable(self, RemarksPreviewer)
        return self
    end

    function RemarksPreviewer:populate_preview_buf(entry_str)
        local remark = remark_map[entry_str]
        if not remark then
            return
        end

        local lines = {
            "id: " .. remark.id,
            "type: " .. remark.type,
            "commit: " .. remark.sha,
            "age: " .. remark.age,
            "",
            "---",
            "",
        }
        for line in remark.body:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local bufnr = self:get_tmp_buffer()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.bo[bufnr].filetype = "yaml"
        self:set_preview_buf(bufnr)
        if self.win and self.win.update_scrollbar then
            self.win:update_scrollbar()
        end
    end

    fzf.fzf_exec(entries, {
        prompt = "Remarks> ",
        previewer = RemarksPreviewer,
        actions = {
            ["default"] = function(selected)
                if selected[1] then
                    local remark = remark_map[selected[1]]
                    require("remarks.buffer").edit_remark(remark)
                end
            end,
            ["ctrl-d"] = function(selected)
                if selected[1] then
                    local remark = remark_map[selected[1]]
                    local result = require("remarks.git").resolve(remark.id)
                    if result.success then
                        vim.notify("Resolved [" .. remark.id .. "]", vim.log.levels.INFO)
                        vim.schedule(function()
                            require("remarks.picker").pick_remarks(opts)
                        end)
                    end
                end
            end,
        },
    })
end

local function mini_picker(remarks, opts)
    local MiniPick = require("mini.pick")

    local items = vim.tbl_map(function(remark)
        return {
            text = string.format(
                "[%s] %s · %s · %s%s",
                remark.id,
                remark.type,
                remark.age,
                remark.sha,
                remark.is_head and " (HEAD)" or ""
            ),
            remark = remark,
        }
    end, remarks)

    MiniPick.start({
        source = {
            items = items,
            name = "Remarks",
            choose = function(item)
                if item then
                    vim.schedule(function()
                        require("remarks.buffer").edit_remark(item.remark)
                    end)
                end
            end,
        },
    })
end

local function snacks_picker(remarks, opts)
    local items = vim.tbl_map(function(remark)
        return {
            text = string.format(
                "[%s] %s · %s · %s%s",
                remark.id,
                remark.type,
                remark.age,
                remark.sha,
                remark.is_head and " (HEAD)" or ""
            ),
            remark = remark,
        }
    end, remarks)

    require("snacks").picker({
        items = items,
        title = "Remarks",
        format = function(item)
            return { { item.text } }
        end,
        preview = function(ctx)
            local remark = ctx.item.remark
            local lines = {
                "id: " .. remark.id,
                "type: " .. remark.type,
                "commit: " .. remark.sha,
                "age: " .. remark.age,
                "",
                "---",
                "",
            }
            for line in remark.body:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end
            vim.bo[ctx.buf].modifiable = true
            vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
            vim.bo[ctx.buf].filetype = "yaml"
        end,
        confirm = function(picker, item)
            picker:close()
            if item then
                require("remarks.buffer").edit_remark(item.remark)
            end
        end,
    })
end

M.config = function()
    local wk = require("which-key")
    wk.add({
        { "<leader>nl", "<cmd>Remarks<cr>",        desc = "List Remarks" },
        { "<leader>na", "<cmd>RemarksAdd<cr>",     desc = "Add Remark" },
        { "<leader>nf", "<cmd>RemarksAddFull<cr>", desc = "Add Remark (Full)" },
        { "<leader>ns", "<cmd>RemarksShow<cr>",    desc = "Show Remarks on Commit" },
    })

    -- Also register for visual mode to ensure it works after selection
    -- Use <Esc> to exit visual mode first, then run the command
    vim.keymap.set(
        "v",
        "<leader>na",
        "<Esc><cmd>RemarksAdd<cr>",
        { desc = "Add Remark", noremap = true, silent = true }
    )
    vim.keymap.set(
        "v",
        "<leader>nf",
        "<Esc><cmd>RemarksAddFull<cr>",
        { desc = "Add Remark (Full)", noremap = true, silent = true }
    )
    vim.keymap.set("v", "<leader>nl", "<Esc><cmd>Remarks<cr>", { desc = "List Remarks", noremap = true, silent = true })

    require("remarks").setup({
        picker = telescope_picker,
    })
end

return M
