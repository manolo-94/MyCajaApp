//
//  SwiftDataStack.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//
// Manejador de Base de Datos

import SwiftData

@MainActor
final class SwiftDataStack {
    @MainActor static let shared = SwiftDataStack()
    
    let container: ModelContainer
    
    private init(){
        let schema = Schema([
            ProductModel.self
            // SaleModel
            // UserModel
            // Agregamos aquí todos los modelos
        ])
        
        let configuartion = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            container = try ModelContainer( for: schema, configurations: [configuartion])
            
        } catch {
            fatalError("Error al inicializar SwiftData:\(error)")
        }
    }
}
