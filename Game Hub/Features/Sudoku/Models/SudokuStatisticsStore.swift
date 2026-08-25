import Foundation

enum SudokuStatisticsStore {
    private static let statisticsKey = "sudoku.statistics"

    static func load(
        defaults: UserDefaults = .standard
    ) -> SudokuStatistics {
        guard
            let data = defaults.data(
                forKey: statisticsKey
            ),
            let statistics = try? JSONDecoder().decode(
                SudokuStatistics.self,
                from: data
            )
        else {
            return SudokuStatistics()
        }

        return statistics
    }

    static func save(
        _ statistics: SudokuStatistics,
        defaults: UserDefaults = .standard
    ) {
        guard let data = try? JSONEncoder().encode(
            statistics
        ) else {
            return
        }

        defaults.set(
            data,
            forKey: statisticsKey
        )
    }
}
