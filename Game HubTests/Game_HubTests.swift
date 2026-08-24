import Testing
@testable import Game_Hub

struct Game_HubTests {
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

        viewModel.debugSolvePuzzle()
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
        viewModel.debugSolvePuzzle()
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

    private func firstEmptyCell(in viewModel: SudokuViewModel) throws -> SudokuCell {
        try #require(viewModel.puzzle.cells.first { !$0.isGiven })
    }

    private func wrongValue(for cell: SudokuCell) -> Int {
        cell.solution == 1 ? 2 : 1
    }
}
