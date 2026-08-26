import Foundation

struct WordGridBundledDictionary: WordGridDictionary {
    private let words: Set<String>

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
            return
        }

        self.words = Set(
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
    }

    func contains(
        _ word: String
    ) -> Bool {
        words.contains(
            word.uppercased()
        )
    }
}
