import UIKit

extension AppDelegate: AuthResponseHandlerDelegate {

    func doLogout() {

        self.settings?.clearUserData()
        
        guard (self.window?.rootViewController as? UINavigationController)?.viewControllers.last as? LoginViewController != nil else {
            DispatchQueue.main.async {
                self.openRootScreen()
            }
            return
        }
    }
}
