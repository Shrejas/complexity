//
//  TextView.swift
//  Complexity
//
//  Created by IE12 on 24/04/24.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.text = placeholder
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.lightGray
            uiView.textAlignment = .left // Set the text alignment to left
            uiView.textContainerInset = UIEdgeInsets(top: 10, left:10, bottom: 0, right: 0)
            uiView.backgroundColor = UIColor.F_4_F_6_F_8
        } else {
            uiView.text = text
            uiView.textColor = UIColor.black
            uiView.textAlignment = .natural
            uiView.textContainerInset = UIEdgeInsets(top: 0, left:20, bottom: 0, right: 0)
            uiView.backgroundColor = UIColor.F_4_F_6_F_8
        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
