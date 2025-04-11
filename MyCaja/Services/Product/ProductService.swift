//
//  ProductService.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import SwiftData
import Foundation

@MainActor
final class ProductService {
    
    let context: ModelContext
    
    init(context: ModelContext){
        self.context = context
    }
    
    func createProduct(_ product: ProductModel) {
        context.insert(product)
        do {
            try context.save()
        } catch {
            //fatalError(error.localizedDescription)
            print("Error al crear el producto: \(error.localizedDescription)")
        }
        
    }
    
    func updateProduct(){
        do {
            try context.save()
        } catch {
            print("Error al actualizar el producto: \(error.localizedDescription)")
        }
    }
    
    func deleteProduct(_ product: ProductModel){
        context.delete(product)
        do {
            try context.save()
        } catch {
            print("Error al eliminar el producto: \(error.localizedDescription)")
        }
    }
    
    func fetchAllProducts() -> [ProductModel]{
        let fetchDescriptor = FetchDescriptor<ProductModel>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    func generateMockProducts(count: Int = 10){
        for _ in 0..<count {
            let product = ProductModel(
                name: ramdomProductName(),
                price: Double.random(in: 1...10),
                available: Bool.random(),
                presentation: PresentationEnum.allCases.randomElement()!,
                baseUnit: BaseUnitEnum.allCases.randomElement()!,
                image: nil // Por ahora sin imagen
            )
            createProduct(product)
        }
    }
    
    func ramdomProductName() -> String{
        let name = ["Manzana", "Banana", "Carne", "Leche", "Pan", "Jugo", "Queso", "Arroz", "Tomate", "Café"]
        return name.randomElement() ?? "Product"
    }
    
}
