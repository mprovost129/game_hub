import Foundation

struct GameDefinition: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let isAvailable: Bool
}

extension GameDefinition {
    static let sudoku = GameDefinition(
        id: "sudoku",
        title: "Sudoku",
        subtitle: "Classic number puzzle",
        systemImage: "square.grid.3x3",
        isAvailable: true
    )

    static let wordGame = GameDefinition(
        id: "word-game",
        title: "Word Game",
        subtitle: "Coming soon",
        systemImage: "textformat.abc",
        isAvailable: false
    )

    static let hangman = GameDefinition(
        id: "hangman",
        title: "Hangman",
        subtitle: "Coming soon",
        systemImage: "character.textbox",
        isAvailable: false
    )

    static let numberGame = GameDefinition(
        id: "number-game",
        title: "Number Game",
        subtitle: "Coming soon",
        systemImage: "number",
        isAvailable: false
    )

    static let allGames: [GameDefinition] = [
        .sudoku,
        .wordGame,
        .hangman,
        .numberGame
    ]
}
