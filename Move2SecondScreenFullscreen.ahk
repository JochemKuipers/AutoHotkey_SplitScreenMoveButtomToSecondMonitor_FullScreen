#Requires AutoHotkey v2.0

; Define a list of emulator executable paths
EmulatorPaths := Map()
EmulatorPaths["noods"] := "C:\Users\Jochem\Downloads\noods-windows\noods.exe"
EmulatorPaths["cemu"] := "D:\Cemu\Cemu.exe"
EmulatorPaths["citra"] := "D:\Citra\citra-qt.exe"
; Check if a command-line argument is provided
if (A_Args.Length > 0) {
    EmulatorKey := A_Args[1]
    if (EmulatorPaths.Has(EmulatorKey)) {
        EmulatorPath := EmulatorPaths[EmulatorKey]
    } else {
        MsgBox("Invalid emulator key provided.")
        ExitApp
    }
} 
else {
    MsgBox("No emulator key provided.")
    ExitApp
}

; Run the emulator


if EmulatorKey == "citra"{
    if !ProcessExist("citra-qt.exe") {
        Run(EmulatorPath)

        ; Give the emulator some time to load both screens (adjust the sleep time if needed)
        Sleep 2000
    }
    emulator_windows := WinGetList("ahk_exe citra-qt.exe")
}
else if EmulatorKey == "cemu"{ 
    
    if !ProcessExist("Cemu.exe") {
        Run(EmulatorPath)

        ; Give the emulator some time to load both screens (adjust the sleep time if needed)
        Sleep 2000
    }
    emulator_windows := WinGetList("ahk_exe Cemu.exe")
}
else if EmulatorKey == "noods"{

    if !ProcessExist("noods.exe") {
        Run(EmulatorPath)

        ; Give the emulator some time to load both screens (adjust the sleep time if needed)
        Sleep 2000
    }
    emulator_windows := WinGetList("ahk_exe noods.exe")
}
else{
    MsgBox("Invalid emulator key provided.")
    ExitApp
}

; Get the number of monitors
MonitorCount := SysGet(80) ; 80 is for the number of monitors

; Loop through each monitor and display its information
Loop MonitorCount
{
    MonitorIndex := A_Index
    MonitorName := "" ; Declare and initialize the variable 'MonitorName'
    MonitorX := "" ; Declare and initialize the variable 'MonitorX'
    MonitorY := "" ; Declare and initialize the variable 'MonitorY'
    MonitorWidth := "" ; Declare and initialize the variable 'MonitorWidth'
    MonitorHeight := "" ; Declare and initialize the variable 'MonitorHeight'
    
    MonitorName := MonitorGetName(MonitorIndex)
    MonitorGetWorkArea(MonitorIndex, &MonitorX, &MonitorY, &MonitorWidth, &MonitorHeight)
}

; Check if two windows are found
if (emulator_windows.Length > 1) {
    ; Move the first window (top screen) to the primary display and maximize it
    if WinExist(emulator_windows[2]) {
        WinActivate(emulator_windows[2])
        MonitorPrimary := MonitorGetPrimary()
        MonitorPrimaryLeft := SysGet(76)  ; 76 is for the left coordinate of the primary monitor's work area
        MonitorPrimaryTop := SysGet(77)   ; 77 is for the top coordinate of the primary monitor's work area
        WinMove(emulator_windows[2], MonitorPrimaryLeft, MonitorPrimaryTop)
        WinMaximize(emulator_windows[2])
        SendInput("{F11}")
    } else {
        MsgBox("First emulator window not found.")
    }

    ; Move the second window (bottom screen) to the secondary display and maximize it
    ; Assumes the secondary display is to the right of the primary display
    if (MonitorCount > 1) {
        ; Get the work area of the second monitor (index 2)
        Monitor2 := 2
        MonitorGetWorkArea(Monitor2, &Monitor2Left, &Monitor2Top, &Monitor2Right, &Monitor2Bottom)
        if WinExist(emulator_windows[1]) {
            WinActivate(emulator_windows[1])
            WinMove(Monitor2Left, Monitor2Top,,, emulator_windows[1])
            WinMaximize(emulator_windows[1])
            SendInput("{F11}")
        } else {
            MsgBox("Second emulator window not found.")
        }
    } else {
        MsgBox("Only one monitor detected.")
    }
} else {
    MsgBox("Less than two emulator windows found.")
}

return
