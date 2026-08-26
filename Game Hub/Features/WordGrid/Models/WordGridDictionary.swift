import Foundation

protocol WordGridDictionary {
    func contains(_ word: String) -> Bool
    func containsPrefix(_ prefix: String) -> Bool
}

struct LocalWordGridDictionary: WordGridDictionary {
    private let words: Set<String>
    private let prefixes: Set<String>

    init(words: Set<String>) {
        let normalizedWords = Set(
            words.map {
                $0.uppercased()
            }
        )

        self.words = normalizedWords

        self.prefixes = Set(
            normalizedWords.flatMap { word in
                (1...word.count).map { length in
                    String(
                        word.prefix(length)
                    )
                }
            }
        )
    }

    func contains(_ word: String) -> Bool {
        words.contains(
            word.uppercased()
        )
    }

    func containsPrefix(
        _ prefix: String
    ) -> Bool {
        prefixes.contains(
            prefix.uppercased()
        )
    }
}
