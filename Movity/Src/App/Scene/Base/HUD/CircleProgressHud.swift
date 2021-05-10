import Foundation
import UIKit

class CircleProgressHud: UIView {

    @IBInspectable var baseProgress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var widthLine: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var backgroundLineColor: UIColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var progressLineColor: UIColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }

    public var visibleBackgroundCircle: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    private var animationTimer: Timer?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if self.visibleBackgroundCircle {
            self.drawBackgroundCircle()
        }
        self.drawProgress()
    }

    private func drawBackgroundCircle() {
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let radius = min(bounds.size.width, bounds.size.height) * 0.5 - widthLine
        let startAngle = -0.5 * CGFloat.pi

        let endAngle = startAngle + 2 * CGFloat.pi
        let circlePath = UIBezierPath(arcCenter: viewCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        backgroundLineColor.setStroke()
        circlePath.lineWidth = widthLine
        circlePath.stroke()
    }

    private func drawProgress() {
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let radius = min(bounds.size.width, bounds.size.height) * 0.5 - widthLine

        let startAngle: CGFloat = self.baseProgress * 2 * CGFloat.pi
        let endAngle = startAngle + self.progress * 2 * CGFloat.pi

        let progressPath = UIBezierPath(arcCenter: viewCenter,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)

        progressLineColor.setStroke()
        progressPath.lineWidth = widthLine
        progressPath.lineCapStyle = .round
        progressPath.stroke()
    }

    public func animateProgress(_ newValue: CGFloat) {

        self.animationTimer?.invalidate()

        let diff = newValue - self.progress
        let initialProgress = self.progress

        let initialBaseAngle = self.baseProgress

        let speed: Double = 5
        let duration: TimeInterval = abs(Double(diff) / speed)
        let time = CACurrentMediaTime() - duration

        let timer = Timer(timeInterval: 1 / 60, repeats: true) { [weak self]  timer in
            guard let self = self else { return }

            let delta = CACurrentMediaTime() - time

            self.progress = diff * CGFloat(min(1, delta)) + initialProgress

            if diff < 0 {
                self.baseProgress = abs(diff) * CGFloat(min(1, delta)) + initialBaseAngle
            }

            if delta >= 1 {
                timer.invalidate()
            }
        }

        RunLoop.current.add(timer, forMode: .common)
        self.animationTimer = timer
    }
}

