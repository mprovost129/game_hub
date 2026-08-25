import Combine
import SwiftUI

struct SudokuView: View {
    let difficulty: SudokuDifficulty

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: SudokuViewModel
    @State private var showingNewGameConfirmation = false
    @State private var showingEndGameConfirmation = false
    @State private var timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    init(
        difficulty: SudokuDifficulty
    ) {
        self.difficulty = difficulty

        _viewModel = State(
            initialValue: SudokuViewModel(
                difficulty: difficulty
            )
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.difficulty.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        Text("Mistakes: \(viewModel.mistakeCount)")
                        Text("Hints: \(viewModel.hintCount)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

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
                onHint: {
                    viewModel.useHint()
                },
                onPauseToggle: {
                    viewModel.togglePause()
                }
            )

            #if DEBUG
            Button("Solve Puzzle") {
                viewModel.solvePuzzleForTesting()
            }
            .font(.caption)
            #endif

            Spacer()
        }
        .padding()
        .navigationTitle("Sudoku")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Menu {
                    Button {
                        showingNewGameConfirmation = true
                    } label: {
                        Label(
                            "New Game",
                            systemImage: "arrow.clockwise"
                        )
                    }

                    Button(
                        role: .destructive
                    ) {
                        showingEndGameConfirmation = true
                    } label: {
                        Label(
                            "End Game",
                            systemImage: "xmark.circle"
                        )
                    }
                } label: {
                    Image(
                        systemName: "ellipsis.circle"
                    )
                }
            }
        }
        .onReceive(timer) { _ in
            viewModel.advanceTimer()
        }
        .confirmationDialog(
            "Start a New Game?",
            isPresented: $showingNewGameConfirmation,
            titleVisibility: .visible
        ) {
            Button("Start New Game") {
                viewModel.startNewGame()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {
            }
        } message: {
            Text(
                "Your progress in the current puzzle will be lost."
            )
        }
        .confirmationDialog(
            "End Current Game?",
            isPresented: $showingEndGameConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                "End Game",
                role: .destructive
            ) {
                viewModel.endGame()
                dismiss()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {
            }
        } message: {
            Text(
                "Your progress in the current puzzle will be lost."
            )
        }
        .sheet(isPresented: $viewModel.isCompleted) {
            SudokuCompletionView(
                time: viewModel.formattedTime,
                mistakes: viewModel.mistakeCount,
                onNewGame: {
                    viewModel.isCompleted = false
                    viewModel.startNewGame()
                },
                onDone: {
                    viewModel.isCompleted = false
                    dismiss()
                }
            )
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    NavigationStack {
        SudokuView(
            difficulty: .easy
        )
    }
}
