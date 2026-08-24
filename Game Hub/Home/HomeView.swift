import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Text("Game Hub")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Classic games. One app.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                NavigationLink {
                    SudokuStartView()
                } label: {
                    Text("Start Game")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)

                Spacer()
                    .frame(height: 40)
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
