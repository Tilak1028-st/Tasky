//
//  UnderLineTextField.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit

@IBDesignable
class UnderlineTextField: UITextField {

    private let underline = CALayer()

    @IBInspectable var underlineColor: UIColor = .black {
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

    override var returnKeyType: UIReturnKeyType {
        get { return .done } // Always show "Done" button
        set {} // Required for overriding
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUnderline()
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUnderline()
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEndOnExit)
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

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    @objc private func textFieldDidEndEditing() {
        resignFirstResponder()
    }
}
