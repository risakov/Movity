import Foundation
import RxNetworkApiClient

/// Добавляет к каждому запросу заголовок авторизации, если есть токен авторизации.
class AuthInterceptor: Interceptor {

    private let settings: Settings
    private let exceptions = [Config.googleStorageEndpoint]

    init(_ settings: Settings) {
        self.settings = settings
    }
    
    func prepare<T: Codable>(request: ApiRequest<T>) {
        
        guard !self.exceptions.contains(request.endpoint.host) else {
            return
        }
        
        if request.path?.contains("oauth") != true {
            let authHeaderKey = "Authorization"
            //        let index = request.headers?.index(where: { $0.key == authHeaderKey})
            let index = request.headers?.firstIndex(where: { $0.key == authHeaderKey })
            if let auth = settings.token {
                let authHeader = Header(authHeaderKey, "Bearer \(auth.access_token)")
                if index == nil {
                    if request.headers == nil {
                        request.headers = [authHeader]
                    } else {
                        request.headers!.append(authHeader)
                    }
                } else {
                    request.headers![index!] = authHeader
                }
            }
        }
    }

    func handle<T: Codable>(request: ApiRequest<T>,
                            response: NetworkResponse) {
        // empty
    }
}
