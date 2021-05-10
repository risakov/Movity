import UIKit

extension UIApplication {
    /**
     Возвращает ViewController, находящийся вверху стека навигации.
     - parameter base: ViewController, с которого начинать поиск верхнего.
     - returns: верхний ViewController.
     */
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
    
    /**
     Возвращает строку с кодом локали.
     */
    var languageCode: String {
        let supportedLanguageCodes = ["en", "es", "fr", "ru"]
        let languageCode = Locale.current.languageCode ?? "en"
        
        return supportedLanguageCodes.contains(languageCode) ? languageCode : "en"
    }
    
    /**
     Для наиболее точной проверки ориентации интерфейса.
     - returns: true, если интерфейс находится в портретном режиме.
     */
    func interfaceOrientationIsPortrait() -> Bool {
        switch self.statusBarOrientation {
        case .portrait,
             .portraitUpsideDown:
            return true
            
        case .landscapeLeft,
             .landscapeRight:
            return false
            
        case .unknown:
            return UIDevice.current.orientation.isPortrait
        }
    }
}

class UIApplicationUtil {
    /**
     Обертка для открытия ссылки.
     */
    static func openUrl(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
//             Fallback on earlier versions
        }
    }
}
