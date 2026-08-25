import Foundation

struct SudokuStatistics: Codable, Equatable {
    var gamesCompleted = 0

    var easyCompleted = 0
    var mediumCompleted = 0
    var hardCompleted = 0

    var totalMistakes = 0
    var totalHints = 0

    var bestEasyTime: Int?
    var bestMediumTime: Int?
    var bestHardTime: Int?
}
