import Foundation
import RxSwift

enum TokenState {
    case active
    case refreshing
    case failedToRefresh
    case none
}

protocol AuthUseCase {
    var tokenCondition: TokenState { get }

    func loginIn(_ login: String, _ password: String) -> Completable
    func refreshToken() -> Completable
    func logout()
}

class AuthUseCaseImp: AuthUseCase {
    private var settings: Settings
    private let userGateway: UserGateway
    private var authApi: AuthenticationGateway
    private var tokenState: TokenState
    
    var tokenCondition: TokenState {
        return tokenState
    }
    
    var account: UserEntity? {
        get {
            return settings.user
        }
        set(acc) {
            settings.user = acc
        }
    }
    
    init(authApi: AuthenticationGateway,
         userGateway: UserGateway,
         settings: Settings) {
        self.authApi = authApi
        self.settings = settings
        self.userGateway = userGateway
        self.tokenState = settings.token == nil ? .none : .active
    }
    
    func loginIn(_ login: String, _ password: String) -> Completable {
        return authApi.auth(login, password)
            .do(onSuccess: { tokenEntity in
                self.settings.token = tokenEntity
                self.tokenState = .active
            }, onSubscribe: {
                self.settings.token = nil
                self.tokenState = .none
            })
            .asCompletable()
            .andThen(userGateway.getAccount())
            .asCompletable()
            .do(onCompleted: {
                NotificationCenter.default.post(name: .onUserSignedIn, object: nil)
            })
    }
    
    func refreshToken() -> Completable {
        let refToken = settings.token?.refresh_token ?? ""
        return authApi.refreshToken(refToken)
            .observeOn(MainScheduler.instance)
            .do(onSuccess: { tokenEntity in
                self.settings.token = tokenEntity
                self.tokenState = .active
            }, onError: { (_) in
                self.tokenState = .failedToRefresh
            }, onSubscribe: {
                self.tokenState = .refreshing
            }, onDispose: {
                if self.tokenState == .refreshing {
                    self.tokenState = .failedToRefresh
                }
            })
            .asCompletable()
    }
    
    func logout() {
        tokenState = .none
        settings.clearUserData()
    }
    
}

enum LoginError: LocalizedError {
    case notAvailableRole
    
    var errorDescription: String? {
        switch self {
        case .notAvailableRole:
            return "Роль пользователя не подходит для приложения"
        }
    }
}
