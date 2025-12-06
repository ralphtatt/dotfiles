-- Basic settings
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.tabstop = 2                -- 2 spaces per tab
vim.opt.shiftwidth = 2             -- 2 spaces for indentation
vim.opt.softtabstop = 2            -- 2 spaces in insert mode
vim.opt.smartindent = true         -- Smart indentation
vim.opt.wrap = false               -- Don't wrap long lines
vim.opt.ignorecase = true          -- Case insensitive search
vim.opt.smartcase = true           -- Unless uppercase in search
vim.opt.termguicolors = true       -- True color support
vim.opt.cursorline = true          -- Highlight current line
vim.opt.splitbelow = true          -- New horizontal split below
vim.opt.splitright = true          -- New vertical split right
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Key mappings
vim.g.mapleader = " "

-- Clear search highlights
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true })
