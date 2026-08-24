import SwiftUI

struct SudokuView: View {
    @State private var viewModel = SudokuViewModel()

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Mistakes: \(viewModel.mistakeCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            SudokuBoardView(
                viewModel: viewModel
            )

            SudokuNumberPadView(
                isNotesMode: viewModel.isNotesMode,
                canUndo: viewModel.canUndo,
                onNumberSelected: { number in
                    viewModel.enterNumber(number)
                },
                onNotesToggle: {
                    viewModel.toggleNotesMode()
                },
                onUndo: {
                    viewModel.undo()
                },
                onErase: {
                    viewModel.clearSelectedCell()
                }
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Sudoku")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SudokuView()
    }
}
