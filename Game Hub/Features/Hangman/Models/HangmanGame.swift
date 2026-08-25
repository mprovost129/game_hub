import Foundation

enum HangmanGameStatus: Equatable {
    case playing
    case won
    case lost
}

struct HangmanGame {
    let word: String
    var guessedLetters: Set<Character> = []

    let maximumWrongGuesses = 6

    var normalizedWord: String {
        word.uppercased()
    }

    var correctLetters: Set<Character> {
        Set(normalizedWord)
    }

    var wrongGuesses: Set<Character> {
        guessedLetters.subtracting(correctLetters)
    }

    var wrongGuessCount: Int {
        wrongGuesses.count
    }

    var remainingGuesses: Int {
        max(
            maximumWrongGuesses - wrongGuessCount,
            0
        )
    }

    var status: HangmanGameStatus {
        if correctLetters.isSubset(
            of: guessedLetters
        ) {
            return .won
        }

        if wrongGuessCount >= maximumWrongGuesses {
            return .lost
        }

        return .playing
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
