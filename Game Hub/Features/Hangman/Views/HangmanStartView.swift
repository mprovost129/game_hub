import SwiftUI

struct HangmanStartView: View {
    @State private var selectedCategory: HangmanCategory = .everyday

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "character.textbox")
                .font(.system(size: 56))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 8) {
                Text("Hangman")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Choose a category")
                    .foregroundStyle(.secondary)
            }

            Picker(
                "Category",
                selection: $selectedCategory
            ) {
                ForEach(HangmanCategory.allCases) { category in
                    Text(category.rawValue)
                        .tag(category)
                }
            }
            .pickerStyle(.menu)

            NavigationLink {
                HangmanView(
                    category: selectedCategory
                )
            } label: {
                Text("Start Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Hangman")
        .navigationBarTitleDisplayMode(.inline)
    }
}
