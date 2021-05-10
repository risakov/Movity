import UIKit

class StubView: UIView {

    @IBOutlet weak var stubImage: UIImageView!
    @IBOutlet weak var stubMessage: UILabel!

    func setup(_ image: UIImage, _ message: String) {
        self.stubImage.image = image
        self.stubMessage.text = message.localization()
        self.stubMessage.textColor = .gray

        self.setNeedsDisplay()
        self.setNeedsLayout()
    }

}
