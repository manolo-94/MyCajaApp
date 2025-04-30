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
    
    // Ordenamos las ventas por fecha
    private var sortedDate: [Date] {
        saleHistoryViewModel.displayGroupedSales.keys.sorted(by: {$0 > $1})
    }
    
    var body: some View {
        VStack {
            
            // Mostramos un Spiner mientras se cargan la info
            if  saleHistoryViewModel.isloadingMoregGroupedSales {
                ProgressView().padding()
            } else {
                
                if saleHistoryViewModel.displayGroupedSales.isEmpty {
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
                                .onAppear {
                                    saleHistoryViewModel.loadMoreGroupedSalesIfNeeded(currentDate: date)
                                }
                                
                            }
                            
                            if saleHistoryViewModel.isloadingMoregGroupedSales {
                                ProgressView().padding()
                            } else if !saleHistoryViewModel.hasMoreGroupedSales {
                                Text("No hay más ventas para mostrar")
                                    .foregroundStyle(Color.gray)
                                    .padding()
                                    .font(.subheadline)
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
}


