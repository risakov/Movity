import Foundation
import RxNetworkApiClient

class FileEntity: Codable, CustomStringConvertible, Hashable {

    var id: Int?
    var name: String?
    var path: String?

    var description: String {
        return "FileCreatedEntity(id: \(String(describing: id)), name: \(String(describing: name)), path: \(String(describing: path)))"
    }
    
    func hash(into hasher: inout Hasher) {
        var result = id.hashValue
        result = result &* 31 &+ name.hashValue
        result = result &* 31 &+ path.hashValue
        hasher.combine(result)
    }

    static func == (lhs: FileEntity, rhs: FileEntity) -> Bool {
        if lhs === rhs { return true }
        if type(of: lhs) != type(of: rhs) { return false }
        if lhs.id != rhs.id { return false }
        if lhs.name != rhs.name { return false }
        if lhs.path != rhs.path { return false }
        return true
    }
}

extension FileEntity: UrlFormatable {

    var urlPath: String? {
        return "/uploads/\(self.path!)"
    }
    
    var iri: String? {
        return "\(Config.extraPath)/files/\(self.id!)"
    }
}

extension FileEntity: BodyConvertible {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case path
    }
    
    func createBody() -> Data {
        let jsonEncoder = JSONEncoder()
        return try! jsonEncoder.encode(self)
    }
}

protocol UrlFormatable {
    
    var urlPath: String? { get }
}

extension UrlFormatable {
    
    func parseURL() -> URL? {
        guard let path = self.urlPath, !path.isEmpty else {
            return nil
        }
        return URL(string: Config.apiEndpoint + path)
    }
    
    func cachedURL() -> URL? {
        return self.parseURL().flatMap { try? CacheUtil.cached(remoteUrl: $0) }
    }
}
