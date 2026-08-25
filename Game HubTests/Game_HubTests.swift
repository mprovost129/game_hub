import Foundation
import Testing
@testable import Game_Hub

struct Game_HubTests {
    @Test func viewModelUsesRequestedDifficulty() {
        let viewModel = SudokuViewModel(difficulty: .hard)

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
        let viewModel = SudokuViewModel()
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

    @Test func undoRestoresMistakeCountAfterWrongEntry() throws {
        let viewModel = SudokuViewModel()
        let cell = try firstEmptyCell(in: viewModel)
        let wrongNumber = wrongValue(for: cell)

        viewModel.selectCell(cell)
        viewModel.enterNumber(wrongNumber)

        #expect(viewModel.selectedCell?.value == wrongNumber)
        #expect(viewModel.mistakeCount == 1)

        viewModel.undo()

        #expect(viewModel.selectedCell?.value == nil)
        #expect(viewModel.mistakeCount == 0)
    }

    @Test func repeatedSameNumberDoesNotCreateUndoStep() throws {
        let viewModel = SudokuViewModel()
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.enterNumber(cell.solution)
        viewModel.enterNumber(cell.solution)
        viewModel.undo()

        #expect(viewModel.selectedCell?.value == nil)
        #expect(!viewModel.canUndo)
    }

    @Test func undoRestoresNoteChangesOneAtATime() throws {
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()

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

    @Test func pausePreventsGameplayChanges() throws {
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()

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
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel(difficulty: .hard)
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
        let originalViewModel = SudokuViewModel(difficulty: .medium)
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
            savedGame: savedGame
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
        let originalStatistics = SudokuStatisticsStore.load()
        defer {
            SudokuStatisticsStore.save(originalStatistics)
        }

        SudokuStatisticsStore.save(
            SudokuStatistics()
        )

        let firstViewModel = SudokuViewModel(difficulty: .hard)
        let cell = try firstEmptyCell(in: firstViewModel)

        for _ in 0..<90 {
            firstViewModel.advanceTimer()
        }

        firstViewModel.selectCell(cell)
        firstViewModel.enterNumber(wrongValue(for: cell))
        firstViewModel.useHint()
        firstViewModel.solvePuzzleForTesting()
        firstViewModel.solvePuzzleForTesting()

        var statistics = SudokuStatisticsStore.load()

        #expect(statistics.gamesCompleted == 1)
        #expect(statistics.hardCompleted == 1)
        #expect(statistics.totalMistakes == 1)
        #expect(statistics.totalHints == 1)
        #expect(statistics.bestHardTime == 90)

        let secondViewModel = SudokuViewModel(difficulty: .hard)

        for _ in 0..<120 {
            secondViewModel.advanceTimer()
        }

        secondViewModel.solvePuzzleForTesting()
        statistics = SudokuStatisticsStore.load()

        #expect(statistics.gamesCompleted == 2)
        #expect(statistics.hardCompleted == 2)
        #expect(statistics.bestHardTime == 90)

        let thirdViewModel = SudokuViewModel(difficulty: .hard)

        for _ in 0..<30 {
            thirdViewModel.advanceTimer()
        }

        thirdViewModel.solvePuzzleForTesting()
        statistics = SudokuStatisticsStore.load()

        #expect(statistics.gamesCompleted == 3)
        #expect(statistics.hardCompleted == 3)
        #expect(statistics.bestHardTime == 30)
    }

    @Test func hintFillsCorrectEditableCellAndCanBeUndone() {
        let viewModel = SudokuViewModel()
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

    @Test func hintClearsNotesWhenItFillsACell() throws {
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel()
        let cell = try firstEmptyCell(in: viewModel)
        let secondCell = try #require(
            viewModel.puzzle.cells.first {
                !$0.isGiven && $0.id != cell.id
            }
        )

        viewModel.selectCell(cell)
        viewModel.enterNumber(wrongValue(for: cell))
        viewModel.selectCell(secondCell)

        #expect(viewModel.mistakeCount == 1)

        while viewModel.selectedCellID != cell.id && viewModel.hintCount < 81 {
            viewModel.useHint()
        }

        #expect(viewModel.selectedCell?.value == cell.solution)
        #expect(viewModel.mistakeCount == 1)
    }

    @Test func pauseAndCompletionPreventHints() {
        let viewModel = SudokuViewModel()
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
        let viewModel = SudokuViewModel(difficulty: .medium)
        let cell = try firstEmptyCell(in: viewModel)

        viewModel.selectCell(cell)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(2)
        viewModel.toggleNotesMode()
        viewModel.enterNumber(wrongValue(for: cell))
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

    @Test func endGameClearsPausedState() {
        let viewModel = SudokuViewModel()

        viewModel.togglePause()
        #expect(viewModel.isPaused)

        viewModel.endGame()

        #expect(!viewModel.isPaused)
    }

    private func firstEmptyCell(in viewModel: SudokuViewModel) throws -> SudokuCell {
        try #require(viewModel.puzzle.cells.first { !$0.isGiven })
    }

    private func playableUnsolvedCount(in viewModel: SudokuViewModel) -> Int {
        viewModel.puzzle.cells.filter { cell in
            !cell.isGiven && cell.value != cell.solution
        }.count
    }

    private func wrongValue(for cell: SudokuCell) -> Int {
        cell.solution == 1 ? 2 : 1
    }
}
