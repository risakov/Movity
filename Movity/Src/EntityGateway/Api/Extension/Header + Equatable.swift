import RxNetworkApiClient

extension Header: Equatable {

    public static func == (lhs: Header, rhs: Header) -> Bool {
        return lhs.key == rhs.key &&
               lhs.value == rhs.value
    }
}

extension Dictionary: BodyConvertible where Key: Codable, Value: Codable {
    
}

extension Dictionary: JsonBodyConvertible where Key: Codable, Value: Codable {
    
}
