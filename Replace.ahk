/*
Name: Mango: Clipboard Replace
Version 2.0 (Thursday, May 25, 2017)
Created: (Thu May 28, 2009)
Author: tidbit
Info: A plugin for my personal script: Mango
*/
 
; #singleinstance force
#singleinstance OFF
 
help=
(
.   Matches any character.  cat. matches catT and cat2 but not catty
[]  Bracket expression. Matches one of any characters enclosed. gr[ae]y matches gray or grey
[^] Negates a bracket expression. Matches one of any characters EXCEPT those enclosed.  1[^02] matches 13 but not 10 or 12
[-] Range. Matches any characters within the range. [1-9] matches any single digit EXCEPT 0
?   Preceeding item must match one or zero times.   colou?r matches color or colour but not colouur
()  Parentheses. Creates a substring or item that metacharacters can be applied to  a(bee)?t matches at or abeet but not abet
{n} Bound. Specifies exact number of times for the preceeding item to match.    [0-9]{3} matches any three digits
{n,}    Bound. Specifies minimum number of times for the preceeding item to match.  [0-9]{3,} matches any three or more digits
{n,m}   Bound. Specifies minimum and maximum number of times for the preceeding item to match.  [0-9]{3,5} matches any three, four, or five digits
|   Alternation. One of the alternatives has to match.  July (first|1st|1) will match July 1st but not July 2
[:alnum:]   alphanumeric character  [[:alnum:]]{3} matches any three letters or numbers, like 7Ds
[:alpha:]   alphabetic character, any case  [[:alpha:]]{5} matches five alphabetic characters, any case, like aBcDe
[:blank:]   space and tab   [[:blank:]]{3,5} matches any three, four, or five spaces and tabs
[:digit:]   digits  [[:digit:]]{3,5} matches any three, four, or five digits, like 3, 05, 489
[:lower:]   lowercase alphabetics   [[:lower:]] matches a but not A
[:punct:]   punctuation characters  [[:punct:]] matches ! or . or , but not a or 3
[:space:]   all whitespace characters, including newline and carriage return    [[:space:]] matches any space, tab, newline, or carriage return
[:upper:]   uppercase alphabetics   [[:upper:]] matches A but not a
    Default delimiters for pattern  colou?r matches color or colour
i   Append to pattern to specify a case insensitive match   colou?ri matches COLOR or Colour
\b  A word boundary, the spot between word (\w) and non-word (\W) characters    \bfred\bi matches Fred but not Alfred or Frederick
\B  A non-word boundary fred\Bi matches Frederick but not Fred
\d  A single digit character    a\db matches a2b but not acb
\D  A single non-digit character    a\Db matches aCb but not a2b
\n  The newline character. (ASCII 10)   \n matches a newline
\r  The carriage return character. (ASCII 13)   \r matches a carriage return
\s  A single whitespace character   a\sb matches a b but not ab
\S  A single non-whitespace character   a\Sb matches a2b but not a b
\t  The tab character. (ASCII 9)    \t matches a tab.
\w  A single word character - alphanumeric and underscore   \w matches 1 or _ but not ?
\W  A single non-word character a\Wbi matches a!b but not a2b
)

gui, +AlwaysOnTop +Resize
gui, margin, 3, 3
gui, add, text, xm  ym  w80  h20, &Find what?
gui, add, edit, x+2 yp  w555 r2 wanttab gPreview vfind,
gui, add, text, xm  y+3 w80  h20, Replace &with?
gui, add, edit, x+2 yp  w555 r2 wanttab gPreview vrepwith,
; gui, add, text, xm  y+3 w80   h20, &ATest ; yyyyy added to try to create shortcut 
; gui, add, edit, x+2 yp  w555  r2 wanttab gPreview vtest, ; yyyyy added to try to create shortcut 
 
gui, add, button, xp+160 y+3 w90 h20 vbtnUpdate gupdate Default, &Update Content
gui, add, button, xp     y+5 w90 h20 vbtnCopy   gcopy, &Copy
 
gui, add, checkbox, xm  yp-26 h20 gPreview vcs, Ca&se Sensitive
gui, add, checkbox, x+5 yp    h20 gPreview vwwo, &On Whole Words
gui, add, checkbox, xm  y+3   h20 gPreview vra 	+Checked, Replace &All?
gui, add, checkbox, xp  y+3   h20 gPreview vrem	+Checked, Rege&x Mode
gui, add, button,   x+5 yp    h20 gregexhelp, ?
 
 
ttt:="aaa bbb`nccc aaa`n`nbbb aaaaaaaaaaaaaa"
gui, font, s12, Verdana
; gui, add, edit, x6 y+5 w330 h310 +HScroll vpreviewbox, %ttt%
gui, add, edit, xm y+5 w330 h310 +HScroll vpreviewbox, %Clipboard% 
 
gui, rhelp: add, text, y6 x6, Regex Help
gui, rhelp: add, ListView, yp+22 xp w450 r25 vlist, Key|Description|Example
gui, rhelp: default
Loop, Parse, help, `n, `r
    LV_Add( "", strSplit(A_loopField, "`t")*)
 
LV_ModifyCol(1, "Auto")
LV_ModifyCol(2, 200)
LV_ModifyCol(3, "Auto")
 
 
gui, 1: default
gui, Show,, ClipboardReplace
gosub, update
gosub, preview
Return
 
 
rhelpguiClose:
    gui, rhelp: hide
    gui, default
Return
 
regexhelp:
    gui, rhelp: show,, Regex Help
Return
 
update:
    guiControlGet, previewbox
    toModify:=previewbox
return
 
 
copy:
    gui, Submit, NoHide
    guiControlGet, clipboard,, previewbox
    soundBeep
Return
 
 
preview:
    gui, Submit, NoHide
    gui, default
    new:=""
    needle:=""
 
    if (rem=0)
    {
        find:="\Q" find "\E"                    ; make it treated as literal text
        needle.=(cs=1) ? "" : "i)"              ; add the case-sensitive option
        needle.=(wwo=1) ? "\b" find "\b" : find ; add the add whole-word boundaries
        new:=regExReplace(toModify, needle, repwith,, (ra=1)? -1 : 1)
    }
    else
    {
        needle.=(cs=1) ? "" : "i)"
        needle.=(wwo=1) ? "\b" find "\b" : find
        new:=regExReplace(toModify, needle, repwith,, (ra=1)? -1 : 1)
    }
   
    guiControl,, previewbox, %new%
Return
 
 
guiSize:
    if (errorlevel=1) ; The window has been Minimized.  No action needed.
        Return
    guiControlGet, pos, pos, find
    guiControl, Move, btnCopy,  % "x" A_guiWidth-90-3
    guiControl, Move, btnUpdate, % "x" A_guiWidth-90-3
    guiControl, Move, find, % "w" A_guiWidth-posx-3
    guiControl, Move, repwith, % "w" A_guiWidth-posx-3
    guiControlGet, pos, pos, previewbox
    guiControl, Move, previewbox, % "w" A_guiWidth-posx-3 " h" A_guiHeight-posy-3
Return
 
 
; cancel:
; guiClose:
; guiEscape:
    ; ExitApp
; Return