import Foundation
import RxSwift
import RxNetworkApiClient

class ApiPushNotificationSyncGateway: ApiBaseGateway, PushNotificationSyncGateway {
    
    func registerDevice(deviceId: String) -> Completable {
        
        let request: ApiRequest<Data> = ExtendedApiRequest.registerDevice(deviceId)
        request.responseTimeout = 120
        return self.apiClient.execute(request: request)
            .asCompletable()
            .timeout(120, scheduler: MainScheduler.instance)
    }
}
