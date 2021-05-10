import Foundation
import RxSwift

protocol FileGateway {
    func uploadImageFile(name: String, url: URL?, data: Data?) -> Single<FileEntity>
    func createFileByPath(file: FileEntity) -> Single<FileEntity>
}
