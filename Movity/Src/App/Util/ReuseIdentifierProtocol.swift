import UIKit

protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String { get }
}

extension UITableViewHeaderFooterView: ReuseIdentifierProtocol {
    /**
     Возвращает reuseIdentifier хедера/футера.
     */
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifierProtocol {
    /**
     Возвращает reuseIdentifier ячейки.
     */
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReuseIdentifierProtocol {
    /**
     Возвращает reuseIdentifier ячейки.
     */
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
