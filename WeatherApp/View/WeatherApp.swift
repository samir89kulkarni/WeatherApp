//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Sameer on 15/10/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CityCoordinatorView(coordinator: CityCoordinator(parent: MainCoordinator()))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
// @ObservedObject var coordinator:
