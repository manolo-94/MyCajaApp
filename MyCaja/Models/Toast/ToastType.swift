//
//  ToastType.swift
//  MyCaja
//
//  Created by MacBook Air on 22/04/25.
//

import Foundation
import SwiftUI

enum ToastType {
    case success
    case error
}

struct ToastModel: Identifiable {
    var id = UUID()
    let message: String
    let type: ToastType
}

