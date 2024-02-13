//
//  EndEditing.swift
//  HotProspects
//
//  Created by Maks Winters on 13.02.2024.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
