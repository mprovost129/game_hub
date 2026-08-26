import SwiftUI

struct WordGridCompletionView: View {
    let score: Int
    let words: [String]

    let onNewGame: () -> Void
    let onDone: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(
                    systemName: "checkmark.circle.fill"
                )
                .font(.system(size: 64))
                .foregroundStyle(
                    Color.accentColor
                )

                VStack(spacing: 6) {
                    Text("Round Complete")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Score: \(score)")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(
                        "\(words.count) words found"
                    )
                    .foregroundStyle(.secondary)
                }

                if words.isEmpty {
                    ContentUnavailableView(
                        "No Words Found",
                        systemImage: "text.magnifyingglass"
                    )
                } else {
                    List {
                        Section("Found Words") {
                            ForEach(
                                words.sorted(),
                                id: \.self
                            ) { word in
                                Text(word)
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                VStack(spacing: 12) {
                    Button {
                        onNewGame()
                    } label: {
                        Text("New Game")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        onDone()
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}
