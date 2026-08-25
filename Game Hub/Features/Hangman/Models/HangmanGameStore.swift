import Foundation

enum HangmanGameStore {
    private static let savedGameKey = "hangman.savedGame"

    static func save(
        _ game: HangmanSavedGame,
        defaults: UserDefaults = .standard
    ) {
        guard let data = try? JSONEncoder().encode(game) else {
            return
        }

        defaults.set(
            data,
            forKey: savedGameKey
        )
    }

    static func load(
        defaults: UserDefaults = .standard
    ) -> HangmanSavedGame? {
        guard
            let data = defaults.data(
                forKey: savedGameKey
            )
        else {
            return nil
        }

        return try? JSONDecoder().decode(
            HangmanSavedGame.self,
            from: data
        )
    }

    static func clear(
        defaults: UserDefaults = .standard
    ) {
        defaults.removeObject(
            forKey: savedGameKey
        )
    }
}
