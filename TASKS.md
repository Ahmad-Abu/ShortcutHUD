# ShortcutHUD Autopilot Task Checklist

Goal: Build a macOS floating HUD that teaches keyboard shortcuts progressively.
Milestone reference: prd.md

## M1 — Skeleton
- [x] Swift package scaffolded (Package.swift, Sources layout)
- [x] AppDelegate and main.swift entry point — status bar item + onboarding/HUD routing
- [x] HUDWindowController — floating NSPanel, Combine wiring for all state changes
- [x] HUDView — SwiftUI shortcut list view
- [x] Models.swift — Shortcut, AppShortcuts types

## M2 — Active App Detection
- [x] AppDetector.swift — NSWorkspace KVO publisher for frontmostApplication
- [x] Wired to HUDWindowController via Combine (lines 53–65 of HUDWindowController.swift)
- [x] HUD updates on every app switch automatically

## M3 — Usage Tracking
- [x] KeyMonitor.swift — NSEvent global monitor with AXIsProcessTrusted polling
- [x] UsageStore.swift — per-shortcut counters persisted to Application Support/ShortcutHUD/usage.json
- [x] KeyMonitor.onMatch → UsageStore.record() connected in HUDWindowController.show()
- [x] Persistence: JSON encode/decode with atomic write on every record()

## M4 — Graduation Logic
- [x] UsageStore.isLearned() checks count >= graduationThreshold
- [x] displayedShortcuts() filters out learned shortcuts and pulls in unlearned ones
- [x] graduationThreshold wired to SettingsView Stepper (3–50, default 10)

## M5 — Polish
- [x] SettingsView — threshold stepper, HUD toggle, per-app progress reset
- [x] OnboardingView — skill level picker + app selection before first launch
- [x] ShortcutLibrary — 25 apps with basic/intermediate/advanced tiers
- [x] Launch-at-login toggle (SMAppService.mainApp, macOS 13+)
- [x] SettingsView: skill level picker and app selection (previously onboarding-only)
- [x] HUDView: distinguish "all learned" (with graduation reward) from "unknown app" empty states
- [x] End-to-end manual test: open VS Code, use shortcuts 10×, watch graduation
