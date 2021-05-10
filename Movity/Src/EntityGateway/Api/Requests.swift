import Foundation
import RxNetworkApiClient
import RxSwift

extension ExtendedApiRequest {

    // Важно поменять структуру запросов в соответствии с Api проекта
    
    // MARK: /oauth

    static func loginRequest(_ login: String, _ password: String) -> ExtendedApiRequest {
        let appVersion = Bundle.main.shortVersion
        
        return extendedRequest(path: "/oauth/v2/token",
                               method: .get,
                               query: ("client_id", Config.clientId),
                               ("client_secret", Config.clientSecret),
                               ("grant_type", "password"),
                               ("username", login),
                               ("password", password),
                               ("version", appVersion))
    }

    static func tokenRefreshRequest(_ refreshToken: String) -> ExtendedApiRequest {
        return extendedRequest(path: "/oauth/v2/token",
                               method: .post,
                               formData: ["client_id": Config.clientId,
                                          "client_secret": Config.clientSecret,
                                          "grant_type": "refresh_token",
                                          "refresh_token": refreshToken])
    }
    
    static func registrationRequest(_ entity: CreateRegistrationRequestApiEntity) -> ExtendedApiRequest {
        return extendedRequest(path: "/v1/users",
                               method: .post,
                               headers: [Header.contentJson],
                               body: entity)
    }
    
    static func signUP(_ entity: SignUPEntity, _ locale: String) -> ExtendedApiRequest {
        return extendedRequest(path: "/users",
                               method: .post,
                               headers: [Header.contentJson, Header("localization", locale)],
                               body: entity,
                               query: ("lang", locale))
    }
    
    // MARK: - Devices

    static func registerDevice(_ deviceId: String) -> ExtendedApiRequest {
        let body = ApiDeviceEntity(deviceId: deviceId)

        return extendedRequest(path: "/devices",
                               method: .post,
                               headers: [Header.contentJson],
                               body: body)
    }
    
    // MARK: UserInfo
    
    static func getAccountRequest() -> ExtendedApiRequest {
        return extendedRequest(path: "/users/current", method: .get)
    }

    static func updateUserInfo(_ userId: Int, _ user: UserApiEntity) -> ExtendedApiRequest {
        return extendedRequest(path: "/users/\(userId)",
                               method: .put,
                               headers: [Header.contentJson],
                               body: user)
    }
    
    static func checkUserInfo(_ entity: CheckUserEntity) -> ExtendedApiRequest {
        return extendedRequest(path: "/users/check_user",
                               method: .post,
                               headers: [Header.contentJson],
                               body: entity)
    }
    
    // MARK: Version
    
    static func getVersion() -> ExtendedApiRequest {
        return extendedRequest(path: "/app_version",
                       method: .get)
    }
    
    // MARK: File
    
    static func uploadFile(_ file: UploadFile) -> ExtendedApiRequest {
        return extendedRequest(path: "/files",
                               method: .post,
                               files: [file])
    }
    
    static func createFileByPath(_ file: FileEntity) -> ExtendedApiRequest {
        return extendedRequest(path: "/fileobj",
                               method: .post,
                               headers: [Header.contentJson],
                               body: file)
    }
    
}

// swiftlint:enable file_length

