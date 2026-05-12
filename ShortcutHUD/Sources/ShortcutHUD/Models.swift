import Foundation

enum ShortcutLevel: String, Codable {
    case basic, intermediate, advanced

    var sortOrder: Int {
        switch self { case .basic: return 0; case .intermediate: return 1; case .advanced: return 2 }
    }
}

struct Shortcut: Identifiable, Codable {
    let id: UUID
    let keys: String
    let description: String
    let level: ShortcutLevel
    let appBundleID: String

    // Stable key for persistence — survives app restarts
    var stableID: String { "\(appBundleID)|\(keys)" }

    init(keys: String, description: String, level: ShortcutLevel, appBundleID: String) {
        self.id = UUID()
        self.keys = keys
        self.description = description
        self.level = level
        self.appBundleID = appBundleID
    }
}

struct AppShortcuts {
    let appBundleID: String
    let appName: String
    let shortcuts: [Shortcut]

    init(appBundleID: String, appName: String, shortcuts: [Shortcut]) {
        self.appBundleID = appBundleID
        self.appName = appName
        // Inject the correct bundleID into every shortcut so stableID is globally unique
        self.shortcuts = shortcuts.map { s in
            Shortcut(keys: s.keys, description: s.description, level: s.level, appBundleID: appBundleID)
        }
    }
}
