//
//  NewsModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation

// MARK: - NewsResponse
struct NewsResponse: Codable {
    let articles: [Article]
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    //MARK: - INITIALIZER TO COREDATA
    
    init(from favouriteArticle: FavouriteArticle) {
            self.source = Source(id: nil, name: nil)
            self.author = favouriteArticle.author
            self.title = favouriteArticle.title
            self.description = favouriteArticle.articleDescription
            self.url = ""
            self.urlToImage = favouriteArticle.urlToImage
            self.publishedAt = favouriteArticle.publishedAt!
            self.content = favouriteArticle.content
        }
}


