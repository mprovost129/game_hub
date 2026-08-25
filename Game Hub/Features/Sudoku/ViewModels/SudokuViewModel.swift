import Foundation
import Observation

private struct SudokuSnapshot {
    let cells: [SudokuCell]
    let mistakeCount: Int
    let hintCount: Int
    let selectedCellID: UUID?
}

@Observable
final class SudokuViewModel {
    let difficulty: SudokuDifficulty
    var puzzle: SudokuPuzzle
    var selectedCellID: UUID?
    var mistakeCount = 0
    var hintCount = 0
    var isNotesMode = false
    var elapsedSeconds = 0
    var isPaused = false
    var isCompleted = false

    private var undoStack: [SudokuSnapshot] = []
    private let gameDefaults: UserDefaults
    private let statisticsDefaults: UserDefaults
    private var shouldPersistGame = true

    init(
        difficulty: SudokuDifficulty = .easy,
        gameDefaults: UserDefaults = .standard,
        statisticsDefaults: UserDefaults = .standard
    ) {
        self.difficulty = difficulty
        self.gameDefaults = gameDefaults
        self.statisticsDefaults = statisticsDefaults
        self.puzzle = SudokuPuzzleLibrary.randomPuzzle(
            for: difficulty
        )
    }

    init(
        savedGame: SudokuSavedGame,
        gameDefaults: UserDefaults = .standard,
        statisticsDefaults: UserDefaults = .standard
    ) {
        self.difficulty = savedGame.difficulty
        self.gameDefaults = gameDefaults
        self.statisticsDefaults = statisticsDefaults
        self.puzzle = savedGame.puzzle
        self.mistakeCount = savedGame.mistakeCount
        self.hintCount = savedGame.hintCount
        self.elapsedSeconds = savedGame.elapsedSeconds
        self.selectedCellID = savedGame.selectedCellID
        self.isNotesMode = savedGame.isNotesMode
        self.isPaused = false
        self.isCompleted = false
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
        guard !isPaused, !isCompleted else {
            return
        }

        selectedCellID = cell.id
        saveGame()
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
        guard !isPaused, !isCompleted else {
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
            saveGame()
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
        checkForCompletion()
        saveGame()
    }

    func clearSelectedCell() {
        guard !isPaused, !isCompleted else {
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

        saveGame()
    }

    func toggleNotesMode() {
        guard !isPaused, !isCompleted else {
            return
        }

        isNotesMode.toggle()
        saveGame()
    }

    func undo() {
        guard !isPaused, !isCompleted else {
            return
        }

        guard let snapshot = undoStack.popLast() else {
            return
        }

        puzzle.cells = snapshot.cells
        mistakeCount = snapshot.mistakeCount
        hintCount = snapshot.hintCount
        selectedCellID = snapshot.selectedCellID
        saveGame()
    }

    func advanceTimer() {
        guard !isPaused, !isCompleted else {
            return
        }

        elapsedSeconds += 1
    }

    func togglePause() {
        guard !isCompleted else {
            return
        }

        isPaused.toggle()
        saveGame()
    }

    func solvePuzzleForTesting() {
        guard !isCompleted else {
            return
        }

        for index in puzzle.cells.indices {
            puzzle.cells[index].value = puzzle.cells[index].solution
            puzzle.cells[index].notes.removeAll()
        }

        checkForCompletion(
            recordStatistics: false
        )
    }

    func useHint() {
        guard !isPaused, !isCompleted else {
            return
        }

        let candidates = puzzle.cells.indices.filter { index in
            !puzzle.cells[index].isGiven &&
            puzzle.cells[index].value != puzzle.cells[index].solution
        }

        guard let index = candidates.randomElement() else {
            return
        }

        saveUndoSnapshot()

        puzzle.cells[index].value = puzzle.cells[index].solution
        puzzle.cells[index].notes.removeAll()
        selectedCellID = puzzle.cells[index].id
        hintCount += 1

        checkForCompletion()
        saveGame()
    }

    func startNewGame() {
        shouldPersistGame = true

        SudokuGameStore.clear(
            defaults: gameDefaults
        )

        puzzle = SudokuPuzzleLibrary.randomPuzzle(
            for: difficulty
        )

        selectedCellID = nil
        mistakeCount = 0
        hintCount = 0
        elapsedSeconds = 0
        isPaused = false
        isCompleted = false
        isNotesMode = false
        undoStack.removeAll()

        saveGame()
    }

    func endGame() {
        shouldPersistGame = false

        SudokuGameStore.clear(
            defaults: gameDefaults
        )
        isPaused = false
    }

    func saveCurrentGame() {
        saveGame()
    }

    private func saveUndoSnapshot() {
        undoStack.append(
            SudokuSnapshot(
                cells: puzzle.cells,
                mistakeCount: mistakeCount,
                hintCount: hintCount,
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

    private func checkForCompletion(
        recordStatistics: Bool = true
    ) {
        guard !isCompleted else {
            return
        }

        let solved = puzzle.cells.allSatisfy { cell in
            cell.value == cell.solution
        }

        if solved {
            shouldPersistGame = false
            isCompleted = true
            isPaused = false

            SudokuGameStore.clear(
                defaults: gameDefaults
            )

            if recordStatistics {
                recordCompletedGame()
            }
        }
    }

    private func recordCompletedGame() {
        var statistics = SudokuStatisticsStore.load(
            defaults: statisticsDefaults
        )

        statistics.gamesCompleted += 1
        statistics.totalMistakes += mistakeCount
        statistics.totalHints += hintCount

        switch difficulty {
        case .easy:
            statistics.easyCompleted += 1
            statistics.bestEasyTime = bestTime(
                current: statistics.bestEasyTime
            )

        case .medium:
            statistics.mediumCompleted += 1
            statistics.bestMediumTime = bestTime(
                current: statistics.bestMediumTime
            )

        case .hard:
            statistics.hardCompleted += 1
            statistics.bestHardTime = bestTime(
                current: statistics.bestHardTime
            )
        }

        SudokuStatisticsStore.save(
            statistics,
            defaults: statisticsDefaults
        )
    }

    private func bestTime(
        current: Int?
    ) -> Int {
        if let current {
            return min(
                current,
                elapsedSeconds
            )
        }

        return elapsedSeconds
    }

    private func saveGame() {
        guard shouldPersistGame else {
            return
        }

        guard !isCompleted else {
            return
        }

        guard !puzzle.cells.allSatisfy({ $0.value == $0.solution }) else {
            SudokuGameStore.clear(
                defaults: gameDefaults
            )
            return
        }

        let savedGame = SudokuSavedGame(
            puzzle: puzzle,
            difficulty: difficulty,
            mistakeCount: mistakeCount,
            hintCount: hintCount,
            elapsedSeconds: elapsedSeconds,
            selectedCellID: selectedCellID,
            isNotesMode: isNotesMode
        )

        SudokuGameStore.save(
            savedGame,
            defaults: gameDefaults
        )
    }
}
