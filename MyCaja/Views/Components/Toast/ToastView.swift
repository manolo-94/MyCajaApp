//
//  ToastView.swift
//  MyCaja
//
//  Created by MacBook Air on 22/04/25.
//

import SwiftUI

struct ToastView: View {
    
    let toast: ToastModel
    
    var backgroundColor: Color {
        switch toast.type {
        case .success:
            return Color.green.opacity(0.9)
        case .error:
            return Color.red.opacity(0.9)
        }
    }

    var icon: String {
        switch toast.type {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.octagon.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.title2)

            Text(toast.message)
                .foregroundColor(.white)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(radius: 5)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
