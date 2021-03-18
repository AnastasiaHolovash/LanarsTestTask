//
//  PageViewController.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    // MARK: - Private Variables
    
    private var controllers = [UIViewController]()
    private var lions: [UIImage] = []
    private var currentIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataSource = self
        delegate = self
        
        for item in 1...15 {
            
            let vc = PhotoViewController.create(with: UIImage(named: "lion\(item)") ?? UIImage())
            controllers.append(vc)
        }
        
        setViewControllers([controllers[currentIndex]], direction: .forward, animated: false)
        
    }
    
    // MARK: - IBActions
    
    @IBAction func forwardAction(_ sender: UIButton) {
        
        currentIndex += 1
        setViewControllers([controllers[currentIndex]], direction: .forward, animated: true)
    }
    
    @IBAction func backwardAction(_ sender: UIButton) {
        
        currentIndex -= 1
        setViewControllers([controllers[currentIndex]], direction: .reverse, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.firstIndex(of: viewController) , index > 0 else {
            return nil
        }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else {
            return nil
        }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0],
              let index = controllers.firstIndex(of: viewController) else {
            return
        }
        currentIndex = index
    }
}
