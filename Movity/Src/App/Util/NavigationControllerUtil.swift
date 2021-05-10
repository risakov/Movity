import UIKit

extension UINavigationController {
    /**
     Расширенный метод снятия VC со стека навигации. Позволяет выполнить действие по завершении.
     - Parameter animated: Анимировать ли снятие VC со стека навигации?
     - Parameter completion: Блок кода для выполнения по завершении.
    */
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        self.popViewController(animated: animated)
        self.transitionCoordinator?.animate(alongsideTransition: nil) { _ in
            completion()
        }
    }
}
