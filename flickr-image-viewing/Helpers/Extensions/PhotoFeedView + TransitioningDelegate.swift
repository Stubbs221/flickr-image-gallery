//
//  PhotoFeedView + TransitionDelegate.swift
//  flickr-image-viewing
//
//  Created by MAC on 13.08.2022.
//

import UIKit

extension PhotoFeedView: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? PhotoFeedView,
              let secondViewController = presented as? FullImageView,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot else { return nil }
        
        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? FullImageView,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot else { return nil }
        
        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}
