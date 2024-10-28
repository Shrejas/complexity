//
//  DeleteView.swift
//  Complexity
//
//  Created by IE12 on 01/05/24.
//

import SwiftUI

struct DeleteView: View {
    var body: some View {

        VStack(spacing: 0){
            Arrow()
            VStack{
                Text("Delete")
            } .background(.red)
        }
    }
}

#Preview {
    DeleteView()
}
struct Arrow: Shape {
  func path(in rect: CGRect) -> Path {
   var path = Path()
   let arrowWidth: CGFloat = 20
    let arrowHeight: CGFloat = 10
   let startX = rect.midX
   let startY = rect.minY
   let endY = rect.maxY
   path.move(to: CGPoint(x: startX, y: startY))
   path.addLine(to: CGPoint(x: startX - arrowWidth/2, y: endY))
   path.addLine(to: CGPoint(x: startX + arrowWidth/2, y: endY))
   path.closeSubpath()
   return path
  }
}
