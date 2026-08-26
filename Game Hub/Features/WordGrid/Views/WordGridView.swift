import SwiftUI

struct WordGridView: View {
    @State private var viewModel =
        WordGridViewModel()

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text("SCORE")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(viewModel.score)")
                        .font(.title2)
                        .fontWeight(.bold)
                }

                Spacer()

                VStack(
                    alignment: .trailing,
                    spacing: 2
                ) {
                    Text("WORDS")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(
                        "\(viewModel.submittedWords.count)"
                    )
                    .font(.title2)
                    .fontWeight(.bold)
                }
            }

            VStack(spacing: 6) {
                Text("Build a Word")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(
                    "Tap touching letters."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Text(
                viewModel.currentWord.isEmpty
                ? "-"
                : viewModel.currentWord
            )
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(height: 48)

            WordGridBoardView(
                viewModel: viewModel
            )

            HStack(spacing: 12) {
                Button {
                    viewModel.clearSelection()
                } label: {
                    Label(
                        "Clear",
                        systemImage: "xmark"
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .buttonStyle(.bordered)

                Button {
                    viewModel.submitCurrentWord()
                } label: {
                    Label(
                        "Submit",
                        systemImage: "checkmark"
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    viewModel.currentWord.isEmpty
                )
            }

            submissionFeedback
                .font(.subheadline)

            Spacer()
        }
        .padding()
        .navigationTitle("Word Grid")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var submissionFeedback: some View {
        switch viewModel.lastSubmissionResult {
        case .accepted(
            let word,
            let points
        ):
            Label(
                "\(word)  +\(points)",
                systemImage: "checkmark.circle.fill"
            )
            .foregroundStyle(.green)

        case .tooShort:
            Label(
                "Words must be at least 3 letters.",
                systemImage: "exclamationmark.circle"
            )
            .foregroundStyle(.orange)

        case .invalidWord:
            Label(
                "Not a valid word.",
                systemImage: "xmark.circle"
            )
            .foregroundStyle(.red)

        case .alreadyFound:
            Label(
                "Already found.",
                systemImage: "arrow.counterclockwise.circle"
            )
            .foregroundStyle(.orange)

        case nil:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        WordGridView()
    }
}
