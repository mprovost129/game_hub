import SwiftUI

struct SudokuStartView: View {
    @State private var selectedDifficulty: SudokuDifficulty = .easy
    @State private var savedGame: SudokuSavedGame?
    @State private var showingReplaceGameConfirmation = false
    @State private var pendingDifficulty: SudokuDifficulty?
    @State private var replacementDifficulty: SudokuDifficulty?

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 8) {
                Text("Sudoku")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Choose your difficulty")
                    .foregroundStyle(.secondary)
            }

            Picker(
                "Difficulty",
                selection: $selectedDifficulty
            ) {
                ForEach(SudokuDifficulty.allCases) { difficulty in
                    Text(difficulty.rawValue)
                        .tag(difficulty)
                }
            }
            .pickerStyle(.segmented)

            if let savedGame {
                NavigationLink {
                    SudokuView(
                        savedGame: savedGame
                    )
                } label: {
                    VStack(spacing: 4) {
                        Text("Resume Game")
                            .font(.headline)

                        Text(
                            "\(savedGame.difficulty.rawValue) - " +
                            formattedTime(savedGame.elapsedSeconds)
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

            Button {
                if savedGame != nil {
                    replacementDifficulty = selectedDifficulty
                    showingReplaceGameConfirmation = true
                } else {
                    pendingDifficulty = selectedDifficulty
                }
            } label: {
                Text("Start New Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.bordered)

            NavigationLink {
                SudokuStatisticsView()
            } label: {
                Label(
                    "Statistics",
                    systemImage: "chart.bar"
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sudoku")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            savedGame = SudokuGameStore.load()
        }
        .navigationDestination(
            item: $pendingDifficulty
        ) { difficulty in
            SudokuView(
                difficulty: difficulty
            )
        }
        .confirmationDialog(
            "Start a New Game?",
            isPresented: $showingReplaceGameConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                "Start New Game",
                role: .destructive
            ) {
                SudokuGameStore.clear()

                pendingDifficulty = replacementDifficulty ?? selectedDifficulty
                replacementDifficulty = nil
                savedGame = nil
            }

            Button(
                "Keep Current Game",
                role: .cancel
            ) {
                replacementDifficulty = nil
                pendingDifficulty = nil
            }
        } message: {
            Text(
                "Your unfinished Sudoku game will be deleted."
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
        SudokuStartView()
    }
}
