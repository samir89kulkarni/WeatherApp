//
//  BaseService.swift
//  SwiftUITest
//
//  Created by Yasemin Üçtaş on 27.06.2022.
//

import Foundation

enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

class BaseWebService {
    
    enum RequestType: String {
      case post = "POST"
      case get = "GET"
      case put = "PUT"
    }
    
    // async await style
    
    @available(iOS 15.0, *)
    func request<T: Decodable> (url: URL, type: RequestType) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        
        do {
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: result.data)
        }
        catch {
            throw APError.unableToComplete
        }
    }
}
