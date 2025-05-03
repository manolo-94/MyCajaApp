//
//  ProductSelectorView.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import SwiftUI
import SwiftData

struct SaleProductListView: View {
    
    @ObservedObject var saleProductViewModel: SaleProductViewModel
    @ObservedObject var cartViewModel: CartViewModel
    
    @State private var selectedProduct: ProductModel?
    
    // MARK: - Dynamic grid layout
    var adaptiveColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 160), spacing: 16)]
    }
    
    var body: some View {
        VStack {
            Text("Selecciona Productos")
                .font(.title.bold())
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                    ForEach(saleProductViewModel.availableProducts, id: \.id) { product in
                        SaleProductCardView(product: product) {
                            selectedProduct = product
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(item: $selectedProduct) { product in
            SaleQuantityInputView(product: product) { quantity in
                cartViewModel.addProduct(product, quantity: quantity)
                selectedProduct = nil
            }
        }
    }
}

