import Foundation
import RxSwift

protocol FileManagerGateway {
    /// Saves file from given URL in the persistent directory and returns the URL of saved file.
    ///
    /// - Parameter url: URL of resource
    /// - Returns: URL of saved file
    func saveFile(_ sourcePath: URL) -> Single<URL>
    func saveFile(_ sourcePath: URL, shouldRemoveSourceFile: Bool) -> Single<URL>
   
    func getTempDirectoryContent() -> Single<[URL]>
    func getContentOfFolder(folderName: String) -> Single<[URL]>
    func getContentOfDocumentDirectory() -> Single<[URL]>
    func getContentOfAppSupportDirectory() -> Single<[URL]>
    
    func removeFile(at filePath: String) -> Completable
    func removeFiles(at urls: [URL]) -> Completable
    func removeFolder(folderName: String) -> Completable
    
    func changeRootFolder(to folderName: String)
}
