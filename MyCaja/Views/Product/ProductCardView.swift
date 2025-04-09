//
//  ProductCardView.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import SwiftUI

struct ProductCardView: View {
    
    var product: ProductModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16){
        
            // Informacion a la izquierda
            VStack(alignment: .leading, spacing: 8){
                Text(product.name).font(.title3).bold()
                /*Text(String(format: "$ %.2f",*/
                Text(String(product.price)).font(.subheadline).foregroundStyle(Color.secondary)
                
                Text("Presentación: \(product.presentation.rawValue)").font(.caption).foregroundStyle(Color.gray)
                Text("Unidad: \(product.baseUnit.rawValue)").font(.caption2).foregroundStyle(Color.gray)
                
            }
            
            Spacer()
            
            // Imagen a la derecha
            
            if let imageDate = product.image,
               let uiImage = UIImage(data: imageDate){
                Image(uiImage: uiImage).resizable().scaledToFit().frame(width: 80, height: 80).clipped().cornerRadius(8)
            } else {
                // Placeholder si no hay imagen
                Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundStyle(.gray.opacity(0.5))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x:0, y:2)
    }
}


