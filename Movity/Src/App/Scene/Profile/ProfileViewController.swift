//
//  ProfileViewController.swift
//  Movity
//
//  Created by Роман on 31.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var patronymicLabel: UILabel!
    
    @IBAction func onSugnOutButtonTouched(_ sender: Any) {
        showChoiceDialog(
            title: "Выход",
            message: "Вы действительно хотите выйти?",
            positiveMessage: "Да",
            negativeMessage: "Нет",
            onChoice: { [weak self] _ in
                self?.presenter.signOut()
            }
        )
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileConfigurator().configure(view: self)
        
        presenter.setCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareNavigationBar()
    }
    
    func prepareNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
}

extension ProfileViewController: ProfileView {
    
    func setUser(for user: UserEntity) {
        emailLabel.text = user.email
        lastnameLabel.text = user.lastname
        nameLabel.text = user.name
        patronymicLabel.text = user.patronymic
    }
    
}
