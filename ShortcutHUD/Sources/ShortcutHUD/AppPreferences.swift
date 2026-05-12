import Foundation
import Combine
import ServiceManagement

enum SkillLevel: String, CaseIterable {
    case beginner, mixed, advanced

    var title: String {
        switch self {
        case .beginner: return "I know a few"
        case .mixed:    return "Mix it up"
        case .advanced: return "Throw it all"
        }
    }

    var detail: String {
        switch self {
        case .beginner: return "Show basics first. Easy ramp-up."
        case .mixed:    return "A blend of basics and intermediates."
        case .advanced: return "Skip basics. Go straight to power moves."
        }
    }
}

final class AppPreferences: ObservableObject {
    static let shared = AppPreferences()

    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }
    // Empty = all apps enabled (pre-onboarding default)
    @Published var selectedBundleIDs: Set<String> {
        didSet { UserDefaults.standard.set(Array(selectedBundleIDs), forKey: "selectedBundleIDs") }
    }
    @Published var skillLevel: SkillLevel {
        didSet { UserDefaults.standard.set(skillLevel.rawValue, forKey: "skillLevel") }
    }

    @Published var launchAtLogin: Bool {
        didSet {
            guard oldValue != launchAtLogin else { return }
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                // Revert toggle if registration fails
                launchAtLogin = !launchAtLogin
            }
        }
    }

    private init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        selectedBundleIDs      = Set(UserDefaults.standard.stringArray(forKey: "selectedBundleIDs") ?? [])
        skillLevel             = SkillLevel(rawValue: UserDefaults.standard.string(forKey: "skillLevel") ?? "") ?? .beginner
        launchAtLogin          = SMAppService.mainApp.status == .enabled
    }
}
