let s:DEEPLINK_ADB_TIMESTAMP_FILE = "dl_ts.txt"

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
"IMPORTANT for visual selections so function just runs once
vnoremap <localleader>dl :<c-u>call DeeplinkCheck()<cr>
vnoremap <localleader>cl :<c-u>call CheckLinesAreFiles()<cr>
vnoremap <localleader>mj :<c-u>call MakeSafeJsonObjectFromData()<cr>
nnoremap <localleader>cd :call GetCommitDescription()<cr>
nnoremap <localleader>jj :call GetJiraTicket()<cr>
nnoremap <localleader>jt :call GetJiraTicketUrl()<cr>
nnoremap <localleader>jb :call GetBranchName()<cr>
nnoremap <localleader>gh :call OpenGithubLine()<cr>
vnoremap <localleader>gh :<c-u>call OpenGithubLineRange()<cr>
nnoremap <localleader>ggb :call ToggleGitBlameGutter()<cr>
nnoremap <localleader>ca :call CalculateLineBC()<cr>
nnoremap <localleader>X :call MakeXML()<cr>
nnoremap <localleader>e :call EchoOutWordSay()<cr>
vnoremap <localleader>e :<c-u>call SelectionEchoOutWordSay()<cr>
vnoremap <localleader>6 :<c-u>call Base64EncodeLines()<cr>
vnoremap <localleader>0 :<c-u>call Base64DecodeLines()<cr>

nnoremap <localleader>cc :call CleanClaudeOutput()<cr>

nnoremap <localleader>R :<c-u>call ReplaceAcrossFile()<cr>

nnoremap <localleader>f :call WordToFiglet()<cr>
nnoremap <localleader>de :call TranslateToGerman()<cr>
nnoremap <localleader>en :call TranslateToEnglish()<cr>
nnoremap <localleader>m :call MakeFoldMarker()<cr>
nnoremap <localleader>= :call MakeNotes()<cr>
nnoremap <localleader>d :call ConvertToHumanTime()<cr>
vnoremap tt :<c-u>call MakeTodoItems()<cr>
nnoremap tt :call MakeTodoItem()<cr>
nnoremap tp :call MakeTodoItemHighPriority()<cr>


"Visual
function! MakeSafeJsonObjectFromData()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    let l:joined = join(lines, "\n")
    let l:count = 1
    let l:linenum = line_start
    echom lines
    for i in lines
        "redraw
        if len(i) > 0
            let l:matcher = matchlist(i, '\([a-zA-Z0-9]\+\)=\([a-zA-Z0-9]\+\)')

            if !empty(l:matcher)
                echom l:matcher[0]
                let capture_groups = l:matcher[1:]
                echom "->".capture_groups[0]
                echom "->".capture_groups[1]
                call setline(l:linenum,"OK")
            else
                call setline(l:linenum,"NOT")
            endif
        endif
        let l:count += 1
        let l:linenum += 1
    endfor
    "redraw
    return ''
endfunction

function! ExtractJustLinks()
    echom "---"
    silent execute 'g!/\(https\|gyg\)/d'
    silent execute '%s/\(.*\(\(http\|gyg\)[^ ]\+\).*\)/\2/g'
endfunction

" This function is set to script private
" it can only be called from within this script
function! s:CreateLocalFileInVimData(filePath)
    let filename = expand('~/.vim/data/'.a:filePath)
    if !filereadable(filename)
        call writefile([], filename)
        echo "File created: " . filename
        return 0
    else
        return 1
    endif
endfunction

function! s:GetSingleLineFromFile(filePath)
    let l:ans = s:GetFileContentsInVimData(a:filePath)
    if len(l:ans) > 0
        return l:ans[0]
    else
        return ""
    endif
endfunction

function! s:GetFileContentsInVimData(filePath)
    let filename = expand('~/.vim/data/'.a:filePath)
    if !filereadable(filename)
        let l:created = s:CreateLocalFileInVimData(a:filePath)
        if l:created == 0
            echom 'FILE CREATED'
        else
            echom 'FILE NOT CREATED: err'
        endif
    endif
    let lines = readfile(filename)
    return lines
endfunction

function! s:OverwriteFileContentsInVimData(filePath, dataChunks)
    let filename = expand('~/.vim/data/'.a:filePath)
    call writefile(a:dataChunks, filename)
endfunction

function! GetSampleData()
    "NOTE: Just a sample function for file reading and writing
    "let l:ans = s:GetFileContentsInVimData(s:DEEPLINK_ADB_TIMESTAMP_FILE)
    let l:ans = s:GetFileContentsInVimData("ben.txt")
    "echom 'OLD DATA--'.join(l:ans,",").'--'
    call s:OverwriteFileContentsInVimData('ben.txt',['ttest'])
endfunction


"function! ReadSampleFile()
"    let filename = expand('~/.vim/data/sample.txt')
"    if !filereadable(filename)
"        " File does not exist; create it
"        "NOTE: i created the dir myself as CBA
"        let lines = ['This is a new file.', 'Created by Vimscript.']
"        call writefile(lines, filename)
"        echo "File created: " . filename
"    else
"        echo "File already exists: " . filename
"        let lines = readfile(filename)
"        echom '->'.lines.'<-'
"    endif
"endfunction

function! ColorEchoTest()
    "highlight MyHighlightGroup ctermfg=Red guifg=Red
    echohl WarningMsg
    echom "This is something"
    echohl Title
    echom "This is something"
    echohl None
    echom "This sfafs"
endfunction

function! DeeplinkCheck()
    let [line_start, column_start] = getpos("'<")[1:2]
    echom '-'.line_start
    let [line_end, column_end] = getpos("'>")[1:2]
    echom '-'.line_end
    "return
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    let l:joined = join(lines, "\n")
    let l:count = 1
    let l:linenum = line_start
    for i in lines
        redraw
        echo 'Checking... '.i.' ('.l:count.'/'.len(lines).') ['.l:linenum.']'
        if len(i) > 0
            let l:out = system('adb shell am start -a android.intent.action.VIEW -d "'.i.'" &> /dev/null; sleep 2; adb logcat --regex "^BK" -d | tail -n 1')
            let l:splitLines = split(l:out,"\n")
            if len(l:splitLines) > 0
                let first_element = l:splitLines[0]
                let l:datestamp = system("echo '".first_element."' | awk '{printf(\"%s%s\", $1, $2)}'")
                let l:lastts = s:GetSingleLineFromFile(s:DEEPLINK_ADB_TIMESTAMP_FILE)
                if l:lastts == l:datestamp
                    echom 'SAME'
                    call append(l:linenum,"FAIL")
                    let l:linenum = l:linenum + 1
                else
                    let l:classname = system("echo '".first_element."' | awk '{printf(\"%s\", $9)}'")
                    call s:OverwriteFileContentsInVimData(s:DEEPLINK_ADB_TIMESTAMP_FILE,[l:datestamp])
                    if l:classname == "null"
                        echom 'WAS NULL'
                        call append(l:linenum,"NULL FAIL")
                        let l:linenum = l:linenum + 1
                    else
                        echom 'NOT SAME'
                        if len(l:out) > 0
                            call append(l:linenum ,split(l:out,"\n"))
                            let l:linenum = l:linenum + len(split(l:out,"\n"))
                        else
                            call append(l:linenum,"")
                            let l:linenum = l:linenum + 1
                        endif
                    endif
                endif
            endif
        endif
        let l:count += 1
        let l:linenum += 1
    endfor
    let l:count -= 1
    redraw
    echom '--DONE-- ('.l:count.'/'.len(lines).')'
    return l:joined
endfunction

function! CheckLinesAreFiles()
    let [line_start, column_start] = getpos("'<")[1:2]
    echom '-'.line_start
    let [line_end, column_end] = getpos("'>")[1:2]
    echom '-'.line_end
    "return
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 2]
    let lines[0] = lines[0][column_start - 1:]
    let l:joined = join(lines, "\n")
    let l:count = 1
    let l:linenum = line_start
    for i in lines
        redraw
        echo 'Checking... '.i.' ('.l:count.'/'.len(lines).') ['.l:linenum.']'
        let l:out = system('find . -name *'.i.'* -not -path "*/build/*"')
        if len(l:out) > 0
            call append(l:linenum ,split(l:out,"\n"))
            let l:linenum = l:linenum + len(split(l:out,"\n"))

        else
            call append(l:linenum,"")
            let l:linenum = l:linenum + 1
        endif
        let l:count += 1
        let l:linenum += 1
    endfor
    let l:count -= 1
    redraw
    echom '--DONE-- ('.l:count.'/'.len(lines).')'
    return l:joined
endfunction

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

function! ReplaceAcrossFile()
    let l:wordUnderCursor = expand("<cword>")
    echom "Replacing: " .l:wordUnderCursor
    let l:name = input('Enter name: ')
    echom "NEW: " .l:name
    silent execute '%s/\<'.l:wordUnderCursor.'\>/'.l:name.'/g'
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

function! GetBranchName()
    let l:gitdir = system("git status &> /dev/null; printf '%d' $?") 
    if l:gitdir == "0"
        let l:branch = system("git symbolic-ref --short HEAD")[:-2]
        call setline('.',l:branch)
    endif 
endfunction

function! GetCommitDescription()
    let l:gitdir = system("git status &> /dev/null; printf '%d' $?") 
    if l:gitdir == "0"
        let l:description = system("git log -1 --pretty=%B")[:-2]
        "call setline('.',l:description)
        call append(line('.'),split(l:description,"\n"))

    endif 
endfunction

function! GetJiraTicket()
    let l:gitdir = system("git status &> /dev/null; printf '%d' $?") 
    if l:gitdir == "0"
        "let l:branch = "feat/REE-1234-asdkj-safgf"
        let l:branch = system("git symbolic-ref --short HEAD")[:-2]
        "-2 strips the newline
        let l:matcher = matchstr(l:branch,'\(REE\)-.*')
        "^.*\/(REE)-[0-9]+
        if !empty(l:matcher)
            "Old way
            "let l:ticket = matchstr(l:matcher,'\(REE\)-[0-9]\+')
            let l:ticket = matchstr(l:branch,'^[^/]*/REE-[0-9]\+')
            let l:ticketCleaned = substitute(l:ticket, '/', ': ', '')
            call setline('.',l:ticketCleaned)
        endif
    endif 
endfunction

function! GetJiraTicketUrl()
    let l:base=expand('$JIRA_TICKETS_BASE_URL') "Set this env var to your jira url
    let l:gitdir = system("git status &> /dev/null; printf '%d' $?") 
    if l:gitdir == "0"
        let l:branch = system("git symbolic-ref --short HEAD")[:-2]
        let l:matcher = matchstr(l:branch,'\(TP\|CF\)-.*')
        if !empty(l:matcher)
            let l:ticket = matchstr(l:matcher,'\(TP\|CF\)-[0-9]\+')
            call setline('.',"[".l:ticket."](".l:base."/".l:ticket.")")
        endif
    endif 
endfunction

" Converts a git remote URL (ssh, git@ or https) into the https://github.com/user/repo form
" Returns '' if the remote isn't a github.com remote
function! s:GithubRemoteToHttps(remote)
    let l:remote = substitute(a:remote, '\.git$', '', '')
    if l:remote =~# '^git@github\.com:'
        return 'https://github.com/' . substitute(l:remote, '^git@github\.com:', '', '')
    elseif l:remote =~# '^ssh://git@github\.com/'
        return 'https://github.com/' . substitute(l:remote, '^ssh://git@github\.com/', '', '')
    elseif l:remote =~# '^https\?://github\.com/'
        return substitute(l:remote, '^http://', 'https://', '')
    else
        return ''
    endif
endfunction

" Builds the github.com/.../blob/<branch>/<path> url (no #L fragment) for the current buffer
" Uses the current branch, not master, so links stay correct on feature branches
function! s:BuildGithubBlobUrl()
    let l:gitcheck = system('git rev-parse --is-inside-work-tree 2>/dev/null')
    if l:gitcheck !~# '^true'
        echom 'Not inside a git repository'
        return ''
    endif

    let l:remote = system('git config --get remote.origin.url 2>/dev/null')[:-2]
    if empty(l:remote)
        echom "No 'origin' remote found"
        return ''
    endif

    let l:base = s:GithubRemoteToHttps(l:remote)
    if empty(l:base)
        echom 'Remote is not a GitHub repository: ' . l:remote
        return ''
    endif

    let l:branch = system('git symbolic-ref --short HEAD 2>/dev/null')[:-2]
    if empty(l:branch)
        echom 'Could not determine current branch (detached HEAD?)'
        return ''
    endif

    let l:root = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
    let l:filepath = expand('%:p')
    if l:filepath[:len(l:root)-1] !=# l:root
        echom 'File is not inside the repo root'
        return ''
    endif
    let l:relpath = l:filepath[len(l:root)+1:]

    return l:base . '/blob/' . l:branch . '/' . l:relpath
endfunction

function! s:OpenUrl(url)
    call system('open ' . shellescape(a:url))
    echom 'Opened: ' . a:url
endfunction

function! OpenGithubLine() abort
    let l:url = s:BuildGithubBlobUrl()
    if empty(l:url)
        return
    endif
    call s:OpenUrl(l:url . '#L' . line('.'))
endfunction

function! OpenGithubLineRange() abort
    let [l:line_start, l:col_start] = getpos("'<")[1:2]
    let [l:line_end, l:col_end] = getpos("'>")[1:2]
    let l:url = s:BuildGithubBlobUrl()
    if empty(l:url)
        return
    endif
    if l:line_start == l:line_end
        call s:OpenUrl(l:url . '#L' . l:line_start)
    else
        call s:OpenUrl(l:url . '#L' . l:line_start . '-L' . l:line_end)
    endif
endfunction

" ===== Git Blame Gutter =====
" Shows git blame (short hash, author, date) for every line of the current
" file in a scrollbound gutter window to the left, instead of just echoing
" the blame for the line under the cursor.
function! s:GitBlameParseLine(entry) abort
    let l:m = matchlist(a:entry, '^\^\?\([0-9a-f]\+\)\s\+(\(.\{-}\)\s\+\(\d\{4}-\d\{2}-\d\{2}\)\s\+\d\+)')
    if empty(l:m)
        return ''
    endif
    let l:hash = l:m[1][0:6]
    let l:author = substitute(l:m[2], '\s\+$', '', '')
    if len(l:author) > 15
        let l:author = l:author[0:14]
    endif
    return printf('%-7s %-15s %s', l:hash, l:author, l:m[3])
endfunction

" Called from inside the gutter window (e.g. via q) to close it and
" restore the source window's settings
function! s:CloseGitBlameGutter() abort
    let l:srcwinid = exists('b:git_blame_src_winid') ? b:git_blame_src_winid : 0
    close
    if l:srcwinid > 0 && win_gotoid(l:srcwinid)
        setlocal noscrollbind nocursorbind
        if exists('w:git_blame_gutter_winid')
            unlet w:git_blame_gutter_winid
        endif
    endif
endfunction

function! ToggleGitBlameGutter() abort
    " cursor is currently inside the blame gutter itself: close it
    if exists('w:is_git_blame_gutter') && w:is_git_blame_gutter
        call s:CloseGitBlameGutter()
        return
    endif

    " this window already has a blame gutter open next to it: close it
    if exists('w:git_blame_gutter_winid')
        let l:gutterwinid = w:git_blame_gutter_winid
        if win_gotoid(l:gutterwinid)
            call s:CloseGitBlameGutter()
        else
            unlet w:git_blame_gutter_winid
        endif
        return
    endif

    let l:gitcheck = system('git rev-parse --is-inside-work-tree 2>/dev/null')
    if l:gitcheck !~# '^true'
        echom 'Not inside a git repository'
        return
    endif

    let l:file = expand('%:p')
    if empty(l:file) || !filereadable(l:file)
        echom 'No file to blame'
        return
    endif

    let l:raw = systemlist('git blame --date=short -- ' . shellescape(l:file))
    if v:shell_error
        echom 'git blame failed: ' . (len(l:raw) > 0 ? l:raw[0] : 'unknown error')
        return
    endif

    let l:lines = map(copy(l:raw), 's:GitBlameParseLine(v:val)')
    let l:width = 4
    for l:entry in l:lines
        let l:width = max([l:width, len(l:entry)])
    endfor

    let l:srcwinid = win_getid()
    let l:topline = line('w0')
    let l:curline = line('.')

    execute 'leftabove ' . (l:width + 1) . 'vnew'
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal nowrap nonumber norelativenumber nocursorline
    setlocal foldcolumn=0 signcolumn=no
    setlocal filetype=gitblamegutter
    call setline(1, l:lines)
    setlocal nomodifiable nomodified
    let w:is_git_blame_gutter = 1
    let b:git_blame_src_winid = l:srcwinid
    let l:gutterwinid = win_getid()
    nnoremap <buffer> <silent> q :call <SID>CloseGitBlameGutter()<CR>
    setlocal scrollbind cursorbind

    call win_gotoid(l:srcwinid)
    let w:git_blame_gutter_winid = l:gutterwinid
    setlocal scrollbind cursorbind
    execute 'normal! ' . l:topline . 'Gzt' . l:curline . 'G'
    syncbind
endfunction

function! MakeJson()
    "set foldmethod=syntax
    "set syntax=json
    silent execute '%!jq'
    "%!jq -c to collapse all json
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

function! CleanClaudeOutput()
    let l:lines = getline(1, '$')
    let l:result = []

    for l:i in range(len(l:lines))
        let l:line = l:lines[l:i]

        if l:line =~# '^  '
            let l:stripped = l:line[2:]
        else
            let l:stripped = l:line
        endif

        if l:stripped =~# '^\s*$'
            call add(l:result, '')
            continue
        endif

        let l:is_continuation = 0
        if len(l:result) > 0 && l:result[-1] !~# '^\s*$'
            if l:stripped !~# '^\d\+[.)]\s' && l:stripped !~# '^[-*+]\s' && l:stripped !~# '^#' && l:stripped !~# '^>'
                let l:is_continuation = 1
            endif
        endif

        if l:is_continuation
            let l:result[-1] = l:result[-1] . ' ' . l:stripped
        else
            call add(l:result, l:stripped)
        endif
    endfor

    silent %delete _
    call setline(1, l:result)
    echom 'Claude output cleaned (' . len(l:lines) . ' lines -> ' . len(l:result) . ' lines)'
endfunction


