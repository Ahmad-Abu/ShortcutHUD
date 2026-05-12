import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: UsageStore
    @ObservedObject var hudController: HUDWindowController
    @ObservedObject private var prefs = AppPreferences.shared

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at login", isOn: $prefs.launchAtLogin)
                Toggle("Show HUD", isOn: $hudController.isHUDVisible)
            }

            Section("Skill Level") {
                Picker("Show shortcuts for", selection: $prefs.skillLevel) {
                    ForEach(SkillLevel.allCases, id: \.self) { level in
                        VStack(alignment: .leading, spacing: 1) {
                            Text(level.title)
                            Text(level.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .tag(level)
                    }
                }
                .pickerStyle(.radioGroup)
            }

            Section("Apps") {
                Toggle(
                    "Show shortcuts for all apps",
                    isOn: Binding(
                        get: { prefs.selectedBundleIDs.isEmpty },
                        set: { allApps in
                            if allApps {
                                prefs.selectedBundleIDs = []
                            } else {
                                // Seed with all apps so the user can deselect individual ones
                                prefs.selectedBundleIDs = Set(ShortcutLibrary.all.map(\.appBundleID))
                            }
                        }
                    )
                )

                if !prefs.selectedBundleIDs.isEmpty {
                    ForEach(ShortcutLibrary.all, id: \.appBundleID) { entry in
                        Toggle(entry.appName, isOn: Binding(
                            get: { prefs.selectedBundleIDs.contains(entry.appBundleID) },
                            set: { included in
                                if included {
                                    prefs.selectedBundleIDs.insert(entry.appBundleID)
                                } else {
                                    prefs.selectedBundleIDs.remove(entry.appBundleID)
                                }
                            }
                        ))
                    }
                }
            }

            Section("Learning") {
                Stepper(
                    "Graduate after \(store.graduationThreshold) uses",
                    value: $store.graduationThreshold,
                    in: 3...50
                )
                Text("A shortcut disappears from the HUD once you've used it this many times.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Reset Progress") {
                if appsWithProgress.isEmpty {
                    Text("No usage recorded yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(appsWithProgress, id: \.bundleID) { entry in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.appName)
                                    .font(.system(size: 13))
                                Text("\(entry.totalUses) total uses")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Reset") {
                                store.reset(bundleID: entry.bundleID)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 380)
        .padding(.vertical, 8)
    }

    private var appsWithProgress: [(bundleID: String, appName: String, totalUses: Int)] {
        var totals: [String: Int] = [:]
        for (key, count) in store.counts {
            // stableID format: "bundleID|keys"
            guard let bundleID = key.components(separatedBy: "|").first else { continue }
            totals[bundleID, default: 0] += count
        }
        return totals
            .map { (bundleID: $0.key,
                    appName: ShortcutLibrary.shortcuts(for: $0.key)?.appName ?? $0.key,
                    totalUses: $0.value) }
            .sorted { $0.appName < $1.appName }
    }
}
