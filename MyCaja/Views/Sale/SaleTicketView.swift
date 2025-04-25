//
//  SaleTicketView.swift
//  MyCaja
//
//  Created by MacBook Air on 24/04/25.
//

import SwiftUI

struct SaleTicketView: View {
    
    let saleItems: [SaleDetailModel]
    let total: Double
    let paymentMethod: PaymentMethodsEnum
    let amountPaid: Double
    @ObservedObject var cartViewModel: CartViewModel
    
    var onFinish: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(spacing: 16) {
           Text("✅ Venta Exitosa")
                .font(.title2)
                .bold()
                .padding(.top)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(saleItems, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.productName).font(.headline)
                            HStack {
                                Text("Cantidad: \(Int(item.quantity))")
                                Spacer()
                                Text("Subtotal: $\(item.subTotal, specifier: "%.2f")")
                            }
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            
            
            Divider()
            
            VStack(spacing: 6) {
                HStack {
                    Text("Metodo de pago:")
                    Spacer()
                    Text(paymentMethod.description).bold()
                }
                
                HStack {
                    Text("Total pagado:")
                    Spacer()
                    Text("$\(amountPaid, specifier: "%.2f")").bold()
                }
                
                HStack {
                    Text("Total venta:")
                    Spacer()
                    Text("$\(total, specifier: "%.2f")").bold()
                }
                
                HStack {
                    Text("Cambio:")
                    Spacer()
                    Text("$\(amountPaid - total, specifier: "%.2f")").bold()
                }
            }
            .padding()
            .backgroundStyle(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                cartViewModel.clearCart()
                //dismiss()
                onFinish()
            } label: {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                    Text("Finalizar").fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundStyle(Color(.white))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

