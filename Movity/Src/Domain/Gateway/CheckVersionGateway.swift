import Foundation
import RxSwift

protocol CheckVersionGateway {
    func getVersion() -> Single<PaginationEntity<AppVersionEntity>>
}
