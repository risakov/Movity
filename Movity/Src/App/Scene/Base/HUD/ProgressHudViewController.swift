import UIKit

class ProgressHudViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var progressView: CircleProgressHud!
    @IBOutlet weak var cancelButton: DesignableUIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBAction func onCancelButtonTouched(_ sender: Any) {
        NotificationCenter.default.post(name: HudNotificationName.HudOnCancelButtonTouched.getNotificationName(),
                                        object: self,
                                        userInfo: nil)
    }
    
    private var halfProgress: Bool = false
    private var mode: ProgressHudMode = .indeterminate
    private let rotationAnimationKey = "Rotationanimationkey"
    
    var lastPercent: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancelButton.isHidden = !ProgressHudControl.config.isCancelButtonVisible
        self.halfProgress = ProgressHudControl.config.halfProgress
        lastPercent = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch ProgressHudControl.config.hudMode {
        case .indeterminate:
            self.startInfinityAnimation()
            
        case .determinate:
            print("|| determinate viewDidAppear")
        }
        lastPercent = 0.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch ProgressHudControl.config.hudMode {
        case .indeterminate:
            self.stopInfinityAnimation()
            
        case .determinate:
            print("|| determinate viewDidDisappear")
        }
        lastPercent = 0.0
    }
    public func setSuperViewColor(color: UIColor) {
        self.view.backgroundColor = color
    }
    
    public func setBackground(color: UIColor) {
        self.backgroundView.backgroundColor = color
    }

    public func setProgress(_ percent: Float) {
        if lastPercent > percent { return }
        lastPercent = percent
        
        if self.halfProgress && false {
            var percent2 = (percent - 0.5) * 2
            if percent2 < 0.01 { percent2 = 0.01 }
            self.progressView.animateProgress(CGFloat(percent2))
            progressLabel.text = String(
                Int(
                    (
                        percent * 100 - 50
                    )
                ) * 2
                ) + " %"
        } else {
            self.progressView.animateProgress(CGFloat(percent))
            progressLabel.text = String(
                Int(
                    (
                        percent * 100 //- 50
                    ) //* 2
                )
                ) + " %"
        }
        
    }

    public func stopAnimations() {
        switch ProgressHudControl.config.hudMode {
        case .indeterminate:
            self.stopInfinityAnimation()
            
        default:
            print("stop animations")
        }
    }
}

extension ProgressHudViewController {

    // MARK: - Infinity animation

    private func startInfinityAnimation() {
        self.progressView.animateProgress(0.75)
        self.startRotatingView(view: self.progressView, duration: 3)
    }

    private func stopInfinityAnimation() {
        self.stopRotatingView(view: self.progressView)
    }
}

extension ProgressHudViewController {
    // TODO 19/09/2019/unicorn может перенести в расширение вью?
    private func startRotatingView(view: UIView, duration: Double = 1) {
        if view.layer.animation(forKey: rotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(Double.pi * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            view.layer.add(rotationAnimation, forKey: rotationAnimationKey)
        }
    }

    private func stopRotatingView(view: UIView) {
        if view.layer.animation(forKey: rotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: rotationAnimationKey)
        }
    }
}

