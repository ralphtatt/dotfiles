return {
  cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/terraform-ls"), "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
}
