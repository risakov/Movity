import Foundation
import RxNetworkApiClient

extension ApiEndpoint {

    private(set) static var devApi = ApiEndpoint(Config.apiEndpoint)
    
    static func updateEndpoint() {
        ApiEndpoint.devApi = ApiEndpoint(Config.apiEndpoint)
    }
    
}
