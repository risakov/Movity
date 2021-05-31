//
//  MainMapRouter.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class MainMapRouter: BaseRouter {
    
    weak var view: UIViewController!
    
    init(_ view: MainMapViewController) {
        self.view = view
    }
    
    func showBottomSheet(
        view: BottomSheetViewController,
        currentVehicle: VehicleEntity,
        vehicles: [VehicleEntity],
        delegate: MainMapDelegate
    ) {
        BottomSheetConfiguratorImp.open(
            view: view,
            currentVehicle: currentVehicle,
            vehicles: vehicles,
            delegate: delegate
        )
    }
}
