//
//  SplashView.swift
//  Complexity
//
//  Created by IE12 on 19/04/24.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
   
    @State private var isActive: Bool = false
    @State private var isFromLogout: Bool = false
    

    
    var body: some View {
        VStack(alignment: .center) {
            if isActive {
                if let token = UserDefaultManger.getToken(), !token.isEmpty {
                    HomeView()
                } else {
                    ContentView()
                }
            } else {
                Image("splash")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(maxWidth: .infinity)
        .onReceive(NotificationCenter.default.publisher(for: .userLogoutNotification)) { _ in
            isActive.toggle()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(AppViewModel())
    }
}
