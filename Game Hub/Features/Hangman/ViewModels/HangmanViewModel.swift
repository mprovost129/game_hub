import Foundation
import Observation

@Observable
final class HangmanViewModel {
    var game: HangmanGame

    init(
        category: HangmanCategory = .everyday
    ) {
        let word = HangmanWordLibrary.randomWord(
            for: category
        )

        self.game = HangmanGame(
            word: word.uppercased(),
            category: category
        )
    }

    var letters: [Character] {
        Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }

    func guess(
        _ letter: Character
    ) {
        guard game.status == .playing else {
            return
        }

        game.guessedLetters.insert(
            Character(
                letter.uppercased()
            )
        )
    }

    func hasGuessed(
        _ letter: Character
    ) -> Bool {
        game.guessedLetters.contains(letter)
    }

    func startNewGame() {
        let word = HangmanWordLibrary.randomWord(
            for: game.category
        )

        game = HangmanGame(
            word: word,
            category: game.category
        )
    }
}
