import Foundation

enum SudokuGameStore {
    private static let savedGameKey = "sudoku.savedGame"

    static func save(
        _ game: SudokuSavedGame
    ) {
        do {
            let data = try JSONEncoder().encode(game)

            UserDefaults.standard.set(
                data,
                forKey: savedGameKey
            )
        } catch {
            print(
                "Failed to save Sudoku game: \(error)"
            )
        }
    }

    static func load() -> SudokuSavedGame? {
        guard
            let data = UserDefaults.standard.data(
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

    static func clear() {
        UserDefaults.standard.removeObject(
            forKey: savedGameKey
        )
    }

    static var hasSavedGame: Bool {
        UserDefaults.standard.data(
            forKey: savedGameKey
        ) != nil
    }
}
