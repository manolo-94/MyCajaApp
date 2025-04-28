//
//  SalesHistoryListView.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//

import SwiftUI

struct SalesHistoryListView: View {
    
    @StateObject private var saleHistoryViewModel: SaleHistoryViewModel
    
    init() {
        let context = SwiftDataStack.shared.container.mainContext
        
        let saleHistoryService = SaleHistoryService(context: context)
        
        _saleHistoryViewModel = StateObject(wrappedValue: SaleHistoryViewModel(saleHistoryService: saleHistoryService))
    }
    
    private var sortedDate: [Date] {
        saleHistoryViewModel.groupedSales.keys.sorted()
    }
    
    var body: some View {
        VStack {
            if saleHistoryViewModel.groupedSales.isEmpty {
                Spacer()
                Text("No hay ventas registradas.")
                    .font(.headline)
                    .foregroundStyle(Color.black)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        
                        let sortedDate = saleHistoryViewModel.groupedSales.keys.sorted(by: { $0 < $1 })
                        ForEach(sortedDate, id: \.self) { date in
                            
                            Section(header: Text(formattedDate(date))){
                                VStack(alignment: .leading) {
                                    Text("Total en ventas: \(saleHistoryViewModel.totalFor(date: date), specifier: "%.2f")$")
                                    Text("Numero de ventas: \(saleHistoryViewModel.numberOfSales(date: date))$")
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius:8).fill(Color.gray.opacity(0.1)))
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}


