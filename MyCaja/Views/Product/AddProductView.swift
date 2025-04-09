//
//  AddProduct.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    //@Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductViewModel
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var available: Bool = true
    @State private var presentation: PresentationEnum = .unidad
    @State private var baseUnit: BaseUnitEnum = .pieza
    @State private var image: Data? = nil
    
    @State private var showAlert = false
    @State private var showSuccessAlert =  false
    @State private var alertMessage = ""
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var shoeError = false
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedAsset: PhotosPickerItem? = nil
    
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
                            Text(unit.rawValue)
                        }
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Seleccionar imagen")
                    }
                    .onChange(of: selectedItem) { oldItem, newItem in
                        if let newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    self.image = data
                                }
                            }
                        }
                    }

                    if let image, let uiImage = UIImage(data: image){
                        Image(uiImage: uiImage).resizable().scaledToFit().frame(width:100, height:100).clipShape(RoundedRectangle(cornerRadius:10)).frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Nuevo Producto")
            /*
             .alert("Error", isPresented: $showAlert){
             Button("Ok", role: .cancel){}
             } message: {
             Text(alertMessage)
             }
             .alert("Guardado exitosamente!", isPresented: $showSuccessAlert){
             Button("Ok"){
             isPresented = false
             }
             }
             */
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancelar"){
                        //dismiss()
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button(action:{
                        saveProduct()
                    }){
                        Text("Guardar")
                    }
                    .disabled(name.isEmpty || price.isEmpty)
                }
            }
            // --- Toast View ---
            if showToast {
                VStack{
                    Spacer()
                    HStack{
                        Text(toastMessage).foregroundStyle(Color.white)
                            .padding()
                            .background(shoeError ? Color.red : Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.5), value: showToast)
                }
            }
        }
    }

    
    private func saveProduct(){
        guard !name.isEmpty else {
            //alertMessage = "Por favor ingrese un precio válido"
            //showAlert = true
            showTemporaryToast(message: "Por favor complete todos los campos", isError: true)
            return
        }
        
        guard let priceValue = Double(price) else {
            //alertMessage = "Por favor ingrese un precio válido"
            //showAlert = true
            showTemporaryToast(message: "Por favor ingrese un valor numerico en precio", isError: true)
            return
        }
        
        viewModel.addProduct(
            name: name,
            price: priceValue,
            available: available,
            presentation: presentation,
            baseUnit: baseUnit,
            image: image
        )
        //print("Producto Guardado")
        //dismiss()
        //isPresented = false
        //showSuccessAlert = true
        showTemporaryToast(message: "Producto creado con exito!", isError: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            isPresented = false
        }
    }
    
    private func showTemporaryToast(message: String, isError: Bool){
        
        toastMessage = message
        shoeError = isError
        withAnimation{
            showToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            withAnimation{
                showToast = false
            }
        }
    }
}


