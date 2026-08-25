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
                        Circle()
                            .stroke(
                                Color.primary,
                                lineWidth: 4
                            )
                            .frame(
                                width: width * 0.18,
                                height: width * 0.18
                            )
                            .position(
                                x: width * 0.68,
                                y: height * 0.28
                            )
                    }

                    if wrongGuessCount >= 2 {
                        bodyPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        )
                    }

                    if wrongGuessCount >= 3 {
                        leftArmPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        )
                    }

                    if wrongGuessCount >= 4 {
                        rightArmPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        )
                    }

                    if wrongGuessCount >= 5 {
                        leftLegPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        )
                    }

                    if wrongGuessCount >= 6 {
                        rightLegPath(
                            width: width,
                            height: height
                        )
                        .stroke(
                            Color.primary,
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
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

    private func gallowsPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

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
                x: width * 0.28,
                y: height * 0.92
            )
        )
        path.addLine(
            to: CGPoint(
                x: width * 0.28,
                y: height * 0.08
            )
        )

        // Top beam
        path.addLine(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.08
            )
        )

        // Rope
        path.addLine(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.18
            )
        )

        return path
    }

    private func bodyPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.38
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

    private func leftArmPath(
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: width * 0.68,
                y: height * 0.46
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.56,
                y: height * 0.56
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
                y: height * 0.46
            )
        )

        path.addLine(
            to: CGPoint(
                x: width * 0.80,
                y: height * 0.56
            )
        )

        return path
    }

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
                y: height * 0.80
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
                y: height * 0.80
            )
        )

        return path
    }
}

#Preview {
    VStack(spacing: 30) {
        HangmanFigureView(
            wrongGuessCount: 0,
            maximumWrongGuesses: 6
        )

        HangmanFigureView(
            wrongGuessCount: 6,
            maximumWrongGuesses: 6
        )
    }
    .padding()
}
