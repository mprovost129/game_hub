import SwiftUI

struct SudokuView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Sudoku")
                .font(.largeTitle)
                .fontWeight(.bold)

            SudokuBoardView()

            Spacer()
        }
        .padding()
        .navigationTitle("Sudoku")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SudokuView()
    }
}
