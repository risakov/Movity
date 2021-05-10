import Foundation
import UIKit

enum StubType {
    case common
    case favorites

    static func getImage(_ type: StubType) -> UIImage? {
        switch type {
        case .common:
            return R.image.empty_background()
            
        case .favorites:
            return R.image.favorits_background()
        }
    }
}
