; --------
; SETTINGS
; --------

#Warn ; Enable all warnings.
SetKeyDelay(-1) ; No delay
SetWinDelay(-1) ; No delay
SetTitleMatchMode(1) ; A window's title must start with the specified WinTitle to be a match.

; ------------
; CORE HOTKEYS
; ------------

^+!r::Reload
#SuspendExempt True
^+!s::Suspend
#SuspendExempt False

#Down::WinMinimize("A")

; Cycle program windows forward.
#Tab::{
  activeProcessName := WinGetProcessName("A")
  windowIDs := WinGetList("ahk_exe " activeProcessName)

  if (windowIDs.Length <= 1) {
    return
  }

  sortedWindowIDs := SortNumArray(windowIDs)
  activeWindowID := WinGetID("A")
  activeWindowIndex := 0

  for index, windowID in sortedWindowIDs
  {
    if (windowID = activeWindowID)
    {
      activeWindowIndex := index
      break
    }
  }

  if (activeWindowIndex = 0)
  {
    return
  }

  nextWindowIndex := activeWindowIndex + 1
  if (nextWindowIndex > sortedWindowIDs.Length)
  {
    nextWindowIndex := 1
  }

  nextWindowID := sortedWindowIDs[nextWindowIndex]
  WinActivate("ahk_id " nextWindowID)
}

; Cycle program windows backward.
#+Tab::{
  activeProcessName := WinGetProcessName("A")
  windowIDs := WinGetList("ahk_exe " activeProcessName)

  if (windowIDs.Length <= 1) {
    return
  }

  sortedWindowIDs := SortNumArray(windowIDs)
  activeWindowID := WinGetID("A")
  activeWindowIndex := 0

  for index, windowID in sortedWindowIDs
  {
    if (windowID = activeWindowID)
    {
      activeWindowIndex := index
      break
    }
  }

  if (activeWindowIndex = 0)
  {
    return
  }

  previousWindowIndex := activeWindowIndex - 1
  if (previousWindowIndex < 1)
  {
    previousWindowIndex := sortedWindowIDs.Length
  }

  previousWindowID := sortedWindowIDs[previousWindowIndex]
  WinActivate("ahk_id " previousWindowID)
}

; From: https://www.autohotkey.com/boards/viewtopic.php?t=113911
SortNumArray(arr) {
  str := ""
  for k, v in arr {
    str .= v "`n"
  }
  str := Sort(RTrim(str, "`n"), "N")
  return StrSplit(str, "`n")
}

; --------------------
; OPEN PROGRAM HOTKEYS
; --------------------

^`::{
  if (WinExist("ahk_exe msedge.exe")) {
    WinActivate("ahk_exe msedge.exe")
  } else {
    Run("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")
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
  if (WinExist("ahk_exe firefox.exe")) {
    WinActivate("ahk_exe firefox.exe")
  } else {
    Run("C:\Program Files\Mozilla Firefox\firefox.exe")
  }
}

;^1::{}

;^2::{}

^3::{
  if (WinExist("ahk_exe RemoteDesktopManager.exe")) {
    WinActivate("ahk_exe RemoteDesktopManager.exe")
  } else {
    Run("C:\Program Files\Devolutions\Remote Desktop Manager\RemoteDesktopManager.exe")
  }
}

^4::{
  if (WinExist("ahk_exe kitty_portable.exe")) {
    WinActivate("ahk_exe kitty_portable.exe")
  } else {
    Run("C:\Users\jnesta\OneDrive - LogixHealth Inc\Documents\KiTTY\kitty_portable.exe")
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
    Run(A_AppData . "\..\Local\Microsoft\WindowsApps\MSTeams_8wekyb3d8bbwe\ms-teams.exe") ; cspell:disable-line
  }
}

^9::{
  if (WinExist("ahk_exe chrome.exe")) {
    WinActivate("ahk_exe chrome.exe")
  } else {
    Run("C:\Program Files\Google\Chrome\Application\chrome.exe")
  }
}

^0::{
  if (WinExist("ahk_exe olk.exe")) {
    WinActivate "ahk_exe olk.exe"
  } else {
    Run("C:\Program Files\WindowsApps\Microsoft.OutlookForWindows_1.2024.619.100_x64__8wekyb3d8bbwe\olk.exe") ; cspell:disable-line
  }
}

^+k::Run("C:\Users\jnesta\OneDrive - LogixHealth Inc\Documents\KiTTY\kitty_portable.exe")
^+s::Run(A_AppData . "\..\Local\Programs\WinSCP\WinSCP.exe")

; Win+Z for debugging
#z::{
  Run(A_ComSpec " /k whoami")
}
