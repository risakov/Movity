import Foundation

enum ErrorForTextField: LocalizedError {
    
    case nameFieldIsEmpty
    case lastnameFieldIsEmpty
    case patronymicFieldIsEmpty
    case cityFieldIsEmpty
    case loginFieldIsEmpty
    case phoneFieldIsEmpty
    case emailFieldIsEmpty
    case passwordFieldIsEmpty
    case passwordFieldIsTooShort
    case phoneOrEmailIsEmpty
    case phoneOrEmailIsIncorrect
    case codeIsEmpty
    case incorrectPhone
    case incorrectEmail
    
    var errorDescription: String? {
        switch self {
        case .loginFieldIsEmpty:
            return "Введите логин"
            
        case .phoneFieldIsEmpty:
            return "Введите номер телефона"
            
        case .emailFieldIsEmpty:
            return "Введите e-mail"
            
        case .passwordFieldIsEmpty:
            return "Введите пароль"
            
        case .passwordFieldIsTooShort:
            return "Не менее 6 символов"
            
        case .nameFieldIsEmpty:
            return "Введите имя"
            
        case .lastnameFieldIsEmpty:
            return "Введите фамилию"
            
        case .patronymicFieldIsEmpty:
            return "Введите отчество"
            
        case .cityFieldIsEmpty:
            return "Введите город"
            
        case .phoneOrEmailIsEmpty:
            return "Введите e-mail или телефон"
            
        case .phoneOrEmailIsIncorrect:
            return "Некорректный e-mail или телефон"
            
        case .codeIsEmpty:
            return "Некорректный код"
            
        case .incorrectPhone:
            return "Некорректный телефон"

        case .incorrectEmail:
            return "Некорректный email"
        }
    }
    
}
