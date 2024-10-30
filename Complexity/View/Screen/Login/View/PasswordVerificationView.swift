//
//  PasswordVerificationView.swift
//  Complexity
//
//  Created by IE12 on 08/05/24.
//

import SwiftUI

struct PasswordVerificationView: View {
    @State private var otpText = ""
    @FocusState private var isKeyboardShowing: Bool
    @State private var isResetViewTapped: Bool = false
    @State private var showAlert: Bool = false
    @State private var title = ""
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var timerIsRunning = false
    @State private var timeRemaining = 20

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var isEmail: String


    var body: some View {

        VStack(alignment: .center){

            NavigationLink(isActive: $isResetViewTapped) {
                ResetPasswordView( userName: $isEmail, otp: $otpText)
            } label: {
                EmptyView()
            }

            Text("Verification")
                .foregroundColor(Color._1D1A1A)
                .font(.muliFont(size: 34, weight: .bold))
                .padding(.top,47)

            HStack(alignment: .center){
                Text("We’ve sent a code to")
                    .font(.muliFont(size: 15, weight: .semibold))
                    .foregroundColor(Color._8A8E91)
                Text(isEmail)
                    .font(.muliFont(size: 15, weight: .bold))
                    .foregroundColor(Color._1D1A1A)
            }


            HStack(spacing:22){
                ForEach(0..<4,id: \.self){ index in
                    OTPTextBox(index)
                }
            }
            .padding(.top,76)
            .background(content:{
                TextField("", text:$otpText.limit(length: 6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 8,height: 8)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
                    .font(.muliFont(size: 17, weight: .regular))

            })
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing.toggle()
            }

            Button(action: {
                validation()
                //  isResetViewTapped.toggle()

            }, label: {
                Text("Verify")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color._4F87CB)
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .font(.muliFont(size: 17, weight: .bold))

            })
            .padding(.horizontal,20)
            .padding(.top,50)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(title), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            HStack(spacing:4){

                if timeRemaining == 20 {
                    Button(action: {
                        self.timerIsRunning = true
                        self.timeRemaining = 20
                    }, label: {
                        Text("Send code again")
                            .font(.muliFont(size: 17, weight: .bold))
                            .foregroundColor(Color._1D1A1A)
                    })
                } else {
                    Text("Send code again")
                        .font(.muliFont(size: 17, weight: .regular))
                        .foregroundColor(Color._8A8E91)
                }

                Text(timeString(timeRemaining))
                    .font(.muliFont(size: 17, weight: .regular))
                    .foregroundColor(Color._1D1A1A)
            }
            .padding(.top,42)
            .onReceive(timer) { _ in
                if self.timerIsRunning {
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        self.timerIsRunning = false
                        self.timeRemaining = 20
                    }
                }
            }
            Spacer()
        }
        .onAppear{
            self.timerIsRunning = true
            self.timeRemaining = 20
            isKeyboardShowing = true
        }
        .navigationBarBackButtonHidden(true)

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color._626465)
                    }
                }
            }
        }
    }

    func validation(){
        if otpText.count != 4 {
            showAlert = true
            alertMessage = "Please enter otp"
            title = "Message"
            return
        }
        isResetViewTapped = true
    }
    func timeString(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    @ViewBuilder
    func OTPTextBox(_ index: Int)->some View{
        ZStack{
            if otpText.count > index{
                /// - Finding Char At Index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String (otpText[charIndex])
                Text(charToString)
            }else{
                Text(" ")
            }
        }
        .frame(width: 66, height: 70)

        .background {
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle (cornerRadius: 10, style: .continuous)
                .stroke(status ? Color._2A2C2E : Color._E4E6E8,lineWidth: status ? 1 : 1)
                .animation(.easeInOut, value: status)
        }
    }
}

extension Binding where Value == String{ func limit( length: Int)->Self{
    if self.wrappedValue.count > length{
        DispatchQueue.main.async {
            self.wrappedValue = String(self.wrappedValue.prefix(length))
        }
    }
    return self
}
}

//#Preview {
//    PasswordVerificationView(isEmail: .constant("adf"))
//}
