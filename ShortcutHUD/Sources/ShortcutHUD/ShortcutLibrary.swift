import Foundation

enum ShortcutLibrary {
    static let all: [AppShortcuts] = [
        vscode, finder, safari, xcode,
        chrome, terminal, figma, slack,
        notion, spotify, mail, notes,
        cursor, iterm2, arc,
        obsidian, zoom, discord, bear,
        things3, githubDesktop, sketch, warp,
        zed, onePassword,
    ]

    static func shortcuts(for bundleID: String) -> AppShortcuts? {
        all.first { $0.appBundleID == bundleID }
    }

    // MARK: - VS Code
    static let vscode = AppShortcuts(
        appBundleID: "com.microsoft.VSCode",
        appName: "VS Code",
        shortcuts: [
            Shortcut(keys: "⌘ P",       description: "Quick open file",            level: .basic),
            Shortcut(keys: "⌘ ⇧ P",     description: "Command palette",            level: .basic),
            Shortcut(keys: "⌘ /",       description: "Toggle line comment",        level: .basic),
            Shortcut(keys: "⌘ B",       description: "Toggle sidebar",             level: .basic),
            Shortcut(keys: "⌥ ↑",       description: "Move line up",               level: .intermediate),
            Shortcut(keys: "⌥ ↓",       description: "Move line down",             level: .intermediate),
            Shortcut(keys: "⌘ D",       description: "Select next occurrence",     level: .intermediate),
            Shortcut(keys: "⌘ ⇧ K",     description: "Delete line",               level: .intermediate),
            Shortcut(keys: "⌘ ⇧ L",     description: "Select all occurrences",    level: .intermediate),
            Shortcut(keys: "⌃ `",       description: "Toggle terminal",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ \\",    description: "Jump to matching bracket",   level: .advanced),
            Shortcut(keys: "⌃ G",       description: "Go to line",                 level: .advanced),
            Shortcut(keys: "⌘ K ⌘ 0",   description: "Fold all regions",          level: .advanced),
            Shortcut(keys: "⌘ ⇧ F",     description: "Search across files",       level: .advanced),
            Shortcut(keys: "⌥ ⌘ ↑",     description: "Add cursor above",          level: .advanced),
        ]
    )

    // MARK: - Cursor
    static let cursor = AppShortcuts(
        appBundleID: "com.todesktop.230313mzl4w4u92",
        appName: "Cursor",
        shortcuts: [
            Shortcut(keys: "⌘ P",       description: "Quick open file",            level: .basic),
            Shortcut(keys: "⌘ ⇧ P",     description: "Command palette",            level: .basic),
            Shortcut(keys: "⌘ K",       description: "AI inline edit",             level: .basic),
            Shortcut(keys: "⌘ L",       description: "Open AI chat",               level: .basic),
            Shortcut(keys: "⌘ /",       description: "Toggle line comment",        level: .basic),
            Shortcut(keys: "⌘ ⇧ K",     description: "Delete line",               level: .intermediate),
            Shortcut(keys: "⌘ D",       description: "Select next occurrence",     level: .intermediate),
            Shortcut(keys: "⌥ ↑",       description: "Move line up",               level: .intermediate),
            Shortcut(keys: "⌥ ↓",       description: "Move line down",             level: .intermediate),
            Shortcut(keys: "⌃ `",       description: "Toggle terminal",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ A",     description: "AI composer (multi-file)",  level: .advanced),
            Shortcut(keys: "⌘ ⇧ F",     description: "Search across files",       level: .advanced),
            Shortcut(keys: "⌥ ⌘ ↑",     description: "Add cursor above",          level: .advanced),
        ]
    )

    // MARK: - Finder
    static let finder = AppShortcuts(
        appBundleID: "com.apple.finder",
        appName: "Finder",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New Finder window",          level: .basic),
            Shortcut(keys: "⌘ ⇧ N",     description: "New folder",                 level: .basic),
            Shortcut(keys: "⌘ ⌫",       description: "Move to Trash",             level: .basic),
            Shortcut(keys: "Space",     description: "Quick Look preview",         level: .basic),
            Shortcut(keys: "⌘ ↑",       description: "Open enclosing folder",     level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Go forward",                level: .intermediate),
            Shortcut(keys: "⌘ [",       description: "Go back",                   level: .intermediate),
            Shortcut(keys: "⌘ 1",       description: "Icon view",                 level: .intermediate),
            Shortcut(keys: "⌘ 2",       description: "List view",                 level: .intermediate),
            Shortcut(keys: "⌘ 3",       description: "Column view",               level: .intermediate),
            Shortcut(keys: "⌘ ⇧ .",     description: "Show hidden files",         level: .advanced),
            Shortcut(keys: "⌘ ⌥ P",     description: "Show/hide path bar",        level: .advanced),
            Shortcut(keys: "⌘ ⌥ S",     description: "Show/hide sidebar",         level: .advanced),
        ]
    )

    // MARK: - Safari
    static let safari = AppShortcuts(
        appBundleID: "com.apple.Safari",
        appName: "Safari",
        shortcuts: [
            Shortcut(keys: "⌘ T",       description: "New tab",                   level: .basic),
            Shortcut(keys: "⌘ W",       description: "Close tab",                 level: .basic),
            Shortcut(keys: "⌘ L",       description: "Focus address bar",         level: .basic),
            Shortcut(keys: "⌘ R",       description: "Reload page",               level: .basic),
            Shortcut(keys: "⌘ ⇧ ]",     description: "Next tab",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ [",     description: "Previous tab",              level: .intermediate),
            Shortcut(keys: "⌘ F",       description: "Find on page",             level: .intermediate),
            Shortcut(keys: "⌘ ⇧ T",     description: "Reopen closed tab",        level: .intermediate),
            Shortcut(keys: "⌘ ⇧ R",     description: "Enter Reader Mode",        level: .advanced),
            Shortcut(keys: "⌘ ⌥ 1",     description: "Show bookmarks sidebar",   level: .advanced),
            Shortcut(keys: "⌘ ⌥ 2",     description: "Show reading list",        level: .advanced),
        ]
    )

    // MARK: - Chrome
    static let chrome = AppShortcuts(
        appBundleID: "com.google.Chrome",
        appName: "Chrome",
        shortcuts: [
            Shortcut(keys: "⌘ T",       description: "New tab",                   level: .basic),
            Shortcut(keys: "⌘ W",       description: "Close tab",                 level: .basic),
            Shortcut(keys: "⌘ L",       description: "Focus address bar",         level: .basic),
            Shortcut(keys: "⌘ R",       description: "Reload page",               level: .basic),
            Shortcut(keys: "⌘ ⇧ ]",     description: "Next tab",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ [",     description: "Previous tab",              level: .intermediate),
            Shortcut(keys: "⌘ ⇧ T",     description: "Reopen closed tab",        level: .intermediate),
            Shortcut(keys: "⌘ ⇧ N",     description: "New incognito window",     level: .intermediate),
            Shortcut(keys: "⌘ ⌥ I",     description: "Open DevTools",            level: .intermediate),
            Shortcut(keys: "⌘ ⌥ J",     description: "Open JS Console",          level: .intermediate),
            Shortcut(keys: "⌘ ⇧ C",     description: "Inspect element",          level: .advanced),
            Shortcut(keys: "⌘ ⇧ J",     description: "Open Downloads",           level: .advanced),
            Shortcut(keys: "⌘ ⇧ B",     description: "Toggle bookmarks bar",     level: .advanced),
            Shortcut(keys: "⌘ ⌥ ←",     description: "Go back",                  level: .advanced),
        ]
    )

    // MARK: - Arc
    static let arc = AppShortcuts(
        appBundleID: "company.thebrowser.Browser",
        appName: "Arc",
        shortcuts: [
            Shortcut(keys: "⌘ T",       description: "New tab",                   level: .basic),
            Shortcut(keys: "⌘ L",       description: "Focus address bar",         level: .basic),
            Shortcut(keys: "⌘ ⇧ ]",     description: "Next tab",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ [",     description: "Previous tab",              level: .intermediate),
            Shortcut(keys: "⌘ S",       description: "Save to Arc",              level: .intermediate),
            Shortcut(keys: "⌘ ⌥ N",     description: "New space",                level: .intermediate),
            Shortcut(keys: "⌃ Tab",     description: "Switch tabs",               level: .intermediate),
            Shortcut(keys: "⌘ ⌥ C",     description: "Copy URL",                 level: .advanced),
            Shortcut(keys: "⌘ ⌥ I",     description: "Open DevTools",            level: .advanced),
            Shortcut(keys: "⌘ ⇧ E",     description: "Split view",               level: .advanced),
        ]
    )

    // MARK: - Terminal
    static let terminal = AppShortcuts(
        appBundleID: "com.apple.Terminal",
        appName: "Terminal",
        shortcuts: [
            Shortcut(keys: "⌘ T",       description: "New tab",                   level: .basic),
            Shortcut(keys: "⌘ N",       description: "New window",                level: .basic),
            Shortcut(keys: "⌃ C",       description: "Interrupt process",         level: .basic),
            Shortcut(keys: "⌃ D",       description: "End of input (EOF)",        level: .basic),
            Shortcut(keys: "⌃ L",       description: "Clear screen",              level: .basic),
            Shortcut(keys: "⌃ R",       description: "Reverse history search",    level: .intermediate),
            Shortcut(keys: "⌃ A",       description: "Jump to line start",        level: .intermediate),
            Shortcut(keys: "⌃ E",       description: "Jump to line end",          level: .intermediate),
            Shortcut(keys: "⌃ U",       description: "Clear current line",        level: .intermediate),
            Shortcut(keys: "⌃ W",       description: "Delete word before cursor", level: .intermediate),
            Shortcut(keys: "⌃ Z",       description: "Suspend process (bg)",      level: .advanced),
            Shortcut(keys: "⌃ ←",       description: "Jump back one word",        level: .advanced),
            Shortcut(keys: "⌃ →",       description: "Jump forward one word",     level: .advanced),
        ]
    )

    // MARK: - iTerm2
    static let iterm2 = AppShortcuts(
        appBundleID: "com.googlecode.iterm2",
        appName: "iTerm2",
        shortcuts: [
            Shortcut(keys: "⌘ T",       description: "New tab",                   level: .basic),
            Shortcut(keys: "⌘ D",       description: "Split pane vertically",     level: .basic),
            Shortcut(keys: "⌘ ⇧ D",     description: "Split pane horizontally",  level: .basic),
            Shortcut(keys: "⌃ C",       description: "Interrupt process",         level: .basic),
            Shortcut(keys: "⌃ R",       description: "Reverse history search",    level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Next pane",                 level: .intermediate),
            Shortcut(keys: "⌘ [",       description: "Previous pane",             level: .intermediate),
            Shortcut(keys: "⌘ ⌥ E",     description: "Find across all panes",    level: .intermediate),
            Shortcut(keys: "⌘ ⇧ I",     description: "Broadcast input to panes", level: .advanced),
            Shortcut(keys: "⌘ ⌥ B",     description: "Open toolbelt",            level: .advanced),
        ]
    )

    // MARK: - Figma
    static let figma = AppShortcuts(
        appBundleID: "com.figma.Desktop",
        appName: "Figma",
        shortcuts: [
            Shortcut(keys: "V",         description: "Move tool",                 level: .basic),
            Shortcut(keys: "F",         description: "Frame tool",                level: .basic),
            Shortcut(keys: "R",         description: "Rectangle tool",            level: .basic),
            Shortcut(keys: "T",         description: "Text tool",                 level: .basic),
            Shortcut(keys: "⌘ G",       description: "Group selection",           level: .basic),
            Shortcut(keys: "⌘ ⇧ G",     description: "Ungroup",                  level: .basic),
            Shortcut(keys: "⌘ [",       description: "Send backward",            level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Bring forward",            level: .intermediate),
            Shortcut(keys: "⌘ ⌥ G",     description: "Frame selection",          level: .intermediate),
            Shortcut(keys: "⌘ ⇧ H",     description: "Flip horizontal",          level: .intermediate),
            Shortcut(keys: "⌃ C",       description: "Pick color",               level: .intermediate),
            Shortcut(keys: "⌘ E",       description: "Export selection",         level: .advanced),
            Shortcut(keys: "⌘ ⌥ K",     description: "Create component",         level: .advanced),
            Shortcut(keys: "⌘ ⌥ B",     description: "Detach instance",          level: .advanced),
        ]
    )

    // MARK: - Slack
    static let slack = AppShortcuts(
        appBundleID: "com.tinyspeck.slackmacgap",
        appName: "Slack",
        shortcuts: [
            Shortcut(keys: "⌘ K",       description: "Jump to conversation",      level: .basic),
            Shortcut(keys: "⌘ /",       description: "Open shortcuts list",       level: .basic),
            Shortcut(keys: "⌘ N",       description: "New message",               level: .basic),
            Shortcut(keys: "⌘ ⇧ M",     description: "Open DMs",                 level: .intermediate),
            Shortcut(keys: "⌘ ⇧ K",     description: "Browse channels",          level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Go forward in history",    level: .intermediate),
            Shortcut(keys: "⌘ [",       description: "Go back in history",       level: .intermediate),
            Shortcut(keys: "⌘ ⇧ A",     description: "All unreads",              level: .intermediate),
            Shortcut(keys: "⌘ ⇧ Y",     description: "Set a status",             level: .advanced),
            Shortcut(keys: "⌘ ⇧ S",     description: "Open starred items",      level: .advanced),
            Shortcut(keys: "⌘ .",       description: "Toggle right sidebar",     level: .advanced),
        ]
    )

    // MARK: - Notion
    static let notion = AppShortcuts(
        appBundleID: "notion.id",
        appName: "Notion",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New page",                  level: .basic),
            Shortcut(keys: "⌘ P",       description: "Quick search / jump to",   level: .basic),
            Shortcut(keys: "⌘ ⇧ U",     description: "Go up to parent page",     level: .basic),
            Shortcut(keys: "⌘ ⇧ L",     description: "Toggle dark mode",         level: .intermediate),
            Shortcut(keys: "⌘ ⇧ P",     description: "Toggle page preview",      level: .intermediate),
            Shortcut(keys: "⌘ ⌥ T",     description: "Create new template",      level: .intermediate),
            Shortcut(keys: "/",         description: "Insert block",              level: .basic),
            Shortcut(keys: "⌘ ⇧ H",     description: "Highlight block",          level: .intermediate),
            Shortcut(keys: "⌘ ⇧ M",     description: "Move block",               level: .advanced),
            Shortcut(keys: "⌘ ⇧ 0",     description: "Body text",                level: .advanced),
        ]
    )

    // MARK: - Spotify
    static let spotify = AppShortcuts(
        appBundleID: "com.spotify.client",
        appName: "Spotify",
        shortcuts: [
            Shortcut(keys: "Space",     description: "Play / pause",              level: .basic),
            Shortcut(keys: "⌘ →",       description: "Next track",                level: .basic),
            Shortcut(keys: "⌘ ←",       description: "Previous track",            level: .basic),
            Shortcut(keys: "⌘ ↑",       description: "Volume up",                 level: .basic),
            Shortcut(keys: "⌘ ↓",       description: "Volume down",               level: .basic),
            Shortcut(keys: "⌘ ⇧ →",     description: "Seek forward",              level: .intermediate),
            Shortcut(keys: "⌘ ⇧ ←",     description: "Seek backward",             level: .intermediate),
            Shortcut(keys: "⌘ L",       description: "Like current song",         level: .intermediate),
            Shortcut(keys: "⌘ R",       description: "Toggle repeat",             level: .intermediate),
            Shortcut(keys: "⌘ ⇧ R",     description: "Toggle shuffle",            level: .advanced),
        ]
    )

    // MARK: - Mail
    static let mail = AppShortcuts(
        appBundleID: "com.apple.mail",
        appName: "Mail",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New message",               level: .basic),
            Shortcut(keys: "⌘ R",       description: "Reply",                     level: .basic),
            Shortcut(keys: "⌘ ⇧ R",     description: "Reply all",                level: .basic),
            Shortcut(keys: "⌘ ⇧ F",     description: "Forward",                  level: .basic),
            Shortcut(keys: "⌘ ⌫",       description: "Delete message",           level: .basic),
            Shortcut(keys: "⌘ ⌥ F",     description: "Search mailbox",           level: .intermediate),
            Shortcut(keys: "⌘ ⇧ J",     description: "Mark as junk",             level: .intermediate),
            Shortcut(keys: "⌘ ⇧ U",     description: "Mark as unread",           level: .intermediate),
            Shortcut(keys: "⌘ ⌃ A",     description: "Archive",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ N",     description: "Get new mail",             level: .advanced),
        ]
    )

    // MARK: - Notes
    static let notes = AppShortcuts(
        appBundleID: "com.apple.Notes",
        appName: "Notes",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New note",                  level: .basic),
            Shortcut(keys: "⌘ ⇧ N",     description: "New folder",               level: .basic),
            Shortcut(keys: "⌘ F",       description: "Search notes",              level: .basic),
            Shortcut(keys: "⌘ B",       description: "Bold",                      level: .basic),
            Shortcut(keys: "⌘ I",       description: "Italic",                    level: .basic),
            Shortcut(keys: "⌘ ⇧ H",     description: "Heading style",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ 7",     description: "Numbered list",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ 8",     description: "Bullet list",              level: .intermediate),
            Shortcut(keys: "⌘ ⇧ 9",     description: "Checklist",                level: .intermediate),
            Shortcut(keys: "⌘ K",       description: "Add link",                  level: .advanced),
        ]
    )

    // MARK: - Xcode
    static let xcode = AppShortcuts(
        appBundleID: "com.apple.dt.Xcode",
        appName: "Xcode",
        shortcuts: [
            Shortcut(keys: "⌘ B",       description: "Build",                     level: .basic),
            Shortcut(keys: "⌘ R",       description: "Run",                       level: .basic),
            Shortcut(keys: "⌘ .",       description: "Stop",                      level: .basic),
            Shortcut(keys: "⌘ ⇧ O",     description: "Open quickly",             level: .intermediate),
            Shortcut(keys: "⌃ ⌘ ↑",     description: "Switch .h / .m",           level: .intermediate),
            Shortcut(keys: "⌘ ⇧ J",     description: "Reveal in navigator",      level: .intermediate),
            Shortcut(keys: "⌘ ⌥ [",     description: "Move line up",              level: .intermediate),
            Shortcut(keys: "⌘ ⌥ ]",     description: "Move line down",            level: .intermediate),
            Shortcut(keys: "⌘ ⌥ ←",     description: "Fold code block",          level: .advanced),
            Shortcut(keys: "⌃ ⌘ E",     description: "Edit all in scope",        level: .advanced),
            Shortcut(keys: "⌘ ⇧ Y",     description: "Show debug area",          level: .advanced),
        ]
    )
    // MARK: - Obsidian
    static let obsidian = AppShortcuts(
        appBundleID: "md.obsidian",
        appName: "Obsidian",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New note",                  level: .basic),
            Shortcut(keys: "⌘ O",       description: "Open quick switcher",       level: .basic),
            Shortcut(keys: "⌘ P",       description: "Command palette",           level: .basic),
            Shortcut(keys: "⌘ ⇧ F",     description: "Search in all files",      level: .basic),
            Shortcut(keys: "⌘ E",       description: "Toggle edit/preview",       level: .basic),
            Shortcut(keys: "⌘ [",       description: "Navigate back",             level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Navigate forward",          level: .intermediate),
            Shortcut(keys: "⌘ ⇧ ]",     description: "Next tab",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ [",     description: "Previous tab",              level: .intermediate),
            Shortcut(keys: "⌘ ⇧ E",     description: "Toggle left sidebar",      level: .intermediate),
            Shortcut(keys: "⌘ ⌥ ←",     description: "Fold current section",     level: .advanced),
            Shortcut(keys: "⌘ ⌥ →",     description: "Unfold current section",   level: .advanced),
            Shortcut(keys: "⌘ ⇧ I",     description: "Open Obsidian URI",        level: .advanced),
        ]
    )

    // MARK: - Zoom
    static let zoom = AppShortcuts(
        appBundleID: "us.zoom.xos",
        appName: "Zoom",
        shortcuts: [
            Shortcut(keys: "⌘ ⇧ A",     description: "Mute / unmute audio",       level: .basic),
            Shortcut(keys: "⌘ ⇧ V",     description: "Start / stop video",        level: .basic),
            Shortcut(keys: "⌘ ⇧ S",     description: "Start / stop screen share", level: .basic),
            Shortcut(keys: "⌘ ⇧ H",     description: "Show / hide controls",      level: .basic),
            Shortcut(keys: "Space",     description: "Push to talk (when muted)",  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ C",     description: "Show / hide chat",          level: .intermediate),
            Shortcut(keys: "⌘ ⇧ P",     description: "Show participants panel",   level: .intermediate),
            Shortcut(keys: "⌘ ⇧ R",     description: "Start / stop recording",    level: .intermediate),
            Shortcut(keys: "⌘ ⇧ W",     description: "Switch camera",             level: .advanced),
            Shortcut(keys: "⌘ ⇧ N",     description: "Rename yourself",           level: .advanced),
            Shortcut(keys: "⌘ ⌥ Y",     description: "Raise / lower hand",        level: .advanced),
        ]
    )

    // MARK: - Discord
    static let discord = AppShortcuts(
        appBundleID: "com.hnc.Discord",
        appName: "Discord",
        shortcuts: [
            Shortcut(keys: "⌘ K",       description: "Quick switcher",            level: .basic),
            Shortcut(keys: "⌘ ⇧ M",     description: "Mute / unmute",             level: .basic),
            Shortcut(keys: "⌘ ⇧ D",     description: "Deafen / undeafen",        level: .basic),
            Shortcut(keys: "⌘ F",       description: "Search in server",          level: .basic),
            Shortcut(keys: "⌘ ⇧ ]",     description: "Next unread channel",       level: .intermediate),
            Shortcut(keys: "⌘ ⇧ [",     description: "Previous channel",          level: .intermediate),
            Shortcut(keys: "⌘ ↓",       description: "Next channel",              level: .intermediate),
            Shortcut(keys: "⌘ ↑",       description: "Previous channel",          level: .intermediate),
            Shortcut(keys: "⌘ ⇧ H",     description: "Toggle member list",        level: .intermediate),
            Shortcut(keys: "⌘ ⇧ I",     description: "Mark channel as read",      level: .advanced),
            Shortcut(keys: "⌘ ⌥ ↓",     description: "Next unread server",        level: .advanced),
        ]
    )

    // MARK: - Bear
    static let bear = AppShortcuts(
        appBundleID: "net.shinyfrog.bear",
        appName: "Bear",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New note",                  level: .basic),
            Shortcut(keys: "⌘ ⇧ F",     description: "Search all notes",          level: .basic),
            Shortcut(keys: "⌘ B",       description: "Bold",                      level: .basic),
            Shortcut(keys: "⌘ I",       description: "Italic",                    level: .basic),
            Shortcut(keys: "⌘ ⌥ C",     description: "Code block",               level: .intermediate),
            Shortcut(keys: "⌘ ⇧ H",     description: "Heading style",             level: .intermediate),
            Shortcut(keys: "⌘ ⇧ U",     description: "Unordered list",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ T",     description: "Todo item",                 level: .intermediate),
            Shortcut(keys: "⌘ ⇧ L",     description: "Link to note",              level: .intermediate),
            Shortcut(keys: "⌘ ⌥ 1",     description: "Heading 1",                 level: .advanced),
            Shortcut(keys: "⌘ ⌥ 2",     description: "Heading 2",                 level: .advanced),
            Shortcut(keys: "⌘ ⌥ 3",     description: "Heading 3",                 level: .advanced),
        ]
    )

    // MARK: - Things 3
    static let things3 = AppShortcuts(
        appBundleID: "com.culturedcode.ThingsMac",
        appName: "Things 3",
        shortcuts: [
            Shortcut(keys: "⌘ N",       description: "New to-do",                 level: .basic),
            Shortcut(keys: "⌘ ⇧ N",     description: "New project",               level: .basic),
            Shortcut(keys: "Space",     description: "Open selected to-do",       level: .basic),
            Shortcut(keys: "⌘ ⇧ D",     description: "Show Today",                level: .basic),
            Shortcut(keys: "⌘ K",       description: "Move to project",           level: .intermediate),
            Shortcut(keys: "⌘ T",       description: "Schedule",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ L",     description: "Show logbook",              level: .intermediate),
            Shortcut(keys: "⌘ ⌥ N",     description: "New area",                  level: .intermediate),
            Shortcut(keys: "⌘ ⇧ C",     description: "Complete to-do",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ S",     description: "Start today",               level: .advanced),
            Shortcut(keys: "⌃ ⌘ O",     description: "Jump to upcoming",          level: .advanced),
        ]
    )

    // MARK: - GitHub Desktop
    static let githubDesktop = AppShortcuts(
        appBundleID: "com.github.GitHubClient",
        appName: "GitHub Desktop",
        shortcuts: [
            Shortcut(keys: "⌘ ⇧ O",     description: "Open repository in editor", level: .basic),
            Shortcut(keys: "⌘ Enter",   description: "Commit changes",            level: .basic),
            Shortcut(keys: "⌘ P",       description: "Push to remote",            level: .basic),
            Shortcut(keys: "⌘ ⇧ P",     description: "Pull from remote",          level: .basic),
            Shortcut(keys: "⌘ '",       description: "Focus commit message",       level: .intermediate),
            Shortcut(keys: "⌘ ⇧ Y",     description: "Open PR in browser",        level: .intermediate),
            Shortcut(keys: "⌘ ⇧ A",     description: "Open in external editor",   level: .intermediate),
            Shortcut(keys: "⌘ ⇧ G",     description: "Open in browser",           level: .intermediate),
            Shortcut(keys: "⌘ ⌥ ↑",     description: "Previous commit",           level: .advanced),
            Shortcut(keys: "⌘ ⌥ ↓",     description: "Next commit",               level: .advanced),
        ]
    )

    // MARK: - Sketch
    static let sketch = AppShortcuts(
        appBundleID: "com.bohemiancoding.sketch3",
        appName: "Sketch",
        shortcuts: [
            Shortcut(keys: "V",         description: "Vector pen",                level: .basic),
            Shortcut(keys: "R",         description: "Rectangle",                 level: .basic),
            Shortcut(keys: "O",         description: "Oval",                      level: .basic),
            Shortcut(keys: "T",         description: "Text",                      level: .basic),
            Shortcut(keys: "A",         description: "Artboard",                  level: .basic),
            Shortcut(keys: "⌘ G",       description: "Group selection",           level: .intermediate),
            Shortcut(keys: "⌘ ⇧ G",     description: "Ungroup",                   level: .intermediate),
            Shortcut(keys: "⌘ [",       description: "Send backward",             level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Bring forward",             level: .intermediate),
            Shortcut(keys: "⌘ ⇧ H",     description: "Flip horizontal",           level: .intermediate),
            Shortcut(keys: "⌘ E",       description: "Export selection",          level: .advanced),
            Shortcut(keys: "⌘ ⌥ C",     description: "Copy CSS attributes",       level: .advanced),
            Shortcut(keys: "⌘ ⌥ G",     description: "Flatten selection",         level: .advanced),
        ]
    )

    // MARK: - Warp
    static let warp = AppShortcuts(
        appBundleID: "dev.warp.Warp-Stable",
        appName: "Warp",
        shortcuts: [
            Shortcut(keys: "⌘ T",       description: "New tab",                   level: .basic),
            Shortcut(keys: "⌘ D",       description: "Split pane right",          level: .basic),
            Shortcut(keys: "⌘ ⇧ D",     description: "Split pane down",           level: .basic),
            Shortcut(keys: "⌃ C",       description: "Interrupt process",         level: .basic),
            Shortcut(keys: "⌘ /",       description: "AI command search",         level: .basic),
            Shortcut(keys: "⌃ R",       description: "Search command history",    level: .intermediate),
            Shortcut(keys: "⌘ P",       description: "Command palette",           level: .intermediate),
            Shortcut(keys: "⌘ ]",       description: "Next pane",                 level: .intermediate),
            Shortcut(keys: "⌘ [",       description: "Previous pane",             level: .intermediate),
            Shortcut(keys: "⌘ ⇧ R",     description: "Rename tab",                level: .advanced),
            Shortcut(keys: "⌘ ⌥ ↑",     description: "Scroll to top of block",   level: .advanced),
        ]
    )

    // MARK: - Zed
    static let zed = AppShortcuts(
        appBundleID: "dev.zed.Zed",
        appName: "Zed",
        shortcuts: [
            Shortcut(keys: "⌘ P",       description: "Open file",                 level: .basic),
            Shortcut(keys: "⌘ ⇧ P",     description: "Command palette",           level: .basic),
            Shortcut(keys: "⌘ /",       description: "Toggle comment",            level: .basic),
            Shortcut(keys: "⌘ D",       description: "Select next occurrence",    level: .intermediate),
            Shortcut(keys: "⌥ ↑",       description: "Move line up",              level: .intermediate),
            Shortcut(keys: "⌥ ↓",       description: "Move line down",            level: .intermediate),
            Shortcut(keys: "⌘ ⇧ F",     description: "Search in project",         level: .intermediate),
            Shortcut(keys: "⌃ `",       description: "Toggle terminal",           level: .intermediate),
            Shortcut(keys: "⌃ G",       description: "Go to line",                level: .advanced),
            Shortcut(keys: "⌘ ⌥ ↑",     description: "Add cursor above",          level: .advanced),
            Shortcut(keys: "⌘ ⇧ O",     description: "Go to symbol",              level: .advanced),
        ]
    )

    // MARK: - 1Password
    static let onePassword = AppShortcuts(
        appBundleID: "com.1password.1password",
        appName: "1Password",
        shortcuts: [
            Shortcut(keys: "⌘ F",       description: "Search vault",              level: .basic),
            Shortcut(keys: "⌘ N",       description: "New item",                  level: .basic),
            Shortcut(keys: "⌘ C",       description: "Copy password",             level: .basic),
            Shortcut(keys: "⌘ ⇧ C",     description: "Copy username",             level: .basic),
            Shortcut(keys: "⌘ ⇧ L",     description: "Lock 1Password",            level: .intermediate),
            Shortcut(keys: "⌘ L",       description: "Show in large type",        level: .intermediate),
            Shortcut(keys: "⌘ ⇧ Space", description: "Open Quick Access",         level: .intermediate),
            Shortcut(keys: "⌘ ⌥ C",     description: "Copy one-time password",    level: .advanced),
            Shortcut(keys: "⌘ ⇧ V",     description: "Move to vault",             level: .advanced),
        ]
    )
}

private extension Shortcut {
    init(keys: String, description: String, level: ShortcutLevel) {
        self.init(keys: keys, description: description, level: level, appBundleID: "")
    }
}
