import Foundation

// MARK: - Version comparison
extension String {
    /**
     Внутренний метод для реализации сравнения версий, содержащихся в строках.
     - returns: ComparisonResult
     - Remark:
     Modified from the DragonCherry extension:
     https://github.com/DragonCherry/VersionCompare
     */
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        
        while versionComponents.count < targetComponents.count {
            versionComponents.append("0")
        }
        
        while targetComponents.count < versionComponents.count {
            targetComponents.append("0")
        }
        
        for (version, target) in zip(versionComponents, targetComponents) {
            result = version.compare(target, options: .numeric)
            if result != .orderedSame {
                break
            }
        }
        
        return result
    }
    /**
     Для сравнения версий, содержащихся в строках.
     - parameter targetVersion: Строка с версией,  с которой сравниваем self.
     - returns: true, если self == targetVersion
     */
    func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
    /**
     Для сравнения версий, содержащихся в строках.
     - parameter targetVersion: Строка с версией,  с которой сравниваем self.
     - returns: true, если self > targetVersion
     */
    func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
    /**
     Для сравнения версий, содержащихся в строках.
     - parameter targetVersion: Строка с версией,  с которой сравниваем self.
     - returns: true, если self >= targetVersion
     */
    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
    /**
     Для сравнения версий, содержащихся в строках.
     - parameter targetVersion: Строка с версией,  с которой сравниваем self.
     - returns: true, если self < targetVersion
     */
    func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
    /**
     Для сравнения версий, содержащихся в строках.
     - parameter targetVersion: Строка с версией,  с которой сравниваем self.
     - returns: true, если self <= targetVersion
     */
    func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }

    static func == (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedSame }
    
    static func < (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedAscending }
    
    static func <= (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) != .orderedDescending }
    
    static func > (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedDescending }
    
    static func >= (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) != .orderedAscending }
    
}
