" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
syntax on
syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

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

" ALE - linting engine
let g:ale_linters = {
			\	'cs': ['OmniSharp'],
			\	'rust': ['analyzer'],
			\}
nnoremap <silent> <Leader>ad :ALEDetail<CR>

" Activate rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable via :RainbowToggle

" Set OmniSharp-vim log dir
let g:OmniSharp_log_dir = $HOME . '/.omnisharp_vim_log'
let g:Omnisharp_selector_iu = 'fzf'

" Autoformat
let g:formatdef_my_custom_cs = '"dotnet format --files"'
let g:formatters_cs = ['my_custom_cs']

" Tagbar
nnoremap <silent> <Leader>tb :TagbarToggle<CR>

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

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet:
" https://github.com/neovim/neovim/issues/10996
if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  "autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd :OmniSharpGotoDefinition<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu :OmniSharpFindUsages<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi :OmniSharpFindImplementations<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd :OmniSharpPreviewDefinition<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi :OmniSharpPreviewImplementations<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost :OmniSharpTypeLookup<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd :OmniSharpDocumentation<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs :OmniSharpFindSymbol<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx :OmniSharpFixUsings<CR>
  autocmd FileType cs nmap <silent> <buffer> <C-\> :OmniSharpSignatureHelp<CR>
  autocmd FileType cs imap <silent> <buffer> <C-\> :OmniSharpSignatureHelp<CR>

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ :OmniSharpNavigateUp<CR>
  autocmd FileType cs nmap <silent> <buffer> ]] :OmniSharpNavigateDown<CR>
  " Find all code errors/warnings for the current solution and populate the quickfix window<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc :OmniSharpGlobalCodeCheck<CR>
  " Contextual code actions uses fzf, vim-clap, CtrlP or unite.vim selector when available<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca :OmniSharpCodeActions<CR>
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca :OmniSharpCodeActions<CR>
  " Repeat the last code action performed does not use a selector<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. :OmniSharpCodeActionRepeat<CR>
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. :OmniSharpCodeActionRepeat<CR>

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= :OmniSharpCodeFormat<CR>

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm :OmniSharpRename<CR>

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre :OmniSharpRestartServer<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst :OmniSharpStartServer<CR>
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp :OmniSharpStopServer<CR>
augroup END

" Enable snippet completion, using the ultisnips plugin
let g:OmniSharp_want_snippet=1
