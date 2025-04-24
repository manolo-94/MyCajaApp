//
//  CartSummaryView.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import SwiftUI

struct SaleCartSummaryView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                }
                .foregroundStyle(Color.red)
                
                Spacer()
                
                Button("Pagar") {
                    //cartViewModel.registerSale()
                    showingPaymentSheet = true
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
        .sheet(isPresented: $showingPaymentSheet) {
            VStack(spacing: 20) {
                Text("Confirmar Pago")
                    .font(.title2.bold())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total a pagar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("$\(cartViewModel.calculateTotal(), specifier: "%.2f")")
                        .font(.title.bold())
                        .foregroundColor(.green)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Cantidad pagada")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("Ej. 200.00", text: $amountPaid)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Método de pago")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Método de pago", selection: $selectedPaymentMethod) {
                        ForEach(PaymentMethodsEnum.allCases, id: \.self) { method in
                            Text(method.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Mostrar el cambio si el pago es válido
                if let amount = Double(amountPaid),
                   amount >= cartViewModel.calculateTotal() && selectedPaymentMethod == .cash{
                    let change = amount - cartViewModel.calculateTotal()
                    Text("Cambio: $\(change, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }

                Button(action: {
                    if let amount = Double(amountPaid) {
                        do {
                            let _ = try cartViewModel.registerSale(
                                details: cartViewModel.carItems,
                                method: selectedPaymentMethod,
                                amountPaid: amount
                            )
                            showingPaymentSheet = false
                        } catch {
                            print("Error al registrar la venta: \(error.localizedDescription)")
                            localToast = ToastModel(message: error.localizedDescription, type: .error)
                            
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Confirmar pago")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button("Cancelar", role: .cancel) {
                    showingPaymentSheet = false
                }
            }
            .padding()
            
            // Mostramos el toast solo en el sheet
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

