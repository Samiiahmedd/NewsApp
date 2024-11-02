//
//  DetailedScreenViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import Foundation

class DetailedScreenViewModel {
    
    func fetchArticleDetails(url: String) async throws -> Article {
        guard let articleUrl = URL(string: url) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: articleUrl)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NSError(domain: "Server error", code: 0, userInfo: nil)
        }
        
        do {
            let articleDetail = try JSONDecoder().decode(Article.self, from: data)
            return articleDetail
        } catch {
            throw error
        }
    }
}
