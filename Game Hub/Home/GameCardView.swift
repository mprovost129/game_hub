import SwiftUI

struct GameCardView: View {
    let game: GameDefinition

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBackground)

                    Image(systemName: game.systemImage)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
                .frame(width: 48, height: 48)

                Spacer()

                availabilityBadge
            }

            Spacer()

            VStack(alignment: .leading, spacing: 5) {
                Text(game.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        game.isAvailable
                        ? Color.primary
                        : Color.secondary
                    )

                Text(game.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 166)
        .background(cardBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    borderColor,
                    lineWidth: game.isAvailable ? 1.25 : 1
                )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .opacity(game.isAvailable ? 1 : 0.72)
    }

    @ViewBuilder
    private var availabilityBadge: some View {
        if game.isAvailable {
            Text("PLAY")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)
        } else {
            Label(
                "SOON",
                systemImage: "lock.fill"
            )
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(.secondary)
        }
    }

    private var cardBackground: some ShapeStyle {
        game.isAvailable
        ? AnyShapeStyle(Color.accentColor.opacity(0.06))
        : AnyShapeStyle(.thinMaterial)
    }

    private var iconBackground: Color {
        game.isAvailable
        ? Color.accentColor.opacity(0.14)
        : Color.secondary.opacity(0.10)
    }

    private var iconColor: Color {
        game.isAvailable
        ? Color.accentColor
        : Color.secondary
    }

    private var borderColor: Color {
        game.isAvailable
        ? Color.accentColor.opacity(0.28)
        : Color.secondary.opacity(0.12)
    }
}

#Preview {
    HStack {
        GameCardView(
            game: .sudoku
        )

        GameCardView(
            game: .hangman
        )
    }
    .padding()
}
