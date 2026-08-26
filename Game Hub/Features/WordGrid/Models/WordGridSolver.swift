import Foundation

enum WordGridSolver {
    static func findWords(
        in game: WordGridGame,
        dictionary: any WordGridDictionary
    ) -> Set<String> {
        var results = Set<String>()

        for cell in game.cells {
            search(
                from: cell,
                currentWord: "",
                visited: [],
                game: game,
                dictionary: dictionary,
                results: &results
            )
        }

        return results
    }

    private static func search(
        from cell: WordGridCell,
        currentWord: String,
        visited: Set<UUID>,
        game: WordGridGame,
        dictionary: any WordGridDictionary,
        results: inout Set<String>
    ) {
        guard !visited.contains(cell.id) else {
            return
        }

        var newVisited = visited
        newVisited.insert(cell.id)

        let newWord =
            currentWord + String(cell.letter)

        guard dictionary.containsPrefix(
            newWord
        ) else {
            return
        }

        if newWord.count >= 3,
           dictionary.contains(newWord) {
            results.insert(newWord)
        }

        guard newWord.count < 12 else {
            return
        }

        for neighbor in neighbors(
            of: cell,
            in: game
        ) {
            search(
                from: neighbor,
                currentWord: newWord,
                visited: newVisited,
                game: game,
                dictionary: dictionary,
                results: &results
            )
        }
    }

    private static func neighbors(
        of cell: WordGridCell,
        in game: WordGridGame
    ) -> [WordGridCell] {
        game.cells.filter { candidate in
            guard candidate.id != cell.id else {
                return false
            }

            let rowDistance = abs(
                candidate.row - cell.row
            )

            let columnDistance = abs(
                candidate.column - cell.column
            )

            return rowDistance <= 1 &&
                columnDistance <= 1
        }
    }
}
