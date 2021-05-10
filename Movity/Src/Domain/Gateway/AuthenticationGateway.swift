import Foundation
import RxSwift

protocol AuthenticationGateway {
    func auth(_ username: String, _ password: String) -> Single<TokenEntity>
    func refreshToken(_ refreshToken: String) -> Single<TokenEntity>
}
