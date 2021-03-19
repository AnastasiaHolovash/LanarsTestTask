//
//  UIApplicationExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import UIKit

extension UIApplication {
    
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
