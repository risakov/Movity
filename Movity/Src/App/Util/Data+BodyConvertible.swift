import Foundation
import RxNetworkApiClient

extension Data: BodyConvertible {
    /**
     Для удовлетворения протокола BodyConvertible, который требует метод для
     конвертации структуры в Data().
     - Returns: В данном случае себя же.
    */
    public func createBody() -> Data {
        return self
    }
    
}
