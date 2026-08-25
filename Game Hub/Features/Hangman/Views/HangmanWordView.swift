import SwiftUI

struct HangmanWordView: View {
    let word: String
    let guessedLetters: Set<Character>

    var body: some View {
        HStack(spacing: 8) {
            ForEach(
                Array(word.enumerated()),
                id: \.offset
            ) { _, letter in
                VStack(spacing: 4) {
                    Text(
                        guessedLetters.contains(letter)
                        ? String(letter)
                        : " "
                    )
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 30, height: 36)

                    Rectangle()
                        .frame(
                            width: 30,
                            height: 2
                        )
                }
            }
        }
    }
}

#Preview {
    HangmanWordView(
        word: "APPLE",
        guessedLetters: ["A", "P"]
    )
    .padding()
}
