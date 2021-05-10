import UIKit

extension UIColor {
    
    // Основные цвета приложения
    open class var appLightGray: UIColor {
        return UIColor(named: "AppLightGray") ?? UIColor.gray
    }
    
    open class var appGray: UIColor {
        return UIColor(named: "AppGray") ?? UIColor.gray
    }
    
    open class var appBlue: UIColor {
        return UIColor(named: "AppBlue") ?? UIColor.blue
    }
    
    open class var appRed: UIColor {
        return UIColor(named: "AppRed") ?? UIColor.red
    }
    
    open class var appGreen: UIColor {
        return UIColor(named: "AppGreen") ?? UIColor.green
    }
    
    open class var appOrange: UIColor {
        return UIColor(named: "AppOrange") ?? UIColor.orange
    }
    
    open class var appWhite: UIColor {
        return UIColor(named: "AppWhite") ?? UIColor.white
    }
    
    open class var appLabelGray: UIColor {
        return UIColor(named: "LabelGray") ?? UIColor.gray
    }
    
    open class var appPlaceHolderGray: UIColor {
        return UIColor(named: "AppPlaceHolderGray") ?? UIColor.lightGray
    }
    
    open class var appDisabledGray: UIColor {
        return UIColor(named: "AppDisabledGray") ?? UIColor.lightGray
    }
    
    // Для поддержки темной темы и устройств < 13 ios
    open class var smartBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }
    
    // Для поддержки темной темы и устройств < 13 ios
    open class var smartTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
}
