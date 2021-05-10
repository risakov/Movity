//
//  BottomSheetRouter.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class BottomSheetRouter: BaseRouter {
    
    weak var view: UIViewController!
    
    init(_ view: BottomSheetViewController) {
        self.view = view
    }
    
    func openSomeScene() {
        if let navController = self.view.navigationController {
            //  SomeSceneConfigurator.open(navigationController: navController)
        }
    }
}
