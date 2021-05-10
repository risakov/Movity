import UIKit
import Kingfisher

extension UIImageView {

    /**
     Устанавливает в ImageView картинку из provider для KingFisher.
     - Parameter source: provider изображений
    */
    func loadImage(with provider: ImageDataProvider?) {
        if let provider = provider {
            self.prepareImageLoading()
            self.kf.setImage(with: provider, options: [.transition(.none)])
        }
    }
    
    /**
     Устанавливает в ImageView картинку из Source для KingFisher.
     - Parameter source: Источник изображений
    */
    func loadImage(with source: Source?) {
        if let source = source {
            self.prepareImageLoading()
            self.kf.setImage(with: source)
        }
    }
    
    /**
     Устанавливает в ImageView картинку из Resource для KingFisher.
     - Parameter resource: ресурс изображения.
    */
    func loadImage(with resource: Resource?) {
        if let resource = resource {
            self.prepareImageLoading()
            self.kf.setImage(with: resource)
        }
    }
    
    /**
     Подготавливает ImageView для работы с KingFisher.
    */
    private func prepareImageLoading() {
        self.kf.indicatorType = .activity
        self.contentMode = .scaleAspectFit
    }
}
