import SwiftUI

struct SudokuStartView: View {
    @State private var selectedDifficulty: SudokuDifficulty = .easy
    @State private var savedGame: SudokuSavedGame?

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

            NavigationLink {
                SudokuView(
                    difficulty: selectedDifficulty
                )
            } label: {
                Text("Start Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Sudoku")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            savedGame = SudokuGameStore.load()
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
