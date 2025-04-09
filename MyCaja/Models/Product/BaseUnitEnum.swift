//
//  BaseUnitEnum.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import Foundation

// Enum para la unidad de medida base

enum BaseUnitEnum: String, CaseIterable, Identifiable, Codable {
    
    case kilogramo
    case litro
    case mililitro
    case pieza
    case unidad
    case otro
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .kilogramo:
            return "Kilogramo (Kg)"
        case .litro:
            return "Litro (L)"
        case .mililitro:
            return "Mililitro (ml)"
        case .pieza:
            return "Pieza"
        case .unidad:
            return "Unidad"
        case .otro:
            return "Otro"
        }
    }
}
