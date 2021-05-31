//
//  UIViewUtil.swift
//  Movity
//
//  Created by Роман on 18.04.2021.
//

import  UIKit

// MARK: Rotating UIView

extension UIView {
    
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            
            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}

// MARK: - Designable & Inspectable

@IBDesignable
class DesignableView: UIView { }

@IBDesignable
class DesignableButton: UIButton { }

@IBDesignable
class DesignableLabel: UILabel { }

extension UIView {
    
    @IBInspectable var isCircle: Bool {
        get {
            return self.bounds.width == self.layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue ? self.bounds.width / 2 : cornerRadius
            layer.masksToBounds = true
        }
    }
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.borderColor = color.cgColor
      } else {
        layer.borderColor = nil
      }
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable
  var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }
    
    func show(animated: Bool = true, duration: Double = 0.2, completion: ((Bool) -> Void)? = nil) {
        if self.isHidden {
            if animated {
                self.isHidden = false
                self.alpha = 0
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    self?.alpha = 1
                }, completion: completion)
            } else {
                self.isHidden = false
            }
        }
    }
    
    func hide(animated: Bool = true, duration: Double = 0.2, completion: ((Bool) -> Void)? = nil) {
        if !self.isHidden {
            if animated {
                self.isHidden = false
                self.alpha = 1
                UIView.animate(withDuration: duration,
                               animations: { [weak self] in
                                self?.alpha = 0
                               },
                               completion: { [weak self] (_) in
                                self?.alpha = 1
                                self?.isHidden = true
                                completion?(true)
                               })
            } else {
                self.isHidden = true
            }
        }
    }

   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
