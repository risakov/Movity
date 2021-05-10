import RxSwift
import UIKit

extension ObservableType {
    /**
     Позволяет задать таймаут и навесить на него свою ошибку.
     */
    public func timeout(_ dueTime: RxTimeInterval,
                        error: Swift.Error,
                        scheduler: SchedulerType) -> Observable<Element> {
        return timeout(dueTime, other: Observable.error(error), scheduler: scheduler)
    }

    /**
     Позволяет обработать ошибку и выдать на выход обработанную.
     */
    public func mapError(_ map: @escaping (Error) -> Error) -> Observable<Element> {
        return self.catchError { (error: Error) -> Observable<Element> in
            throw map(error)
        }
    }

    /**
     Подменяет любую ошибку в цепочке на заданную.
     */
    public func applyError(_ error: Error) -> Observable<Element> {
        return self.catchError { _ -> Observable<Element> in
            throw error
        }
    }

    /**
     Запускает цикл по условию.
     */
    public func repeatWhile(predicate: @escaping () -> Bool) -> Observable<Element> {
        return concat(Observable.error(FakeError())).catchError { (error: Error) -> Observable<Element> in
            if error is FakeError == false {
                return Observable.error(error)
            }
            if predicate() {
                return self.repeatWhile(predicate: predicate)
            } else {
                return Observable.empty()
            }
        }
    }
}

extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Never {
    /**
     Просто сокращение оператора andThen. Позволяет выполнить другой блок после завершения.
     */
    func then(_ block: () -> Completable) -> Completable {
        return self.andThen(block())
    }
    
    /**
     Просто сокращение оператора andThen. Позволяет выполнить другой блок после завершения.
     */
    func then<E>(_ block: () -> Single<E>) -> Single<E> {
        return self.andThen(block())
    }
    
    /**
     Просто сокращение оператора andThen. Позволяет выполнить другой блок после завершения.
     */
    func then<E>(_ block: () -> Observable<E>) -> Observable<E> {
        return self.andThen(block())
    }
}

extension PrimitiveSequence {
    /**
     Подменяет любую ошибку в цепочке на заданную.
     */
    public func applyError(_ error: Error) -> PrimitiveSequence<Trait, Element> {
        return catchError { _ -> PrimitiveSequence<Trait, Element> in
            throw error
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    /**
     Создает Single из лямбда-функции, описанной прямо в параметрах.
     */
    static func from(_ lambda: @escaping @autoclosure () throws -> Element) -> Single<Element> {
        return Single<Element>.create { observer in
            do {
                try observer(.success(lambda()))
            } catch let e {
                observer(.error(e))
            }
            return Disposables.create()
        }
    }
    
    /**
     Создает Single из лямбда-функции.
     */
    static func from(_ lambda: @escaping () throws -> Element) -> Single<Element> {
        return Single<Element>.create { observer in
            do {
                try observer(.success(lambda()))
            } catch let e {
                observer(.error(e))
            }
            return Disposables.create()
        }
    }

    /**
     Позволяет задать таймаут и навесить на него свою ошибку.
     */
    public func timeout(_ dueTime: RxTimeInterval,
                        error: Swift.Error,
                        scheduler: SchedulerType) -> PrimitiveSequence<SingleTrait, Element> {
        return timeout(dueTime, other: Single.error(error), scheduler: scheduler)
    }
}

extension PrimitiveSequence where Trait == CompletableTrait {
    /**
     Создает Single из лямбда-функции, описанной прямо в параметрах.
     */
    static func from(_ lambda: @escaping @autoclosure () throws -> Void) -> Completable {
        return .create { observer in
            do {
                try lambda()
                observer(.completed)
            } catch let e {
                observer(.error(e))
            }
            return Disposables.create()
        }
    }
}

extension Observable where Element == ProgressResult<URL> {
    /**
     Служит для подхвата прогресса в ActivityIndicator из ProgressObservable.
     */
    func applyProgressDialog() -> Observable<Element> {
        return self.onProgressChange { progress in
            DispatchQueue.main.async {
                if progress == 1 {
                    ProgressHudControl.dismiss()
                    return
                }
                ProgressHudControl.show(progress: progress, withCancelButton: false, halfProgress: false)
            }
        }
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate class FakeError: Error {
    /// Используется сугубо в имплементации расширений.
}
// swiftlint:enable private_over_fileprivate
