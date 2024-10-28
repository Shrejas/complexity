//
//  ComplexityApp.swift
//  Complexity
//
//  Created by IE12 on 17/04/24.
//

import SwiftUI
import GoogleSignIn

@main
struct ComplexityApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var appViewModel: AppViewModel = AppViewModel()
        
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashView()
                    .environmentObject(appViewModel)
                    .preferredColorScheme(.light)
            }
        }
    }
}
