import Foundation

enum HangmanCategory: String, CaseIterable, Identifiable {
    case animals = "Animals"
    case food = "Food"
    case places = "Places"
    case everyday = "Everyday"

    var id: String { rawValue }
}
