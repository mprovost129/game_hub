import SwiftUI

struct SudokuNumberPadView: View {
    let isNotesMode: Bool
    let canUndo: Bool

    let onNumberSelected: (Int) -> Void
    let onNotesToggle: () -> Void
    let onUndo: () -> Void
    let onErase: () -> Void

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
                        notesControlLabel
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button {
                        onNotesToggle()
                    } label: {
                        notesControlLabel
                    }
                    .buttonStyle(.bordered)
                }

                Button {
                    onUndo()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.uturn.backward")
                        Text("Undo")
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                }
                .buttonStyle(.bordered)
                .disabled(!canUndo)

                Button {
                    onErase()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "eraser")
                        Text("Erase")
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var notesControlLabel: some View {
        VStack(spacing: 4) {
            Image(systemName: "pencil")
            Text(isNotesMode ? "Notes On" : "Notes")
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
        .frame(height: 52)
    }
}

#Preview {
    SudokuNumberPadView(
        isNotesMode: true,
        canUndo: true,
        onNumberSelected: { number in
            print(number)
        },
        onNotesToggle: {
            print("Notes")
        },
        onUndo: {
            print("Undo")
        },
        onErase: {
            print("Erase")
        }
    )
    .padding()
}
