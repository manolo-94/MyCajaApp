//
//  SaleQuantityInputView.swift
//  MyCaja
//
//  Created by MacBook Air on 19/04/25.
//

import SwiftUI

struct SaleQuantityInputView: View {
    @Environment(\.dismiss) var dismiss
    
    let product: ProductModel
    var onAdd: (Double) -> Void // puede ser cantidad (unit) o monto (bulk)
    
   @State private var inputText = ""
   @State private var calculatedSubtotal: Double = 0.0
    
    @FocusState private var isInputFocused: Bool
    
    var inputLabel: String {
        product.presentation == .granel ? "Monto en pesos" : "Cantidad"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("\(product.name)")) {
                    TextField(inputLabel, text: $inputText).keyboardType(.decimalPad)
                        .focused($isInputFocused)
                        .onChange(of: inputText) {
                        
                        let value = Double(inputText)
                        calculatedSubtotal = product.price * (value ?? 0)
                    }
                    
                    if product.presentation != .granel {
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
            .navigationTitle("Agregar Prodcuto")
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
                    Button("Agregar al carrito") {
                        if let value = Double(inputText), value > 0 {
                            onAdd(value)
                        }
                    }
                    .disabled(inputText.isEmpty)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isInputFocused = true
                }
            }
            
        }
    }
}


