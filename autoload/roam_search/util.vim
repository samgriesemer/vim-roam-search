" Initialize options
function! roam_search#util#default_wrap_link(lines)
    call feedkeys('A')
    let link = join(a:lines)
    return '[['.link.']]'
endfunction

