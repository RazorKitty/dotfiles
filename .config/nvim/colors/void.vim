" Vim colorscheme template file
" Author: Gerardo Galindez <gerardo.galindez@gmail.com>
" Maintainer: Gerardo Galindez <gerardo.galindez@gmail.com>
" Notes: To check the meaning of the highlight groups, :help 'highlight'

" --------------------------------
set background=dark
" - or ---------------------------
"set background=light
" --------------------------------

highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="void"

"----------------------------------------------------------------
" General settings                                              |
"----------------------------------------------------------------
"----------------------------------------------------------------
" Syntax group   | Foreground    | Background    | Style        |
"----------------------------------------------------------------

" --------------------------------
" User Colors
" --------------------------------
hi User1           guifg=none   guibg=none  ctermfg=0       ctermbg=0       cterm=none
hi User2           guifg=none   guibg=none  ctermfg=0       ctermbg=1       cterm=none
hi User3           guifg=none   guibg=none  ctermfg=10      ctermbg=8       cterm=none
hi User4           guifg=none   guibg=none  ctermfg=0       ctermbg=3       cterm=none
hi User5           guifg=none   guibg=none  ctermfg=0       ctermbg=4       cterm=none
hi User6           guifg=none   guibg=none  ctermfg=0       ctermbg=5       cterm=none
hi User7           guifg=none   guibg=none  ctermfg=0       ctermbg=6       cterm=none
hi User8           guifg=none   guibg=none  ctermfg=0       ctermbg=7       cterm=none
hi User9           guifg=none   guibg=none  ctermfg=0       ctermbg=8       cterm=none
" --------------------------------
" Editor settings
" --------------------------------
hi Normal          guifg=none   guibg=none  ctermfg=7       ctermbg=none       cterm=none
hi Cursor          guifg=none   guibg=none  ctermfg=none    ctermbg=15      cterm=none
hi CursorLine      guifg=none   guibg=none  ctermfg=none    ctermbg=0       cterm=none
hi LineNr          guifg=none   guibg=none  ctermfg=4      ctermbg=none       cterm=none
hi CursorLineNR    guifg=none   guibg=none  ctermfg=15      ctermbg=none       cterm=none

" -----------------
" - Number column -
" -----------------
hi CursorColumn    guifg=none   guibg=none  ctermfg=none    ctermbg=8       cterm=none
hi FoldColumn      guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi SignColumn      guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Folded          guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none

" -------------------------
" - Window/Tab delimiters - 
" -------------------------
hi VertSplit       guifg=none   guibg=none  ctermfg=4       ctermbg=none       cterm=none
hi ColorColumn     guifg=none   guibg=none  ctermfg=none    ctermbg=8       cterm=none
hi TabLine         guifg=none   guibg=none  ctermfg=4      ctermbg=none       cterm=none
hi TabLineFill     guifg=none   guibg=none  ctermfg=none       ctermbg=none       cterm=none
hi TabLineSel      guifg=none   guibg=none  ctermfg=15      ctermbg=none       cterm=none

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi Search          guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi IncSearch       guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none

" -----------------
" - Prompt/Status -
" -----------------
hi StatusLine      guifg=none   guibg=none  ctermfg=15      ctermbg=none       cterm=none
hi StatusLineNC    guifg=none   guibg=none  ctermfg=4      ctermbg=none       cterm=none
hi WildMenu        guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Question        guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Title           guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi ModeMsg         guifg=none   guibg=none  ctermfg=0       ctermbg=7       cterm=none
hi MoreMsg         guifg=none   guibg=none  ctermfg=7       ctermbg=none    cterm=none

" --------------
" - Visual aid -
" --------------
hi MatchParen      guifg=none   guibg=none  ctermfg=0       ctermbg=7       cterm=none
hi Visual          guifg=none   guibg=none  ctermfg=none       ctermbg=0       cterm=none
hi VisualNOS       guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi NonText         guifg=none   guibg=none  ctermfg=0       ctermbg=none       cterm=none

hi Todo            guifg=none   guibg=none  ctermfg=0       ctermbg=8       cterm=none
hi Underlined      guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Error           guifg=none   guibg=none  ctermfg=0       ctermbg=9       cterm=none
hi ErrorMsg        guifg=none   guibg=none  ctermfg=0       ctermbg=1       cterm=none
hi WarningMsg      guifg=none   guibg=none  ctermfg=0       ctermbg=3       cterm=none
hi Ignore          guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi SpecialKey      guifg=none   guibg=none  ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Variable types
" --------------------------------
hi Constant        guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi String          guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi StringDelimiter guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi Character       guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi Number          guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi Boolean         guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none
hi Float           guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none

hi Identifier      guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Function        guifg=none   guibg=none  ctermfg=2       ctermbg=none    cterm=none

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       guifg=none   guibg=none  ctermfg=6      ctermbg=none    cterm=none
hi Conditional     guifg=none   guibg=none  ctermfg=3       ctermbg=none    cterm=none
hi Repeat          guifg=none   guibg=none  ctermfg=6      ctermbg=none    cterm=none
hi Label           guifg=none   guibg=none  ctermfg=12      ctermbg=none    cterm=none
hi Operator        guifg=none   guibg=none  ctermfg=3       ctermbg=none    cterm=none
hi Keyword         guifg=none   guibg=none  ctermfg=10      ctermbg=none    cterm=none
hi Exception       guifg=none   guibg=none  ctermfg=1       ctermbg=none    cterm=none
hi Comment         guifg=none   guibg=none  ctermfg=4       ctermbg=none    cterm=none

hi Special         guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi SpecialChar     guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Tag             guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Delimiter       guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi SpecialComment  guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Debug           guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
                   
" ----------       
" - C like -
" ----------
hi PreProc         guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Include         guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Define          guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi Macro           guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none
hi PreCondit       guifg=none   guibg=none  ctermfg=15      ctermbg=none    cterm=none

hi Type            guifg=none   guibg=none  ctermfg=10      ctermbg=none    cterm=none
hi StorageClass    guifg=none   guibg=none  ctermfg=14      ctermbg=none    cterm=none
hi Structure       guifg=none   guibg=none  ctermfg=10      ctermbg=none    cterm=none
hi Typedef         guifg=none   guibg=none  ctermfg=10      ctermbg=none    cterm=none  
" --------------------------------
" Diff
" --------------------------------
hi DiffAdd         guifg=none   guibg=none   ctermfg=none   ctermbg=none    cterm=none
hi DiffChange      guifg=none   guibg=none   ctermfg=none   ctermbg=none    cterm=none
hi DiffDelete      guifg=none   guibg=none   ctermfg=none   ctermbg=none    cterm=none
hi DiffText        guifg=none   guibg=none   ctermfg=none   ctermbg=none    cterm=none

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu           guifg=none   guibg=none  ctermfg=7       ctermbg=8       cterm=none
hi PmenuSel        guifg=none   guibg=none  ctermfg=15      ctermbg=8       cterm=none
hi PmenuSbar       guifg=none   guibg=none  ctermfg=8       ctermbg=8       cterm=none
hi PmenuThumb      guifg=none   guibg=none  ctermfg=15      ctermbg=15      cterm=none 
" --------------------------------
" Spelling
" --------------------------------
hi SpellBad        ctermfg=none    ctermbg=none    cterm=none
hi SpellCap        ctermfg=none    ctermbg=none    cterm=none
hi SpellLocal      ctermfg=none    ctermbg=none    cterm=none
hi SpellRare       ctermfg=none    ctermbg=none    cterm=none

"--------------------------------------------------------------------
" Specific settings                                                 |
"--------------------------------------------------------------------
