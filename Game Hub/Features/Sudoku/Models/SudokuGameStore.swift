import Foundation

enum SudokuGameStore {
    private static let savedGameKey = "sudoku.savedGame"

    static func save(
        _ game: SudokuSavedGame,
        defaults: UserDefaults = .standard
    ) {
        do {
            let data = try JSONEncoder().encode(game)

            defaults.set(
                data,
                forKey: savedGameKey
            )
        } catch {
            print(
                "Failed to save Sudoku game: \(error)"
            )
        }
    }

    static func load(
        defaults: UserDefaults = .standard
    ) -> SudokuSavedGame? {
        guard
            let data = defaults.data(
                forKey: savedGameKey
            )
        else {
            return nil
        }

        do {
            return try JSONDecoder().decode(
                SudokuSavedGame.self,
                from: data
            )
        } catch {
            print(
                "Failed to load Sudoku game: \(error)"
            )

            return nil
        }
    }

    static func clear(
        defaults: UserDefaults = .standard
    ) {
        defaults.removeObject(
            forKey: savedGameKey
        )
    }

    static func hasSavedGame(
        defaults: UserDefaults = .standard
    ) -> Bool {
        defaults.data(
            forKey: savedGameKey
        ) != nil
    }
}
