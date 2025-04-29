//
//  MainView.swift
//  MyCaja
//
//  Created by MacBook Air on 03/04/25.
//
// Funciona como un controlador de navegacion

import SwiftUI

struct MainView: View {
    
    @State private var isMenuOpen = false
    @State private var selectedScreen: MenuOption = .home
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    // Cambiamos la vista segun la opcion seleccionada
                    switch selectedScreen {
                    case .home:
                        HomeView()
                    case .product:
                        ProductListView()
                    case .sale:
                        SaleView()
                    case .salesHistory:
                        SalesHistoryView()
                    }
                }
                .navigationTitle(selectedScreen.rawValue).toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        Button(action: {
                            isMenuOpen.toggle()
                        }){
                            Image(systemName: "line.horizontal.3").imageScale(.large)
                        }
                    }
                }
            }
            SideMenuView(isMenuOpen: $isMenuOpen, selectedScreen: $selectedScreen)
        }
        .gesture(DragGesture().onEnded{
            value in if value.translation.width > 50 {
                withAnimation{
                    isMenuOpen = true
                }
            } else if value.translation.width < -50 {
                withAnimation{
                    isMenuOpen = false
                }
            }
        })
    }
}

#Preview {
    MainView()
}
