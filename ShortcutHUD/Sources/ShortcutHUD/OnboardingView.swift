import SwiftUI
import AppKit

// MARK: - Step enum

enum OnboardingStep: Int, CaseIterable {
    case welcome, permission, apps, skill, demo, done
    var total: Int { OnboardingStep.allCases.count }
}

// MARK: - Root container

struct OnboardingView: View {
    @ObservedObject var store: UsageStore
    let onComplete: () -> Void

    @State private var step: OnboardingStep = .welcome
    @State private var accessGranted = false
    @State private var selectedIDs: Set<String> = Set(ShortcutLibrary.all.map(\.appBundleID))
    @State private var skill: SkillLevel = .beginner
    @State private var demoCounts: [String: Int] = [:]
    @State private var justGraduated: String? = nil
    @State private var insertFromRight = true

    private let allApps      = ShortcutLibrary.all
    private let demoShortcuts = Array((ShortcutLibrary.shortcuts(for: "com.microsoft.VSCode")?.shortcuts ?? []).prefix(7))

    var body: some View {
        VStack(spacing: 0) {
            // Step content
            ZStack {
                stepView
                    .transition(.asymmetric(
                        insertion: .move(edge: insertFromRight ? .trailing : .leading),
                        removal: .move(edge: insertFromRight ? .leading : .trailing)
                    ))
                    .id(step)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

            // Footer
            Divider().opacity(0.15)
            footerView
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.02))
        }
        .frame(width: 880, height: 580)
        .background(Color(nsColor: NSColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
        .preferredColorScheme(.dark)
        .onAppear { startPollingAccessibility() }
    }

    // MARK: - Step content

    @ViewBuilder
    private var stepView: some View {
        switch step {
        case .welcome:    WelcomeStep()
        case .permission: PermissionStep(granted: $accessGranted)
        case .apps:       AppsStep(allApps: allApps, selectedIDs: $selectedIDs)
        case .skill:      SkillStep(skill: $skill, threshold: $store.graduationThreshold)
        case .demo:       DemoStep(shortcuts: demoShortcuts, counts: $demoCounts,
                                   threshold: store.graduationThreshold,
                                   justGraduated: $justGraduated)
        case .done:       DoneStep(selectedCount: selectedIDs.count,
                                   threshold: store.graduationThreshold, skill: skill)
        }
    }

    // MARK: - Footer

    private var footerView: some View {
        HStack(spacing: 12) {
            if step != .welcome {
                Button("Back") { navigate(forward: false) }
                    .buttonStyle(HUDButtonStyle(kind: .secondary))
            }
            StepDotsView(total: step.total, current: step.rawValue)
            Spacer()

            // Contextual right label
            if step == .apps {
                Text("\(selectedIDs.count) of \(allApps.count) selected")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
            }

            Button(primaryLabel) {
                if step == .done { complete() }
                else { navigate(forward: true) }
            }
            .buttonStyle(HUDButtonStyle(kind: .primary))
            .disabled(step == .apps && selectedIDs.isEmpty)
        }
    }

    private var primaryLabel: String {
        switch step {
        case .welcome: return "Get started"
        case .done:    return "Start using ShortcutHUD"
        default:       return "Continue"
        }
    }

    // MARK: - Navigation

    private func navigate(forward: Bool) {
        insertFromRight = forward
        withAnimation(.easeInOut(duration: 0.25)) {
            let next = step.rawValue + (forward ? 1 : -1)
            step = OnboardingStep(rawValue: next) ?? step
        }
    }

    private func complete() {
        AppPreferences.shared.selectedBundleIDs = selectedIDs
        AppPreferences.shared.skillLevel = skill
        AppPreferences.shared.hasCompletedOnboarding = true
        onComplete()
    }

    // MARK: - Accessibility polling

    private func startPollingAccessibility() {
        accessGranted = AXIsProcessTrusted()
        guard !accessGranted else { return }
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { t in
            if AXIsProcessTrusted() {
                accessGranted = true
                t.invalidate()
            }
        }
    }
}

// MARK: - 1. Welcome

private struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            // Hero keys
            HStack(spacing: 10) {
                BigKey(label: "⌘")
                BigKey(label: "⇧")
                BigKey(label: "P")
            }
            .padding(.bottom, 32)

            Text("Welcome to ShortcutHUD")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.primary)

            Text("A quiet panel that teaches you keyboard shortcuts for whichever app you're using — then gets out of the way once you've learned them.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 460)
                .padding(.top, 12)

            HStack(alignment: .top, spacing: 36) {
                FeatureItem(color: .green,  title: "Context-aware",
                    detail: "Watches the front app and shows shortcuts that work right now.")
                FeatureItem(color: .yellow, title: "Tracks progress",
                    detail: "Counts every shortcut you press. Watch the progress bars fill up.")
                FeatureItem(color: .orange, title: "Graduates with you",
                    detail: "Use it 10 times and it retires — replaced by a harder one.")
            }
            .padding(.top, 36)
            Spacer()
        }
        .padding(.horizontal, 56)
    }
}

private struct BigKey: View {
    let label: String
    var body: some View {
        Text(label)
            .font(.system(size: 36, weight: .medium))
            .foregroundStyle(Color(nsColor: .labelColor))
            .frame(width: 76, height: 76)
            .background(
                LinearGradient(colors: [.white, Color(nsColor: NSColor.lightGray)],
                               startPoint: .top, endPoint: .bottom),
                in: RoundedRectangle(cornerRadius: 14)
            )
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
    }
}

private struct FeatureItem: View {
    let color: Color
    let title: String
    let detail: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .shadow(color: color.opacity(0.4), radius: 4)
            Text(title)
                .font(.system(size: 13, weight: .semibold))
            Text(detail)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
        .frame(maxWidth: 160, alignment: .leading)
    }
}

// MARK: - 2. Permission

private struct PermissionStep: View {
    @Binding var granted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StepHeader(eyebrow: "Step 1 of 5",
                       title: "Allow ShortcutHUD to read keystrokes",
                       subtitle: "To count shortcuts as you press them, ShortcutHUD needs Accessibility access. Keystrokes are matched on-device against the shortcut list — nothing is logged or transmitted.")

            VStack(spacing: 14) {
                // Faux System Settings row
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(nsColor: .windowBackgroundColor))
                        .frame(width: 40, height: 40)
                        .overlay(Image(systemName: "keyboard")
                            .font(.system(size: 18))
                            .foregroundStyle(.secondary))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ShortcutHUD")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Allow this app to receive keystrokes from any application.")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if granted {
                        Label("Access granted", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.green)
                    } else {
                        Button("Grant Access") {
                            let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
                            AXIsProcessTrustedWithOptions([key: true] as CFDictionary)
                        }
                        .buttonStyle(HUDButtonStyle(kind: .primary))
                    }
                }
                .padding(16)
                .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                    granted ? Color.green.opacity(0.4) : Color.white.opacity(0.08), lineWidth: 0.5))

                // Status banner
                HStack(spacing: 8) {
                    Image(systemName: granted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundStyle(granted ? .green : .orange)
                    Text(granted
                         ? "Access granted. ShortcutHUD will count keystrokes for the front app only."
                         : "Access not granted. Click \"Grant Access\" and enable ShortcutHUD in System Settings.")
                        .font(.system(size: 12))
                        .foregroundStyle(granted ? .green : .orange)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    (granted ? Color.green : Color.orange).opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 8)
                )
                .animation(.easeInOut(duration: 0.25), value: granted)

                // Privacy chips
                HStack(spacing: 12) {
                    PrivacyChip(icon: "cpu", title: "On-device", detail: "Matching runs in the menu-bar process.")
                    PrivacyChip(icon: "nosign", title: "No logging", detail: "Keys aren't written to disk or sent anywhere.")
                    PrivacyChip(icon: "slider.horizontal.3", title: "Revocable", detail: "Disable any time in System Settings.")
                }
            }
            .padding(.horizontal, 56)
            .padding(.top, 20)
        }
    }
}

private struct PrivacyChip: View {
    let icon: String
    let title: String
    let detail: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.system(size: 12, weight: .semibold))
            Text(detail)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
    }
}

// MARK: - 3. Apps

private struct AppsStep: View {
    let allApps: [AppShortcuts]
    @Binding var selectedIDs: Set<String>

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StepHeader(eyebrow: "Step 2 of 5",
                       title: "Pick the apps you actually use",
                       subtitle: "ShortcutHUD will surface shortcuts for these apps. You can change this from Settings any time.")

            HStack(spacing: 10) {
                Button("Select all") { selectedIDs = Set(allApps.map(\.appBundleID)) }
                    .buttonStyle(HUDButtonStyle(kind: .ghost))
                Text("·").foregroundStyle(.tertiary)
                Button("Clear") { selectedIDs = [] }
                    .buttonStyle(HUDButtonStyle(kind: .ghost))
            }
            .padding(.horizontal, 56)
            .padding(.bottom, 12)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(allApps, id: \.appBundleID) { app in
                        AppTileButton(app: app,
                                      selected: selectedIDs.contains(app.appBundleID)) {
                            if selectedIDs.contains(app.appBundleID) {
                                selectedIDs.remove(app.appBundleID)
                            } else {
                                selectedIDs.insert(app.appBundleID)
                            }
                        }
                    }
                }
                .padding(.horizontal, 56)
                .padding(.bottom, 12)
            }
        }
    }
}

private struct AppTileButton: View {
    let app: AppShortcuts
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(appTint(app.appBundleID))
                        .frame(width: 48, height: 48)
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                    Text(String(app.appName.prefix(1)))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(selected ? 0.8 : 0), lineWidth: 2.5)
                        .padding(-2)
                )
                Text(app.appName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(selected ? Color.blue.opacity(0.08) : Color.white.opacity(0.03),
                        in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                selected ? Color.blue.opacity(0.3) : Color.white.opacity(0.07), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: selected)
    }
}

private func appTint(_ bundleID: String) -> Color {
    let tints: [String: Color] = [
        "com.microsoft.VSCode":               Color(red: 0.00, green: 0.47, blue: 0.80),
        "com.todesktop.230313mzl4w4u92":      Color(red: 0.23, green: 0.23, blue: 0.23),
        "com.apple.dt.Xcode":                 Color(red: 0.08, green: 0.47, blue: 0.95),
        "com.apple.finder":                   Color(red: 0.12, green: 0.63, blue: 0.95),
        "com.apple.Safari":                   Color(red: 0.11, green: 0.53, blue: 0.97),
        "com.google.Chrome":                  Color(red: 0.26, green: 0.52, blue: 0.96),
        "company.thebrowser.Browser":         Color(red: 1.00, green: 0.39, blue: 0.39),
        "com.apple.Terminal":                 Color(red: 0.29, green: 0.29, blue: 0.30),
        "com.googlecode.iterm2":              Color(red: 0.16, green: 0.16, blue: 0.17),
        "com.figma.Desktop":                  Color(red: 0.64, green: 0.35, blue: 1.00),
        "com.tinyspeck.slackmacgap":          Color(red: 0.38, green: 0.12, blue: 0.41),
        "notion.id":                          Color(red: 0.35, green: 0.35, blue: 0.36),
        "com.spotify.client":                 Color(red: 0.11, green: 0.72, blue: 0.33),
        "com.apple.mail":                     Color(red: 0.13, green: 0.64, blue: 0.99),
        "com.apple.Notes":                    Color(red: 1.00, green: 0.77, blue: 0.00),
        "md.obsidian":                        Color(red: 0.49, green: 0.23, blue: 0.93),
        "us.zoom.xos":                        Color(red: 0.18, green: 0.55, blue: 1.00),
        "com.hnc.Discord":                    Color(red: 0.34, green: 0.40, blue: 0.95),
        "net.shinyfrog.bear":                 Color(red: 0.78, green: 0.20, blue: 0.12),
        "com.culturedcode.ThingsMac":         Color(red: 0.14, green: 0.47, blue: 0.82),
        "com.github.GitHubClient":            Color(red: 0.14, green: 0.16, blue: 0.18),
        "com.bohemiancoding.sketch3":         Color(red: 0.97, green: 0.71, blue: 0.00),
        "dev.warp.Warp-Stable":               Color(red: 0.36, green: 0.31, blue: 0.98),
        "dev.zed.Zed":                        Color(red: 0.05, green: 0.45, blue: 0.81),
        "com.1password.1password":            Color(red: 0.00, green: 0.47, blue: 1.00),
    ]
    return tints[bundleID] ?? Color(red: 0.40, green: 0.40, blue: 0.42)
}

// MARK: - 4. Skill

private struct SkillStep: View {
    @Binding var skill: SkillLevel
    @Binding var threshold: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StepHeader(eyebrow: "Step 3 of 5",
                       title: "Set your pace",
                       subtitle: "ShortcutHUD shows up to 7 shortcuts at a time. Choose where to start, and how many uses before a shortcut graduates off the list.")

            VStack(spacing: 20) {
                // Skill cards
                VStack(alignment: .leading, spacing: 8) {
                    Text("Starting point")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                        .kerning(0.8)
                    HStack(spacing: 12) {
                        ForEach(SkillLevel.allCases, id: \.rawValue) { lvl in
                            SkillCard(level: lvl, selected: skill == lvl) { skill = lvl }
                        }
                    }
                }

                // Threshold stepper
                VStack(alignment: .leading, spacing: 8) {
                    Text("Graduation threshold")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                        .kerning(0.8)
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Text("\(threshold)")
                                    .font(.system(size: 32, weight: .semibold, design: .monospaced))
                                Text("uses to graduate")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: Binding(
                                get: { Double(threshold) },
                                set: { threshold = Int($0) }
                            ), in: 3...25, step: 1)
                            .tint(.blue)
                            HStack {
                                Text("3 — quick")
                                Spacer()
                                Text("10 — default")
                                Spacer()
                                Text("25 — thorough")
                            }
                            .font(.system(size: 10))
                            .foregroundStyle(.quaternary)
                        }
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
                }
            }
            .padding(.horizontal, 56)
            .padding(.top, 16)
        }
    }
}

private struct SkillCard: View {
    let level: SkillLevel
    let selected: Bool
    let action: () -> Void

    private var accent: Color {
        switch level {
        case .beginner: return .green
        case .mixed:    return .yellow
        case .advanced: return .orange
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Circle().fill(accent)
                    .frame(width: 8, height: 8)
                    .shadow(color: accent.opacity(0.4), radius: 4)
                Text(level.title)
                    .font(.system(size: 14, weight: .semibold))
                Text(level.detail)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(selected ? Color.white.opacity(0.10) : Color.white.opacity(0.04),
                        in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                selected ? accent : Color.white.opacity(0.08), lineWidth: selected ? 1 : 0.5))
            .shadow(color: selected ? accent.opacity(0.15) : .clear, radius: 10)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: selected)
    }
}

// MARK: - 5. Demo

private struct DemoStep: View {
    let shortcuts: [Shortcut]
    @Binding var counts: [String: Int]
    let threshold: Int
    @Binding var justGraduated: String?

    private var visible: [Shortcut] {
        shortcuts.filter { (counts[$0.stableID] ?? 0) < threshold }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StepHeader(eyebrow: "Step 4 of 5",
                       title: "Try it out",
                       subtitle: "Tap a shortcut to simulate pressing it — the count ticks up, the bar fills, and once it hits the threshold, the shortcut graduates off the list.")

            HStack(alignment: .top, spacing: 22) {
                // Left: tap list
                VStack(alignment: .leading, spacing: 10) {
                    Text("Practice — tap to \"press\"")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                        .kerning(0.8)

                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(shortcuts, id: \.id) { s in
                                let c = counts[s.stableID] ?? 0
                                let learned = c >= threshold
                                Button {
                                    if !learned { press(s) }
                                } label: {
                                    HStack(spacing: 10) {
                                        Text(s.keys)
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .padding(.horizontal, 8).padding(.vertical, 3)
                                            .background(levelColor(s.level).opacity(0.15),
                                                        in: RoundedRectangle(cornerRadius: 4))
                                            .overlay(RoundedRectangle(cornerRadius: 4)
                                                .stroke(levelColor(s.level).opacity(0.35), lineWidth: 0.5))
                                            .frame(minWidth: 70)
                                        Text(s.description)
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        if c > 0 {
                                            Text("\(c)/\(threshold)")
                                                .font(.system(size: 10, design: .monospaced))
                                                .foregroundStyle(.tertiary)
                                        }
                                        if learned {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.green)
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .padding(.horizontal, 10).padding(.vertical, 8)
                                    .background(learned ? Color.green.opacity(0.06) : Color.clear,
                                                in: RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                                .opacity(learned ? 0.5 : 1)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                // Right: live HUD preview
                VStack(alignment: .leading, spacing: 10) {
                    Text("Live HUD")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                        .kerning(0.8)

                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: [Color(red: 0.17, green: 0.33, blue: 0.39),
                                         Color(red: 0.06, green: 0.13, blue: 0.16)],
                                startPoint: .topLeading, endPoint: .bottomTrailing))

                        HUDView(appName: "VS Code",
                                shortcuts: visible,
                                counts: counts,
                                threshold: threshold)
                            .scaleEffect(0.9, anchor: .bottomTrailing)
                            .padding(12)

                        if justGraduated != nil {
                            GraduationToast(keys: justGraduated ?? "")
                                .padding(12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity,
                                       alignment: .topLeading)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .frame(width: 300)
            }
            .padding(.horizontal, 56)
            .padding(.top, 14)
            .padding(.bottom, 4)
        }
    }

    private func press(_ shortcut: Shortcut) {
        let key = shortcut.stableID
        let next = (counts[key] ?? 0) + 1
        withAnimation(.easeInOut(duration: 0.2)) {
            counts[key] = next
        }
        if next >= threshold {
            withAnimation { justGraduated = shortcut.keys }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation { justGraduated = nil }
            }
        }
    }

    private func levelColor(_ level: ShortcutLevel) -> Color {
        switch level {
        case .basic:        return .green
        case .intermediate: return .yellow
        case .advanced:     return .orange
        }
    }
}

private struct GraduationToast: View {
    let keys: String
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Graduated 🎓")
                .font(.system(size: 10, weight: .bold))
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.9))
            Text(keys)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .background(Color.green.opacity(0.95), in: RoundedRectangle(cornerRadius: 10))
        .shadow(color: .green.opacity(0.4), radius: 10)
    }
}

// MARK: - 6. Done

private struct DoneStep: View {
    let selectedCount: Int
    let threshold: Int
    let skill: SkillLevel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Checkmark circle
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(colors: [Color.green, Color.green.opacity(0.7)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 88, height: 88)
                    .shadow(color: .green.opacity(0.35), radius: 20)
                Image(systemName: "checkmark")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 8) {
                Text("You're all set")
                    .font(.system(size: 30, weight: .semibold))
                Text("ShortcutHUD lives in your menu bar and floats in the bottom-right of your screen. It updates as you switch apps. Quietly. Forever.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 420)
            }

            // Summary stats
            HStack(spacing: 0) {
                SummaryStat(value: "\(selectedCount)", label: "apps tracked")
                Divider().frame(height: 36).opacity(0.2)
                SummaryStat(value: "\(threshold)", label: "uses to graduate")
                Divider().frame(height: 36).opacity(0.2)
                SummaryStat(value: skill.title, label: "starting pace")
            }
            .padding(4)
            .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
            .frame(maxWidth: 480)

            Spacer()
        }
        .padding(.horizontal, 56)
    }
}

private struct SummaryStat: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 22, weight: .semibold, design: .monospaced))
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24).padding(.vertical, 10)
    }
}

// MARK: - Shared primitives

private struct StepHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(eyebrow)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.blue)
                .textCase(.uppercase)
                .kerning(1.4)
                .padding(.bottom, 10)
            Text(title)
                .font(.system(size: 28, weight: .semibold))
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .lineSpacing(3)
                .padding(.top, 6)
        }
        .padding(.horizontal, 56)
        .padding(.top, 32)
        .padding(.bottom, 18)
    }
}

private struct StepDotsView: View {
    let total: Int
    let current: Int
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                RoundedRectangle(cornerRadius: 3)
                    .fill(i == current ? Color.blue : Color.white.opacity(0.18))
                    .frame(width: i == current ? 18 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
    }
}

private enum ButtonKind { case primary, secondary, ghost }

private struct HUDButtonStyle: ButtonStyle {
    let kind: ButtonKind
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 18).padding(.vertical, 8)
            .background(background, in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(foreground)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }

    private var background: Color {
        switch kind {
        case .primary:   return .blue
        case .secondary: return .white.opacity(0.1)
        case .ghost:     return .clear
        }
    }
    private var foreground: Color {
        switch kind {
        case .primary:   return .white
        case .secondary: return Color(nsColor: .labelColor)
        case .ghost:     return .blue
        }
    }
}
