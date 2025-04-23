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
        HStack {
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
            }
            Spacer()
            Button(action: onAddToCart) {
                Image(systemName: "cart.badge.plus")
                    .padding()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
