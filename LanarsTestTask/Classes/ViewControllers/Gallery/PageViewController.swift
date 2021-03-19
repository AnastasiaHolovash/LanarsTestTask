//
//  PageViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    // MARK: - Private Variables
    
    private let imagesCount = 15
    private var currentIndex: Int = 0 {
        didSet {
            backwardButton.isEnabled = currentIndex == 0 ? false : true
            forwardButton.isEnabled = currentIndex == imagesCount - 1 ? false : true
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        delegate = self
        dataSource = self
        
        let viewController = PhotoViewController.create(with: getImage(for: currentIndex), index: currentIndex)
        setViewControllers([viewController], direction: .forward, animated: false)
        backwardButton.isEnabled = false
    }
    
    // MARK: - IBActions
    
    @IBAction func forwardAction(_ sender: UIButton) {
        
        if let viewController = next() {
            currentIndex += 1
            setViewControllers([viewController], direction: .forward, animated: true)
        }
    }
    
    @IBAction func backwardAction(_ sender: UIButton) {
        
        if let viewController = previous() {
            currentIndex -= 1
            setViewControllers([viewController], direction: .reverse, animated: true)
        }
    }
    
    // MARK: - Private funcs
    
    private func next() -> UIViewController? {
        
        guard currentIndex < imagesCount - 1 else {
            return nil
        }
        let index = currentIndex + 1
        let viewController = PhotoViewController.create(with: getImage(for: index), index: index)
        
        return viewController
    }
    
    private func previous() -> UIViewController? {
        
        guard currentIndex > 0 else {
            return nil
        }
        let index = currentIndex - 1
        let viewController = PhotoViewController.create(with: getImage(for: index), index: index)
        return viewController
    }
    
    private func getImage(for index: Int) -> UIImage {
        
        return UIImage(named: "lion\(index)") ?? UIImage()
    }
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return previous()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return next()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?.first as? PhotoViewController else {
            return
        }
        currentIndex = viewController.index
    }
}
