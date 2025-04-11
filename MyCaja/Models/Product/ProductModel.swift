//
//  ProductModel.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import Foundation
import SwiftData

/// Modelo de datos que representa un producto dentro de la aplicación.
///
/// Utiliza SwiftData para la persistencia de datos.
/// Cada producto tiene un identificador único, un nombre, precio, disponibilidad, tipo de presentación, unidad base y una imagen opcional.
@Model
class ProductModel {
    
    /// Identificador único del producto.
    ///
    /// Este atributo está marcado como único dentro del modelo de datos.
    @Attribute(.unique) var id: UUID
    
    /// Nombre del producto.
    var name: String
    
    /// Precio del producto expresado en una cantidad decimal.
    var price: Double
    
    /// Indica si el producto está disponible para su venta.
    var available: Bool
    
    /// Tipo de presentación del producto (por ejemplo, botella, caja, etc.).
    var presentation: PresentationEnum
    
    /// Unidad base asociada al producto (por ejemplo, litros, piezas, gramos, etc.).
    var baseUnit: BaseUnitEnum
    
    /// Imagen del producto almacenada en formato binario (opcional).
    var image: Data?
    
    /// Inicializador del modelo `ProductModel`.
    ///
    /// - Parameters:
    ///   - id: Identificador único. Se genera automáticamente si no se proporciona.
    ///   - name: Nombre del producto.
    ///   - price: Precio del producto.
    ///   - available: Estado de disponibilidad del producto.
    ///   - presentation: Tipo de presentación del producto.
    ///   - baseUnit: Unidad base utilizada por el producto.
    ///   - image: Imagen asociada al producto (opcional).
    init (
        id: UUID = UUID(),
        name: String,
        price: Double,
        available: Bool,
        presentation: PresentationEnum,
        baseUnit: BaseUnitEnum,
        image: Data? = nil
    ){
        self.id = id
        self.name = name
        self.price = price
        self.available = available
        self.presentation = presentation
        self.baseUnit = baseUnit
        self.image = image
    }
}

// SUGERENCIA:
// Actualmente `ProductModel` no implementa validaciones internas, por ejemplo, evitar que el nombre esté vacío o que el precio sea negativo.
// Se podría considerar agregar validaciones simples dentro del inicializador para mejorar la integridad de los datos.
