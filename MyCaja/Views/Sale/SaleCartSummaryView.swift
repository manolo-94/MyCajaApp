//
//  CartSummaryView.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import SwiftUI

struct SaleCartSummaryView: View {
    
    @ObservedObject var cartViewModel: CartViewModel

    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Carrito").font(.title.bold()).padding()
            
            List{
                ForEach(cartViewModel.carItems, id: \.id) { item in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading){
                            Text(item.productName).font(.headline)
                            Spacer()
                            
                            Text("Cantidad: \(item.quantity, specifier: "%.0f")")
                            
                            Text("Subtotal: \(item.subTotal, specifier: "%.2f")")
                        }
                        
                        Spacer()
                        
                        HStack(spacing:12) {
                            Button(action: {
                                // Logica para editar
                                cartViewModel.startEditing(item: item)
                            }) {
                                Image(systemName: "pencil").padding(10)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .contentShape(Rectangle()) // Esto mejora la detección táctil
                            .buttonStyle(PlainButtonStyle()) // Para evitar efectos visuales extraños
                            
                            Button(action: {
                                cartViewModel.removeItem(item)
                            }) {
                                Image(systemName: "trash").foregroundStyle(Color.red).padding(10)
                                    .background(Color.red.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            //.padding(.trailing, 8)
                            .contentShape(Rectangle())
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            
            Divider()
            HStack {
                Text("Total:").font(.headline)
                Spacer()
                Text("$\(cartViewModel.calculateTotal(), specifier: "%.2f")")
            }
            .font(.headline)
            
            HStack {
                Button("Cancelar") {
                    cartViewModel.clearCart()
                }
                .foregroundStyle(Color.red)
                
                Spacer()
                
                Button("Pagar") {
                    //cartViewModel.registerSale()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $cartViewModel.showEditSheet){
            if let item = cartViewModel.itemBeingEdited {
                EditSaleProductCartView(
                    item: item,
                    onAdd: { newQuantityOrPrice in cartViewModel.editProduct(item: item, with: newQuantityOrPrice)
                        cartViewModel.showEditSheet = false
                    }
                )
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


