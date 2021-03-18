//
//  PageViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    // MARK: - Private Variables
    
    private let imagesCount = 15
    private var currentIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        delegate = self
        
        let viewController = PhotoViewController.create(with: getImage(for: currentIndex))
        
        setViewControllers([viewController], direction: .forward, animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction func forwardAction(_ sender: UIButton) {
        
        if let viewController = next() {
            setViewControllers([viewController], direction: .forward, animated: true)
        }
    }
    
    @IBAction func backwardAction(_ sender: UIButton) {
        
        if let viewController = previous() {
            setViewControllers([viewController], direction: .reverse, animated: true)
        }
    }
    
    // MARK: - Private funcs
    
    private func next() -> UIViewController? {
        
        guard currentIndex < imagesCount - 1 else {
            return nil
        }
        currentIndex += 1
        let viewController = PhotoViewController.create(with: getImage(for: currentIndex))
        
        return viewController
    }
    
    private func previous() -> UIViewController? {
        
        guard currentIndex > 0 else {
            return nil
        }
        currentIndex -= 1
        let viewController = PhotoViewController.create(with: getImage(for: currentIndex))
        return viewController
    }
    
    private func getImage(for index: Int) -> UIImage {
        
        return UIImage(named: "lion\(index)") ?? UIImage()
    }
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return previous()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return next()
    }
}
