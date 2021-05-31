import Foundation

protocol AllUsersSettings {
    func getSimpleState() -> Bool
    func setSimpleState(_ state: Bool)
}

protocol Settings: class {
    var token: TokenEntity? { get set }
    var user: UserEntity? { get set }
    
    func clearUserData()
}
