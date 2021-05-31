import Foundation
import RxSwift

protocol BottomSheetPresenter: class {
    
    func setCurrentVehicle()
    func openNextScene()
    
}

class BottomSheetPresenterImp: BottomSheetPresenter {
    
    private weak var view: BottomSheetView!
    private let router: BottomSheetRouter!
    private var requestsBag = DisposeBag()
    private var currentVehicle: VehicleEntity
    private let vehicles: [VehicleEntity]
    private let delegate: MainMapDelegate
    
    init(_ view: BottomSheetView,
         _ router: BottomSheetRouter,
         _ currentVehicle: VehicleEntity,
         _ vehicles: [VehicleEntity],
         _ delegate: MainMapDelegate
    ) {
        self.view = view
        self.router = router
        self.currentVehicle = currentVehicle
        self.vehicles = vehicles
        self.delegate = delegate
        
        setCurrentVehicle()
    }
    
    func setCurrentVehicle() {
        view.prepareBottomSheet(vehicle: currentVehicle)
    }
    
    func openNextScene() {
//        profileGateway.setNewOutputPlace(for: currentPlace.id)
//            .observeOn(MainScheduler.instance)
//            .do(onSubscribed: { [weak self] in self?.view.showActivityIndicator() },
//                onDispose: { [weak self] in self?.view.hideActivityIndicator() })
//            .subscribe(onCompleted: { [weak self]  in
//                guard let self = self else { return }
//                // оборачиваю в массив из-за костыльного бэка...
//                self.settings.user?.output_place = [self.currentPlace]
//                self.view.showDialog(message: "Пункт выдачи успешно изменен!",
//                                     action: { [weak self] _ in
//                                        self?.router.popViewControllers(popViews: 2)
//                                     })
//            }, onError: { [weak self] error in
//                self?.view.showErrorDialog(message: error.localizedDescription)
//            }).disposed(by: requestsBag)
    }
    
}
