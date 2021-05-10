import UIKit

extension UIViewController {
    /**
     Скрывает TabBar.
     - parameter hidden: Bool - Скрыть/Показать.
     - parameter animated: Bool - С анимацией, или без неё.
     - parameter duration: TimeInterval - Длительность анимации.
     */
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }

}
