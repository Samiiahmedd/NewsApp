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
    @IBOutlet weak var writerView: UIView!
    
    //MARK: - VARIABLES
    
    static let identifier = String(describing: NewsCollectionViewCell.self)
    
    //MARK: -ViewLifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureWriterView()
    }
    
    //MARK: - FUNCTIONS
    private func configureWriterView() {
        writerView.layer.cornerRadius = 8
        writerView.clipsToBounds = true
        newsWriter.numberOfLines = 1
        newsWriter.lineBreakMode = .byTruncatingTail
    }
}



// MARK: - SETUP CELL

extension NewsCollectionViewCell {
    func Setup(News: Article) {
        let imageUrl = News.urlToImage?.asUrl
        NewsImage.kf.setImage(with: imageUrl, placeholder:UIImage(systemName: "photo.artframe"))
        NewsImage.tintColor = UIColor(named: "FavouriteColor")
        newsTitle.text = News.title ?? "Article"
        newsWriter.text = News.author ?? "author"
        newsDescription.text = News.description ?? "Details"
    }
}


