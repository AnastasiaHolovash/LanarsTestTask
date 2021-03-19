//
//  KeyboardEventsHandler.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 19.03.2021.
//

import UIKit

public class KeyboardEventsHandler: NSObject {
    
    private weak var animatedView: UIView!
    private var scrollView: UIScrollView!
    private var keyboardIsPresent: Bool = false
    private var keyboardHeight: CGFloat = 0.0
    
    public var isEnabled = true
    
    public var completion: ((Bool, CGFloat) -> Void)?
    
/** Convenience init
    
- Parameters:
    - forView: super view
    - scroll: scroll view the size of which must be changed
*/
    public convenience init(forView: UIView, scroll: UIScrollView) {
        self.init()
        
        animatedView = forView
        scrollView = scroll
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func handleConstraint(with notification: NSNotification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = animatedView?.convert(keyboardScreenEndFrame, from: animatedView?.window)

        if keyboardViewEndFrame!.minY < scrollView.frame.maxY {
            scrollView.contentInset = scrollView.frame.maxY == animatedView?.frame.maxY ? UIEdgeInsets(top: 0, left: 0, bottom: scrollView.frame.maxY - keyboardViewEndFrame!.minY - animatedView!.safeAreaInsets.bottom, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: scrollView.frame.maxY - keyboardViewEndFrame!.minY, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc
    public func keyboardWillShow(notification: NSNotification) {
        
        guard isEnabled else {
            return
        }
        
        if keyboardIsPresent == false {
            
            handleConstraint(with: notification)
        }
    }
    
    @objc
    public func keyboardDidShow(notification: NSNotification) {
        
        guard isEnabled else {
            return
        }
        
        keyboardIsPresent = true
        completion?(keyboardIsPresent, keyboardHeight)
    }
    
    @objc
    public func keyboardWillHide(notification: NSNotification) {
        
        guard isEnabled else {
            return
        }
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc
    public func keyboardDidHide(notification: NSNotification) {
        
        guard isEnabled else {
            return
        }
        
        keyboardIsPresent = false
        completion?(keyboardIsPresent, keyboardHeight)
    }
    
    @objc
    public func keyboardWillChangeFrame(notification: NSNotification) {
        
        guard isEnabled else {
            return
        }
        
        if keyboardIsPresent == true {
            
            handleConstraint(with: notification)
        }
    }
}

