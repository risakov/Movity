//
//  RegistrationRouter.swift
//  Movity
//
//  Created by Роман on 11.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class RegistrationRouter: BaseRouter {
    
    weak var view: UIViewController!
    
    init(_ view: RegistrationViewController) {
        self.view = view
    }
    
    func openSomeScene() {
        if let navController = self.view.navigationController {
            //  SomeSceneConfigurator.open(navigationController: navController)
        }
    }
}
