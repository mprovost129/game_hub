import Foundation

struct SudokuCell: Identifiable, Equatable {
    let id = UUID()

    let row: Int
    let column: Int
    let solution: Int

    var value: Int?
    var notes: Set<Int> = []

    let isGiven: Bool
}
