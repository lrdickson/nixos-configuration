" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
syntax on
syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

" Set colorscheme for Git Gutter to be more readable
"colorscheme OceanNext
"colorscheme PaperColor
"colorscheme apprentice
"colorscheme challenger_deep
"colorscheme darkblue
"colorscheme dogrun
"colorscheme hybrid
"colorscheme hybrid_material
"colorscheme jellybeans
colorscheme meta5
"colorscheme molokai

" Git Gutter
set updatetime=250
"let g:gitgutter_max_signs = 500
" No mapping
"let g:gitgutter_map_keys = 0
" Colors
"let g:gitgutter_override_sign_column_highlight = 0
"highlight clear SignColumn
"highlight GitGutterAdd ctermfg=2
"highlight GitGutterChange ctermfg=3
"highlight GitGutterDelete ctermfg=1
"highlight GitGutterChangeDelete ctermfg=4

" Rust linting
let g:ale_linters = {
\	'cs': ['OmniSharp'],
\	'rust': ['analyzer'],
\}

" Activate rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable via :RainbowToggle

" Set OmniSharp-vim log dir
let g:OmniSharp_log_dir = $HOME . '/.omnisharp_vim_log'

" Autoformat
let g:formatdef_my_custom_cs = '"dotnet format --files"'
let g:formatters_cs = ['my_custom_cs']

