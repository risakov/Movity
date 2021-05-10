import Foundation
import RxSwift

protocol RemoteConfigGateway {
    func fetchRemoteConfig() -> Single<String>
}

