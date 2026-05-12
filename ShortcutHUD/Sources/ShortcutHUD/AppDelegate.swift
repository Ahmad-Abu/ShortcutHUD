import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let hudController = HUDWindowController()
    private var settingsController: SettingsWindowController?
    private var onboardingController: OnboardingWindowController?
    private var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBarItem()
        settingsController = SettingsWindowController(hudController: hudController)

        if AppPreferences.shared.hasCompletedOnboarding {
            hudController.show()
        } else {
            let ob = OnboardingWindowController(hudController: hudController)
            ob.show()
            onboardingController = ob
        }
    }

    private func setupStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "ShortcutHUD")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings…", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(.separator())
        let accessItem = NSMenuItem(title: "Grant Accessibility Access…", action: #selector(grantAccess), keyEquivalent: "")
        menu.addItem(accessItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit ShortcutHUD", action: #selector(quit), keyEquivalent: "q"))
        statusItem?.menu = menu
    }

    @objc private func openSettings() {
        settingsController?.show()
    }

    @objc private func grantAccess() {
        let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        AXIsProcessTrustedWithOptions([key: true] as CFDictionary)
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
