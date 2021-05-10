import UIKit

class CustomAlertRouter: BaseRouter {
    internal weak var view: UIViewController!
    
    init(_ view: CustomAlertViewController) {
        self.view = view
    }
}
