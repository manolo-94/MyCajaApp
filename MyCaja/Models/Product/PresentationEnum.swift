//
//  PresentacionEnum.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import Foundation

// Enun para la forma en que se vende el producto

enum PresentacionEnum: String, CaseIterable, Identifiable, Codable {
    
    case granel
    case paquete
    case unidad
    case docena
    case otro
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .granel:
            return "Granel"
        case .paquete:
            return "Paquete"
        case .unidad:
            return "Unidad"
        case .docena:
            return "Docena"
        case .otro:
            return "Otro"
        }
    }
}
