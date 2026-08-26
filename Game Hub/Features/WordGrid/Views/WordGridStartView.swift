import SwiftUI

struct WordGridStartView: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(
                systemName: "square.grid.3x3.fill"
            )
            .font(.system(size: 56))
            .foregroundStyle(
                Color.accentColor
            )

            VStack(spacing: 8) {
                Text("Word Grid")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Build words using touching letters."
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            }

            NavigationLink {
                WordGridView()
            } label: {
                Text("Start Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Word Grid")
        .navigationBarTitleDisplayMode(.inline)
    }
}
