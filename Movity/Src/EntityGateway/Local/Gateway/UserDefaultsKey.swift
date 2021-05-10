import Foundation

protocol UserDefaultsKeyType {
    var rawValue: String { get }
}

enum UserDefaultsKey: String, CaseIterable, UserDefaultsKeyType {

    case token,
         account,
         accountsSuiteNames,
         deviceId,
         fbEndpoint
    
    case simpleState,
         searchedQueries
    
    static var clearable: [UserDefaultsKey] {
        return UserDefaultsKey.allCases.filter({$0 != .simpleState &&
                                                $0 != .searchedQueries})
    }
}
