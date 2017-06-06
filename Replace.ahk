/*
Name: Clipboard Replace
Info: A plugin for a script by tidbit: Mango
Version 1.9.1 
Created: (Thu May 28, 2009)
Author: tidbit
*/

#singleinstance OFF
amount:=-1
mode:=""

help=
(
.	Matches any character.	cat. matches catT and cat2 but not catty
[]	Bracket expression. Matches one of any characters enclosed.	gr[ae]y matches gray or grey
[^]	Negates a bracket expression. Matches one of any characters EXCEPT those enclosed.	1[^02] matches 13 but not 10 or 12
[-]	Range. Matches any characters within the range.	[1-9] matches any single digit EXCEPT 0
?	Preceeding item must match one or zero times.	colou?r matches color or colour but not colouur
()	Parentheses. Creates a substring or item that metacharacters can be applied to	a(bee)?t matches at or abeet but not abet
{n}	Bound. Specifies exact number of times for the preceeding item to match.	[0-9]{3} matches any three digits
{n,}	Bound. Specifies minimum number of times for the preceeding item to match.	[0-9]{3,} matches any three or more digits
{n,m}	Bound. Specifies minimum and maximum number of times for the preceeding item to match.	[0-9]{3,5} matches any three, four, or five digits
|	Alternation. One of the alternatives has to match.	July (first|1st|1) will match July 1st but not July 2
[:alnum:]	alphanumeric character	[[:alnum:]]{3} matches any three letters or numbers, like 7Ds
[:alpha:]	alphabetic character, any case	[[:alpha:]]{5} matches five alphabetic characters, any case, like aBcDe
[:blank:]	space and tab	[[:blank:]]{3,5} matches any three, four, or five spaces and tabs
[:digit:]	digits	[[:digit:]]{3,5} matches any three, four, or five digits, like 3, 05, 489
[:lower:]	lowercase alphabetics	[[:lower:]] matches a but not A
[:punct:]	punctuation characters	[[:punct:]] matches ! or . or , but not a or 3
[:space:]	all whitespace characters, including newline and carriage return	[[:space:]] matches any space, tab, newline, or carriage return
[:upper:]	uppercase alphabetics	[[:upper:]] matches A but not a
	Default delimiters for pattern	colou?r matches color or colour
i	Append to pattern to specify a case insensitive match	colou?ri matches COLOR or Colour
\b	A word boundary, the spot between word (\w) and non-word (\W) characters	\bfred\bi matches Fred but not Alfred or Frederick
\B	A non-word boundary	fred\Bi matches Frederick but not Fred
\d	A single digit character	a\dbi matches a2b but not acb
\D	A single non-digit character	a\Dbi matches aCb but not a2b
\n	The newline character. (ASCII 10)	\n matches a newline
\r	The carriage return character. (ASCII 13)	\r matches a carriage return
\s	A single whitespace character	a\sb matches a b but not ab
\S	A single non-whitespace character	a\Sb matches a2b but not a b
\t	The tab character. (ASCII 9)	\t matches a tab.
\w	A single word character - alphanumeric and underscore	\w matches 1 or _ but not ?
\W	A single non-word character	a\Wbi matches a!b but not a2b
)

gui, +AlwaysOnTop +Resize
gui, add, text, x4  y6  w80  h20, &Find what?
gui, add, edit, x+2 yp  w250 r2 wanttab gPreview vfind,
gui, add, text, x4  y+3 w80  h20, Replace &with?
gui, add, edit, x+2 yp  w250 r2 wanttab gPreview vrepwith,

gui, add, button, xp+160 y+5 w90 h20 vbtnrep    greplace, &Replace
gui, add, button, xp     y+3 w90 h20 vbtnprev   gPreview Default, &Preview
gui, add, button, xp     y+3 w90 h20 vbtnCancel gcancel, Cancel (Esc)

gui, add, checkbox, x6  yp-50 h20 gPreview vcs, &Case Sensitive
gui, add, checkbox, x+5 yp    h20 gPreview vwwo, &Whole Words Only
gui, add, checkbox, x6  y+3   h20 gPreview vra +Checked, Replace &All?
gui, add, checkbox, xp  y+3   h20 gPreview vrem, Rege&x Mode
gui, add, button,   x+5 yp    h20 gregexhelp, ?

gui, font, s12, Verdana
gui, add, edit, x6 y+5 w330 h310 +HScroll vpreviewbox, %Clipboard%

gui, rhelp: add, text, y6 x6, Regex Help
gui, rhelp: add, ListView, yp+22 xp w450 r25 vlist, Key|Description|Example
gui, rhelp: default
Loop, Parse, help, `n, `r
	LV_Add( "", strSplit(A_loopField, "`t")*)

LV_ModifyCol(1, "Auto")
LV_ModifyCol(2, 200)
LV_ModifyCol(3, "Auto")


gui, 1: default
gui, Show,, Clipboard Replace
gosub, Preview
Return


rhelpguiClose:
	gui, hide
Return


OnClipboardChange:
	gosub, Preview
Return


replace:
	gui, Submit, NoHide
	gui, default
	Gosub, setup
	guiControl, , previewbox, %Clipboard%
Return


setup:
	gui, Submit, NoHide
	gui, default
	if (cs=1) ; case sensitive
		case:=""
	Else
		case:="i)"

	if (rem=0) ; regex mode
		find:=regExReplace(find,  "[\\.*?+[{|()^$]", "\$0")

	; this >>MUST<< be after Regex Mode.
	if (wwo=1) ; whole words only
		find:="\b" find "\b"

	if (ra=1) ; replace all
		amount:=-1
	Else
		amount:=1
Return


Preview:
	gui, Submit, NoHide
	gui, default
	Gosub, setup

	reg:=case find
	previewChange:=RegExReplace(Clipboard, reg, repwith)
	guiControl, , previewbox, %previewChange%
Return


guiSize:
	if (errorlevel=1) ; The window has been Minimized.  No action needed.
		Return
	guiControl, Move, btnrep,  % "x" A_guiWidth-96
	guiControl, Move, btnprev, % "x" A_guiWidth-96
	guiControl, Move, btnCancel, % "x" A_guiWidth-96
	guiControl, Move, find, % "w" A_guiWidth-91
	guiControl, Move, repwith, % "w" A_guiWidth-91
	guiControl, Move, previewbox, % "w" A_guiWidth-6 " h" A_guiHeight-127
Return


regexhelp:
	gui, rhelp: show,, Regex Help
Return


Esc::
cancel:
guiClose:
	ExitApp
Return

