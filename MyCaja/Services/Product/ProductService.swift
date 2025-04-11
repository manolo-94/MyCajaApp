//
//  ProductService.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import SwiftData
import Foundation

/// Servicio responsable de gestionar operaciones CRUD para instancias de `ProductModel`.
///
/// Todas las operaciones se ejecutan en el hilo principal (`@MainActor`) para mantener la sincronización con la interfaz de usuario.
@MainActor
final class ProductService {
    
    /// Contexto de datos utilizado para realizar operaciones sobre el modelo.
    let context: ModelContext
    
    /// Inicializa el servicio con un contexto de datos específico.
    ///
    /// - Parameter context: Contexto de modelo proporcionado por SwiftData.
    init(context: ModelContext){
        self.context = context
    }
    
    /// Crea un nuevo producto en el contexto y guarda los cambios.
    ///
    /// - Parameter product: Instancia de `ProductModel` que se desea insertar.
    func createProduct(_ product: ProductModel) {
        context.insert(product)
        do {
            try context.save()
        } catch {
            // Se maneja el error de forma controlada, evitando el uso de fatalError en producción.
            print("Error al crear el producto: \(error.localizedDescription)")
        }
    }
    
    /// Guarda los cambios realizados en el contexto, típicamente después de actualizar un producto.
    func updateProduct(){
        do {
            try context.save()
        } catch {
            print("Error al actualizar el producto: \(error.localizedDescription)")
        }
    }
    
    /// Elimina un producto existente del contexto y guarda los cambios.
    ///
    /// - Parameter product: Instancia de `ProductModel` que se desea eliminar.
    func deleteProduct(_ product: ProductModel){
        context.delete(product)
        do {
            try context.save()
        } catch {
            print("Error al eliminar el producto: \(error.localizedDescription)")
        }
    }
    
    /// Recupera todos los productos almacenados en el contexto.
    ///
    /// - Returns: Un arreglo de instancias de `ProductModel`. Retorna un arreglo vacío en caso de error.
    func fetchAllProducts() -> [ProductModel] {
        let fetchDescriptor = FetchDescriptor<ProductModel>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    /// Genera productos de prueba (mock) y los inserta en el contexto.
    ///
    /// - Parameter count: Cantidad de productos a generar. Valor por defecto: `10`.
    ///
    /// ### Ejemplo de uso:
    /// ```swift
    /// productService.generateMockProducts(count: 5)
    /// ```
    func generateMockProducts(count: Int = 10) {
        for _ in 0..<count {
            let product = ProductModel(
                name: randomProductName(),
                price: Double.random(in: 1...10),
                available: Bool.random(),
                presentation: PresentationEnum.allCases.randomElement()!,
                baseUnit: BaseUnitEnum.allCases.randomElement()!,
                image: nil // Por ahora sin imagen
            )
            createProduct(product)
        }
    }
    
    /// Genera un nombre aleatorio de producto para los datos de prueba.
    ///
    /// - Returns: Una cadena de texto representando un nombre de producto.
    private func randomProductName() -> String {
        let names = ["Manzana", "Banana", "Carne", "Leche", "Pan", "Jugo", "Queso", "Arroz", "Tomate", "Café"]
        return names.randomElement() ?? "Producto Desconocido"
    }
}

// SUGERENCIA:
// - Se recomienda marcar `randomProductName` como `private` para evitar su acceso externo no intencionado.
// - Podrías manejar los errores con un sistema de logs más estructurado o un servicio de alertas si es un entorno de producción.


// SUGERENCIA:
// - Considerar el manejo de errores de manera más robusta, por ejemplo, mostrando alertas al usuario si las operaciones fallan.
// - En `generateMockProducts`, podrías hacer la creación de productos asincrónica si se generan muchos registros, para no bloquear la UI.

