import SwiftUI

struct SudokuCompletionView: View {
    let time: String
    let mistakes: Int
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text("Puzzle Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Nice work.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 40) {
                VStack(spacing: 6) {
                    Image(systemName: "clock")

                    Text(time)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Time")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 6) {
                    Image(systemName: "xmark.circle")

                    Text("\(mistakes)")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Mistakes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                onDone()
            } label: {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(32)
    }
}

#Preview {
    SudokuCompletionView(
        time: "08:24",
        mistakes: 2,
        onDone: {}
    )
}
