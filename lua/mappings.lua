require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("n", "<leader>op", "<cmd> Telescope neovim-project history<CR>", { desc = "Open recent project" })
map("n", "<leader>fp", "<cmd> Telescope neovim-project discover<CR>", { desc = "Discover projects" })
map("n", "<leader>ft", "<cmd> Telescope tags<CR>", { desc = "Find in tags" })
map(
  "n",
  "<leader>fg",
  "<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "Live grep with glob" }
)
map("n", "<leader>X", '<cmd> lua require("nvchad.tabufline").closeAllBufs()<CR>', { desc = "Close all buffers" })
map("n", "<F5>", '<cmd> lua require("dap").continue()<CR>', { desc = "Start debugger / continue" })
map("n", "<F6>", '<cmd> lua require("dap").step_over()<CR>', { desc = "Step over" })
map("n", "<F7>", '<cmd> lua require("dap").step_into()<CR>', { desc = "Step into" })
map("n", "<F8>", '<cmd> lua require("dap").step_out()<CR>', { desc = "Step out" })
map("n", "<leader>db", '<cmd> lua require("dap").toggle_breakpoint()<CR>', { desc = "Toggle breakpoint" })
map("n", "<leader>u", "<cmd> URLOpenUnderCursor<CR>", { desc = "Open URL under cursor" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("i", "<C-J>", "copilot#Accept('<CR>')", { expr = true, silent = true, replace_keycodes = false })
