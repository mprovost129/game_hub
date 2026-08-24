import SwiftUI

struct SudokuBoardView: View {
    @Bindable var viewModel: SudokuViewModel

    private let gridSize = 9

    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(gridSize)

            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize, id: \.self) { column in
                                let index = row * gridSize + column
                                let cell = viewModel.puzzle.cells[index]

                                SudokuCellView(
                                    cell: cell,
                                    isSelected: viewModel.isSelected(cell)
                                )
                                .frame(
                                    width: cellSize,
                                    height: cellSize
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.selectCell(cell)
                                }
                            }
                        }
                    }
                }

                SudokuGridLines()
                    .allowsHitTesting(false)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct SudokuCellView: View {
    let cell: SudokuCell
    let isSelected: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    isSelected
                    ? Color.accentColor.opacity(0.15)
                    : Color.clear
                )

            Rectangle()
                .stroke(
                    Color.secondary.opacity(0.35),
                    lineWidth: 0.5
                )

            if let value = cell.value {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(cell.isGiven ? .semibold : .regular)
            }
        }
    }
}

private struct SudokuGridLines: View {
    var body: some View {
        GeometryReader { geometry in
            let third = geometry.size.width / 3

            Path { path in
                for index in 0...3 {
                    let position = CGFloat(index) * third

                    path.move(
                        to: CGPoint(
                            x: position,
                            y: 0
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: position,
                            y: geometry.size.height
                        )
                    )

                    path.move(
                        to: CGPoint(
                            x: 0,
                            y: position
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: geometry.size.width,
                            y: position
                        )
                    )
                }
            }
            .stroke(.primary, lineWidth: 2)
        }
    }
}

#Preview {
    SudokuBoardView(
        viewModel: SudokuViewModel()
    )
    .padding()
}
