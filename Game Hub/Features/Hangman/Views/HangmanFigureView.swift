import SwiftUI

struct HangmanFigureView: View {
    let wrongGuessCount: Int
    let maximumWrongGuesses: Int

    var body: some View {
        VStack(spacing: 10) {
            Image(
                systemName: figureSymbol
            )
            .font(.system(size: 64))
            .foregroundStyle(
                wrongGuessCount == 0
                ? Color.secondary
                : Color.primary
            )

            Text(
                "\(wrongGuessCount) of \(maximumWrongGuesses) wrong"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(height: 100)
    }

    private var figureSymbol: String {
        switch wrongGuessCount {
        case 0:
            return "person"

        case 1:
            return "person.fill"

        case 2:
            return "figure.stand"

        case 3:
            return "figure.walk"

        case 4:
            return "figure.run"

        case 5:
            return "figure.fall"

        default:
            return "xmark.circle.fill"
        }
    }
}
