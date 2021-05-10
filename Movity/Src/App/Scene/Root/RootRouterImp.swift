import UIKit

class RootRouterImp: RootRouter {

    private weak var view: RootViewController!

    init(_ view: RootViewController) {
        self.view = view
    }
    
    func openMainMapScene() {
        let tb = view!
        let firstTabIndex = TabBarIndices.firstTab.rawValue
        
        tb.selectedIndex = firstTabIndex
        let navC = tb.viewControllers?[firstTabIndex] as! UINavigationController
        navC.popToRootViewController(animated: false)
        let mainMapVC = MainMapConfigurator.getVC()
        navC.setViewControllers([mainMapVC], animated: false)
        
    }
    
    func openSecondScene() {
        let tb = view!
        let secondTabIndex = TabBarIndices.secondTab.rawValue
        
        tb.selectedIndex = secondTabIndex
        let navC = tb.viewControllers?[secondTabIndex] as! UINavigationController
        navC.popToRootViewController(animated: false)

//        let firstVC = FirstConfigurator.getVC()
//        navC.setViewControllers([firstVC], animated: false)
    }
    
}
