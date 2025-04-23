//
//  EditSaleProductCartView.swift
//  MyCaja
//
//  Created by MacBook Air on 21/04/25.
//

import SwiftUI

struct EditSaleProductCartView: View {
    @Environment(\.dismiss) var dismiss
    
    let item: SaleDetailModel
    var onAdd: (Double) -> Void // puede ser cantidad (unit) o monto (bulk)
    
   @State private var inputText = ""
   @State private var calculatedSubtotal: Double = 0.0
    
    var inputLabel: String {
        item.isBulk ? "Monto en pesos" : "Cantidad"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("\(item.productName)")) {
                    TextField(inputLabel, text: $inputText).keyboardType(.decimalPad).onChange(of: inputText) {
                        
                        let value = Double(inputText)
                        calculatedSubtotal = item.unitPrice * (value ?? 0)
                    }
                    
                    if  !item.isBulk {
                        Text("Subtotal: $\(calculatedSubtotal, specifier: "%.2f")")
                    }
                    
                }
                
                /*Section {
                    Button("Agregar al carrito") {
                        if let value = Double(inputText), value > 0 {
                            onAdd(value)
                        }
                    }
                }*/
            }
            .navigationTitle("Editar Prodcuto")
            //.navigationBarTitleDisplayMode(.inline)
            // Barra de herramientas para los botones de la vista.
            .toolbar {
                // Botón para cancelar la operación y cerrar la vista.
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                // Botón para guardar el producto.
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardar") {
                        if let value = Double(inputText), value > 0 {
                            onAdd(value)
                        }
                    }
                    .disabled(inputText.isEmpty)
                }
            }
            
        }
    }
}

