import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sideMenuState: SideMenuState
    @State private var isSearching = false  // Not used, but necessary for binding
    @State private var searchText = ""
    @State private var showTimeClockView = false  // State to manage the navigation

    var firstName: String = "Fazal"

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting and user info
                    Text("Hey there, \(firstName)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                        .padding(.horizontal, 5)

                    // Current status card
                    CardView(
                        iconName: "clock.fill",
                        title: "Current status",
                        detail: "Clocked in",
                        linkText: "View time clock",
                        action: { showTimeClockView = true }  // Set the action to show the TimeClockView
                    )
                    // Schedule card
                    CardView(
                        iconName: "calendar",
                        title: "Your schedule",
                        detail: "Entertainment TA - 2:00pm - 6:00pm",
                        linkText: "View full schedule",
                        action: {}
                    )
                }
                .padding()
            }

            TopBarView(
                title: "Drive Now",
                leftIconName: "line.3.horizontal",
                leftButtonAction: { sideMenuState.showMenu.toggle() },
                rightIconName: nil,
                rightButtonAction: {
                    // Your custom action here
                },
                showSearchBar: false,
                isSearching: $isSearching,
                searchText: $searchText
            )
        }
        .fullScreenCover(isPresented: $showTimeClockView) {
            TimeClockView(isTimeClockViewPresented: $showTimeClockView)  // Present the TimeClockView with binding
                .environmentObject(sideMenuState)
        }
    }
}

// Reusable card view component
struct CardView: View {
    var iconName: String
    var title: String
    var detail: String
    var linkText: String
    var action: () -> Void  // Add an action parameter

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.red)
                    .imageScale(.large)
                Text(title)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
            }

            Text(detail)
                .font(.headline)
                .foregroundColor(.gray)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: action) {  // Use the action parameter
                Text(linkText)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(SideMenuState())
}
