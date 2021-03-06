syntax on
set shiftwidth=4
set tabstop=4
set expandtab
set number
set relativenumber
" useful im termux
set mouse=
set showcmd
set noequalalways
"set cursorline
"set cursorcolumn
set wildmenu
set showmatch
set incsearch
set hlsearch
set scrolloff=32
set foldmethod=syntax
set nofoldenable
set foldlevel=2
"set cursorline
"set colorcolumn=120
"set t_Co=16
"color settings
"set termguicolors
colorscheme void
set splitbelow
set splitright
"set colorcolumn=160

" terminal settings
au TermOpen * setlocal nonumber norelativenumber

"netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 24
"let g:netrw_preview = 1

" custom keys
nmap <silent> <M-t> :execute('tabnew')<CR>
nmap <silent> <M-T> :execute('tabclose')<CR>
nmap <silent> <M-n> :execute('tabnext')<CR>
nmap <silent> <M-p> :execute('tabprev')<CR>

" add save and quit custom key
nmap <silent> <M-q> :execute('qa')<CR>
nmap <silent> <M-x> :execute('wqa')<CR>

" basic session support
function! MakeSession()
    if (len(argv()) > 0)
        return
    endif

    let l:sessiondir = $HOME . "/.cache/vim/sessions" . getcwd()
    if (filewritable(l:sessiondir) != 2)
        exe 'silent !mkdir -p ' l:sessiondir
        redraw!
    endif
    let l:filename = l:sessiondir . '/session.vim'
    exe "mksession! " . l:filename
endfunction

function! LoadSession()

    if (len(argv()) > 0)
        return
    endif

    let l:sessiondir = $HOME . "/.cache/vim/sessions" . getcwd()
    let l:sessionfile = l:sessiondir . "/session.vim"
    if (filereadable(l:sessionfile))
        " source the session
        exe 'source ' l:sessionfile
        let [i, n; empty] = [1, bufnr('$')]
        " enumerate all empty buffers with no changes
        while i <= n
            if bufexists(i) && bufname(i) == ''
                call add(empty, i)
            endif
            let i += 1
        endwhile
        " delete all empty buffers
        if len(empty) > 0
            exe 'bdelete' join(empty)
        endif
    else
        echo "No session loaded."
    endif
endfunction

" Adding automatons for when entering or leaving Vim
au VimEnter * nested :call LoadSession()
au VimLeave * :call MakeSession()

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'fabi1cazenave/suckless.vim'
Plug 'fabi1cazenave/termopen.vim'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "completion framework
Plug 'Shougo/neoinclude.vim' "c include completion
Plug 'neomake/neomake' "cmake runner
Plug 'Raimondi/delimitMate' "auto closing tag insertion
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' "snippets
Plug 'zchee/deoplete-zsh' "zsh completion
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'racer-rust/vim-racer'
Plug 'timonv/vim-cargo'
Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
Plug 'phpactor/phpactor' ,  { 'for': 'php', 'do': 'composer install'}
Plug 'kristijanhusak/deoplete-phpactor'
Plug 'deoplete-plugins/deoplete-jedi'
call plug#end()

"suckless settings

let g:suckless_tmap = 1            " work in terminal insert mode
let g:suckless_tabline = 1
let g:suckless_min_width = 24      " minimum window width
let g:suckless_inc_width = 1       " width increment
let g:suckless_inc_height = 1      " height increment

let g:suckless_mappings = {
\        '<M-[sdf]>'      :   'SetTilingMode("[sdf]")'    ,
\        '<M-[hjkl]>'     :    'SelectWindow("[hjkl]")'   ,
\        '<M-[HJKL]>'     :      'MoveWindow("[hjkl]")'   ,
\      '<C-M-[hjkl]>'     :    'ResizeWindow("[hjkl]")'   ,
\        '<M-[Oo]>'       :    'CreateWindow("[sv]")'     ,
\        '<M-w>'          :     'CloseWindow()'           ,
\   '<M-[123456789]>' :       'SelectTab([123456789])',
\  '<Leader>t[123456789]' : 'MoveWindowToTab([123456789])',
\  '<Leader>T[123456789]' : 'CopyWindowToTab([123456789])',
\}

"term open settings
"open a terminal
nmap <M-Return> :call TermOpen('','v')<CR>
nmap <M-Backspace> :call TermOpen('')<CR>
nmap <Leader>l :call TermOpen('lua')<CR>
nmap <Leader>L :call TermOpen('lua', 'v')<CR>
"deoplete settings

let g:deoplete#enable_at_startup = 1


"neoinclude settings

let g:neoinclude#paths={}
let g:neoinclude#paths.c = '/usr/include'
let g:neoinclude#paths.cpp = '/usr/include'

"neomake settings

call neomake#configure#automake('nrw')
let g:neomake_open_list = 2

"delimitMate settings

"set matching pairs by default and then by file type
let b:delimitMate_matchpairs = "(:),[:],{:}"
au FileType html,xml, let b:delimitMate_matchpairs = "(:),[:],{:},<:>"

"set quote symbols
let delimitMate_quotes = "\" ' `"
au FileType vim let b:delimitMate_quotes = "' `"

"nestable quotes
let delimitMate_nesting_quotes = ['"']

"set expansion of delimiters with carrage return
let delimitMate_expand_cr = 2
"same but for spaces
let delimitMate_expand_space = 1

"balance matching pairs
let delimitMate_balance_matchpairs = 1

"ultisnips settings

let g:UltiSnipsEditSplit = "horizontal"

let g:UltiSnipsSnippetsDir = "~/.config/nvim/plugged/vim-snippets/UltiSnips"

" Trigger configuration.
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsListTrigger="<c-e>"


"language server
set hidden

let g:LanguageClient_serverCommands = {
    \ 'c': ['/usr/bin/clangd'],
    \ 'cpp': ['/usr/bin/clangd']
    \ }


"racer
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1
augroup Racer
    autocmd!
    autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
    autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <buffer> gt         <Plug>(rust-def-tab)
    autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
    autocmd FileType rust nmap <buffer> <leader>gD <Plug>(rust-doc-tab)
augroup END
