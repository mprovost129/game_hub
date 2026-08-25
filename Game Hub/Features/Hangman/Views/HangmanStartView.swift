import SwiftUI

struct HangmanStartView: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(
                systemName: "character.textbox"
            )
            .font(.system(size: 56))
            .foregroundStyle(
                Color.accentColor
            )

            VStack(spacing: 8) {
                Text("Hangman")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Guess the word one letter at a time."
                )
                .foregroundStyle(.secondary)
            }

            NavigationLink {
                HangmanView()
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
        .navigationTitle("Hangman")
        .navigationBarTitleDisplayMode(.inline)
    }
}
