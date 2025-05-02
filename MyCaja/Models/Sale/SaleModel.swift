//
//  SaleModel.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation
import SwiftData

@Model
class SaleModel {
    @Attribute(.unique) var id: UUID
    
    var date: Date
    
    var paymentMethod: PaymentMethodsEnum
    
    var status: SaleStatusEnum
    
    var total: Double
    
    var amountPaid: Double
    
    var change: Double
    
    var details: [SaleDetailModel]
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        paymentMethod: PaymentMethodsEnum,
        status: SaleStatusEnum,
        total: Double,
        amountPaid: Double,
        change: Double,
        details: [SaleDetailModel]
    ) {
        self.id = id
        self.date = date
        self.paymentMethod = paymentMethod
        self.status = status
        self.total = total
        self.amountPaid = amountPaid
        self.change = change
        self.details = details
    }
}
