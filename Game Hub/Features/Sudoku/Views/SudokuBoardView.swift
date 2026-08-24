import SwiftUI

struct SudokuBoardView: View {
    private let gridSize = 9

    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(gridSize)

            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { _ in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(
                                        width: cellSize,
                                        height: cellSize
                                    )
                                    .border(
                                        Color.secondary.opacity(0.35),
                                        width: 0.5
                                    )
                            }
                        }
                    }
                }

                SudokuGridLines()
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct SudokuGridLines: View {
    var body: some View {
        GeometryReader { geometry in
            let third = geometry.size.width / 3

            Path { path in
                for index in 0...3 {
                    let position = CGFloat(index) * third

                    path.move(to: CGPoint(x: position, y: 0))
                    path.addLine(
                        to: CGPoint(
                            x: position,
                            y: geometry.size.height
                        )
                    )

                    path.move(to: CGPoint(x: 0, y: position))
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
    SudokuBoardView()
        .padding()
}
