return {
  cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/tflint"), "--langserver" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git", ".tflint.hcl" },
}
