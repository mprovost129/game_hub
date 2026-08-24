import Combine
import SwiftUI

struct SudokuView: View {
    @State private var viewModel = SudokuViewModel()
    @State private var timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Mistakes: \(viewModel.mistakeCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Label(
                    viewModel.formattedTime,
                    systemImage: "clock"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            ZStack {
                SudokuBoardView(
                    viewModel: viewModel
                )
                .opacity(viewModel.isPaused ? 0 : 1)

                if viewModel.isPaused {
                    VStack(spacing: 12) {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 44))

                        Text("Game Paused")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Tap Resume to continue.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                }
            }

            SudokuNumberPadView(
                isNotesMode: viewModel.isNotesMode,
                canUndo: viewModel.canUndo,
                isPaused: viewModel.isPaused,
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
                },
                onPauseToggle: {
                    viewModel.togglePause()
                }
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Sudoku")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { _ in
            viewModel.advanceTimer()
        }
    }
}

#Preview {
    NavigationStack {
        SudokuView()
    }
}
