//
//  View+Extensions.swift
//  Complexity
//
//  Created by IftekharSSD on 22/05/24.
//

import Foundation
import SwiftUI

extension View {
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
