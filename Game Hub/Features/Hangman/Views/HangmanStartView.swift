import SwiftUI

struct HangmanStartView: View {
    @State private var selectedCategory: HangmanCategory = .everyday
    @State private var savedGame: HangmanSavedGame?

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "character.textbox")
                .font(.system(size: 56))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 8) {
                Text("Hangman")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Choose a category")
                    .foregroundStyle(.secondary)
            }

            Picker(
                "Category",
                selection: $selectedCategory
            ) {
                ForEach(HangmanCategory.allCases) { category in
                    Text(category.rawValue)
                        .tag(category)
                }
            }
            .pickerStyle(.menu)

            VStack(spacing: 12) {
                if let savedGame {
                    NavigationLink {
                        HangmanView(
                            savedGame: savedGame
                        )
                    } label: {
                        VStack(spacing: 4) {
                            Text("Resume Game")
                                .font(.headline)

                            Text(
                                savedGame.game.category.rawValue
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                    }
                    .buttonStyle(.borderedProminent)

                    Text("or")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                NavigationLink {
                    HangmanView(
                        category: selectedCategory
                    )
                } label: {
                    Text("Start Game")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
            }

            NavigationLink {
                HangmanStatisticsView()
            } label: {
                Label(
                    "View Statistics",
                    systemImage: "chart.bar"
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Hangman")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            savedGame = HangmanGameStore.load()
        }
    }
}
