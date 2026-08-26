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

    static let wordGrid = GameDefinition(
        id: "word-grid",
        title: "Word Grid",
        subtitle: "Build words from adjacent letters",
        systemImage: "square.grid.3x3.fill",
        availability: .available
    )

    static let hangman = GameDefinition(
        id: "hangman",
        title: "Hangman",
        subtitle: "Classic word guessing",
        systemImage: "character.textbox",
        availability: .available
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
        .hangman,
        .wordGrid,
        .numberGame
    ]
}
