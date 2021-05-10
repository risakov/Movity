import Foundation
import RxSwift
import RxNetworkApiClient

protocol RemoteConfigUseCase {
}

class RemoteConfigUseCaseImp: RemoteConfigUseCase {
    
    let configGateway: RemoteConfigGateway
    
    init(_ configGateway: RemoteConfigGateway) {
        self.configGateway = configGateway
    }
}
