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
    
    func applyBorder(color: UIColor, width: CGFloat, cornerRadius: CGFloat = 0.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = cornerRadius > 0
    }
    
    func makeCircular() {
        let smallestSide = min(self.frame.size.width, self.frame.size.height)
        self.frame.size = CGSize(width: smallestSide, height: smallestSide)
        self.layer.cornerRadius = smallestSide / 2
        self.layer.masksToBounds = true
    }
}
