import AppKit
import Combine

final class AppDetector: ObservableObject {
    @Published private(set) var activeBundleID: String = ""
    @Published private(set) var activeAppName: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        updateFromFrontApp()

        NSWorkspace.shared.publisher(for: \.frontmostApplication)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] app in
                self?.activeBundleID = app?.bundleIdentifier ?? ""
                self?.activeAppName  = app?.localizedName ?? ""
            }
            .store(in: &cancellables)
    }

    private func updateFromFrontApp() {
        let app = NSWorkspace.shared.frontmostApplication
        activeBundleID = app?.bundleIdentifier ?? ""
        activeAppName  = app?.localizedName ?? ""
    }
}
