" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
syntax on
syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

" Set colorscheme for Git Gutter to be more readable
"colorscheme PaperColor
colorscheme darkblue
"colorscheme deep-space
"colorscheme purify "colorful comments, Git Gutter and rainbow braces, high contrast, errors in vim
"colorscheme space-vim-dark "colorful comments, Git Gutter and rainbow braces
"colorscheme stellarized "Works with nvim but no vim

" Git Gutter
set updatetime=250
"let g:gitgutter_max_signs = 500
" No mapping
let g:gitgutter_map_keys = 0

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

" Tagbar
nnoremap <silent> t :TagbarToggle<CR>

" FZF mappings
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>

" Autoformat mapping
nnoremap <silent> <C-k> :Autoformat<CR>
