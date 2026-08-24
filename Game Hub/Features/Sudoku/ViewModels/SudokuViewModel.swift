import Foundation
import Observation

@Observable
final class SudokuViewModel {
    var puzzle: SudokuPuzzle
    var selectedCellID: UUID?

    init(puzzle: SudokuPuzzle = .testPuzzle) {
        self.puzzle = puzzle
    }

    var selectedCell: SudokuCell? {
        guard let selectedCellID else {
            return nil
        }

        return puzzle.cells.first {
            $0.id == selectedCellID
        }
    }

    func selectCell(_ cell: SudokuCell) {
        selectedCellID = cell.id
    }

    func isSelected(_ cell: SudokuCell) -> Bool {
        selectedCellID == cell.id
    }

    func enterNumber(_ number: Int) {
        guard
            let selectedCellID,
            let index = puzzle.cells.firstIndex(
                where: { $0.id == selectedCellID }
            )
        else {
            return
        }

        guard !puzzle.cells[index].isGiven else {
            return
        }

        puzzle.cells[index].value = number
    }

    func clearSelectedCell() {
        guard
            let selectedCellID,
            let index = puzzle.cells.firstIndex(
                where: { $0.id == selectedCellID }
            )
        else {
            return
        }

        guard !puzzle.cells[index].isGiven else {
            return
        }

        puzzle.cells[index].value = nil
    }
}
