" A networked note management plugin for Vim
"
" Maintainer: Sam Griesemer
" Email:      samgriesemer@gmail.com
"


let s:plugin_path = escape(expand('<sfile>:p:h:h'), '\')


" RoamFzfFiles - search wiki filenames and go to file
command! -bang -complete=dir RoamFzfFiles
    \ call fzf#vim#files(g:wiki_root, fzf#vim#with_preview({'right':'100'}, 'down:70%:wrap'), <bang>0)

" RoamFzfLines - search lines in all wiki files and go to file. Following FZF
" session has a prefilled query using the first argument, which is a
" string used for the initial ripgrep exact search.
command! -bang -nargs=* RoamFzfLines
    "\ call roam#search#fzf_grep_preview(rg_base, shellescape(<q-args>), g:wiki_root, <q-args>, <bang>0)
    \ call roam#search#fzf_grep_preview(
    \   'cd '.g:wiki_root.' && '.rg_base,
    \   shellescape(<q-args>),
    \   '*',
    \   <q-args>,
    \   'wLines> ',
    \   '3..',
    \   <bang>0,
    \   'accept_line',
    \ )

" RoamFzfLinesFnames - search lines in all wiki files and go to file. Following FZF
command! -bang -nargs=* RoamFzfLinesFnames
    "\ call roam#search#fzf_grep_preview(rg_base, shellescape(<q-args>), g:wiki_root, <q-args>, <bang>0)
    \ call roam#search#fzf_grep_preview(
    \   'cd '.g:wiki_root.' && '.rg_base,
    \   shellescape(<q-args>),
    \   '*',
    \   <q-args>,
    \   'wLines+f> ',
    \   '1,3..',
    \   <bang>0,
    \   'accept_line',
    \ )

" RoamFzfFullLines - search lines in all wiki files and go to file. Following FZF
command! -bang -nargs=* RoamFzfFullLines
    \ call roam#search#fzf_grep_preview(
    \   'python3 ' . s:plugin_path . '/autoload/roam/search/search.py ' . g:wiki_root, 
    \   '',
    \   '',
    \   <q-args>,
    \   'wLines+L> ',
    \   '3..',
    \   <bang>0,
    \   'accept_line',
    \ )

" RoamFzfFullPages - search lines in all wiki files and go to file. Following FZF
command! -bang -nargs=* RoamFzfFullPages
    \ call roam#search#fzf_grep_preview(
    \   'python3 ' . s:plugin_path . '/autoload/roam/search/search.py ' . g:wiki_root . ' 1', 
    \   '',
    \   '',
    \   <q-args>,
    \   'wLines+P> ',
    \   '3..',
    \   <bang>0,
    \   'accept_line',
    \ )

"command! -bang -nargs=* RoamFzfLinesHard
    ""\ call roam#search#fzf_grep_preview(rg_base, shellescape(<q-args>), g:wiki_root, <q-args>, <bang>0)
    "\ call roam#search#fzf_grep_preview(
    "\   'cd '.g:wiki_root.' && '.rg_base.' -- %s || true',
    "\   shellescape(<q-args>),
    "\   '*',
    "\   <q-args>,
    "\   'wLines+H> ',
    "\   '1,3..',
    "\   <bang>0,
    "\   {
    "\       
    "\ )

"function! RipgrepFzf(query, fullscreen)
  "let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  "let initial_command = printf(command_fmt, shellescape(a:query))
  "let reload_command = printf(command_fmt, '{q}')
  "let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  "call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
"endfunction



" Initialize mappings
nnoremap <silent> <plug>(roam-fzf-files)              :RoamFzfFiles<cr>
nnoremap <silent> <plug>(roam-fzf-lines)              :RoamFzfLines<cr>
nnoremap <silent> <plug>(roam-fzf-lines-fnames)       :RoamFzfLinesFnames<cr>
nnoremap <silent> <plug>(roam-fzf-full-lines)         :RoamFzfFullLines<cr>
nnoremap <silent> <plug>(roam-fzf-full-pages)         :RoamFzfFullPages<cr>

" Apply default mappings
" the following are applied if the user allows `all` or `global` defaults
let s:mappings = index(['all', 'global'], g:wiki_mappings_use_defaults) >= 0
      \ ? {
      \ '<plug>(roam-fzf-files)':        '<leader>wf',
      \ '<plug>(roam-fzf-lines)':        '<leader>wl',
      \ '<plug>(roam-fzf-lines-fnames)': '<leader>wL',
      \ '<plug>(roam-fzf-full-lines)':   '<leader>wsl',
      \ '<plug>(roam-fzf-full-pages)':   '<leader>wsL',
      \} : {}

" any user set global mappings are overridden here
call extend(s:mappings, get(g:, 'roam_mappings_global', {}))

" mappings finally applied
call roam#init#apply_mappings_from_dict(s:mappings, '')


" Expressions
imap <expr> [[ fzf#vim#complete(fzf#wrap({
    \ 'source': 'cd '.g:wiki_root.' && find * \| sed -r "s/(.*)\..*/\1/"',
    \ 'reducer': function('util#handle_completed_link'),
    \ 'options': '--bind=ctrl-d:print-query --multi --reverse --margin 15%,0',
    \ 'right':    40}))
