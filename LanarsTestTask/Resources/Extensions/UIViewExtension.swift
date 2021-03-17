//
//  UIViewExtension.swift
//  LanarsTestTask
//
//  Created by Anastasia Holovash on 18.03.2021.
//

import UIKit

extension UIView {
    
    public func isHiddenInStackView(_ isHidden: Bool, animated: Bool = true, duration: TimeInterval = 0.35) {
        isHidden
            ? hideInStackView(animated: animated, duration: duration)
            : showInStackView(animated: animated, duration: duration)
    }
    
    /// Hide view in stack if needed
    private func hideInStackView(animated: Bool, duration: TimeInterval = 0.35) {
        if !isHidden {
            if animated {
                UIView.animate(withDuration: duration) { [self] in
                    alpha = 0
                    isHidden = true
                    superview?.layoutSubviews()
                }
            } else {
                alpha = 0
                isHidden = true
                superview?.layoutSubviews()
            }
        }
    }
    
    /// Show view in stack if needed
    private func showInStackView(animated: Bool, duration: TimeInterval = 0.35) {
        if isHidden {
            if animated {
                UIView.animate(withDuration: duration) { [self] in
                    alpha = 1
                    isHidden = false
                    superview?.layoutSubviews()
                }
            } else {
                alpha = 1
                isHidden = false
                superview?.layoutSubviews()
            }
        }
    }
}
