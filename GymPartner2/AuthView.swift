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

    func handleSignInButton() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                  as? UIWindowScene)?.windows.first?.rootViewController
              else {return}
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController) { signInResult, error in
              guard let result = signInResult else {
                // Inspect error
                return
              }
                print("successful")
                // If sign in succeeded, display the app's main content View.
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
            AuthView()
        }
    }
    @State static var isAuthenticated = false
    @State static var isAwaitingAuth = false

}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    ///magic hack from
    ///https://www.youtube.com/watch?v=0ncKXZVaXOU
    ///i think this is to use UIKit alongside the swiftUI
    func getRootViewController()->UIViewController{
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else{
            fatalError("No root view controller found")
        }
        return rootViewController
    
    }
}
