import Foundation
import RxSwift
import RxNetworkApiClient

class ApiUserGateway: ApiBaseGateway, UserGateway {

    func getAccount() -> Single<UserEntity> {
        return apiClient.execute(request: ExtendedApiRequest.getAccountRequest())
    }

    func updateInfoUser(_ userId: Int, _ user: UserApiEntity) -> Completable {
        let request: ApiRequest<Data> = ExtendedApiRequest.updateUserInfo(userId, user)
        return apiClient.execute(request: request).asCompletable()
    }
    
}
