//
//  SwiftDataStack.swift
//  MyCaja
//
//  Created by MacBook Air on 05/04/25.
//
/// La clase SwiftDataStack configura y maneja la base de datos de la aplicación utilizando SwiftData.
import SwiftData

/// Se asegura de que las interacciones con esta clase se realicen en el hilo principal. Esto es importante porque muchas operaciones de UI deben ejecutarse en el hilo principal.
@MainActor
final class SwiftDataStack {
    
    /// Implementa el patrón de diseño Singleton, lo que significa que solo existe una instancia de SwiftDataStack en toda la aplicación, accesible globalmente mediante SwiftDataStack.shared.
    @MainActor static let shared = SwiftDataStack()
    
    let container: ModelContainer
    
    private init(){
        // Definición del esquema de la base de datos.
        let schema = Schema([
            ProductModel.self,
            SaleModel.self,
            SaleDetailModel.self,
            // SaleModel
            // UserModel
            // Agregamos aquí todos los modelos que se utilizarán en la base de datos.
        ])
        
        // Configuración del contenedor del modelo con el esquema y configuración.
        let configuartion = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            // Intentar inicializar el contenedor del modelo con la configuración definida.
            container = try ModelContainer(for: schema, configurations: [configuartion])
        } catch {
            // Si ocurre un error, la aplicación se detendrá y mostrará el error.
            fatalError("Error al inicializar SwiftData: \(error)")
        }
    }
}
