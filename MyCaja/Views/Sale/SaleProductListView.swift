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
                            showModal = true
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $showModal) {
                if let product = selectedProduct {
                    SaleQuantityInputView(product: product, onAdd: {
                        result in cartViewModel.addProduct(product, quantity: result)
                        showModal = false
                    })
                }
            }
        }
        .overlay(
            Group {
                if let toast = cartViewModel.toast {
                    ToastView(toast: toast)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    cartViewModel.toast = nil
                                }
                            }
                        }
                }
            },
            alignment: .top
        )
    }
}


