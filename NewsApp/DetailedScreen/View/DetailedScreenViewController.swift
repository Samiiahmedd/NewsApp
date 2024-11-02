//
//  DetailedScreenViewController.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import UIKit

class DetailedScreenViewController: UIViewController {
    var article: Article?

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsWriter: UILabel!
    @IBOutlet weak var newDescription: UILabel!
    @IBOutlet weak var writerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let article = article {
                // Set the title of the navigation bar
                self.title = article.title
                
                // Configure UI elements with the article data
                newsTitle.text = article.title
                newsWriter.text = article.author ?? "Unknown Author" // Assuming there's an author property
                newDescription.text = article.description
                
                if let imageUrlString = article.urlToImage, let imageUrl = URL(string: imageUrlString) {
                    // Fetch and display the image
                    fetchImage(from: imageUrl)
                }
            }
    }


    // Function to fetch and set the image
    private func fetchImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.newsImage.image = UIImage(data: data)
            }
        }
        task.resume()
    }

}
