//
//  FirstCoordinator.swift
//  SwiftUITest
//
//  Created by Yasemin Üçtaş on 13.06.2022.
//

import SwiftUI

@MainActor
final class CityCoordinator: ObservableObject, Identifiable {
    
    private unowned let parent: MainCoordinator?
    @Published var alertItem: AlertItem?
    @Published var viewModel: WeatherAppViewModel!
    let apiKey = "0d51f9e1c560871e0953e69350b2c44c"

    init(parent: MainCoordinator?) {
        self.parent = parent
        self.viewModel = WeatherAppViewModel(coordinator: self, searchService: WeatherDetailService(), apiKey: apiKey)
    }
}

