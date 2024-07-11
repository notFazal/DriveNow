import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileCompletionView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @Binding var isSignedIn: Bool
    
    var body: some View {
        VStack {
            Text("Complete your profile")
                .font(.largeTitle)
                .padding()

            TextField("First Name", text: $firstName)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.bottom, 10)

            TextField("Last Name", text: $lastName)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.bottom, 20)

            Button(action: {
                Task {
                    do {
                        try await saveProfile()
                        isSignedIn = true
                    } catch {
                        print("Error saving profile: \(error)")
                    }
                }
            }) {
                Text("Complete Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }

    private func saveProfile() async throws {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }

        let docRef = db.collection("employees").document(user.uid)
        try await docRef.setData([
            "firstName": firstName,
            "lastName": lastName
        ], merge: true)
    }
}

#Preview {
    ProfileCompletionView(isSignedIn: .constant(false))
}
