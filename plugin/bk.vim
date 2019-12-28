nnoremap <buffer> <localleader>b :call AllMapsToSplit()<cr>
nnoremap <buffer> <localleader>t :call CreateTitle()<cr>
nnoremap <buffer> <localleader>J :call MakeJson()<cr>
nnoremap <buffer> <localleader>e :call ConvertEcho()<cr>

function! AllMapsToSplit()
    redir @a
    silent map
    redir END
    execute 'split temp_map'
    normal! "ap
    set buftype=nofile
    nnoremap <buffer> q <esc>:q<cr>
endfunction

" Notes
"   l: is scoped to a function
function! CreateTitle()
    let l:amount=50
    normal VU"eyy
    "get lenght of string but it includes newline char
    let l:actlength=(strlen(@e) -1)
    let l:remain=(l:amount - l:actlength)
    let l:half=((l:remain / 2) - 1)
    normal "_dd
    normal o
    normal 50i=
    normal "ep
    normal I 
    normal A 
    execute "normal! 0". l:half . "i=" 
    execute "normal! $". l:half . "A=" 
    "modulo to get remainer for even/odd figuring
    if(fmod(l:actlength,2) > 0)
        normal A=
    endif
    normal o50i=
endfunction

function! MakeJson()
    .!jq .
    set foldmethod=syntax
    set syntax=json
    noh
endfunction

function! ConvertEcho()
    echom "Converting echos..."
endfunction
