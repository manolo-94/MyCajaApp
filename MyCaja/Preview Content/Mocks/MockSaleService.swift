//
//  MockSaleService.swift
//  MyCaja
//
//  Created by MacBook Air on 22/09/25.
//

import Foundation

class MockSaleService: SaleServiceProtocol{
    
    func fetchAllSales() -> [SaleModel] {
        print("Recuperamos todas las ventas")
        return []
    }
    
    func saveSale(_ sale: SaleModel) throws {
        print("Recuperamos todas las ventas")
    }
    
    func updateSaleStatus(sale: SaleModel, newStatus: SaleStatusEnum) {
        print("Actualizamos el estado de la venta")
    }
    
    
}
