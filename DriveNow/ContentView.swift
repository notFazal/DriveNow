import SwiftUI

// Change Nav Title
extension View {
    @available(iOS 16, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor]
        return self
    }
}

struct ContentView: View {
    @AppStorage("isSignedIn") var isSignedIn = false
    @StateObject private var sideMenuState = SideMenuState()
    @State private var selectedTab: Tab = .house
    @StateObject var dataManager = DataManager()
    
    var body: some View {
        Group {
            if isSignedIn {
                ZStack {
                    TabView(selection: $selectedTab) {
                        HomeView()
                            .environmentObject(sideMenuState)
                            .tag(Tab.house)
                        ProfileView()
                            .environmentObject(sideMenuState)
                            .tag(Tab.personTextRectangle)
                        CarsView(dataManager: dataManager)
                            .environmentObject(sideMenuState)
                            .tag(Tab.car2)
                        TeamView()
                            .environmentObject(sideMenuState)
                            .tag(Tab.person3)
                        NotesView()
                            .environmentObject(sideMenuState)
                            .tag(Tab.listBulletClipboard)
                    }
                    .onAppear {
                        dataManager.fetchCars()
                    }
                    
                    VStack {
                        Spacer()
                        CustomTabBar(selectedTab: $selectedTab)
                    }
                    
                    SideMenuView(isShowing: $sideMenuState.showMenu)
                }
                .ignoresSafeArea(.keyboard)
            } else {
                AuthenticationView(isSignedIn: $isSignedIn)
            }
        }
        .environmentObject(sideMenuState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

