//
//  TabbarView.swift
//  Complexity
//
//  Created by IE12 on 22/04/24.
//



import SwiftUI

enum Tab: String, CaseIterable {
    case Feed
    case Find
    case Profile
    
    var view: AnyView {
        switch self {
        case .Feed:
            return AnyView(FeedViewScreen())
        case .Find:
            return AnyView(FindView())
        case .Profile:
            return AnyView(UserProfileView())
        }
    }

}

struct CustomTabBar: View {

    @Binding var selectedTab: Tab
    
    private var tabImage: String {
        switch selectedTab {
        case .Feed:
            return "FeedFill"
        case .Find:
            return "FindFill"
        case .Profile:
            return "ProfileFill"
        }
    }
    
    
    var body: some View {
        VStack {
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(selectedTab == tab ? tabImage : tab.rawValue)
                        .scaledToFit()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: 320, height: 63)
            .background(.white)
            .cornerRadius(200)
            .shadow(color: .secondary.opacity(0.3), radius: 10, y: 5)
            .padding(.horizontal)
        } 
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.Feed))
    }
}

