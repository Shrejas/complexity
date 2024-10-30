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
    @State private var isShowActionSheet: Bool = false
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
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(notifications.indices, id: \.self) { index in
                                ZStack {
                                    if !notifications[index].isRead {
                                        Color._E9F2FE
                                    } 
                                   else {
                                       Color.white
                                    }
                        
                                    CustomCell(
                                        imageName: notifications[index].profilePicture,
                                        text: notifications[index].notificationMessage,
                                        createdAt: notifications[index].createdTime,
                                        createdBy: notifications[index].name,
                                        userID: notifications[index].userId, id: notifications[index].notificationId
                                    ) { userId in
                                        handleProfileImageTap(userId: userId)
                                    } cellTapAction: { userId in
                                        handleCellTapAction(id: userId)
                                    }
                                    .padding(.horizontal)
                                    .onAppear {
                                        if notifications.count >= feedViewModel.notificationPageSize * feedViewModel.notificationPageIndex {
                                            if index == notifications.count - 1 {
                                                feedViewModel.notificationPageIndex += 1
                                                feedViewModel.getNotification()
                                            }
                                        }
                                    }
                                }
                                .cornerRadius(8)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .background(Color._F4F6F8)
                }
            }
        }
        .onAppear{
            feedViewModel.getNotification()
        }
        .navigationBarTitle(Text("Notification"), displayMode: .inline)
        .navigationBarItems(leading: Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color._626465)
            }
        }, trailing:
                                Menu {
            Button {
                handleCellTapAction()
            } label: {
                HStack(alignment: .center, spacing: 10)  {
                    Image(systemName: "bell.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Mark all as read")
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .presentationDetents([.height(100), .fraction(0.15)])
                }
            }
            
            
        } label: {
            HStack {
                Image(ImageConstant.dot)
                    .foregroundColor(Color._626465)
            }
        }
        ).navigationBarColor(.white)
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
    
    private func handleCellTapAction(id: Int? = nil) {
        feedViewModel.readNotification(id: id)
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
    var id: Int
    var profileImageTapAction: (Int) -> Void
    var cellTapAction: (Int) -> Void
    var body: some View {
        
    
        HStack(alignment: .top, spacing: 5) {
            Button {
                profileImageTapAction(userID)
                cellTapAction(id)
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

            Button {
                profileImageTapAction(userID)
                cellTapAction(id)
            } label: {
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
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }

            
            
        }
        .padding(5)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        
        
        
    }
}

