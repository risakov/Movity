//
//  ProfileConfigurator.swift
//  Movity
//
//  Created by Роман on 31.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class ProfileConfigurator {
    func configure(view: ProfileViewController) {
        let router = ProfileRouter(view)
        let presenter = ProfilePresenterImp(view, router, DI.resolve())
        view.presenter = presenter
    }

    static func open(navigationController: UINavigationController) {
        guard let view = R.storyboard.profileStoryboard.instantiateInitialViewController() else {
            return
        }
        ProfileConfigurator().configure(view: view)
        navigationController.pushViewController(view, animated: true)
    }
}
