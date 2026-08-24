import SwiftUI

struct SudokuNumberPadView: View {
    let isNotesMode: Bool
    let onNumberSelected: (Int) -> Void
    let onErase: () -> Void
    let onNotesToggle: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ForEach(1...9, id: \.self) { number in
                    Button {
                        onNumberSelected(number)
                    } label: {
                        Text("\(number)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                    .buttonStyle(.bordered)
                }
            }

            HStack(spacing: 12) {
                if isNotesMode {
                    Button {
                        onNotesToggle()
                    } label: {
                        notesLabel
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button {
                        onNotesToggle()
                    } label: {
                        notesLabel
                    }
                    .buttonStyle(.bordered)
                }

                Button {
                    onErase()
                } label: {
                    Label("Erase", systemImage: "eraser")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var notesLabel: some View {
        Label(
            isNotesMode ? "Notes On" : "Notes",
            systemImage: "pencil"
        )
        .font(.headline)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}

#Preview {
    SudokuNumberPadView(
        isNotesMode: true,
        onNumberSelected: { number in
            print(number)
        },
        onErase: {
            print("Erase")
        },
        onNotesToggle: {
            print("Notes")
        }
    )
    .padding()
}
