import Foundation
import RxSwift
import Firebase
import ProgressHUD

protocol LoginPresenter {
    func openRegistrationScene()
    func openPasswordChangeScene()
    func signIn(username: String, password: String)
}

class LoginPresenterImp: LoginPresenter {
    private var loginUseCase: AuthUseCase
    private var loginGateway: AuthenticationGateway
    private var disposeBag = DisposeBag()
    let router: LoginRouter
    var view: LoginView!
    
    init(_ view: LoginView,
         _ router: LoginRouter,
         _ loginGateway: AuthenticationGateway,
         _ useCase: AuthUseCase) {
        self.view = view
        self.router = router
        self.loginGateway = loginGateway
        self.loginUseCase = useCase
    }
    
    func signIn(username: String, password: String) {
        ProgressHUD.show()
        Auth.auth().signIn(
            withEmail: username,
            password: password,
            completion: { [weak self] (_, error) in
                guard let self = self else { return }
                
                if error == nil {
                    self.router.openMainScene()
                    ProgressHUD.dismiss()
                } else {
                    self.view.showErrorDialog(message: error!.localizedDescription)
                    ProgressHUD.dismiss()
                }
        })
    }
    
    func openRegistrationScene() {
        router.openRegistrationScene()
    }
    
    func openPasswordChangeScene() {
    }

}
