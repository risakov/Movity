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
    
    func openMainScene() {
        let rootView = R.storyboard.root.rootVC()!
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = rootView
        rootView.openMainMapScene()
    }
}
