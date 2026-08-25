import SwiftUI

struct SudokuStatisticsView: View {
    @State private var statistics =
        SudokuStatisticsStore.load()

    var body: some View {
        List {
            Section("Games") {
                LabeledContent(
                    "Completed",
                    value: "\(statistics.gamesCompleted)"
                )

                LabeledContent(
                    "Easy",
                    value: "\(statistics.easyCompleted)"
                )

                LabeledContent(
                    "Medium",
                    value: "\(statistics.mediumCompleted)"
                )

                LabeledContent(
                    "Hard",
                    value: "\(statistics.hardCompleted)"
                )
            }

            Section("Best Times") {
                bestTimeRow(
                    title: "Easy",
                    seconds: statistics.bestEasyTime
                )

                bestTimeRow(
                    title: "Medium",
                    seconds: statistics.bestMediumTime
                )

                bestTimeRow(
                    title: "Hard",
                    seconds: statistics.bestHardTime
                )
            }

            Section("Gameplay") {
                LabeledContent(
                    "Mistakes",
                    value: "\(statistics.totalMistakes)"
                )

                LabeledContent(
                    "Hints Used",
                    value: "\(statistics.totalHints)"
                )
            }
        }
        .navigationTitle("Statistics")
        .onAppear {
            statistics = SudokuStatisticsStore.load()
        }
    }

    @ViewBuilder
    private func bestTimeRow(
        title: String,
        seconds: Int?
    ) -> some View {
        if let seconds {
            LabeledContent(
                title,
                value: formattedTime(seconds)
            )
        } else {
            LabeledContent(
                title,
                value: "-"
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
    NavigationStack {
        SudokuStatisticsView()
    }
}
