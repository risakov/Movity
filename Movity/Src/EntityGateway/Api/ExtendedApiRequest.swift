import RxNetworkApiClient

class ExtendedApiRequest<T: Codable>: ApiRequest<T> {

    override public init(_ endpoint: ApiEndpoint) {
        super.init(endpoint)
        super.responseTimeout = 30
    }
    
    override var request: URLRequest {
        var result = super.request
        result.timeoutInterval = self.responseTimeout
        return result
    }
    
    static public func extendedRequest<T: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            query: QueryField...) -> ExtendedApiRequest<T> {
        
        return ExtendedApiRequest
                    .extendedRequest(
                        path: path,
                        method: method,
                        endpoint: endpoint,
                        headers: headers,
                        formData: formData,
                        files: files,
                        body: body,
                        queryArr: query)
    }
    
    static public func extendedRequest<T: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            queryArr: [QueryField]) -> ExtendedApiRequest<T> {
        
        let request = ExtendedApiRequest<T>(endpoint)
        request.path = path
        request.method = method
        request.headers = headers
        request.formData = formData
        request.files = files
        request.body = body
        request.query = queryArr
        return request
    }
}

fileprivate extension Data {
    
    mutating func appendString(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: false)
        self.append(data!)
    }
}

fileprivate extension Array where Element == QueryField {
    
    func toString() -> String {
        var allowedSymbols = CharacterSet.alphanumerics
        allowedSymbols.insert(charactersIn: "-._~&=") // as per RFC 3986
        allowedSymbols.remove("+")
        
        if !self.isEmpty {
            let flatStringQuery = self.filter({ $0.1?.isEmpty == false })
                .compactMap({ "\($0)=\($1!)" })
                .joined(separator: "&")
                .addingPercentEncoding(withAllowedCharacters: allowedSymbols)!
            return "?\(flatStringQuery)"
        }
        return ""
    }
}

