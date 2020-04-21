nnoremap <buffer> <localleader>b :call AllMapsToSplit()<cr>
nnoremap <buffer> <localleader>t :call CreateTitle()<cr>
nnoremap <buffer> <localleader>J :call MakeJson()<cr>
nnoremap <buffer> <localleader>e :call ConvertEcho()<cr>
nnoremap <buffer> <localleader>f :call WordToFiglet()<cr>

nnoremap <buffer> tt :call MakeTodoItem()<cr>

":command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

function! AllMapsToSplit()
    redir @a
    silent map
    redir END
    execute 'split temp_map'
    normal! "ap
    set buftype=nofile
    nnoremap <buffer> q <esc>:q<cr>
endfunction

function! WordToFiglet()
    let l:line=getline('.')
    silent execute '.!figlet "'.l:line.'"'
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
    normal V
    execute 's/echo/printf/g'
endfunction

function! MakeTodoItem()
    let l:line=getline('.')
    echom "Making a TODO item out of: ".l:line." --"
    silent execute '!todo "'.l:line.'"' | execute ':redraw!'
endfunction

