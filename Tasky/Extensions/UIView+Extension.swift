//
//  UIView+Extension.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import Foundation
import  UIKit

extension UIView {
    func applyCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
