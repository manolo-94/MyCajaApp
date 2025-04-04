//
//  SideMenuView.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//
// Vista del menú lateral con navegación

import SwiftUI

struct SideMenuView: View {
    
    @Binding var isMenuOpen: Bool
    @Binding var selectedScreen: MenuOption
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack (alignment: .leading){
                Text("Menu").font(.largeTitle).foregroundStyle(.background, .white).padding(.top,50)
                
                ForEach(MenuOption.allCases, id: \.self) {
                    option in SideMenuRow(option: option){
                        selectedScreen = option
                        isMenuOpen = false
                    }
                }
                Spacer()
            }
            .frame(maxWidth: geometry.size.width * 0.75) // 75% del ancho de la pantalla
            .background(Color(UIColor.systemGray2))
            .ignoresSafeArea()
            .offset(x: isMenuOpen ? 0 : -geometry.size.width * 0.75) // Se mueve dinamicamente
            .animation(.easeInOut, value: isMenuOpen)
        }
        
    }
}
/*
 #Preview {
 SideMenuView()
 }
 */
