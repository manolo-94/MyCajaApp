//
//  MyCajaApp.swift
//  MyCaja
//
//  Created by MacBook Air on 02/04/25.
//

import SwiftUI
import SwiftData

@main
struct MyCajaApp: App {

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(SwiftDataStack.shared.container)
    }
}
