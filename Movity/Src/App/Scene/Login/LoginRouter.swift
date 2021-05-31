import  UIKit

class LoginRouter: BaseRouter {
    
    weak var view: UIViewController!
    
    init(_ view: LoginViewController) {
        self.view = view
    }
    
    func openRegistrationScene() {
        if let navController = self.view.navigationController {
            RegistrationConfigurator.open(navigationController: navController)
        }
    }

    func openMainScene() {
        let rootView = R.storyboard.root.rootVC()!
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = rootView
        rootView.openMainMapScene()
    }
    
}
