import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

class SideMenuState: ObservableObject {
    @Published var showMenu: Bool = false
}


struct SideMenuView: View {
    @Binding var isShowing: Bool
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }

                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenu()
                        Spacer()
                        Button(action: {
                            Task {
                                do {
                                    try viewModel.signOut()
                                    print("Sign out successful, should show sign-in view now.")
                                } catch {
                                    print("Sign out error: \(error)")
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.left.square.fill")
                                    .foregroundColor(.white)
                                Text("Sign Out")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding()
                        .frame(maxWidth: 130, alignment: .leading)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    .padding()
                    .frame(width: 325, alignment: .leading)
                    .background(Color.black)

                    Spacer()
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut, value: isShowing)
            }
        }
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
