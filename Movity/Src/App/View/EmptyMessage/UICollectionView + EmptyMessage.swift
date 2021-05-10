import UIKit

extension UICollectionView {

    /**
     Задает текст для отображения в фоне UICollectionView
     - Parameter message: Текст для вывода в фоне UICollectionView.
    */
    func emptyMessage(message: String) {
        let sizes: CGSize = bounds.size

        let messageLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: sizes.width, height: sizes.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }

//    func emptyMessageWithImage(message: String, image: UIImage) {
//        let sizes: CGSize = bounds.size
//
//        let nib = R.nib.backgroundTableView
//        let backgroundView = nib.instantiate(withOwner: nil)[0] as? BackgroundTableView
//        backgroundView?.frame = CGRect(x: 0.0, y: 0.0, width: sizes.width, height: sizes.height)
//
//        backgroundView?.setup(message: message, image: image)
//
//        self.backgroundView = backgroundView
//    }

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
    }

    func hideEmptyMessage() {
        self.backgroundView = nil
    }
}

