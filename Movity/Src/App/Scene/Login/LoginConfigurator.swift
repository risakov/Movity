import UIKit

class LoginConfigurator {
    func configure(view: LoginViewController) {
        let router = LoginRouter(view)
        let presenter = LoginPresenterImp(view,
                                          router,
                                          DI.resolve(),
                                          DI.resolve())
        view.presenter = presenter
    }

    static func open(navigationController: UINavigationController) {
        let view = R.storyboard.loginStoryboard.loginViewController()
        LoginConfigurator().configure(view: view!)
        navigationController.isNavigationBarHidden = true
        navigationController.navigationItem.hidesBackButton = true
        navigationController.pushViewController(view!, animated: true)
    }
}
