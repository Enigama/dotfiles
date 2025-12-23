local M = {}

-- Create git worktree and open in new tmux window
function M.create_worktree(issue, prompt_bufnr, actions)
  local key = issue.key
  
  -- Close telescope picker
  actions.close(prompt_bufnr)
  
  -- Check if we're in tmux
  local tmux_env = vim.fn.getenv("TMUX")
  if tmux_env == vim.NIL or tmux_env == "" then
    vim.notify("Not running in tmux. This feature requires tmux.", vim.log.levels.ERROR)
    return
  end
  
  -- Check if we're in a git repository
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end
  
  -- Worktree configuration
  local worktrees_dir = vim.fn.expand("~/Projects/worktrees")
  local worktree_path = worktrees_dir .. "/" .. key
  
  -- Check if worktree already exists
  local worktree_exists = vim.fn.isdirectory(worktree_path) == 1
  
  if worktree_exists then
    -- Find existing tmux window with this name
    local windows_output = vim.fn.system("tmux list-windows -F '#{window_name}'")
    local window_exists = false
    
    for window_name in windows_output:gmatch("[^\r\n]+") do
      if window_name == key then
        window_exists = true
        break
      end
    end
    
    if window_exists then
      -- Switch to existing window
      vim.fn.system(string.format("tmux select-window -t '%s'", key))
      if vim.v.shell_error == 0 then
        vim.notify("Switched to existing worktree window: " .. key, vim.log.levels.INFO)
      else
        vim.notify("Failed to switch to window: " .. key, vim.log.levels.ERROR)
      end
    else
      -- Worktree exists but window doesn't, create new window
      local cmd = string.format([[
        tmux new-window -n '%s' -c '%s' \; \
        send-keys 'nvim' C-m
      ]], key, worktree_path)
      
      vim.notify("Opening existing worktree in new window: " .. key, vim.log.levels.INFO)
      vim.fn.system(cmd)
      
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to create tmux window", vim.log.levels.ERROR)
      end
    end
  else
    -- Create new worktree first (while we're in the git repo)
    vim.notify("Creating worktree for " .. key .. "...", vim.log.levels.INFO)
    
    local worktree_cmd = string.format("git worktree add -b %s %s", key, worktree_path)
    local result = vim.fn.system(worktree_cmd)
    
    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to create worktree: " .. result, vim.log.levels.ERROR)
      return
    end
    
    -- Now create tmux window in the new worktree directory
    local cmd = string.format([[
      tmux new-window -n '%s' -c '%s' \; \
      send-keys 'nvim' C-m
    ]], key, worktree_path)
    
    vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
      vim.notify("Worktree created in new tmux window: " .. key, vim.log.levels.INFO)
    else
      vim.notify("Failed to create tmux window (but worktree was created)", vim.log.levels.WARN)
    end
  end
end

return M

