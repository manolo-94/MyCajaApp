//
//  SaleProductViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation

/// Mostrar productos disponibles par ventas
@MainActor
final class SaleProductViewModel: ObservableObject {
    
    @Published var availableProducts: [ProductModel] = []
    
    private let productService: ProductServiceProtocol
    
    init(productService: ProductServiceProtocol) {
        self.productService = productService
        loadAvailableProdcuts()
    }
    
    func loadAvailableProdcuts(){
        let allProduct = productService.fetchAllProducts()
        self.availableProducts = allProduct.filter {$0.available}
    }
}
