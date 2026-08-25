import SwiftUI

struct GameHubStatisticsView: View {
    @State private var statistics =
        SudokuStatisticsStore.load()

    var body: some View {
        NavigationStack {
            List {
                Section("Game Hub") {
                    LabeledContent(
                        "Games Completed",
                        value: "\(statistics.gamesCompleted)"
                    )
                }

                Section("Sudoku") {
                    LabeledContent(
                        "Easy Completed",
                        value: "\(statistics.easyCompleted)"
                    )

                    LabeledContent(
                        "Medium Completed",
                        value: "\(statistics.mediumCompleted)"
                    )

                    LabeledContent(
                        "Hard Completed",
                        value: "\(statistics.hardCompleted)"
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
            }
            .navigationTitle("Statistics")
            .onAppear {
                statistics = SudokuStatisticsStore.load()
            }
        }
    }
}

#Preview {
    GameHubStatisticsView()
}
