import Foundation
import Observation

@Observable
final class WordGridViewModel {
    var game: WordGridGame

    var selectedCellIDs: [UUID] = []
    var submittedWords: [String] = []
    var score = 0

    var lastSubmissionResult:
        WordGridSubmissionResult?

    private let dictionary: any WordGridDictionary

    init(
        dictionary: any WordGridDictionary =
            WordGridBundledDictionary()
    ) {
        self.dictionary = dictionary
        self.game =
            WordGridBoardGenerator.randomPlayableGame(
                dictionary: dictionary
            )
    }

    init(
        game: WordGridGame,
        dictionary: any WordGridDictionary
    ) {
        self.game = game
        self.dictionary = dictionary
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

    func selectCellDuringDrag(
        _ cell: WordGridCell
    ) {
        // Ignore repeated drag updates over the current final tile.
        if selectedCellIDs.last == cell.id {
            return
        }

        // Dragging backward one tile removes the current final tile.
        if selectedCellIDs.count >= 2,
           selectedCellIDs[
                selectedCellIDs.count - 2
           ] == cell.id {
            selectedCellIDs.removeLast()
            return
        }

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
        let word = currentWord.uppercased()

        guard word.count >= 3 else {
            lastSubmissionResult = .tooShort
            clearSelection()
            return
        }

        guard dictionary.contains(word) else {
            lastSubmissionResult = .invalidWord
            clearSelection()
            return
        }

        guard !submittedWords.contains(word) else {
            lastSubmissionResult = .alreadyFound
            clearSelection()
            return
        }

        let points = scoreForWord(word)

        submittedWords.append(word)
        score += points

        lastSubmissionResult = .accepted(
            word: word,
            points: points
        )

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

    private func scoreForWord(
        _ word: String
    ) -> Int {
        switch word.count {
        case 0...2:
            return 0

        case 3...4:
            return 1

        case 5:
            return 2

        case 6:
            return 3

        case 7:
            return 5

        default:
            return 11
        }
    }
}
