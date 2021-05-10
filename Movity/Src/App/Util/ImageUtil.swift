import UIKit
import CoreImage
import Photos

extension CGImage {
    /**
     Считает степень освещенности изображения.
    */
    var luminance: Float {
        guard let imageData = self.dataProvider?.data else { return 0 }
        guard let ptr = CFDataGetBytePtr(imageData) else { return 0 }
        let length = CFDataGetLength(imageData)

        let totalPixels = Int(Double(self.width * self.height))
        var darkPixels = 0

        for i in stride(from: 0, to: length, by: 4) {
            let r = ptr[i]
            let g = ptr[i + 1]
            let b = ptr[i + 2]
            let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
            if luminance < 150 {
                darkPixels += 1
            }
        }
        return 1 - (Float(darkPixels) / Float(totalPixels))
    }
}

extension CIImage {
    /**
     Генерирует UIImage на основе CIImage.
    */
    var uiImage: UIImage {
        let context: CIContext = CIContext(options: nil)
        let cgImage: CGImage = context.createCGImage(self, from: self.extent)!
        return UIImage(cgImage: cgImage)
    }
}

extension CALayer {
    /**
     Генерирует UIImage на основе CALayer.
    */
    var uiImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

extension UIImage {
    /**
     Считает степень освещенности изображения.
    */
    var luminance: Float {
        return self.cgImage?.luminance ?? 0.0
    }

    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage? {
        // Guard newSize is different
        guard self.size != newSize else { return self }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage? {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height

        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }

        let newSize = CGSize(width: size.width / resizeFactor, height: size.height / resizeFactor)
        return resizedImage(newSize: newSize)
    }

    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
}

extension PHImageManager {
    /**
     Возвращает Data картинки из галереи.
     - Parameter asset: PHAsset - сведения об объекте.
     - Returns: Data-байты объекта.
    */
    func requestImageDataSynchronously(for asset: PHAsset) throws -> Data {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        var imageData: Data?

        PHImageManager.default()
                .requestImageData(for: asset, options: options) { data, _, _, _ in
                    imageData = data
                    dispatchGroup.leave()
                }

        dispatchGroup.wait()

        guard let data = imageData else {
            throw NSError(domain: "Not found data for PHAsset: \(asset)", code: 0)
        }

        return data
    }
}
