//
//  SaleHistoryServiceProtocol.swift
//  MyCaja
//
//  Created by MacBook Air on 25/04/25.
//

import Foundation

@MainActor
protocol SaleHistoryServiceProtocol {
    func fetchAllSales() -> [SaleModel]
    func fetchSalesGroupedByDate() -> [Date: [SaleModel]]
    func getTotalSales(for date: Date) -> Double // Total de venta por fecha
    func getNumberOfSales(for date: Date) -> Int  // Total de numero de ventas realizadas en la fecha seleccionada
    func getSalesInRange(from: Date, to: Date) -> [SaleModel] // ventas en un rago de fechas
}
