//
//  NotificationView.swift
//  Complexity
//
//  Created by IE Mac 05 on 14/05/24.
//

import Combine
import SwiftUI
import Kingfisher
struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var text: String = ""
    @State private var password: String = ""
    @State private var isSecured = true
    @State private var tap = true
    @State public var userInfo: UserInfo?
    @State private var isShowProfileView: Bool = false
    @StateObject var feedViewModel: FeedViewModel = FeedViewModel()
    
    var body: some View {
        
        NavigationLink(isActive: $isShowProfileView) {
            if let userInfo = self.userInfo {
                PostProfileView(userInfo: userInfo, isShowProfileView: $isShowProfileView)
            }
        } label: {
            EmptyView()
        }
        .opacity(0)
        
        VStack {
            if feedViewModel.isLoding {
                VStack{
                    ForEach(0 ..< 15){_ in
                        NotificationSkeltonView(isSkeletonUIPresenting: true)
                    }.frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(.top, 16)
            }
            if let notifications = feedViewModel.notificationData?.notifications {
                if notifications.isEmpty {
                    
                    ZStack{
                        Image("EmptyImage")
                            .resizable()
                            .scaledToFill()
                        Text("You currently have no notifications.")
                            .font(.muliFont(size: 20, weight: .bold))
                            .foregroundColor(.black.opacity(0.5))
                    }
                } else {
                    List {
                        ForEach(notifications.indices, id: \.self) { index in
                            CustomCell(imageName: notifications[index].profilePicture, text: notifications[index].notificationMessage, createdAt: notifications[index].createdTime, createdBy: notifications[index].name, userID: notifications[index].userId) { userId in
                                handleProfileImageTap(userId: userId)
                            }
                            .onAppear {
                                if notifications.count > feedViewModel.notificationPageSize * feedViewModel.notificationPageIndex {
                                    if index == notifications.count - 1 {
                                        feedViewModel.notificationPageIndex += 1
                                        feedViewModel.getNotification()
                                    }
                                }
                            }
                        }
                    }
                    
                    .listRowBackground(Color._F4F6F8)
                    .listRowSpacing(10.0)
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("Notification")
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
            }
        } .onAppear{
            feedViewModel.getNotification()
        }
    }
    
    private func handleProfileImageTap(userId: Int) {
        feedViewModel.getProfileDetail(userId: userId) { result in
            switch result {
            case .success(let data):
                self.userInfo = data
                isShowProfileView.toggle()
            case .failure(let error):
                break
            }
        }
        
    }
}
#Preview {
    NotificationView()
}

struct CustomCell: View {
    var imageName: String
    var text: String
    var createdAt: String
    var createdBy: String
    var userID: Int
    var profileImageTapAction: (Int) -> Void
    var body: some View {
        
    
        HStack(alignment: .top, spacing: 5) {
            Button {
                profileImageTapAction(userID)
            } label: {
                if let imageUrl = URL(string: imageName){
                    KFImage(imageUrl)
                        .resizable()
                        .placeholder {
                            ProgressView()
                                .frame(width: 40,height: 40, alignment: .top)
                                .padding(.trailing, 15)
                        }
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .top)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(35)
                        .padding(.trailing, 15)
                }
            }

            
            VStack {
                HStack {
                    Text(createdBy)
                        .font(.muliFont(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Text(createdAt)
                        .font(.muliFont(size: 13, weight: .light))
                        .foregroundColor(.gray)
                    Image(systemName: "clock" )
                        .resizable()
                        .frame(width: 15, height: 15)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
                Text(text)
                    .font(.muliFont(size: 15, weight: .semibold))
                    .foregroundColor(.black.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
        }
        .padding(5)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        
        
    }
}

