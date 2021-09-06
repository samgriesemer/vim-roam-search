" Search extension for vim-roam
"
" Maintainer: Sam Griesemer
" Email:      samgriesemer@gmail.com
"


let s:plugin_path = escape(expand('<sfile>:p:h:h'), '\')


call roam#init#option('roam_search_wrap_link', 'roam_search#util#default_wrap_link')


" initialize commands
command! -bang -nargs=* RoamFzfFiles
    \ call roam#search#fzf_grep_preview(
    \   'cd '.g:roam_wiki_root.' && rg --files',
    \   shellescape(<q-args>),
    \   '*',
    \   <q-args>,
    \   'wFiles> ',
    \   '..',
    \   <bang>0,
    \   0,
    \   'accept_page',
    \   s:plugin_path.'/autoload/roam_search/preview-rga.sh '''.g:roam_wiki_root.'/{..}'' {q}'
    \ )

" RoamFzfLines - search lines in all wiki files and go to file. Following FZF
" session has a prefilled query using the first argument, which is a
" string used for the initial ripgrep exact search.
command! -bang -nargs=* RoamFzfLines
    "\ call roam#search#fzf_grep_preview(rg_base, shellescape(<q-args>), g:roam_wiki_root, <q-args>, <bang>0)
    \ call roam#search#fzf_grep_preview(
    \   'cd '.g:roam_wiki_root.' && '.rg_base,
    \   shellescape(<q-args>),
    \   '*',
    \   <q-args>,
    \   'wLines> ',
    \   '3..',
    \   <bang>0,
    \   0,
    \   'accept_line',
    \ )

" RoamFzfLinesFnames - search lines in all wiki files and go to file. Following FZF
command! -bang -nargs=* RoamFzfLinesFnames
    "\ call roam#search#fzf_grep_preview(rg_base, shellescape(<q-args>), g:roam_wiki_root, <q-args>, <bang>0)
    \ call roam#search#fzf_grep_preview(
    \   'cd '.g:roam_wiki_root.' && '.rg_base,
    \   shellescape(<q-args>),
    \   '*',
    \   <q-args>,
    \   'wLines+f> ',
    \   '1,3..',
    \   <bang>0,
    \   0,
    \   'accept_line',
    \ )

" RoamFzfFullLines - search lines in all wiki files and go to file. Following FZF
command! -bang -nargs=* RoamFzfFullLines
    \ call roam#search#fzf_grep_preview(
    \   'python3 '.s:plugin_path.'/autoload/roam_search/search.py '.g:roam_wiki_root, 
    \   '',
    \   '',
    \   <q-args>,
    \   'wLines+L> ',
    \   '3..',
    \   <bang>0,
    \   0,
    \   'accept_line',
    \ )

" RoamFzfFullPages - search lines in all wiki files and go to file. Following FZF
command! -bang -nargs=* RoamFzfFullPages
    \ call roam#search#fzf_grep_preview(
    \   'python3 '.s:plugin_path.'/autoload/roam_search/search.py '.g:roam_wiki_root.' 1', 
    \   '',
    \   '',
    \   <q-args>,
    \   'wLines+P> ',
    \   '3..',
    \   <bang>0,
    \   0,
    \   'accept_line',
    \ )

let s:rga_base = 'rga --column --line-number --no-heading --color=always --smart-case -- %s'
command! -bang -nargs=* RoamFzfRgAll 
    \ call roam#search#fzf_grep_preview(
    \   'cd '.g:roam_wiki_root.' && '.printf(s:rga_base, shellescape(<q-args>)),
    \   '',
    \   '',
    \   <q-args>,
    \   'wAll> ',
    \   '..',
    \   <bang>0,
    \   1,
    \   'accept_line',
    \   s:plugin_path.'/autoload/roam_search/preview-rga.sh '''.g:roam_wiki_root.'/{..2}'' {q}',
    \   'change:reload:'.printf(s:rga_base, '{q}'),
    \ )


"command! -bang -nargs=* RoamFzfLinesHard

"command! -bang -nargs=* RoamFzfLinesHard
    ""\ call roam#search#fzf_grep_preview(rg_base, shellescape(<q-args>), g:roam_wiki_root, <q-args>, <bang>0)
    "\ call roam#search#fzf_grep_preview(
    "\   'cd '.g:roam_wiki_root.' && '.rg_base.' -- %s || true',
    "\   shellescape(<q-args>),
    "\   '*',
    "\   <q-args>,
    "\   'wLines+H> ',
    "\   '1,3..',
    "\   <bang>0,
    "\   {
    "\       
    "\ )


" Initialize mappings
nnoremap <silent> <plug>(roam-fzf-files)              :RoamFzfFiles<cr>
nnoremap <silent> <plug>(roam-fzf-lines)              :RoamFzfLines<cr>
nnoremap <silent> <plug>(roam-fzf-lines-fnames)       :RoamFzfLinesFnames<cr>
nnoremap <silent> <plug>(roam-fzf-full-lines)         :RoamFzfFullLines<cr>
nnoremap <silent> <plug>(roam-fzf-full-pages)         :RoamFzfFullPages<cr>
nnoremap <silent> <plug>(roam-fzf-rg-all-lines)       :RoamFzfRgAll<cr>

" Apply default mappings
" the following are applied if the user allows `all` or `global` defaults
let s:mappings = index(['all', 'global'], g:wiki_mappings_use_defaults) >= 0
      \ ? {
      \ '<plug>(roam-fzf-files)':        '<leader>wf',
      \ '<plug>(roam-fzf-lines)':        '<leader>wl',
      \ '<plug>(roam-fzf-lines-fnames)': '<leader>wL',
      \ '<plug>(roam-fzf-full-lines)':   '<leader>wsl',
      \ '<plug>(roam-fzf-full-pages)':   '<leader>wsL',
      \ '<plug>(roam-fzf-rg-all-lines)': '<leader>wsa',
      \} : {}

" any user set global mappings are overridden here
call extend(s:mappings, get(g:, 'roam_mappings_global', {}))

" mappings finally applied
call roam#init#apply_mappings_from_dict(s:mappings, '')

" Expressions
imap <expr> [[ fzf#vim#complete(fzf#wrap({
    \ 'source': 'cd '.g:roam_wiki_root.' && find * \| sed -r "s/(.*)\..*/\1/"',
    \ 'reducer': function(get(g:, 'roam_search_wrap_link')),
    \ 'options': '--bind='.get(g:, 'wiki_fzf_pages_force_create_key', 'alt-enter').':print-query'
    \ }))


function! TestFunc(lines)
    let l:out = join(a:lines)
    " janky
    normal! xx
    return l:out.']]'
endfunction
function! TestSrc(lines)
    let l:curline = getline('.')
    let l:mask = l:curline[:getcurpos('.')[2]]
    echo l:mask
    let l:mlist = matchlist(l:mask, '\[\[\([^\]]*\)\]\]$')
    " TODO: add support for just doing `##` to create link of current file anchors

    if empty(l:mlist)
        echo "Cursor not properly positioned over link"
        return []
    endif
    return wiki#page#get_anchors(l:mlist[1])
endfunction
imap <expr> ## fzf#vim#complete(fzf#wrap({
    \ 'prefix': '',
    \ 'source': function('TestSrc'),
    \ 'reducer': function('TestFunc'),
    \ 'options': '--bind='.get(g:, 'wiki_fzf_pages_force_create_key', 'alt-enter').':print-query'
    \ }))
