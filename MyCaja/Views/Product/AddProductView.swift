//
//  AddProduct.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import SwiftUI

struct AddProduct: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservableObject var viewModel: ProductViewModel
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var available: Bool = true
    @State private var presentation: PresentationEnum = .unidad
    @State private var baseUnit: BaseUnitEnum = .pieza
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Informacion del Producto")){
                    TextField("Nombre", text:$name)
                    TextField("Precio", text:$price).keyboardType(.decimalPad)
                    
                    Toggle("Diponible", isOn: $available)
                    
                    Picker("Presentacion", selection: $presentation){
                        ForEach(PresentationEnum.allCases, id: \.self){
                            type in Text(type.rawValue)
                        }
                    }
                    
                    Picker("Unidad de Medida", selection: $baseUnit){
                        ForEach(BaseUnitEnum.allCases, id: \.self){ unit in
                            Text(baseUnit.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Nuevo Producto")
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancelar"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading){
                    Button("Guardar"){
                        print("Producto Guardado")
                    }
                }
            }
        }
    }
}


