//
//  UIView+Extentions.swift
//  NewsApp
//
//  Created by Sami Ahmed on 01/11/2024.
//

import Foundation
import UIKit


extension UIView {
    
    // CornerRadius
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    // Shadow
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = self.layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
}
