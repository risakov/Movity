import Foundation

public struct ProgressHudConfig {

    /**
     - Progress HUD mode
     - Default: .indeterminate
     */
    public var hudMode: ProgressHudMode = .indeterminate

    /**
     - Progress HUD Visible cancel button
     - Default: false
     */
    public var isCancelButtonVisible: Bool = false

    /**
     - Progress HUD FadeIn animation duration on start
     - Default: 0.2 Sec
     */
    public var fadeInAnimationDuration: TimeInterval = 0.2

    /**
     - Progress HUD FadeOut animation duration on start
     - Default: 0.25 Sec
     */
    public var fadeOutAnimationDuration: TimeInterval = 0.25

    /**
    - Rotating circle border width
     - Default: 1.0
    */
//    public var circleBorderWidth: CGFloat = 1.0
    
    public var halfProgress: Bool = false

}

public enum ProgressHudMode {
    case determinate
    case indeterminate
}

