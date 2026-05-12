import AppKit

// Switches the app between menu-bar-only (.accessory) and Dock-visible (.regular)
// based on whether any user-facing window (Settings, Onboarding) is currently open.
// The floating HUD does not count — it should stay invisible from the Dock.
enum DockVisibility {
    private static var openCount = 0

    static func windowDidShow() {
        openCount += 1
        NSApp.setActivationPolicy(.regular)
    }

    static func windowDidClose() {
        openCount = max(0, openCount - 1)
        if openCount == 0 {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
