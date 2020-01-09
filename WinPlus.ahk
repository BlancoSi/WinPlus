#NoEnv
#SingleInstance, Force
#UseHook
SendMode Input
SetWorkingDir, %A_ScriptDir%

Menu, Tray, Icon, favicon.ico,, 1

Gosub, InitShortcutsList	; 初始化快捷菜单
;Gosub, InitNumMouse	; 初始化小键盘鼠标
Gosub, InitHideTray	;初始化隐藏任务栏

#b::SoundBeep, 750, 500	; 测试beep

#`::reload	; reload脚本

<#LAlt::  ; 状态
Progress
		, x50 y950 m b1 fs30 zh0 CTFFFFFF CW808080
		, %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%
		, , , Courier New
Sleep, 1500
Progress, Off
return

>#Enter::Suspend	; 挂起/启用热键

#s::Run https://www.baidu.com/s?ie=UTF-8&wd=%clipboard%	; 搜索剪切板内容

#=::Send {Volume_Up}	; 音量+

#-::Send {Volume_Down}	; 音量-

#0::Run calc	; 打开计算器

#]::Send {Media_Next}	; 下一首

#[::Send {Media_Prev}	; 上一首

#'::Send {Media_Play_Pause}	; 暂停

#Del::FileRecycleEmpty	; 清空回收站

^Space::PostMessage, 0x50, 0, 0x4090409,, A	; 切为英文输入法

#End::	; 关闭显示器
Sleep 100
SendMessage, 0x112, 0xF170, 2,, Program Manager
return

<#RButton:: Menu, ShortcutsList, Show, %A_GuiX%, %A_GuiY%	; 显示快捷菜单

;<#Enter::Gosub, NumMouse	;启动小键盘鼠标

<#Enter::Gosub, HideTray	;隐藏任务栏

#Include  %A_ScriptDir%/ShortcutsList.ahk	; 包含快捷菜单

;#Include  %A_ScriptDir%/NumMouse.ahk	;包含小键盘鼠标

#Include HideTray.ahk	;包含隐藏任务栏

;十六进制代码
	; 0x50 是 WM_INPUTLANGCHANGEREQUEST
	; 0x112 是 WM_SYSCOMMAND, 0xF170 是 SC_MONITORPOWER
	; 参见https://wyagd001.github.io/zh-cn/docs/commands/PostMessage.htm
;待处理
	;EnvUpdate