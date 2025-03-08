local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
    return
end

trouble.setup({
    position = "bottom",
use_diagnostic_signs = true
})
