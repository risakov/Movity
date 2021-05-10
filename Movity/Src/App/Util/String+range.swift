import Foundation

extension String {
    /**
     Находит range'и подстроки в исходной строке
     - parameter s: Искомая подстрока.
     - returns: Массив NSRange
    */
    func rangesOfString(s: String) -> [NSRange] {
        let re = try! NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: s), options: [])
        return re.matches(in: self, options: [], range: NSRange(location: 0, length: count)).compactMap({ $0.range })
    }
    
    /**
     Находит range'и подстроки в исходной строке
     - parameter s: Искомая подстрока.
     - returns: Массив Range<Index>
    */
    func ranges(of substring: String) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = range(of: substring,
                                options: [],
                                range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex,
                                locale: nil) {
            ranges.append(range)
        }
        return ranges
    }
    
    /**
     Конвертирует Range<Index> в NSRange
     - parameter range: Range<String.Index>
     - returns: NSRange
    */
    func getNsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
}
