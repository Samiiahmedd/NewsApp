//
//  DetailedScreenViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import Foundation
import Combine

protocol DetailedScreenViewModelProtocol {
    //output
    var isLoading: PassthroughSubject<Bool, Never> { get }
    var errorMessage: PassthroughSubject<String, Never> { get }
    var articleDetails: CurrentValueSubject<[Article], Never> { get }
    
    // Input
    func fetchArticleDetails(url: String)
}

class DetailedScreenViewModel:DetailedScreenViewModelProtocol {
    
    // MARK: - Properties
    
    var isLoading: PassthroughSubject<Bool, Never> = .init()
    var errorMessage: PassthroughSubject<String, Never> = .init()
    var articleDetails: CurrentValueSubject<[Article], Never> = .init([])
    private var cancellables = Set<AnyCancellable>()
    
    func fetchArticleDetails(url: String) {
        guard URL(string: url) != nil else {
            errorMessage.send("invalidRoot")
            return
        }
        
        isLoading.send(true)
        let networkManager = NetworkManager<NewsResponse>()
        Task {
            do {
                let articleUrl = ""
                let articlesResponse = try await networkManager.getData(from: articleUrl)
                self.articleDetails.send(articlesResponse.articles)
                isLoading.send(false)
            } catch {
                isLoading.send(false)
                errorMessage.send(error.localizedDescription)
            }
        }
    }
}
