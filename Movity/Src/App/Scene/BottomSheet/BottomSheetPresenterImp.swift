//
//  BottomSheetPresenterImp.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import Foundation

class BottomSheetPresenterImp: BottomSheetPresenter {
    private weak var view: BottomSheetView?
    private let router: BottomSheetRouter
    
    init(_ view: BottomSheetView,
         _ router: BottomSheetRouter) {
        self.view = view
        self.router = router
    }
    
}
