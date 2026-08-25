import Foundation
import Testing
@testable import Game_Hub

struct Game_HubTests {
    @Test func viewModelUsesRequestedDifficulty() {
        let viewModel = makeViewModel(difficulty: .hard)

        #expect(viewModel.difficulty == .hard)
        #expect(viewModel.puzzle.cells.count == 81)
    }

    @Test func puzzleInitializerBuildsExpectedCells() {
        let puzzleValues = Array(repeating: 0, count: 80) + [9]
        let solutionValues = Array(repeating: 1, count: 80) + [9]
        let puzzle = SudokuPuzzle(
            puzzle: puzzleValues,
            solution: solutionValues
        )

        #expect(puzzle.cells.count == 81)
        #expect(puzzle.cells[0].row == 0)
        #expect(puzzle.cells[0].column == 0)
        #expect(puzzle.cells[0].value == nil)
        #expect(!puzzle.cells[0].isGiven)
        #expect(puzzle.cells[80].row == 8)
        #expect(puzzle.cells[80].column == 8)
        #expect(puzzle.cells[80].value == 9)
        #expect(puzzle.cells[80].solution == 9)
        #expect(puzzle.cells[80].isGiven)
    }

    @Test func puzzleLibraryReturnsPuzzleForEveryDifficulty() {
        for difficulty in SudokuDifficulty.allCases {
            let puzzle = SudokuPuzzleLibrary.randomPuzzle(for: difficulty)

            #expect(puzzle.cells.count == 81)
        }
    }

    @Test func undoRestoresCorrectNumberEntry() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.enterNumber(cell.solution)

        #expect(viewModel.selectedCell?.value == cell.solution)
        #expect(viewModel.canUndo)

        viewModel.undo()

        #expect(viewModel.selectedCell?.value == nil)
        #expect(viewModel.mistakeCount == 0)
        #expect(!viewModel.canUndo)
    }

    @Test func nonConflictingWrongEntryDoesNotCountAsMistake() throws {
        let viewModel = makeViewModel()
        let (cell, wrongNumber) = try firstCellWithNonConflictingWrongValue(
            in: viewModel
        )

        viewModel.selectCell(cell)
        viewModel.enterNumber(wrongNumber)

        #expect(viewModel.selectedCell?.value == wrongNumber)
        #expect(viewModel.mistakeCount == 0)
        #expect(viewModel.selectedCell.map { viewModel.hasConflict($0) } == false)

        viewModel.undo()

        #expect(viewModel.selectedCell?.value == nil)
        #expect(viewModel.mistakeCount == 0)
    }

    @Test func undoRestoresMistakeCountAfterConflictingEntry() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)
        let conflictNumber = try conflictingValue(
            for: cell,
            in: viewModel
        )
        let conflictingPeer = try conflictingPeer(
            for: cell,
            value: conflictNumber,
            in: viewModel
        )

        viewModel.selectCell(cell)
        viewModel.enterNumber(conflictNumber)

        #expect(viewModel.selectedCell?.value == conflictNumber)
        #expect(viewModel.mistakeCount == 1)
        #expect(viewModel.selectedCell.map { viewModel.hasConflict($0) } == true)
        #expect(viewModel.hasConflict(conflictingPeer))

        viewModel.undo()

        #expect(viewModel.selectedCell?.value == nil)
        #expect(viewModel.mistakeCount == 0)
    }

    @Test func conflictDetectionCoversRowsColumnsAndBoxes() {
        let viewModel = makeViewModel()
        var puzzleValues = Array(
            repeating: 0,
            count: 81
        )
        let solutionValues = Array(
            repeating: 1,
            count: 81
        )

        puzzleValues[0] = 5
        puzzleValues[1] = 5
        puzzleValues[2] = 6
        puzzleValues[11] = 6
        puzzleValues[10] = 7
        puzzleValues[20] = 7

        viewModel.puzzle = SudokuPuzzle(
            puzzle: puzzleValues,
            solution: solutionValues
        )

        #expect(viewModel.hasConflict(viewModel.puzzle.cells[0]))
        #expect(viewModel.hasConflict(viewModel.puzzle.cells[1]))
        #expect(viewModel.hasConflict(viewModel.puzzle.cells[2]))
        #expect(viewModel.hasConflict(viewModel.puzzle.cells[11]))
        #expect(viewModel.hasConflict(viewModel.puzzle.cells[10]))
        #expect(viewModel.hasConflict(viewModel.puzzle.cells[20]))
    }

    @Test func repeatedSameNumberDoesNotCreateUndoStep() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.enterNumber(cell.solution)
        viewModel.enterNumber(cell.solution)
        viewModel.undo()

        #expect(viewModel.selectedCell?.value == nil)
        #expect(!viewModel.canUndo)
    }

    @Test func undoRestoresNoteChangesOneAtATime() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(2)
        viewModel.enterNumber(4)
        viewModel.enterNumber(7)

        #expect(viewModel.selectedCell?.notes == [2, 4, 7])

        viewModel.undo()
        #expect(viewModel.selectedCell?.notes == [2, 4])

        viewModel.undo()
        #expect(viewModel.selectedCell?.notes == [2])

        viewModel.undo()
        #expect(viewModel.selectedCell?.notes.isEmpty == true)
        #expect(!viewModel.canUndo)
    }

    @Test func undoRestoresRemovedNote() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(3)
        viewModel.enterNumber(3)

        #expect(viewModel.selectedCell?.notes.isEmpty == true)

        viewModel.undo()

        #expect(viewModel.selectedCell?.notes == [3])
    }

    @Test func undoRestoresErasedValueAndNotes() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.enterNumber(cell.solution)
        viewModel.clearSelectedCell()

        #expect(viewModel.selectedCell?.value == nil)

        viewModel.undo()

        #expect(viewModel.selectedCell?.value == cell.solution)

        viewModel.undo()
        viewModel.toggleNotesMode()
        viewModel.enterNumber(1)
        viewModel.enterNumber(8)
        viewModel.clearSelectedCell()

        #expect(viewModel.selectedCell?.notes.isEmpty == true)

        viewModel.undo()

        #expect(viewModel.selectedCell?.notes == [1, 8])
    }

    @Test func givenCellsCannotBeModifiedOrUndone() throws {
        let viewModel = makeViewModel()
        let givenCell = try #require(viewModel.puzzle.cells.first { $0.isGiven })
        let originalValue = givenCell.value

        viewModel.selectCell(givenCell)
        viewModel.enterNumber(wrongValue(for: givenCell))
        viewModel.clearSelectedCell()
        viewModel.undo()

        #expect(viewModel.selectedCell?.value == originalValue)
        #expect(viewModel.mistakeCount == 0)
        #expect(!viewModel.canUndo)
    }

    @Test func timerFormatsElapsedTimeAndStopsWhilePaused() {
        let viewModel = makeViewModel()

        for _ in 0..<65 {
            viewModel.advanceTimer()
        }

        #expect(viewModel.elapsedSeconds == 65)
        #expect(viewModel.formattedTime == "01:05")

        viewModel.togglePause()
        viewModel.advanceTimer()

        #expect(viewModel.elapsedSeconds == 65)
        #expect(viewModel.formattedTime == "01:05")
    }

    @Test func interruptionPausesAndSavesGame() {
        let gameDefaults = isolatedDefaults()
        let viewModel = makeViewModel(
            gameDefaults: gameDefaults
        )

        viewModel.advanceTimer()
        viewModel.pauseForInterruption()
        viewModel.advanceTimer()

        let savedGame = SudokuGameStore.load(
            defaults: gameDefaults
        )

        #expect(viewModel.isPaused)
        #expect(viewModel.elapsedSeconds == 1)
        #expect(savedGame?.elapsedSeconds == 1)
    }

    @Test func pausePreventsGameplayChanges() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(2)
        viewModel.toggleNotesMode()
        viewModel.togglePause()

        viewModel.enterNumber(cell.solution)
        viewModel.clearSelectedCell()
        viewModel.undo()
        viewModel.toggleNotesMode()

        #expect(viewModel.selectedCell?.notes == [2])
        #expect(viewModel.selectedCell?.value == nil)
        #expect(viewModel.isNotesMode == false)
        #expect(viewModel.canUndo)
    }

    @Test func pausePreventsSelectionChanges() throws {
        let viewModel = makeViewModel()
        let firstCell = try firstEmptyCell(in: viewModel)
        let secondCell = try #require(
            viewModel.puzzle.cells.first {
                !$0.isGiven && $0.id != firstCell.id
            }
        )

        viewModel.selectCell(firstCell)
        viewModel.togglePause()
        viewModel.selectCell(secondCell)

        #expect(viewModel.selectedCellID == firstCell.id)
    }

    @Test func debugSolveCompletesPuzzleAndStopsTimer() {
        let viewModel = makeViewModel()

        for _ in 0..<8 {
            viewModel.advanceTimer()
        }

        viewModel.solvePuzzleForTesting()
        viewModel.advanceTimer()

        #expect(viewModel.isCompleted)
        #expect(!viewModel.isPaused)
        #expect(viewModel.elapsedSeconds == 8)
        #expect(viewModel.formattedTime == "00:08")
        #expect(viewModel.puzzle.cells.allSatisfy { $0.value == $0.solution })
    }

    @Test func completionPreventsGameplayChanges() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.solvePuzzleForTesting()
        viewModel.enterNumber(wrongValue(for: cell))
        viewModel.clearSelectedCell()
        viewModel.undo()
        viewModel.toggleNotesMode()
        viewModel.togglePause()

        #expect(viewModel.isCompleted)
        #expect(!viewModel.isPaused)
        #expect(viewModel.isNotesMode == false)
        #expect(viewModel.puzzle.cells.allSatisfy { $0.value == $0.solution })
    }

    @MainActor
    @Test func savedGameCodableRoundTripsSessionState() throws {
        let viewModel = makeViewModel(difficulty: .hard)
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(1)

        let savedGame = SudokuSavedGame(
            puzzle: viewModel.puzzle,
            difficulty: viewModel.difficulty,
            mistakeCount: 2,
            hintCount: 1,
            elapsedSeconds: 42,
            selectedCellID: viewModel.selectedCellID,
            isNotesMode: viewModel.isNotesMode
        )

        let data = try JSONEncoder().encode(savedGame)
        let decoded = try JSONDecoder().decode(
            SudokuSavedGame.self,
            from: data
        )

        #expect(decoded.difficulty == .hard)
        #expect(decoded.mistakeCount == 2)
        #expect(decoded.hintCount == 1)
        #expect(decoded.elapsedSeconds == 42)
        #expect(decoded.selectedCellID == cell.id)
        #expect(decoded.isNotesMode)
        #expect(decoded.puzzle.cells == viewModel.puzzle.cells)
    }

    @MainActor
    @Test func viewModelRestoresSavedGameWithoutPausedState() throws {
        let originalViewModel = makeViewModel(difficulty: .medium)
        let cell = try firstEmptyCell(in: originalViewModel)

        originalViewModel.selectCell(cell)
        originalViewModel.toggleNotesMode()
        originalViewModel.enterNumber(3)

        let savedGame = SudokuSavedGame(
            puzzle: originalViewModel.puzzle,
            difficulty: originalViewModel.difficulty,
            mistakeCount: 1,
            hintCount: 2,
            elapsedSeconds: 125,
            selectedCellID: originalViewModel.selectedCellID,
            isNotesMode: originalViewModel.isNotesMode
        )

        let restoredViewModel = SudokuViewModel(
            savedGame: savedGame,
            gameDefaults: isolatedDefaults(),
            statisticsDefaults: isolatedDefaults()
        )

        #expect(restoredViewModel.difficulty == .medium)
        #expect(restoredViewModel.puzzle.cells == originalViewModel.puzzle.cells)
        #expect(restoredViewModel.mistakeCount == 1)
        #expect(restoredViewModel.hintCount == 2)
        #expect(restoredViewModel.elapsedSeconds == 125)
        #expect(restoredViewModel.selectedCellID == cell.id)
        #expect(restoredViewModel.isNotesMode)
        #expect(!restoredViewModel.isPaused)
        #expect(!restoredViewModel.isCompleted)
        #expect(!restoredViewModel.canUndo)
    }

    @MainActor
    @Test func completedGamesRecordStatisticsOnceAndTrackBestTime() throws {
        let statisticsDefaults = isolatedDefaults()
        SudokuStatisticsStore.save(
            SudokuStatistics(),
            defaults: statisticsDefaults
        )

        let firstViewModel = makeViewModel(
            difficulty: .hard,
            statisticsDefaults: statisticsDefaults
        )
        let cell = try firstEmptyCell(in: firstViewModel)

        for _ in 0..<90 {
            firstViewModel.advanceTimer()
        }

        firstViewModel.selectCell(cell)
        firstViewModel.enterNumber(
            try conflictingValue(
                for: cell,
                in: firstViewModel
            )
        )
        firstViewModel.useHint()
        try completePuzzleNormally(firstViewModel)
        firstViewModel.solvePuzzleForTesting()

        var statistics = SudokuStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesCompleted == 1)
        #expect(statistics.hardCompleted == 1)
        #expect(statistics.totalMistakes == 1)
        #expect(statistics.totalHints == 1)
        #expect(statistics.bestHardTime == 90)

        let secondViewModel = makeViewModel(
            difficulty: .hard,
            statisticsDefaults: statisticsDefaults
        )

        for _ in 0..<120 {
            secondViewModel.advanceTimer()
        }

        try completePuzzleNormally(secondViewModel)
        statistics = SudokuStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesCompleted == 2)
        #expect(statistics.hardCompleted == 2)
        #expect(statistics.bestHardTime == 90)

        let thirdViewModel = makeViewModel(
            difficulty: .hard,
            statisticsDefaults: statisticsDefaults
        )

        for _ in 0..<30 {
            thirdViewModel.advanceTimer()
        }

        try completePuzzleNormally(thirdViewModel)
        statistics = SudokuStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(statistics.gamesCompleted == 3)
        #expect(statistics.hardCompleted == 3)
        #expect(statistics.bestHardTime == 30)
    }

    @MainActor
    @Test func debugSolveDoesNotRecordStatistics() {
        let statisticsDefaults = isolatedDefaults()
        SudokuStatisticsStore.save(
            SudokuStatistics(),
            defaults: statisticsDefaults
        )

        let viewModel = makeViewModel(
            statisticsDefaults: statisticsDefaults
        )

        viewModel.solvePuzzleForTesting()

        let statistics = SudokuStatisticsStore.load(
            defaults: statisticsDefaults
        )

        #expect(viewModel.isCompleted)
        #expect(statistics.gamesCompleted == 0)
    }

    @Test func hintFillsCorrectEditableCellAndCanBeUndone() {
        let viewModel = makeViewModel()
        let unsolvedCount = playableUnsolvedCount(in: viewModel)

        viewModel.useHint()

        #expect(viewModel.hintCount == 1)
        #expect(viewModel.canUndo)
        #expect(viewModel.selectedCell?.value == viewModel.selectedCell?.solution)
        #expect(playableUnsolvedCount(in: viewModel) == unsolvedCount - 1)

        viewModel.undo()

        #expect(viewModel.hintCount == 0)
        #expect(!viewModel.canUndo)
        #expect(playableUnsolvedCount(in: viewModel) == unsolvedCount)
    }

    @Test func hintSolvesSelectedUnresolvedCellFirst() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.useHint()

        #expect(viewModel.selectedCellID == cell.id)
        #expect(viewModel.selectedCell?.value == cell.solution)
        #expect(viewModel.hintCount == 1)
    }

    @Test func hintCorrectsSelectedWrongCellFirst() throws {
        let viewModel = makeViewModel()
        let (cell, wrongNumber) = try firstCellWithNonConflictingWrongValue(
            in: viewModel
        )

        viewModel.selectCell(cell)
        viewModel.enterNumber(wrongNumber)
        viewModel.useHint()

        #expect(viewModel.selectedCellID == cell.id)
        #expect(viewModel.selectedCell?.value == cell.solution)
        #expect(viewModel.mistakeCount == 0)
        #expect(viewModel.hintCount == 1)
    }

    @Test func hintFallsBackWhenSelectedCellIsGiven() throws {
        let viewModel = makeViewModel()
        let givenCell = try #require(
            viewModel.puzzle.cells.first { $0.isGiven }
        )
        let unsolvedCount = playableUnsolvedCount(in: viewModel)

        viewModel.selectCell(givenCell)
        viewModel.useHint()

        #expect(viewModel.selectedCellID != givenCell.id)
        #expect(viewModel.selectedCell?.value == viewModel.selectedCell?.solution)
        #expect(viewModel.hintCount == 1)
        #expect(playableUnsolvedCount(in: viewModel) == unsolvedCount - 1)
    }

    @Test func hintClearsNotesWhenItFillsACell() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)
        let secondCell = try #require(
            viewModel.puzzle.cells.first {
                !$0.isGiven && $0.id != cell.id
            }
        )

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(1)
        viewModel.enterNumber(2)
        viewModel.toggleNotesMode()
        viewModel.selectCell(secondCell)

        while viewModel.selectedCellID != cell.id && viewModel.hintCount < 81 {
            viewModel.useHint()
        }

        #expect(viewModel.selectedCell?.value == cell.solution)
        #expect(viewModel.selectedCell?.notes.isEmpty == true)
    }

    @Test func hintCanCorrectWrongEntryWithoutChangingMistakeCount() throws {
        let viewModel = makeViewModel()
        let cell = try firstEmptyCell(in: viewModel)
        let conflictNumber = try conflictingValue(
            for: cell,
            in: viewModel
        )
        let secondCell = try #require(
            viewModel.puzzle.cells.first {
                !$0.isGiven && $0.id != cell.id
            }
        )

        viewModel.selectCell(cell)
        viewModel.enterNumber(conflictNumber)
        viewModel.selectCell(secondCell)

        #expect(viewModel.mistakeCount == 1)

        while viewModel.selectedCellID != cell.id && viewModel.hintCount < 81 {
            viewModel.useHint()
        }

        #expect(viewModel.selectedCell?.value == cell.solution)
        #expect(viewModel.mistakeCount == 1)
    }

    @Test func pauseAndCompletionPreventHints() {
        let viewModel = makeViewModel()
        let unsolvedCount = playableUnsolvedCount(in: viewModel)

        viewModel.togglePause()
        viewModel.useHint()

        #expect(viewModel.hintCount == 0)
        #expect(playableUnsolvedCount(in: viewModel) == unsolvedCount)

        viewModel.togglePause()
        viewModel.solvePuzzleForTesting()
        viewModel.useHint()

        #expect(viewModel.hintCount == 0)
    }

    @Test func startNewGameResetsSessionState() throws {
        let viewModel = makeViewModel(difficulty: .medium)
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(2)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(
            try conflictingValue(
                for: cell,
                in: viewModel
            )
        )
        viewModel.useHint()
        viewModel.advanceTimer()
        viewModel.togglePause()

        #expect(viewModel.selectedCellID != nil)
        #expect(viewModel.mistakeCount == 1)
        #expect(viewModel.hintCount == 1)
        #expect(viewModel.elapsedSeconds == 1)
        #expect(viewModel.isPaused)
        #expect(viewModel.canUndo)

        viewModel.startNewGame()

        #expect(viewModel.difficulty == .medium)
        #expect(viewModel.puzzle.cells.count == 81)
        #expect(viewModel.selectedCellID == nil)
        #expect(viewModel.mistakeCount == 0)
        #expect(viewModel.hintCount == 0)
        #expect(viewModel.elapsedSeconds == 0)
        #expect(!viewModel.isPaused)
        #expect(!viewModel.isCompleted)
        #expect(!viewModel.isNotesMode)
        #expect(!viewModel.canUndo)
    }

    @Test func endGameClearsPausedStateAndPreventsFutureSaves() {
        let gameDefaults = isolatedDefaults()
        let viewModel = makeViewModel(
            gameDefaults: gameDefaults
        )

        viewModel.togglePause()
        #expect(viewModel.isPaused)
        #expect(
            SudokuGameStore.hasSavedGame(
                defaults: gameDefaults
            )
        )

        viewModel.endGame()
        viewModel.saveCurrentGame()

        #expect(!viewModel.isPaused)
        #expect(
            !SudokuGameStore.hasSavedGame(
                defaults: gameDefaults
            )
        )
    }

    private func firstEmptyCell(in viewModel: SudokuViewModel) throws -> SudokuCell {
        try #require(viewModel.puzzle.cells.first { !$0.isGiven })
    }

    private func completePuzzleNormally(
        _ viewModel: SudokuViewModel
    ) throws {
        let finalCell = try firstPlayableUnsolvedCell(in: viewModel)

        for index in viewModel.puzzle.cells.indices {
            guard viewModel.puzzle.cells[index].id != finalCell.id else {
                continue
            }

            guard !viewModel.puzzle.cells[index].isGiven else {
                continue
            }

            viewModel.puzzle.cells[index].value =
                viewModel.puzzle.cells[index].solution

            viewModel.puzzle.cells[index].notes.removeAll()
        }

        viewModel.selectCell(finalCell)
        viewModel.enterNumber(finalCell.solution)
    }

    private func playableUnsolvedCount(in viewModel: SudokuViewModel) -> Int {
        viewModel.puzzle.cells.filter { cell in
            !cell.isGiven && cell.value != cell.solution
        }.count
    }

    private func firstPlayableUnsolvedCell(
        in viewModel: SudokuViewModel
    ) throws -> SudokuCell {
        try #require(
            viewModel.puzzle.cells.first { cell in
                !cell.isGiven && cell.value != cell.solution
            }
        )
    }

    private func firstCellWithNonConflictingWrongValue(
        in viewModel: SudokuViewModel
    ) throws -> (cell: SudokuCell, value: Int) {
        for cell in viewModel.puzzle.cells where !cell.isGiven {
            if let value = nonConflictingWrongValue(
                for: cell,
                in: viewModel
            ) {
                return (cell, value)
            }
        }

        let result: (cell: SudokuCell, value: Int)? = nil
        return try #require(result)
    }

    private func nonConflictingWrongValue(
        for cell: SudokuCell,
        in viewModel: SudokuViewModel
    ) -> Int? {
        (1...9).first { value in
            value != cell.solution &&
            !hasPeerValue(
                value,
                for: cell,
                in: viewModel
            )
        }
    }

    private func conflictingValue(
        for cell: SudokuCell,
        in viewModel: SudokuViewModel
    ) throws -> Int {
        try #require(
            (1...9).first { value in
                hasPeerValue(
                    value,
                    for: cell,
                    in: viewModel
                )
            }
        )
    }

    private func conflictingPeer(
        for cell: SudokuCell,
        value: Int,
        in viewModel: SudokuViewModel
    ) throws -> SudokuCell {
        try #require(
            viewModel.puzzle.cells.first { peer in
                peer.id != cell.id &&
                peer.value == value &&
                isPeer(
                    peer,
                    of: cell
                )
            }
        )
    }

    private func hasPeerValue(
        _ value: Int,
        for cell: SudokuCell,
        in viewModel: SudokuViewModel
    ) -> Bool {
        viewModel.puzzle.cells.contains { peer in
            peer.id != cell.id &&
            peer.value == value &&
            isPeer(
                peer,
                of: cell
            )
        }
    }

    private func isPeer(
        _ firstCell: SudokuCell,
        of secondCell: SudokuCell
    ) -> Bool {
        let sameRow = firstCell.row == secondCell.row
        let sameColumn = firstCell.column == secondCell.column

        let sameBox =
            firstCell.row / 3 == secondCell.row / 3 &&
            firstCell.column / 3 == secondCell.column / 3

        return sameRow || sameColumn || sameBox
    }

    private func makeViewModel(
        difficulty: SudokuDifficulty = .easy,
        gameDefaults: UserDefaults? = nil,
        statisticsDefaults: UserDefaults? = nil
    ) -> SudokuViewModel {
        SudokuViewModel(
            difficulty: difficulty,
            gameDefaults: gameDefaults ?? isolatedDefaults(),
            statisticsDefaults: statisticsDefaults ?? isolatedDefaults()
        )
    }

    private func isolatedDefaults() -> UserDefaults {
        let suiteName = "GameHubTests.\(UUID().uuidString)"
        let defaults = UserDefaults(
            suiteName: suiteName
        )!

        defaults.removePersistentDomain(
            forName: suiteName
        )

        return defaults
    }

    private func wrongValue(for cell: SudokuCell) -> Int {
        cell.solution == 1 ? 2 : 1
    }
}
