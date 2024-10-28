//
//  RotateImageView.swift
//  Complexity
//
//  Created by IE Mac 05 on 31/07/24.
//

import SwiftUI

struct RotateImageView: View {
    @Binding var isShowRotateView: Bool
    @State var rotationAngle: Angle = .zero
    @Binding var images: [UIImage]
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(alignment: .center) {
                if let image = images.last {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(rotationAngle)
                }
            }
            Spacer()
            HStack(alignment: .center){
                Image(systemName: "crop.rotate")
                    .frame(width: 20 , height: 20)
                    .onTapGesture {
                        withAnimation {
                            rotationAngle += .degrees(90)
                        }
                    }
                Spacer()
                Text("Done")
                    .onTapGesture {
                        saveRotatedImage()
                        isShowRotateView = false
                    }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .center)
        } .padding(16)
        
    }
    
    func saveRotatedImage() {
        guard var image = images.last else { return }
        let rotatedImage = image.rotated(by: rotationAngle)
        if let index = images.indices.last {
            images[index] = rotatedImage
        }
    }
}
extension UIImage {
    func rotated(by angle: Angle) -> UIImage {
        let radians = CGFloat(angle.radians)
        let rotatedSize = CGSize(width: size.height * abs(sin(radians)) + size.width * abs(cos(radians)),
                                 height: size.width * abs(sin(radians)) + size.height * abs(cos(radians)))

        UIGraphicsBeginImageContext(rotatedSize)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}

//#Preview {
//    RotateImageView()
//}
