//
//  CartSummaryView.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import SwiftUI

struct SaleCartSummaryView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss

    
    @ObservedObject var cartViewModel: CartViewModel
    
    @State private var selectedPaymentMethod: PaymentMethodsEnum = .cash
    @State private var showingPaymentSheet = false
    @State private var amountPaid = ""
    
    @State private var localToast: ToastModel? = nil
    
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
                    
                    if horizontalSizeClass == .compact {
                        dismiss()// Solo cerramos la vista si es iPhone (modo compacto)
                    }
                }
                .foregroundStyle(Color.red)
                
                Spacer()
                
                Button("Pagar") {
                    //cartViewModel.registerSale()
                    showingPaymentSheet = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(cartViewModel.carItems.isEmpty)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Regresar")
                    }
                }
            }
        }
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
        .sheet(isPresented: $showingPaymentSheet) {
            SalePaymentView(
                total: cartViewModel.calculateTotal(),
                selectedPaymentMethod: $selectedPaymentMethod,
                amountPaid: $amountPaid,
                onConfirm: { amount in
                    do {
                        let _ = try cartViewModel.registerSale(
                            details: cartViewModel.carItems,
                            method: selectedPaymentMethod,
                            amountPaid: amount
                        )
                        showingPaymentSheet = false
                        amountPaid = ""
                    } catch {
                        print("Error al registrar la venta: \(error.localizedDescription)")
                        localToast = ToastModel(message: error.localizedDescription, type: .error)
                        
                    }
                },
                onCancel: {
                    showingPaymentSheet = false
                }
            )
            // Este toast se usa para mostrar un mensaje en la vista SalePaymentView
            if let toast = localToast {
                ToastView(toast: toast)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                localToast = nil
                            }
                        }
                    }
            }
        }

        .overlay(
            Group {
                // validamos el tipo de pantalla para poder mostrar el toast en el SaleCartSummaryView cuando esta en dispositivos iPhone.
                if horizontalSizeClass == .compact, let toast = cartViewModel.toast {
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

