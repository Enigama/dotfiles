local M = {
    "pwntester/octo.nvim",
    -- commit = "e0e4326893efb3da9ab584c99ec907bd82ad8570", -- not working "e27ab3cb4d2087c835a82e720ba9640beac5c74b", --Working commit- "e0e4326893efb3da9ab584c99ec907bd82ad8570",
}

function M.config()
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap("n", "<leader>pr", ":Octo pr create<CR>", opts)
    keymap("n", "<leader>cp", ":Octo pr checks<CR>", opts)
    keymap("n", "<leader>pl", ":Octo pr list checks<CR>", opts)

    require("octo").setup({
        suppress_missing_scope = {
            projects_v2 = true,
        },
        commands = {
            pr = {
                auto = function()
                    local gh = require("octo.gh")
                    local picker = require("octo.picker")
                    local utils = require("octo.utils")

                    local buffer = utils.get_current_buffer()

                    local auto_merge = function(number)
                        local cb = function()
                            utils.info("This PR will be auto-merged")
                        end
                        local opts = { cb = cb }
                        gh.pr.merge({ number, auto = true, squash = true, opts = opts })
                    end

                    if not buffer or not buffer:isPullRequest() then
                        picker.prs({
                            cb = function(selected)
                                auto_merge(selected.obj.number)
                            end,
                        })
                    elseif buffer:isPullRequest() then
                        auto_merge(buffer.node.number)
                    end
                end,
            },
        },
    })
end

return M
