# Product Requirements Document — ShortcutWindowApp

## Problem

Power users know a handful of shortcuts for every app they use. The rest sit undiscovered in a menu bar no one opens. Learning new shortcuts is friction-heavy: you have to stop, look them up, forget them, look them up again. There's no system that meets you where you are and nudges you forward incrementally.

## Goal

A lightweight macOS companion that floats beside your active app, teaches you shortcuts at your own pace, and retires them from view once you've internalized them — replacing each one with the next thing worth learning.

---

## Users

- Primary: macOS power users who want to improve their keyboard fluency (developers, designers, writers)
- Secondary: New macOS users who want a guided shortcut ramp-up for specific apps

---

## Core Features

### 1. Active App Detection
The window automatically updates its content when the frontmost application changes. No manual input required.

### 2. Floating Shortcut HUD
- Small, non-intrusive popup anchored to a screen edge or corner
- Displays a short list (3–7) of shortcuts for the current app
- Always-on-top but does not steal focus or intercept clicks

### 3. Usage Tracking
- Listens for global key events and matches them against the displayed shortcuts
- Increments a per-app, per-shortcut usage counter on each successful use
- Persists counts locally across sessions

### 4. Progressive Shortcut Replacement ("graduation")
- Once a shortcut crosses a usage threshold, it is marked as learned
- Learned shortcuts are replaced in the HUD by new ones the user hasn't seen or used much
- The threshold is configurable; default is 10 successful uses

### 5. Shortcut Library
- Bundled shortcut definitions for common macOS apps (Finder, Safari, Chrome, VS Code, Figma, Xcode)
- Each shortcut has: key combo, description, category (basic / intermediate / advanced), and app ID

---

## Out of Scope (v1)

- User-defined custom shortcuts
- Cloud sync or multi-device support
- Windows / Linux support
- Shortcut suggestions based on menu bar parsing (post-v1 enhancement)
- Analytics or telemetry

---

## User Stories

| # | As a… | I want to… | So that… |
|---|-------|-----------|----------|
| 1 | daily VS Code user | see 5 shortcuts I don't use much | I gradually improve my editing speed |
| 2 | new macOS user | have the HUD update when I switch apps | I learn shortcuts in context |
| 3 | user who knows ⌘C | stop seeing ⌘C after I've used it 10 times | the HUD stays relevant |
| 4 | user | hide the HUD temporarily | I can focus without distraction |
| 5 | user | configure the graduation threshold | I can tune the pace of learning |

---

## Success Metrics

- User uses a displayed shortcut at least once within the first session
- At least one shortcut graduates (reaches threshold) within the first week of use
- HUD is not dismissed / hidden permanently within the first 3 sessions

---

## Technical Constraints

- macOS only (initial release targets macOS 13+)
- Must not require root or kernel extensions — use Accessibility API for key event listening
- Local-only data; no network access required
- App must launch at login (optional, user-controlled)

---

## Open Questions

1. **Platform**: Native Swift/SwiftUI vs. Electron — affects bundle size, Accessibility API access, and distribution (App Store vs. direct download)
2. **Key event listening**: `CGEventTap` (requires Accessibility permission) vs. monitoring `NSEvent.addGlobalMonitorForEvents` — both need the same permission but have different reliability profiles
3. **HUD positioning**: Fixed corner, draggable, or snapped to active window edge?
4. **Graduation algorithm**: Simple counter vs. spaced-repetition scoring (like Anki) for more accurate "learned" detection
5. **Shortcut data format**: Static JSON bundles per app vs. pulling from app's own menu structure via Accessibility API

---

## Milestones

| Milestone | Scope |
|-----------|-------|
| M1 — Skeleton | Floating window appears, hardcoded shortcut list, no tracking |
| M2 — Detection | Active app detection, HUD updates on app switch |
| M3 — Tracking | Global key listener, usage counter, local persistence |
| M4 — Graduation | Threshold logic, shortcut replacement, progress indicator |
| M5 — Polish | Settings panel, launch-at-login, bundled library for 10+ apps |
