#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, Force
    
    Try
    Menu, Tray, Icon, C:\Windows\system32\FileHistory.exe,1
	IniRead, IconResource, %A_WorkingDir%\Desktop.ini, .ShellClassInfo, IconResource
	DesktopINIIco := StrSplit(IconResource,"`,")
	DesktopINIIcoPath := DesktopINIIco[1]
	DesktopINIIcoNumb := DesktopINIIco[2]

	ICOSwapTime := 500
	Gosub AltIcons

    Start := A_Now
    StartTime := A_TickCount
    Process, Priority,,Low
    DestinationPath = \\server\share\ OR Drv:\Folder
    FileCreateDir, DestinationPath
    arr := StrSplit(A_WorkingDir, "\")		; split the string dir at all \s
    DestinationFile := arr[arr.MaxIndex()]	; take the last element of the created array
    Type = a
    IfExist, %DestinationPath%\%DestinationFile% [%A_YYYY%-%A_MM%-%A_DD%].7z
        Type = u
    
    args = %Type% "%DestinationPath%\%DestinationFile% [%A_YYYY%-%A_MM%-%A_DD%].7z" -pRiata -ms=off -mx=9 -myx=9 -mm=LZMA2 -mtm=on -mhe=on -mhc=on -mtc=on -ssw -ssp -bsp1 -slt -slp -bt "%A_WorkingDir%"
    
    ; MsgBox, ,,Admin Status : %A_IsAdmin%`n`nCommand:`n"%A_ProgramFiles%\7-Zip\7z.exe" %args%, 30
    SetTimer, AltIcons,  %ICOSwapTime%
    RunWait,  "%A_ProgramFiles%\7-Zip\7z.exe" %args% , %DestinationPath%,min
    
    PSScriptBlock = Get-ChildItem -Path "%DestinationPath%" -Recurse -Force | Where-Object { $_.LastWriteTime -lt $((Get-Date).AddDays(-28)) } | Remove-Item -Force `; Timeout /t 30
    
    IfExist,C:\Program Files\PowerShell\7\pwsh.exe
        RunWait, C:\Program Files\PowerShell\7\pwsh.exe -ExecutionPolicy ByPass -Command %PSScriptBlock%, %DestinationPath%,min
    Else
        RunWait, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -Command %PSScriptBlock%, %DestinationPath%,min
    
    RunTime := FormatSeconds((A_TickCount-StartTime)/1000)
    IniWrite, %RunTime%, %DestinationPath%\%A_ScriptName%.ini, %A_ComputerName% > Log-%DestinationFile%, %Start%
    
    ExitApp, 0
    
    FormatSeconds(NumberOfSeconds)  ; Convert the specified number of seconds to hh:mm:ss format.
    {
        time = 19990101  ; *Midnight* of an arbitrary date.
        time += %NumberOfSeconds%, seconds
        FormatTime, mmss, %time%, mm:ss
            SetFormat, float, 2.0
            return NumberOfSeconds//3600 ":" mmss  ; This method is used to support more than 24 hours worth of sections.
    }
    
AltIcons:
    {
        Try
        Menu, Tray, Icon, C:\Windows\system32\FileHistory.exe,1

        sleep, %ICOSwapTime%

        Try
        Menu, Tray, Icon, C:\Program Files\7-Zip\7zFM.exe,2

        sleep,  %ICOSwapTime%

        Try
        Menu, Tray, Icon, %DesktopINIIcoPath%,%DesktopINIIcoNumb%

          sleep,  %ICOSwapTime%
      
        return
    }
