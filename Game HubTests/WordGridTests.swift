import Testing
@testable import game_hub

@MainActor
struct WordGridTests {
    @Test func selectingAdjacentLettersBuildsCurrentWord() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(try cell(at: 2, in: viewModel))

        #expect(viewModel.currentWord == "CAT")
    }

    @Test func submittingCurrentWordRecordsScoreAndClearsSelection() throws {
        let viewModel = makeTestViewModel()

        try selectCAT(in: viewModel)
        viewModel.submitCurrentWord()

        #expect(viewModel.submittedWords == ["CAT"])
        #expect(viewModel.score == 1)
        #expect(viewModel.lastSubmissionResult == .accepted(word: "CAT", points: 1))
        #expect(viewModel.currentWord.isEmpty)
        #expect(viewModel.selectedCellIDs.isEmpty)
    }

    @Test func nonAdjacentLetterCannotBeSelected() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 15, in: viewModel))

        #expect(viewModel.currentWord == "C")
    }

    @Test func selectedCellCannotBeReusedInSameWord() throws {
        let viewModel = makeTestViewModel()
        let firstCell = try cell(at: 0, in: viewModel)

        viewModel.selectCell(firstCell)
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(firstCell)

        #expect(viewModel.currentWord == "CA")
    }

    @Test func diagonalSelectionWorks() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 5, in: viewModel))

        #expect(viewModel.currentWord == "CE")
    }

    @Test func clearSelectionResetsCurrentWord() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.clearSelection()

        #expect(viewModel.currentWord.isEmpty)
        #expect(viewModel.selectedCellIDs.isEmpty)
    }

    @Test func dragSelectionBuildsCurrentWord() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 2, in: viewModel))

        #expect(viewModel.currentWord == "CAT")
    }

    @Test func dragSelectionIgnoresRepeatedFinalCell() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))

        #expect(viewModel.currentWord == "CA")
    }

    @Test func draggingBackwardToPreviousCellRemovesFinalCell() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 2, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))

        #expect(viewModel.currentWord == "CA")
    }

    @Test func dragSelectionCannotReuseEarlierCell() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 1, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 5, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))

        #expect(viewModel.currentWord == "CAE")
    }

    @Test func dragSelectionCannotJumpToNonAdjacentCell() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCellDuringDrag(try cell(at: 0, in: viewModel))
        viewModel.selectCellDuringDrag(try cell(at: 15, in: viewModel))

        #expect(viewModel.currentWord == "C")
    }

    @Test func tooShortSubmissionClearsSelectionWithoutScoring() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.submitCurrentWord()

        #expect(viewModel.lastSubmissionResult == .tooShort)
        #expect(viewModel.submittedWords.isEmpty)
        #expect(viewModel.score == 0)
        #expect(viewModel.currentWord.isEmpty)
    }

    @Test func invalidSubmissionClearsSelectionWithoutScoring() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(try cell(at: 5, in: viewModel))
        viewModel.submitCurrentWord()

        #expect(viewModel.lastSubmissionResult == .invalidWord)
        #expect(viewModel.submittedWords.isEmpty)
        #expect(viewModel.score == 0)
        #expect(viewModel.currentWord.isEmpty)
    }

    @Test func duplicateSubmissionDoesNotScoreAgain() throws {
        let viewModel = makeTestViewModel()

        try selectCAT(in: viewModel)
        viewModel.submitCurrentWord()
        try selectCAT(in: viewModel)
        viewModel.submitCurrentWord()

        #expect(viewModel.submittedWords == ["CAT"])
        #expect(viewModel.score == 1)
        #expect(viewModel.lastSubmissionResult == .alreadyFound)
    }

    @Test func injectedDictionaryControlsAcceptedWords() throws {
        let viewModel = WordGridViewModel(
            game: WordGridBoardLibrary.testBoard,
            dictionary: LocalWordGridDictionary(
                words: ["CAE"]
            )
        )

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(try cell(at: 5, in: viewModel))
        viewModel.submitCurrentWord()

        #expect(viewModel.submittedWords == ["CAE"])
        #expect(viewModel.score == 1)
        #expect(viewModel.lastSubmissionResult == .accepted(word: "CAE", points: 1))
    }

    @Test func lengthScoringUsesBoggleValues() throws {
        let game = WordGridGame(
            letters: [
                "A", "B", "C", "D",
                "E", "F", "G", "H",
                "I", "J", "K", "L",
                "M", "N", "O", "P"
            ]
        )

        let viewModel = WordGridViewModel(
            game: game,
            dictionary: LocalWordGridDictionary(
                words: [
                    "ABC",
                    "ABCD",
                    "ABCDH",
                    "ABCDHG",
                    "ABCDHGF",
                    "ABCDHGFE"
                ]
            )
        )

        try submit(indices: [0, 1, 2], in: viewModel)
        try submit(indices: [0, 1, 2, 3], in: viewModel)
        try submit(indices: [0, 1, 2, 3, 7], in: viewModel)
        try submit(indices: [0, 1, 2, 3, 7, 6], in: viewModel)
        try submit(indices: [0, 1, 2, 3, 7, 6, 5], in: viewModel)
        try submit(indices: [0, 1, 2, 3, 7, 6, 5, 4], in: viewModel)

        #expect(viewModel.score == 23)
    }

    @Test func timerFinishesRoundAtDuration() {
        let viewModel = makeTestViewModel()
        viewModel.roundDuration = 2

        viewModel.advanceTimer()

        #expect(viewModel.elapsedSeconds == 1)
        #expect(viewModel.remainingSeconds == 1)
        #expect(!viewModel.isRoundComplete)

        viewModel.advanceTimer()

        #expect(viewModel.elapsedSeconds == 2)
        #expect(viewModel.remainingSeconds == 0)
        #expect(viewModel.formattedTimeRemaining == "00:00")
        #expect(viewModel.isRoundComplete)
    }

    @Test func finishingRoundClearsSelectionAndBlocksGameplay() throws {
        let viewModel = makeTestViewModel()

        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.finishRound()
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.submitCurrentWord()

        #expect(viewModel.isRoundComplete)
        #expect(viewModel.currentWord.isEmpty)
        #expect(viewModel.submittedWords.isEmpty)
        #expect(viewModel.score == 0)
    }

    @Test func startNewGameResetsRoundState() throws {
        let viewModel = makeTestViewModel()

        try selectCAT(in: viewModel)
        viewModel.submitCurrentWord()
        viewModel.elapsedSeconds = 90
        viewModel.finishRound()

        viewModel.startNewGame()

        #expect(!viewModel.isRoundComplete)
        #expect(viewModel.elapsedSeconds == 0)
        #expect(viewModel.score == 0)
        #expect(viewModel.submittedWords.isEmpty)
        #expect(viewModel.selectedCellIDs.isEmpty)
        #expect(viewModel.lastSubmissionResult == nil)
    }

    @Test func petIsAcceptedAsValidWord() {
        let dictionary = LocalWordGridDictionary(
            words: WordGridWordLibrary.developmentWords
        )

        #expect(dictionary.contains("PET"))
    }

    @Test func localDictionaryTracksWordsAndPrefixesSeparately() {
        let dictionary =
            LocalWordGridDictionary(
                words: [
                    "CAT",
                    "CATS",
                    "CARE",
                    "DOG"
                ]
            )

        #expect(dictionary.contains("CAT"))
        #expect(!dictionary.contains("CA"))

        #expect(dictionary.containsPrefix("C"))
        #expect(dictionary.containsPrefix("CA"))
        #expect(dictionary.containsPrefix("CAT"))
        #expect(dictionary.containsPrefix("CATS"))
        #expect(dictionary.containsPrefix("CAR"))
        #expect(dictionary.containsPrefix("CARE"))

        #expect(!dictionary.containsPrefix("CX"))
        #expect(!dictionary.containsPrefix("Z"))
    }

    @Test func solverFindsValidWordsOnTestBoard() {
        let words = WordGridSolver.findWords(
            in: WordGridBoardLibrary.testBoard,
            dictionary: LocalWordGridDictionary(
                words: WordGridWordLibrary.developmentWords
            )
        )

        #expect(words.contains("CAT"))
        #expect(words.contains("PET"))
        #expect(words.contains("PLAY"))
    }

    private func makeTestViewModel() -> WordGridViewModel {
        WordGridViewModel(
            game: WordGridBoardLibrary.testBoard,
            dictionary: LocalWordGridDictionary(
                words: WordGridWordLibrary.developmentWords
            )
        )
    }

    private func selectCAT(
        in viewModel: WordGridViewModel
    ) throws {
        viewModel.selectCell(try cell(at: 0, in: viewModel))
        viewModel.selectCell(try cell(at: 1, in: viewModel))
        viewModel.selectCell(try cell(at: 2, in: viewModel))
    }

    private func submit(
        indices: [Int],
        in viewModel: WordGridViewModel
    ) throws {
        for index in indices {
            viewModel.selectCell(try cell(at: index, in: viewModel))
        }

        viewModel.submitCurrentWord()
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
