import Foundation
import Observation

@Observable
final class WordGridViewModel {
    var game: WordGridGame

    var selectedCellIDs: [UUID] = []
    var submittedWords: [String] = []

    init(
        game: WordGridGame = WordGridBoardLibrary.testBoard
    ) {
        self.game = game
    }

    var selectedCells: [WordGridCell] {
        selectedCellIDs.compactMap { id in
            game.cells.first {
                $0.id == id
            }
        }
    }

    var currentWord: String {
        String(
            selectedCells.map(\.letter)
        )
    }

    func isSelected(
        _ cell: WordGridCell
    ) -> Bool {
        selectedCellIDs.contains(cell.id)
    }

    func selectCell(
        _ cell: WordGridCell
    ) {
        guard !isSelected(cell) else {
            return
        }

        guard canSelect(cell) else {
            return
        }

        selectedCellIDs.append(cell.id)
    }

    func clearSelection() {
        selectedCellIDs.removeAll()
    }

    func submitCurrentWord() {
        guard !currentWord.isEmpty else {
            return
        }

        submittedWords.append(currentWord)
        clearSelection()
    }

    private func canSelect(
        _ cell: WordGridCell
    ) -> Bool {
        guard let lastCell = selectedCells.last else {
            return true
        }

        let rowDistance = abs(
            cell.row - lastCell.row
        )

        let columnDistance = abs(
            cell.column - lastCell.column
        )

        return rowDistance <= 1 &&
            columnDistance <= 1 &&
            !(rowDistance == 0 && columnDistance == 0)
    }
}
