//
//  CustomTextFieldView.swift
//  Complexity
//
//  Created by IE12 on 20/04/24.
//

import Foundation

struct CustomTextField: View {
    let placeholder: String
    let imageName: String
    @Binding var text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.F_4_F_6_F_8)
            HStack {
                Button(action: {

                }, label: {
                    Image(imageName)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                })

                TextField(placeholder, text: $text)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .frame(height: 50)
                    .foregroundColor(Color(._8_A_8_E_91))
                    .font(.muliFont(size: 15, weight: .regular))
            }
        }
        .frame(height: 50)
    }
}
