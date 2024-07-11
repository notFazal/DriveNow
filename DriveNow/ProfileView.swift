import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sideMenuState: SideMenuState
    @State private var isSearching = false  // Not used, but necessary for binding
    @State private var searchText = ""      // Not used, but necessary for binding

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Spacer()
                Text("Profile Page")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                Spacer()
            }

            TopBarView(
                title: "Profile Page",
                leftIconName: "line.3.horizontal",
                leftButtonAction: { sideMenuState.showMenu.toggle() },
                rightIconName: nil,
                rightButtonAction: nil,
                showSearchBar: false,
                isSearching: $isSearching,
                searchText: $searchText
            )
        }
        .background(Color.black)
    }
}

#Preview {
    ProfileView()
        .environmentObject(SideMenuState())
}
