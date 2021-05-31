//
//  MainMapConfigurator.swift
//  Movity
//
//  Created by Роман on 08.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class MainMapConfigurator {
    func configure(view: MainMapViewController) {
        let router = MainMapRouter(view)
        let presenter = MainMapPresenterImp(view, router)
        view.dataSource = BottomSheetDataSource()
        view.presenter = presenter
    }

    static func open(navigationController: UINavigationController) {
        let viewController = MainMapConfigurator.getVC()
        MainMapConfigurator().configure(view: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    static func getVC() -> MainMapViewController {
        guard let viewController = R.storyboard.mainMapStoryboard.instantiateInitialViewController() else {
            return MainMapViewController()
        }
        return viewController
    }
}
