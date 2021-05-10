import Foundation
import RxNetworkApiClient

class Config {
    
    // Все здесь должно быть в соответствии с проектом

    static var apiEndpoint = "https://9fe5759621d3.ngrok.io"
    static var resourceEndpoint = "https://baseAppApi.ru/uploads/"
    
    static var extraPath = "/api"
    
    static var googleStorageEndpoint = "https://storage.googleapis.com/upload/storage/v1/b/baseApp-file-storage"
    
    static let clientId = "2_5652pd1vzkg8ko0kcoc40skcok0o4844c0s88w840coossoc88"
    static let clientSecret = "1b30ywq3rehw0ckoc04scgkosccoo800gwwsckocwokcsgc8ks"
            
    static let appStoreIdentifier = "1474816595"
    static func setState(_ endpoints: (main: String, userArea: String)) {
        let prefix = "https://"
        let postfix = "/uploads/"
        Config.apiEndpoint = endpoints.main.contains(prefix) ? endpoints.main : prefix + endpoints.main
        Config.resourceEndpoint = endpoints.main.contains(prefix) ? endpoints.main + postfix : prefix + endpoints.main + postfix
        ApiEndpoint.updateEndpoint()
    }
}
