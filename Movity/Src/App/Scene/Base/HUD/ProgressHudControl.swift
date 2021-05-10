import Foundation
import UIKit

public enum HudNotificationName: String {
    case HudOnCancelButtonTouched

    public func getNotificationName() -> Notification.Name {
        return Notification.Name(self.rawValue)
    }
}

public final class ProgressHudControl {

    /// - `HudProgress` shared instance
    public static var shared = ProgressHudControl()

    /// - `HudProgressConfig` shared instance for the Progress HUD
    public static var config = ProgressHudConfig()

    /// HUD Window added on top of current window.
    /// - Default: nil
    fileprivate var hudWindow: UIWindow?

    /// Flag to indicate if dismiss animation is being played to dismiss the ProgressHUD
    fileprivate var isDismissing = false

    /// Flag to indicate if Progress is waiting for the timeInterval given before showing up
    fileprivate var isWaitingToShow = false

    /// Creating `UIWindow` to present Progress HUD
    /// 'CustomProgressHudViewController' //initialization and setting as rootViewController for the window.
    /// Returns 'UIWindow'.
    fileprivate func getHUDWindow() -> UIWindow {
        let hudWindow = UIWindow()
        hudWindow.frame = UIScreen.main.bounds
        hudWindow.isHidden = false
        hudWindow.windowLevel = UIWindow.Level.normal
        hudWindow.backgroundColor = UIColor.clear
        let controller = R.storyboard.customProgressHud.customProgressHud()!
        hudWindow.rootViewController = controller
        return hudWindow
    }

    /// Showing Progress HUD
    /// - parameter animated: Flag to indicate if progress hud should appear with animation.
    /// - parameter withCancelButton set Cancel Button in bottom ProgressView
    /// - animated: Default: true
    public static func show(_ withCancelButton: Bool, animated: Bool = true, _ halfProgress: Bool) {
//        DispatchQueue.main.async {
        let action = {
            config.hudMode = .indeterminate
            ProgressHudControl.config.isCancelButtonVisible = withCancelButton
            ProgressHudControl.config.halfProgress = halfProgress

            if shared.isDismissing {
                shared.isDismissing = false
                let animated = true
                makeKeyWindowVisible(animated)
                return
            }

            guard shared.hudWindow == nil else { return }
            makeKeyWindowVisible(animated)
        }
        if Thread.current.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
//        }
    }
    
    public static func show(_ withCancelButton: Bool, backgroundColor: UIColor, animated: Bool = true, _ halfProgress: Bool) {
        let action = {
            config.hudMode = .indeterminate
            ProgressHudControl.config.isCancelButtonVisible = withCancelButton
            ProgressHudControl.config.halfProgress = halfProgress
            
            if shared.isDismissing {
                shared.isDismissing = false
                let animated = true
                makeKeyWindowVisible(animated)
                return
            }
            
            guard shared.hudWindow == nil else { return }
            makeKeyWindowVisible(animated)
            if let rootViewController = shared.hudWindow?.rootViewController,
                let progressVC = rootViewController as? ProgressHudViewController {
                progressVC.setBackground(color: backgroundColor)
            }
        }
        if Thread.current.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
    
    public static func show(_ withCancelButton: Bool, superViewColor: UIColor, backgroundColor: UIColor, animated: Bool = true, _ halfProgress: Bool) {
        let action = {
            config.hudMode = .indeterminate
            ProgressHudControl.config.isCancelButtonVisible = withCancelButton
            ProgressHudControl.config.halfProgress = halfProgress
            
            if shared.isDismissing {
                shared.isDismissing = false
                let animated = true
                makeKeyWindowVisible(animated)
                return
            }
            
            guard shared.hudWindow == nil else { return }
            makeKeyWindowVisible(animated)
            if let rootViewController = shared.hudWindow?.rootViewController,
                let progressVC = rootViewController as? ProgressHudViewController {
                progressVC.setSuperViewColor(color: superViewColor)
                progressVC.setBackground(color: backgroundColor)
            }
        }
        if Thread.current.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }

    /// Showing Progress HUD with progress
    /// - parameter animated: Flag to indicate if progress hud should appear with animation.
    /// - parameter progress: Set progress, progress in (0...1)
    /// - animated: Default: true
    public static func show(progress: Float, withCancelButton: Bool, halfProgress: Bool) {

        config.hudMode = .determinate
        if let rootViewController = shared.hudWindow?.rootViewController,
           let progressVC = rootViewController as? ProgressHudViewController {
            progressVC.setProgress(progress)
        } else {
            ProgressHudControl.show(withCancelButton, halfProgress)
        }
    }

    /// Hiding the progress hud
    /// - parameter animated: Flag to handle the fadeOut animation on dismiss.
    /// - animated: Default: true
    public static func dismiss(_ animated: Bool = true) {
        let progress = ProgressHudControl.shared

        func hideProgressHud() {
            progress.isDismissing = false

            progress.stopAnimatoins()
            progress.hudWindow?.resignKey()
            progress.hudWindow = nil
        }

        ProgressHudControl.shared.isWaitingToShow = false

        if animated {
            progress.playFadeOutAnimation({ _ in
                guard ProgressHudControl.shared.isDismissing else { return }
                hideProgressHud()
            })
        } else {
            hideProgressHud()
        }
    }

    /// Presenting Progress window
    /// - parameter animated: Flag to indicate if progress hud should appear with animation.
    /// - animated: Default: true
    fileprivate static func makeKeyWindowVisible(_ animated: Bool) {
        shared.hudWindow = shared.getHUDWindow()
        shared.hudWindow?.makeKeyAndVisible()

        guard animated else { return }
        shared.playFadeInAnimation()
    }

    /// Plays fade in animation
    private func playFadeInAnimation() {
        guard let rootViewController = self.hudWindow?.rootViewController else { return }

        rootViewController.view.layer.opacity = 0.0

        UIView.animate(withDuration: ProgressHudControl.config.fadeInAnimationDuration, animations: {
            rootViewController.view.layer.opacity = 1.0
        })
    }

    /// Plays fade out animation
    private func playFadeOutAnimation(_ completion: ((Bool) -> Void)?) {
        guard let rootViewController = self.hudWindow?.rootViewController else { return }

        ProgressHudControl.shared.isDismissing = true
        rootViewController.view.layer.opacity = 1.0

        UIView.animate(withDuration: ProgressHudControl.config.fadeOutAnimationDuration, animations: {
            guard ProgressHudControl.shared.isDismissing else { return }
            rootViewController.view.layer.opacity = 0.0
        }, completion: completion)
    }

    fileprivate func stopAnimatoins() {
        guard let rootViewController = self.hudWindow?.rootViewController else { return }
        (rootViewController as? ProgressHudViewController)?.stopAnimations()
    }
}
