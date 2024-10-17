//
//  UserDetailService.swift
//  SwiftUITest
//
//  Created by Yasemin Üçtaş on 27.06.2022.
//

import Foundation

protocol WeatherDetailServiceProtocol: AnyObject {
    
    @available(iOS 15.0, *)
    func search(searchText: String, apiKey: String) async throws -> CityModel
}

final class WeatherDetailService: WeatherDetailServiceProtocol {
    
    @available(iOS 15.0, *)
    func search(searchText: String, apiKey: String) async throws -> CityModel {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(searchText)&appid=\(apiKey)"
        guard let url = URL(string: url) else {
            throw APError.invalidURL
        }
        
        let baseService = BaseWebService()
        return try await baseService.request(url: url, type: .get)
    }
    
    func getSearchResults(with text: String, apiKey: String, completion: @escaping (CityModel?, Error?) -> Void) {
        Task {
            do {
                let result = try await search(searchText: text, apiKey: apiKey)
                completion(result, nil)  // This returns an array of CityModel
            } catch {
                print(error)
                completion(nil, error)  // In case of error, return nil
            }
        }
    }}
