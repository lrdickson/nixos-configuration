" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
syntax on
syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

" Set colorscheme for Git Gutter to be more readable
"colorscheme PaperColor
"colorscheme darkblue
"colorscheme deep-space
"colorscheme purify "colorful comments, Git Gutter and rainbow braces, high contrast, errors in vim
"colorscheme space-vim-dark "colorful comments, Git Gutter and rainbow braces
"colorscheme stellarized "Works with nvim but no vim

" Git Gutter
set updatetime=250
"let g:gitgutter_max_signs = 500
" No mapping
let g:gitgutter_map_keys = 0
" Colors
" I'm not sure this section accomplishes anything when a colorscheme is set
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

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

" Lightline config
" Display git branch
let g:lightline = {
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
			\ },
			\ 'component_function': {
			\   'gitbranch': 'FugitiveHead'
			\ },
			\ }
" Fix lightline colors when running sudo
if !has('gui_running')
  set t_Co=256
endif

" Set Tab Width Command
fu! SetTabWidth(w)
	let &l:shiftwidth = a:w
	let &l:tabstop = a:w
	let &l:softtabstop = a:w
endf
command! -nargs=* SetTabWidth call SetTabWidth(<f-args>)
