//
//  ProductCardView.swift
//  MyCaja
//
//  Created by MacBook Air on 07/04/25.
//

import SwiftUI

/// Vista que representa una tarjeta visual de un producto individual.
struct ProductCardView: View {
    
    /// Modelo de datos del producto que se va a mostrar.
    var product: ProductModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            // Información del producto (lado izquierdo)
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.title3)
                    .bold()
                
                Text(String(format: "$ %.2f", product.price))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Presentación: \(product.presentation.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text("Unidad: \(product.baseUnit.rawValue)")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // Imagen del producto (lado derecho)
            if let imageData = product.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                // Placeholder si no existe imagen
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
