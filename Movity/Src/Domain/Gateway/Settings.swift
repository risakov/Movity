import Foundation

protocol AllUsersSettings {
    func getSimpleState() -> Bool
    func setSimpleState(_ state: Bool)
}

protocol Settings: class {
    var token: TokenEntity? { get set }
    var account: UserEntity? { get set }
    var accountsSuiteNames: [String]? { get set }

    func clearUserData()
}
