import SwiftUI

struct HangmanCompletionView: View {
    let didWin: Bool
    let word: String
    let wrongGuesses: Int

    let onNewGame: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(
                systemName:
                    didWin
                    ? "checkmark.circle.fill"
                    : "xmark.circle.fill"
            )
            .font(.system(size: 64))
            .foregroundStyle(
                didWin ? Color.green : Color.red
            )

            VStack(spacing: 8) {
                Text(
                    didWin
                    ? "You Got It!"
                    : "Game Over"
                )
                .font(.largeTitle)
                .fontWeight(.bold)

                Text(word)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(
                    "Wrong guesses: \(wrongGuesses)"
                )
                .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                Button {
                    onNewGame()
                } label: {
                    Text("New Game")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    onDone()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(32)
    }
}
