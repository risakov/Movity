import Foundation

class PaginationEntity<T: Codable>: Codable {

    var totalItems: Int
    var itemsPerPage: Int
    var countOfPages: Int
    var items: [T]

    init(totalItems: Int, itemsPerPage: Int, countOfPages: Int, items: [T]) {
        self.totalItems = totalItems
        self.itemsPerPage = itemsPerPage
        self.countOfPages = countOfPages
        self.items = items
    }
}
