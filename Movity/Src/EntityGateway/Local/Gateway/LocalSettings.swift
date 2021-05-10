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

    var account: UserEntity? {
        get {
            return self.userDefaults.read(UserDefaultsKey.account)
        }
        set(value) {
            self.userDefaults.saveData(UserDefaultsKey.account, value)
        }
    }
    
    var accountsSuiteNames: [String]? {
        get {
            return self.userDefaults.read(UserDefaultsKey.accountsSuiteNames)
        }
        set(value) {
            self.userDefaults.saveData(UserDefaultsKey.accountsSuiteNames, value)
        }
    }

    private let userDefaults: UserDefaultsSettings

    init(userDefaults: UserDefaultsSettings) {
        self.userDefaults = userDefaults
    }

    func clearUserData() {
        self.token = nil
        self.account = nil
        self.userDefaults.resetUserDefaults()
    }
}
