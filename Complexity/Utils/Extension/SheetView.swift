//
//  SheetView.swift
//  Complexity
//
//  Created by IE on 16/07/24.
//

import Foundation
import SwiftUI
import PartialSheet

struct SheetView<PrimaryView: View, PresentableView: View>: View {
    @Binding var show: Bool
    let primaryView: PrimaryView
    let presentableView: PresentableView
    let type: PSType
    let onDismiss: (() -> Void)?
    let isFixedSized: Bool
    let hideCloseButtonForIPad: Bool
    
    let iPhoneStyle = PSIphoneStyle(
        background: .solid(Color(UIColor.systemBackground)),
        handleBarStyle: .solid(Color.secondary),
        cover: .enabled(Color(red: 0.04, green: 0.06, blue: 0.11).opacity(0.69)),
        cornerRadius: 40
    )
    
    init(show: Binding<Bool>, isFixedSized: Bool = false, hideCloseButtonForIPad: Bool = false, type: PSType = PSType.dynamic, @ViewBuilder primaryView: () -> PrimaryView, @ViewBuilder presentableView: () -> PresentableView, onDismiss: (() -> Void)? = nil) {
        _show = show
        self.primaryView = primaryView()
        self.presentableView = presentableView()
        self.type = type
        self.onDismiss = onDismiss
        self.isFixedSized = isFixedSized
        self.hideCloseButtonForIPad = hideCloseButtonForIPad
    }
    
    var body: some View {
        VStack {
            primaryView
                .partialSheet(isPresented: $show, type: type, iPhoneStyle: iPhoneStyle, onDismiss: onDismiss) {
                    ZStack {
                        if isFixedSized {
                            Color.clear
                                .disabled(true)
                                .gesture(
                                    DragGesture()
                                        .onChanged { _ in
                                            
                                        }
                                        .onEnded { _ in
                                            
                                        }
                                )
                        }
                        presentableView
                    }
                }
        }
    }
}

