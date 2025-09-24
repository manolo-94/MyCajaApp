//
//  CartViewModel+Preview.swift
//  MyCaja
//
//  Created by MacBook Air on 22/09/25.
//

import Foundation

extension CartViewModel {
    static var empety: CartViewModel {
        let mockService = MockSaleService()
        let vm  = CartViewModel(saleService: mockService)
        return vm
    }
    
    static var full: CartViewModel {
        let mockService = MockSaleService()
        let vm = CartViewModel(saleService: mockService)
        vm.addProduct(ProductModel.sample1, quantity: 2, enteredPrice: 16000)
        return vm
    }
}
