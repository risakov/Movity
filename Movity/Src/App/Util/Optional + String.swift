import Foundation

// MARK: - Опциональная строка
extension Swift.Optional where Wrapped == String {
    /**
     Возвращает true, если строка пуста или == nil.
     */
    var isEmptyOrNil: Bool {
        guard let self = self else { return true }
        return self.isEmpty
    }
}
