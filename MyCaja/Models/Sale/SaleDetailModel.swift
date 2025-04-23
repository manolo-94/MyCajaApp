//
//  SaleDetailModel.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation
import SwiftData

@Model
class SaleDetailModel {
    
    @Attribute(.unique) var id: UUID
    
    var productId: UUID
    
    var productName: String
    
    var unitPrice: Double
    
    var quantity: Double
    
    var isBulk: Bool
    
    var subTotal: Double {
        if isBulk {
            return quantity
        } else {
            return quantity * unitPrice
        }
    }
    
    var date: Date
    
    init(
        id: UUID = UUID(),
        productId: UUID,
        productName: String,
        unitPrice: Double,
        quantity: Double,
        isBulk: Bool,
        date: Date = Date()
    ) {
        self.id = id
        self.productId = productId
        self.productName = productName
        self.unitPrice = unitPrice
        self.quantity = quantity
        self.isBulk = isBulk
        self.date = date
    }
    
}
