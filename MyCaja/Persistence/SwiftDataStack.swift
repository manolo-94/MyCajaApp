//
//  SwiftDataStack.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//

import SwiftData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: ModelContainer
    
    init(){
        do {
            container = try ModelContainer(for: ProductModel.self)
        } catch {
            fatalError("Error al inicializar SwiftData:\(error)")
        }
    }
}
