import Foundation

public extension Bundle {
    /**
     Возвращает версию приложения.
     - Returns: Строку с версией приложения
    */
    var shortVersion: String {
        if let result = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            return "-.-.-"
        }
    }

    /**
     Возвращает номер сборки.
     - Returns: Строку с номером сборки.
    */
    var buildVersion: String {
        if let result = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            return "-.-"
        }
    }

    /**
     Возвращает полную версию приложения: версия + номер сборки.
     - Returns: Строку с версией и номером сборки.
    */
    var fullVersion: String {
        return "\(shortVersion)(\(buildVersion))"
    }

    /**
     Возвращает имя пакета.
     - Returns: Строку с именем пакета.
    */
    var identifier: String {
        if let result = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return result
        } else {
            return ""
        }
    }
}
