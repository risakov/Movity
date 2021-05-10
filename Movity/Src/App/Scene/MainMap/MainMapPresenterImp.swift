//
//  MainMapPresenterImp.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import Foundation

class MainMapPresenterImp: MainMapPresenter {
    private weak var view: MainMapView?
    private let router: MainMapRouter
    
    init(_ view: MainMapView,
         _ router: MainMapRouter) {
        self.view = view
        self.router = router
    }
    
}
