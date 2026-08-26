import SwiftUI

struct WordGridBoardView: View {
    @Bindable var viewModel: WordGridViewModel

    private let columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 10
        ),
        count: 4
    )

    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 10
        ) {
            ForEach(
                viewModel.game.cells
            ) { cell in
                Button {
                    viewModel.selectCell(cell)
                } label: {
                    Text(
                        String(cell.letter)
                    )
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(
                        1,
                        contentMode: .fit
                    )
                    .background(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                        .fill(
                            viewModel.isSelected(cell)
                            ? Color.accentColor.opacity(0.18)
                            : Color.secondary.opacity(0.10)
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                        .stroke(
                            viewModel.isSelected(cell)
                            ? Color.accentColor
                            : Color.secondary.opacity(0.18),
                            lineWidth:
                                viewModel.isSelected(cell)
                                ? 2
                                : 1
                        )
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}
