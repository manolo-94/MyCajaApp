//
//  ProductLsitView.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//

import SwiftUI
import SwiftData

struct ProductListView: View {
    
    // Access the context from the enviroment (inyection) acceso a swiftdata
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel: ProductViewModel
    
    @State private var showingAddProduct = false
    
    init(){
        _viewModel = StateObject(wrappedValue: ProductViewModel(context: SwiftDataStack.shared.container.mainContext))
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if viewModel.products.isEmpty {
                    Spacer()
                    Text("No hay productos disponibles.")
                        .font(.headline).foregroundStyle(Color.black)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing:16){
                            ForEach(viewModel.products){ product in ProductCardView(product: product)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Productos")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        showingAddProduct = true
                    }){
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProduct){
                AddProductView(viewModel: viewModel, isPresented: $showingAddProduct)
            }
            .onAppear{
                viewModel.loadAllProducts()
            }
        }
        
    }
}

#Preview {
    ProductListView()
}
