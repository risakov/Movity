import Foundation
import RxSwift

// ElementEntity и ElementGateway - это просто заглушки, на их местах должны быть реальные сущности и реальные шлюзы для работы с конкретными данными. TODO: Сделать дженерик пагинацию
protocol PaginationUseCase {
    var source: PublishSubject<[ElementEntity]> { get }
    var isLoadingInProcess: Bool { get }
    var currentPage: Int { get }
    var totalItemsCount: Int? { get }

    func hasMorePage() -> Bool
    func loadNewData(elementId: Int) -> Completable
    func replaceElement(_ element: ElementEntity)
    func reset()
}

class PaginationUseCaseImp: PaginationUseCase {

    public var source = PublishSubject<[ElementEntity]>()
    public var isLoadingInProcess: Bool = false
    public var currentPage = 1
    public var totalItemsCount: Int?

    private let gateway: ElementGateway
    private var items = [ElementEntity]()
    private var requestsBag = DisposeBag()

    init(gateway: ElementGateway) {
        self.gateway = gateway
    }

    public func hasMorePage() -> Bool {

        guard let totalItemsCount = self.totalItemsCount else {
            return true
        }

        return self.items.count < totalItemsCount
    }

    public func loadNewData(elementId: Int) -> Completable {
        return .deferred {
            self.cancelLoading()
            self.isLoadingInProcess = true

            return self.gateway.getElements(elementId, self.currentPage)
                    .do(onSuccess: { (result: PaginationEntity<ElementEntity>) in
                        self.currentPage += 1
                        self.totalItemsCount = result.totalItems
                        self.items.append(contentsOf: result.items)
                        self.isLoadingInProcess = false
                        self.source.onNext(self.items)
                    }, onError: { error in
                        self.isLoadingInProcess = false
                        print("PaginationSourceUseCase: catch error =", error.localizedDescription)
                    })
                    .asCompletable()
        }

    }
    
    public func replaceElement(_ element: ElementEntity) {
        let updatedElementIndex = self.items.firstIndex { $0.id == element.id }
        if let index = updatedElementIndex {
            self.items[index] = element
            self.source.onNext(self.items)
        }
    }

    public func reset() {
        self.items.removeAll()
        self.totalItemsCount = nil
        self.currentPage = 1
    }

    private func cancelLoading() {
        requestsBag = DisposeBag()
    }
}
