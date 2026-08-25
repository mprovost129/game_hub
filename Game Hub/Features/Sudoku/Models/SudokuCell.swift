import Foundation

struct SudokuCell: Identifiable, Equatable, Codable {
    let id: UUID

    let row: Int
    let column: Int
    let solution: Int

    var value: Int?
    var notes: Set<Int>

    let isGiven: Bool

    init(
        id: UUID = UUID(),
        row: Int,
        column: Int,
        solution: Int,
        value: Int?,
        notes: Set<Int> = [],
        isGiven: Bool
    ) {
        self.id = id
        self.row = row
        self.column = column
        self.solution = solution
        self.value = value
        self.notes = notes
        self.isGiven = isGiven
    }
}
