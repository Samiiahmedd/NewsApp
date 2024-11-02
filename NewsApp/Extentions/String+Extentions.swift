//
//  String+Extentions.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation
extension String {
        var asUrl: URL? {
            return URL(string: self)
        }
    }

