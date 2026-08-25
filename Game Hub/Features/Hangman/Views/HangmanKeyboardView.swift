import SwiftUI

struct HangmanKeyboardView: View {
    let letters: [Character]
    let guessedLetters: Set<Character>
    let onLetterSelected: (Character) -> Void

    private let columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 8
        ),
        count: 7
    )

    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 8
        ) {
            ForEach(
                letters,
                id: \.self
            ) { letter in
                Button {
                    onLetterSelected(letter)
                } label: {
                    Text(String(letter))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                }
                .buttonStyle(.bordered)
                .disabled(
                    guessedLetters.contains(letter)
                )
            }
        }
    }
}
