import Foundation
import RxSwift
import RxNetworkApiClient

//Алгоритм работы обработчика ощибок авторизации:
//В первую очередь убеждаемся что пришедшая ошибка связана именно с авторизацией
//и только в этом случае метод в результате работы возвращает true, это означает, что ошибка обработана.
//Далее смотрим текущее состояние токена(tokenState = active по умолчанию):
//1) active:
// - Если пришел ответ"the access token provided has expired",
//   то меняем состояние токена на неактивно, добавляем метод повторно отправляющий запрос в очереди
//   и делаем запрос на обновление токена, после его успеха повторно выполняем запросы из очереди и очищаем ее,
//   в случае ошибки - делаем logout, состояние меняем на актив и отправляем эту ошибку во все observer-ы из очереди ;
// - Если ответ связан с попыткой залогиниться мапим в соответствущую ошибку и отправляем в ObserverType
// - В остальных случаях
//2) refreshing:
// - Если исходный запрос не является запросом на обновление токена - он добавляется в очередь
// - Если это был запрос на обновление токена и вернулась ошибка связанная с авторизацией - значит
//   обновить токен не удалось: делаем logout
//3) при остальных состояниях токена если ошибка связана с авторизацией отправляем ошибку в обзервер иначе возвращаем false

open class AuthResponseHandler: ResponseHandler {
    
    private let jsonDecoder = JSONDecoder()
    private let authUseCase: AuthUseCaseImp
    private var settings: Settings
    private let apiClient: ApiClient
    private weak var delegate: AuthResponseHandlerDelegate?
    
    // Вместо BaseApp вставить имя проекта
    private let queue = DispatchQueue(label: "ru.WebAnt.BaseApp.Queue.AuthResponseHandler")
    private let timerQueue = SerialDispatchQueueScheduler(internalSerialQueueName: "ru.WebAnt.BaseApp.Queue.AuthResponseHandler.RxTimer")
    private let refreshTokenQuery = ("grant_type", "refresh_token")
    
    private var _tokenState: TokenState = .active
    private var tokenState: TokenState {
        get { return queue.sync { self._tokenState } }
        set {
            queue.sync { self._tokenState = newValue }
            print("#token state changed to: \(String(describing: newValue))")
        }
    }
    
    private var _pendingRequestsBlocks = [(Error?) -> Void]()
    private var pendingRequestsBlocks: [(Error?) -> Void] {
        get { return queue.sync { self._pendingRequestsBlocks } }
        set { queue.sync { self._pendingRequestsBlocks = newValue } }
    }
    
    private let disposeBag = DisposeBag()
    
    private var lastRefreshTokenTime = Date(timeIntervalSince1970: 0)
    
    init(_ delegate: AuthResponseHandlerDelegate,
         _ authUseCase: AuthUseCaseImp,
         _ settings: Settings,
         _ apiClient: ApiClient) {
        self.delegate = delegate
        self.authUseCase = authUseCase
        self.settings = settings
        self.apiClient = apiClient
    }
    
    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        //  for testing
        //        if #available(iOS 13.0, *) {
        //            if self.lastRefreshTokenTime.distance(to: Date()) > 30 && self.tokenState == .active {
        //                self.lastRefreshTokenTime = Date()
        //                self.pendingRequestsBlocks.append { err in
        //                    if err == nil {
        //                        _ = self.apiClient.execute(request: request).subscribe(observer)
        //                    } else {
        //                        observer(.error(err!))
        //                    }
        //                }
        //                self.refreshToken(request: request, observer: observer)
        //                return true
        //            }
        //        }
        if let data = response.data,
            let responseError = try? jsonDecoder.decode(AuthErrorResponseEntity.self, from: data) {
            let error = responseError.error_description.lowercased()
            if self.tokenState == .active {
                switch error {
                case let er where er.contains("invalid grant_type parameter or parameter missing"):
                    observer(.error(AuthResponseHandlerError.errorApplication))
                    return true
                    
                case let er where er.contains("the client credentials are invalid") ||
                    er.contains("the grant type is unauthorized for this client_id"):
                    observer(.error(AuthResponseHandlerError.invalidClient))
                    return true
                    
                case let er where er.contains("missing parameters. \"username\" and \"password\" required"):
                    observer(.error(AuthResponseHandlerError.missingParameters))
                    return true
                    
                case let er where er.contains("invalid username and password combination"):
                    observer(.error(AuthResponseHandlerError.invalidCombination))
                    return true
                    
                case let er where er.contains("invalid refresh token"):
                    observer(.error(AuthResponseHandlerError.invalidRefreshToken))
                    //                        delegate?.doLogout()
                    return true
                    
                case let er where er.contains("the access token provided has expired"):
                    self.pendingRequestsBlocks.append { err in
                        if err == nil {
                            _ = self.apiClient.execute(request: request).subscribe(observer)
                        } else {
                            observer(.error(err!))
                        }
                    }
                    refreshToken(request: request, observer: observer)
                    return true
                    
                case let er where er.contains("refresh token has expired") ||
                    er.contains("user account is disabled") ||
                    er.contains("the access token provided is invalid") ||
                    er.contains("oauth2 authentication required"):
                    observer(.error(AuthResponseHandlerError.requiredReAuthentication))
                    delegate?.doLogout()
                    return true
                    
                default:
                    break
                }
            } else if self.tokenState == .refreshing {
                let wasRequestTokenRefresh = request.formData?.contains(where: { $0.0 == refreshTokenQuery.0 && ($0.1 as? String) == refreshTokenQuery.1 }) == true
                if wasRequestTokenRefresh {
                    //запрос на рефреш завершился ошибкой
                    let err = AuthResponseHandlerError.requiredReAuthentication
                    observer(.error(err))
                    delegate?.doLogout()
                    self.tokenState = .active
                    self.processPendingRequests(with: err)
                } else {
                    self.pendingRequestsBlocks.append { err in
                        if err == nil {
                            _ = self.apiClient.execute(request: request).subscribe(observer)
                        } else {
                            observer(.error(err!))
                        }
                    }
                }
                return true
            } else {
                let isErrorRelatedToAuth = ["token", "expired", "invalid", "grant_type"].map(error.contains).reduce(false) { (acc, val) -> Bool in
                    return acc || val
                }
                if isErrorRelatedToAuth {
                    observer(.error(AuthResponseHandlerError.invalidRefreshToken))
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    private func refreshToken<T: Codable>(request: ApiRequest<T>, observer: @escaping SingleObserver<T>) {
        //        guard authUseCase.tokenCondition != .refreshing else {
        //            return
        //        }
        //        guard authUseCase.tokenCondition != .none else {
        //            delegate?.doLogout()
        //            return
        //        }
        self.tokenState = .refreshing
        authUseCase.refreshToken()
            .catchError({ (error) -> Completable in
                if error is AuthResponseHandlerError {
                    return .error(error)
                } else {
                    return self.authUseCase.refreshToken()
                        .delaySubscription(1, scheduler: self.timerQueue)
                }
            })
            .subscribe(onCompleted: { [weak self] in
                self?.tokenState = .active
                self?.processPendingRequests()
                }, onError: { error in
                    print("## failed to refresh token: \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func processPendingRequests(with error: Error? = nil) {
        let requestsToExecute = self.pendingRequestsBlocks.map({ $0 })
        self.pendingRequestsBlocks.removeAll()
        requestsToExecute.forEach({ $0(error) })
    }
}
