import Foundation

enum GameAvailability {
    case available
    case comingSoon
}

struct GameDefinition: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let availability: GameAvailability

    var isAvailable: Bool {
        availability == .available
    }
}

extension GameDefinition {
    static let sudoku = GameDefinition(
        id: "sudoku",
        title: "Sudoku",
        subtitle: "Classic number puzzle",
        systemImage: "square.grid.3x3",
        availability: .available
    )

    static let wordGame = GameDefinition(
        id: "word-game",
        title: "Word Game",
        subtitle: "Coming soon",
        systemImage: "textformat.abc",
        availability: .comingSoon
    )

    static let hangman = GameDefinition(
        id: "hangman",
        title: "Hangman",
        subtitle: "Coming soon",
        systemImage: "character.textbox",
        availability: .comingSoon
    )

    static let numberGame = GameDefinition(
        id: "number-game",
        title: "Number Game",
        subtitle: "Coming soon",
        systemImage: "number",
        availability: .comingSoon
    )

    static let allGames: [GameDefinition] = [
        .sudoku,
        .wordGame,
        .hangman,
        .numberGame
    ]
}
