// Renders the ShortcutHUD app icon at 1024×1024 and writes it as PNG.
// Usage: swift tools/make_icon.swift <output.png>

import SwiftUI
import AppKit

struct AppIcon: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.27, green: 0.52, blue: 0.98),
                    Color(red: 0.08, green: 0.28, blue: 0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 1024 * 0.2237, style: .continuous))

            Image(systemName: "keyboard")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .padding(180)
                .shadow(color: .black.opacity(0.20), radius: 14, x: 0, y: 8)
        }
        .frame(width: 1024, height: 1024)
    }
}

MainActor.assumeIsolated {
    let outPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "icon.png"

    let renderer = ImageRenderer(content: AppIcon())
    renderer.scale = 1.0

    guard let nsImage = renderer.nsImage,
          let tiff = nsImage.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:])
    else {
        FileHandle.standardError.write(Data("render failed\n".utf8))
        exit(1)
    }

    do {
        try png.write(to: URL(fileURLWithPath: outPath))
        print("Wrote \(outPath) (\(png.count) bytes)")
    } catch {
        FileHandle.standardError.write(Data("write failed: \(error)\n".utf8))
        exit(1)
    }
}
