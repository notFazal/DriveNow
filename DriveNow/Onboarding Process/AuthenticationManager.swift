import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authDataResult.user
        
        // Send verification email
        try await user.sendEmailVerification()

        return AuthDataResultModel(user: user)
    }

    func resendEmail() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        // Send verification email
        try await user.sendEmailVerification()
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func isEmailVerified() throws -> Bool {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return user.isEmailVerified
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func isEmployee(email: String) async throws -> Bool {
        let db = Firestore.firestore()
        let normalizedEmail = email.lowercased()
        let docRef = db.collection("verifiedEmployees").document("emails")
        
        print("Checking if \(normalizedEmail) is an employee.") // Debugging statement
        
        let doc = try await docRef.getDocument()
        
        if let emailList = doc.data()?["emailList"] as? [String] {
            let normalizedEmailList = emailList.map { $0.lowercased() } // Ensure the list is also lowercased
            print("Document path: \(docRef.path)") // Debugging statement
            print("Email list: \(normalizedEmailList)") // Debugging statement
            return normalizedEmailList.contains(normalizedEmail)
        }
        
        return false
    }
    
    func profileCompleted(uid: String) async throws -> Bool {
        let db = Firestore.firestore()
        let docRef = db.collection("employees").document(uid)
        
        print("Checking if \(uid) profile is completed.")
        
        let doc = try? await docRef.getDocument()
        
        if let data = doc?.data() {
            if let firstName = data["firstName"] as? String, !firstName.isEmpty,
               let lastName = data["lastName"] as? String, !lastName.isEmpty {
                print("Profile completed: \(firstName) \(lastName)")
                return true
            }
        } else {
            // Create document if it does not exist
            try await docRef.setData([
                "firstName": "",
                "lastName": ""
            ], merge: true)
        }
        
        print("Profile is not completed for \(uid)")
        return false
    }
}
