import SwiftUI

struct HomeView: View {
    private let columns = [
        GridItem(
            .flexible(),
            spacing: 16
        ),
        GridItem(
            .flexible(),
            spacing: 16
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    LazyVGrid(
                        columns: columns,
                        spacing: 16
                    ) {
                        ForEach(GameDefinition.allGames) { game in
                            gameDestination(for: game)
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Game Hub")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Pick a game and start playing.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
    }

    @ViewBuilder
    private func gameDestination(
        for game: GameDefinition
    ) -> some View {
        if game.id == GameDefinition.sudoku.id {
            NavigationLink {
                SudokuStartView()
            } label: {
                GameCardView(
                    game: game
                )
            }
            .buttonStyle(.plain)
        } else {
            GameCardView(
                game: game
            )
        }
    }
}

#Preview {
    HomeView()
}
