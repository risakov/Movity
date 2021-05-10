import Foundation
import RxNetworkApiClient

class UserEntity: JsonBodyConvertible {

    let email: String?
    let name: String?
    let lastname: String?
    let patronymic: String?
    let gender: Gender?
    let cityname: String?
    let birthDate: String?
    
    init(_ email: String?,
         _ name: String?,
         _ lastname: String?,
         _ patronymic: String?,
         _ gender: Gender?,
         _ cityname: String?,
         _ birthDate: String?) {
        self.email = email
        self.name = name
        self.lastname = lastname
        self.patronymic = patronymic
        self.gender = gender
        self.cityname = cityname
        self.birthDate = birthDate
    }

}

class UserApiEntity: JsonBodyConvertible {
    let email: String?
    let name: String?
    let lastname: String?
    let patronymic: String?
    let gender: Gender?
    let cityname: String?
    let birthDate: String?

    init(user: UserEntity) {
        self.email = user.email
        self.name = user.name
        self.lastname = user.lastname
        self.patronymic = user.patronymic
        self.gender = user.gender
        self.cityname = user.cityname
        self.birthDate = user.birthDate
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
                          self.patronymic,
                          self.gender,
                          self.cityname,
                          self.birthDate)
    }
}
