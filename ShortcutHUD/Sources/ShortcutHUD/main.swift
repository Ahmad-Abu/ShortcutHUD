import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)  // no Dock icon, no menu bar stealing focus

let delegate = AppDelegate()
app.delegate = delegate
app.run()
