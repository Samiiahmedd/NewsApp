//
//  DetailedScreenViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import Foundation
class DetailedScreenViewModel {
    
    func fetchArticleDetails(url: String, completion: @escaping (Result<Article, Error>) -> Void) {
          guard let articleUrl = URL(string: url) else {
              completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
              return
          }

          let task = URLSession.shared.dataTask(with: articleUrl) { data, response, error in
              if let error = error {
                  completion(.failure(error))
                  return
              }
              guard let data = data else {
                  completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                  return
              }
              do {
                  let articleDetail = try JSONDecoder().decode(Article.self, from: data)
                  completion(.success(articleDetail))
              } catch {
                  completion(.failure(error))
              }
          }
          task.resume()
      }
}
