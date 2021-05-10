//
//  BottomSheetConfigurator.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class BottomSheetConfigurator {
    func configure(view: BottomSheetViewController) {
        let router = BottomSheetRouter(view)
        let presenter = BottomSheetPresenterImp(view, router)
        view.presenter = presenter
    }

    static func open(navigationController: UINavigationController) {
        guard let view = R.storyboard.bottomSheetStoryboard.instantiateInitialViewController() else {
            return
        }
        BottomSheetConfigurator().configure(view: view)
        navigationController.pushViewController(view, animated: true)
    }
}
