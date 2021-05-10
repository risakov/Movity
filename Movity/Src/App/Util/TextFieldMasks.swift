import Foundation

/**
    Расширение для масок нотификации. Регулярки для того, чтобы сохранялась разметка текста в UITextField.
 */
enum TextFieldMasks {
    case phone
    case email
    
    var mask: String {
        switch self {
        case .phone:
            return "([000]-[00]-[00]"
        case .email:
            return "[----------------------------------]{@}[---------------]{.}[---------------]"
        }
    }
}
