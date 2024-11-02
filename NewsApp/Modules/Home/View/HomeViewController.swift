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
    var newsResult: [Article] = []
    
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
        updatesFromVM()
        
    }
    
    //MARK: - IBACTIONS
    
    @objc private func addButtonTapped() {
        // Action to perform when the button is tapped
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        fetchNewsData()
}
    //MARK: - FUNCTIONS

    func updatesFromVM() {
        Task {
            await viewModel.fetchNews(query: "apple", fromDate: "2024-11-01", toDate: "2024-11-01")
        }
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.newsResult = self?.viewModel.newsResult ?? []
                self?.newsCollectionView.reloadData()
            }
        }
        fetchNewsData()
    }
    
    private func fetchNewsData() {
        let query = navigationItem.searchController?.searchBar.text?.isEmpty == false ?
                    navigationItem.searchController?.searchBar.text! : "apple"
        Task {
            await viewModel.fetchNews(for: datePicker.date, query: query!)
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
            viewModel.clearNewsResults() // Clear results if search bar is empty
            newsCollectionView.reloadData()
            return
        }

        fetchNewsData()
    }
}

// CollectionViewExtention

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        cell.Setup(News: newsResult[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = newsResult[indexPath.row]
        let detailVC = NewsDetailedScreenViewController()
        detailVC.article = selectedArticle // Pass the article
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


