import SwiftUI

struct HangmanFigureView: View {
    let wrongGuessCount: Int
    let maximumWrongGuesses: Int

    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                ZStack {
                    gallowsPath(
                        width: width,
                        height: height
                    )
                    .stroke(
                        Color.primary,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )

                    if wrongGuessCount >= 1 {
                        headView(
                            width: width,
                            height: height
                        )
                    }

                    if wrongGuessCount >= 2 {
                        bodyPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: bodyStroke
                        )
                    }

                    if wrongGuessCount >= 3 {
                        leftArmPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: bodyStroke
                        )
                    }

                    if wrongGuessCount >= 4 {
                        rightArmPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: bodyStroke
                        )
                    }

                    if wrongGuessCount >= 5 {
                        leftLegPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: bodyStroke
                        )
                    }

                    if wrongGuessCount >= 6 {
                        rightLegPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: bodyStroke
                        )
                    }
                }
            }
            .frame(height: 220)

            Text(
                "\(wrongGuessCount) of \(maximumWrongGuesses) wrong"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private var bodyStroke: StrokeStyle {
        StrokeStyle(
            lineWidth: 4,
            lineCap: .round,
            lineJoin: .round
        )
    }

    // MARK: - Gallows

    private func gallowsPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        let uprightX = width * 0.28
        let beamY = height * 0.08
        let ropeX = width * 0.68

        // Base
        path.move(
            to: CGPoint(
                x: width * 0.12,
                y: height * 0.92
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.48,
                y: height * 0.92
            )
        )

        // Upright
        path.move(
            to: CGPoint(
                x: uprightX,
                y: height * 0.92
            )
        )

        path.addLine(
            to: CGPoint(
                x: uprightX,
                y: beamY
            )
        )

        // Top beam
        path.addLine(
            to: CGPoint(
                x: ropeX,
                y: beamY
            )
        )

        // Rope
        //
        // This stops exactly at the top of the head.
        path.addLine(
            to: CGPoint(
                x: ropeX,
                y: height * 0.215
            )
        )

        return path
    }

    // MARK: - Head

    @ViewBuilder
    private func headView(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        let headDiameter = width * 0.12

        Circle()
            .stroke(
                Color.primary,
                lineWidth: 4
            )
            .frame(
                width: headDiameter,
                height: headDiameter
            )
            .position(
                x: width * 0.68,
                y: height * 0.275
            )
    }

    // MARK: - Body

    private func bodyPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        // Starts at bottom center of head.
        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.335
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.64
            )
        )

        return path
    }

    // MARK: - Arms

    private func leftArmPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.40
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.56,
                y: height * 0.52
            )
        )

        return path
    }

    private func rightArmPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.40
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.80,
                y: height * 0.52
            )
        )

        return path
    }

    // MARK: - Legs

    private func leftLegPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.64
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.58,
                y: height * 0.82
            )
        )

        return path
    }

    private func rightLegPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.64
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.78,
                y: height * 0.82
            )
        )

        return path
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            ForEach(0...6, id: \.self) { stage in
                VStack(spacing: 8) {
                    Text("\(stage) wrong")
                        .font(.headline)

                    HangmanFigureView(
                        wrongGuessCount: stage,
                        maximumWrongGuesses: 6
                    )
                }
            }
        }
        .padding()
    }
}
