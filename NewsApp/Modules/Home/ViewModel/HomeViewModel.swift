//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation

class HomeViewModel {
    
    //MARK: - VARIABLES
    var onDataUpdate: (() -> Void)?
    private(set) var newsResult: [Article] = [] {
            didSet {
                onDataUpdate?()
            }
        }
    
    
    // FUNCTION TO DELETE SEARCH RESULT
    func clearNewsResults() {
        newsResult = []
    }
    
    // FUNCTION TO FETCH NEWS WITH QUERY AND DATE
    func fetchNews(query: String, fromDate: String, toDate: String) async {
           print("Fetching news with query: \(query), fromDate: \(fromDate), toDate: \(toDate)")
           do {
               let articles = try await fetchNewsData(query: query, fromDate: fromDate, toDate: toDate)
               print("Fetched articles count: \(articles.count)")
               self.newsResult = articles
           } catch {
               print("Error fetching news: \(error.localizedDescription)")
           }
       }
    
    // FUNCTION TO FORMAT DATE
    func fetchNews(for date: Date, query: String) async {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          let formattedDate = dateFormatter.string(from: date)
          print("Fetching news for date: \(formattedDate) with query: \(query)")
          await fetchNews(query: query, fromDate: formattedDate, toDate: formattedDate)
      }
    
    //NETWORK CALL
    private func fetchNewsData(query: String, fromDate: String, toDate: String) async throws -> [Article] {
            let apiKey = "d9423074473c4fc7b774a143e8749b24"
            let urlString = "https://newsapi.org/v2/everything?q=\(query)&from=\(fromDate)&to=\(toDate)&sortBy=popularity&apiKey=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw NSError(domain: "Server error", code: 0, userInfo: nil)
            }
            
            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            print("Fetched \(newsResponse.articles.count) articles")
            return newsResponse.articles
        }
    }





