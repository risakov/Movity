import Foundation

public extension Optional {
    /**
     Пытается развернуть опциональную коллекцию.
     */
    func flatten<R>() -> R?
        where Wrapped == R? {
        return self.flatMap { $0 }
    }
}
