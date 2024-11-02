//
//  NewsDetailedScreenViewController.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import UIKit
import Kingfisher

class NewsDetailedScreenViewController: UIViewController {
    
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsWriter: UILabel!
    @IBOutlet weak var newDescription: UILabel!
    @IBOutlet weak var writerView: UIView!
    
    //MARK: - VARIABLES
    
    var article: Article?
    
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
    }
    
    //MARK: - FUNCTIONS
    
    func setupView() {
        if let article = article {
            self.title = "Details"
            newsTitle.text = article.title
            newsWriter.text = article.author ?? "Unknown Author"
            newDescription.text = article.description
            let imageUrl = article.urlToImage?.asUrl
            newsImage.kf.setImage(with: imageUrl, placeholder:UIImage(systemName: "photo.artframe"))
        }

    }
}
