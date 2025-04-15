//
//  ProductViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import Foundation
import SwiftData

/// ProductViewModel responsable de gestionar la lógica de negocio base relacionada con los productos.
///
/// Administra la lista de productos, genera Mock y expone métodos.

/// Utiliza un `ProductServiceProtocol` como capa de acceso a los datos.
/// Todas las operaciones se ejecutan en el hilo principal (`@MainActor`) para mantener la sincronización de la interfaz.
@MainActor
class ProductViewModel: ObservableObject {
    
    let productService: ProductServiceProtocol
    
    /// Lista observable de productos disponibles. La vista se actualiza automáticamente al modificarse esta propiedad.
    @Published var products: [ProductModel] = []
    
    /// Inicializa el ViewModel con una instancia de `ProductServiceProtocol`.
    ///
    /// - Parameter productService: Servicio encargado de la gestión de productos.
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }
    
    /// Carga todos los productos almacenados utilizando el servicio y actualiza la lista `products`.
    func loadAllProducts() {
        products = productService.fetchAllProducts()
    }
    
    /// Genera datos de prueba (mock) si la base de datos no contiene productos.
    func generateMockData() {
        productService.generateMockProducts(count: 5)
        loadAllProducts()
    }
    
}
