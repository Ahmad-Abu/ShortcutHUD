import SwiftUI

struct HUDView: View {
    let appName: String
    let shortcuts: [Shortcut]
    let counts: [String: Int]
    let threshold: Int
    var isMonitoring: Bool = true
    var bundleID: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider().padding(.horizontal, 12)
            if !isMonitoring {
                accessWarning
            } else if shortcuts.isEmpty {
                emptyState
            } else {
                shortcutList
            }
        }
        .frame(width: 280)
        .frame(minHeight: 200)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
        )
    }

    private var header: some View {
        HStack(spacing: 6) {
            Image(systemName: "keyboard")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
            Text(appName.isEmpty ? "No App" : appName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.primary)
            Spacer()
            Text("shortcuts")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var shortcutList: some View {
        VStack(spacing: 0) {
            ForEach(shortcuts.prefix(7)) { shortcut in
                ShortcutRow(
                    shortcut: shortcut,
                    count: counts[shortcut.stableID] ?? 0,
                    threshold: threshold
                )
            }
        }
        .padding(.vertical, 4)
    }

    private var accessWarning: some View {
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.lock.fill")
                .font(.system(size: 18))
                .foregroundStyle(.orange)
            Text("Accessibility access needed")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.primary)
            Text("1. System Settings → Privacy & Security → Accessibility → enable ShortcutHUD")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            Text("2. Quit and relaunch ShortcutHUD")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.orange.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private var emptyState: some View {
        let isKnownApp = ShortcutLibrary.shortcuts(for: bundleID) != nil
        return VStack(spacing: 6) {
            if isKnownApp {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.green)
                Text("All shortcuts learned!")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("Change the skill level in Settings to unlock more.")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            } else {
                Text("No shortcuts for this app")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

struct ShortcutRow: View {
    let shortcut: Shortcut
    let count: Int
    let threshold: Int

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 8) {
                Text(shortcut.keys)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(levelColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(levelColor.opacity(0.35), lineWidth: 0.5)
                    )
                    .frame(minWidth: 70, alignment: .center)

                Text(shortcut.description)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Spacer()

                if count > 0 {
                    Text("\(count)/\(threshold)")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundStyle(.tertiary)
                }
            }

            // Progress bar — only visible once the user has used the shortcut at least once
            if count > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.primary.opacity(0.06))
                            .frame(height: 2)
                        RoundedRectangle(cornerRadius: 1)
                            .fill(levelColor.opacity(0.6))
                            .frame(width: geo.size.width * min(Double(count) / Double(threshold), 1.0), height: 2)
                    }
                }
                .frame(height: 2)
                .padding(.horizontal, 12)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 5)
        .padding(.bottom, count > 0 ? 4 : 5)
        .animation(.easeInOut(duration: 0.2), value: count)
    }

    private var levelColor: Color {
        switch shortcut.level {
        case .basic:        return .green
        case .intermediate: return .yellow
        case .advanced:     return .orange
        }
    }
}
