nnoremap <localleader>y :call CopyFileName()<cr>
nnoremap <localleader>b :call AllMapsToSplit()<cr>
nnoremap <localleader>w :call ToggleWrap()<cr>
nnoremap <localleader>t :call CreateTitle()<cr>
nnoremap <localleader>u :call CreateUnderline()<cr>
nnoremap <localleader>sf :call CreateSmallFiglet()<cr>
nnoremap <localleader>J :call MakeJson()<cr>
nnoremap <localleader>ca :call CalculateLineBC()<cr>
nnoremap <localleader>X :call MakeXML()<cr>
nnoremap <localleader>e :call EchoOutWordSay()<cr>
vnoremap <localleader>e :<c-u>call SelectionEchoOutWordSay()<cr>
vnoremap <localleader>6 :<c-u>call Base64EncodeLines()<cr>
vnoremap <localleader>0 :<c-u>call Base64DecodeLines()<cr>
nnoremap <localleader>f :call WordToFiglet()<cr>
nnoremap <localleader>de :call TranslateToGerman()<cr>
nnoremap <localleader>en :call TranslateToEnglish()<cr>
nnoremap <localleader>m :call MakeFoldMarker()<cr>
nnoremap <localleader>= :call MakeNotes()<cr>
nnoremap <localleader>d :call ConvertToHumanTime()<cr>
nnoremap tt :call MakeTodoItem()<cr>
nnoremap tp :call MakeTodoItemHighPriority()<cr>

"augroup mygroup 
"    autocmd!
"    autocmd CursorMoved,CursorMovedI * call s:cursor_moved() 
"augroup END 
"
"function! s:cursor_moved() abort 
"    echom "cursor moved" 
"endfunction 

" IMPORTANT only works currently on files in the CWD
" :call Peak("index.js")
" Use this function to open the file for 15 seconds then close it
" giving the player the time to cover their screen and hit ENTER 
" when the screen is fully covered...
function! Peak(file) abort
    execute 'edit ' . a:file
    redraw
    echom "You have 15 seconds to look at the code..."
    execute 'sleep 15'
    bd
    redraw
    echom "Are you ready to play??"
    sleep 2
    echom "Please COVER YOUR SCREEN NOW and press ENTER when you are ready..."
    sleep 2
    let l:ans = input("Press Enter to re-open the file... GOOD LUCK")
    execute 'edit ' . a:file
endfunction

"NOTE: function with ! would silently replace a function that already exists
"with that name, if you dont have the bang and another function with the same
"name exists then an error is thrown

function! MakeNotes()
    echom "Notes"
    r~/TEMPLATE_NOTES.txt
endfunction

" What is this ben? vvv
":command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'"
function! ToggleWrap()
    set wrap!
endfunction

function! CopyFileName()
    echom @%
    let @* = expand("%")
endfunction

function! LineBreak()
    " i+++==============================================================================================+++<esc>
    " i+++==============================================================================================+++<esc>
endfunction

function! ConvertToHumanTime()
    let l:wordUnderCursor = expand("<cword>")
    "echom "Word on: " . l:wordUnderCursor . ""
    let l:cmd = "gdate -d \"@" . l:wordUnderCursor . "\""
    let l:human = system("" . l:cmd)
    echom "Time: " . l:human . ""
endfunction

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

"abort
"at end of function statement stops execution if any line fails
"usual behaviour is that vim continues past failing lines
function! CreateSmallFiglet() abort
    if executable('figlet')
        let l:line=getline('.')
        silent execute '.!figlet -f cybermedium "'.l:line.'"'
    endif
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
    normal! VU"eyy
    "get lenght of string but it includes newline char
    "@e is at buffer e thats where the line above copies to
    let l:actlength=(strlen(@e) -1)
    let l:remain=(l:amount - l:actlength)
    let l:half=((l:remain / 2) - 1)
    normal "_dd
    normal o
    normal 50i=
    normal! "ep
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

function! MakeXML()
    ":%! xmllint --format -
    .!xmllint --format -
    set foldmethod=syntax
    set syntax=xml
endfunction

function! MakeJson()
    "set foldmethod=syntax
    "set syntax=json
    :%!jq
    ":.!jq .
    "noh
    echom "Converted to JSON nicely"
    set foldmethod=syntax
    set syntax=json
    "normal u
endfunction

function! EchoOutWordSay()
    let l:line = getline('.')
    let l:res = system('say "'.l:line.'"')
    "echom "Converting echos..."
    "normal V
    "execute 's/echo/printf/g'
endfunction

function! Base64DecodeLines()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    let l:joined = join(lines, "\n")
    for i in lines
        let l:out = system('echo "'.i.'" | base64 -d')
        call append(line('$'),split(l:out,"\n"))
    endfor
    return l:joined
endfunction

function! Base64EncodeLines()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    let l:joined = join(lines, "\n")
    for i in lines
        let l:out = system('echo "'.i.'" | base64')
        call append(line('$'),split(l:out,"\n"))
    endfor
    return l:joined
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
    let l:res = system('say "'.l:say.'"')
endfunction

function! CalculateLineBC()
    let l:line=getline('.')
    let l:answer= system('echo "'.l:line.'" | bc | sed "s/[[:space:]]//g"')
    normal o
    echom "---".l:answer."---"
    execute '.!echo '.l:answer
endfunction

function! MakeTodoItem()
    let l:line=getline('.')
    silent execute '!todo -l 6 "'.l:line.'"' | execute ':redraw!'
    echom "Made a todo item out of: ".l:line
endfunction

function! MakeTodoItemHighPriority()
    let l:line=getline('.')
    silent execute '!todo -l 6 -p 1 "'.l:line.'"' | execute ':redraw!'
    echom "Made a PRIORITY todo item out of: ".l:line
endfunction

function! MakeFoldMarker()
    normal i# ===== {{{
    normal ooi#}}}
    normal OO
    execute "normal! i\<tab>"
    set foldmethod=marker
    normal kk^f=
    "nnoremap <leader>m i# ___ {{{<esc>o#}}}<esc>O<tab><esc>
endfunction


