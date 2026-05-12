# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ShortcutWindowApp** is a macOS companion popup window that floats alongside whatever app the user has open. It displays keyboard shortcuts for the active application, tracks how often the user actually uses each shortcut, and progressively replaces well-learned shortcuts with more advanced or lesser-known ones.

Core loop:
1. Detect the active application
2. Show relevant shortcuts in a floating HUD
3. Track shortcut usage frequency per app
4. Once a shortcut is "learned" (used enough), swap it out for a more advanced one

## Status

Early concept stage — only `Idea.md` exists. No code has been written yet.

## Key Design Decisions to Make

- **Platform target**: Native macOS (Swift/SwiftUI) vs. Electron vs. a system tray agent — affects how the app detects the frontmost app and listens for global key events
- **Shortcut data source**: Hardcoded per-app shortcut lists vs. dynamic parsing of app menus via Accessibility API
- **Persistence**: Where usage counts are stored (SQLite locally, JSON file, UserDefaults)
- **"Learned" threshold**: The heuristic that decides when a shortcut is promoted/replaced
