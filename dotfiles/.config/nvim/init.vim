" Depends: vim-plug
" Requires: npm, ripgrep

scriptencoding utf-8

" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" stop coc version nagging
let g:coc_disable_startup_warning = 1

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.config/nvim/plugged')
" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Quick commenting
Plug 'tpope/vim-commentary'

" Fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Tagbar
Plug 'liuchengxu/vista.vim'

" Change directory to project root
Plug 'airblade/vim-rooter'

" Colorscheme
Plug 'morhetz/gruvbox'

" Motions
Plug 'justinmk/vim-sneak'

" BBCode syntax (no coc plugin)
Plug 'Winseven4lyf/vim-bbcode'

" CSV support
Plug 'mechatroner/rainbow_csv'

" Initialize plugin system
call plug#end()

" ============================================================================ "
" ===                           GENERAL OPTIONS                            === "
" ============================================================================ "

" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
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

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" === Vim Rooter ===
" Where to find project root
let g:rooter_patterns = ['.git/']

" Be quiet about directory change
let g:rooter_silent_chdir = 1

" === FZF === "
" Preview in files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" ripgrep with preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Always show preview
let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" === Coc.nvim === "
" Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Default plugins
let g:coc_global_extensions = [
  \ 'coc-explorer',
  \ 'coc-git',
  \ 'coc-groovy',
  \ 'coc-java',
  \ 'coc-json',
  \ 'coc-markdownlint',
  \ 'coc-phpls',
  \ 'coc-pyright',
  \ 'coc-sh',
  \ 'coc-terminal',
  \ 'coc-tsserver',
  \ 'coc-yaml',
  \ ]

" === Vista (tagbar) ===
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 0

" ============================================================================ "
" ===                            Status Line                               === "
" ============================================================================ "

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, ' E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, ' W' . info['warning'])
  endif
  return join(msgs, ' ') . get(g:, 'coc_status', '')
endfunction

set statusline=
set statusline+=%#GruvboxGreenSign#
set statusline+=\ %F%m%r%h%w\ 
set statusline+=%#IndentGuidesEven#
set statusline+=%=
set statusline+=%{StatusDiagnostic()}
set statusline+=%=
set statusline+=%#GruvboxBlueSign#
set statusline+=%y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Enable true color support
set termguicolors

" Change vertical split character to be a space (essentially hide it)
set fillchars+=vert:.

" Load colors
colorscheme gruvbox

" ============================================================================ "
" ===                      CUSTOM COLORSCHEME CHANGES                      === "
" ============================================================================ "

" Add custom highlights in method that is executed every time a colorscheme is sourced
" See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f for details
function! TrailingSpaceHighlights() abort
  " Hightlight trailing whitespace
  highlight Trail ctermbg=red guibg=red
  call matchadd('Trail', '\s\+$', 100)
endfunction

autocmd! ColorScheme * call TrailingSpaceHighlights()

" Editor theme
set background=dark

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" Space as a leader
map <Space> <Leader>

" Create mappings for function and class text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Ctrl+hjkl moves splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Fix Y shortcut (behave like C or D)
map Y y$

" Basic go to X shortcuts
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gy <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" FZF gotos
nmap <silent> gh :History<CR>
nmap <silent> gb :Buffers<CR>
nmap <silent> gf :Files<CR>

" Leader shortcuts
nmap <silent> <leader>a <Plug>(coc-codeaction)
nmap <silent> <leader>b :!./gradlew runGameWithBuild<CR>
nmap <silent> <leader>f <Plug>(coc-format)
xmap <silent> <leader>f <Plug>(coc-format-selected)
nmap <silent> <leader>e :CocCommand explorer<CR>
nmap <silent> <leader>h :noh<CR>
nmap <silent> <leader>o :CocCommand editor.action.organizeImport<CR>
nmap <silent> <leader>r <Plug>(coc-rename)
nmap <silent> <leader>s :w<CR>
nmap <silent> <leader>t :Vista!!<CR>
nmap <silent> <leader>q :bd<CR>
nmap <silent> <leader>x :CocFix<CR>
nmap <silent> <leader>w :noa w<CR>

" Terminal
imap <silent> <F1> <Plug>(coc-terminal-toggle)
nmap <silent> <F1> <Plug>(coc-terminal-toggle)
tnoremap <silent> <F1> exit<CR>

" ============================================================================ "
" ===                                 MISC.                                === "
" ============================================================================ "

" Enable spellcheck
autocmd BufRead,BufNewFile *.bbcode setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif

" Don't put backups in current dir
set backupdir=~/.local/share/nvim/backup
set backup
set noswapfile

" Better insert mode distinction
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

" Show white characters
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list

" For Windows - yank copies to clipboard as well
autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | clip.exe')

" Fix coc-explorer floating window background
hi CocExplorerNormalFloat guibg=Default

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
cnoreabbrev rg Rg
cnoreabbrev rm Rm

" Ignore ^M
match Ignore /\r$/
