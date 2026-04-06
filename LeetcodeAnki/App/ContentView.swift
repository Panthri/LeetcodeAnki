import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cardStore: CardStore
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(onStartReview: { selectedTab = 1 })
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            StudyTabWrapper()
                .tabItem {
                    Label("Study", systemImage: "rectangle.stack.fill")
                }
                .tag(1)

            AppProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        .accentColor(.indigo)
    }
}

struct StudyTabWrapper: View {
    @EnvironmentObject var cardStore: CardStore
    @StateObject private var viewModel = StudyViewModel()

    var body: some View {
        StudyView(viewModel: viewModel)
            .onAppear {
                viewModel.loadSession(cards: cardStore.dueCards)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CardStore())
    }
}
