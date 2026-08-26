import Foundation

enum WordGridBoardGenerator {
    private static let weightedLetters: [Character] =
        Array(
            "EEEEEEEEEEEE" +
            "AAAAAAAAA" +
            "IIIIIIIII" +
            "OOOOOOOO" +
            "NNNNNN" +
            "RRRRRR" +
            "TTTTTT" +
            "LLLL" +
            "SSSS" +
            "UUUU" +
            "DDDD" +
            "GGG" +
            "BBB" +
            "CCC" +
            "MMM" +
            "PPP" +
            "FFF" +
            "HHH" +
            "VV" +
            "WW" +
            "YY" +
            "K" +
            "J" +
            "X" +
            "Q" +
            "Z"
        )

    static func randomGame() -> WordGridGame {
        let letters = (0..<16).compactMap { _ in
            weightedLetters.randomElement()
        }

        return WordGridGame(
            letters: letters
        )
    }

    static func randomPlayableGame(
        dictionary: any WordGridDictionary,
        minimumWords: Int = 8
    ) -> WordGridGame {
        for _ in 0..<100 {
            let game = randomGame()

            let words = WordGridSolver.findWords(
                in: game,
                dictionary: dictionary
            )

            if words.count >= minimumWords {
                return game
            }
        }

        return WordGridBoardLibrary.testBoard
    }
}
