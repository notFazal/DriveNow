import SwiftUI

// Enum for managing tabs
enum Tab: String, CaseIterable {
    case house
    case personTextRectangle = "person.text.rectangle"
    case car2 = "car.2"
    case person3 = "person.3"
    case listBulletClipboard = "list.bullet.clipboard"
}

// Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    private var fillImage: String {
        /*
        if selectedTab == .magnifyingglass {
            return selectedTab.rawValue
        }
     */
        return selectedTab.rawValue + ".fill"
        
    }
     
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.gray)
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.1)) {
                            selectedTab = tab
                        }
                    }) {
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                            .foregroundColor(selectedTab == tab ? .red : .gray)
                            .font(.system(size: 22))
                            .frame(width: 50, height: 50) // Keeps the image size the same
                    }
                    .background(Color.clear)
                    .frame(width: 60, height: 60) // Increase the tappable area
                    .contentShape(Rectangle()) // Ensures the tappable area is a rectangle
                    Spacer()
                }
            }
            .frame(height: 60)
            .background(Color.black)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.house))
}

struct TopBarView: View {
    var title: String
    var leftIconName: String?  // Optional icon name for the left button
    var leftButtonAction: (() -> Void)?  // Optional action for the left button
    var rightIconName: String?  // Optional icon name for the right button
    var rightButtonAction: (() -> Void)?  // Optional action for the right button
    var showSearchBar: Bool
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if let leftIconName = leftIconName, let leftButtonAction = leftButtonAction {
                    Button(action: leftButtonAction) {
                        Image(systemName: leftIconName)
                            .bold()
                            .scaleEffect(1.6)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 25)
                    .frame(width: 50, height: 50) // Increase the tappable area
                    .contentShape(Rectangle()) // Ensures the tappable area is a rectangle
                }
                
                Text(title)
                    .bold()
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                    .scaleEffect(1.1, anchor: .leading)
                
                Spacer()
                
                if let rightIconName = rightIconName, let rightButtonAction = rightButtonAction {
                    Button(action: rightButtonAction) {
                        Image(systemName: rightIconName)
                            .foregroundColor(.white)
                            .scaleEffect(1.6)
                            .padding(.trailing, 30)
                    }
                    .frame(width: 50, height: 50) // Increase the tappable area
                    .contentShape(Rectangle()) // Ensures the tappable area is a rectangle
                }
            }
            .frame(height: 50)
            .background(Color.red)
            
            if showSearchBar {
                // Wrap the TextField to control background
                ZStack {
                    Color.red  // Apply background color to the ZStack to keep the TextField in place
                        .frame(height: 70)  // Set the height for the red background
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 25)
                }
            }
            
            Divider()
        }
    }
}

#Preview {
    TopBarView(
        title: "Preview",
        leftIconName: "line.3.horizontal",
        leftButtonAction: {},
        rightIconName: "bell",
        rightButtonAction: {},
        showSearchBar: false,
        isSearching: .constant(false),
        searchText: .constant("")
    )
}


/*
struct TopBarView: View {
    var title: String
    var menuButton: () -> Void
    var rightIconName: String?
    var extraButton: (() -> Void)?
    var showSearchBar: Bool
    @Binding var searchText: String  // Removed isSearching for simplicity
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: menuButton) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.white)
                        .bold().scaleEffect(1.6)
                }
                .padding(.leading, 25)
                
                Text(title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .scaleEffect(1.1, anchor: .leading)
                
                if showSearchBar {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 25)
                }
                
                Spacer()
                
                if let iconName = rightIconName, let action = extraButton {
                    Button(action: action) {
                        Image(systemName: iconName)
                            .foregroundColor(.white)
                            .scaleEffect(1.6)
                            .padding(.trailing, 30)
                    }
                }
            }
            .frame(height: 50)
            .background(Color.red)
            
            Divider()
        }
    }
}
*/


/*
// Main Container View
struct MainContainerView: View {
    @State private var selectedTab: Tab = .house
    @State private var isSearching = false
    @State private var searchText = ""

    var body: some View {
        VStack {
            TopBarView(
                title: "DriveNow",
                menuButton: { print("Menu tapped") },
                rightIconName: selectedTab == .house ? "plus" : nil,
                extraButton: selectedTab == .house ? { print("Plus button tapped") } : nil,
                isSearching: $isSearching,
                searchText: $searchText
            )
            Spacer()

            // Assuming you have a custom tab bar implementation
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerView()
    }
}
*/
