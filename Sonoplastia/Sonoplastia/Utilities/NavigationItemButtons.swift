//
//  NavigationItemButtons.swift
//  Sonoplastia
//
//  Created by Claudio Noberto on 09/06/22.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    var isHidden: Bool {
        get {
            return tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : nil
            isEnabled = !newValue
            isAccessibilityElement = !newValue
        }
    }
}
