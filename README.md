# Better-MouseKeys

**Better-MouseKeys** is a high-performance productivity utility for Windows that allows you to control your mouse cursor using your keyboard. It features smooth exponential acceleration, fully customizable keybindings, and a modern GUI for easy configuration.

---

## 🚀 Features

* **Customizable Keys:** Map your movement and click actions to any keys.
* **Exponential Acceleration:** Features a "Smoothness" (curve) setting for natural-feeling cursor movement.
* **Persistent Settings:** Saves your configuration to an `.ini` file automatically.
* **System Tray Integration:** Run the app quietly in the background; minimize to tray or show the GUI via the tray menu.
* **Run at Startup:** Optional setting to launch the app automatically when you log into Windows.
* **Compiled EXE Support:** Fully compatible with AutoHotkey v2 compilation.

---

## 🛠 Installation & Usage

1.  **Download/Run:** Run the `mousekeys.exe` (or the `.ahk` script if you have AutoHotkey v2 and prefer to use the raw script).
2.  **Configuration:** * Set your **Activation Key** (default: `CapsLock`). You must hold this key down to move the mouse.
    * Adjust **Speed Controls** to find your preferred sensitivity.
    * Configure your **Key Bindings** for Up, Down, Left, Right, and Clicks.
3.  **Apply:** Click **SAVE & APPLY**. The script will reload and, if enabled, minimize directly to your system tray.
4.  **Control:** * Hold your Activation Key and use your bound keys to move.
    * Press **'S'** while holding the Activation Key to quickly bring the settings menu back up.

---

## ⚙️ Settings Explained

| Setting | Description |
| :--- | :--- |
| **Start Speed** | The initial speed of the cursor when you first press a direction. |
| **Max Speed** | The maximum velocity the cursor can reach. |
| **Acceleration** | How quickly the cursor gains speed. |
| **Smoothness** | The exponential curve of the movement. Higher values make the start slower and the end faster. |
| **Run at Startup** | Creates a shortcut in your Windows Startup folder to launch on login. |

---

## 📋 Requirements

* **Operating System:** Windows 10 or 11.
* **Software:** [AutoHotkey v2.0+](https://www.autohotkey.com/) (only if running the `.ahk` source file).

---

## ⚖️ License

This project is open-source. Feel free to modify and distribute it as needed for personal or professional use.
