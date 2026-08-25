import SwiftUI

struct HangmanView: View {
    @State private var viewModel =
        HangmanViewModel()

    var body: some View {
        VStack(spacing: 36) {
            Spacer()

            Text("Guess the Word")
                .font(.title2)
                .fontWeight(.bold)

            HangmanWordView(
                word: viewModel.game.normalizedWord,
                guessedLetters:
                    viewModel.game.guessedLetters
            )

            Spacer()

            HangmanKeyboardView(
                letters: viewModel.letters,
                guessedLetters:
                    viewModel.game.guessedLetters
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
}

#Preview {
    NavigationStack {
        HangmanView()
    }
}
