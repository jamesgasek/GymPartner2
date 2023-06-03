//
//  AuthView.swift
//  GymPartner
//
//  Created by James Gasek on 1/15/23.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
///mixed instructions from https://developers.google.com/identity/sign-in/ios/start-integrating
///and from https://firebase.google.com/docs/auth/ios/google-signin (makes no mention of GoogInSwift)
import GoogleSignInSwift


struct AuthView: View {

    @Binding var auth: Bool
    
    func handleSignInButton() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                  as? UIWindowScene)?.windows.first?.rootViewController
              else {return}
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController) { result, error in
                ///make sure we have no errors
                guard error == nil
                else {
                    print("error during GIDSignIn in AuthVIew")
                    return
                }
                ///get the user from the result optional if possible
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else {
                    print("error getting user from result in GIDSignIn in AuthView")
                    return
                }
                ///finally, create the credential object
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                            accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { result, error in

                  print("successful firebase authentication!! 🤣")
                    auth = true
                }
            }
        }
    
    var body: some View {
        ZStack{
            
            Color("White")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("GymPartner")
                    .font(.largeTitle.italic())
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .padding(15)
                    .background(Color("Green"))
                    .cornerRadius(1)
                
                Spacer()
                VStack{
                    ///begin signin with google button
                    GoogleSignInButton(action: {handleSignInButton()})
                        .frame(width: 300, height: 50)
                    ///end signin with google button
                    
                    
                    ///begin signin with apple buttom
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    }) { (result) in
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                
                                let userIdentifier = appleIDCredential.user
                                let fullName = appleIDCredential.fullName
                                let email = appleIDCredential.email
                                
                                print("User ID: \(userIdentifier)")
                                print("Full Name: \(String(describing: fullName))")
                                print("Email: \(String(describing: email))")
                                print("Authorization Code: \(String(describing: appleIDCredential.authorizationCode))")
                                print("Identity Token: \(String(describing: appleIDCredential.identityToken))")
                                
                                ///this all pulls from the apple API and does not interface with firebase until this point
                                
                                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: String(describing: appleIDCredential.identityToken), rawNonce: "nonce")
                                
                                ///this is a firebase call- not sure if this uses the apple route TODO
                                Auth.auth().signIn(with: credential) { (authResult, error) in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    print("User is signed in with Firebase")
                                }
                            default:
                                break
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .frame(width: 300, height: 50)
                    ///end apple sign in
                    
                }
            }
        }
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthView(auth: .constant(false))
        }
    }
    @State static var isAuthenticated = false
    @State static var isAwaitingAuth = false

}
