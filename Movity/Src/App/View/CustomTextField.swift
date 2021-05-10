import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    /// Additional to inset for default
    @IBInspectable var insetX: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// Additional to inset for default
    @IBInspectable var insetY: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// distance from the lefts views leading to fields leading
    @IBInspectable var leftViewPadding: CGFloat = 10 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// distance from the right views trailing to fields trailing
    @IBInspectable var rightViewPadding: CGFloat = 10 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            guard let leftImage = leftImage else {
                leftView = nil
                return
            }
            let imageView = UIImageView(image: leftImage)
            imageView.frame = imageView.bounds.insetBy(dx: -leftViewPadding, dy: 0)
            imageView.contentMode = .right
            leftView = imageView
            let width = leftImage.size.width + leftViewPadding
            leftView!.translatesAutoresizingMaskIntoConstraints = false
            leftView!.widthAnchor.constraint(equalToConstant: width).isActive = true
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            guard let rightImage = rightImage else {
                rightView = nil
                return
            }
            let imageView = UIImageView(image: rightImage)
            imageView.frame = imageView.bounds.insetBy(dx: -rightViewPadding, dy: 0)
            imageView.contentMode = .left
            let width = rightImage.size.width + rightViewPadding
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
            rightView = imageView
            rightViewMode = .always
        }
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: insetX, dy: insetY)
    }
}
