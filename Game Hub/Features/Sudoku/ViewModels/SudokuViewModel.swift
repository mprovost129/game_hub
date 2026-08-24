import Foundation
import Observation

private struct SudokuSnapshot {
    let cells: [SudokuCell]
    let mistakeCount: Int
    let selectedCellID: UUID?
}

@Observable
final class SudokuViewModel {
    var puzzle: SudokuPuzzle
    var selectedCellID: UUID?
    var mistakeCount = 0
    var isNotesMode = false
    var elapsedSeconds = 0
    var isPaused = false

    private var undoStack: [SudokuSnapshot] = []

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

    var canUndo: Bool {
        !undoStack.isEmpty
    }

    var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    func selectCell(_ cell: SudokuCell) {
        guard !isPaused else {
            return
        }

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
        guard !isPaused else {
            return
        }

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
            guard puzzle.cells[index].value == nil else {
                return
            }

            saveUndoSnapshot()
            toggleNote(number, at: index)
            return
        }

        let previousValue = puzzle.cells[index].value

        guard previousValue != number else {
            return
        }

        saveUndoSnapshot()

        if number != puzzle.cells[index].solution {
            mistakeCount += 1
        }

        puzzle.cells[index].value = number
        puzzle.cells[index].notes.removeAll()
    }

    func clearSelectedCell() {
        guard !isPaused else {
            return
        }

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

        let hasValue = puzzle.cells[index].value != nil
        let hasNotes = !puzzle.cells[index].notes.isEmpty

        guard hasValue || hasNotes else {
            return
        }

        saveUndoSnapshot()

        if hasValue {
            puzzle.cells[index].value = nil
        } else {
            puzzle.cells[index].notes.removeAll()
        }
    }

    func toggleNotesMode() {
        guard !isPaused else {
            return
        }

        isNotesMode.toggle()
    }

    func undo() {
        guard !isPaused else {
            return
        }

        guard let snapshot = undoStack.popLast() else {
            return
        }

        puzzle.cells = snapshot.cells
        mistakeCount = snapshot.mistakeCount
        selectedCellID = snapshot.selectedCellID
    }

    func advanceTimer() {
        guard !isPaused else {
            return
        }

        elapsedSeconds += 1
    }

    func togglePause() {
        isPaused.toggle()
    }

    private func saveUndoSnapshot() {
        undoStack.append(
            SudokuSnapshot(
                cells: puzzle.cells,
                mistakeCount: mistakeCount,
                selectedCellID: selectedCellID
            )
        )
    }

    private func toggleNote(_ number: Int, at index: Int) {
        if puzzle.cells[index].notes.contains(number) {
            puzzle.cells[index].notes.remove(number)
        } else {
            puzzle.cells[index].notes.insert(number)
        }
    }
}
