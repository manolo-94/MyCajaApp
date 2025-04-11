//
//  BaseUnitEnum.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import Foundation

/// Enumeración que define las unidades de medida base para los productos.
///
/// Implementa los protocolos `CaseIterable`, `Identifiable` y `Codable` para facilitar su uso en listas, identificación única y codificación/decodificación de datos.
enum BaseUnitEnum: String, CaseIterable, Identifiable, Codable {
    
    /// Unidad de medida en kilogramos.
    case kilogramo
    
    /// Unidad de medida en litros.
    case litro
    
    /// Unidad de medida en mililitros.
    case mililitro
    
    /// Unidad de medida por pieza individual.
    case pieza
    
    /// Unidad de medida genérica de unidad simple.
    case unidad
    
    /// Unidad de medida personalizada o no especificada.
    case otro
    
    /// Identificador único para cada unidad, basado en su valor en crudo (`rawValue`).
    var id: String { self.rawValue }
    
    /// Descripción legible de cada unidad de medida, para uso en la interfaz de usuario o reportes.
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
