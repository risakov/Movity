import UIKit

extension UITextField {
    /**
        Делает из обычного текстфилда оный для ввода пароля:
     со звездочками вместо символов и кнопкой переключения режима.
     - parameter icon: Иконка кнопки переключения режима.
     */
    func setRightViewIcon(icon: UIImage) {
        let buttonView = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: ((self.frame.height) * 0.70),
                                                height: ((self.frame.height) * 0.70)))

        buttonView.setImage(icon.withRenderingMode(UIImage.RenderingMode.alwaysTemplate),
                            for: .normal)
        buttonView.tintColor = .lightGray
        
        self.rightViewMode = .always
        self.rightView = buttonView
        
        buttonView.addTarget(self, action: #selector(isSecure(button:)), for: .touchUpInside)
    }
    
    /**
        Используется в 'setRightViewIcon(icon: UIImage)' для переключениярежима текстфилда.
     - parameter button: Кнопка переключения режимов.
     */
    @objc func isSecure(button: UIButton) {
        self.isSecureTextEntry.toggle()
        
        if button.tintColor == .lightGray {
            button.tintColor = .green
        } else {
            button.tintColor = .lightGray
        }
    }
}

