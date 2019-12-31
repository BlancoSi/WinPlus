; Gosub, InitShortcutsList
; <#RButton:: Menu, ShortcutsList, Show, %A_GuiX%, %A_GuiY%
InitShortcutsList:

; 存档名 settingstxt.txt
SplitPath, A_ScriptFullPath,,,, settingstxt
settingstxt .= ".txt"
; 检查存档
IfExist, %settingstxt%
settingsExist := 1

; 变量输入有%0%个

If (%0% == 0)	; 没有输入
{
	If (settingsExist)	; 有存档
	{
		Gosub, DoHaveSetings
	}
	Else	; 没存档
	{
		Msgbox Drag something on this to creat a table. Application Closed.
		ExitApp
	}
}
Else	; 有输入
{
	Loop, %0%
		Loop, % %A_Index%, 1 ; %A_Index%为上一级当前循环次数
		{
			; 文件夹还是文件
			FileGetAttrib, isFileNotFolder, %A_LoopFileLongPath%
			isFileNotFolder := (InStr(isFileNotFolder, "d") ? 0 : 1)
			FileAppend, % (settingsExist ? "`n" : "") A_LoopFileName (isFileNotFolder ? "" : "\") "|" A_LoopFileLongPath, %settingstxt%
		}
	Gosub, DoHaveSetings
}

Return

; 执行
LaunchFiles:
Run, % paths[A_ThisMenuItem]
Return

; 有存档文件
DoHaveSetings:
FileRead, settings, %settingstxt%
paths := {}	; 路径列表
Loop, Parse, settings, `n, `r
{
	StringSplit, singleRecordPart, A_LoopField, |	; 以竖线为分隔符
	Menu, ShortcutsList, Add, %A_Index%. %singleRecordPart1%, LaunchFiles	; 菜单创建一行
	If (singleRecordPart1 ~= "iS)^.*\.exe$")	; *.exe图标
		Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, %singleRecordPart2%
	Else If (singleRecordPart1 ~= "iS)^.*\\$")	; 文件夹图标
		Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, shell32.dll, 4
	Else	; 其他图标
	{
		thisFileExtension := chopString(singleRecordPart1)
		RegRead, temp, HKCR, .%thisFileExtension%
		RegRead, icoPath, HKCR, %temp%\DefaultIcon
		If !ErrorLevel
		{
			thisIconLibPath := chopString(icoPath, "`,", 1)
			thisIconNumberInLib := chopString(icoPath, "`,")
		}
		Else	; There's no path to the icon stored in the registry (example is .pdf being handled by "SumatraPDF portable")
		{
			RegRead, icoPath, HKCR, %temp%\shell\open\command
			thisIconNumberInLib := 1
		}
		If InStr(thisIconLibPath, """")
			thisIconLibPath := chopString(icoPath, """", 2)	; Might be unreliable. Usually the path is like '"C:\path\to\file.exe" "%1"' or just '"C:\path\to\file.exe"' and it has to be normalized for further use.
		Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, %thisIconLibPath%, %thisIconNumberInLib%
	}
	paths.Insert(A_Index ". " singleRecordPart1, singleRecordPart2)	; 插入对应地址
}
Return

; 获取后缀
chopString(string, delimiter = ".", nthPart = 0)
{
	StringSplit, section, string, %delimiter%
	Return ((nthPart) ? (section%nthPart%) : (section%section0%))
	; %xxxx0%为伪数组%xxxx%所含对数
}
