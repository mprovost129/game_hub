import Foundation

struct WordGridGame {
    let cells: [WordGridCell]

    init(
        letters: [Character]
    ) {
        precondition(letters.count == 16)

        self.cells = letters.enumerated().map { index, letter in
            WordGridCell(
                row: index / 4,
                column: index % 4,
                letter: Character(
                    String(letter).uppercased()
                )
            )
        }
    }
}
