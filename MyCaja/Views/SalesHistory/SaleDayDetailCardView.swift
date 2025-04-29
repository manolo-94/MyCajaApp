//
//  SalesHistoryListView.swift
//  MyCaja
//
//  Created by MacBook Air on 26/04/25.
//

import SwiftUI

struct SaleDayDetailCardView: View {
    
    var sale: SaleModel
    var onClick:() -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(formattedDate(sale.date)).font(.title2).bold()
                
                Text("Venta: \(sale.id.uuidString.prefix(8))")
                Text("Monto total: \(sale.total, specifier: "%.2f")")
                Text("Metodo de pago: \(sale.paymentMethod.description)")
            }
            .onTapGesture {
                //print(formattedDate(date))
                onClick()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x:0, y:2)
    }
    
    private func formattedDate(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
}
