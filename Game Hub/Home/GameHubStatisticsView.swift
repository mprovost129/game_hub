import SwiftUI

struct GameHubStatisticsView: View {
    @State private var sudokuStatistics =
        SudokuStatisticsStore.load()

    @State private var hangmanStatistics =
        HangmanStatisticsStore.load()

    var body: some View {
        NavigationStack {
            List {
                Section("Game Hub") {
                    LabeledContent(
                        "Games Completed",
                        value: "\(totalGamesCompleted)"
                    )
                }

                Section("Sudoku") {
                    LabeledContent(
                        "Easy Completed",
                        value: "\(sudokuStatistics.easyCompleted)"
                    )

                    LabeledContent(
                        "Medium Completed",
                        value: "\(sudokuStatistics.mediumCompleted)"
                    )

                    LabeledContent(
                        "Hard Completed",
                        value: "\(sudokuStatistics.hardCompleted)"
                    )

                    NavigationLink {
                        SudokuStatisticsView()
                    } label: {
                        Label(
                            "View Sudoku Statistics",
                            systemImage: "square.grid.3x3"
                        )
                    }
                }

                Section("Hangman") {
                    LabeledContent(
                        "Played",
                        value: "\(hangmanStatistics.gamesPlayed)"
                    )

                    LabeledContent(
                        "Won",
                        value: "\(hangmanStatistics.gamesWon)"
                    )

                    NavigationLink {
                        HangmanStatisticsView()
                    } label: {
                        Label(
                            "View Hangman Statistics",
                            systemImage: "character.textbox"
                        )
                    }
                }
            }
            .navigationTitle("Statistics")
            .onAppear {
                sudokuStatistics = SudokuStatisticsStore.load()
                hangmanStatistics = HangmanStatisticsStore.load()
            }
        }
    }

    private var totalGamesCompleted: Int {
        sudokuStatistics.gamesCompleted +
        hangmanStatistics.gamesPlayed
    }
}

#Preview {
    GameHubStatisticsView()
}
