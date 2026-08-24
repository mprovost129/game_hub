import Testing
@testable import Game_Hub

struct SudokuPuzzleLibraryTests {
    @Test func libraryContainsExpectedDefinitionCounts() {
        #expect(SudokuPuzzleLibrary.definitions(for: .easy).count == 3)
        #expect(SudokuPuzzleLibrary.definitions(for: .medium).count == 2)
        #expect(SudokuPuzzleLibrary.definitions(for: .hard).count == 2)
    }

    @Test func randomPuzzleReturnsCompleteBoardShapeForEveryDifficulty() {
        for difficulty in SudokuDifficulty.allCases {
            let puzzle = SudokuPuzzleLibrary.randomPuzzle(for: difficulty)

            #expect(puzzle.cells.count == 81)
        }
    }

    @Test func solutionContainsOnlyNumbersOneThroughNine() {
        for definition in allDefinitions {
            let puzzle = definition.makePuzzle()

            for cell in puzzle.cells {
                #expect((1...9).contains(cell.solution))
            }
        }
    }

    @Test func givensMatchSolution() {
        for definition in allDefinitions {
            let puzzle = definition.makePuzzle()

            for cell in puzzle.cells where cell.isGiven {
                #expect(cell.value == cell.solution)
            }
        }
    }

    @Test func puzzleDefinitionsHaveExpectedArraySizes() {
        for definition in allDefinitions {
            #expect(definition.puzzle.count == 81)
            #expect(definition.solution.count == 81)
        }
    }

    private var allDefinitions: [SudokuPuzzleDefinition] {
        SudokuDifficulty.allCases.flatMap { difficulty in
            SudokuPuzzleLibrary.definitions(for: difficulty)
        }
    }
}
