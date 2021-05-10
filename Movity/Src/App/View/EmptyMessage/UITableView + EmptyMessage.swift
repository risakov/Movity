import UIKit

extension UITableView {

    /**
     Задает текст для отображения в фоне UITableView
     - Parameter message: Текст для вывода в фоне UITableView.
     - Parameter rect: Прямоугольник,  в который будет вписан EmptyMessage.
    */
    func emptyMessage(message: String, rect: CGRect? = nil) {

        let messageLabel = UILabel()

        let sizes: CGSize = bounds.size
        messageLabel.frame = CGRect(x: 0.0, y: 0.0, width: sizes.width, height: sizes.height)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        if let rect = rect {
            let sizes: CGSize = bounds.size
            self.backgroundView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: sizes.width, height: sizes.height))
            let container = UIView(frame: rect)
            self.backgroundView?.addSubview(container)
            container.addSubview(messageLabel)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        } else {
            self.backgroundView = messageLabel
        }
        self.separatorStyle = .none
    }

    //использовать этот метод
    /**
     Задает текст для отображения в фоне UITableView
     - Parameter message: Текст для вывода в фоне UITableView.
     - Parameter image: Изображение для вывода в фоне UITableView.
     - Parameter rect: Прямоугольник для позиционирования EmptyMessage.
    */
    func stubView(message: String, image: UIImage, take header: CGRect? = nil) {
        let sizes: CGSize = bounds.size
        let nib = R.nib.stubView
        guard let backgroundView = nib.instantiate(withOwner: nil)[0] as? StubView else {
            return
        }

        let rect = header != nil ? CGRect(x: 0,
                                          y: header!.maxY,
                                          width: sizes.width,
                                          height: sizes.height - header!.height) : CGRect(x: 0.0,
                                                                                          y: 0.0,
                                                                                          width: sizes.width,
                                                                                          height: sizes.height)

        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: sizes.width, height: sizes.height))
        backgroundView.frame = rect
        container.addSubview(backgroundView)

        backgroundView.setup(image, message)
        self.backgroundView = container

        self.separatorStyle = .none
    }

    /**
     Прячет фоновый текст UITableView
    */
    func hideEmptyMessage() {
        self.backgroundView = nil
    }

    /**
     Прячет фоновый текст UITableView и возвращает разделители ячейкам
    */
    func hideEmptyMessageAndSetSeparators() {
        self.hideEmptyMessage()
        self.separatorColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        self.separatorStyle = .singleLine
    }

    /**
     Изменяет высоту хедера UITableView
    */
    func updateHeaderHeight(_ height: CGFloat) {
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = headerView.bounds.size.width

        let temporaryWidthConstraints = NSLayoutConstraint.constraints(
                                            withVisualFormat: "[headerView(width)]",
                                            options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)),
                                            metrics: ["width": headerWidth],
                                            views: ["headerView": headerView])

        headerView.addConstraints(temporaryWidthConstraints)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        var frame = headerView.frame

        frame.size.height = height
        headerView.frame = frame

        self.tableHeaderView = headerView

        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

