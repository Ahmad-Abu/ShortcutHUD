import AppKit
import Combine

final class KeyMonitor: ObservableObject {
    var onMatch: ((Shortcut) -> Void)?

    @Published private(set) var isMonitoring = false

    private var monitor: Any?
    private var shortcuts: [Shortcut] = []

    func start() {
        requestAccessibilityPermission()
        installMonitorIfTrusted()
    }

    func stop() {
        if let m = monitor { NSEvent.removeMonitor(m) }
        monitor = nil
        isMonitoring = false
    }

    func update(shortcuts: [Shortcut]) {
        self.shortcuts = shortcuts
    }

    // MARK: - Private

    private func installMonitorIfTrusted() {
        // If we already have a working monitor, nothing to do
        guard !isMonitoring else { return }

        if AXIsProcessTrusted() {
            let m = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
                self?.handle(event)
            }
            if let m {
                monitor = m
                isMonitoring = true
            } else {
                // Trusted but install failed (rare) — retry
                scheduleRetry()
            }
        } else {
            scheduleRetry()
        }
    }

    private func scheduleRetry() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.installMonitorIfTrusted()
        }
    }

    private func requestAccessibilityPermission() {
        let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        AXIsProcessTrustedWithOptions([key: true] as CFDictionary)
    }

    private func handle(_ event: NSEvent) {
        for shortcut in shortcuts {
            if matches(event, shortcut) {
                onMatch?(shortcut)
                return
            }
        }
    }

    private func matches(_ event: NSEvent, _ shortcut: Shortcut) -> Bool {
        let (requiredMods, keyToken) = parse(shortcut.keys)
        guard !keyToken.isEmpty else { return false }

        let eventMods = event.modifierFlags.intersection([.command, .shift, .option, .control])
        guard eventMods == requiredMods else { return false }

        if let code = specialKeyCode(keyToken) {
            return event.keyCode == code
        }
        return event.charactersIgnoringModifiers?.lowercased() == keyToken.lowercased()
    }

    // Returns (modifiers, keyToken) — keyToken is empty for multi-step chords
    private func parse(_ keys: String) -> (NSEvent.ModifierFlags, String) {
        var mods: NSEvent.ModifierFlags = []
        var keyToken = ""
        var tokenCount = 0

        for token in keys.split(separator: " ").map(String.init) {
            switch token {
            case "⌘": mods.insert(.command)
            case "⇧": mods.insert(.shift)
            case "⌥": mods.insert(.option)
            case "⌃": mods.insert(.control)
            default:
                tokenCount += 1
                if tokenCount == 1 { keyToken = token }
                else { keyToken = "" }  // two-step chord — skip
            }
        }
        return (mods, keyToken)
    }

    private func specialKeyCode(_ token: String) -> UInt16? {
        switch token {
        case "Space": return 49
        case "←":    return 123
        case "→":    return 124
        case "↑":    return 126
        case "↓":    return 125
        case "⌫":    return 51
        case "Tab":  return 48
        case "↩":    return 36
        case "`":    return 50
        case "/":    return 44
        case "\\", "\\\\": return 42
        case "[":    return 33
        case "]":    return 30
        default:     return nil
        }
    }
}
