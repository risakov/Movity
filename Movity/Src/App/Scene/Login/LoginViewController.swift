import UIKit
import MaterialTextField

protocol LoginView: BaseView {
    func startAnimationOnLoginButton()
    func stopAnimationOnLoginButton()
}

class LoginViewController: UIViewController, LoginView {
    var presenter: LoginPresenter!

    @IBOutlet weak var loginButton: MTYDesignableButton!
    @IBOutlet weak var createAccountButton: MTYDesignableButton!
    @IBOutlet weak var passwordTextField: MFTextField!
    @IBOutlet weak var usernameTextField: MFTextField!
    @IBAction func onLoginButtonClick(_ sender: Any) {
        checkTextFieldsAndLogIn()
    }
    @IBAction func createAccount(_ sender: Any) {
        presenter.openRegistrationScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginConfigurator().configure(view: self)
        
        prepareTextFields()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareNavigationBar()
        updateLoginButtonState()
    }
    
    func prepareNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func prepareTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.tintColor = R.color.violetLight()!
        usernameTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        usernameTextField.placeholderColor = .lightGray
        usernameTextField.addDoneButtonOnKeyboard()
        
        passwordTextField.tintColor = R.color.violetLight()!
        passwordTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        passwordTextField.placeholderColor = .lightGray
        passwordTextField.addDoneButtonOnKeyboard()
    }
    
    func updateLoginButtonState() {
        guard !usernameTextField.text.isEmptyOrNil &&
                !passwordTextField.text.isEmptyOrNil else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
    
    func checkTextFieldsAndLogIn() {
        var password = ""
        var username = ""
        var hasErrors = false

        do {
            username = try validateUsername()
        } catch let error {
            usernameTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            password = try validatePassword()
        } catch let error {
            passwordTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        guard !hasErrors else {
            let message = "Пожалуйста, проверьте введенные данные."
            showErrorDialog(message: message)
            return
        }
        presenter.signIn(username: username, password: password)
    }
    
    func validateUsername() throws -> String {
        var username = self.usernameTextField.text
        guard let validUsername = username,
              !validUsername.isEmpty else {
            throw ErrorForTextField.emailFieldIsEmpty
        }
        guard validUsername.isValidEmail else {
            throw ErrorForTextField.incorrectEmail
        }
        
        username = validUsername
        
        return username!
    }
    
    func validatePassword() throws -> String {
        guard let password = self.passwordTextField.text,
              password.removeWhitespace() != "" else {
            throw ErrorForTextField.passwordFieldIsEmpty
        }
        
        guard password.count >= 6 else {
            throw ErrorForTextField.passwordFieldIsTooShort
        }
        
        return password
    }
    
    func startAnimationOnLoginButton() {
        loginButton.startLoadingAnimation()
    }
    
    func stopAnimationOnLoginButton() {
        loginButton.stopLoadingAnimation()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? MFTextField else {
            return
        }
        textField.setError(nil, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            textField.resignFirstResponder()
            onLoginButtonClick((Any).self)
            
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
