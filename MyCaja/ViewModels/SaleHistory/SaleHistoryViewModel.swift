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
    @Published var displayGroupedSales: [Date: [SaleModel]] = [:]
    
    @Published var filteredSales: [SaleModel] = []
    @Published var displaySales: [SaleModel] = []
    
    @Published var isloadingMore: Bool = false
    @Published var hasMoreSales: Bool = true
    
    private var currentPageFilterSales = 0
    private var currentPageGroupedSales = 0
    private let pageSize = 20
    
    private var sortedGroupedSales: [(key: Date, value: [SaleModel])] = []
    
    private let saleHistoryService : SaleHistoryServiceProtocol
    
    init(saleHistoryService: SaleHistoryServiceProtocol) {
        self.saleHistoryService = saleHistoryService
        loadGroupedSales()
    }
    
    // Agrupa todas las ventas por fecha
    func loadGroupedSales(){
        // Agrupa todas las ventas por fecha
        groupedSales = saleHistoryService.fetchSalesGroupedByDate()
        
        // Ordenamos las ventas agrupadas por fechas de manera ascendente y lo convertimos en un array ordenado
        sortedGroupedSales = groupedSales.sorted {$0.key > $1.key}
        
        //currentPageGroupedSales = 0
        loadMoreGroupedSales()
    }
    
    // Obtiene el total de cuanto se vendio en una fecha
    func totalFor(date: Date) -> Double {
        return saleHistoryService.getTotalSales(for: date)
    }
    
    // Obtiene el total de cuantas ventas se realizaron en una fecha
    func numberOfSales(for date: Date) -> Int {
        return saleHistoryService.getNumberOfSales(for: date)
    }
    
    // Obtiene todas las ventas de una fecha
    func fetchSalesForDate(_ date:Date) {
        let sales = saleHistoryService.getSalesInRange(from: date, to: date)
        
        // Ordena las fechas de manera descendete
        filteredSales = sales.sorted(by: {$0.date > $1.date})
        
        // Cargamos en bloques de 20 ventas
        displaySales =  Array(filteredSales.prefix(pageSize))
        
        currentPageFilterSales = 1
    }
    
    // Cargamos mas ventas agrupadas por fechas con un Scroll infinito
    func loadMoreGroupedSalesIfNeeded(currentDate: Date) {
        guard !isloadingMore, hasMoreSales else {return}
        
        guard let lastDate = displayGroupedSales.keys.sorted(by: >).last else {return}
        
        //Si el día actual que se está mostrando en pantalla (currentDate) es igual al último día que ya se mostró (lastDate), entonces carga más días agrupados con loadMoreGroupedSales()."
        if currentDate == lastDate {
            loadMoreGroupedSales()
        }
    }
    
    // Cargamos mas ventas haciendo un scroll infinito
    func loadMoreSalesIfNeeded(currentSale: SaleModel) {
        guard !isloadingMore, hasMoreSales else { return }
        
        guard let lastSale = displaySales.last else { return }
        
        // Si la ultima venta actual mostrada en pantalla es igual a la ultima venta que se mostro, entonces cargamos mas ventas
        if currentSale.id == lastSale.id {
            loadMoreSales()
        }
    }
    
    // Cargamos porciones del array sortedGroupedSales en displayGroupedSales
    private func  loadMoreGroupedSales()
    {
        isloadingMore = true
        
        // simula un delay de 5 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            // Calculamos desde donde deberiamos cargar las fechas
            let start = self.currentPageGroupedSales * self.pageSize
            
            // Calculamos hasta donde deberiamos cargar las fechas
            let end = min(start + self.pageSize, self.groupedSales.count)
            
            // validamos si hay mas fechas por cargar si ya no hay salimos de la funcion
            guard start < end else { return }
            
            // Validamos si hay fecha por cargar
            if start < self.groupedSales.count {
                
                // obtenemos las los nuevos datos del arreglo ordenado
                let nextSlice = self.sortedGroupedSales[start..<end]
                
                // Se recorre las fechas y sus ventas y se agregan a displayGroupedSales
                for(date, sales) in nextSlice {
                    self.displayGroupedSales[date] = sales
                }
                
                // aumenta el contaador
                self.currentPageGroupedSales += 1
            }
            
            // detenemos el loading
            self.isloadingMore = false
            
            // Se actuliza si hay mas fechas por cargar
            self.hasMoreSales = self.displayGroupedSales.count < self.groupedSales.count
            
        }
    }
    
    // Cargamos porciones del array filteredSales en displaySales
    private func loadMoreSales() {
        
        // Activa el Spiner
        isloadingMore = true
        print("Cargando....")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Calcular desde donde deberiamos cargar ventas
            let nextIndex = self.currentPageFilterSales * self.pageSize
            
            // Calcular hasta donde deberiamos cargar
            let endIndex = min(nextIndex + self.pageSize, self.filteredSales.count)
            
            // Validamos si hay mas ventas para cargar
            if nextIndex < self.filteredSales.count {
                
                // Se agregar mas ventas al arreglo
                self.displaySales.append(contentsOf: self.filteredSales[nextIndex..<endIndex])
                
                // avanzamos a la siguiente pagina
                self.currentPageFilterSales += 1
                
            }
            
            // Desactiva el Spiner
            self.isloadingMore = false
            print("Carga Finalizada....")
            
            // si ya no hay mas ventas para cargar
            self.hasMoreSales = self.displaySales.count < self.filteredSales.count
            
        }
    }
    
}
