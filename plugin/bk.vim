nnoremap <buffer> <localleader>b :call AllMapsToSplit()<cr>
nnoremap <buffer> <localleader>t :call CreateTitle()<cr>
nnoremap <buffer> <localleader>u :call CreateUnderline()<cr>
nnoremap <buffer> <localleader>J :call MakeJson()<cr>
nnoremap <buffer> <localleader>e :call EchoOutWordSay()<cr>
vnoremap <buffer> <localleader>e :<c-u>call SelectionEchoOutWordSay()<cr>
nnoremap <buffer> <localleader>f :call WordToFiglet()<cr>
nnoremap <buffer> <localleader>de :call TranslateToGerman()<cr>
nnoremap <buffer> <localleader>en :call TranslateToEnglish()<cr>
nnoremap <buffer> tt :call MakeTodoItem()<cr>

"NOTE: function with ! would silently replace a function that already exists
"with that name, if you dont have the bang and another function with the same
"name exists then an error is thrown

" What is this ben? vvv
":command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'"

function! TranslateToEnglish()
    if executable('trans')
        let l:line = getline('.')
        let l:res = system('trans -b de: "'.l:line.'" | tail -n 1 | sed "s/^ *//g" | perl -pe "s/\e\[[0-9;]*m(?:\e\[K)?//g"')
        call setline('.', l:line." - ".l:res)
        normal $x
    endif
endfunction

function! TranslateToGerman()
    if executable('trans')
        let l:line = getline('.')
        let l:res = system('trans -b :de "'.l:line.'" | tail -n 1 | sed "s/^ *//g" | perl -pe "s/\e\[[0-9;]*m(?:\e\[K)?//g"')
        call setline('.', l:line." - ".l:res)
        normal $x
    endif
endfunction

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
    if executable('figlet')
        let l:line=getline('.')
        silent execute '.!figlet "'.l:line.'"'
    endif
endfunction

" Notes
"   l: is scoped to a function
function! CreateTitle()
    let l:amount=50
    normal VU"eyy
    "get lenght of string but it includes newline char
    "@e is at buffer e thats where the line above copies to
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

" Underline (-u) 
" Creates a configurable smaller title
function! CreateUnderline()
    normal ^"ey$
    let l:side=3
    "★ ┸ ○ ●
    let l:character="-"
    let l:undercharacter="┴"
    let l:actlength=(strlen(@e) -1)
    let l:bottomlength=l:actlength + l:side + l:side + 3
    normal "_dd
    normal "ep
    normal I 
    normal A 
    execute "normal! 0".l:side."i".l:character
    execute "normal! $".l:side."A".l:character
    normal o
    execute "normal! ".l:bottomlength."i".l:undercharacter
endfunction

function! MakeJson()
    .!jq .
    set foldmethod=syntax
    set syntax=json
    noh
endfunction

function! EchoOutWordSay()
    let l:line = getline('.')
    let l:res = system('say -v Alex "'.l:line.'"')
    "echom "Converting echos..."
    "normal V
    "execute 's/echo/printf/g'
endfunction

function! SelectionEchoOutWordSay()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    let l:say = join(lines, " ")
    let l:res = system('say -v Alex "'.l:say.'"')
endfunction

function! MakeTodoItem()
    let l:line=getline('.')
    echom "Making a TODO item out of: ".l:line." --"
    silent execute '!todo "'.l:line.'"' | execute ':redraw!'
endfunction



