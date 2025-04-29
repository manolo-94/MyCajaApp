//
//  SaleHistoryViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 25/04/25.
//

import Foundation

@MainActor
final class SaleHistoryViewModel: ObservableObject {
    
    @Published var groupedSales: [Date: [SaleModel]] = [:]
    @Published var filteredSales: [SaleModel] = []
    
    @Published var displaySales: [SaleModel] = []
    @Published var isloadingMore: Bool = false
    @Published var hasMoreSales: Bool = true
    
    private var currentePage = 0
    private let pageSize = 20
    
    private let saleHistoryService : SaleHistoryServiceProtocol
    
    init(saleHistoryService: SaleHistoryServiceProtocol) {
        self.saleHistoryService = saleHistoryService
        loadGroupedSales()
    }
    
    func loadGroupedSales(){
        groupedSales = saleHistoryService.fetchSalesGroupedByDate()
    }
    
    func totalFor(date: Date) -> Double {
        return saleHistoryService.getTotalSales(for: date)
    }
    
    func numberOfSales(for date: Date) -> Int {
        return saleHistoryService.getNumberOfSales(for: date)
    }
    
    func fetchSalesForDate(_ date:Date) {
        let sales = saleHistoryService.getSalesInRange(from: date, to: date)
        
        filteredSales = sales.sorted(by: {$0.date > $1.date})
        
        displaySales =  Array(filteredSales.prefix(pageSize))
        
        currentePage = 1
    }
    
    func loadMoreSalesIfNeeded(currentSale: SaleModel) {
        guard !isloadingMore, hasMoreSales else { return }
        
        guard let lastSale = displaySales.last else { return }
        
        if currentSale.id == lastSale.id {
            loadMoreSales()
        }
    }
    
    private func loadMoreSales() {
        
        isloadingMore = true
        print("Cargando....")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Calcular desde donde deberiamos cargar ventas
            let nextIndex = self.currentePage * self.pageSize
            
            // Calcular hasta donde deberiamos cargar
            let endIndex = min(nextIndex + self.pageSize, self.filteredSales.count)
            
            // Validamos si hay mas ventas para cargar
            if nextIndex < self.filteredSales.count {
                
                // Se agregar mas ventas al arreglo
                self.displaySales.append(contentsOf: self.filteredSales[nextIndex..<endIndex])
                
                // avanzamos a la siguiente pagina
                self.currentePage += 1
                
            }
            
            self.isloadingMore = false
            print("Carga Finalizada....")
            
            // si ya no hay mas ventas para cargar
            self.hasMoreSales = self.displaySales.count < self.filteredSales.count
            
        }
    }
}
