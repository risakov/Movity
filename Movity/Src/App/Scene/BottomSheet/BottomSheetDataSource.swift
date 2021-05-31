import UIKit
import UBottomSheet

class BottomSheetDataSource: UBottomSheetCoordinatorDataSource {
    // Итак, во-первых за костыль сори. Во-вторых, этот костыль был создан для того, чтобы сделать под адаптивным под все айфоны, т.к. этот коэффициент не переопределяется в зависимости от высоты экрана(здесь это availableHeight, за подробностями в под). ПОСЛЕ ОТКАЗА ОТ ПОДДЕРЖКИ iOS 9 и 10 ПЕРЕЙТИ НА ПОД FloatingPanel !!!
    
    // Для альбомной ориентации
    let landscapeCoefficient: CGFloat = 0.3
    // Для потретной ориентации
    let portraitCoefficient: CGFloat = 0.6
    // Для айфонов 5s, SE
    let smallHeightiPhoneCoefficient: CGFloat = 0.5
    // Для айфонов 6, 6s, 7, 8, 6, Plus, 6s Plus, 7 Plus, 8 Plus, и это дефолтное значение
    let mediumHeightiPhoneCoefficient: CGFloat = 0.6
    // Для некоторых айфонов с бровью, у которых не совсем стандартный размер экрана
    let prehighHeightiPhoneCoefficient: CGFloat = 0.66
    // Для айфонов с бровью
    let highHeightiPhoneCoefficient: CGFloat = 0.45
    let screenHeight = UIScreen.main.bounds.height
    
    // В этой функции возвращается массив положений шторки на экране, сделано одно только положение на экране, чтобы сделать шторку неактивной, иначе из-за этого появляются проблемы. Поэтому возвращается массив с одним элементом. Реализованная функция протокола UBottomSheetCoordinatorDataSource пода UBottomSheet
    
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        if UIDevice.current.orientation.isLandscape {
            return [landscapeCoefficient].map { $0 * availableHeight }
        } else {
            print(screenHeight)
            switch screenHeight {
            case ..<600:
                return [smallHeightiPhoneCoefficient].map { $0 * availableHeight }
                
            case 600...700:
                return [mediumHeightiPhoneCoefficient].map { $0 * availableHeight }
                
            case 700...800:
                return [mediumHeightiPhoneCoefficient].map { $0 * availableHeight }
                
            case 800...850:
                return [prehighHeightiPhoneCoefficient].map { $0 * availableHeight }

            case 850...1200:
                return [highHeightiPhoneCoefficient].map { $0 * availableHeight }
                
            default:
                return [mediumHeightiPhoneCoefficient].map { $0 * availableHeight }
            }
        }
    }
    
    // В этой задается начальное положение шторки, соответственно оно и возвращается. Реализованная функция протокола UBottomSheetCoordinatorDataSource пода UBottomSheet
    
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return availableHeight * landscapeCoefficient
        } else {
            switch screenHeight {
            case ..<600:
                return availableHeight * smallHeightiPhoneCoefficient
                
            case 600...700:
                return availableHeight * mediumHeightiPhoneCoefficient
                
            case 700...800:
                return availableHeight * mediumHeightiPhoneCoefficient
                
            case 800...850:
                return availableHeight * prehighHeightiPhoneCoefficient
                
            case 850...1200:
                return availableHeight * highHeightiPhoneCoefficient

            default:
                return availableHeight * mediumHeightiPhoneCoefficient
            }
        }
    }
}
