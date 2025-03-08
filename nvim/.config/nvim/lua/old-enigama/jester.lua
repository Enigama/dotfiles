local status_ok, jester = pcall(require, "jester")
if not status_ok then
    return
end

jester.setup({
    terminal_cmd = ":split | terminal"
})
