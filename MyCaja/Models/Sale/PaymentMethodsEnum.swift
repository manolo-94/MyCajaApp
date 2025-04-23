//
//  PaymentMethodsEnum.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation

enum PaymentMethodsEnum: String, CaseIterable, Identifiable, Codable {
     
    case cash
    
    case card
    
    case transfer
    
    var id:String {self.rawValue}
    
    var description:String {
        switch self {
        case .card:
            return "Tarjeta"
        case .transfer:
            return "Transferencia"
        default:
            return "Efectivo"
        }
    }
}
