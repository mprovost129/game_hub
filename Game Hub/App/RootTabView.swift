import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(
                        "Games",
                        systemImage: "square.grid.2x2"
                    )
                }

            GameHubStatisticsView()
                .tabItem {
                    Label(
                        "Stats",
                        systemImage: "chart.bar"
                    )
                }

            GameHubSettingsView()
                .tabItem {
                    Label(
                        "Settings",
                        systemImage: "gearshape"
                    )
                }
        }
    }
}

#Preview {
    RootTabView()
}
