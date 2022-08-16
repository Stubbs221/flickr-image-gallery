//
//  PhotoFeedView + TransitionDelegate.swift
//  flickr-image-viewing
//
//  Created by MAC on 13.08.2022.
//

import UIKit

extension PhotoFeedView: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Type of presented: \(type(of: presented)), must be fullImageView")
        print("Type of presenting: \(type(of: presenting)), must be photoFeedView")
        guard let secondViewController = presented as? FullImageView else { return nil }
        guard let firstNavViewController = presenting as? UINavigationController else { return nil }
//        guard let firstViewController = firstNavViewController.viewControllers.first as? PhotoFeedView else { return nil }
        
        guard let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot else { return nil }
        
        currentNavigationController = firstNavViewController
        animator = Animator(type: .present, navController: firstNavViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? FullImageView,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot,
              let navVC = currentNavigationController else { return nil }
        
        animator = Animator(type: .dismiss, navController: navVC, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}
