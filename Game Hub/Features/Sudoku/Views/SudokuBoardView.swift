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
                                    isSelected: viewModel.isSelected(cell),
                                    isPeer: viewModel.isPeerOfSelectedCell(cell),
                                    hasSameValue: viewModel.hasSameValueAsSelectedCell(cell),
                                    isIncorrect: viewModel.isIncorrect(cell)
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
    let isPeer: Bool
    let hasSameValue: Bool
    let isIncorrect: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)

            Rectangle()
                .stroke(
                    Color.secondary.opacity(0.35),
                    lineWidth: 0.5
                )

            if let value = cell.value {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(cell.isGiven ? .semibold : .regular)
                    .foregroundStyle(numberColor)
            } else if !cell.notes.isEmpty {
                SudokuNotesView(notes: cell.notes)
                    .padding(2)
            }
        }
    }

    private var numberColor: Color {
        if cell.isGiven {
            return .primary
        }

        if isIncorrect {
            return .red
        }

        return .accentColor
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor.opacity(0.22)
        }

        if hasSameValue {
            return Color.accentColor.opacity(0.14)
        }

        if isPeer {
            return Color.accentColor.opacity(0.07)
        }

        return Color.clear
    }
}

private struct SudokuNotesView: View {
    let notes: Set<Int>

    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / 3
            let cellHeight = geometry.size.height / 3

            ForEach(1...9, id: \.self) { number in
                if notes.contains(number) {
                    let index = number - 1
                    let row = index / 3
                    let column = index % 3

                    Text("\(number)")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .frame(
                            width: cellWidth,
                            height: cellHeight
                        )
                        .position(
                            x: cellWidth * CGFloat(column) + cellWidth / 2,
                            y: cellHeight * CGFloat(row) + cellHeight / 2
                        )
                }
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
