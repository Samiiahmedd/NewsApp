//
//  NewsDetailedScreenViewController.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import UIKit
import Combine

class NewsDetailedScreenViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsWriter: UILabel!
    @IBOutlet weak var newDescription: UILabel!
    @IBOutlet weak var writerView: UIView!
    @IBOutlet weak var addToFavouriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - VARIABLES
    
    var viewModel = NewsDetailedScreenViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
        setupBindings()
        activityIndicator.isHidden = true
    }
    
    //MARK: - IBACTIONS
    
    @IBAction func addToFavouritesButtonAction(_ sender: Any) {
        showAlertWithTitleAndNavigateBack()
        viewModel.saveArticleToCoreData(article: viewModel.article!)
    }
    
    //MARK: - FUNCTIONS
    
    private func setupBindings() {
        // Bind loading state
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.activityIndicator.isHidden = !isLoading
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        // Bind error messages
        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showError(message: errorMessage)
            }
            .store(in: &cancellables)
        
        //            Bind article details
        viewModel.articleDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.setupView()
            }
            .store(in: &cancellables)
    }
    
    func setupView() {
        if let article = viewModel.article {
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
        guard let articleTitle = viewModel.article?.title else { return }
        let alert = UIAlertController(title: articleTitle, message: "added to favourite successfully", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "FavouriteColor")
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

