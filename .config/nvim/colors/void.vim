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
" Editor settings
" --------------------------------
hi Normal          guifg=#48737a    guibg=#0d0015   ctermfg=none    ctermbg=none    cterm=none
hi Cursor          guifg=#0d0015    guibg=#b4c1c2   ctermfg=none    ctermbg=none    cterm=none
hi CursorLine      guifg=none       guibg=none      ctermfg=none    ctermbg=none    cterm=none
hi LineNr          guifg=#48737a    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none
hi CursorLineNR    guifg=#0d0015    guibg=#174b58   ctermfg=none    ctermbg=none    cterm=none

" -----------------
" - Number column -
" -----------------
hi CursorColumn    ctermfg=none    ctermbg=none    cterm=none
hi FoldColumn      ctermfg=none    ctermbg=none    cterm=none
hi SignColumn      ctermfg=none    ctermbg=none    cterm=none
hi Folded          guifg=#b4c1c2   guibg=#0f192e  ctermfg=none    ctermbg=none    cterm=none

" -------------------------
" - Window/Tab delimiters - 
" -------------------------
hi VertSplit       guifg=#0f192e    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none
hi ColorColumn     guifg=none       guibg=none      ctermfg=none    ctermbg=none    cterm=none
hi TabLine         guifg=#48737a   guibg=#0f192e    ctermfg=none    ctermbg=none    cterm=none
hi TabLineFill     guifg=#0f192e   guibg=#0f192e    ctermfg=none    ctermbg=none    cterm=none
hi TabLineSel      guifg=#0d0015   guibg=#174b58    ctermfg=none    ctermbg=none    cterm=none

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       guifg=#247345    guibg=#0d0015   ctermfg=none    ctermbg=none    cterm=none
hi Search          guifg=#0d0015    guibg=#247345   ctermfg=none    ctermbg=none    cterm=none
hi IncSearch       guifg=#0d0015    guibg=#b4c1c2   ctermfg=none    ctermbg=none    cterm=none

" -----------------
" - Prompt/Status -
" -----------------
hi StatusLine      guifg=#174b58    guibg=#0d0015   ctermfg=none    ctermbg=none    cterm=none
hi StatusLineNC    guifg=#0f192e    guibg=#b4c1c2   ctermfg=none    ctermbg=none    cterm=none
hi WildMenu        guifg=#b4c1c2    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none
hi Question        guifg=#b4c1c2    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none
hi Title           guifg=#b4c1c2    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none
hi ModeMsg         guifg=#0d0015    guibg=#b4c1c2   ctermfg=none    ctermbg=none    cterm=none
hi MoreMsg         guifg=#b4c1c2    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none

" --------------
" - Visual aid -
" --------------
hi MatchParen      ctermfg=none    ctermbg=none    cterm=none
hi Visual          ctermfg=none    ctermbg=none    cterm=none
hi VisualNOS       ctermfg=none    ctermbg=none    cterm=none
hi NonText         ctermfg=none    ctermbg=none    cterm=none

hi Todo            guifg=#0d0015    guibg=#0f192e   ctermfg=none    ctermbg=none    cterm=none
hi Underlined      guifg=none       guibg=none      ctermfg=none    ctermbg=none    cterm=none
hi Error           guifg=#0d0015    guibg=#ac1e33   ctermfg=none    ctermbg=none    cterm=none
hi ErrorMsg        guifg=#0d0015    guibg=#ac1e33   ctermfg=none    ctermbg=none    cterm=none
hi WarningMsg      guifg=#0d0015    guibg=#797724   ctermfg=none    ctermbg=none    cterm=none
hi Ignore          guifg=none       guibg=none      ctermfg=none    ctermbg=none    cterm=none
hi SpecialKey      guifg=none       guibg=none      ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Variable types
" --------------------------------
hi Constant        guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi String          guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi StringDelimiter guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Character       guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Number          guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Boolean         guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Float           guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none

hi Identifier      guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Function        guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Conditional     guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Repeat          guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Label           guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Operator        guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Keyword         guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Exception       guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Comment         guifg=#153043    guibg=none  ctermfg=none    ctermbg=none    cterm=none

hi Special         guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi SpecialChar     guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Tag             guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Delimiter       guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi SpecialComment  guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Debug           guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
                   
" ----------       
" - C like -
" ----------
hi PreProc         guifg=#4d3a58    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Include         guifg=#4d3a58    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Define          guifg=#4d3a58    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Macro           guifg=#4d3a58    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi PreCondit       guifg=#4d3a58    guibg=none  ctermfg=none    ctermbg=none    cterm=none

hi Type            guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi StorageClass    guifg=#375e57    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Structure       guifg=#375e57    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi Typedef         guifg=#247345    guibg=none  ctermfg=none    ctermbg=none    cterm=none  
" --------------------------------
" Diff
" --------------------------------
hi DiffAdd         guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi DiffChange      guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi DiffDelete      guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none
hi DiffText        guifg=#b4c1c2    guibg=none  ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu           guifg=#b4c1c2    guibg=#0f192e  ctermfg=none    ctermbg=none    cterm=none
hi PmenuSel        guifg=#b4c1c2    guibg=#153043  ctermfg=none    ctermbg=none    cterm=none
hi PmenuSbar       guifg=#b4c1c2    guibg=#0f192e  ctermfg=none    ctermbg=none    cterm=none
hi PmenuThumb      guifg=#b4c1c2    guibg=#153043  ctermfg=none    ctermbg=none    cterm=none 
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
