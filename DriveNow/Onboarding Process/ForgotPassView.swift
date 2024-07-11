import SwiftUI

struct ForgotPassView: View {
    
    @StateObject private var viewModel: SignInViewModel
    @Binding var authenticationStep: AuthenticationStep
    @Binding var isSignedIn: Bool
    @State private var isSuccessDialogActive: Bool = false
    @State private var isErrorDialogActive: Bool = false
    @State private var errorMessage: String = ""
    
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
                    //.padding(.vertical)
                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            isSuccessDialogActive = true
                        } catch {
                            errorMessage = error.localizedDescription
                            isErrorDialogActive = true
                        }
                    }
                } label: {
                    Text("Reset Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.vertical)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Enter your Email")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleTextColor(.white)
            .navigationBarItems(leading: Button(action: {
                authenticationStep = .signIn
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.white)
            })
            .background(.black)
            .overlay {
                if isSuccessDialogActive {
                    CustomDialog(
                        isActive: $isSuccessDialogActive,
                        title: "Email Sent",
                        message: "A password reset link has been sent to your email address. Please check your inbox and follow the instructions to reset your password.",
                        buttonTitle: "Close"
                    ) {
                        isSuccessDialogActive = false
                    }
                }
            }
            .overlay {
                if isErrorDialogActive {
                    CustomDialog(
                        isActive: $isErrorDialogActive,
                        title: "Error",
                        message: errorMessage,
                        buttonTitle: "Close"
                    ) {
                        isErrorDialogActive = false
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPassView(authenticationStep: .constant(.forgotPass), isSignedIn: .constant(false))
}
