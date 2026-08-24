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

    @Test func difficultyPuzzleClueCountsAreReasonable() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                let clueCount = definition.puzzle.filter {
                    $0 != 0
                }.count

                switch difficulty {
                case .easy:
                    #expect(clueCount >= 30)

                case .medium:
                    #expect(clueCount >= 22)
                    #expect(clueCount < 40)

                case .hard:
                    #expect(clueCount < 32)
                }
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

    @Test func everyPuzzleHasExactlyOneSolution() {
        for difficulty in SudokuDifficulty.allCases {
            for definition in SudokuPuzzleLibrary.definitions(
                for: difficulty
            ) {
                #expect(
                    solutionCount(
                        for: definition.puzzle
                    ) == 1
                )
            }
        }
    }

    private func isValidGroup(
        _ values: [Int]
    ) -> Bool {
        Set(values) == Set(1...9)
    }

    private func solutionCount(
        for puzzle: [Int],
        limit: Int = 2
    ) -> Int {
        var board = puzzle
        var count = 0

        func solve() {
            guard count < limit else {
                return
            }

            guard let emptyIndex = bestEmptyCell(
                in: board
            ) else {
                count += 1
                return
            }

            let candidates = validCandidates(
                for: emptyIndex,
                in: board
            )

            for candidate in candidates {
                board[emptyIndex] = candidate

                solve()

                board[emptyIndex] = 0

                if count >= limit {
                    return
                }
            }
        }

        solve()

        return count
    }

    private func bestEmptyCell(
        in board: [Int]
    ) -> Int? {
        var bestIndex: Int?
        var bestCandidateCount = 10

        for index in board.indices where board[index] == 0 {
            let candidates = validCandidates(
                for: index,
                in: board
            )

            if candidates.count < bestCandidateCount {
                bestCandidateCount = candidates.count
                bestIndex = index
            }

            if bestCandidateCount == 1 {
                break
            }
        }

        return bestIndex
    }

    private func validCandidates(
        for index: Int,
        in board: [Int]
    ) -> [Int] {
        let row = index / 9
        let column = index % 9

        var usedNumbers = Set<Int>()

        for currentColumn in 0..<9 {
            usedNumbers.insert(
                board[row * 9 + currentColumn]
            )
        }

        for currentRow in 0..<9 {
            usedNumbers.insert(
                board[currentRow * 9 + column]
            )
        }

        let boxRow = (row / 3) * 3
        let boxColumn = (column / 3) * 3

        for rowOffset in 0..<3 {
            for columnOffset in 0..<3 {
                let currentRow =
                    boxRow + rowOffset

                let currentColumn =
                    boxColumn + columnOffset

                usedNumbers.insert(
                    board[
                        currentRow * 9 +
                        currentColumn
                    ]
                )
            }
        }

        return (1...9).filter {
            !usedNumbers.contains($0)
        }
    }
}
