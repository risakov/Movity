import Foundation
import RxSwift

protocol LoginPresenter {
    func openRegistrationScene()
    func openPasswordChangeScene()
    func sendRegistrationRequest()
}

class LoginPresenterImp: LoginPresenter {
    private var loginUseCase: AuthUseCase
    private var loginGateway: AuthenticationGateway
    private var disposeBag = DisposeBag()
    private let gateway: RegistrationGateway
    let router: LoginRouter
    var view: LoginView!
    
    init(_ view: LoginView,
         _ router: LoginRouter,
         _ loginGateway: AuthenticationGateway,
         _ registrationGateway: RegistrationGateway,
         _ useCase: AuthUseCase) {
        self.view = view
        self.router = router
        self.gateway = registrationGateway
        self.loginGateway = loginGateway
        self.loginUseCase = useCase
    }
    
    func signIn(_ username: String, _ password: String) {
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
    }
    
    func openPasswordChangeScene() {
    }
    
    func sendRegistrationRequest() {
        let gender: Gender = .male
        self.gateway.sendReqistrationRequest(
            CreateRegistrationRequestApiEntity(user:
                CreateRegistrationRequestEntity(
                    email: "romanikani@gmail.com",
                    password: "wawawa",
                    name: "Roman",
                    lastname: "Isakov",
                    patronymic: "Alexandrovich",
                    gender: gender.rawValue,
                    cityname: "Rostov-on-Don",
                    birthDate: "21.09.1999"
                )
            )
        )
        .observeOn(MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] entity in
            guard let self = self else { return }
            let newEntity = entity
            }, onError: { [weak self] error in
                self?.view.showErrorDialog(message: error.localizedDescription)
        })
        .disposed(by: self.disposeBag)
    }

}
