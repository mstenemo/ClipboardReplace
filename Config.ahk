#ifwinactive ClipboardReplace 
!p::
	guiControl, focus, Edit3
	return 

Esc:: ;this is the command to close RegEx replace plugin. 
	cancel:
	GuiClose:
	reload
	Return

!e::
	send !u
	send !c
	sleep 50
	reload ; closes ClipboardReplace and updates other AutoHotkey scripts
	return 

#ifwinactive 

Cbreplm()
	{
	global 
	#Include %A_ScriptDir%\Replace.ahk
	return 
	}