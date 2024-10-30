//
//  ContentView.swift
//  Complexity
//
//  Created by IE12 on 09/05/24.
//

import Foundation
import SwiftUI

struct ContentView: View {

    @State private var isCheck: Bool = false
    var body: some View {
        NavigationView{
            VStack{
              Login()
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
