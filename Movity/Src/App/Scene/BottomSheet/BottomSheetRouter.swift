import UIKit

class BottomSheetRouter: BaseRouter {

    weak var view: UIViewController!
    
    init(_ view: BottomSheetViewController) {
        self.view = view
    }
    
}
