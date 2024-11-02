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
}

@MainActor
class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Properties
    
    var isLoading: PassthroughSubject<Bool, Never> = .init()
    var errorMessage: PassthroughSubject<String, Never> = .init()
    var articles: CurrentValueSubject<[Article], Never> = .init([]) 
    private var cancellables = Set<AnyCancellable>()
    private var repository = NewsRepository()

    func fetchNews(query: String, fromDate: String, toDate: String) {
        guard !query.isEmpty else {
            errorMessage.send("Please enter a valid query.")
            return
        }
        isLoading.send(true)
        Task {
            do {
                let articlesResponse = try await repository.getNews(query: query, fromDate: fromDate, toDate: toDate)
                self.articles.send(articlesResponse)
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
}

    



