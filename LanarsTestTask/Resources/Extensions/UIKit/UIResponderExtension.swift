//
//  UIResponderExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 17.03.2021.
//

import UIKit

extension UIResponder {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
