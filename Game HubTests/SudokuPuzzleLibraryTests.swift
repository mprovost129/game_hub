import Testing
@testable import Game_Hub

struct SudokuPuzzleLibraryTests {
    @Test func everyPuzzleHasValidStructure() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                #expect(definition.puzzle.count == 81)
                #expect(definition.solution.count == 81)

                for value in definition.puzzle {
                    #expect((0...9).contains(value))
                }

                for value in definition.solution {
                    #expect((1...9).contains(value))
                }
            }
        }
    }

    @Test func everyPuzzleContainsPlayableCells() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                #expect(
                    definition.puzzle.contains(0)
                )
            }
        }
    }

    @Test func everyGivenMatchesItsSolution() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                for index in 0..<81 {
                    let given = definition.puzzle[index]

                    if given != 0 {
                        #expect(
                            given == definition.solution[index]
                        )
                    }
                }
            }
        }
    }

    @Test func everySolutionHasValidRows() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                for row in 0..<9 {
                    let values = (0..<9).map { column in
                        definition.solution[
                            row * 9 + column
                        ]
                    }

                    #expect(isValidGroup(values))
                }
            }
        }
    }

    @Test func everySolutionHasValidColumns() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                for column in 0..<9 {
                    let values = (0..<9).map { row in
                        definition.solution[
                            row * 9 + column
                        ]
                    }

                    #expect(isValidGroup(values))
                }
            }
        }
    }

    @Test func everySolutionHasValidBoxes() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                for boxRow in 0..<3 {
                    for boxColumn in 0..<3 {
                        var values: [Int] = []

                        for rowOffset in 0..<3 {
                            for columnOffset in 0..<3 {
                                let row =
                                    boxRow * 3 + rowOffset

                                let column =
                                    boxColumn * 3 + columnOffset

                                values.append(
                                    definition.solution[
                                        row * 9 + column
                                    ]
                                )
                            }
                        }

                        #expect(isValidGroup(values))
                    }
                }
            }
        }
    }

    private func isValidGroup(
        _ values: [Int]
    ) -> Bool {
        Set(values) == Set(1...9)
    }
}
