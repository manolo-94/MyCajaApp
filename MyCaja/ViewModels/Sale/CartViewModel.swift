//
//  CartViewModel.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import Foundation

/// Manejar el carrito y generar la venta
@MainActor
final class CartViewModel: ObservableObject {
    
    @Published var carItems: [SaleDetailModel] = []
    private let saleService: SaleServiceProtocol
    
    @Published var showEditSheet = false
    @Published var itemBeingEdited: SaleDetailModel?
    
    @Published var toast: ToastModel?
    
    @Published var changeToReturn: Double? = nil
    
    //@Published var lastSaleItems: [SaleDetailModel] = []
    
    init(saleService: SaleServiceProtocol) {
        self.saleService = saleService
    }
    
    func calculateTotal() -> Double {
        carItems.reduce(0) {$0 + $1.subTotal}
    }
    
    func addProduct(_ product: ProductModel, quantity: Double, enteredPrice: Double? = nil) {
        
        let bulk = isBulkProduct(product)
                
        let detail = SaleDetailModel(
            productId: product.id,
            productName: product.name,
            unitPrice: product.price,
            quantity: quantity,
            isBulk: bulk
        )
        carItems.append(detail)
        toast = ToastModel(message: "Producto agregado al carrito", type: .success)
    }
    
    func startEditing(item: SaleDetailModel) {
        self.itemBeingEdited = item
        self.showEditSheet = true
    }
    
    func editProduct(item: SaleDetailModel, with newValue: Double) {
        
        guard newValue > 0 else {
            //print("La cantidad debe ser mayor a 0")
            toast = ToastModel(message: "La cantidad debe ser mayor a 0", type: .error)
            return
        }
        
        if let index = carItems.firstIndex(where: {$0.id == item.id})
        {
            carItems[index].quantity = newValue
            //print("Se actualizo la cantidad del producto")
            toast = ToastModel(message: "Cantidad actualizada correctamente", type: .success)
        }
       
    }
    
    func removeItem(_ item: SaleDetailModel) {
        carItems.removeAll {$0.id == item.id }
        //print("Se elimino \(item.productName) del carrito")
        toast = ToastModel(message: "Se elimino \(item.productName) del carrito", type: .success)
    }
    
    func clearCart() {
       //print("Se limpio el carrito")
       //toast = ToastModel(message: "Se limpio el carrito", type: .success)
        carItems.removeAll()
    }
    
    func registerSale(details: [SaleDetailModel], method: PaymentMethodsEnum, amountPaid: Double) throws -> Double {
        
        let total = calculateTotal()
        
        guard amountPaid >= total else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "El monto pagado es menor al total."])
        }
        
        let change = amountPaid - total
        
        let sale = SaleModel(
            paymentMethod: method,
            status: .completed,
            total: total,
            amountPaid: amountPaid,
            change: change,
            details: details
        )
        
       try saleService.saveSale(sale)
            
        print("Venta registrada con éxito.")
        toast = ToastModel(message: "Venta registrada con éxito.", type: .success)
        
        //lastSaleItems = carItems
        //clearCart()
        
        //let change = amountPaid - total
        
        return change
        
        
    }
    
    func isBulkProduct(_ product: ProductModel) -> Bool {
        switch product.presentation {
        case .granel:
            return true
        default:
            return false
        }
    }
    
}
