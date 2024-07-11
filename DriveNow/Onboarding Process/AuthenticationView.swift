import SwiftUI

enum AuthenticationStep {
    case signIn, signUp, forgotPass, profComplete
}

struct AuthenticationView: View {
    @State private var authenticationViewStep: AuthenticationStep = .signIn
    @Binding var isSignedIn: Bool
    
    var body: some View {
        VStack {
            switch authenticationViewStep {
            case .signIn:
                SignInView(authenticationStep: $authenticationViewStep, isSignedIn: $isSignedIn)
            case .signUp:
                SignUpView(authenticationStep: $authenticationViewStep, isSignedIn: $isSignedIn)
            case .forgotPass:
                ForgotPassView(authenticationStep: $authenticationViewStep, isSignedIn: $isSignedIn)
            case .profComplete:
                ProfileCompletionView(isSignedIn: $isSignedIn)
            }
        }
    }
}

#Preview {
    AuthenticationView(isSignedIn: .constant(false))
}
