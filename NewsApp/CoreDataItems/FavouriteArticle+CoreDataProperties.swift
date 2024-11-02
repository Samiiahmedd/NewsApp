//
//  FavouriteArticle+CoreDataProperties.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//
//

import Foundation
import CoreData


extension FavouriteArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteArticle> {
        return NSFetchRequest<FavouriteArticle>(entityName: "FavouriteArticle")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension FavouriteArticle : Identifiable {

}
