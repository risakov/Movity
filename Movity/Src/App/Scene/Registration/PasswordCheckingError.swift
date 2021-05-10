//
//  PasswordCheckingError.swift
//  Movity
//
//  Created by Роман on 11.05.2021.
//

import Foundation

enum PasswordCheckingError: LocalizedError {
    case passwordsAreNotEqual
    case incorrectValues
    case shortPassword
    
    var errorDescription: String? {
        switch self {
        case .passwordsAreNotEqual:
            return "Пароли не совпадают"
            
        case .incorrectValues:
            return "Некорректные символы"
            
        case .shortPassword:
            return "Не менее 6 символов"
        }
    }
}
