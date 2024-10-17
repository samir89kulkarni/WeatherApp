//
//  FirstCoordinatorView.swift
//  SwiftUITest
//
//  Created by Yasemin Üçtaş on 13.06.2022.
//

import SwiftUI

struct CityCoordinatorView: View {
    
    // MARK: Stored Properties
    
    @ObservedObject var coordinator: CityCoordinator
    
    // MARK: Views
    
    var body: some View {
        NavigationView {
            CityView(viewModel: coordinator.viewModel)
        }
    }
}
