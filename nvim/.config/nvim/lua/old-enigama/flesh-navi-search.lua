local status_ok, flesh = pcall(require, "flesh")
if not status_ok then
	return
end

flesh.setup({})
