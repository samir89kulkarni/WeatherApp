//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Sameer on 16/10/24.
//

import SwiftUI
import CoreData

struct WeatherListView: View {
    @ObservedObject var viewModel: WeatherAppViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
            HStack {
                List(viewModel.filteredCities(searchText: searchText), id: \.self) { city in
                    if let firstWeather = city.weather.first {
                        HStack {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(firstWeather.icon)@2x.png")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                case .failure:
                                    Color.red.frame(width: 50, height: 50)
                                case .empty:
                                    Color.blue.frame(width: 50, height: 50)
                                @unknown default:
                                    Color.gray.frame(width: 50, height: 50)
                                }
                            }.padding()
                            Text(city.name)
                        }
                    } else {
                        Text("Weather data unavailable")
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onSubmit(of: .search) {
                viewModel.searchCity(with: searchText, completion: {
                    searchText = ""
                })
            }
            .focused($isFocused)
        }
}

#if DEBUG
struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        return WeatherListView(viewModel: WeatherAppViewModel(coordinator: CityCoordinator(parent: MainCoordinator()), searchService: WeatherDetailService(), apiKey: "apiKey"))
    }
}
#endif
