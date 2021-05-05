//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Olivier Van hamme on 05/05/2021.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
