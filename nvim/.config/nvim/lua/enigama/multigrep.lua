local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    local finder = finders.new_async_job({
        command_generator = function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            -- Split prompt by two spaces (the "magic" separator)
            local pieces = vim.split(prompt, "  ")
            local args = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            }

            -- args[1] is the search pattern
            if pieces[1] then
                table.insert(args, "-e")
                table.insert(args, pieces[1])
            end

            -- args[2] is the file glob/pattern (e.g., typing "  *.lua")
            if pieces[2] then
                table.insert(args, "-g")
                table.insert(args, pieces[2])
            end

            return args
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    })

    pickers
        .new(opts, {
            debounce = 100,
            prompt_title = "Multi Grep (use 2 spaces to filter files)",
            finder = finder,
            previewer = conf.grep_previewer(opts),
            sorter = require("telescope.sorters").empty(),
        })
        :find()
end

-- Export it if you're putting this in a module
return multigrep
