import Foundation
import UIKit

protocol BaseRouter {

    var view: UIViewController! { get }
}

extension BaseRouter {

    func dismiss(completion: (() -> Void)? = nil) {
        guard let view = self.view else { return }

        view.dismiss(animated: true, completion: completion)
    }

    func pop(completion: (() -> Void)? = nil) {
        guard let view = self.view else { return }

        if let completion = completion {
            view.navigationController?.popViewController(animated: true, completion: completion)
        } else {
            view.navigationController?.popViewController(animated: true)
        }
    }

    func popViewControllerss(popViews: Int, animated: Bool = true) {
        guard let vcCount = view.navigationController?.viewControllers.count else { return }
        if vcCount > popViews {
            guard let vc = view.navigationController?.viewControllers[vcCount - popViews - 1] else { return }
            view.navigationController?.popToViewController(vc, animated: animated)
        }
    }

    func popToRoot(animated: Bool = true) {
        guard let view = self.view else { return }

        view.navigationController?.popToRootViewController(animated: animated)
    }
}

