import UIKit

class RootViewController: UITabBarController {

    var presenter: RootPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        RootConfiguratorImp().configure(view: self)
    }

}

extension RootViewController: RootView {
    func openMainMapScene() {
        presenter.openMainMapScene()
    }
    
    func openSecondScene() {
        presenter.openSecondScene()
    }
    
    func getUserInteractionsOnTabBarItems() -> Bool {
        return self.tabBar.items?.first?.isEnabled ?? true
    }

    func updateUserInteractionsOnTabBarItems(isEnabled: Bool) {
        if let items = self.tabBar.items {
            items.forEach { $0.isEnabled = isEnabled }
        }
    }
}

