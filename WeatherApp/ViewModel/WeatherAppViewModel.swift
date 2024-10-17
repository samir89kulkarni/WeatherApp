//
//  WeatherAppViewModel.swift
//  WeatherApp
//
//  Created by Sameer on 15/10/24.
//

import Foundation
import SwiftUI
import CoreData

class WeatherAppViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    private let apiKey: String
    private let coordinator: CityCoordinator
    private let searchService: WeatherDetailService

    @Published var cities: [CityModel] = []
    @Published var errorMessage: String? // To store error messages

    init(coordinator: CityCoordinator, searchService: WeatherDetailService, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext, apiKey: String) {
        self.coordinator = coordinator
        self.searchService = searchService
        self.viewContext = context
        self.apiKey = apiKey
        fetchCitiesFromDatabase() // Fetch cities when the view model is initialized
    }

    // Fetch cities from the database
    private func fetchCitiesFromDatabase() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()

        do {
            let cityEntities = try viewContext.fetch(fetchRequest)
            self.cities = cityEntities.map { cityEntity in
                // Map Core Data entity to CityModel
                let weatherArray = cityEntity.weather?.allObjects as? [Weather] ?? []
                let weatherModels = weatherArray.map { weatherEntity in
                    WeatherModel(id: Int(weatherEntity.id), main: weatherEntity.main ?? "", description: weatherEntity.descr ?? "", icon: weatherEntity.icon ?? "")
                }
                return CityModel(id: Int(cityEntity.id), name: cityEntity.name ?? "", weather: weatherModels, cod: 200) // Assuming cod is always 200 for fetched cities
            }
        } catch {
            print("Failed to fetch cities: \(error.localizedDescription)")
        }
    }
    
    func filteredCities(searchText: String) -> [CityModel] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func searchCity(with searchText: String, completion: @escaping () -> Void) {
        getSearchResults(with: searchText) { localCities in
            if let localCity = localCities {
                self.addCity(from: localCity)
                DispatchQueue.main.async {
                    self.cities.append(localCities ?? CityModel(id: 0, name: "", weather: [WeatherModel(id: 0, main: "", description: "", icon: "")], cod: 0)) // Notify the parent to update UI
                }
            } else {
                self.errorMessage = "City not found." // Handle case where no cities were found
                completion()
            }
        }
    }

    private func getSearchResults(with searchText: String, completion: @escaping (CityModel?) -> Void) {
        Task {
            do {
                let result = try await searchService.search(searchText: searchText, apiKey: apiKey)
                print(result)
                completion(result)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }

    private func addCity(from localCity: CityModel) {
        viewContext.perform {
            let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", Int64(localCity.id))
            
            do {
                let existingCities = try self.viewContext.fetch(fetchRequest)
                
                if existingCities.isEmpty {
                    let cityToInsert = City(context: self.viewContext)
                    cityToInsert.name = localCity.name
                    cityToInsert.id = Int64(localCity.id)
                    
                    for weather in localCity.weather {
                        let weatherEntity = Weather(context: self.viewContext)
                        weatherEntity.id = Int64(weather.id)
                        weatherEntity.main = weather.main
                        weatherEntity.descr = weather.description
                        weatherEntity.icon = weather.icon
                        cityToInsert.addToWeather(weatherEntity)
                    }
                    try self.viewContext.save()
                }
            } catch {
                print("Failed to fetch cities: \(error.localizedDescription)")
            }
        }
    }

    func printDatabasePath() {
        // Get the path to the Documents directory
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Append your database filename
            let databasePath = documentsDirectory.appendingPathComponent("WeatherApp.sqlite")
            print("Database Path: \(databasePath.path)")
        }
    }

}
