//
//  UITableviewExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import UIKit

extension UITableView {
    
    func addPlaceholder(image: UIImage = .emptyPersons) {
        
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        backgroundView = image
    }
    
    func removePlaceholder() {
        
        backgroundView = nil
    }
}
