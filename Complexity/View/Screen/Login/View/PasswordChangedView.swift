//
//  PasswordChangedView.swift
//  Complexity
//
//  Created by IE12 on 08/05/24.
//

import SwiftUI



class ViewCoordinator: ObservableObject {
    // Use a boolean binding to trigger view dismissal
    @Published var dismissAllViews = false

    // Function to dismiss all views
    func dismissAll() {
        dismissAllViews.toggle()
    }
}


struct PasswordChangedView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @EnvironmentObject var coordinator: ViewCoordinator
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some View {
        VStack(alignment: .center){
            Text("Password changed")
                .foregroundColor(Color._1D1A1A)
                .font(.muliFont(size: 34, weight: .bold))
                .padding(.top,210)
            
            Text("Your password has been changed")
                .font(.muliFont(size: 15, weight: .semibold))
                .foregroundColor(Color._8A8E91)
            
            
            Text("succesfully")
                .font(.muliFont(size: 15, weight: .semibold))
                .foregroundColor(Color._8A8E91)
            
            Button(action: {
                //     presentationMode.wrappedValue.dismiss()
                //       coordinator.dismissAll()
                appDelegate.setWindowGroup(AnyView(ContentView()))

            }, label: {
                Text("Back to Log in")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color._4F87CB)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .font(.muliFont(size: 17, weight: .bold))
                    .padding(.top,39)
                
            }).padding(.horizontal,20)
            
            Spacer()
        }
          .navigationBarHidden(true)
    }
}

#Preview {
    PasswordChangedView()
}
