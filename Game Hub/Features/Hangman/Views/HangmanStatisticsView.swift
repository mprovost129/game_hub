import SwiftUI

struct HangmanStatisticsView: View {
    @State private var statistics =
        HangmanStatisticsStore.load()

    var body: some View {
        List {
            Section("Games") {
                LabeledContent(
                    "Played",
                    value: "\(statistics.gamesPlayed)"
                )

                LabeledContent(
                    "Won",
                    value: "\(statistics.gamesWon)"
                )

                LabeledContent(
                    "Lost",
                    value: "\(statistics.gamesLost)"
                )
            }

            Section("Gameplay") {
                LabeledContent(
                    "Wrong Guesses",
                    value: "\(statistics.totalWrongGuesses)"
                )
            }
        }
        .navigationTitle("Hangman Statistics")
        .onAppear {
            statistics =
                HangmanStatisticsStore.load()
        }
    }
}
