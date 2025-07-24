//
//  RitmiaApp.swift
//  Ritmia
//
//  Created by Antonio Dromundo on 24/07/25.
//

import SwiftUI

@main
struct RitmiaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
