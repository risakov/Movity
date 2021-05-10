import RxNetworkApiClient

class JsonContentInterceptor: Interceptor {

    func prepare<T: Codable>(request: ApiRequest<T>) {
        var headers = request.headers ?? [Header]()

        if !headers.contains(.acceptJson) {
            headers.append(.acceptJson)
            request.headers = headers
        }
    }

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        // Noting to do.
    }
}

class ExtraPathInterceptor: Interceptor {
    
    func prepare<T: Codable>(request: ApiRequest<T>) {

//        #if DEBUG
        if request.path?.contains("oauth") != true &&
            request.path?.contains("uploads") != true &&
            request.path?.contains("/api") != true &&
            request.path?.contains("/lookup") != true {
            request.path = Config.extraPath + (request.path ?? "")
        }
//        #endif

    }

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        // Noting to do.
    }
}

