-- Colorscheme
lvim.colorscheme = "kanagawa-wave"

lvim.builtin.which_key.mappings["t"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" }
lvim.keys.normal_mode["<C-e>"] = "$"
lvim.keys.normal_mode["<C-a>"] = "^"
lvim.keys.insert_mode["jk"] = "<Esc>"
vim.opt.relativenumber = true
lvim.lsp.automatic_servers_installation = false
lvim.lsp.installer.setup.automatic_installation = false
lvim.plugins = {
  "rebelot/kanagawa.nvim",
  {
    "Exafunction/codeium.vim",
    config = function()
      vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true })
    end
  }
}
