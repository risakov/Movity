import Foundation
import UIKit

extension NSMutableAttributedString {
    /**
     Выделяет жирным заданные подстроки в исходной изменяемой атрибутной строке.
     - Parameter substrings: Массив подстрок.
     - Parameter ofSize: Размер шрифта.
    */
    func setSubstringsBold(_ substrings: [String], ofSize: CGFloat) {
        substrings.forEach { self.setSubstringBold($0, ofSize: ofSize) }
    }
    
    /**
     Выделяет жирным заданную подстроку в исходной изменяемой атрибутной строке.
     - Parameter substrings: Подстрока.
     - Parameter ofSize: Размер шрифта.
    */
    func setSubstringBold(_ substring: String, ofSize: CGFloat) {
        self.string.ranges(of: substring).forEach {
            self.addAttribute(NSAttributedString.Key.font,
                              value: UIFont.systemFont(ofSize: ofSize, weight: .bold),
                              range: string.getNsRange(from: $0))
        }
    }
    
    /**
     Выделяет цветом заданную подстроку в исходной изменяемой атрибутной строке.
     Поддерживает многократный последовательный вызов.
     - Parameter substring: Подстрока.
     - Parameter color: Цвет выделения.
     - Returns: Итоговую строку для следующей итерации.
    */
    @discardableResult func setSubstringColor(_ substring: String, color: UIColor) -> NSMutableAttributedString {
        self.string.ranges(of: substring).forEach {
            self.addAttribute(NSAttributedString.Key.foregroundColor,
                              value: color,
                              range: string.getNsRange(from: $0))
        }
        return self
    }
}

extension NSMutableAttributedString {
    /**
     Добавляет к изменяемой атрибутной строке текст с заданными параметрами.
     Поддерживает многократный последовательный вызов.
     - Parameter UIColor: Цвет текста.
     - Parameter weight: Жирность текста.
     - Parameter ofSize: Размер текста.
     - Parameter text: Сам текст.
     - Returns: Итоговую строку для следующей итерации.
    */
    @discardableResult func appendWith(color: UIColor = UIColor.darkText,
                                       weight: UIFont.Weight = .regular,
                                       ofSize: CGFloat = 12.0,
                                       _ text: String) -> NSMutableAttributedString {
        let attrText = NSAttributedString.makeWith(color: color, weight: weight, ofSize: ofSize, text)
        self.append(attrText)
        return self
    }

}

extension NSAttributedString {
    /**
     Конвертирует исходную атрибутную строку в изменяемую с заданными параметрами.
     - Parameter UIColor: Цвет текста.
     - Parameter weight: Жирность текста.
     - Parameter ofSize: Размер текста.
     - Parameter text: Сам текст.
     - Returns: Изменяемую атрибутную строку.
    */
    public static func makeWith(color: UIColor = UIColor.darkText,
                                weight: UIFont.Weight = .regular,
                                ofSize: CGFloat = 12.0,
                                _ text: String) -> NSMutableAttributedString {

        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize,
                                                                    weight: weight),
                     NSAttributedString.Key.foregroundColor: color]
        return NSMutableAttributedString(string: text, attributes: attrs)
    }
}

