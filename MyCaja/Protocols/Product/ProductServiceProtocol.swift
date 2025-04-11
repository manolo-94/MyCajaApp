//
//  ProductServiceProtocol.swift
//  MyCaja
//
//  Created by MacBook Air on 11/04/25.
//

import Foundation

/// Protocolo que define las operaciones esenciales para gestionar productos en la aplicación.
///
/// Al utilizar este protocolo, los servicios concretos (por ejemplo, conexión local o servidor)
/// pueden ser fácilmente intercambiables sin afectar a las capas superiores (como el ViewModel).
@MainActor
protocol ProductServiceProtocol {
    
    /// Crea un nuevo producto en la fuente de datos.
    ///
    /// - Parameter product: El producto a ser creado.
    func createProduct(_ product: ProductModel)
    
    /// Actualiza la información de los productos en la fuente de datos.
    ///
    /// - Parameter product: El producto a ser actualizado
    func updateProduct(_ product: ProductModel)
    
    /// Elimina un producto existente de la fuente de datos.
    ///
    /// - Parameter product: El producto a ser eliminado.
    func deleteProduct(_ product: ProductModel)
    
    /// Obtiene todos los productos disponibles desde la fuente de datos.
    ///
    /// - Returns: Una lista de `ProductModel` disponibles.
    func fetchAllProducts() -> [ProductModel]
    
    /// Genera productos de prueba para propósitos de desarrollo o demostración.
    ///
    /// - Parameter count: La cantidad de productos de prueba a generar.
    func generateMockProducts(count: Int)
}
