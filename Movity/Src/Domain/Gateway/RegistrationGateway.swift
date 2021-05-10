import Foundation
import RxSwift

protocol RegistrationGateway {
    func sendReqistrationRequest(_ entity: CreateRegistrationRequestApiEntity) -> Single<UserEntity>
    func signUP(_ entity: SignUPEntity, _ locale: String) -> Single<UserEntity>
}
