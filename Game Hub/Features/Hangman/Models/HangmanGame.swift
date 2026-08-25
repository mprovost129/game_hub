import Foundation

struct HangmanGame {
    let word: String
    var guessedLetters: Set<Character> = []

    var normalizedWord: String {
        word.uppercased()
    }

    func isLetterRevealed(
        _ letter: Character
    ) -> Bool {
        guessedLetters.contains(
            Character(
                letter.uppercased()
            )
        )
    }
}
