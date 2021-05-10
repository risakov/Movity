import Foundation
import RxNetworkApiClient

struct VersionResponse: JsonBodyConvertible {
    let results: [Version]?
}

struct Version: JsonBodyConvertible {
    let version: String?
}
