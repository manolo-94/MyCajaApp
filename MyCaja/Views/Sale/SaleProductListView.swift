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
    @State private var showModal = false
    
    var body: some View {
        VStack {
            Text("Selecciona Productos").font(.title.bold()).padding()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(saleProductViewModel.availableProducts, id: \.id) {
                        product in SaleProductCardView(product:product) {
                            //cartViewModel.addProduct(product, quantity: 1)
                            selectedProduct = product
                            //showModal = true
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(item: $selectedProduct) { product in
                
                    SaleQuantityInputView(product: product, onAdd: {
                        result in cartViewModel.addProduct(product, quantity: result)
                        //showModal = false
                        selectedProduct = nil
                    })
                
            }
        }
    }
}


