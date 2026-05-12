import AppKit
import SwiftUI

final class OnboardingWindowController {
    private var window: NSWindow?
    private weak var hudController: HUDWindowController?

    init(hudController: HUDWindowController) {
        self.hudController = hudController
    }

    func show() {
        guard let hud = hudController else { return }
        let window = makeWindow()
        self.window = window

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { _ in
            DockVisibility.windowDidClose()
        }

        let view = OnboardingView(store: hud.usageStore) { [weak self, weak hud] in
            self?.window?.close()
            hud?.show()
        }
        window.contentView = NSHostingView(rootView: view)
        window.center()
        window.makeKeyAndOrderFront(nil)
        DockVisibility.windowDidShow()
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makeWindow() -> NSWindow {
        let w = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 880, height: 580),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        w.title = "ShortcutHUD Setup"
        w.titlebarAppearsTransparent = true
        w.isMovableByWindowBackground = true
        w.isReleasedWhenClosed = false
        return w
    }
}
