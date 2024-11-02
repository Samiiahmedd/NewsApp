//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import Foundation

class NetworkManager<T: Decodable> {
    
    // Fetch data from a URL
    func getData(from url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NSError(domain: "Server error", code: 0, userInfo: nil)
        }
        
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
}
