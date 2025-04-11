//
//  ProductListView.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//

import SwiftUI
import SwiftData

/// Vista principal que muestra la lista de productos disponibles.
/// Permite agregar nuevos productos o editar los existentes.
struct ProductListView: View {
    
    /// Contexto de modelo de SwiftData inyectado desde el entorno.
    @Environment(\.modelContext) private var context
    
    /// ViewModel que gestiona la lógica de productos.
    @StateObject private var viewModel: ProductViewModel
    
    /// Controla la presentación de la vista para agregar un nuevo producto.
    @State private var showingAddProduct = false
    
    /// Producto seleccionado para editar.
    @State private var selectedProduct: ProductModel? = nil
    
    /// Inicializador que crea el ViewModel utilizando el contexto principal de SwiftData.
    init(){
        _viewModel = StateObject(wrappedValue: ProductViewModel(context: SwiftDataStack.shared.container.mainContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Si no hay productos, muestra un mensaje indicativo.
                if viewModel.products.isEmpty {
                    Spacer()
                    Text("No hay productos disponibles.")
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    Spacer()
                } else {
                    // Si hay productos, se muestra una lista scrollable.
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Se itera sobre los productos y se crea una tarjeta para cada uno.
                            ForEach(viewModel.products) { product in
                                ProductCardView(product: product)
                                    .onTapGesture {
                                        // Al hacer clic en un producto, se selecciona para editar.
                                        selectedProduct = product
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            // Configura la vista para que ocupe todo el espacio disponible.
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Productos") // Título de la navegación.
            .toolbar {
                // Botón en la barra de herramientas para agregar un nuevo producto.
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Al hacer clic, se muestra la vista para agregar un nuevo producto.
                        showingAddProduct = true
                    }) {
                        Image(systemName: "plus") // Icono de "+" para agregar.
                    }
                }
            }
            // Hoja para agregar un producto cuando se active la variable `showingAddProduct`.
            .sheet(isPresented: $showingAddProduct) {
                AddProductView(viewModel: viewModel, isPresented: $showingAddProduct)
            }
            // Hoja para editar el producto seleccionado.
            .sheet(item: $selectedProduct) { product in
                EditProductView(product: product, viewModel: viewModel)
            }
        }
    }
}
