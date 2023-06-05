//
//  ContentView.swift
//  GymPartner2
//
//  Created by James Gasek on 6/2/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


enum ViewSelection{
    case home
    case workout
    case profile
}

struct ProfileView: View{
    
    var logoutCallBack: () -> Void

    let currentUser = Auth.auth().currentUser
    
    func signOut() {
            do {
                try Auth.auth().signOut()
                ///callback goes to contentView, then to GymPartner2App.swift
                logoutCallBack()
                
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Button(action: {
                    signOut()
                }){
                    Text("Sign Out")
                }
                .padding()
                
                Text("Current E-Mail: " + (currentUser?.email ?? "no user"))
                    .padding()
                
                Text("Current UID: " + (currentUser?.uid ?? "NA"))
                    .padding()
                
                Spacer()
            }
            Spacer()
        }
        }
    }

struct MainView: View{
    
    let fname: String
    
    init(fname: String) {
        self.fname = fname
    }
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text("Welcome Back, " + fname)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Text("Your personal gym partner")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

struct ContentView: View {
    
    var logoutCallBack: () -> Void
    
    let fname: String
    @State var currentView: ViewSelection
    
    init(fname: String, logoutCallBack: @escaping () -> Void = {}) {
        
        self.fname = fname
        self.currentView = .home
        self.logoutCallBack = logoutCallBack
        
        ///this is the entry point for the entire app, after authenticaiton is successful.
        
        let db = Firestore.firestore()
        
        let currentUser = Auth.auth().currentUser

        let docRef = db.collection("users").document(currentUser?.uid ?? "NA")
        

        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                print("User exists in the system")
            } else {
                print("First time user logged into the system")
            
                docRef.setData(["field1": "value1", "field2": "value2"]) { error in
                
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully with custom ID")
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        TabView {
            MainView(fname: fname)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Text("Workout")
                .tabItem {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Workout")
                }
            ProfileView(logoutCallBack: logoutCallBack)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(fname: "James")
    }
}
