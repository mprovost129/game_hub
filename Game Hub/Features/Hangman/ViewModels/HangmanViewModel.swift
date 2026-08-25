import Foundation
import Observation

@Observable
final class HangmanViewModel {
    var game: HangmanGame

    init(
        word: String = "APPLE"
    ) {
        self.game = HangmanGame(
            word: word.uppercased()
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
}
