-- General
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.scrolloff = 16
vim.opt.wrap = false

-- Stops help opening on top and instead to the right
vim.opt.splitright = true
vim.cmd('cnoreabbrev help vert help')

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>r', ':write<CR> :source ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':bdelete<CR>')
vim.keymap.set('n', '<leader>Q', ':quit<CR>')

-- Style
vim.pack.add({
  { src = 'https://github.com/navarasu/onedark.nvim' },
})

require('onedark').setup {
  style = 'darker'
}

vim.cmd('colorscheme onedark')
vim.cmd(':hi statusline guibg=NONE')

-- Tabs/Spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- General Style Settings
vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'

-- Plugins
vim.pack.add({
  { src = 'https://github.com/stevearc/oil.nvim' },

  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },

  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },

  { src = 'https://github.com/nvim-mini/mini.pick' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.tabline' },
  { src = 'https://github.com/nvim-mini/mini.comment' },
  { src = 'https://github.com/nvim-mini/mini.diff' },
})

-- Mason
require('mason').setup()

-- LSP
vim.lsp.enable({
  'lua_ls',
  'bashls',
  'terraformls',
  'efm',
})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end
})
vim.cmd('set completeopt+=noselect')

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})
vim.opt.updatetime = 500

-- Oil
require('oil').setup()
vim.keymap.set('n', '<leader>e', ':Oil<CR>')

-- Treesitter
require('nvim-treesitter').setup({
  ensure_installed = {
    'go',
    'lua',
    'markdown',
    'python',
    'terraform',
  },
  highlight = {
    enable = true,
  },
})


-- mini.pick N.B: This is done a bit differently due to the registry change
local MiniPick = require('mini.pick')
MiniPick.setup()

MiniPick.registry.help = function()
  return MiniPick.builtin.help({ default_split = 'vertical' })
end

vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>m', ':Pick help<CR>')
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')

-- mini.comment
require('mini.comment').setup()

-- mini.diff
require('mini.diff').setup()

-- mini.icons
require('mini.icons').setup()

-- mini.tabline
require('mini.tabline').setup()
