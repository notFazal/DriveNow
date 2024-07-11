import SwiftUI

struct SignUpView: View {

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
                            try await viewModel.signUp()
                            return
                        } catch {
                            print("Sign Up Error: \(error)")
                            errorMessage = error.localizedDescription
                            showDialog = true
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Spacer().frame(height: 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up With Email")
            .navigationBarTitleTextColor(.white)
            .navigationBarItems(leading: Button(action: {
                authenticationStep = .signIn
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.white)
            })
            .overlay {
                if showDialog {
                    CustomDialog(isActive: $showDialog, title: "Sign Up Failed", message: errorMessage, buttonTitle: "Go to Sign In") {
                        authenticationStep = .signIn
                    }
                }
            }
            .overlay {
                if viewModel.notEmployee {
                    CustomDialog(isActive: $viewModel.notEmployee, title: "Not Registered as Employee", message: "You are not authorized to sign up. Please contact administrator to troubleshoot.", buttonTitle: "Close") {
                        viewModel.notEmployee = false
                    }
                }
            }
            .overlay {
                if viewModel.notVerified {
                    CustomDialog(isActive: $viewModel.notVerified, title: "Verify your email", message: "We have sent a verification link to \(viewModel.email) if it exists within the system. Click on the link to complete the verification process.", buttonTitle: "Resend Email") {
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
            .background(.black)
        }
    }
}

#Preview {
    SignUpView(authenticationStep: .constant(.signUp), isSignedIn: .constant(false))
}
