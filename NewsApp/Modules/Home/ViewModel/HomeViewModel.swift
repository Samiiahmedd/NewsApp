//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation
import Combine

@MainActor
protocol HomeViewModelProtocol {
    // Output
    var isLoading: PassthroughSubject<Bool, Never> { get }
    var errorMessage: PassthroughSubject<String, Never> { get }
    var articles: CurrentValueSubject<[Article], Never> { get }
    
    // Input
    func fetchNews(query: String, fromDate: String, toDate: String)
    func fetchNews(for date: Date, query: String)
    func clearResults()
}

@MainActor
class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Properties
    var isLoading: PassthroughSubject<Bool, Never> = .init()
    var errorMessage: PassthroughSubject<String, Never> = .init()
    var articles: CurrentValueSubject<[Article], Never> = .init([]) 
    private var cancellables = Set<AnyCancellable>()

    func fetchNews(query: String, fromDate: String, toDate: String) {
        guard !query.isEmpty else {
            errorMessage.send("Please enter a valid query.")
            return
        }
        isLoading.send(true)
        let networkManager = NetworkManager<NewsResponse>()
        Task {
            do {
                let urlString = "\(Constants.baseURL)?q=\(query)&from=\(fromDate)&to=\(toDate)&sortBy=popularity&apiKey=\(Constants.apiKey)"
                let articlesResponse = try await networkManager.getData(from: urlString)
                self.articles.send(articlesResponse.articles)
                isLoading.send(false)
            } catch {
                isLoading.send(false)
                errorMessage.send(error.localizedDescription)
            }
        }
    }

    // Function to fetch news for a specific date
    func fetchNews(for date: Date, query: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        fetchNews(query: query, fromDate: formattedDate, toDate: formattedDate)
    }

    func clearResults() {
        articles.send([])
    }
}


    
//    // FUNCTION TO FETCH NEWS WITH QUERY AND DATE
//    func fetchNews(query: String, fromDate: String, toDate: String) async {
//           print("Fetching news with query: \(query), fromDate: \(fromDate), toDate: \(toDate)")
//           do {
//               let articles = try await fetchNewsData(query: query, fromDate: fromDate, toDate: toDate)
//               print("Fetched articles count: \(articles.count)")
//               self.newsResult = articles
//           } catch {
//               print("Error fetching news: \(error.localizedDescription)")
//           }
//       }
//    
//    // FUNCTION TO FORMAT DATE
//    func fetchNews(for date: Date, query: String) async {
//          let dateFormatter = DateFormatter()
//          dateFormatter.dateFormat = "yyyy-MM-dd"
//          let formattedDate = dateFormatter.string(from: date)
//          print("Fetching news for date: \(formattedDate) with query: \(query)")
//          await fetchNews(query: query, fromDate: formattedDate, toDate: formattedDate)
//      }
//    
//    //NETWORK CALL
//    private func fetchNewsData(query: String, fromDate: String, toDate: String) async throws -> [Article] {
//        let urlString = "\(Constants.baseURL)q=\(query)&from=\(fromDate)&to=\(toDate)&sortBy=popularity&apiKey=\(Constants.apiKey)"
//            
//            guard let url = URL(string: urlString) else {
//                throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//            }
//            
//            let (data, response) = try await URLSession.shared.data(from: url)
//
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//                throw NSError(domain: "Server error", code: 0, userInfo: nil)
//            }
//            
//            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
//            print("Fetched \(newsResponse.articles.count) articles")
//            return newsResponse.articles
//        }
//    }
//
//
//


