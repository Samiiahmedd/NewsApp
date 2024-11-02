//
//  FavouritesViewModel.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import UIKit
import CoreData
import Combine

class FavouritesViewModel{
    
    //MARK: - VARIABLES
    
    @Published var favouriteArticles: [FavouriteArticle] = []
    
    // MARK: - FUNCTIONS
    
    func fetchFavouriteArticles() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavouriteArticle> = FavouriteArticle.fetchRequest()
        
        do {
            favouriteArticles = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch articles: \(error.localizedDescription)")
        }
    }
    
}
