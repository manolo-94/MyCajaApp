//
//  SaleStatus.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation

enum SaleStatusEnum: String, CaseIterable, Identifiable, Codable {
    
    case draft
    
    case pending
    
    case inProgress
    
    case completed
    
    case failed
    
    case canceled
    
    case refunded
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .draft:
            return "Borrador"
        case .pending:
            return "Pendiente"
        case .inProgress:
            return "En progreso"
        case .completed:
            return "Completada"
        case .failed:
            return "Fallida"
        case .canceled:
            return "Cancelada"
        case .refunded:
            return "Reembolso"
        }
    }
}
