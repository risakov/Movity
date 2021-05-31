//
//  RegistrationPresenterImp.swift
//  Movity
//
//  Created by Роман on 11.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import Foundation
import RxSwift
import Firebase
import ProgressHUD

class RegistrationPresenterImp: RegistrationPresenter {
    private weak var view: RegistrationView!
    private let router: RegistrationRouter
    private let gateway: RegistrationGateway
    private let settings: Settings
    private var disposeBag = DisposeBag()
    
    init(_ view: RegistrationView,
         _ router: RegistrationRouter,
         _ registrationGateway: RegistrationGateway,
         _ settings: Settings) {
        self.view = view
        self.router = router
        self.gateway = registrationGateway
        self.settings = settings
    }
    
    func sendRegistrationRequest(entity: CreateRegistrationRequestApiEntity) {
        ProgressHUD.show()
        Auth.auth().createUser(
            withEmail: entity.user.email,
            password: entity.user.password,
            completion: { [weak self] (result, error) in
                guard let self = self else { return }
                
                if error == nil, let result = result {
                    let user = entity.user
                    
                    let refToDatabase = Database.database().reference().child("users")
                    refToDatabase.child(result.user.uid).updateChildValues(
                        [
                            "email": user.email,
                            "password": user.password,
                            "name": user.name,
                            "lastname": user.lastname,
                            "patronymic": user.patronymic
                        ]
                    )
                    
                    self.settings.user = UserEntity(
                        user.email,
                        user.name,
                        user.lastname,
                        user.patronymic
                    )
                    
                    self.router.openMainScene()
                    ProgressHUD.dismiss()
                } else {
                    self.view.showErrorDialog(message: error!.localizedDescription)
                    ProgressHUD.dismiss()
                }

            })
    }
    
}
