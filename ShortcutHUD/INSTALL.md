# Installing ShortcutHUD

ShortcutHUD requires **macOS 13 (Ventura) or later** on an **Apple Silicon Mac** (M1/M2/M3/M4).

The app is ad-hoc signed (not yet notarized through the Apple Developer Program), so macOS Gatekeeper will refuse the first launch unless you clear the "downloaded from the internet" flag. There are two ways to install — pick whichever feels comfortable.

---

## Option 1 — One-line install (Recommended)

If you're comfortable with Terminal, this is the fastest and most reliable path. It downloads the latest release, removes the quarantine flag, and launches the app.

```sh
curl -fsSL https://raw.githubusercontent.com/Ahmad-Abu/ShortcutHUD/main/ShortcutHUD/install.sh | bash
```

> Want to read the script before running it? It's right here: [install.sh](https://github.com/Ahmad-Abu/ShortcutHUD/blob/main/ShortcutHUD/install.sh)

---

## Option 2 — Manual install from DMG

> ⚠️ **Important**: On macOS Sonoma and Tahoe (14+ / 26+), you **must remove the quarantine flag before double-clicking the app**. If you double-click first, macOS may silently delete the app within seconds. The Terminal command in step 3 below is not optional.

### 1. Install the app

1. Double-click `ShortcutHUD-x.y.z.dmg` to mount it.
2. Drag **ShortcutHUD** into the **Applications** folder.
3. Eject the DMG.

### 2. Remove the quarantine flag — DO THIS BEFORE FIRST LAUNCH

Open **Terminal** (Applications → Utilities → Terminal) and paste:

```sh
xattr -dr com.apple.quarantine /Applications/ShortcutHUD.app
```

This removes the "downloaded from the internet" tag macOS attaches to anything from a browser. Without this step, macOS will refuse to launch the app and may even delete it.

### 3. Launch ShortcutHUD

Now double-click **ShortcutHUD** in the Applications folder. It should launch normally and show up in the menu bar (top-right of screen) as a small keyboard icon.

### 4. Grant Accessibility permission

ShortcutHUD needs to observe keyboard events to count how often you use each shortcut.

1. The HUD will show **"Accessibility access needed"**.
2. Open **System Settings → Privacy & Security → Accessibility**.
3. Toggle **ShortcutHUD** on.
4. **Quit ShortcutHUD** (right-click its menu bar icon → Quit) and **relaunch** it from Applications.

The HUD will now track your shortcuts.

---

## Uninstall

1. Quit ShortcutHUD from the menu bar.
2. Drag `ShortcutHUD.app` to the Trash.
3. (Optional) Remove your usage data:
   ```sh
   rm -rf ~/Library/Application\ Support/ShortcutHUD
   ```

## Troubleshooting

- **App vanished from /Applications right after I double-clicked it** — this is the macOS Gatekeeper auto-removal behavior. Re-install and make sure to run the `xattr` command **before** double-clicking. The one-line installer above does this automatically.
- **HUD doesn't appear after launch** — check the menu bar (top right of your screen) for the small keyboard icon. Click it to toggle visibility.
- **Permissions seem stuck** — open System Settings → Privacy & Security → Accessibility, remove any existing ShortcutHUD entries, quit the app, relaunch, and re-approve.
- **No shortcuts shown for an app** — ShortcutHUD ships with a built-in library of 25 popular apps. If your app isn't supported, the HUD will say so.

## Why all this friction?

ShortcutHUD is currently ad-hoc signed. Apple's Gatekeeper treats anything not signed with a paid Apple Developer ID ($99/year) as untrusted, and on macOS Tahoe (26.x) this enforcement got much more aggressive — the OS will silently delete unsigned downloads on launch attempt. Notarization through the Apple Developer Program would eliminate this, and may happen in a future release.
