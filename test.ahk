EmulatorPath := "C:\Users\Jochem\Downloads\noods-windows\noods.exe"

; Run the emulator
Run(EmulatorPath)

; Give the emulator some time to load both screens (adjust the sleep time if needed)
Sleep 2000

emulator_windows := WinGetList("ahk_class wxWindowNR")

MsgBox("Found " emulator_windows.Length " emulator windows.")