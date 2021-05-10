import Foundation

protocol RootView: BaseView {
    func openMainMapScene()
    func openSecondScene()
    func getUserInteractionsOnTabBarItems() -> Bool
    func updateUserInteractionsOnTabBarItems(isEnabled: Bool)
}
