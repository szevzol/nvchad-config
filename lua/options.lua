require "nvchad.options"

-- Powershell settings
-- vim.cmd("set shell=pwsh.exe")
-- vim.cmd("set shellxquote=")
-- vim.cmd("let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '")
-- vim.cmd("let &shellquote   = ''")
-- vim.cmd("let &shellpipe    = '| Out-File -Encoding UTF8 %s'")
vim.opt.sh = "nu"
vim.opt.shellredir = "| save %s"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- Jenkinsfile/groovy settings
vim.cmd "au BufNewFile,BufRead Jenkinsfile setf groovy"
vim.cmd "autocmd FileType groovy setlocal shiftwidth=4 softtabstop=4 expandtab"

-- posh-direnv syntax highlight
vim.cmd "au BufNewFile,BufRead .psenvrc setf ps1"

-- Mappings to get rid of "stuck" shift effect
vim.cmd "command! Q quit"
vim.cmd "command! Qa quitall"
vim.cmd "command! QA quitall"
vim.cmd "command! W write"

-- Help to use some movement commands in normal mode with Hungarian keyboard
vim.cmd "map ő ["
vim.cmd "map ú ]"

-- folding settings
vim.cmd "set nofoldenable"

-- set treesitter folding for every filtype that has a
-- treesitter parser
vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.opt.foldmethod = "syntax"
    end
  end,
})

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
vim.keymap.set("n", "<F5>", "<cmd> lua require('dap').continue()<CR>")
vim.keymap.set("n", "<F10>", "<cmd> lua require('dap').step_over()<CR>")
vim.keymap.set("n", "<F11>", "<cmd> lua require('dap').step_into()<CR>")
vim.keymap.set("n", "<F12>", "<cmd> lua require('dap').step_out()<CR>")

local toggle_diagnostics = function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "Toggle Diagnostics" })
