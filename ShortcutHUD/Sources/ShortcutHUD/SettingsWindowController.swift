import AppKit
import SwiftUI

final class SettingsWindowController {
    private var panel: NSPanel?
    private weak var hudController: HUDWindowController?

    init(hudController: HUDWindowController) {
        self.hudController = hudController
    }

    func show() {
        if let panel = panel {
            let wasVisible = panel.isVisible
            panel.makeKeyAndOrderFront(nil)
            if !wasVisible {
                DockVisibility.windowDidShow()
            }
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        guard let hud = hudController else { return }
        let panel = makePanel()
        self.panel = panel

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: panel,
            queue: .main
        ) { _ in
            DockVisibility.windowDidClose()
        }

        let view = SettingsView(store: hud.usageStore, hudController: hud)
        panel.contentView = NSHostingView(rootView: view)
        panel.makeKeyAndOrderFront(nil)
        DockVisibility.windowDidShow()
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makePanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 420),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.title = "ShortcutHUD Settings"
        panel.isReleasedWhenClosed = false
        panel.center()
        return panel
    }
}
