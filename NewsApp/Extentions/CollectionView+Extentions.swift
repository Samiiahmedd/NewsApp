//
//  CollectionView+Extentions.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation
import UIKit

extension UIViewController {
    var fullScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    var halfScreenWidth: CGFloat {
        return UIScreen.main.bounds.width / 2
    }
}

extension UICollectionView {
    var collectionViewHeight: CGFloat {
        return self.frame.size.height
    }
}
