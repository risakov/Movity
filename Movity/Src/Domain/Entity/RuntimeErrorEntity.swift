//
//  RuntimeErrorEntity.swift
//  Movity
//
//  Created by Роман on 11.05.2021.
//

import Foundation

struct RuntimeError: LocalizedError {
    let message: String?

    init(_ message: String? = nil) {
        self.message = message
    }

    public var errorDescription: String? {
        return message
    }
}
