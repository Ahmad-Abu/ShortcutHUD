# Installing ShortcutHUD

ShortcutHUD requires macOS 13 (Ventura) or later.

## 1 — Install

1. Double-click `ShortcutHUD-x.y.z.dmg` to mount it.
2. Drag **ShortcutHUD** into the **Applications** folder.
3. Eject the DMG.

## 2 — First Launch (Important)

ShortcutHUD is distributed without an Apple Developer signature, so the first time you open it macOS will warn you that **"ShortcutHUD" cannot be opened because Apple cannot check it for malicious software**.

**To open it the first time:**

1. Open the **Applications** folder.
2. **Right-click** (or Control-click) `ShortcutHUD` → **Open**.
3. In the dialog that appears, click **Open** again.

After this one-time approval, you can launch ShortcutHUD normally by double-clicking it.

### If you still can't open it (macOS Sonoma / Sequoia)

Newer macOS versions sometimes block the right-click bypass. In that case:

1. Open **Terminal** (Applications → Utilities → Terminal).
2. Paste this command and press Return:
   ```
   xattr -dr com.apple.quarantine /Applications/ShortcutHUD.app
   ```
3. Now double-click ShortcutHUD in Applications.

This removes the "downloaded from the internet" flag macOS attaches to the app.

## 3 — Grant Accessibility Permission

ShortcutHUD needs to observe keyboard events to count how often you use each shortcut. macOS will prompt you when you first launch it.

1. The HUD will show **"Accessibility access needed"**.
2. Open **System Settings → Privacy & Security → Accessibility**.
3. Toggle **ShortcutHUD** on.
4. **Quit ShortcutHUD** (right-click its menu bar icon → Quit) and **relaunch** it from Applications.

The HUD will now track your shortcuts.

## Uninstall

1. Quit ShortcutHUD from the menu bar.
2. Drag `ShortcutHUD.app` to the Trash.
3. (Optional) Remove your usage data:
   ```
   rm -rf ~/Library/Application\ Support/ShortcutHUD
   ```

## Troubleshooting

- **HUD doesn't appear** — check the menu bar (top right of your screen) for the ShortcutHUD icon. Click it to toggle visibility.
- **Permissions seem stuck** — open System Settings → Privacy & Security → Accessibility, remove any existing ShortcutHUD entries, then relaunch the app and re-approve.
- **No shortcuts shown for an app** — ShortcutHUD ships with a built-in library of 25 popular apps. If your app isn't supported, the HUD will say so.
