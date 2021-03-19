//
//  UIImageExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

extension UIImage {
    
    static let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
    
    static let emptyPersons = UIImage(systemName: "rectangle.stack.person.crop")?
        .withConfiguration(UIImage.SymbolConfiguration(scale: .small)) ?? UIImage()
        .withTintColor(.placeholderText, renderingMode: .alwaysTemplate)
}

