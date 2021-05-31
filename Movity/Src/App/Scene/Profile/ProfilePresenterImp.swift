//
//  ProfilePresenterImp.swift
//  Movity
//
//  Created by Роман on 31.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import Foundation
import Firebase

class ProfilePresenterImp: ProfilePresenter {
    private weak var view: ProfileView?
    private let router: ProfileRouter
    private let settings: Settings
    
    init(_ view: ProfileView,
         _ router: ProfileRouter,
         _ settings: Settings) {
        self.view = view
        self.router = router
        self.settings = settings
    }
    
    func setCurrentUser() {
        guard let user = settings.user else { return }
        
        view?.setUser(for: user)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            settings.clearUserData()
            router.openLoginScene()
        } catch {
            view?.showErrorDialog(message: error.localizedDescription)
        }
        
    }
    
}
