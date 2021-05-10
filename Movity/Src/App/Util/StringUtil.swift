import Foundation

extension String {
    /**
     Возвращает случайный фрагмент строки.
     */
    public var sample: Character? {
        isEmpty ? nil : self[index(startIndex, offsetBy: Int(randomBelow: count)!)]
    }

    /**
     Возвращает случайный фрагмент строки.
     - parameter size: Длина фрагмента.
     - returns: Фрагмент строки
     */
    @inlinable
    public func sample(size: Int) -> String? {
        guard !isEmpty else { return nil }

        var sampleElements = String()
        size.times { sampleElements.append(sample! as Character) }

        return sampleElements
    }

    /**
     Инициализирует строку со случайным содержимым.
     - parameter length: Длина строки.
     - parameter allowedCharactersType: Тип допустимых символов.
     */
    public init(randomWithLength length: Int, allowedCharactersType: AllowedCharacters) {
        let allowedCharsString: String = {
            switch allowedCharactersType {
            case .numeric:
                return "0123456789"
                
            case .alphabetic:
                return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                
            case .alphaNumeric:
                return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                
            case let .allCharactersIn(allowedCharactersString):
                return allowedCharactersString
            }
        }()
        
        self.init(allowedCharsString.sample(size: length)!)
    }

    /**
     Строка без переносов текста.
     */
    var withoutLineBreak: String {
        self.replacingOccurrences(of: " ", with: "\u{a0}")
            .replacingOccurrences(of: "-", with: "\u{2011}")
    }
    

    /**
     Заменяет подстроки на заданную.
     - parameter string: Подстрока, которую заменить.
     - parameter replacement: Подстрока, на которую заменить.
     - returns: Фрагмент строки
     */
    func replace(_ string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string,
                                         with: replacement,
                                         options: NSString.CompareOptions.literal,
                                         range: nil)
    }

    /**
     Строка без пробелов.
     */
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }

    /**
     Форматирует строку с количеством секнд в человеческий вид
     - Remark:
     Пример:  36c; 20м 15с
     */
    func formatFromSeconds() -> String {

        let duration = Int(self.timeInterval)

        let minutes = duration / 60
        let seconds = duration % 60

        if minutes == 0 {
            return "\(seconds)" + "с"
        }
        return "\(minutes)" + "м" + " \(seconds)" + "с"
    }

    /**
     Конвертирует строку в TimeInterval
     */
    var timeInterval: TimeInterval {
        return TimeInterval((self as NSString).doubleValue)
    }

    /**
     Проверка на то, состоит ли строка только из букв и цифр.
     */
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    /**
     Возвращает строку, убрав из нее лишние пробелы.
     */
    func removeExtraSpaces() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    /**
     Проверка на содержание self в массиве строк.
     - returns: true, если содержится.
     */
    func containsIn(_ array: [String]) -> Bool {
        return array.contains { (key) -> Bool in
            key.lowercased().contains(self.lowercased())
        }
    }

    /**
     Проверка на валидность электронной почты в строке.
     - returns: true, если почта валидна.
     */
    var isValidEmail: Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    /**
     Возвращает ту же строку, но с заглавной первой буквой.
     - returns: String
     */
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    /**
     Заменяет первую букву в строке на заглавную.
     */
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    /// The type of allowed characters.
    public enum AllowedCharacters {
        /// Allow all numbers from 0 to 9.
        case numeric
        /// Allow all alphabetic characters ignoring case.
        case alphabetic
        /// Allow both numbers and alphabetic characters ignoring case.
        case alphaNumeric
        /// Allow all characters appearing within the specified String.
        case allCharactersIn(String)
    }
}
