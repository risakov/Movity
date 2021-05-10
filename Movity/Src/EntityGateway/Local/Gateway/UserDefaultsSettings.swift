import Foundation

open class UserDefaultsSettings {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults: UserDefaults
    static let globalSuiteName = "tizer"
    
    /// Suite "tizer" contains general information, including list of available user-related suite names.
    /// Suites "user-xxx" contains scripts and etc for user
    /// - Parameter userSuitName: name of the UserDefault instance suite.
    public init(userSuiteName: String? = nil) {
        self.userDefaults = UserDefaults(suiteName: userSuiteName ?? UserDefaultsSettings.globalSuiteName)!
    }
    
    func read<T: Codable>(_ key: UserDefaultsKeyType) -> T? {
        let keyValue = key.rawValue
        
        print("UserDefaults: reading key: \(keyValue) of type: \(T.self)")
        let value = userDefaults.value(forKey: keyValue)
        
        switch T.self {
        case is String.Type: return userDefaults.string(forKey: keyValue) as? T
        case is Double.Type: return userDefaults.double(forKey: keyValue) as? T
        case is Float.Type:  return userDefaults.float(forKey: keyValue) as? T
        case is Bool.Type:   return userDefaults.bool(forKey: keyValue) as? T
        case is Int.Type:    return userDefaults.integer(forKey: keyValue) as? T
            
        default:
            guard let data = value as? Data else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
    }
    
    func saveData<T: Codable>(_ key: UserDefaultsKeyType, _ value: T?) {
        print("UserSettings: save '\(key)' = '\(String(describing: value))' of type: \(T.self)")
        let keyValue = key.rawValue
        if value == nil {
            userDefaults.set(nil, forKey: keyValue)
            return
        }
        switch value {
        case is String: userDefaults.set(value as! String, forKey: keyValue)
        case is Double: userDefaults.set(value as! Double, forKey: keyValue)
        case is Float:  userDefaults.set(value as! Float, forKey: keyValue)
        case is Bool:   userDefaults.set(value as! Bool, forKey: keyValue)
        case is Int:    userDefaults.set(value as! Int, forKey: keyValue)
            
        default:
            let data = try! encoder.encode(value)
            userDefaults.set(data, forKey: keyValue)
        }
        userDefaults.synchronize()
    }
    
    public func resetUserDefaults() {
        UserDefaultsKey.clearable
            .forEach { key in
                self.userDefaults.removeObject(forKey: key.rawValue)
        }
        self.userDefaults.synchronize()
    }
}
