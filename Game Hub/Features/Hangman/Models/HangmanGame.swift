import Foundation

enum HangmanGameStatus: Equatable, Codable {
    case playing
    case won
    case lost
}

struct HangmanGame: Codable {
    let word: String
    let category: HangmanCategory

    var guessedLetters: Set<Character> = []

    var maximumWrongGuesses: Int {
        6
    }

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

    init(
        word: String,
        category: HangmanCategory,
        guessedLetters: Set<Character> = []
    ) {
        self.word = word
        self.category = category
        self.guessedLetters = guessedLetters
    }

    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        word = try container.decode(
            String.self,
            forKey: .word
        )

        category = try container.decode(
            HangmanCategory.self,
            forKey: .category
        )

        let guessedLetterStrings = try container.decode(
            [String].self,
            forKey: .guessedLetters
        )

        guessedLetters = Set(
            guessedLetterStrings.compactMap {
                $0.uppercased().first
            }
        )
    }

    func encode(
        to encoder: Encoder
    ) throws {
        var container = encoder.container(
            keyedBy: CodingKeys.self
        )

        try container.encode(
            word,
            forKey: .word
        )

        try container.encode(
            category,
            forKey: .category
        )

        try container.encode(
            guessedLetters.map(String.init).sorted(),
            forKey: .guessedLetters
        )
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

    private enum CodingKeys: String, CodingKey {
        case word
        case category
        case guessedLetters
    }
}
