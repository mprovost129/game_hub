import SwiftUI

struct GameHubSettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Game Hub") {
                    LabeledContent(
                        "Version",
                        value: appVersion
                    )
                }

                Section("About") {
                    NavigationLink {
                        AboutGameHubView()
                    } label: {
                        Label(
                            "About Game Hub",
                            systemImage: "info.circle"
                        )
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var appVersion: String {
        Bundle.main.object(
            forInfoDictionaryKey:
                "CFBundleShortVersionString"
        ) as? String ?? "1.0"
    }
}

private struct AboutGameHubView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 56))

            Text("Game Hub")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                "A growing collection of classic number, word, and puzzle games."
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GameHubSettingsView()
}
