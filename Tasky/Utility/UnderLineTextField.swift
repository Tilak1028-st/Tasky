//
//  UnderLineTextField.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import Foundation
import UIKit

@IBDesignable
class UnderlineTextField: UITextField {

    private let underline = CALayer()
    
    @IBInspectable var underlineColor: UIColor = UIColor.black {
        didSet {
            underline.backgroundColor = underlineColor.cgColor
        }
    }
    
    @IBInspectable var underlineHeight: CGFloat = 1.0 {
        didSet {
            updateUnderlineFrame()
        }
    }
    
    @IBInspectable var padding: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUnderline()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUnderline()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnderlineFrame()
    }

    private func setupUnderline() {
        borderStyle = .none
        underline.backgroundColor = underlineColor.cgColor
        layer.addSublayer(underline)
    }

    private func updateUnderlineFrame() {
        underline.frame = CGRect(x: 0, y: frame.height - underlineHeight, width: frame.width, height: underlineHeight)
    }

    // Add padding to the text field
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
}
