//
//  ErrorTypes.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 21/11/24.
//

import Foundation

enum ErrorTypes: LocalizedError {
    case mediaNotFound
    case indexOutOfBounds
    
    var errorDescription: String? {
        switch self {
        case .mediaNotFound:
            return "A mídia selecionada não foi encontrada."
        case .indexOutOfBounds:
            return "O índice da mídia está fora do alcance válido."
        }
    }
}
