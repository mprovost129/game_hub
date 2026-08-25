import Foundation
import Observation

@Observable
final class HangmanViewModel {
    var game: HangmanGame

    private let gameDefaults: UserDefaults
    private let statisticsDefaults: UserDefaults
    private var shouldPersistGame = true

    init(
        category: HangmanCategory = .everyday,
        gameDefaults: UserDefaults = .standard,
        statisticsDefaults: UserDefaults = .standard
    ) {
        self.gameDefaults = gameDefaults
        self.statisticsDefaults = statisticsDefaults

        let word = HangmanWordLibrary.randomWord(
            for: category
        )

        self.game = HangmanGame(
            word: word.uppercased(),
            category: category
        )
    }

    init(
        savedGame: HangmanSavedGame,
        gameDefaults: UserDefaults = .standard,
        statisticsDefaults: UserDefaults = .standard
    ) {
        self.gameDefaults = gameDefaults
        self.statisticsDefaults = statisticsDefaults
        self.game = savedGame.game
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

        if game.status == .playing {
            saveGame()
        } else {
            finishGame()
        }
    }

    func hasGuessed(
        _ letter: Character
    ) -> Bool {
        game.guessedLetters.contains(letter)
    }

    func startNewGame() {
        shouldPersistGame = true

        let word = HangmanWordLibrary.randomWord(
            for: game.category
        )

        game = HangmanGame(
            word: word,
            category: game.category
        )

        saveGame()
    }

    func saveCurrentGame() {
        saveGame()
    }

    func endGame() {
        shouldPersistGame = false

        HangmanGameStore.clear(
            defaults: gameDefaults
        )
    }

    private func saveGame() {
        guard shouldPersistGame else {
            return
        }

        guard game.status == .playing else {
            return
        }

        HangmanGameStore.save(
            HangmanSavedGame(
                game: game
            ),
            defaults: gameDefaults
        )
    }

    private func finishGame() {
        shouldPersistGame = false

        HangmanGameStore.clear(
            defaults: gameDefaults
        )

        recordCompletedGame()
    }

    private func recordCompletedGame() {
        var stats = HangmanStatisticsStore.load(
            defaults: statisticsDefaults
        )

        stats.gamesPlayed += 1
        stats.totalWrongGuesses += game.wrongGuessCount

        switch game.status {
        case .won:
            stats.gamesWon += 1

        case .lost:
            stats.gamesLost += 1

        case .playing:
            break
        }

        HangmanStatisticsStore.save(
            stats,
            defaults: statisticsDefaults
        )
    }
}
