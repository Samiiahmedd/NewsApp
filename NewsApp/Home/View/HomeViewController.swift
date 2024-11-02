//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import UIKit
import Combine


class HomeViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    //MARK: - VARIABLES
    
    private let viewModel = HomeViewModel()
    private let detailsVM = DetailedScreenViewModel()
    var NewsResult: [Article] = []
    
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchNews(for: datePicker.date, query: "apple")
        
    }
    
    
    //MARK: - FUNCTIONS
    
    private func fetchNews(query: String, fromDate: String, toDate: String) {
            print("Fetching news with query: \(query), fromDate: \(fromDate), toDate: \(toDate)")
            viewModel.fetchNews(query: query, fromDate: fromDate, toDate: toDate) { [weak self] result in
                switch result {
                case .success(let articles):
                    print("Fetched articles count: \(articles.count)")
                    self?.NewsResult = articles
                    DispatchQueue.main.async {
                        self?.newsCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching news: \(error.localizedDescription)")
                }
            }
        }
    
    private func fetchNews(for date: Date, query: String) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let formattedDate = dateFormatter.string(from: date)
           print("Fetching news for date: \(formattedDate) with query: \(query)")
           fetchNews(query: query, fromDate: formattedDate, toDate: formattedDate)
       }
    
    //MARK: - IBACTIONS
    
    @objc private func addButtonTapped() {
        // Action to perform when the button is tapped
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if let query = navigationItem.searchController?.searchBar.text, !query.isEmpty {
            fetchNews(for: sender.date, query: query)
        } else {
            fetchNews(for: sender.date, query: "apple")
        }
    }
}

// SETUP VIEW

extension HomeViewController {
    func setupView() {
        addNavigationBarButton()
        addSearchBar()
        registerCells()
        configerCollectionView()
    }
    
    func addNavigationBarButton() {
        let addImage = UIImage(systemName: "heart.fill")
        let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for news"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    func configerCollectionView() {
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
    }
    
    func registerCells() {
        newsCollectionView.register(UINib(nibName: NewsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        
    }
    
}

//Extention Search Results

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            NewsResult.removeAll() // Clear results if search bar is empty
            newsCollectionView.reloadData()
            print("Cleared search results")
            return
        }
        
        // Log the query to confirm it's being used
        print("Updating search with query: \(query)")
        fetchNews(for: datePicker.date, query: query) // Perform fetch based on search input
    }
}


// CollectionViewExtention

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewsResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        cell.Setup(News: NewsResult[indexPath.row])
        return cell
    }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedArticle = NewsResult[indexPath.row]
            
            // Initialize the DetailedScreenViewController and pass the selected article
            let detailVC = DetailedScreenViewController()
            detailVC.article = selectedArticle // Pass the article
            
            // Present the detailed screen
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 16
           let totalHorizontalPadding = padding * 3
           let availableWidth = collectionView.frame.width - totalHorizontalPadding
           let cellWidth = availableWidth / 2
           
           return CGSize(width: cellWidth, height: 240)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 16
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 16
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
       }
    
}


