import Foundation
import Testing
@testable import game_hub

struct HangmanTests {
    @Test func savedGameRoundTripsCurrentGame() throws {
        let defaults = makeDefaults()
        defer { clear(defaults) }

        let game = HangmanGame(
            word: "APPLE",
            category: .food,
            guessedLetters: Set<Character>(["A", "P"])
        )

        HangmanGameStore.save(
            HangmanSavedGame(game: game),
            defaults: defaults
        )

        let savedGame = try #require(
            HangmanGameStore.load(defaults: defaults)
        )

        #expect(savedGame.game.normalizedWord == "APPLE")
        #expect(savedGame.game.category == .food)
        #expect(savedGame.game.guessedLetters == Set<Character>(["A", "P"]))
    }

    @Test func abandonedGameSavesButDoesNotRecordStatistics() {
        let gameDefaults = makeDefaults()
        let statisticsDefaults = makeDefaults()
        defer {
            clear(gameDefaults)
            clear(statisticsDefaults)
        }

        let viewModel = HangmanViewModel(
            savedGame: HangmanSavedGame(
                game: HangmanGame(
                    word: "APPLE",
                    category: .food
                )
            ),
            gameDefaults: gameDefaults,
            statisticsDefaults: statisticsDefaults
        )

        viewModel.guess("A")

        #expect(HangmanGameStore.load(defaults: gameDefaults) != nil)

        let statistics = HangmanStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesPlayed == 0)
        #expect(statistics.gamesWon == 0)
        #expect(statistics.gamesLost == 0)
    }

    @Test func winningClearsSavedGameAndRecordsStatisticsOnce() {
        let gameDefaults = makeDefaults()
        let statisticsDefaults = makeDefaults()
        defer {
            clear(gameDefaults)
            clear(statisticsDefaults)
        }

        let viewModel = HangmanViewModel(
            savedGame: HangmanSavedGame(
                game: HangmanGame(
                    word: "APPLE",
                    category: .food
                )
            ),
            gameDefaults: gameDefaults,
            statisticsDefaults: statisticsDefaults
        )

        for letter in Array("APLE") {
            viewModel.guess(letter)
        }

        viewModel.guess("Z")
        viewModel.saveCurrentGame()

        #expect(viewModel.game.status == .won)
        #expect(HangmanGameStore.load(defaults: gameDefaults) == nil)

        let statistics = HangmanStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesPlayed == 1)
        #expect(statistics.gamesWon == 1)
        #expect(statistics.gamesLost == 0)
        #expect(statistics.totalWrongGuesses == 0)
    }

    @Test func losingClearsSavedGameAndRecordsWrongGuesses() {
        let gameDefaults = makeDefaults()
        let statisticsDefaults = makeDefaults()
        defer {
            clear(gameDefaults)
            clear(statisticsDefaults)
        }

        let viewModel = HangmanViewModel(
            savedGame: HangmanSavedGame(
                game: HangmanGame(
                    word: "APPLE",
                    category: .food
                )
            ),
            gameDefaults: gameDefaults,
            statisticsDefaults: statisticsDefaults
        )

        for letter in Array("BCDFGH") {
            viewModel.guess(letter)
        }

        #expect(viewModel.game.status == .lost)
        #expect(HangmanGameStore.load(defaults: gameDefaults) == nil)

        let statistics = HangmanStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesPlayed == 1)
        #expect(statistics.gamesWon == 0)
        #expect(statistics.gamesLost == 1)
        #expect(statistics.totalWrongGuesses == 6)
    }

    @Test func endGameClearsSavedGameWithoutRecordingStatistics() {
        let gameDefaults = makeDefaults()
        let statisticsDefaults = makeDefaults()
        defer {
            clear(gameDefaults)
            clear(statisticsDefaults)
        }

        let viewModel = HangmanViewModel(
            savedGame: HangmanSavedGame(
                game: HangmanGame(
                    word: "APPLE",
                    category: .food
                )
            ),
            gameDefaults: gameDefaults,
            statisticsDefaults: statisticsDefaults
        )

        viewModel.saveCurrentGame()
        viewModel.endGame()

        #expect(HangmanGameStore.load(defaults: gameDefaults) == nil)

        let statistics = HangmanStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesPlayed == 0)
        #expect(statistics.gamesWon == 0)
        #expect(statistics.gamesLost == 0)
    }

    @Test func newGameKeepsCategoryAndSavesFreshGame() throws {
        let gameDefaults = makeDefaults()
        let statisticsDefaults = makeDefaults()
        defer {
            clear(gameDefaults)
            clear(statisticsDefaults)
        }

        let viewModel = HangmanViewModel(
            savedGame: HangmanSavedGame(
                game: HangmanGame(
                    word: "APPLE",
                    category: .food
                )
            ),
            gameDefaults: gameDefaults,
            statisticsDefaults: statisticsDefaults
        )

        for letter in Array("APLE") {
            viewModel.guess(letter)
        }

        viewModel.startNewGame()

        let savedGame = try #require(
            HangmanGameStore.load(defaults: gameDefaults)
        )

        #expect(viewModel.game.status == .playing)
        #expect(viewModel.game.category == .food)
        #expect(viewModel.game.guessedLetters.isEmpty)
        #expect(savedGame.game.category == .food)
        #expect(savedGame.game.guessedLetters.isEmpty)
        #expect(
            HangmanWordLibrary.words(for: .food).contains(
                viewModel.game.normalizedWord
            )
        )
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "game-hub.hangman.tests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        return defaults
    }

    private func clear(
        _ defaults: UserDefaults
    ) {
        if let suiteName = defaults.volatileDomainNames.first(
            where: { $0.hasPrefix("game-hub.hangman.tests") }
        ) {
            defaults.removeVolatileDomain(forName: suiteName)
        }
    }
}
