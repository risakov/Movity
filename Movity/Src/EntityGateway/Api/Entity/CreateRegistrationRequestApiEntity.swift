import Foundation
import RxNetworkApiClient

struct CreateRegistrationRequestApiEntity: JsonBodyConvertible {
    let user: CreateRegistrationRequestEntity
}

struct CreateRegistrationRequestEntity: JsonBodyConvertible {
    let email: String
    let password: String
    let name: String
    let lastname: String
    let patronymic: String
}
