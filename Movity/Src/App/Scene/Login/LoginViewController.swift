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
        self.checkTextFieldsAndLogIn()
    }
    @IBAction func createAccount(_ sender: Any) {
        self.presenter.openRegistrationScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginConfigurator().configure(view: self)
        self.prepareTextFields()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLoginButtonState()
    }
    
    func prepareTextFields() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.usernameTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.usernameTextField.placeholderColor = .lightGray
        self.usernameTextField.addDoneButtonOnKeyboard()
        
        self.passwordTextField.placeholderFont = UIFont.systemFont(ofSize: 13)
        self.passwordTextField.placeholderColor = .lightGray
        self.passwordTextField.addDoneButtonOnKeyboard()
    }
    
    func updateLoginButtonState() {
        guard !self.usernameTextField.text.isEmptyOrNil &&
                !self.passwordTextField.text.isEmptyOrNil else {
            self.loginButton.isEnabled = false
            return
        }
        self.loginButton.isEnabled = true
    }
    
    func checkTextFieldsAndLogIn() {
        var password = ""
        var username = ""
        var hasErrors = false

        do {
            username = try self.validateUsername()
        } catch let error {
            self.usernameTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        do {
            password = try self.validatePassword()
        } catch let error {
            self.passwordTextField.setError(error, animated: true)
            hasErrors = true
        }
        
        guard !hasErrors else {
            let message = "Пожалуйста, проверьте введенные данные."
            self.showErrorDialog(message: message)
            return
        }
        self.presenter.signIn(username: username, password: password)
    }
    
    func validateUsername() throws -> String {
        guard let username = self.usernameTextField.text,
              username.removeWhitespace() != "" else {
            throw ErrorForTextField.loginFieldIsEmpty
        }
        return username
    }
    
    func validatePassword() throws -> String {
        guard let password = self.passwordTextField.text,
              password.removeWhitespace() != "" else {
            throw ErrorForTextField.passwordFieldIsEmpty
        }
        return password
    }
    
    func startAnimationOnLoginButton() {
        self.loginButton.startLoadingAnimation()
    }
    
    func stopAnimationOnLoginButton() {
        self.loginButton.stopLoadingAnimation()
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
        self.updateLoginButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.usernameTextField:
            self.passwordTextField.becomeFirstResponder()
            
        case self.passwordTextField:
            textField.resignFirstResponder()
            self.onLoginButtonClick((Any).self)
            
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
