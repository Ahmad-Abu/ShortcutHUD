import Foundation
import Combine

final class UsageStore: ObservableObject {
    @Published private(set) var counts: [String: Int] = [:]

    @Published var graduationThreshold: Int {
        didSet { UserDefaults.standard.set(graduationThreshold, forKey: "graduationThreshold") }
    }
    private let fileURL: URL

    init() {
        let saved = UserDefaults.standard.integer(forKey: "graduationThreshold")
        self.graduationThreshold = saved > 0 ? saved : 10
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = support.appendingPathComponent("ShortcutHUD", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("usage.json")
        load()
    }

    func record(_ shortcut: Shortcut) {
        counts[shortcut.stableID, default: 0] += 1
        save()
    }

    func count(for shortcut: Shortcut) -> Int {
        counts[shortcut.stableID] ?? 0
    }

    func isLearned(_ shortcut: Shortcut) -> Bool {
        count(for: shortcut) >= graduationThreshold
    }

    func reset(bundleID: String) {
        counts = counts.filter { !$0.key.hasPrefix("\(bundleID)|") }
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([String: Int].self, from: data)
        else { return }
        counts = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(counts) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
