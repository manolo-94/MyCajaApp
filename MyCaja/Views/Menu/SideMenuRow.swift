//
//  SideMenuRow.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//
// Fial induvidual del menú

import SwiftUI

struct SideMenuRow: View {
    
    var option: MenuOption
    var action: () -> Void
    
    var body: some View {
        Button (action: action) {
            HStack {
                Image(systemName: option.icon).frame(width: 24, height: 24)
                Text(option.rawValue).font(.headline).foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
    }
}
/*
#Preview {
    SideMenuRow()
}
*/
