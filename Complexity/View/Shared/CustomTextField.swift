//
//  CustomTextField.swift
//  Complexity
//
//  Created by IE12 on 20/04/24.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    let imageName: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    @Binding var isEditable: Bool
    var onCommit: (() -> Void)?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color._F4F6F8)
            HStack {
                Image(imageName)
                    .foregroundColor(.gray)
                    .padding(.leading, 17)
                TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                    if !isEditing {
                        onCommit?()
                    }
                })
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .frame(height: 50)
                    .foregroundColor(Color._2A2C2E)
                    .font(.muliFont(size: 15, weight: .regular))
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
                    .disabled(!isEditable)
            }
        }
        .frame(height: 50)
    }
}


struct CustomButtonView: View {
     let text: String
    let buttonAction: () -> Void
    
    var body: some View {
        Button {
         buttonAction()
        } label: {
                HStack {
                    Text(text)
                        .foregroundColor(.white)
                        .font(.muliFont(size: 15, weight: .regular))
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .background(Color._4F87CB)
                .cornerRadius(25)

        }
    }
}

struct DeleteButtonView: View{
    let text: String
   let buttonAction: () -> Void

   var body: some View {
       Button {
        buttonAction()
       } label: {
               HStack {
                   Text(text)
                       .foregroundColor(.white)
                       .font(.muliFont(size: 15, weight: .bold))
                       .frame(maxWidth: .infinity, minHeight: 50)
               }
               .background(Color.red)
               .cornerRadius(25)
               .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 0.3)
               )

       }
   }
}
