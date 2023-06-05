//
//  LaunchScreen.swift
//  GymPartner2
//
//  Created by James Gasek on 6/4/23.
//

import SwiftUI

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Text("YourLogo")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 200, height: 200)
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}


struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
