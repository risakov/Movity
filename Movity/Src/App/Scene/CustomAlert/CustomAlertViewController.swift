import UIKit

class CustomAlertViewController: UIViewController {

    var presenter: CustomAlertPresenter!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: DesignableUIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func onOkButtonTap(_ sender: DesignableUIButton) {
        self.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLabels()
        self.presenter.saveTabBarInteractionState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.updateUserInteractionsOnTabBarItems(isEnabled: false)
//        AppDelegate.shared.lockPortraitOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateBackground(isHidden: false)
        self.presenter.updateUserInteractionsOnTabBarItems(isEnabled: false)
//        AppDelegate.shared.lockPortraitOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateBackground(isHidden: true)
        self.presenter.updateUserInteractionsOnTabBarItems(isEnabled: true)
//        AppDelegate.shared.unlockOrientation()
    }
    
    func setupLabels() {
        let strings = self.presenter.getStrings()
        self.titleLabel.text = strings.title
        self.descriptionTextView.text = strings.description
    }
    
    func updateBackground(isHidden: Bool) {
        if isHidden {
            self.view.backgroundColor = UIColor(hex: "000000", alpha: 0)
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
            })
        }
    }
    
    func close() {
        self.presenter.onOkButtonTap()
    }

}
