//
//  SaleServiceProtocol.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation

@MainActor
protocol SaleServiceProtocol {
    func fetchAllSales() -> [SaleModel]
    func saveSale(_ sale: SaleModel) throws
    func updateSaleStatus(sale: SaleModel, newStatus: SaleStatusEnum)
    
}
