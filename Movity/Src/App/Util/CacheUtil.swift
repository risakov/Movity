import AVFoundation

class CacheUtil {

    /**
     Кеширует некешированное и возвращает ссылку на кеш вместо ссылки на внешний ресурс.
     - Parameter remoteUrl: URL файла на внешнем ресурсе
     - Returns: URL локального файла

     - Remark:
     Кеш необходимо очищать.
    */
    class func cached(remoteUrl: URL) throws -> URL {

        let path = "cached_\(remoteUrl.path.hash)_\(remoteUrl.pathComponents.last ?? "X")"

        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(path)

        if FileManager.default.fileExists(atPath: path) {
            return outputURL
        } else {
            try Data(contentsOf: remoteUrl).write(to: outputURL)
            return outputURL
        }
    }
}
