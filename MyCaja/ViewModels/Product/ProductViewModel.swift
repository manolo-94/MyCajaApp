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
    
    func loadAllProducts(){
        products = productService.fetchAllProducts()
    }
    
    func generateMockData(){
        productService.generateMockProducts(count: 5)
        loadAllProducts()
    }
    
    
}

