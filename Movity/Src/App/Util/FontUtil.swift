import UIKit

extension NSString {
    /**
     Возвращает размер строки с указанным шрифтом, необходимый для отрисовки.
     - Parameter font: Шрифт для подсчета размера.
     - Returns: Размер строки.
    */
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
