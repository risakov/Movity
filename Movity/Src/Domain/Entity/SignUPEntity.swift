import Foundation
import RxNetworkApiClient

public struct SignUPEntity: JsonBodyConvertible {
    var username: String?
    var firstName: String
    var secondName: String?
    var password: String
    var email: String?
    var phone: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName
        case secondName
        case password
        case email
        case phone
    }
}
