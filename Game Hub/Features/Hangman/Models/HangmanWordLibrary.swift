import Foundation

enum HangmanWordLibrary {
    static func randomWord(
        for category: HangmanCategory
    ) -> String {
        words(for: category).randomElement()!
    }

    static func words(
        for category: HangmanCategory
    ) -> [String] {
        switch category {
        case .animals:
            return [
                "ELEPHANT",
                "TIGER",
                "PENGUIN",
                "RABBIT",
                "GIRAFFE",
                "DOLPHIN",
                "TURTLE",
                "MONKEY"
            ]

        case .food:
            return [
                "PIZZA",
                "BURGER",
                "PANCAKE",
                "SPAGHETTI",
                "POPCORN",
                "CHEESE",
                "COOKIE",
                "WAFFLE"
            ]

        case .places:
            return [
                "SCHOOL",
                "BEACH",
                "AIRPORT",
                "LIBRARY",
                "MUSEUM",
                "STADIUM",
                "MARKET",
                "PARK"
            ]

        case .everyday:
            return [
                "PHONE",
                "WINDOW",
                "CHAIR",
                "PENCIL",
                "BACKPACK",
                "UMBRELLA",
                "COMPUTER",
                "BICYCLE"
            ]
        }
    }
}
