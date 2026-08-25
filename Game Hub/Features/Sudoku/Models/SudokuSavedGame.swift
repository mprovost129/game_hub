import Foundation

struct SudokuSavedGame: Codable {
    let puzzle: SudokuPuzzle
    let difficulty: SudokuDifficulty

    let mistakeCount: Int
    let hintCount: Int
    let elapsedSeconds: Int

    let selectedCellID: UUID?
    let isNotesMode: Bool
}
