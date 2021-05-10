import Foundation
import RxNetworkApiClient

struct CheckUserEntity: JsonBodyConvertible {
    let email: String?
    let name: String?
    let lastname: String?
    let patronymic: String?
    let gender: Gender?
    let cityname: String?
    let birthDate: String?
}

