//
//  FileManagerExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import Foundation

extension FileManager {
    
    static func libraryURL() -> URL {
        
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
    }
}
