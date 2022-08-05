" Install and run plugins
call plug#begin()
Plug 'sonph/onehalf', { 'rtp': 'vim' }
call plug#end()

" Disable this pesky critter
set mouse=
set ttymouse=

" Ignore case when searching
set ignorecase

" If the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" Automatically re-read file if a change was detected outside of vim
set autoread

" Enable line numbers
set number

" Don't show last command
set noshowcmd

" Yank and paste with the system clipboard
set clipboard=unnamedplus

" Hides buffers instead of closing them
set hidden

" Insert spaces when TAB is pressed.
set expandtab

" Change number of spaces that a <Tab> counts for during editing ops
set softtabstop=4

" Indentation amount for < and > commands.
set shiftwidth=4

" do not wrap long lines by default
set nowrap

" Don't highlight current cursor line
set nocursorline

" Only one line for command line
set cmdheight=1

" Don't give completion messages like 'match 1 of 2' or 'The only match'
set shortmess+=c

" Enable true color support
set termguicolors

" Space as a leader
map <Space> <Leader>

" Fix Y shortcut (behave like C or D)
map Y y$

" Enable spellcheck
autocmd BufRead,BufNewFile *.bbcode setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Better insert mode distinction
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

" Load colors
colorscheme onehalfdark

" Show white characters
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list

" Copy current file
function! CopyCurrentFile(path)
    let path = "%:h/" . a:path
    execute "saveas " . path
    execute "edit " . path
endfunction
command! -bar -nargs=1 Cp call CopyCurrentFile(<q-args>)

" Delete current file
command! Rm call delete(expand('%')) | bdelete!

" Make lowercase aliases
cnoreabbrev cp Cp
cnoreabbrev rm Rm
