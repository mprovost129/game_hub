import Foundation

enum SudokuStatisticsStore {
    private static let statisticsKey = "sudoku.statistics"

    static func load() -> SudokuStatistics {
        guard
            let data = UserDefaults.standard.data(
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
        _ statistics: SudokuStatistics
    ) {
        guard let data = try? JSONEncoder().encode(
            statistics
        ) else {
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: statisticsKey
        )
    }
}
