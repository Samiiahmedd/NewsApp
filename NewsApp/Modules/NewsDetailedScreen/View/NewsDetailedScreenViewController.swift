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
    @IBOutlet weak var addToFavouriteButton: UIButton!
    
    //MARK: - VARIABLES
    
    var article: Article?
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
    }
    
    //MARK: - IBACTIONS
    
    @IBAction func addToFavouritesButtonAction(_ sender: Any) {
        showAlertWithTitleAndNavigateBack()
        saveArticleToCoreData(article: article!)
        
    }
    
    //MARK: - FUNCTIONS
    
    private func saveArticleToCoreData(article: Article) {
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
    
    
    func setupView() {
        if let article = article {
            self.title = "Details"
            newsTitle.text = article.title
            newsWriter.text = article.author ?? "Unknown Author"
            newDescription.text = article.description
            let imageUrl = article.urlToImage?.asUrl
            newsImage.kf.setImage(with: imageUrl, placeholder:UIImage(systemName: "photo.artframe"))
            newsImage.tintColor = UIColor(named: "FavouriteColor")
            configureWriterView()

        }
    }
    
    private func configureWriterView() {
        writerView.layer.cornerRadius = 25
        writerView.clipsToBounds = true
        newsWriter.numberOfLines = 1
        newsWriter.lineBreakMode = .byTruncatingTail
    }
    
    private func showAlertWithTitleAndNavigateBack() {
        guard let articleTitle = article?.title else { return }
        let alert = UIAlertController(title: articleTitle, message: "added to favourite successfully", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "FavouriteColor")
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

