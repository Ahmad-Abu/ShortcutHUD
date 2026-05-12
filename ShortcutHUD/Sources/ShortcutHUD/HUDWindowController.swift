import AppKit
import SwiftUI
import Combine

final class HUDWindowController: ObservableObject {
    private var panel: NSPanel?
    private var hostingView: NSHostingView<HUDView>?

    private let detector   = AppDetector()
    let usageStore         = UsageStore()
    private let keyMonitor = KeyMonitor()

    @Published var isHUDVisible: Bool = true {
        didSet {
            guard oldValue != isHUDVisible else { return }
            isHUDVisible ? panel?.orderFrontRegardless() : panel?.orderOut(nil)
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private var currentBundleID = ""
    private var currentAppName  = ""

    func show() {
        guard panel == nil else { panel?.orderFrontRegardless(); return }

        let panel = makePanel()
        self.panel = panel

        keyMonitor.onMatch = { [weak self] shortcut in
            DispatchQueue.main.async { self?.usageStore.record(shortcut) }
        }
        keyMonitor.start()

        // Re-render on any data change: counts, threshold, or preferences
        Publishers.Merge3(
            usageStore.$counts.map { _ in () },
            usageStore.$graduationThreshold.map { _ in () },
            keyMonitor.$isMonitoring.map { _ in () }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in self?.refreshContent() }
        .store(in: &cancellables)

        Publishers.Merge(
            AppPreferences.shared.$skillLevel.map { _ in () },
            AppPreferences.shared.$selectedBundleIDs.map { _ in () }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in self?.refreshContent() }
        .store(in: &cancellables)

        detector.$activeBundleID
            .combineLatest(detector.$activeAppName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bundleID, appName in
                self?.currentBundleID = bundleID
                self?.currentAppName  = appName
                self?.refreshContent()
            }
            .store(in: &cancellables)

        currentBundleID = detector.activeBundleID
        currentAppName  = detector.activeAppName
        refreshContent()
        panel.orderFrontRegardless()
    }

    // MARK: - Private

    private func displayedShortcuts(for bundleID: String) -> [Shortcut] {
        let prefs = AppPreferences.shared
        let selected = prefs.selectedBundleIDs
        if prefs.hasCompletedOnboarding && !selected.isEmpty && !selected.contains(bundleID) {
            return []
        }
        guard let entry = ShortcutLibrary.shortcuts(for: bundleID) else { return [] }
        let unlearned = entry.shortcuts.filter { !usageStore.isLearned($0) }
        return Array(sorted(unlearned, by: prefs.skillLevel).prefix(7))
    }

    private func sorted(_ shortcuts: [Shortcut], by skill: SkillLevel) -> [Shortcut] {
        switch skill {
        case .beginner:
            return shortcuts.sorted { $0.level.sortOrder < $1.level.sortOrder }
        case .advanced:
            return shortcuts.sorted { $0.level.sortOrder > $1.level.sortOrder }
        case .mixed:
            let groups = Dictionary(grouping: shortcuts, by: \.level)
            let inter  = groups[.intermediate] ?? []
            let basic  = groups[.basic] ?? []
            let adv    = groups[.advanced] ?? []
            var result: [Shortcut] = []
            for i in 0..<max(inter.count, basic.count, adv.count) {
                if i < inter.count { result.append(inter[i]) }
                if i < basic.count { result.append(basic[i]) }
                if i < adv.count   { result.append(adv[i]) }
            }
            return result
        }
    }

    private func refreshContent() {
        let shortcuts = displayedShortcuts(for: currentBundleID)
        keyMonitor.update(shortcuts: shortcuts)

        let name = ShortcutLibrary.shortcuts(for: currentBundleID)?.appName ?? currentAppName
        let view = HUDView(
            appName: name,
            shortcuts: shortcuts,
            counts: usageStore.counts,
            threshold: usageStore.graduationThreshold,
            isMonitoring: keyMonitor.isMonitoring,
            bundleID: currentBundleID
        )

        if let hosting = hostingView {
            hosting.rootView = view
        } else {
            let hosting = NSHostingView(rootView: view)
            hosting.autoresizingMask = [.width, .height]
            panel?.contentView = hosting
            hostingView = hosting
        }
        if let p = panel { positionPanel(p) }
    }

    private func makePanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 300),
            styleMask: [.nonactivatingPanel, .fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false
        )
        panel.level = .floating
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isMovableByWindowBackground = true
        positionPanel(panel)
        return panel
    }

    private func positionPanel(_ panel: NSPanel) {
        guard let screen = NSScreen.main else { return }
        let size   = CGSize(width: 280, height: 300)
        let margin: CGFloat = 20
        let origin = CGPoint(
            x: screen.visibleFrame.maxX - size.width - margin,
            y: screen.visibleFrame.minY + margin
        )
        panel.setFrame(CGRect(origin: origin, size: size), display: true)
    }
}
