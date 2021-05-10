import Foundation

class CustomAlertPresenterImp {
    private weak var view: CustomAlertViewController?
    private var router: CustomAlertRouter?
    private var title: String
    private var description: String
    private var wasTabBarItemsEnabled = true
    private var onDone: (() -> Void)?
    
    init(_ view: CustomAlertViewController,
         _ router: CustomAlertRouter,
         _ title: String,
         _ description: String,
         _ onDoneAction: (() -> Void)?) {
        self.view = view
        self.router = router
        self.title = title
        self.description = description
        self.onDone = onDoneAction
    }
}

extension CustomAlertPresenterImp: CustomAlertPresenter {
    func updateUserInteractionsOnTabBarItems(isEnabled: Bool) {
        if let tabBarController = AppDelegate.shared.window?.rootViewController as? RootViewController {
            /// чтобы не включить выключенные ранее из другого модуля вкладки
            guard wasTabBarItemsEnabled else { return }
            tabBarController.updateUserInteractionsOnTabBarItems(isEnabled: isEnabled)
        }
    }
    
    func saveTabBarInteractionState() {
        if let tabBarController = AppDelegate.shared.window?.rootViewController as? RootViewController {
            wasTabBarItemsEnabled = tabBarController.getUserInteractionsOnTabBarItems()
        }
    }
    
    func getStrings() -> (title: String, description: String) {
        return (self.title, self.description)
    }

    func onOkButtonTap() {
        self.router?.dismiss()
        self.onDone?()
    }
    
}
