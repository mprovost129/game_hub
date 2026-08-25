import SwiftUI

struct HangmanView: View {
    let category: HangmanCategory

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: HangmanViewModel
    @State private var showingEndGameConfirmation = false

    init(
        category: HangmanCategory
    ) {
        self.category = category

        _viewModel = State(
            initialValue: HangmanViewModel(
                category: category
            )
        )
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 4) {
                Text("Guess the Word")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.game.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HangmanFigureView(
                wrongGuessCount:
                    viewModel.game.wrongGuessCount,
                maximumWrongGuesses:
                    viewModel.game.maximumWrongGuesses
            )

            Text(
                "\(viewModel.game.remainingGuesses) guesses remaining"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HangmanWordView(
                word: viewModel.game.normalizedWord,
                guessedLetters:
                    viewModel.game.guessedLetters
            )

            Spacer()

            HangmanKeyboardView(
                letters: viewModel.letters,
                guessedLetters:
                    viewModel.game.guessedLetters,
                word: viewModel.game.normalizedWord
            ) { letter in
                viewModel.guess(letter)
            }

            Spacer()
                .frame(height: 30)
        }
        .padding()
        .navigationTitle("Hangman")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Menu {
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
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(
            isPresented: Binding(
                get: {
                    viewModel.game.status != .playing
                },
                set: { _ in }
            )
        ) {
            HangmanCompletionView(
                didWin: viewModel.game.status == .won,
                word: viewModel.game.normalizedWord,
                wrongGuesses: viewModel.game.wrongGuessCount,
                onNewGame: {
                    viewModel.startNewGame()
                },
                onDone: {
                    dismiss()
                }
            )
            .interactiveDismissDisabled()
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
                dismiss()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {
            }
        } message: {
            Text(
                "Your current Hangman game will be lost."
            )
        }
    }
}

#Preview {
    NavigationStack {
        HangmanView(
            category: .animals
        )
    }
}
