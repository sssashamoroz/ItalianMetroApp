//
//  ItalianMetroAppApp.swift
//  ItalianMetroApp
//
//  Created by Aleksandr Morozov on 27/03/24.
//

import SwiftUI

@main
struct ItalianMetroAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
