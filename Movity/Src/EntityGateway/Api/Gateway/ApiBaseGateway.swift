import Foundation
import RxNetworkApiClient

class ApiBaseGateway {

    let apiClient: ApiClient

    init(_ apiClient: ApiClient) {
        self.apiClient = apiClient
    }
}
