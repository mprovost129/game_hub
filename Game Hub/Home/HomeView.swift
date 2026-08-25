import SwiftUI

struct HomeView: View {
    @State private var savedSudokuGame: SudokuSavedGame?

    private let columns = [
        GridItem(
            .flexible(),
            spacing: 16
        ),
        GridItem(
            .flexible(),
            spacing: 16
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    if let savedSudokuGame {
                        continuePlayingSection(
                            savedGame: savedSudokuGame
                        )
                    }

                    Text("Games")
                        .font(.title2)
                        .fontWeight(.bold)

                    LazyVGrid(
                        columns: columns,
                        spacing: 16
                    ) {
                        ForEach(GameDefinition.allGames) { game in
                            gameDestination(for: game)
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                savedSudokuGame =
                    SudokuGameStore.load()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Game Hub")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Pick a game and start playing.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
    }

    private func continuePlayingSection(
        savedGame: SudokuSavedGame
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continue Playing")
                .font(.title2)
                .fontWeight(.bold)

            NavigationLink {
                SudokuView(
                    savedGame: savedGame
                )
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "square.grid.3x3")
                        .font(.system(size: 30))

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text("Sudoku")
                            .font(.headline)

                        Text(
                            "\(savedGame.difficulty.rawValue) • " +
                            formattedTime(
                                savedGame.elapsedSeconds
                            )
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "play.fill")
                        .font(.headline)
                }
                .padding()
                .background(
                    RoundedRectangle(
                        cornerRadius: 18
                    )
                    .fill(.thinMaterial)
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func gameDestination(
        for game: GameDefinition
    ) -> some View {
        if game.id == GameDefinition.sudoku.id {
            NavigationLink {
                SudokuStartView()
            } label: {
                GameCardView(
                    game: game
                )
            }
            .buttonStyle(.plain)
        } else {
            GameCardView(
                game: game
            )
        }
    }

    private func formattedTime(
        _ seconds: Int
    ) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60

        return String(
            format: "%02d:%02d",
            minutes,
            remainder
        )
    }
}

#Preview {
    HomeView()
}
