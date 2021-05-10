import UIKit

extension UIButton {
    /**
     Анимирует кнопку на манер "сжалась - вернулась в исходное".
     Используется в классе кастомной кнопки.
     - Parameter hex: RGB-код цвета.
     - Parameter alpha: Степень непрозрачности.
     */
    func animate(_ transform: CGAffineTransform) {
        UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 3,
                options: [.curveEaseInOut],
                animations: {
                    self.transform = transform
                }
        )
    }
}
