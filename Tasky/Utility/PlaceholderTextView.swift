//
//  PlaceholderTextView.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit

@IBDesignable
class PlaceholderTextView: UITextView {

    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = placeholderColor
        label.numberOfLines = 0
        label.font = self.font ?? UIFont.systemFont(ofSize: 14)
        label.text = placeholder
        return label
    }()

    override var text: String! {
        didSet {
            textDidChange()
        }
    }

    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlaceholderLabel()
    }

    private func setupPlaceholder() {
        addSubview(placeholderLabel)
        placeholderLabel.isHidden = !text.isEmpty
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        
        // Set the textContainerInset and lineFragmentPadding to create space between border and content
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textContainer.lineFragmentPadding = 8
    }

    private func layoutPlaceholderLabel() {
        let padding = textContainerInset.left + textContainer.lineFragmentPadding
        let labelX = textContainerInset.left + textContainer.lineFragmentPadding
        let labelY = textContainerInset.top
        let labelWidth = frame.width - 2 * padding
        let labelHeight = placeholderLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
}
