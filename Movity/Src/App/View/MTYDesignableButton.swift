//
//  MTYDesignableButton.swift
//  Movity
//
//  Created by Роман on 18.04.2021.
//

import UIKit

enum MTYButtonState: Int {
    case pink
    case clear
}

class MTYDesignableButton: DesignableUIButton {
    private var titleTemp: String?
    public var buttonState: MTYButtonState = .pink
    
    @IBInspectable var IBButtonState: Int {
        get {
            return self.buttonState.rawValue
        }
        set {
            self.updateState(MTYButtonState(rawValue: newValue))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateState()
    }
    
    public func updateState(_ state: MTYButtonState? = nil, _ title: String? = nil) {
        self.buttonState = state ?? self.buttonState
        
        self.setTitle(title ?? self.titleLabel?.text, for: .normal)
        self.setTitle(title ?? self.titleLabel?.text, for: .disabled)

        self.clipsToBounds = true
        self.cornerRadius = 6.0
        self.borderWidth = 1.0
        
        switch self.buttonState {
        case .pink:
            self.backgroundColor = R.color.violetLight()
            self.borderColor = UIColor.smartBackground
            self.setTitleColor(.appWhite, for: self.state)
            self.setTitleColor(.appGray, for: .disabled)
            self.titleLabel?.tintColor = .appWhite
            self.imageView?.tintColor = .appWhite
            self.tintColor = .appWhite
            self.changeDisableButtonColor()
            
        case .clear:
            self.backgroundColor = UIColor.smartBackground
            self.borderColor = R.color.violetLight()
            self.setTitleColor(R.color.violetLight(), for: self.state)
            self.titleLabel?.tintColor = R.color.violetLight()
            self.imageView?.tintColor = R.color.violetLight()
            self.tintColor = R.color.violetLight()
        }
        self.layoutSubviews()
    }
    
    func startLoadingAnimation() {
        self.isUserInteractionEnabled = false
        self.titleTemp = self.title(for: .normal)
        self.setTitle(nil, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        let loaderImage = R.image.loaderIcon()?
            .withRenderingMode(.alwaysTemplate)
        self.setImage(loaderImage, for: .normal)
        self.imageView?.startRotating()
        self.setNeedsDisplay()
    }
    
    func stopLoadingAnimation() {
        self.isUserInteractionEnabled = true
        self.imageView?.stopRotating()
        self.setImage(nil, for: .normal)
        self.setTitle(self.titleTemp, for: .normal)
        self.titleTemp = nil
        self.setNeedsDisplay()
    }
    
    private func changeDisableButtonColor() {
        let color = UIColor.appDisabledGray
        let rect = CGRect(x: 0.0, y: 0.0,
                          width: self.frame.width,
                          height: self.frame.height)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(image, for: .disabled)
    }
    
    public func getState() -> MTYButtonState {
        return self.buttonState
    }
}
