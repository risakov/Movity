import Foundation
import RxSwift
import RxNetworkApiClient

open class ErrorResponseHandler: ResponseHandler {
    private let exceptions = [Config.googleStorageEndpoint]

    private let jsonDecoder = JSONDecoder()

    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        guard let urlResponse = response.urlResponse,
            let nsHttpUrlResponse = urlResponse as? HTTPURLResponse else {
                return false
        }
        if let host = nsHttpUrlResponse.url?.host,
            exceptions.first!.contains(host) {
            let errorEntity = ResponseErrorEntity(response.urlResponse)
            
            switch nsHttpUrlResponse.statusCode {
            case 408:

                return true

            case 500:
                return true

            case 502:
                return true

            case 503:
                return true

            case 504:
                return true

            case 404:
                // When performing a resumable upload, handle 404 Not Found errors
                //  by starting the entire upload over from the beginning.
                
                // Пример того, как должна выглядеть обработка ошибок
                
//                errorEntity.errors.append(R.string.errorResponseHandler.notFound())
//                observer(.error(errorEntity))
                return true

            default:
                break
            }
            
            return false
            
        } else if (300..<600).contains(nsHttpUrlResponse.statusCode) {
            let errorEntity = ResponseErrorEntity(response.urlResponse)

            if let data = response.data {

                if let responseAuthError = try? jsonDecoder.decode(AuthErrorResponseEntity.self, from: data) {
                    let error = responseAuthError.error_description
                    errorEntity.errors.append(error)
                }

                if let responseError = try? jsonDecoder.decode(ErrorResponseEntity.self, from: data) {
                    if let violations = responseError.violations {
                        let error = violations.reduce("", { (result, elem) in result +
                            (elem.localizePropertyPath) + ": " +
                            (elem.message ?? "") })
                        errorEntity.errors.append(error != "" ? error : responseError.detail)
                    } else {
                        errorEntity.errors.append(responseError.detail)
                    }
                }

                #if DEBUG
                var debugDescription = [String]()
                debugDescription.append("|| \(nsHttpUrlResponse.statusCode) ||\n")
                switch nsHttpUrlResponse.statusCode {
                case (300..<400):
                    debugDescription.append("Неверный редирект.\n")

                case (400..<500):
                    debugDescription.append("Неверный запрос.\n")

                case (500..<600):
                    debugDescription.append("Ошибка сервера.\n")

                default:
                    debugDescription.append("Неизвестная ошибка.\n")
                }
                errorEntity.errors.insert(contentsOf: debugDescription, at: 0)
                #endif
            }

            observer(.error(errorEntity))
            return true
        }
        return false
    }
}

