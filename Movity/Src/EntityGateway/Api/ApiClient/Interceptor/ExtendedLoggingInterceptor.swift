import RxNetworkApiClient
import SwiftyJSON

class ExtendedLoggingInterceptor: Interceptor {
    private let exceptions = [Config.googleStorageEndpoint]
    public init() {
    }

    public func prepare<T: Codable>(request: ApiRequest<T>) {
        let urlRequest = request.request
        var parameters = ""
        if let params = urlRequest.httpBody {
            let body = String(data: params, encoding: .utf8)
                       ?? String(data: params, encoding: .ascii)
                          ?? "\(params)"

            if request.files?.isEmpty == false {
                parameters = "File Content!"
            } else {
                if self.exceptions.contains(request.endpoint.host) {
                parameters = "Parameters: \(body.sample(size: 150) ?? "nil") (...)"
                } else {
                    parameters = "Parameters: \(body)"
                }
            }
        }

        print(">>>>>>>>>>>>>>>>>>>>>>>>")
        print("Headers:")
        urlRequest.allHTTPHeaderFields?.forEach { key, value in
            print("\(key) : \(value)")
        }
        print("\(urlRequest.url!.absoluteString) [\(urlRequest.httpMethod ?? "NULL")] \(parameters)\n")
        print(">>>>>>>>>>>>>>>>>>>>>>>>")
    }

    public func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        print("<<<<<<<<<<<<<<<<<<<<<<<<")
        if let urlResponse = response.urlResponse {

            var responseBody: String?

            if let data = response.data {
                responseBody = String(data: data, encoding: .utf8)
            }

            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                print("\(urlResponse.url!.absoluteString) \(String(describing: responseBody))")
                return
            }
            let statusEmoji = getStatusEmoji(httpUrlResponse.statusCode)

            print("Headers:")
            httpUrlResponse.allHeaderFields.forEach { key, value in
                print("\(key) : \(value)")
            }
            print("\(urlResponse.url!.relativeString)")
            print("Status code: (\(httpUrlResponse.statusCode)) \(statusEmoji)")

            if let responseStringBody = responseBody {

                guard let responseData = response.data,
                      let object = try? JSONSerialization.jsonObject(with: responseData, options: []),
                      let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
                      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                    print("Body: \(responseStringBody)")
                    return
                }

                print(prettyPrintedString)
            } else {
                print("Raw Body: \(String(describing: response.data))\n")
            }
        } else {
            print("nil response")
        }
        print("<<<<<<<<<<<<<<<<<<<<<<<<")
    }

    private func getStatusEmoji(_ code: Int) -> String {
        if (200..<300).contains(code) {
            return "👌"
        } else if (400..<500).contains(code) {
            return "🤔"
        } else if (500..<600).contains(code) {
            return "💥"
        }
        return ""
    }
}
