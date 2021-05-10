import Foundation
import RxNetworkApiClient

class GoogleStorageResponseEntity: EntityWithHeaders {
    
    var responseHeaders: ResponseHeaders?
    
    let generation: String?
    let name: String?
    
    init(name: String?,
         generation: String?) {
        self.responseHeaders = nil
        self.generation = generation
        self.name = name
    }
    
    public init(_ response: GoogleStorageResponseEntity?,
                _ headers: ResponseHeaders?) {
        self.responseHeaders = headers
        self.generation = response?.generation
        self.name = response?.name
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        let generation = try? container?.decode(String?.self, forKey: .generation) ?? ""
        let name = (try? container?.decode(String?.self, forKey: .name)) ?? ""
        self.init(name: name, generation: generation)
    }
}

extension GoogleStorageResponseEntity: Codable {
    private enum CodingKeys: String, CodingKey {
        case responseHeaders
        case generation
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(generation, forKey: .generation)
        try container.encode(name, forKey: .name)
    }
}

extension GoogleStorageResponseEntity: BodyConvertible {
    func createBody() -> Data {
        let jsonEncoder = JSONEncoder()
        return try! jsonEncoder.encode(self)
    }
}
