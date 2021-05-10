import UIKit

class CustomAlertConfigurator {
    
    func configure(view: CustomAlertViewController, title: String, message: String, onDone: (() -> Void)?) {
        let router = CustomAlertRouter(view)
        let presenter = CustomAlertPresenterImp(view, router, title, message, onDone)
        view.presenter = presenter
    }
    
    static func open(title: String, message: String, onDone: (() -> Void)?) {
        guard let view = R.storyboard.customAlert.instantiateInitialViewController(),
              let rootVC = AppDelegate.shared.window?.rootViewController as? RootViewController else {
            return
        }
        CustomAlertConfigurator().configure(view: view, title: title, message: message, onDone: onDone)
        view.providesPresentationContextTransitionStyle = true
        view.definesPresentationContext = true
        view.modalPresentationStyle = .overCurrentContext
        rootVC.present(view, animated: true, completion: nil)
    }

}
