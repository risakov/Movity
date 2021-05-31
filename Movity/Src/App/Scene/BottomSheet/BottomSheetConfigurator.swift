import UIKit
import RxNetworkApiClient

protocol BottomSheetConfigurator {
    
    static func configure(
        view: BottomSheetViewController,
        currentVehicle: VehicleEntity,
        vehicles: [VehicleEntity],
        delegate: MainMapDelegate
    )
}

class BottomSheetConfiguratorImp: BottomSheetConfigurator {
    
    static func configure(
        view: BottomSheetViewController,
        currentVehicle: VehicleEntity,
        vehicles: [VehicleEntity],
        delegate: MainMapDelegate
    ) {
        let router = BottomSheetRouter(view)
        let presenter = BottomSheetPresenterImp(
            view,
            router,
            currentVehicle,
            vehicles,
            delegate
        )
        view.presenter = presenter
    }

    static func open(
        view: BottomSheetViewController,
        currentVehicle: VehicleEntity,
        vehicles: [VehicleEntity],
        delegate: MainMapDelegate
    ) {
        // Мы здесь не делаем show экрана каждый раз, а просто устанавливаем новые данные для Bottom Sheet
        BottomSheetConfiguratorImp.configure(
            view: view,
            currentVehicle: currentVehicle,
            vehicles: vehicles,
            delegate: delegate)
    }
    
    static func getVC() -> BottomSheetViewController {
        let viewController = R.storyboard.bottomSheetStoryboard.instantiateInitialViewController()!
        return viewController
    }
    
}
