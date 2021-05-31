import Foundation

class LocalSettings: Settings {

    var token: TokenEntity? {
        get {
            return self.userDefaults.read(UserDefaultsKey.token)
        }
        set(value) {
            self.userDefaults.saveData(UserDefaultsKey.token, value)
        }
    }

    var user: UserEntity? {
        get {
            return self.userDefaults.read(UserDefaultsKey.account)
        }
        set(value) {
            self.userDefaults.saveData(UserDefaultsKey.account, value)
        }
    }
    
    private let userDefaults: UserDefaultsSettings

    init(userDefaults: UserDefaultsSettings) {
        self.userDefaults = userDefaults
    }

    func clearUserData() {
        self.token = nil
        self.user = nil
        self.userDefaults.resetUserDefaults()
    }
}
