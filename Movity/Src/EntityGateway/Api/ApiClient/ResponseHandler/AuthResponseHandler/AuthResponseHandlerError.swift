import Foundation

enum AuthResponseHandlerError: LocalizedError {

    case requiredReAuthentication
    case errorApplication
    case invalidClient
    case missingParameters
    case invalidCombination

    case invalidRefreshToken
    
    case codeNotFound
    case codeTimeOut

    var errorDescription: String? {
        switch self {

        // Возвращаются ошибки в строках через R.string в необходимой локализации. Пример в первом кейсе
        case .requiredReAuthentication:
            return ""
//            return R.string.authResponseHandler.userNotActivated()
            
        case .errorApplication:
            return ""

        case .invalidClient:
            return ""
            
        case .missingParameters:
            return ""
            
        case .invalidCombination:
            return ""
            
        case .invalidRefreshToken:
            return ""
            
        case .codeNotFound:
            return ""
            
        case .codeTimeOut:
            return ""
        }
    }
}
