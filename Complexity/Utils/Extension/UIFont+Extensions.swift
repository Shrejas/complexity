//
//  UIFont+Extensions.swift
//  Private MD Labs
//
//  Created by IE Mac 05 on 20/01/24.
//

import SwiftUI

extension Font {

//    static var muliTitle: Font = Font.interDisplay(size: 28, weight: .bold)

    static func muliFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .regular:
            return Font.custom("Muli", size: size)
        case .semibold:
            return Font.custom("Muli-SemiBold", size: size)
        case .bold:
            return Font.custom("Muli-Bold", size: size)
        default:
            return Font.custom("Muli", size: size)
        }
    }
}


