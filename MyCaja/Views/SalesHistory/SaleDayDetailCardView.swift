//
//  SalesHistoryListView.swift
//  MyCaja
//
//  Created by MacBook Air on 26/04/25.
//

import SwiftUI

struct SaleHistoryCardView: View {
    
    var date: Date
    var total: Double
    var numberOfSale: Int
    
    var onClick:() -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(formattedDate(date)).font(.title2).bold()
                
                Text("Total vendido: \(total, specifier: "%.2f")$")
                Text("Numero de ventas: \(numberOfSale)$")
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
