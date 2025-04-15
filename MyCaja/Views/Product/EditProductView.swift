//
//  EditProductView.swift
//  MyCaja
//
//  Created by MacBook Air on 09/04/25.
//

import SwiftUI
import PhotosUI

/// Vista para editar un producto existente.
struct EditProductView: View {
    @Environment(\.dismiss) var dismiss  // Permite cerrar la vista
    @ObservedObject var viewModel: ProductAdminViewModel  // Vista Modelo de Producto
    
    var product: ProductModel  // Producto a editar
    @State private var name: String  // Nombre del producto
    @State private var price: String  // Precio del producto
    @State private var available: Bool  // Disponibilidad del producto
    @State private var presentation: PresentationEnum  // Presentación del producto
    @State private var baseUnit: BaseUnitEnum  // Unidad base de medida
    @State private var image: Data?  // Imagen del producto
    
    @State private var selectedItem: PhotosPickerItem? = nil  // Elemento seleccionado de la galería de fotos
    
    @State private var showToast: Bool = false  // Estado de la visualización del mensaje Toast
    @State private var toastMessage: String = ""  // Mensaje del Toast
    @State private var showError: Bool = false  // Indicador de error en el Toast
    
    @State private var showSaveAlert: Bool = false  // Estado para mostrar la alerta de guardar cambios
    @State private var showDeleteAlert: Bool = false  // Estado para mostrar la alerta de eliminar producto
    
    /// Inicializa la vista de edición con un producto existente.
    init (product: ProductModel, viewModel: ProductAdminViewModel){
        self.product = product
        self.viewModel = viewModel
        
        // Inicialización de las variables de estado con los valores del producto
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
                    
                    // Campo para editar el nombre del producto
                    TextField("Nombre", text: $name)
                    
                    // Campo para editar el precio del producto, con teclado numérico
                    TextField("Precio", text: $price).keyboardType(.decimalPad)
                    
                    Toggle("Disponible", isOn: $available)
                    
                    // Selector para elegir la presentación del producto
                    Picker("Presentación", selection: $presentation){
                        ForEach(PresentationEnum.allCases, id: \.self){
                            type in Text(type.rawValue)
                        }
                    }
                    
                    // Selector para elegir la unidad base de medida del producto
                    Picker("Unidad de Medida", selection: $baseUnit){
                        ForEach(BaseUnitEnum.allCases, id: \.self){ unit in
                            Text(unit.rawValue)
                        }
                    }
                    
                    // Selector de imágenes desde la galería de fotos
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

                    // Muestra la imagen seleccionada si está disponible
                    if let image, let uiImage = UIImage(data: image){
                        Image(uiImage: uiImage).resizable().scaledToFit().frame(width:100, height:100).clipShape(RoundedRectangle(cornerRadius:10)).frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                }
            }
            
            // Vista de Toast (mensaje emergente)
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
            
            // Botón para eliminar el producto
            Button(role: .destructive){
                showDeleteAlert = true
            } label: {
                Label("Eliminar Producto", systemImage: "trash").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent).tint(.red).padding()
            
            .navigationTitle("Editar Producto")
            .toolbar{
                // Botón para cancelar la edición
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()  // Cierra la vista actual
                    }
                }
                // Botón para guardar los cambios realizados en el producto
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSaveAlert = true  // Muestra la alerta de confirmación de guardado
                    }){
                        Text("Guardar")
                    }
                }
            }
            
            // Alerta de confirmación para guardar los cambios
            .alert("¿Guardar Cambios?", isPresented: $showSaveAlert){
                Button("Cancelar", role: .cancel) {}
                Button("Guardar", role: .destructive) {
                    editProduct()  // Guarda los cambios
                }
            } message: {
                Text("¿Estás seguro que quieres guardar los cambios en este producto?")
            }
            
            // Alerta de confirmación para eliminar el producto
            .alert("¿Eliminar Producto?", isPresented: $showDeleteAlert){
                Button("Cancelar", role: .cancel) {}
                Button("Eliminar", role: .destructive) {
                    deleteProduct()  // Elimina el producto
                }
            } message: {
                Text("¿Estás seguro que quieres eliminar este producto? Esta acción no se puede deshacer.")
            }
        }
    }
    
    /// Función para guardar los cambios realizados en el producto.
    private func editProduct(){
        
        // Verifica que los campos requeridos no estén vacíos
        guard !name.isEmpty || !price.isEmpty else {
            showTemporaryToast(message: "Por favor complete todos los campos", isError: true)
            return
        }
        
        // Verifica que el precio sea un valor numérico válido
        guard let priceValue = Double(price) else {
            showTemporaryToast(message: "Por favor ingrese un valor numérico en precio", isError: true)
            return
        }
        
        // Llama al método para actualizar el producto
        viewModel.editProduct(
            product: product,
            name: name,
            price: priceValue,
            available: available,
            presentation: presentation,
            baseUnit: baseUnit,
            image: image
        )
        
        // Muestra un mensaje de éxito
        showTemporaryToast(message: "Producto actualizado con éxito!", isError: false)
        
        // Cierra la vista después de un breve retraso
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            dismiss()
        }
        print("Producto Actualizado")
    }
    
    /// Función para eliminar el producto.
    private func deleteProduct(){
        viewModel.removeProduct(product)
        dismiss()  // Cierra la vista
        print("Producto Eliminado")
    }
    
    /// Función para mostrar un mensaje Toast temporal.
    private func showTemporaryToast(message: String, isError: Bool){
        toastMessage = message
        showError = isError
        
        withAnimation{
            showToast = true  // Muestra el Toast con animación
        }
        
        // Oculta el Toast después de un breve retraso
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            withAnimation{
                showToast = false  // Oculta el Toast
            }
        }
    }
}
