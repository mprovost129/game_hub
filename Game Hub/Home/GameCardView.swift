import SwiftUI

struct GameCardView: View {
    let game: GameDefinition

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: game.systemImage)
                    .font(.system(size: 30, weight: .semibold))

                Spacer()

                if !game.isAvailable {
                    Text("COMING SOON")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(game.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color.secondary.opacity(0.15),
                    lineWidth: 1
                )
        }
        .opacity(game.isAvailable ? 1 : 0.55)
    }
}
