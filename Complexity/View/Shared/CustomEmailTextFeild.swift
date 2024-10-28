//
//  CustomEmailTextFeild.swift
//  Complexity
//
//  Created by IE Mac 05 on 17/05/24.
//

import SwiftUI

struct CustomEmailTextFeild: View {
    let placeholder: String
    let imageName: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    @Binding var isLoading: Bool
    var onCommit: () -> Void
   

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color._F4F6F8)
            HStack {
                Image(imageName)
                    .foregroundColor(.gray)
                    .padding(.leading, 17)
                
                TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                    if !isEditing{
                        onCommit()
                    }
                })
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .frame(height: 50)
                    .foregroundColor(Color._2A2C2E)
                    .font(.muliFont(size: 15, weight: .regular))
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)

                if isLoading {
                    ProgressView()
                        .padding(.trailing)
                }
                
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    // Use a State variable to bind the text property
    @State  var emailText: String = ""
    
    return CustomEmailTextFeild(
        placeholder: "Enter your email",
        imageName: "email_icon",
        text: $emailText,
        keyboardType: .emailAddress, isLoading: .constant(false),
        onCommit: {
            // Perform any action needed on commit
            print("Email entered: \(emailText)")
        }
    )
}

