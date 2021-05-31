//
//  RegistrationConfigurator.swift
//  Movity
//
//  Created by Роман on 11.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class RegistrationConfigurator {
    func configure(view: RegistrationViewController) {
        let router = RegistrationRouter(view)
        let presenter = RegistrationPresenterImp(
            view,
            router,
            DI.resolve(),
            DI.resolve()
        )
        view.presenter = presenter
    }

    static func open(navigationController: UINavigationController) {
        guard let view = R.storyboard.registrationStoryboard.instantiateInitialViewController() else {
            return
        }
        RegistrationConfigurator().configure(view: view)
        navigationController.pushViewController(view, animated: true)
    }
}
