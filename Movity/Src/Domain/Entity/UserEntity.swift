import Foundation
import RxNetworkApiClient

class UserEntity: JsonBodyConvertible {

    let email: String?
    let name: String?
    let lastname: String?
    let patronymic: String?

    init(_ email: String?,
         _ name: String?,
         _ lastname: String?,
         _ patronymic: String?) {
        self.email = email
        self.name = name
        self.lastname = lastname
        self.patronymic = patronymic
    }

}

class UserApiEntity: JsonBodyConvertible {
    let email: String?
    let name: String?
    let lastname: String?
    let patronymic: String?

    init(user: UserEntity) {
        self.email = user.email
        self.name = user.name
        self.lastname = user.lastname
        self.patronymic = user.patronymic

    }

}

enum Gender: String, Codable {
    case male
    case female
}

extension UserEntity {
    func getCopy() -> UserEntity {
        return UserEntity(self.email,
                          self.name,
                          self.lastname,
                          self.patronymic)
    }
}
