import  UIKit

class LoginRouter: BaseRouter {
    
    weak var view: UIViewController!
    
    init(_ view: LoginViewController) {
        self.view = view
    }
    
    func openRegistrationScene() {
        if let navController = self.view.navigationController {
        }
    }
    
    func openPermissionsRequestScreen() {
        if let navController = self.view.navigationController {
        }
    }
    
    func openPasswordChangeScreen() {
        if let navController = self.view.navigationController {
        }
    }
}
