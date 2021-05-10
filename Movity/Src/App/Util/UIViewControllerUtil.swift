import UIKit

enum NavigationBarStyle {
    case defaultStyle
    case clearStyle
}

enum ButtonTintStyle {
    case black
    case white
}

extension UIViewController: BaseView { }

extension UIViewController: UIGestureRecognizerDelegate { }

extension UIViewController {
    
    // Экшн кнопки "Назад". По умолчанию будет делать
    // стандартный .pop
    @discardableResult
    @objc func backButtonAction() -> Bool {
        self.shouldPopViewController { [weak self] shouldPop in
            if shouldPop {
                self?.navigationController?.popViewController(animated: true)
            }
            return shouldPop
        }
    }
    
    // Флаг у UIViewController по умолчанию true, который определяет,
    // можно ли сделать .pop с текущего экрана. При override можно
    // запретить, либо вставить диалог с запросом подтверждения
    @objc
    @discardableResult
    func shouldPopViewController(shouldPop: @escaping (_ isPositive: Bool) -> Bool) -> Bool {
        return shouldPop(true)
    }
    
    public var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }
    
    public var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
    
    var navVC: UINavigationController? {
        guard let navVC = self as? UINavigationController else {
            return self.navigationController
        }
        return navVC
    }
}
