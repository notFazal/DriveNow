import SwiftUI
import FirebaseFirestore

@MainActor
final class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Binding var authenticationStep: AuthenticationStep
    @Published var notVerified: Bool = false
    @Published var notEmployee: Bool = false
    @Binding var isSignedIn: Bool
    
    init(authenticationStep: Binding<AuthenticationStep>, isSignedIn: Binding<Bool>) {
        self._authenticationStep = authenticationStep
        self._isSignedIn = isSignedIn
    }
    
    func resetPassword() async throws {
        guard !email.isEmpty else {
            print("Email is empty.")
            return
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let user = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        if try AuthenticationManager.shared.isEmailVerified() {
            if try await AuthenticationManager.shared.profileCompleted(uid: user.uid) {
                isSignedIn = true
            } else {
                authenticationStep = .profComplete
            }
        } else {
            print("Email is not verified. Please check your email for verification.")
            notVerified = true
            return
        }
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let employeeStatus = try await AuthenticationManager.shared.isEmployee(email: email)
        
        guard employeeStatus else {
            print("Email is not registered as an employee.")
            notEmployee = true
            return
        }
        
        let user = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        if try AuthenticationManager.shared.isEmailVerified() {
            print("Email is verified.")
        } else {
            print("Email is not verified. Please check your email for verification.")
            notVerified = true
            return
        }
    }
    
    func resendVerificationEmail() async throws {
        try await AuthenticationManager.shared.resendEmail()
    }
}

struct SignInView: View {
    
    @StateObject private var viewModel: SignInViewModel
    @State private var showDialog = false
    @State private var errorMessage = ""
    @Binding var authenticationStep: AuthenticationStep
    @Binding var isSignedIn: Bool
    
    init(authenticationStep: Binding<AuthenticationStep>, isSignedIn: Binding<Bool>) {
        _authenticationStep = authenticationStep
        _isSignedIn = isSignedIn
        _viewModel = StateObject(wrappedValue: SignInViewModel(authenticationStep: authenticationStep, isSignedIn: isSignedIn))
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                        } catch {
                            print("Sign In Error: \(error)")
                            errorMessage = error.localizedDescription
                            showDialog = true
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Spacer().frame(height: 20)
                
                HStack {
                    Button {
                        authenticationStep = .forgotPass
                    } label: {
                        Text("Forgot your password?")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                
            }
            .padding()
            .navigationTitle("Sign In to your account")
            .navigationBarTitleTextColor(.white)
            .navigationBarItems(trailing: Button(action: {
                authenticationStep = .signUp
            }) {
                Text("Sign Up")
            })
            .foregroundColor(.red)
            .overlay {
                if showDialog {
                    CustomDialog(isActive: $showDialog, title: "Sign In Failed", message: errorMessage, buttonTitle: "Close") {
                        showDialog = false
                    }
                }
            }
            .overlay {
                if viewModel.notVerified {
                    CustomDialog(isActive: $viewModel.notVerified, title: "Verify your email", message: "We have sent a verification link to \(viewModel.email). Click on the link to complete the verification process.", buttonTitle: "Resend Email") {
                        Task {
                            do {
                                try await viewModel.resendVerificationEmail()
                            } catch {
                                print("Resend Email Error: \(error)")
                                errorMessage = error.localizedDescription
                                showDialog = true
                            }
                            viewModel.notVerified = false
                        }
                    }
                }
            }
            .background(Color.black)
        }
    }
}

#Preview {
    SignInView(authenticationStep: .constant(.signIn), isSignedIn: .constant(false))
}
