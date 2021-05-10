import Foundation

// MARK: - Позволяет инициализировать ошибку по строке.
struct UserError: LocalizedError {

    let message: String

    var errorDescription: String? {
        return self.message
    }
}
