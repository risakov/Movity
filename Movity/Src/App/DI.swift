import DITranquillity
import RxNetworkApiClient

class DI {
    
    private static let shared = DI()
    
    fileprivate(set) static var container = DIContainer()
    fileprivate(set) static var backgroundContainer = DIContainer()
    
    private init() {
        // No Constructor
    }
    
    /// Фоновые процессы
    static func initBackgroundDependencies() {
        // self.backgroundContainer.register({ () -> SomeUseCase in
        //      return SomeUseCase()
        // })
        // .as(SomeProtocol.self)
        // .lifetime(.single)
    }

    /// Основные зависимости
    // swiftlint:disable: function_body_length
    static func initDependencies(_ appDelegate: AppDelegate) {
        
        DI.container = DIContainer(parent: backgroundContainer)
        
        ApiEndpoint.baseEndpoint = ApiEndpoint.devApi
        
        self.container.register(AuthInterceptor.init)
            .as(AuthInterceptor.self)
            .lifetime(.single)
        
        self.container.register {
            AuthResponseHandler(appDelegate, $0, $1, $2)
        }
        .as(AuthResponseHandler.self)
        .lifetime(.single)
        
        self.container.register { () -> ApiClientImp in
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 60 * 20
            config.timeoutIntervalForResource = 60 * 20
            config.waitsForConnectivity = true
            config.shouldUseExtendedBackgroundIdleMode = true
            config.urlCache?.removeAllCachedResponses()
            let client = ApiClientImp(urlSessionConfiguration: config, completionHandlerQueue: .main)
            client.responseHandlersQueue.append(ErrorResponseHandler())
            client.responseHandlersQueue.append(JsonResponseHandler())
            client.responseHandlersQueue.append(NSErrorResponseHandler())
            if ProcessInfo.processInfo.arguments.contains("IS_NETWORK_LOGGING_ENABLED") {
                client.interceptors.append(ExtendedLoggingInterceptor())
            }
            client.interceptors.append(JsonContentInterceptor())
            client.interceptors.append(ExtraPathInterceptor())
            return client
        }
        .as(ApiClient.self)
        .injection(cycle: true) {
            $0.responseHandlersQueue.insert($1 as AuthResponseHandler, at: 0)
        }
        .injection(cycle: true) {
            $0.interceptors.insert($1 as AuthInterceptor, at: 0)
        }
        .lifetime(.single)
        
        self.container.register(UserDefaultsSettings.init)
            .as(UserDefaultsSettings.self)
            .lifetime(.single)
        
        self.container.register {
            LocalSettings(userDefaults: $0)
        }
        .as(Settings.self)
        .lifetime(.single)
        
        // MARK: - Gateways
        
        self.container.register(ApiRegistrationGateway.init)
            .as(RegistrationGateway.self)
            .lifetime(.single)
        
        self.container.register(ApiAuthenticationGateway.init)
            .as(AuthenticationGateway.self)
            .lifetime(.single)
        
        self.container.register(ApiUserGateway.init)
            .as(UserGateway.self)
            .lifetime(.single)
        
        // MARK: - UseCases
        
        self.container.register(AuthUseCaseImp.init)
            .as(AuthUseCase.self)
    }
    // swiftlint:enable: function_body_length

    static func resolve<T>() -> T {
        return self.container.resolve()
    }
    
    static func resolveBackground<T>() -> T {
        return self.backgroundContainer.resolve()
    }
}
