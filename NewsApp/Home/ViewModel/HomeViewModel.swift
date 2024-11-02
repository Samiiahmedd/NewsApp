//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation

class HomeViewModel {
    func fetchNews(query: String, fromDate: String, toDate: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let apiKey = "9790393d82174994975fc4700aedbfee"
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&from=\(fromDate)&to=\(toDate)&sortBy=popularity&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            print("Invalid URL constructed: \(urlString)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                print("No data returned from API")
                return
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(newsResponse.articles))
                print("Fetched \(newsResponse.articles.count) articles")
            } catch {
                completion(.failure(error))
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}




