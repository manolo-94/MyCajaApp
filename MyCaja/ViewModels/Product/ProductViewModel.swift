//
//  ProductViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import Foundation
import SwiftData

@MainActor
final class ProductViewModel: ObservableObject {
    
    private let productService: ProductService
    
    @Published var products: [ProductModel] = []
    
    init(context: ModelContext){
        self.productService = ProductService(context: context)
        loadAllProducts()
        
        // Solo crear productos falsos si no aht productos guardados
        if products.isEmpty {
            generateMockData()
        }
        
    }
    
    func loadAllProducts(){
        products = productService.fetchAllProducts()
    }
    
    func generateMockData(){
        productService.generateMockProducts(count: 5)
        loadAllProducts()
    }
    
    
    func addProduct(name: String, price: Double, available: Bool, presentation: PresentationEnum, baseUnit: BaseUnitEnum, image: Data?){
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
    
    func editProduct(product: ProductModel, name: String, price: Double, available: Bool, presentation: PresentationEnum, baseUnit: BaseUnitEnum, image: Data?){
        product.name = name
        product.price = price
        product.available = available
        product.presentation = presentation
        product.baseUnit = baseUnit
        product.image = image
        
        productService.updateProduct()
        loadAllProducts()
    }
    
    func removeProduct(product: ProductModel){
        productService.deleteProduct(product)
        loadAllProducts()
    }
    
}

