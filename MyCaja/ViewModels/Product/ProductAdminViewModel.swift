//
//  ProductViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import Foundation
import SwiftData

/// ProductAdminViewModel responsable de gestionar la lógica de negocio CRUD relacionada con los productos.
///
/// Expone métodos para agregar, editar, eliminar y cargar productos.

/// La clase `ProductServiceProtocol` extiende de `ProductViewModel` para tener acceso a sus propiedades y funciones.

/// Utiliza un `ProductServiceProtocol` como capa de acceso a los datos.
/// Todas las operaciones se ejecutan en el hilo principal (`@MainActor`) para mantener la sincronización de la interfaz.
@MainActor
final class ProductAdminViewModel: ProductViewModel {
    
    override init(productService: ProductServiceProtocol) {
        super.init(productService: productService)
        loadAllProducts()
        
        if products.isEmpty {
            generateMockData()
        }
    }
    
    /// Agrega un nuevo producto a la base de datos y actualiza la lista de productos.
    ///
    /// - Parameters:
    ///   - name: Nombre del producto.
    ///   - price: Precio del producto.
    ///   - available: Disponibilidad del producto.
    ///   - presentation: Tipo de presentación del producto.
    ///   - baseUnit: Unidad de medida base del producto.
    ///   - image: Imagen asociada al producto, opcional.
    func addProduct(
        name: String,
        price: Double,
        available: Bool,
        presentation: PresentationEnum,
        baseUnit: BaseUnitEnum,
        image: Data? = nil
    ) {
        let product = ProductModel(
            name: name,
            price: price,
            available: available,
            presentation: presentation,
            baseUnit: baseUnit,
            image: image
        )
        productService.createProduct(product)
        loadAllProducts()
    }
    
    /// Actualiza un producto existente en la base de datos y refresca la lista.
    ///
    /// - Parameter product: Producto actualizado.
    func editProduct(
        product: ProductModel,
        name: String,
        price: Double,
        available: Bool,
        presentation: PresentationEnum,
        baseUnit: BaseUnitEnum,
        image: Data? = nil
    ) {
        // Actualiza el producto con los nuevos valores.
        product.name = name
        product.price = price
        product.available = available
        product.presentation = presentation
        product.baseUnit = baseUnit
        product.image = image
        
        // Llama al servicio para actualizar el producto específico.
        productService.updateProduct(product)
        
        // Recarga la lista de productos después de la actualización.
        loadAllProducts()
    }
    
    /// Elimina un producto de la base de datos y actualiza la lista.
    ///
    /// - Parameter product: Producto que se desea eliminar.
    func removeProduct(_ product: ProductModel) {
        productService.deleteProduct(product)
        loadAllProducts()
    }

}
