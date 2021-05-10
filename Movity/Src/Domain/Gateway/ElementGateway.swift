import Foundation
import RxSwift

protocol ElementGateway {
    func getElements(_ elementId: Int, _ page: Int) -> Single<PaginationEntity<ElementEntity>>
}
