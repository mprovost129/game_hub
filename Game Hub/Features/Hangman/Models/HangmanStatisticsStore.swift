import Foundation

enum HangmanStatisticsStore {
    private static let key = "hangman.statistics"

    static func load(
        defaults: UserDefaults = .standard
    ) -> HangmanStatistics {
        guard
            let data = defaults.data(
                forKey: key
            ),
            let stats = try? JSONDecoder().decode(
                HangmanStatistics.self,
                from: data
            )
        else {
            return HangmanStatistics()
        }

        return stats
    }

    static func save(
        _ statistics: HangmanStatistics,
        defaults: UserDefaults = .standard
    ) {
        guard
            let data = try? JSONEncoder().encode(
                statistics
            )
        else {
            return
        }

        defaults.set(
            data,
            forKey: key
        )
    }
}
