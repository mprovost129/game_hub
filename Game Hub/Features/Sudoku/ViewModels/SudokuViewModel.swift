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

    func isPeerOfSelectedCell(_ cell: SudokuCell) -> Bool {
        guard let selectedCell else {
            return false
        }

        let sameRow = cell.row == selectedCell.row
        let sameColumn = cell.column == selectedCell.column

        let sameBox =
            cell.row / 3 == selectedCell.row / 3 &&
            cell.column / 3 == selectedCell.column / 3

        return sameRow || sameColumn || sameBox
    }

    func hasSameValueAsSelectedCell(_ cell: SudokuCell) -> Bool {
        guard
            let selectedValue = selectedCell?.value,
            let cellValue = cell.value
        else {
            return false
        }

        return selectedValue == cellValue
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
