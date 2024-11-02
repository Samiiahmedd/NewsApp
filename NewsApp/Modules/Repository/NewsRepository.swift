//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import Foundation


class NewsRepository {
    
    //MARK: - VARIABLES
    
    let networkManager = NetworkManager()

    //MARK: - FUNCTIONS
    
    func getNews(query:String, fromDate: String, toDate: String) async throws -> [Article] {
        do {
            let urlString = "\(Constants.baseURL)?q=\(query)&from=\(fromDate)&to=\(toDate)&sortBy=popularity&apiKey=\(Constants.apiKey)"
            let articleData = try await networkManager.getData(from: urlString)
            let articles: NewsResponse = try JSONDecoder().decode(NewsResponse.self, from: articleData)
            return articles.articles
        } catch {
            throw error
        }
    }
    
    func getNewsDetails(url:String) async throws -> [Article] {
        do {
            let articleUrl = ""
            let articlesResponse = try await networkManager.getData(from: articleUrl)
            let articlesDetails : NewsResponse = try JSONDecoder().decode(NewsResponse.self, from: articlesResponse)
            return articlesDetails.articles
        } catch {
            throw error
        }
    }
}
