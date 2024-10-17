//
//  MainCoordinator.swift
//  SwiftUITest
//
//  Created by Yasemin Üçtaş on 13.06.2022.
//

import Foundation
import SwiftUI

enum MainTab {
    case first
    case second
}

@MainActor
class MainCoordinator: ObservableObject {

    // MARK: Stored Properties
        
    @Published var cityCoordinator: CityCoordinator!
    
    init() {
        cityCoordinator = .init(parent: self)
    }
}
