import Foundation

protocol CustomAlertPresenter {
    func updateUserInteractionsOnTabBarItems(isEnabled: Bool)
    func getStrings() -> (title: String, description: String)
    func saveTabBarInteractionState()
    func onOkButtonTap()
}
