import UIKit

extension NSTextAttachment {
    /**
     Устанавливает высоту для вложенной в атрибутную строку картинки.
     - parameter height: CGFloat - высота
    */
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height

        bounds = CGRect(x: bounds.origin.x,
                        y: bounds.origin.y,
                        width: ratio * height, height: height)
    }
}
