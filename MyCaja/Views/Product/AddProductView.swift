//
//  AddProduct.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import SwiftUI
import PhotosUI

/// Vista para agregar un nuevo producto a la aplicación.
struct AddProductView: View {
    
    //@Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductAdminViewModel  // ViewModel que maneja la lógica para agregar productos.
    @Binding var isPresented: Bool  // Binding para controlar si la vista de agregar producto está activa o no.
    
    // Estado para almacenar la información del nuevo producto.
    @State private var name: String = ""  // Nombre del producto.
    @State private var price: String = ""  // Precio del producto (como texto para validación antes de convertir a número).
    @State private var available: Bool = true  // Disponibilidad del producto.
    @State private var presentation: PresentationEnum = .unidad  // Presentación del producto.
    @State private var baseUnit: BaseUnitEnum = .pieza  // Unidad base del producto.
    @State private var image: Data? = nil  // Imagen del producto (opcional).
    
    // Estado para manejar alertas y mensajes temporales.
    @State private var showAlert = false  // Bandera para mostrar la alerta.
    @State private var showSuccessAlert =  false  // Bandera para mostrar la alerta de éxito.
    @State private var alertMessage = ""  // Mensaje de alerta.
    
    @State private var showToast = false  // Bandera para mostrar el mensaje de "toast".
    @State private var toastMessage = ""  // Mensaje del toast.
    @State private var showError = false  // Bandera para determinar si el toast es un mensaje de error.
    
    @State private var selectedItem: PhotosPickerItem? = nil  // Elemento seleccionado para la imagen del producto.
    @State private var selectedAsset: PhotosPickerItem? = nil  // Otro estado para manejar activos seleccionados en la librería de fotos.
    
    @State private var showSaveAlert: Bool = false  // Bandera para mostrar la alerta de confirmación para guardar el producto.
    
    var body: some View {
        NavigationStack {
            // Contenedor de formulario para capturar los datos del producto.
            Form {
                Section(header: Text("Informacion del Producto")) {
                    // Campo para ingresar el nombre del producto.
                    TextField("Nombre", text: $name)
                    
                    // Campo para ingresar el precio, usando teclado numérico.
                    TextField("Precio", text: $price).keyboardType(.decimalPad)
                    
                    // Toggle para indicar si el producto está disponible o no.
                    Toggle("Diponible", isOn: $available)
                    
                    // Picker para seleccionar la presentación del producto.
                    Picker("Presentacion", selection: $presentation) {
                        ForEach(PresentationEnum.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    
                    // Picker para seleccionar la unidad de medida del producto.
                    Picker("Unidad de Medida", selection: $baseUnit) {
                        ForEach(BaseUnitEnum.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    
                    // Picker de fotos para seleccionar una imagen para el producto.
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Seleccionar imagen")
                    }
                    .onChange(of: selectedItem) { oldItem, newItem in
                        // Cargar la imagen seleccionada en formato Data.
                        if let newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    self.image = data
                                }
                            }
                        }
                    }
                    
                    // Mostrar la imagen seleccionada en la interfaz, si está disponible.
                    if let image, let uiImage = UIImage(data: image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Nuevo Producto")  // Título de la vista.
            
            // Barra de herramientas para los botones de la vista.
            .toolbar {
                // Botón para cancelar la operación y cerrar la vista.
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        //dismiss()
                        isPresented = false  // Establecer el Binding a false para cerrar la vista.
                    }
                }
                
                // Botón para guardar el producto.
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSaveAlert = true  // Mostrar alerta de confirmación antes de guardar.
                    }) {
                        Text("Guardar")
                    }
                    .disabled(name.isEmpty || price.isEmpty)  // Deshabilitar el botón si el nombre o el precio están vacíos.
                }
            }
            
            // Alerta de confirmación para guardar el producto.
            .alert("Nuevo Producto", isPresented: $showSaveAlert) {
                Button("Cancelar", role: .cancel) {}  // Botón de cancelar.
                Button("Guardar", role: .destructive) {
                    saveProduct()  // Llamar a la función para guardar el producto.
                }
            } message: {
                Text("¿Está seguro de crear un nuevo producto?")  // Mensaje de la alerta.
            }
            
            // Vista de "toast" para mostrar mensajes temporales (como confirmaciones o errores).
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Text(toastMessage)
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(showError ? Color.red : Color.green)  // Color verde para éxito, rojo para error.
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

    
    /// Función para guardar el producto nuevo después de validar los datos.
    private func saveProduct() {
        // Validación: Asegurarse de que el nombre y precio no estén vacíos.
        guard !name.isEmpty || !price.isEmpty else {
            showTemporaryToast(message: "Por favor complete todos los campos", isError: true)
            return
        }
        
        // Validación: Asegurarse de que el precio sea un número válido.
        guard let priceValue = Double(price) else {
            showTemporaryToast(message: "Por favor ingrese un valor numérico en precio", isError: true)
            return
        }
        
        // Llamada al ViewModel para agregar el producto.
        viewModel.addProduct(
            name: name,
            price: priceValue,
            available: available,
            presentation: presentation,
            baseUnit: baseUnit,
            image: image
        )
        
        // Mostrar mensaje de éxito con "toast".
        showTemporaryToast(message: "Producto creado con éxito!", isError: false)
        
        // Cerrar la vista después de un breve retraso.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPresented = false  // Cerrar la vista.
        }
    }
    
    /// Función para mostrar un mensaje "toast" temporal con un mensaje y color específico (error o éxito).
    private func showTemporaryToast(message: String, isError: Bool) {
        toastMessage = message  // Establecer el mensaje del toast.
        showError = isError  // Establecer si es un error o éxito.
        withAnimation {
            showToast = true  // Mostrar el toast con animación.
        }
        
        // Ocultar el toast después de 2 segundos.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false  // Ocultar el toast.
            }
        }
    }
}
