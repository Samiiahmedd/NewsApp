//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import UIKit
import Kingfisher

class NewsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var NewsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsWriter: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    
    //MARK: - VARIABLES
    
    static let identifier = String(describing: NewsCollectionViewCell.self)

}

// MARK: - SETUP CELL

extension NewsCollectionViewCell {
    func Setup(News: Article) {
        let imageUrl = News.urlToImage?.asUrl
        NewsImage.kf.setImage(with: imageUrl, placeholder:UIImage(systemName: "photo.artframe"))
        newsTitle.text = News.title
        newsWriter.text = News.author ?? "User"
        newsDescription.text = News.description
    }
}
