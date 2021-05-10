import UIKit
import Photos

typealias ActionChoiceDialog = (title: String, action: () -> Void)

protocol BaseView: class {
}

extension BaseView {

    func showActivityIndicator(_ withCancelButton: Bool = false, halfProgress: Bool = false) {
        ProgressHudControl.show(withCancelButton, halfProgress)
    }

    func showActivityIndicator(_ withCancelButton: Bool = false, halfProgress: Bool = false, backgroundColor: UIColor) {
        ProgressHudControl.show(withCancelButton, backgroundColor: backgroundColor, halfProgress)
    }

    func showActivityIndicator(_ withCancelButton: Bool = false, halfProgress: Bool = false, superViewColor: UIColor, backgroundColor: UIColor) {
        ProgressHudControl.show(withCancelButton, superViewColor: superViewColor, backgroundColor: backgroundColor, halfProgress)
    }

    func hideActivityIndicator() {
        ProgressHudControl.dismiss()
    }

    func showDialog(title: String? = nil, message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо".localization(), style: .default, handler: action)
        alert.addAction(okAction)
        (self as? UIViewController)?.present(alert, animated: true)
    }

    func showWarningDialog(
        message: String,
        withoutCancel: Bool = true,
        action: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: "Внимание".localization(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо".localization(), style: .default, handler: action)
        alert.addAction(okAction)
        okAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")

        if !withoutCancel {
            let cancelAction = UIAlertAction(title: "Отмена".localization(), style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            cancelAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        }

        (self as? UIViewController)?.present(alert, animated: true)
    }

    func showChoiceDialog(title: String? = nil,
                          message: String,
                          positiveMessage: String,
                          negativeMessage: String,
                          onChoice: @escaping (_ isPositive: Bool) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: positiveMessage,
                                           style: .default,
                                           handler: { _ in
                                               onChoice(true)
                                           })
        positiveAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                forKey: "titleTextColor")
        let negativeAction = UIAlertAction(title: negativeMessage,
                                           style: .cancel,
                                           handler: { _ in
                                               onChoice(false)
                                           })
        negativeAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                forKey: "titleTextColor")

        alert.addAction(negativeAction)
        alert.addAction(positiveAction)
        (self as? UIViewController)?.present(alert, animated: true)
    }

    func showMultiplyChoiceDialog(title: String? = nil,
                                  message: String?,
                                  actionsChoice: [ActionChoiceDialog],
                                  preferredStyle: UIAlertController.Style = .alert,
                                  sender: UIView? = nil,
                                  withoutCancel: Bool? = false) {

        let sheet = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)

        actionsChoice.forEach { (title, action) in

            let button = UIAlertAction(title: title,
                                       style: .default,
                                       handler: { _ in action() })
            button.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
            sheet.addAction(button)
        }

        if withoutCancel != true {
            let cancelButton = UIAlertAction(title: "Отмена".localization(),
                                             style: .cancel,
                                             handler: nil)
            cancelButton.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
            sheet.addAction(cancelButton)

        }
        if preferredStyle == .actionSheet {

//         адаптация для планшетов
            if let sender = sender, let alert = sheet.popoverPresentationController {
                alert.sourceView = sender
                alert.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
//            раскомментировать при необходимости удаления стрелочки на sender
//            alert.permittedArrowDirections = []
            }
        }

        (self as? UIViewController)?.present(sheet, animated: true)
    }

    func showErrorDialog(message: String,
                         action: ((UIAlertAction) -> Void)? = nil,
                         onShow: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alert = UIAlertController(title: "Ошибка".localization(),
                                          message: message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Продолжить".localization(),
                                         style: .default,
                                         handler: action)
            alert.addAction(okAction)
            (self as? UIViewController)?.present(alert, animated: true, completion: onShow)
        }
    }

    func showInputDialog(title: String? = nil,
                         text: String? = nil,
                         subtitle: String? = nil,
                         actionTitle: String? = NSLocalizedString("ОК".localization(), comment: ""),
                         cancelTitle: String? = NSLocalizedString("Отмена".localization(), comment: ""),
                         inputPlaceholder: String? = nil,
                         inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.text = text ?? ""
        }

        let mainAction = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            guard let textField = alert.textFields?.first else {
                fatalError("Not found text fields in Input dialog!")
            }
            actionHandler?(textField.text)
        })
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)

        mainAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        cancelAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")

        alert.addAction(cancelAction)
        alert.addAction(mainAction)

        (self as? UIViewController)?.present(alert, animated: true)
    }
    
    func showInputDialogOnlyMainAction(title: String? = nil,
                                       text: String? = nil,
                                       subtitle: String? = nil,
                                       actionTitle: String? = "ОК".localization(),
                                       inputPlaceholder: String? = nil,
                                       inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                       actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.text = text ?? ""
        }
        
        let mainAction = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            guard let textField = alert.textFields?.first else {
                fatalError("Not found text fields in Input dialog!")
            }
            actionHandler?(textField.text)
        })
        
        mainAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        alert.addAction(mainAction)
        
        (self as? UIViewController)?.present(alert, animated: true)
    }
    
    func showMultiplyInputDialog(title: String? = nil,
                                 subtitle: String? = nil,
                                 actionsChoice: [ActionChoiceDialog],
                                 mainActionTitle: String? = "ОК",
                                 mainActionHandler: ((_ text: String?) -> Void)? = nil,
                                 inputPlaceholder: String? = nil,
                                 inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                 cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }

        let mainAction = UIAlertAction(title: mainActionTitle, style: .default, handler: { _ in
            guard let textField = alert.textFields?.first else {
                fatalError("Not found text fields in Input dialog!")
            }
            mainActionHandler?(textField.text)
        })

        let cancelAction = UIAlertAction(title: "Отмена".localization(), style: .cancel, handler: cancelHandler)

        mainAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
        cancelAction.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")

        alert.addAction(mainAction)
        actionsChoice.forEach { (title, action) in

            let button = UIAlertAction(title: title, style: .default, handler: { _ in action() })
            button.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "titleTextColor")
            alert.addAction(button)
        }
        alert.addAction(cancelAction)

        (self as? UIViewController)?.present(alert, animated: true)
    }
    
    func showTimingAlert(message: String?) {
        let alertController = UIAlertController(title: message,
                                                message: nil,
                                                preferredStyle: .alert)
        (self as? UIViewController)?.present(alertController, animated: true, completion: {
            _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
        })
    }

    func iosShare(text: String, sourceVC: UIViewController? = nil) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//      адаптация для планшетов
        if let alert = activityViewController.popoverPresentationController {
            alert.sourceView = sourceVC?.view
            alert.sourceRect = CGRect(x: UIScreen.main.bounds.minX,
                                      y: UIScreen.main.bounds.maxY,
                                      width: UIScreen.main.bounds.width,
                                      height: 0)
            alert.permittedArrowDirections = []
        }
        (self as? UIViewController)?.present(activityViewController, animated: true)
    }
}

