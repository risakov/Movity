import AVFoundation
import UIKit
import RxSwift

class VideoUtil {
    /**
     Достает кадр из видеоролика.
     - parameter videoURL: Ссылка на видеофайл.
     - parameter seconds: С какой секунды брать кадр.
     - parameter fps: Кадры в секундувидеоролика -  для вычисления кадра.
     - parameter size: Требуемый размер.
     */
    class func createThumbnail(videoURL: URL,
                               seconds: TimeInterval = 1,
                               fps: CMTimeScale = 30,
                               size: CGSize? = nil) throws -> UIImage {

        let asset = AVAsset(url: videoURL)

        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true

        if let size = size {
            // CGSize на разных устройствах может быть одинаковым, но количество занимаемых пикселей разное.
            // Чтобы генерировать картинку одинаковой плотности, что и экран пользователя.
            let scale = UIScreen.main.scale
            assetImgGenerate.maximumSize = CGSize(width: size.width * scale, height: size.height * scale)
        }

        let time = CMTime(seconds: seconds, preferredTimescale: fps)

        let cgImage = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)

        return thumbnail
    }
}
