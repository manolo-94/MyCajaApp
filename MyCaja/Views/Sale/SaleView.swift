//
//  SaleListView.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//

import SwiftUI
import SwiftData

struct SaleView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject private var saleProductVM: SaleProductViewModel
    @StateObject private var cartVM: CartViewModel
    
    
    init() {
        let context = SwiftDataStack.shared.container.mainContext
        let productService = ProductService(context: context)
        let saleService = SaleService(context: context)
        
        _saleProductVM = StateObject(wrappedValue: SaleProductViewModel(productService: productService))
        
        _cartVM = StateObject(wrappedValue: CartViewModel(saleService: saleService))
        
    }
    
    var body: some View {
        ZStack {
            if horizontalSizeClass == .regular {
                // Layout tipo ipad (Landscape)
                GeometryReader { geometry in
                    HStack {
                        HStack(spacing:0) {
                            SaleProductListView(saleProductViewModel: saleProductVM, cartViewModel: cartVM
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.7, height: geometry.size.height)
                            
                            Divider()
                            
                            SaleCartSummaryView(cartViewModel: cartVM).frame(width: UIScreen.main.bounds.width * 0.3, height: geometry.size.height)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGroupedBackground))
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            } else {
                // Layout tipo iPhone (Stack navegable o Tab)
                NavigationView {
                    /*
                    VStack(spacing: 24) {
                        SaleProductListView(saleProductViewModel: saleProductVM, cartViewModel: cartVM).frame(height: 300)
                        
                        SaleCartSummaryView(cartViewModel: cartVM)
                    }
                    .navigationTitle("Nueva Ventana").padding()
                     */
                    SaleProductListView(saleProductViewModel: saleProductVM, cartViewModel: cartVM)
                        .toolbar{
                            NavigationLink(destination: SaleCartSummaryView(cartViewModel: cartVM)) {
                                Image(systemName: "cart")
                                Text(String(format: "$%.2f", cartVM.calculateTotal())).font(.subheadline).foregroundColor(.primary)
                            }
                        }
                }
            }
            
            // Aquí el overlay del Toast (ya dentro del ZStack)
            // Se agrego el toast de manera globla para poder mostrarlo en todas las vistas hijas
            // Tener en cuenta que en el NavigationLink no parace hay que validar la pantalla y agregarlo
            if let toast = cartVM.toast {
                ToastView(toast: toast)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                cartVM.toast = nil
                            }
                        }
                    }
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    SaleView()
}
