import UIKit

extension NSAttributedString {
    /**
     Формирует атрибутную строку в виде списка с пунктами из массива строк.
     - Parameter stringList: Массив строк, элементы которого станут элементами списка.
     - Parameter font: Шрифт.
     - Parameter bullet: Символ в начале строки каждоко пункта.
     - Parameter indentation: Углубление.
     - Parameter lineSpacing: Расстояние между строками.
     - Parameter paragraphSpacing: Расстояние между пунктами
     - Parameter textColor: Цвет текста.
     - Parameter bulletColor: Цвет символа в начале строки каждоко пункта.
     - Returns: Форматированный список.
    */
    static func add(stringList: [String],
                    font: UIFont,
                    bullet: String = "\u{2022}",
                    indentation: CGFloat = 20,
                    lineSpacing: CGFloat = 2,
                    paragraphSpacing: CGFloat = 12,
                    textColor: UIColor = .gray,
                    bulletColor: UIColor = .red) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                             NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font:
                                                               UIFont.systemFont(ofSize: 25),
                                                               NSAttributedString.Key.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left,
                                             location: indentation,
                                             options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                           range: NSRange(location: 0, length: attributedString.length))

            attributedString.addAttributes(textAttributes,
                                           range: NSRange(location: 0, length: attributedString.length))

            let string = NSString(string: formattedString)
            let rangeForBullet = string.range(of: bullet)
            
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
}
