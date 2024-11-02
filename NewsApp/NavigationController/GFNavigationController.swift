//
//  GFNavigationController.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation
import UIKit

class GFNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
    }
    
    func setUpNavigationController() {
        self.viewControllers = [HomeViewController()]
    }
}

