//
//  FavouritesViewController.swift
//  NewsApp
//
//  Created by Sami Ahmed on 02/11/2024.
//

import UIKit
import Combine

class FavouritesViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    //MARK: - VARIABLES
    
    var viewModel = FavouritesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.fetchFavouriteArticles()
        setupView()
        bindViewModel()
    }
    
    //MARK: - BIND VM
    
    @MainActor
    private func bindViewModel() {
            viewModel.$favouriteArticles
                .sink { [weak self] _ in
                    self?.favouritesCollectionView.reloadData()
                }
                .store(in: &cancellables)
        }
}

//MARK: - SETUPVIEW

extension FavouritesViewController {
    func setupView() {
        configureCollectionView()
        registerCells()
    }
    
    func configureCollectionView() {
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.delegate = self
    }
    
    func registerCells() {
        favouritesCollectionView.register(UINib(nibName: NewsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
    }
}

//MARK: - COLLECTION VIEW EXTENTIONS

extension FavouritesViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favouriteArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        let article = viewModel.favouriteArticles[indexPath.item]
        let articleModel = Article(from: article)
        cell.Setup(News: articleModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = viewModel.favouriteArticles[indexPath.item]
        let articleModel = Article(from: selectedArticle)
        let detailVC = NewsDetailedScreenViewController()
        detailVC.viewModel.article = articleModel
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
