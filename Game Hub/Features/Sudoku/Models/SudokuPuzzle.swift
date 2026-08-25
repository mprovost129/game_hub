import Foundation

struct SudokuPuzzle: Codable {
    var cells: [SudokuCell]

    init(
        puzzle: [Int],
        solution: [Int]
    ) {
        precondition(puzzle.count == 81)
        precondition(solution.count == 81)

        var cells: [SudokuCell] = []

        for index in 0..<81 {
            let puzzleValue = puzzle[index]

            cells.append(
                SudokuCell(
                    row: index / 9,
                    column: index % 9,
                    solution: solution[index],
                    value: puzzleValue == 0 ? nil : puzzleValue,
                    isGiven: puzzleValue != 0
                )
            )
        }

        self.cells = cells
    }
}
