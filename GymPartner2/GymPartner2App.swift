//
//  GymPartner2App.swift
//  GymPartner2
//
//  Created by James Gasek on 6/2/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct GymPartner2App: App {
    
    @State private var userIsSignedIn: Bool
    
            
    init() {
        FirebaseApp.configure()
        _userIsSignedIn = State(initialValue: Auth.auth().currentUser != nil)
    }
    
    
    func logoutCallBack(){userIsSignedIn = false}
    
    func loginCallBack(){ userIsSignedIn = true}
    
    var body: some Scene {
        WindowGroup {
            
            if userIsSignedIn {
                ContentView(fname: "James", logoutCallBack: logoutCallBack)
                
            } else {
                AuthView(loginCallBack: self.loginCallBack)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            }
        }
    }
}
