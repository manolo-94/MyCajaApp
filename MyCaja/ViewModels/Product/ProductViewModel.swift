//
//  ProductViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import Foundation
import SwiftData

/// ViewModel encargado de gestionar la lógica de negocio relacionada a los productos.
///
/// Administra la lista de productos y expone métodos para agregar, editar, eliminar y cargar productos.
/// Utiliza un `ProductService` como capa de acceso a los datos.
/// Todas las operaciones son realizadas en el hilo principal (`@MainActor`).
@MainActor
final class ProductViewModel: ObservableObject {
    
    /// Servicio de productos utilizado para acceder y modificar los datos.
    private let productService: ProductService
    
    /// Lista de productos disponibles, observable por la vista.
    @Published var products: [ProductModel] = []
    
    /// Inicializa el ViewModel con un contexto de datos proporcionado.
    ///
    /// - Parameter context: Contexto de modelo de SwiftData.
    init(context: ModelContext){
        self.productService = ProductService(context: context)
        loadAllProducts()
        
        // Solo generar productos de prueba si no existen productos guardados
        if products.isEmpty {
            generateMockData()
        }
    }
    
    /// Carga todos los productos disponibles desde el servicio y actualiza la propiedad `products`.
    func loadAllProducts(){
        products = productService.fetchAllProducts()
    }
    
    /// Genera datos de prueba (mock) en caso de que no existan productos.
    func generateMockData(){
        productService.generateMockProducts(count: 5)
        loadAllProducts()
    }
    
    /// Agrega un nuevo producto a la base de datos y actualiza la lista.
    ///
    /// - Parameters:
    ///   - name: Nombre del producto.
    ///   - price: Precio del producto.
    ///   - available: Indica si el producto está disponible.
    ///   - presentation: Tipo de presentación del producto.
    ///   - baseUnit: Unidad de medida base del producto.
    ///   - image: Imagen asociada al producto, opcional.
    func addProduct(
        name: String,
        price: Double,
        available: Bool,
        presentation: PresentationEnum,
        baseUnit: BaseUnitEnum,
        image: Data?
    ){
        let newProduct = ProductModel(
            name: name,
            price: price,
            available: available,
            presentation: presentation,
            baseUnit: baseUnit,
            image: image
        )
        productService.createProduct(newProduct)
        loadAllProducts()
    }
    
    /// Edita un producto existente con nuevos valores y guarda los cambios.
    ///
    /// - Parameters:
    ///   - product: Producto a editar.
    ///   - name: Nuevo nombre del producto.
    ///   - price: Nuevo precio del producto.
    ///   - available: Nueva disponibilidad.
    ///   - presentation: Nueva presentación.
    ///   - baseUnit: Nueva unidad de medida base.
    ///   - image: Nueva imagen, opcional.
    func editProduct(
        product: ProductModel,
        name: String,
        price: Double,
        available: Bool,
        presentation: PresentationEnum,
        baseUnit: BaseUnitEnum,
        image: Data?
    ){
        product.name = name
        product.price = price
        product.available = available
        product.presentation = presentation
        product.baseUnit = baseUnit
        product.image = image
        
        productService.updateProduct()
        loadAllProducts()
    }
    
    /// Elimina un producto de la base de datos y actualiza la lista.
    ///
    /// - Parameter product: Producto que se desea eliminar.
    func removeProduct(product: ProductModel){
        productService.deleteProduct(product)
        loadAllProducts()
    }
}

// SUGERENCIA:
// Sería recomendable manejar errores de servicio (create/update/delete) desde el ViewModel
// para que puedas mostrar alertas o mensajes de error a los usuarios, en lugar de depender solo de prints en consola.
