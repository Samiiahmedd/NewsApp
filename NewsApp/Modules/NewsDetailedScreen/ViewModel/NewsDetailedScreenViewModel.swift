//
//  DetailedScreenViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import Foundation
import Combine
import UIKit

protocol NewsDetailedScreenViewModelProtocol {
    //output
    var isLoading: PassthroughSubject<Bool, Never> { get }
    var errorMessage: PassthroughSubject<String, Never> { get }
    var articleDetails: CurrentValueSubject<[Article], Never> { get }
    
    // Input
    func fetchArticleDetails(url: String)
}

class NewsDetailedScreenViewModel:NewsDetailedScreenViewModelProtocol {
    
    //MARK: - VARIABLES
    
    var article: Article?
    
    // MARK: - Properties
    
    var isLoading: PassthroughSubject<Bool, Never> = .init()
    var errorMessage: PassthroughSubject<String, Never> = .init()
    var articleDetails: CurrentValueSubject<[Article], Never> = .init([])
    private var cancellables = Set<AnyCancellable>()
    private var repository = NewsRepository()
    
    //MARK: - FUNCTIONS
    
    func fetchArticleDetails(url: String) {
        isLoading.send(true)
        Task {
            do {
                let articlesResponse = try await repository.getNewsDetails(url: url)
                self.articleDetails.send(articlesResponse)
                isLoading.send(false)
            } catch {
                isLoading.send(false)
                errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    func saveArticleToCoreData(article: Article) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newArticle = FavouriteArticle(context: context)
        newArticle.title = article.title
        newArticle.author = article.author
        newArticle.articleDescription = article.description
        newArticle.urlToImage = article.urlToImage
        newArticle.publishedAt = article.publishedAt
        newArticle.content = article.content
        do {
            try context.save()
            print("Article saved to Core Data")
        } catch {
            print("Failed to save article: \(error.localizedDescription)")
        }
    }
}
