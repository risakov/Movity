import Foundation

public typealias ProgressClosure = (_ progress: Float) -> Void
public typealias ResultClosure<T> = (T) -> Void
public typealias ErrorClosure = (Error) -> Void
public typealias CreatorClosure<T> = (ProgressEmitter<T>) throws -> Void

private class ProgressChain {

    var deepCount: Int = 1
    var completedCount: Int = 0

    var shadowDeep: Int = 0
    var currentStepsCount: Int = 0
    var currentProgressValue: Float = 0.0
}

public class ProgressObservable<T: Any> {

    private let creator: CreatorClosure<T>
    fileprivate var progressChain: ProgressChain

    private init(_ creator: @escaping CreatorClosure<T>, _ progressChain: ProgressChain) {
        self.creator = creator
        self.progressChain = progressChain
    }

    public func observe(onProgress: @escaping ProgressClosure,
                        onResult: @escaping ResultClosure<T>,
                        onError: @escaping ErrorClosure) {
        let emitter = ProgressEmitter(onProgress, onResult, onError, self.progressChain)

        do {
            try creator(emitter)
        } catch {
            emitter.error(error)
        }
    }

    public func get() throws -> T {
        var resultElement: T?
        var resultError: Error?

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        self.observe(onProgress: { _ in },
                     onResult: { element in
                         resultElement = element
                         dispatchGroup.leave()
                     },
                     onError: { error in
                         resultError = error
                         dispatchGroup.leave()
                     })

        dispatchGroup.wait()

        if let error = resultError {
            throw error
        }
        if let result = resultElement {
            return result
        }

        fatalError("Expected returned Result value or Error.")
    }

    public func flatMap<D>(silent: Bool = false,
                           _ selector: @escaping (T) -> ProgressObservable<D>) -> ProgressObservable<D> {
        let creator = { (emitter: ProgressEmitter<D>) in

            if silent {
                self.progressChain.shadowDeep += 1
            } else {
                self.progressChain.deepCount += 1
            }

            self.observe(onProgress: emitter.progress(_:),
                         onResult: { (v: T) in
                             if silent {
                                 self.progressChain.shadowDeep -= 1
                             } else {
                                 self.progressChain.completedCount += 1
                             }

                             let newObservable = selector(v)
                             newObservable.progressChain = self.progressChain

                             newObservable.observe(onProgress: emitter.progress(_:),
                                                   onResult: emitter.result(element:),
                                                   onError: emitter.error)
                         }, onError: emitter.error(_:))
        }
        return ProgressObservable<D>(creator, self.progressChain)
    }

    public func map<D>(_ selector: @escaping (T) throws -> D) -> ProgressObservable<D> {
        let creator = { (emitter: ProgressEmitter<D>) in
            self.progressChain.shadowDeep += 1
            self.observe(onProgress: emitter.progress(_:),
                         onResult: { (v: T) in
                             self.progressChain.shadowDeep -= 1

                             do {
                                 let mapped: D = try selector(v)
                                 emitter.result(element: mapped)
                             } catch {
                                 emitter.error(error)
                             }
                         },
                         onError: emitter.error(_:))
        }
        return ProgressObservable<D>(creator, self.progressChain)
    }

    public class func flat(_ observables: [ProgressObservable<T>]) -> ProgressObservable<[T]> {
        assert(!observables.isEmpty, "Try to Flat empty array.")
        return .create({ emitter in

            var values = [T]()

            for observable in observables {
                var resultElement: T?
                var resultError: Error?

                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()

                observable.observe(onProgress: { progress in
                    let baseProgress = 1 / Float(observables.count) * Float(values.count)
                    let partProgress = 1 / Float(observables.count) * progress

                    emitter.progress(baseProgress + partProgress)
                }, onResult: { element in
                    resultElement = element
                    dispatchGroup.leave()
                }, onError: { error in
                    resultError = error
                    dispatchGroup.leave()
                })

                dispatchGroup.wait()

                if let error = resultError {
                    emitter.error(error)
                    return
                }
                guard let result = resultElement else {
                    fatalError("Expected returned Result value or Error.")
                }
                values.append(result)
            }

            emitter.result(element: values)
        })
    }

    public class func deferred(_ selector: @escaping () throws -> ProgressObservable<T>) -> ProgressObservable<T> {
        return .create { (emitter: ProgressEmitter<T>) in
            try selector().observe(onProgress: emitter.progress,
                                   onResult: emitter.result(element:),
                                   onError: emitter.error)
        }
    }

    public class func create(_ creator: @escaping CreatorClosure<T>) -> ProgressObservable<T> {
        return ProgressObservable(creator, ProgressChain())
    }

    public class func just(_ value: T) -> ProgressObservable<T> {
        return .create { emitter in emitter.result(element: value) }
    }

    public class func error(_ error: Error) -> ProgressObservable<T> {
        return .create { emitter in emitter.error(error) }
    }
}

public class ProgressEmitter<T> {

    private let onProgress: ProgressClosure
    private let onResult: ResultClosure<T>
    private let onError: ErrorClosure
    private let progressChain: ProgressChain

    fileprivate init(_ onProgress: @escaping ProgressClosure,
                     _ onResult: @escaping ResultClosure<T>,
                     _ onError: @escaping ErrorClosure,
                     _ progressChain: ProgressChain) {
        self.onProgress = onProgress
        self.onResult = onResult
        self.onError = onError
        self.progressChain = progressChain
    }

    public func progress(_ progress: Float) {
        let chainProgress: Float

        if self.progressChain.currentStepsCount == 0 {

            var repeats = self.progressChain.deepCount - self.progressChain.completedCount + self.progressChain.shadowDeep
            if self.progressChain.completedCount != 0 {
                repeats += 1
            }

            self.progressChain.currentStepsCount = repeats - 1
            chainProgress = progress / Float(self.progressChain.deepCount)

            let baseProgress: Float = (1 / Float(self.progressChain.deepCount) * Float(self.progressChain.completedCount))

            self.progressChain.currentProgressValue = chainProgress + baseProgress
        } else {
            chainProgress = self.progressChain.currentProgressValue
            self.progressChain.currentStepsCount -= 1
        }

        self.onProgress(chainProgress)
    }

    public func result(element: T) {
        self.onResult(element)
    }

    public func error(_ error: Error) {
        self.onError(error)
    }
}
