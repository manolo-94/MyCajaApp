//
//  PresentationEnum.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import Foundation

/// Enumeración que define las formas de presentación o empaque en que se vende un producto.
///
/// Implementa los protocolos `CaseIterable`, `Identifiable` y `Codable` para su fácil uso en listados, identificación única y persistencia de datos.
enum PresentationEnum: String, CaseIterable, Identifiable, Codable {
    
    /// Producto vendido a granel, es decir, sin empaquetado específico.
    case granel
    
    /// Producto vendido en paquete cerrado o agrupado.
    case paquete
    
    /// Producto vendido por unidad individual.
    case unidad
    
    /// Producto vendido en agrupaciones de docena (12 unidades).
    case docena
    
    /// Presentación personalizada o no especificada.
    case otro
    
    /// Identificador único para cada forma de presentación, basado en su valor en crudo (`rawValue`).
    var id: String { self.rawValue }
    
    /// Descripción legible para mostrar en la interfaz de usuario o reportes.
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
