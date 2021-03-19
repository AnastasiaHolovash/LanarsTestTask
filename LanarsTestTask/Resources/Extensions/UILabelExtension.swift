//
//  UILabelExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import UIKit

extension UILabel {
    
    func setDetail(type: String, info: String) {
        
        let typeAttributedString = NSMutableAttributedString(string: type, attributes: [NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
        let infoAttributedString = NSMutableAttributedString(string: info, attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        
        typeAttributedString.append(infoAttributedString)
        
        attributedText = typeAttributedString
        isHidden = false
    }
}
