import SwiftUI

struct WordGridBoardView: View {
    @Bindable var viewModel: WordGridViewModel

    @State private var cellFrames:
        [UUID: CGRect] = [:]

    private let columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 10
        ),
        count: 4
    )

    var body: some View {
        ZStack {
            selectionPath

            LazyVGrid(
                columns: columns,
                spacing: 10
            ) {
                ForEach(
                    viewModel.game.cells
                ) { cell in
                    cellView(cell)
                        .background {
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(
                                        key:
                                            WordGridCellFramePreferenceKey.self,
                                        value: [
                                            cell.id:
                                                geometry.frame(
                                                    in: .named(
                                                        "wordGrid"
                                                    )
                                                )
                                        ]
                                    )
                            }
                        }
                }
            }
        }
        .coordinateSpace(
            name: "wordGrid"
        )
        .onPreferenceChange(
            WordGridCellFramePreferenceKey.self
        ) { frames in
            cellFrames = frames
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(
                minimumDistance: 0,
                coordinateSpace: .named(
                    "wordGrid"
                )
            )
            .onChanged { value in
                handleDrag(
                    at: value.location
                )
            }
        )
    }

    private var selectionPath: some View {
        Canvas { context, _ in
            let points = viewModel.selectedCellIDs
                .compactMap { id -> CGPoint? in
                    guard let frame = cellFrames[id] else {
                        return nil
                    }

                    return CGPoint(
                        x: frame.midX,
                        y: frame.midY
                    )
                }

            guard points.count >= 2 else {
                return
            }

            var path = Path()

            path.move(
                to: points[0]
            )

            for point in points.dropFirst() {
                path.addLine(
                    to: point
                )
            }

            context.stroke(
                path,
                with: .color(
                    Color.accentColor.opacity(0.55)
                ),
                style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
        .allowsHitTesting(false)
    }

    private func cellView(
        _ cell: WordGridCell
    ) -> some View {
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
        .contentShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
        .onTapGesture {
            viewModel.selectCell(cell)
        }
    }

    private func handleDrag(
        at location: CGPoint
    ) {
        guard
            let cellID = cellFrames.first(
                where: {
                    $0.value.contains(location)
                }
            )?.key,
            let cell = viewModel.game.cells.first(
                where: {
                    $0.id == cellID
                }
            )
        else {
            return
        }

        viewModel.selectCellDuringDrag(
            cell
        )
    }
}

private struct WordGridCellFramePreferenceKey:
    PreferenceKey {

    static var defaultValue:
        [UUID: CGRect] = [:]

    static func reduce(
        value: inout [UUID: CGRect],
        nextValue: () -> [UUID: CGRect]
    ) {
        value.merge(
            nextValue(),
            uniquingKeysWith: {
                _, new in new
            }
        )
    }
}
