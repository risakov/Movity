import AVFoundation

extension URL {
    /**
     Возвращает  длительность видео.
     */
    var mediaDuration: TimeInterval {
        return AVURLAsset(url: self,
                          options: [AVURLAssetPreferPreciseDurationAndTimingKey: true]).duration.seconds
    }
}
