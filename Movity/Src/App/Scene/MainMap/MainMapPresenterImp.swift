//
//  MainMapPresenterImp.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//
// swiftlint:disable number_separator
import Foundation

class MainMapPresenterImp: MainMapPresenter {
    private weak var view: MainMapView?
    private let router: MainMapRouter
    private var vehicles: [VehicleEntity] = [
        VehicleEntity(
            type: .car,
            model: "Toyota Corolla",
            number: "У255ОВ",
            fuel: 50.0,
            coordinate: Coordinate(
                longitude: 39.718432094002154,
                latitude: 47.22224803366945
            ),
            tariff: Tariff(
                costForStart: 45,
                costPerMinute: 12,
                costForWaiting: 10,
                freeWaitingTime: 5
            ),
            address: "Подземный переход, пр. Ворошиловский, KFC",
            timeToVehicle: 5,
            vehicleImageName: "toyotaCorolla"
        ),
        VehicleEntity(
            type: .car,
            model: "Volkswagen Polo",
            number: "Е142ЛП",
            fuel: 23.0,
            coordinate: Coordinate(
                longitude: 39.71255313660801,
                latitude: 47.22008305767586

            ),
            tariff: Tariff(
                costForStart: 45,
                costPerMinute: 12,
                costForWaiting: 10,
                freeWaitingTime: 7
            ),
            address: "ул. Социалистическая 74, БЦ 'Купеческий двор'",
            timeToVehicle: 5,
            vehicleImageName: "volkswagenPolo"
        ),
        VehicleEntity(
            type: .bicycle,
            model: "LuckyBike",
            number: "143",
            fuel: 90,
            coordinate: Coordinate(
                longitude: 39.7202899979713,
                latitude: 47.22223085687561
            ),
            tariff: Tariff(
                costForStart: 10,
                costPerMinute: 4.5,
                costForWaiting: 10,
                freeWaitingTime: 5
            ),
            address: "Площадь советов, пр. Ворошиловский",
            timeToVehicle: 3,
            vehicleImageName: "bike"
        ),
        VehicleEntity(
            type: .scooter,
            model: "Whoosh",
            number: "254",
            fuel: 90,
            coordinate: Coordinate(
                longitude: 39.71934017741042,
                latitude: 47.22244535725528
            ),
            tariff: Tariff(
                costForStart: 20,
                costPerMinute: 5,
                costForWaiting: 10,
                freeWaitingTime: 5
            ),
            address: "Площадь советов, пр. Ворошиловский",
            timeToVehicle: 5,
            vehicleImageName: "electricScooter"
        )
    ]

    init(_ view: MainMapView,
         _ router: MainMapRouter) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    private func fetchVehicles() {
        
    }
    
    func getVehicles() -> [VehicleEntity] {
        return vehicles
    }
    
    func showBottomSheet(view: BottomSheetViewController,
                         currentVehicle: VehicleEntity,
                         delegate: MainMapDelegate) {
        router.showBottomSheet(
            view: view,
            currentVehicle: currentVehicle,
            vehicles: vehicles,
            delegate: delegate
        )
    }
}
