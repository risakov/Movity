import Foundation
import RxSwift
import RxNetworkApiClient

class ApiCheckVersionGateway: ApiBaseGateway, CheckVersionGateway {
    
    func getVersion() -> Single<PaginationEntity<AppVersionEntity>> {
        return self.apiClient.execute(request: ExtendedApiRequest.getVersion())
    }
}
