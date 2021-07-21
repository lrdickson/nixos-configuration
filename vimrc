" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
syntax on
syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
