import SwiftUI

struct SudokuStartView: View {
    @State private var selectedDifficulty: SudokuDifficulty = .easy

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
    }
}

#Preview {
    NavigationStack {
        SudokuStartView()
    }
}
