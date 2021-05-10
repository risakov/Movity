import Foundation
import RxSwift

protocol PushNotificationSyncGateway {
    func registerDevice(deviceId: String) -> Completable
}
