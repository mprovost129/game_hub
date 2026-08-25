import SwiftUI

struct HangmanView: View {
    @State private var viewModel =
        HangmanViewModel()

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Guess the Word")
                .font(.title2)
                .fontWeight(.bold)

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

            gameStatusMessage

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
    }

    @ViewBuilder
    private var gameStatusMessage: some View {
        switch viewModel.game.status {
        case .playing:
            EmptyView()

        case .won:
            VStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.green)

                Text("You got it!")
                    .font(.headline)
            }

        case .lost:
            VStack(spacing: 6) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.red)

                Text("Game Over")
                    .font(.headline)

                Text(
                    "The word was \(viewModel.game.normalizedWord)."
                )
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HangmanView()
    }
}
