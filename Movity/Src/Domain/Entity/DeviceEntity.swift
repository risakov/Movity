import Foundation
import RxNetworkApiClient

struct ApiDeviceEntity: JsonBodyConvertible {

    var platform: String = "ios"
    let deviceId: String

    init(deviceId: String) {
        self.deviceId = deviceId
    }
}

struct DeviceEntity: Codable {

    let id: Int
    let deviceId: String
    
}
