//
//  SaleHistoryService.swift
//  MyCaja
//
//  Created by MacBook Air on 25/04/25.
//

import Foundation
import SwiftData

@MainActor
class SaleHistoryService: SaleHistoryServiceProtocol {
   
    private  let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAllSales() -> [SaleModel] {
        let fetchDescriptor = FetchDescriptor<SaleModel>()
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    func fetchSalesGroupedByDate() -> [Date : [SaleModel]] {
        
        let allSales = fetchAllSales()
        
        let grouped = Dictionary(grouping: allSales) { sale in
            Calendar.current.startOfDay(for: sale.date)
        }
        
        let sortedGrouped = grouped.mapValues { sales in
            sales.sorted(by: {$0.date > $1.date})
        }
        
        return sortedGrouped
    }
    
    func getTotalSales(for date: Date) -> Double {
        let dayStart = Calendar.current.startOfDay(for: date)
        
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        
        let filtered = fetchAllSales().filter { $0.date >= dayStart && $0.date < dayEnd}
        
        return filtered.reduce(0) {$0 + $1.total}
    }
    
    func getNumberOfSales(for date: Date) -> Int {
        let dayStart = Calendar.current.startOfDay(for: date)
        
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        
        return fetchAllSales().filter { $0.date >= dayStart && $0.date < dayEnd }.count
    }
    
    func getSalesInRange(from: Date, to: Date) -> [SaleModel] {
        let dayStar = Calendar.current.startOfDay(for: from)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: to))!
        return fetchAllSales().filter {$0.date >= dayStar && $0.date < dayEnd}
    }
    
}
