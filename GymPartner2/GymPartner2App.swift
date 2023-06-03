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
    
    @AppStorage("signIn") var isSignIn = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
            WindowGroup {
                if !isSignIn {
                    AuthView(auth: $isSignIn)
                        .onOpenURL { url in
                                  GIDSignIn.sharedInstance.handle(url)
                                }
                } else {
                    ContentView(fname: "James")
                }
            }
        }
}

