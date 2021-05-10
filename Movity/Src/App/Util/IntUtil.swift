import Foundation
extension Int: Sequence {

    /**
     Инициализирует Int со случайным значением ниже заданного предела.
    */
    public init?(randomBelow upperLimit: Int) {
        guard upperLimit > 0 else { return nil }
        self = .random(in: 0 ..< upperLimit)
    }
    
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }

    /**
     Повторяет заданный блок кода self-раз.
    */
    @inlinable
    func times(f: () -> Void) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}
