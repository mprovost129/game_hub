import Testing
@testable import game_hub

struct WordGridTests {
    @Test func selectingAdjacentLettersBuildsCurrentWord() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(try cell(at: 2, in: viewModel))

        #expect(viewModel.currentWord == "CAT")
    }

    @Test func submittingCurrentWordRecordsAndClearsSelection() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(try cell(at: 2, in: viewModel))
        viewModel.submitCurrentWord()

        #expect(viewModel.submittedWords == ["CAT"])
        #expect(viewModel.currentWord.isEmpty)
        #expect(viewModel.selectedCellIDs.isEmpty)
    }

    @Test func nonAdjacentLetterCannotBeSelected() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 15, in: viewModel))

        #expect(viewModel.currentWord == "C")
    }

    @Test func selectedCellCannotBeReusedInSameWord() throws {
        let viewModel = WordGridViewModel()
        let firstCell = try cell(at: 0, in: viewModel)

        viewModel.selectCell(firstCell)
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(firstCell)

        #expect(viewModel.currentWord == "CA")
    }

    @Test func diagonalSelectionWorks() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 5, in: viewModel))

        #expect(viewModel.currentWord == "CE")
    }

    @Test func clearSelectionResetsCurrentWord() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.clearSelection()

        #expect(viewModel.currentWord.isEmpty)
        #expect(viewModel.selectedCellIDs.isEmpty)
    }

    @Test func dragSelectionBuildsCurrentWord() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 2, in: viewModel))

        #expect(viewModel.currentWord == "CAT")
    }

    @Test func dragSelectionIgnoresRepeatedFinalCell() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))

        #expect(viewModel.currentWord == "CA")
    }

    @Test func draggingBackwardToPreviousCellRemovesFinalCell() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 2, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))

        #expect(viewModel.currentWord == "CA")
    }

    @Test func dragSelectionCannotReuseEarlierCell() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 5, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))

        #expect(viewModel.currentWord == "CAE")
    }

    @Test func dragSelectionCannotJumpToNonAdjacentCell() throws {
        let viewModel = WordGridViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 15, in: viewModel))

        #expect(viewModel.currentWord == "C")
    }

    private func cell(
        at index: Int,
        in viewModel: WordGridViewModel
    ) throws -> WordGridCell {
        try #require(viewModel.game.cells[safe: index])
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}
