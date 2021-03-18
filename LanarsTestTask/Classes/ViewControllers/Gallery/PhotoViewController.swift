//
//  PhotoViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    // MARK: - Statics
    
    static func create(with image: UIImage) -> PhotoViewController {
        
        let viewController = UIStoryboard.main.instantiateViewController(identifier: PhotoViewController.identifier) as! PhotoViewController
        viewController.image = image
        
        return viewController
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public Variables
    
    public var image: UIImage?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        }
    }
}
