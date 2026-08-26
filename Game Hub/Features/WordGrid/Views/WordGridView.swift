import SwiftUI

struct WordGridView: View {
    @State private var viewModel =
        WordGridViewModel()

    var body: some View {
        VStack(spacing: 24) {
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

            if let lastWord =
                viewModel.submittedWords.last {
                Text(
                    "Submitted: \(lastWord)"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Word Grid")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WordGridView()
    }
}
