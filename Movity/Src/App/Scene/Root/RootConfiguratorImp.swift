import Foundation

class RootConfiguratorImp: RootConfigurator {

    func configure(view: RootViewController) {

        let router = RootRouterImp(view)
        let presenter = RootPresenterImp(view, router)
        view.presenter = presenter
    }
}
