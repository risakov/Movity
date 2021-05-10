import Foundation
import RxSwift

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
        self.loginUseCase.loginIn(username, password)
            .observeOn(MainScheduler.instance)
            .do(onSubscribe: { [weak self] in self?.view.showActivityIndicator() },
                onDispose: { [weak self] in self?.view.hideActivityIndicator() })
            .subscribe(onCompleted: {},
                       onError: { [weak self] (error) in
                    self?.view.hideActivityIndicator()
                    self?.view.showDialog(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func openRegistrationScene() {
        router.openRegistrationScene()
    }
    
    func openPasswordChangeScene() {
    }

}
