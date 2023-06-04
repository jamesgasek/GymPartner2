//
//  ContentView.swift
//  GymPartner2
//
//  Created by James Gasek on 6/2/23.
//

import SwiftUI
import FirebaseAuth


enum ViewSelection{
    case home
    case workout
    case profile
}

struct BottomBar: View{
    
    @Binding var selectedView: ViewSelection
    
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    selectedView = .home
                }, label: {
                    Image(systemName: "house.fill")
                        .foregroundColor(.black)
                })
                Spacer()
                Button(action: {
                    selectedView = .workout
                }, label: {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(.black)
                        .font(.system(size: 50))
                    
                })
                Spacer()
                Button(action: {
                    selectedView = .profile
                selectedView = .profile
                }, label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                })
                Spacer()
            }
            .frame(height: 80)
            .background(Color.white)
        }
    }
}

struct ProfileView: View{
    
    var logoutCallBack: () -> Void

    func signOut() {
            do {
                try Auth.auth().signOut()
                // Perform any additional actions after sign out (e.g., navigate to the login screen)
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
                Text("Your personal gym partner")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .padding()
                Button(action: {
                    signOut()
                }){
                    Text("Sign Out")
                }
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
    }
    
    var body: some View {
        ZStack{
            BottomBar(selectedView: $currentView)
                .edgesIgnoringSafeArea(.all)
                .shadow(radius: 1)
            
            switch(currentView){
            case .home:
                MainView(fname: fname)
            case .workout:
                Text("Workout")
            case .profile:
                ProfileView(logoutCallBack: logoutCallBack)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(fname: "James")
    }
}
