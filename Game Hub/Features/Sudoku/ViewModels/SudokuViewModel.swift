import Foundation
import Observation

@Observable
final class SudokuViewModel {
    var puzzle: SudokuPuzzle
    var selectedCellID: UUID?
    var mistakeCount = 0
    var isNotesMode = false

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

    func isIncorrect(_ cell: SudokuCell) -> Bool {
        guard
            !cell.isGiven,
            let value = cell.value
        else {
            return false
        }

        return value != cell.solution
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

        if isNotesMode {
            toggleNote(number, at: index)
            return
        }

        let previousValue = puzzle.cells[index].value

        // Don't count the exact same wrong entry repeatedly.
        if previousValue != number &&
            number != puzzle.cells[index].solution {
            mistakeCount += 1
        }

        puzzle.cells[index].value = number

        // Once a final value is entered, notes are no longer needed.
        puzzle.cells[index].notes.removeAll()
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

        if puzzle.cells[index].value != nil {
            puzzle.cells[index].value = nil
        } else {
            puzzle.cells[index].notes.removeAll()
        }
    }

    func toggleNotesMode() {
        isNotesMode.toggle()
    }

    private func toggleNote(_ number: Int, at index: Int) {
        guard puzzle.cells[index].value == nil else {
            return
        }

        if puzzle.cells[index].notes.contains(number) {
            puzzle.cells[index].notes.remove(number)
        } else {
            puzzle.cells[index].notes.insert(number)
        }
    }
}
