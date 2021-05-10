import Foundation
import RxSwift
import RxNetworkApiClient

class ApiAuthenticationGateway: ApiBaseGateway, AuthenticationGateway {

    func auth(_ username: String, _ password: String) -> Single<TokenEntity> {
        return apiClient.execute(request: ExtendedApiRequest.loginRequest(username, password))
    }

    func refreshToken(_ refreshToken: String) -> Single<TokenEntity> {
        return apiClient.execute(request: ExtendedApiRequest.tokenRefreshRequest(refreshToken))
    }
    
}
