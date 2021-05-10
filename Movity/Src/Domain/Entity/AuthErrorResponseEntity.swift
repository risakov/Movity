import Foundation

class AuthErrorResponseEntity: LocalizedError, Codable {
    
    var error: String
    var error_description: String
    
    public var errorDescription: String? {
        return error_description
    }
    
    init(error: String, error_description: String) {
        self.error = error
        self.error_description = error_description
    }
}

class ErrorMessageResponseEntity: Codable {
    let message: String?
}

class ErrorMessageLOLResponseEntity: Codable {
    let ms: String?
}

class ErrorResponseEntity: LocalizedError, Codable {
    var title: String
    var detail: String
    var violations: [ViolationEntity]?
    
    init(title: String, detail: String, violations: [ViolationEntity]?) {
        self.title = title
        self.detail = detail
        self.violations = violations
    }
}

class ViolationEntity: Codable {
    var propertyPath: String?
    var message: String?
    
    var localizePropertyPath: String {
        switch self.propertyPath {
        case "phone": return "Номер телефона"
        case "email": return "Почта"
        case "name": return "Название"
            
        default: return self.propertyPath ?? ""
        }
    }
}
