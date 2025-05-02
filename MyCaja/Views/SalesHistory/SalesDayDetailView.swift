//
//  SalesDayDetailView.swift
//  MyCaja
//
//  Created by MacBook Air on 26/04/25.
//

import SwiftUI

struct SalesDayDetailView: View {
    
    @ObservedObject var saleHistoryViewModel: SaleHistoryViewModel
    var date: Date
    
    @State var selectedSale: SaleModel?
    
    var body: some View {
        
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(saleHistoryViewModel.displaySales, id: \.id) { sale in
                    
                    SaleDayDetailCardView(sale: sale, onClick: {
                        //print("Hola!!!")
                        selectedSale = sale
                        
                    })
                    .onAppear {
                        saleHistoryViewModel.loadMoreSalesIfNeeded(currentSale: sale)
                    }
                }
                
                if saleHistoryViewModel.isloadingMore {
                    ProgressView().padding()
                } else if !saleHistoryViewModel.hasMoreSales {
                    Text("No hay más ventas para mostrar")
                        .foregroundStyle(Color.gray)
                        .padding()
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            saleHistoryViewModel.fetchSalesForDate(date)
        }
        .sheet(item: $selectedSale){ sale in
                SaleTicketDetailView(
                    saleItems: sale.details,
                    total: sale.total,
                    paymentMethod: sale.paymentMethod,
                    amountPaid: sale.amountPaid,
                    change: sale.change,
                    onFinish: {
                        selectedSale = nil
                })
        }
        
    }
    
    private func formattedDate(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
