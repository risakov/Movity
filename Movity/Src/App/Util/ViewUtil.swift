import UIKit

extension UIView {
    /**
     Возвращает массив NSLayoutConstraint высот.
     - returns: [NSLayoutConstraint]
    */
    private func getHeightConstraints() -> [NSLayoutConstraint] {
        return self.constraints.filter({ $0.firstAttribute == .height })
    }
    
    /**
     Устанавливает значение высоты NSLayoutConstraint.
     - parameter value: CGFloat - значение высоты.
    */
    @objc func setHeightConstraint(_ value: CGFloat) {
        let heightConstraints = getHeightConstraints()
        if !heightConstraints.isEmpty {
            heightConstraints.forEach { constraint in
                constraint.constant = value
            }
        } else {
            self.translatesAutoresizingMaskIntoConstraints = false
            let constraint = heightConstraints.first ?? NSLayoutConstraint(item: self,
                                                                           attribute: NSLayoutConstraint.Attribute.height,
                                                                           relatedBy: NSLayoutConstraint.Relation.equal,
                                                                           toItem: nil,
                                                                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                                           multiplier: 1,
                                                                           constant: value)
            constraint.constant = value
            self.addConstraint(constraint)
        }
    }

}
