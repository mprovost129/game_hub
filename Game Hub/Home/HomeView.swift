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

                    sectionHeader(
                        title: "Games",
                        subtitle: "Choose a game."
                    )

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
        HStack {
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                Text("Game Hub")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Classic games. One place."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(
                systemName: "gamecontroller.fill"
            )
            .font(.system(size: 30))
            .foregroundStyle(
                Color.accentColor
            )
        }
        .padding(.top, 8)
    }

    private func continuePlayingSection(
        savedGame: SudokuSavedGame
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                title: "Continue Playing",
                subtitle: "Pick up where you left off."
            )

            NavigationLink {
                SudokuView(
                    savedGame: savedGame
                )
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                Color.accentColor.opacity(0.14)
                            )

                        Image(
                            systemName: "square.grid.3x3"
                        )
                        .font(.system(
                            size: 28,
                            weight: .semibold
                        ))
                        .foregroundStyle(
                            Color.accentColor
                        )
                    }
                    .frame(width: 58, height: 58)

                    VStack(
                        alignment: .leading,
                        spacing: 5
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

                        Text("Resume game")
                            .font(.caption)
                            .foregroundStyle(
                                Color.accentColor
                            )
                    }

                    Spacer()

                    Image(
                        systemName: "play.circle.fill"
                    )
                    .font(.system(size: 30))
                    .foregroundStyle(
                        Color.accentColor
                    )
                }
                .padding(16)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .fill(
                        Color.accentColor.opacity(0.06)
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .stroke(
                        Color.accentColor.opacity(0.25),
                        lineWidth: 1.25
                    )
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func sectionHeader(
        title: String,
        subtitle: String
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 3
        ) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func gameDestination(
        for game: GameDefinition
    ) -> some View {
        switch game.id {
        case GameDefinition.sudoku.id:
            NavigationLink {
                SudokuStartView()
            } label: {
                GameCardView(
                    game: game
                )
            }
            .buttonStyle(.plain)

        case GameDefinition.hangman.id:
            NavigationLink {
                HangmanStartView()
            } label: {
                GameCardView(
                    game: game
                )
            }
            .buttonStyle(.plain)

        case GameDefinition.wordGrid.id:
            NavigationLink {
                WordGridStartView()
            } label: {
                GameCardView(
                    game: game
                )
            }
            .buttonStyle(.plain)

        default:
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
