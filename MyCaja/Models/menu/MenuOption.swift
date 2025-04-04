//
//  MenuOption.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//
/// Enum que representa las diferentes pantallas disponibles en el menú lateral.

import SwiftUI

enum MenuOption: String, CaseIterable {
    case home = "Inicio"
    case product = "Productos"
    case sale = "Nueva Venta"
    case salesHistory = "Historial de Ventas"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .product: return "cart"
        case .sale: return "dollarsign.circle"
        case .salesHistory: return "list.bullet"
        }
    }
    
}
