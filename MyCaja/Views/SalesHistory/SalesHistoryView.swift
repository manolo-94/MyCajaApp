//
//  SalesHistoryListView.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//

import SwiftUI

struct SalesHistoryView: View {
    
    @StateObject private var saleHistoryViewModel: SaleHistoryViewModel
 
    @State private var isNavigating: Bool = false
    @State private var selectedDate: Date? = nil
    
    init() {
        let context = SwiftDataStack.shared.container.mainContext
        
        let saleHistoryService = SaleHistoryService(context: context)
        
        _saleHistoryViewModel = StateObject(wrappedValue: SaleHistoryViewModel(saleHistoryService: saleHistoryService))
    }
    
    private var sortedDate: [Date] {
        saleHistoryViewModel.groupedSales.keys.sorted(by: {$0 > $1})
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
                        
                        //let sortedDate = saleHistoryViewModel.groupedSales.keys.sorted(by: { $0 < $1 })
                        ForEach(sortedDate, id: \.self) { date in
                            
                            SaleHistoryCardView(
                                date: date,
                                total: saleHistoryViewModel.totalFor(date: date),
                                numberOfSale: saleHistoryViewModel.numberOfSales(for: date),
                                onClick: {
                                    //print(date)
                                    //saleHistoryViewModel.fetchSalesForDate(date)
                                    selectedDate = date
                                    isNavigating = true
                                }
                            )
                            
                        }
                    }
                    .navigationDestination(isPresented: $isNavigating) {
                        if let selectedDate = selectedDate {
                            SalesDayDetailView(saleHistoryViewModel: saleHistoryViewModel, date: selectedDate)
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}


