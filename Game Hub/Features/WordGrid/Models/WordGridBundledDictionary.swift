import Foundation

struct WordGridBundledDictionary: WordGridDictionary {
    private let words: Set<String>
    private let prefixes: Set<String>

    init(
        resourceName: String = "wordgrid_words"
    ) {
        guard
            let url = Bundle.main.url(
                forResource: resourceName,
                withExtension: "txt"
            ),
            let contents = try? String(
                contentsOf: url,
                encoding: .utf8
        )
        else {
            self.words = []
            self.prefixes = []
            return
        }

        let normalizedWords = Set(
            contents
                .split(whereSeparator: \.isNewline)
                .map {
                    $0
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .uppercased()
                }
                .filter {
                    $0.count >= 3
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

    func contains(
        _ word: String
    ) -> Bool {
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
