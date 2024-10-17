//
//  CityModel.swift
//  WeatherApp
//
//  Created by Sameer on 16/10/24.
//

import Foundation

// MARK: - CityWeatherModel
struct CityModel: Codable, Hashable, Equatable {
    let id: Int
    let name: String
    let weather: [WeatherModel]
    let cod: Double

    // Implementing the equality operator
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        return true
    }

    // Implementing the hash(into:) method
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(weather)
        hasher.combine(cod)
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherModel: Codable, Hashable, Equatable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
