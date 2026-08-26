import Foundation

protocol WordGridDictionary {
    func contains(_ word: String) -> Bool
}

struct LocalWordGridDictionary: WordGridDictionary {
    private let words: Set<String>

    init(words: Set<String>) {
        self.words = Set(
            words.map {
                $0.uppercased()
            }
        )
    }

    func contains(_ word: String) -> Bool {
        words.contains(
            word.uppercased()
        )
    }
}
