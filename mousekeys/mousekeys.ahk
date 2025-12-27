#Requires AutoHotkey v2.0
#SingleInstance Force
InstallKeybdHook()

; --- INITIAL CONFIGURATION & LOADING ---
Global SettingsFile := A_ScriptDir "\ArrowMouseSettings.ini"
Global IconPath := "C:\Users\felix\Desktop\mousekeys\mousekeys.ico"
Global StartupShortcut := A_Startup "\MouseKeys.lnk"

; Default Values
Global DefStart := 2.0, DefMax := 18.0, DefAcc := 0.15, DefCurve := 1.2
Global DefToggle := "CapsLock", DefUp := "Up", DefDown := "Down", DefLeft := "Left", DefRight := "Right", DefClick := "Space", DefRClick := "\"

; Load Speed Settings
Global NormalSpeed := Float(IniRead(SettingsFile, "Speed", "Start", DefStart))
Global MaxSpeed := Float(IniRead(SettingsFile, "Speed", "Max", DefMax))
Global Acceleration := Round(Float(IniRead(SettingsFile, "Speed", "Acc", DefAcc)), 2)
Global AccCurve := Float(IniRead(SettingsFile, "Speed", "Curve", DefCurve))
Global CurrentSpeed := NormalSpeed

; Load Key Settings
Global KeyToggle := IniRead(SettingsFile, "Keys", "Toggle", DefToggle)
Global KeyUp := IniRead(SettingsFile, "Keys", "Up", DefUp)
Global KeyDown := IniRead(SettingsFile, "Keys", "Down", DefDown)
Global KeyLeft := IniRead(SettingsFile, "Keys", "Left", DefLeft)
Global KeyRight := IniRead(SettingsFile, "Keys", "Right", DefRight)
Global KeyClick := IniRead(SettingsFile, "Keys", "Click", DefClick)
Global KeyRightClick := IniRead(SettingsFile, "Keys", "RClick", DefRClick)

; --- GUI DESIGN ---
MyGui := Gui("-MinimizeBox -MaximizeBox", "MouseKeys Pro | v4.2")
MyGui.SetFont("s10 w600", "Segoe UI")
MyGui.BackColor := "0xFFFFFF"

if FileExist(IconPath) {
    Try {
        TraySetIcon(IconPath)
        OutType := 0
        hIconSmall := LoadPicture(IconPath, "w16 h16", &OutType)
        hIconBig := LoadPicture(IconPath, "w32 h32", &OutType)
        SendMessage(0x80, 0, hIconSmall, MyGui.Hwnd)
        SendMessage(0x80, 1, hIconBig, MyGui.Hwnd)
    }
}

; Section: Activation
MyGui.Add("GroupBox", "w280 h75 cBlack", " ⏻ Activation Key ")
MyGui.SetFont("s9 w400")
MyGui.Add("Text", "xp+15 yp+30", "Hold to move:")
BindToggle := MyGui.Add("Hotkey", "x+10 yp-3 w110", KeyToggle)

; Section: Speed & Curve
MyGui.SetFont("s10 w600")
MyGui.Add("GroupBox", "xm w280 h170 cBlack", " ⚡ Speed & Curve ")
MyGui.SetFont("s9 w400")
MyGui.Add("Text", "xp+15 yp+30", "Start Speed:")
EditStart := MyGui.Add("Edit", "x+15 yp-3 w65 -VScroll -Multi", NormalSpeed)
MyGui.Add("Text", "xp-82 yp+35", "Max Speed:")
EditMax := MyGui.Add("Edit", "x+19 yp-3 w65 -VScroll -Multi", MaxSpeed)
MyGui.Add("Text", "xp-82 yp+35", "Acceleration:")
EditAcc := MyGui.Add("Edit", "x+13 yp-3 w65 -VScroll -Multi", Acceleration)
MyGui.Add("Text", "xp-82 yp+35", "Smoothness:")
EditCurve := MyGui.Add("Edit", "x+16 yp-3 w65 -VScroll -Multi", AccCurve)

; Section: Keybinds
MyGui.SetFont("s10 w600")
MyGui.Add("GroupBox", "xm w280 h195 cBlack", " ⌨ Key Bindings ")
MyGui.SetFont("s9 w400")
MyGui.Add("Text", "xp+15 yp+30", "Up:")
BindUp := MyGui.Add("Hotkey", "x+38 yp-3 w65", KeyUp)
MyGui.Add("Text", "xp-58 yp+40", "Down:")
BindDown := MyGui.Add("Hotkey", "x+22 yp-3 w65", KeyDown)
MyGui.Add("Text", "xp-58 yp+40", "Left:")
BindLeft := MyGui.Add("Hotkey", "x+29 yp-3 w65", KeyLeft)

MyGui.Add("Text", "x160 yp-80", "Right:")
BindRight := MyGui.Add("Hotkey", "x+15 yp-3 w65", KeyRight)
MyGui.Add("Text", "xp-52 yp+40", "L-Click:")
BindClick := MyGui.Add("Hotkey", "x+10 yp-3 w65", KeyClick)
MyGui.Add("Text", "xp-52 yp+40", "R-Click:")
BindRClick := MyGui.Add("Hotkey", "x+10 yp-3 w65", KeyRightClick)

; Options & Buttons
MyGui.SetFont("s9 w400")
CheckTray := MyGui.Add("Checkbox", "xm+5 yp+55 Checked", "Minimize to tray on save")
CheckStartup := MyGui.Add("Checkbox", "x+10", "Run at startup")
CheckStartup.Value := FileExist(StartupShortcut) ? 1 : 0

BtnReset := MyGui.Add("Button", "xm w135 h40", "RESET DEFAULTS")
BtnReset.OnEvent("Click", ResetDefaults)

BtnSave := MyGui.Add("Button", "x+10 w135 h40 Default", "SAVE & APPLY")
BtnSave.OnEvent("Click", ApplySettings)

A_TrayMenu.Delete()
A_TrayMenu.Add("Show MouseKeys", (*) => MyGui.Show())
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.Default := "Show MouseKeys"

MyGui.OnEvent("Size", (GuiObj, MinMax, Width, Height) => (MinMax = -1 && CheckTray.Value) ? MyGui.Hide() : "")

if (A_Args.Length > 0 && A_Args[1] = "/hide") || FileExist(A_Temp "\mk_hide.tmp") {
    if FileExist(A_Temp "\mk_hide.tmp")
        FileDelete(A_Temp "\mk_hide.tmp")
    MyGui.Hide()
} else {
    MyGui.Show()
}

; --- LOGIC ---

ResetDefaults(*) {
    BindToggle.Value := DefToggle
    EditStart.Value := String(DefStart)
    EditMax.Value := String(DefMax)
    EditAcc.Value := "0.15"
    EditCurve.Value := String(DefCurve)
    BindUp.Value := DefUp
    BindDown.Value := DefDown
    BindLeft.Value := DefLeft
    BindRight.Value := DefRight
    BindClick.Value := DefClick
    BindRClick.Value := DefRClick
}

ApplySettings(*) {
    Global
    IniWrite(BindToggle.Value, SettingsFile, "Keys", "Toggle")
    IniWrite(EditStart.Value, SettingsFile, "Speed", "Start")
    IniWrite(EditMax.Value, SettingsFile, "Speed", "Max")
    IniWrite(Round(Float(EditAcc.Value), 2), SettingsFile, "Speed", "Acc")
    IniWrite(EditCurve.Value, SettingsFile, "Speed", "Curve")
    IniWrite(BindUp.Value, SettingsFile, "Keys", "Up")
    IniWrite(BindDown.Value, SettingsFile, "Keys", "Down")
    IniWrite(BindLeft.Value, SettingsFile, "Keys", "Left")
    IniWrite(BindRight.Value, SettingsFile, "Keys", "Right")
    IniWrite(BindClick.Value, SettingsFile, "Keys", "Click")
    IniWrite(BindRClick.Value, SettingsFile, "Keys", "RClick")
    
    if CheckStartup.Value
        FileCreateShortcut(A_ScriptFullPath, StartupShortcut, , "/hide")
    else if FileExist(StartupShortcut)
        FileDelete(StartupShortcut)

    if CheckTray.Value
        FileAppend("", A_Temp "\mk_hide.tmp")
    
    Reload()
}

HotIf (*) => GetKeyState(KeyToggle, "P")
Hotkey KeyUp, (*) => "", "On"
Hotkey KeyDown, (*) => "", "On"
Hotkey KeyLeft, (*) => "", "On"
Hotkey KeyRight, (*) => "", "On"
Hotkey KeyClick, (*) => (Click("Down"), KeyWait(KeyClick), Click("Up")), "On"
Hotkey KeyRightClick, (*) => Click("Right"), "On"
HotIf 

SetTimer(MouseTimer, 10)
MouseTimer() {
    if GetKeyState(KeyToggle, "P") {
        x := GetKeyState(KeyRight, "P") - GetKeyState(KeyLeft, "P")
        y := GetKeyState(KeyDown, "P") - GetKeyState(KeyUp, "P")
        if (x != 0 or y != 0) {
            Global CurrentSpeed := (CurrentSpeed < MaxSpeed) ? (CurrentSpeed + (Acceleration * (CurrentSpeed / NormalSpeed) ** (AccCurve - 1))) : MaxSpeed
            MouseMove(x * CurrentSpeed, y * CurrentSpeed, 0, "R")
        } else {
            Global CurrentSpeed := NormalSpeed
        }
    } else {
        Global CurrentSpeed := NormalSpeed
    }
}

if (KeyToggle = "CapsLock") {
    SetCapsLockState "AlwaysOff"
}

#HotIf GetKeyState(KeyToggle, "P") and KeyToggle = "CapsLock"
*CapsLock::return
#HotIf