import UIKit

// Классы наследники для того, чтобы IBInspectable поля из ViewExtension.swift отображались при редактировании Storyboard'a.

@IBDesignable
class DesignableUITextField: UITextField {
}

@IBDesignable
class DesignableUIView: UIView {
}

@IBDesignable
class DesignableUIImageView: UIImageView {
}

@IBDesignable
class DesignableUIButton: UIButton {

    @IBInspectable var isFeedbackActive: Bool = true
    @IBInspectable var isAnimationActive: Bool = false

    override var isHighlighted: Bool {
        didSet {
            if isAnimationActive {
                let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
                self.animate(transform)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isFeedbackActive {
            self.generateTouchFeedback()
        }
    }

    /**
     Генерирует вибро-отклик. Срабатывает не всегда, а только если система решит,  что можно.
    */
    func generateTouchFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

