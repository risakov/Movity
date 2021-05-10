//
//  RegistrationViewController.swift
//  Movity
//
//  Created by Роман on 11.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Cheeezcake Template Inc.
//

import UIKit
import MaterialTextField

class RegistrationViewController: UIViewController, RegistrationView {
    var presenter: RegistrationPresenter!
    @IBOutlet weak var emailTextField: MFTextField!
    @IBOutlet weak var nameTextField: MFTextField!
    @IBOutlet weak var lastnameTextField: MFTextField!
    @IBOutlet weak var patronymicTextField: MFTextField!
    @IBOutlet weak var cityTextField: MFTextField!
    @IBOutlet weak var passwordTextField: MFTextField!
    @IBOutlet weak var confirmPasswordTextField: MFTextField!
    @IBOutlet weak var signUpButton: MTYDesignableButton!
    
    @IBAction func onSignUpButtonTap(_ sender: Any) {
        self.confirmPasswordTextField.resignFirstResponder()
        self.checkTextFieldsAndProceed()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.prepareTextFields()
    }
    
    func prepareTextFields() {
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.patronymicTextField.delegate = self
        self.cityTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        self.emailTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.emailTextField.placeholderColor = .lightGray
        self.emailTextField.addDoneButtonOnKeyboard()
        
        self.nameTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.nameTextField.placeholderColor = .lightGray
        self.nameTextField.addDoneButtonOnKeyboard()
        
        self.lastnameTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.lastnameTextField.placeholderColor = .lightGray
        self.lastnameTextField.addDoneButtonOnKeyboard()
        
        self.patronymicTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.patronymicTextField.placeholderColor = .lightGray
        self.patronymicTextField.addDoneButtonOnKeyboard()
        
        self.cityTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.cityTextField.placeholderColor = .lightGray
        self.cityTextField.addDoneButtonOnKeyboard()
        
        self.passwordTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.passwordTextField.placeholderColor = .lightGray
        self.passwordTextField.addDoneButtonOnKeyboard()
        
        self.confirmPasswordTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.confirmPasswordTextField.placeholderColor = .lightGray
        self.confirmPasswordTextField.addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateSignUpButtonState()
    }
    
    func updateSignUpButtonState() {
        guard !self.emailTextField.text.isEmptyOrNil &&
                !self.nameTextField.text.isEmptyOrNil &&
                !self.lastnameTextField.text.isEmptyOrNil &&
                !self.patronymicTextField.text.isEmptyOrNil &&
                !self.cityTextField.text.isEmptyOrNil &&
                !self.passwordTextField.text.isEmptyOrNil &&
                !self.confirmPasswordTextField.text.isEmptyOrNil else {
            self.signUpButton.isEnabled = false
            return
        }
        self.signUpButton.isEnabled = true
    }
    
    // MARK: View Controller Functions

    func checkTextFieldsAndProceed() {
        var password = ""
        var email = ""
        var name = ""
        var lastname = ""
        var patronymic = ""
        var city = ""
        var hasErrors = false
        
        do {
            email = try self.validateEmail()
        } catch let error {
            self.emailTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            name = try self.validateName()
        } catch let error {
            self.nameTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            lastname = try self.validateLastname()
        } catch let error {
            self.lastnameTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            patronymic = try self.validatePatronymic()
        } catch let error {
            self.patronymicTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            city = try self.validateCity()
        } catch let error {
            self.cityTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            password = try self.validatePassword()
        } catch let error {
            self.passwordTextField.setError(error, animated: true)
            self.confirmPasswordTextField.setError(RuntimeError(" "), animated: true)
            hasErrors = true
        }
        
        guard !hasErrors else {
            let message = "Пожалуйста, проверьте введенные данные."
            self.showErrorDialog(message: message)
            return
        }
        
        let gender: Gender = .male
        
        let entity = CreateRegistrationRequestApiEntity(
            user:
                CreateRegistrationRequestEntity(
                    email: email,
                    password: password,
                    name: name,
                    lastname: lastname,
                    patronymic: patronymic,
                    gender: gender.rawValue,
                    cityname: city,
                    birthDate: "21.09.1999"
                )
        )
        
        self.presenter.sendRegistrationRequest(entity: entity)
    }
    
    func validateEmail() throws -> String {
        var email = self.emailTextField.text
        guard let validEmail = email,
              !validEmail.isEmpty else {
            throw ErrorForTextField.emailFieldIsEmpty
        }
        guard validEmail.isValidEmail else {
            throw ErrorForTextField.incorrectEmail
        }
        
        email = validEmail
        
        return email!
    }
    
    func validateName() throws -> String {
        var name = self.nameTextField.text
        guard let validName = name,
              !validName.isEmpty else {
            throw ErrorForTextField.nameFieldIsEmpty
        }
        
        name = validName
        
        return name!
    }
    
    func validateLastname() throws -> String {
        var lastname = self.lastnameTextField.text
        guard let validLastname = lastname,
              !validLastname.isEmpty else {
            throw ErrorForTextField.lastnameFieldIsEmpty
        }
        
        lastname = validLastname
        
        return lastname!
    }
    
    func validatePatronymic() throws -> String {
        var patronymic = self.patronymicTextField.text
        guard let validPatronymic = patronymic,
              !validPatronymic.isEmpty else {
            throw ErrorForTextField.patronymicFieldIsEmpty
        }
        
        patronymic = validPatronymic
        
        return patronymic!
    }
    
    func validateCity() throws -> String {
        var city = self.cityTextField.text
        guard let validCity = city,
              !validCity.isEmpty else {
            throw ErrorForTextField.cityFieldIsEmpty
        }
        
        city = validCity
        
        return city!
    }
    
    func validatePassword() throws -> String {
        guard let password = self.passwordTextField.text,
              password.removeWhitespace() != "" else {
            throw ErrorForTextField.passwordFieldIsEmpty
        }
        
        guard password.count >= 6 else {
            throw ErrorForTextField.passwordFieldIsTooShort
        }
        
        guard let passwordConfirmation = self.confirmPasswordTextField.text,
              passwordConfirmation == password else {
            throw PasswordCheckingError.passwordsAreNotEqual
        }
        
        return password
    }
    
    // MARK: Localization
    
    func setupStrings() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegistrationViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? MFTextField else {
            return
        }
        textField.setError(nil, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateSignUpButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        
        case self.emailTextField:
            self.nameTextField.becomeFirstResponder()
            
        case self.nameTextField:
            self.lastnameTextField.becomeFirstResponder()
            
        case self.lastnameTextField:
            self.patronymicTextField.becomeFirstResponder()
            
        case self.patronymicTextField:
            self.cityTextField.becomeFirstResponder()
            
        case self.cityTextField:
            self.passwordTextField.becomeFirstResponder()
            
        case self.passwordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
            
        case self.confirmPasswordTextField:
            textField.resignFirstResponder()
            self.onSignUpButtonTap((Any).self)
            
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
