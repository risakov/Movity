import UIKit

extension UIView {
    /**
     Запускает анимацию "потряхивания" в указанном направлении.
     - parameter duration: Длительность анимации.
     - parameter xValue: X-координа направления движения.
     - parameter yValue: Y-координа направления движения.
     */
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 1.0,
            options: [.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
            animations: {
                self.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }
    
}
