import Foundation

class RootPresenterImp: RootPresenter {
    private weak var view: RootView?
    private let router: RootRouter

    init(_ view: RootView,
         _ router: RootRouter) {
        self.view = view
        self.router = router
    }
    
    func openMainMapScene() {
        router.openMainMapScene()
    }
    
    func openSecondScene() {
        router.openSecondScene()
    }
    
}
