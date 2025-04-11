//
//  EditProductView.swift
//  MyCaja
//
//  Created by MacBook Air on 09/04/25.
//

import SwiftUI
import PhotosUI

struct EditProductView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductViewModel
    
    var product: ProductModel
    @State private var name: String
    @State private var price: String
    @State private var available: Bool
    @State private var presentation: PresentationEnum
    @State private var baseUnit: BaseUnitEnum
    @State private var image: Data?
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var showError: Bool = false
    
    @State private var showSaveAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    init (product: ProductModel, viewModel: ProductViewModel){
        self.product = product
        self.viewModel = viewModel
        
        _name = State(initialValue: product.name)
        _price = State(initialValue: String(product.price))
        _available = State(initialValue: product.available)
        _presentation = State(initialValue: product.presentation)
        _baseUnit = State(initialValue: product.baseUnit)
        _image = State(initialValue: product.image)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Información del Producto")) {
                    
                    TextField("Nombre", text: $name)
                    
                    TextField("Price", text: $price).keyboardType(.decimalPad)
                    
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
            
            // Toast View
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Text(toastMessage).foregroundStyle(Color.white).padding().background(showError ? Color.red : Color.green).cornerRadius(12).shadow(radius: 10)
                    }
                    .padding(.bottom, 30).transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.5), value: showToast)
                }
            }
            
            Spacer()
            
            Button(role: .destructive){
                showDeleteAlert = true
            } label: {
                Label("Eliminar Producto", systemImage: "trash").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent).tint(.red).padding()
            
            .navigationTitle("Editar Producto")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        //editProduct()
                        showSaveAlert = true
                    }){
                        Text("Guardar")
                    }
                }
            }
            
            .alert("¿Guardar Cambios?", isPresented: $showSaveAlert){
                Button("Cancelar", role: .cancel) {}
                Button("Guardar", role: .destructive) {
                    editProduct()
                }
            } message: {
                Text("¿Estás seguro que quieres guardar los cambios en este producto?")
            }
            
            .alert("¿Eliminar Producto?", isPresented: $showDeleteAlert){
                Button("Cancelar", role: .cancel) {}
                Button("Eliminar", role: .destructive) {
                    deleteProduct()
                }
            } message: {
                Text("¿Estás seguro que quieres eliminar este producto? Esta acción no se puede deshacer.")
            }
        }
    }
    
    private func editProduct(){
        
        guard !name.isEmpty || !price.isEmpty else {
            showTemporaryToast(message: "Por favor complete todos los campos", isError: true)
            return
        }
        
        guard let PriceValue = Double(price) else {
            showTemporaryToast(message: "Por favor ingrese un valor numerico en precio", isError: true)
            return
        }
        
        viewModel.editProduct(
            product: product,
            name: name,
            price: PriceValue,
            available: available,
            presentation: presentation,
            baseUnit: baseUnit,
            image: image
        )
        
        showTemporaryToast(message: "Producto creado con exito!", isError: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            dismiss()
        }
        print("Producto Actualizado")
    }
    
    private func deleteProduct(){
        viewModel.removeProduct(product: product)
        dismiss()
        print("Producto Eliminado")
    }
    
    private func showTemporaryToast(message: String, isError: Bool){
        toastMessage = message
        showError = isError
        
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


