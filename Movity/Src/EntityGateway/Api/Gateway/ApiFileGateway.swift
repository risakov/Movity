import Foundation
import RxSwift
import RxNetworkApiClient

class ApiFileGateway: ApiBaseGateway, FileGateway {

    func createFileByPath(file: FileEntity) -> Single<FileEntity> {
        let request: ExtendedApiRequest<FileEntity> = .createFileByPath(file)
        
        return self.apiClient.execute(request: request)
    }
    
    // Пример загрузки изображения
    func uploadImageFile(name: String, url: URL?, data: Data?) -> Single<FileEntity> {
        return .deferred {
            do {
                var dataOut: Data?
                
                if let url = url {
                    dataOut = try Data(contentsOf: url)
                } else {
                    if let data = data { dataOut = data } else {
                        return Single.error(NSError(domain: "Не удалось прочитать данные из файла", code: 999, userInfo: nil))
                    }
                }
                
                let uploadFile = UploadFile("\(name)_\(Date()).jpg", dataOut!, "image")
                
                let request: ExtendedApiRequest<FileEntity> = ExtendedApiRequest.uploadFile(uploadFile)
                request.responseTimeout = 120
                return self.apiClient.execute(request: request)
            } catch {
                return Single.error(NSError(domain: "Не удалось прочитать данные из файла", code: 999, userInfo: nil))
            }
        }
    }
}
