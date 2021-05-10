import RxSwift
import SwiftyJSON
import RxNetworkApiClient

public typealias ResponseHeaders = [AnyHashable: Any]?

public protocol EntityWithHeaders {
    var responseHeaders: ResponseHeaders? { get set }
}

/// Возвращает требуемый объект или JSON объект, если ответ успешный.
open class ExtendedJsonResponseHandler: ResponseHandler {
    
    public init() {
    }
    
    private let decoder = JSONDecoder()
    
    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        if let data = response.data {
            do {
                if T.self == JSON.self {
                    let json = try JSON(data: data)
                    observer(.success(json as! T))
                } else if T.self == Data.self {
                    observer(.success(data as! T))
                    
                } else if T.self == GoogleStorageResponseEntity?.self {
                    
                    let decodedResult = try? decoder.decode(GoogleStorageResponseEntity.self,
                                                            from: data)
                    
                    let response = response.urlResponse as? HTTPURLResponse
                    let headers = response?.allHeaderFields
                    
                    let finalResult = GoogleStorageResponseEntity(decodedResult, headers)
                    observer(.success(finalResult as! T))
                    
                } else {
                    
                    let result = try decoder.decode(T.self, from: data)
                    
                    guard let resultWithHeaders = result as? EntityWithHeaders else {
                        observer(.success(result))
                        return true
                    }
                    let response = response.urlResponse as? HTTPURLResponse
                    var finalResult = resultWithHeaders
                    finalResult.responseHeaders = response?.allHeaderFields
                    observer(.success(finalResult as! T))
                }
            } catch {
                observer(.error(error))
            }
            return true
        }
        return false
    }
}
