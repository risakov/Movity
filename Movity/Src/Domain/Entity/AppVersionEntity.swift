import Foundation
import RxNetworkApiClient

struct AppVersionApiEntity: Codable {
    var appVersion: AppVersionEntity?
}

struct AppVersionEntity: Codable {
    var version: String?
    var platform: String?
    var id: Int?
    
    init(id: Int, version: String, platform: String) {
        self.id = id
        self.version = version
        self.platform = platform
    }
}

extension AppVersionEntity: Equatable {
    
    static func == (lhs: AppVersionEntity, rhs: AppVersionEntity) -> Bool {
        return lhs.version == rhs.version &&
            lhs.platform == rhs.platform &&
            lhs.id == rhs.id
    }
}
