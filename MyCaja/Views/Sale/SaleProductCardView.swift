//
//  SaleProductCardView.swift
//  MyCaja
//
//  Created by MacBook Air on 17/04/25.
//

import SwiftUI

struct SaleProductCardView: View {
    var product: ProductModel
    var onAddToCart: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            // Imagen centrada en la parte superior
            if let imageData = product.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundStyle(.gray.opacity(0.5))
            }

            // Información del producto
            VStack(spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            // Botón agregar al carrito
            /*Button(action: onAddToCart) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                    Text("Agregar")
                }
                .font(.caption)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }*/
            HStack {
                Image(systemName: "cart.badge.plus")
                Text("Agregar")
            }
            .font(.caption)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .onTapGesture {
            onAddToCart()
        }
    }
}
