import Foundation

struct WordGridCell: Identifiable, Equatable {
    let id = UUID()

    let row: Int
    let column: Int
    let letter: Character
}
