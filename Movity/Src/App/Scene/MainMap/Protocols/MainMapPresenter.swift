//
//  MainMapPresenter.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import Foundation

protocol MainMapPresenter {
    // Геттер для массива точек
    func getVehicles() -> [VehicleEntity]
    // Функция для конфигурации шторки
    func showBottomSheet(view: BottomSheetViewController,
                         currentVehicle: VehicleEntity,
                         delegate: MainMapDelegate)
    
    func viewDidLoad()
}
