; ------------
; CORE HOTKEYS
; ------------

^+!r::Reload
#SuspendExempt True
^+!s::Suspend
#SuspendExempt False

#Down::WinMinimize("A")

; --------------------
; OPEN PROGRAM HOTKEYS
; --------------------

^`::{
  if (WinExist("ahk_exe chrome.exe")) {
    WinActivate("ahk_exe chrome.exe")
  } else {
    Run("C:\Program Files\Google\Chrome\Application\chrome.exe")
  }
}

^+`::{
  if (WinExist("ahk_exe notepad.exe")) {
    WinActivate "ahk_exe notepad++.exe"
  } else {
    Run("C:\Program Files\Notepad++\notepad++.exe")
  }
}

^+!`::{
  if (WinExist("ahk_exe msedge.exe")) {
    WinActivate("ahk_exe msedge.exe")
  } else {
    Run("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")
  }
}

^5::{
  ; "wt.exe" is not the real process name:
  ; https://stackoverflow.com/a/68006153/26408392
  if (WinExist("ahk_exe WindowsTerminal.exe")) {
    WinActivate("ahk_exe WindowsTerminal.exe")
  } else {
    Run(A_AppData . "\..\Local\Microsoft\WindowsApps\wt.exe")
  }
}

^+5::{
  Run(A_AppData . "\..\Local\Microsoft\WindowsApps\wt.exe")
}

^6::{
  if (WinExist("ahk_exe Code.exe")) {
    WinActivate("ahk_exe Code.exe")
  } else {
    Run(A_AppData . "\..\Local\Programs\Microsoft VS Code\Code.exe")
  }
}

^8::{
  if (WinExist("ahk_exe ms-teams.exe")) {
    WinActivate "ahk_exe ms-teams.exe"
  } else {
    Run(A_AppData . "\..\Local\Microsoft\WindowsApps\MSTeams_8wekyb3d8bbwe\ms-teams.exe")
  }
}

^0::{
  if (WinExist("ahk_exe olk.exe")) {
    WinActivate "ahk_exe olk.exe"
  } else {
    Run("C:\Program Files\WindowsApps\Microsoft.OutlookForWindows_1.2024.619.100_x64__8wekyb3d8bbwe\olk.exe")
  }
}

^+k::Run("C:\Users\jnesta\OneDrive - LogixHealth Inc\Documents\KiTTY\kitty_portable.exe")
^+s::Run(A_AppData . "\..\Local\Programs\WinSCP\WinSCP.exe")
