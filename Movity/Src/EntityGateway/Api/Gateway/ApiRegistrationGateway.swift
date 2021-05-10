import Foundation
import RxSwift
import RxNetworkApiClient

class ApiRegistrationGateway: ApiBaseGateway, RegistrationGateway {
    func signUP(_ entity: SignUPEntity, _ locale: String) -> Single<UserEntity> {
        let request: ExtendedApiRequest<UserEntity> = .signUP(entity, locale)
        return apiClient.execute(request: request)
    }
    
    func sendReqistrationRequest(_ entity: CreateRegistrationRequestApiEntity) -> Single<UserEntity> {
        let request: ExtendedApiRequest<UserEntity> = .registrationRequest(entity)
        return apiClient.execute(request: request)
    }
}
