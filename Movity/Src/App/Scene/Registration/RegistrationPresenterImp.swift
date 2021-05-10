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

class RegistrationPresenterImp: RegistrationPresenter {
    private weak var view: RegistrationView!
    private let router: RegistrationRouter
    private let gateway: RegistrationGateway
    private var disposeBag = DisposeBag()
    
    init(_ view: RegistrationView,
         _ router: RegistrationRouter,
         _ registrationGateway: RegistrationGateway) {
        self.view = view
        self.router = router
        self.gateway = registrationGateway
    }
    
    func sendRegistrationRequest(entity: CreateRegistrationRequestApiEntity) {
        let gender: Gender = .male
        self.gateway.sendReqistrationRequest(entity)
        .observeOn(MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] entity in
            guard let self = self else { return }
            let newEntity = entity
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.view.showErrorDialog(message: error.localizedDescription)
        })
        .disposed(by: self.disposeBag)
    }
    
}
