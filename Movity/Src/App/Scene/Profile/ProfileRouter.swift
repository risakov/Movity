//
//  ProfileRouter.swift
//  Movity
//
//  Created by Роман on 31.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class ProfileRouter: BaseRouter {
    
    weak var view: UIViewController!
    
    init(_ view: ProfileViewController) {
        self.view = view
    }
    
    func openLoginScene() {
        let window = AppDelegate.shared.window!
        UIView.transition(with: window, duration: 0, options: .transitionCrossDissolve, animations: {
            window.rootViewController = R.storyboard.loginStoryboard.instantiateInitialViewController()!
        })
    }
}
