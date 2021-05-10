import Foundation
import RxSwift

protocol UserGateway {
    func getAccount() -> Single<UserEntity>
    func updateInfoUser(_ userId: Int, _ user: UserApiEntity) -> Completable
}
