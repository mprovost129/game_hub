import SwiftUI

struct SudokuNumberPadView: View {
    let onNumberSelected: (Int) -> Void
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

#Preview {
    SudokuNumberPadView(
        onNumberSelected: { number in
            print(number)
        },
        onErase: {
            print("Erase")
        }
    )
    .padding()
}
