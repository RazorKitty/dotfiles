syntax on
set shiftwidth=4
set tabstop=4
set expandtab
set number
set relativenumber
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
"set t_Co=16
"color settings
set termguicolors
colorscheme void
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
"set colorcolumn=160

" terminal settings
au TermOpen * setlocal nonumber norelativenumber

let g:terminal_color_0 = '#0b0015'
let g:terminal_color_8 = '#153043'
let g:terminal_color_1 = '#ac1e33'
let g:terminal_color_9 = '#ac1e33'
let g:terminal_color_2 = '#247345'
let g:terminal_color_10 = '#247345'
let g:terminal_color_3 = '#797724'
let g:terminal_color_11 = '#797724'
let g:terminal_color_4 = '#174b58'
let g:terminal_color_12 = '#174b58'
let g:terminal_color_5 = '#4d3a58'
let g:terminal_color_13 = '#4d3a58'
let g:terminal_color_6 = '#376e57'
let g:terminal_color_14 = '#376e57'
let g:terminal_color_7 = '#48737a'
let g:terminal_color_15 = '#48737a'



"netrw settings
let g:netrw_banner = 0
"let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
"let g:netrw_winsize = 25
let g:netrw_preview = 1
augroup netrw_open
    autocmd!
    autocmd VimEnter * :Vexplore
    autocmd VimEnter * :execute "vertical resize" max(map(range(1, line('$')), "virtcol([v:val, '$'])"))
augroup END

augroup netrw_close
    autocmd!
    autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"|q|endif
augroup END

"augroup netrw_change_focus
"    autocmd!
"    autocmd WinEnter * if getbufvar(winbufnr(winnr()), "&filetype") == "netrw" | :execute "vertical resize" max(map(range(1, line('$')), "virtcol([v:val, '$'])")) | endif
"augroup END

call plug#begin()
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "completion framework
Plug 'Shougo/neoinclude.vim' "c include completion
Plug 'neomake/neomake' "cmake runner
Plug 'Raimondi/delimitMate' "auto closing tag insertion
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' "snippets
Plug 'zchee/deoplete-zsh' "zsh completion
Plug 'zchee/deoplete-clang' "c family completion
call plug#end()

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

"when entering a closing delimiter if one exists on the net line then we jump to it
"let delimitMate_jump_expansion = 1

"balance matching pairs
let delimitMate_balance_matchpairs = 1

"exclude these regions from delimitMates scope
let delimitMate_excluded_regions = "Comment,String"


"ultisnips settings

let g:UltiSnipsEditSplit = "horizontal"

let g:UltiSnipsSnippetsDir = "~/.config/nvim/plugged/vim-snippets/UltiSnips"

" Trigger configuration.
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsListTrigger="<c-e>"


"deoplete-clang settings

let g:deoplete#sources#clang#libclang_path = '/lib/libclang.so'

let g:deoplete#sources#clang#clang_header = '/lib/clang/8.0.0/include'

