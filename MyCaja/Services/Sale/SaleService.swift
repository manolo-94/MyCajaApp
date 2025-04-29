//
//  SaleService.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation
import SwiftData

@MainActor
class SaleService: SaleServiceProtocol {
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // Funcion para obtener todas las ventas
    func fetchAllSales() -> [SaleModel] {
        print("Recuperamos todas las ventas")
        let fetchDescriptor = FetchDescriptor<SaleModel>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    // Funcion para guardar una venta en la base de datos
    func saveSale(_ sale: SaleModel) {
        context.insert(sale)
        do {
            try context.save()
            print("Venta Guarda")
        } catch {
            // Se maneja el error de forma controlada, evitando el uso de fatalError en producción.
            print("Error al guardar la venta: \(error.localizedDescription)")
        }
    }
    
    // Funcion para actualizar el estado de una venta
    func updateSaleStatus(sale: SaleModel, newStatus: SaleStatusEnum) {
        print("Actualizamos el estado de la venta")
    }
    
    
}
