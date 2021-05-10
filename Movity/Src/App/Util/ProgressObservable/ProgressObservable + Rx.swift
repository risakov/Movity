import Foundation
import RxSwift

extension ProgressObservable {

    func rx() -> RxProgressObservable<T> {
        let progressQueue = DispatchQueue(label: "ProgressQueue \(UInt32.random(in: 0...9999))")
        return .create { [progressQueue] observer in

            self.observe(onProgress: { progress in
                progressQueue.sync {
                    observer.onNext(.progress(progress))
                }
            }, onResult: { (element: T) in
                progressQueue.sync {
                    observer.onNext(.result(element))
                    observer.onCompleted()
                }
            }, onError: { error in
                progressQueue.sync {
                    observer.onError(error)
                }
            })

            return Disposables.create()
        }
    }

}

struct ProgressResult<T> {

    let progress: Float?
    let result: T?
}

extension ProgressResult {

    var asProgress: Float {
        return self.progress!
    }

    var asResult: T {
        return self.result!
    }

    static func progress(_ progress: Float) -> ProgressResult<T> {
        return ProgressResult(progress: progress, result: nil)
    }

    static func result(_ result: T) -> ProgressResult<T> {
        return ProgressResult(progress: nil, result: result)
    }
}

typealias RxProgressObservable<T> = Observable<ProgressResult<T>>

extension Observable where Element == ProgressResult<URL> {

    func onProgressChange(_ onChange: @escaping (Float) -> Void) -> Observable<Element> {
        return self.do(onNext: { (element: Element) in
            element.progress.map(onChange)

            if element.result != nil {
                onChange(1)
            }
        })
    }

    func toResult() -> Single<URL> {
        return self.filter { (result: ProgressResult<URL>) in
                    result.result != nil
                }
                .map { $0.asResult }
                .take(1)
                .asSingle()
    }
}
