//
//  SalePaymentView.swift
//  MyCaja
//
//  Created by MacBook Air on 24/04/25.
//

import SwiftUI

struct SalePaymentView: View {
    
    var total: Double
    @Binding var selectedPaymentMethod: PaymentMethodsEnum
    @Binding var amountPaid: String
    var onConfirm: (Double) -> Void
    var onCancel: () -> Void
    
    @State private var localToast: ToastModel? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Confirmar Pago")
                .font(.title2.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total a pagar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("$\(total, specifier: "%.2f")")
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
                        Text(method.description)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Mostrar el cambio si el pago es válido
            if let amount = Double(amountPaid),
               amount >= total && selectedPaymentMethod == .cash{
                let change = amount - total
                Text("Cambio: $\(change, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            Button(action: {
                if let amount = Double(amountPaid) {
                    onConfirm(amount)
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

            Button("Cancelar", role: .cancel, action: onCancel)        }
        .padding()
                
    }
}
