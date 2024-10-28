//
//  ContentView.swift
//  Complexity
//
//  Created by IE12 on 17/04/24.
//

import SwiftUI

struct HomeView: View {
    @State private var tabSelected: Tab = .Feed
    @ObservedObject var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ZStack(alignment: .bottom) {
                VStack {
                    switch tabSelected {
                    case .Feed:
                        FeedViewScreen()
                            .navigationBarBackButtonHidden()
                            .navigationDestination(for: Router.Destination.self) { destination in
                                switch destination {
                                case .newPostView:
                                    NewPostView()
                                        .navigationBarBackButtonHidden()
                                case .drinkNameView(let post):
                                    DrinkNameView(post: post)
                                        .navigationBarBackButtonHidden()
                                case .drinkDetailProfileView(let drinkID):
                                    DrinkDetailProfileView(drinkId: drinkID)
                                        .navigationBarBackButtonHidden()
                                case .newPostViewWithDetail(let brandName, let categoryDrinkItem, let drinkName):
                                    NewPostView(drinkBrand: brandName, categoryDrinkItem: categoryDrinkItem, drinkName: drinkName)
                                        .navigationBarBackButtonHidden()
                                }
                            }
                    case .Find:
                        FindView()
                    case .Profile:
                        UserProfileView()
                    }
                }

                // Show CustomTabBar only on main tabs
                if router.navigationPath.isEmpty {
                    CustomTabBar(selectedTab: $tabSelected)
                        .padding(.bottom)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .environmentObject(router)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

final class Router: ObservableObject {

    public enum Destination: Codable, Hashable {
        case newPostView
        case drinkNameView(post: FeedPost)
        case drinkDetailProfileView(drinkID : Int)
        case newPostViewWithDetail(brandName: String, categoryDrinkItem: String, drinkName: String)
        
//        case newPostView()
    }

    @Published var navigationPath = NavigationPath()

    func navigate(to destination: Destination) {
        navigationPath.append(destination)
    }

    func navigateBack() {
        navigationPath.removeLast()
    }

    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
