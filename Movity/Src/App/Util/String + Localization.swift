import Foundation

extension String {
    /**
     Служит для локализации строк. В данном случае исходная строка расценивается,
     как ключ для поиска значения по нему в словарях.
     - Returns: Локализованная строка из словарей переводов.
    */
    func localization() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
