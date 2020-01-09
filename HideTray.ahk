InitHideTray:

IsHided := false
hw_tray := DllCall( "FindWindowEx", "uint",0, "uint",0, "str","Shell_TrayWnd", "uint",0 )
OnExit("ExitHideTray")

return

HideTray:

if (%IsHided% == false)
{
	WinHide, ahk_id %hw_tray%
	ToolTip, Hided
	Sleep, 1000
	ToolTip
	IsHided := true
}
else
{
	WinShow, ahk_id %hw_tray%
	ToolTip, Unhided
	Sleep, 1000
	ToolTip
	IsHided := false
}

ExitHideTray(ExitReason, ExitCode)
{
	WinShow, ahk_id %hw_tray%
}
