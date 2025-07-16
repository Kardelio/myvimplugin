nnoremap <localleader>y :call CopyFileName()<cr>
nnoremap <localleader>o :call OpenFileToEditOnLine()<cr>
nnoremap <localleader>b :call AllMapsToSplit()<cr>
nnoremap <localleader>w :call ToggleWrap()<cr>
nnoremap <localleader>t :call CreateTitle()<cr>

vnoremap <silent> <localleader>t :<C-u>call <SID>RunOnceProcessVisualSelection()<cr>
"vnoremap <localleader>t :call CreateVisualTreeFromSelection()<cr>
nnoremap <localleader>u :call CreateUnderline()<cr>
nnoremap <localleader>sf :call CreateSmallFiglet()<cr>
nnoremap <localleader>J :call MakeJson()<cr>
nnoremap <localleader>aj :call PerformJQCmdOnArrayOfObjects()<cr>
nnoremap <localleader>j :call GetJiraTicket()<cr>
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
vnoremap tt :<c-u>call MakeTodoItems()<cr>
nnoremap tt :call MakeTodoItem()<cr>
nnoremap tp :call MakeTodoItemHighPriority()<cr>


function! PerformJQCmdOnArrayOfObjects()
    let l:userin = input("please type your JQ statement (e.g. 'select(.mergeCommit == true)'):")
    echom "->".l:userin
    "silent execute '.!figlet -f cybermedium "'.l:line.'"'
    silent execute '%!jq "[.[] | '.l:userin.']"'
    call MakeJson()
    ":%! jq '.[] | select(.mergeCommit == true)]'
endfunction

"%!. jq '[.[] | select(.mergeCommit == true)]'

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

function! OpenFileToEditOnLine()
    let l:line = getline('.')
    echom "WIP: Line: " . l:line . "-"
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

function! CreateVisualTreeFromSelection()

    normal! \<Esc>

    " Get the start and end positions of the visual selection
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")

    " Get the line numbers of the selection
    let l:start_line = l:start_pos[1]
    let l:end_line = l:end_pos[1]

    " Iterate through the selected lines and process them
    for l:line_num in range(l:start_line, l:end_line)
        let l:line_content = getline(l:line_num)
        " Do something with the line content (e.g., print it)
        echo "Line " . l:line_num . ": " . l:line_content
    endfor
    "let l:start_pos = getpos("'<")
    "let l:end_pos = getpos("'>")

    "" Get the line numbers of the selection
    "let l:start_line = l:start_pos[1]
    "let l:end_line = l:end_pos[1]

    "" Iterate through the selected lines and process them
    "for l:line_num in range(l:start_line, l:end_line)
    "    let l:line_content = getline(l:line_num)
    "    " Do something with the line content (e.g., print it)
    "    echo "Line " . l:line_num . ": " . l:line_content
    "endfor
endfunction

" Define a function to process the visual selection
function! ProcessVisualSelection()
    " Get the start and end positions of the visual selection
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")

    " Get the line numbers of the selection
    let l:start_line = l:start_pos[1]
    let l:end_line = l:end_pos[1]

    let lines = getline(l:start_line, l:end_line)
    if len(lines) == 0
        return ''
    endif
    let l:joined = join(lines, "\n")

    " Iterate through the selected lines and process them
    for l:line_num in range(l:start_line, l:end_line)
        let l:line_content = getline(l:line_num)
        " Do something with the line content (e.g., print it)
        echo "Line " . l:line_num . ": " . l:line_content
    endfor

    "let [line_start, column_start] = getpos("'<")[1:2]
    "let [line_end, column_end] = getpos("'>")[1:2]
    "let lines = getline(line_start, line_end)
    "if len(lines) == 0
    "    return ''
    "endif
    "let lines[-1] = lines[-1][: column_end - 2]
    "let lines[0] = lines[0][column_start - 1:]
    "let l:joined = join(lines, "\n")



    let l:res = system('makeTree -s 4 "'.l:joined.'"')
    "let l:modified = substitute(l:res, '\x00', "\n", "g")
    "let l:modified = substitute(l:res, '\%x00', "\n", "g")
    "echom "=".l:res."="
    let l:modified = substitute(l:res, '[\x0]', "\n", "g")
    "call setline(1, l:modified)
    let o = @o
    let @o = l:modified
    normal! gv"op
    let @o=o
   " let l:modified = substitute(l:res, '[\x0]', "<CR>", "g")
   " call setline(1, l:modified)
    "echom "-".l:res."-"
    

endfunction

" Map a key in visual mode to trigger the function
"vnoremap <silent> <Leader>p :<C-u>call <SID>RunOnceProcessVisualSelection()<CR>

" Wrapper function to ensure it runs once
function! s:RunOnceProcessVisualSelection()
    " Exit visual mode explicitly
    normal! \<Esc>
    call ProcessVisualSelection()
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

function! GetJiraTicket()
    let l:gitdir = system("git status &> /dev/null; printf '%d' $?") 
    if l:gitdir == "0"
        let l:branch = system("git symbolic-ref --short HEAD")[:-2]
        let l:matcher = matchstr(l:branch,'TP-.*')
        if !empty(l:matcher)
            let l:ticket = matchstr(l:matcher,'TP-[0-9]\+')
            call setline('.',l:ticket)
        endif
    endif 
endfunction

function! MakeJson()
    "set foldmethod=syntax
    "set syntax=json
    silent execute '%!jq'
    ":%!jq
    ":.!jq .
    "noh
    "echom "Converted to JSON nicely"
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

function! MakeTodoItems()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    for i in lines
        silent execute '!todo -l 6 "'.i.'"' | execute ':redraw!'
    endfor
    echom "Done"
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


