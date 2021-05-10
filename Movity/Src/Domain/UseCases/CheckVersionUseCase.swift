import Foundation
import RxSwift

protocol CheckVersionUseCase {
    func getVersion() -> Single<PaginationEntity<AppVersionEntity>>
}

class CheckVersionUseCaseImp: CheckVersionUseCase {
    var checkVersionGateway: CheckVersionGateway?
    
    init(_ checkVersionGateway: CheckVersionGateway) {
        self.checkVersionGateway = checkVersionGateway
    }
    
    func getVersion() -> Single<PaginationEntity<AppVersionEntity>> {
        return self.checkVersionGateway!.getVersion()
    }
}
