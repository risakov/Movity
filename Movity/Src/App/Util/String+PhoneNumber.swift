import Foundation

extension String {
    /**
     Применяет заданный паттерн форматирования на строку с номером телефона.
     - parameter pattern: Сам паттерн.
     - parameter replacmentCharacter: Символ, заменяемый цифрами номера
     - returns: Форматированный номер телефона
    */
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    /**
     Возвращает строку, форматированную по паттерну +# (###) ###-####
     */
    public var phoneNumber: String {
        return self.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
    }
    
    /**
     Примитивная проверка строки на вероятность того, что в ней содиржится номер.
     По сути, проверка на непустоту и содержание цифр без примесей..
     */
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
