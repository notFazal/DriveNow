import SwiftUI

struct NotesView: View {
    @EnvironmentObject var sideMenuState: SideMenuState
    @State private var isSearching = false  // Not used, but necessary for binding
    @State private var searchText = ""      // Not used, but necessary for binding

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Spacer()
                Text("Notes Page")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                Spacer()
            }

            
            TopBarView(
                title: "Notes Page",
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
        NotesView()
        .environmentObject(SideMenuState())
}
