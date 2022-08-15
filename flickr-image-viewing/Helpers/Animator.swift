//
//  Animator.swift
//  flickr-image-viewing
//
//  Created by MAC on 13.08.2022.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 0.25
    
    private let type: PresentationType
    private let firstViewController: PhotoFeedView
    private let secondViewController: FullImageView
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect
    
    init?(type: PresentationType, firstViewController: PhotoFeedView, secondViewController: FullImageView, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        
        guard let window = firstViewController.view.window ?? secondViewController.view.window,
              let selectedCell = firstViewController.selectedCell else { return nil }
        
        self.cellImageViewRect = selectedCell.imageView.convert(selectedCell.imageView.bounds, to: window)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = secondViewController.view
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(toView)
        
        guard let selectedCell = firstViewController.selectedCell,
              let window = firstViewController.view.window ?? secondViewController.view.window,
              let cellImageSnapshot = selectedCell.imageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = secondViewController.fullImage.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(true)
            return
        }
        
        let isPresenting = type.isPresenting
        
        if isPresenting {
            selectedCellImageViewSnapshot = cellImageSnapshot
        }
        
        toView.alpha = 0
        
//        [imageViewSnapshot].forEach { containerView.addSubview($0)}
        
        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach { containerView.addSubview($0)
        }
        
        let controllerImageViewRect = secondViewController.fullImage.convert(secondViewController.fullImage.bounds, to: window)
        
        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach { $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
        }
        
        controllerImageSnapshot.alpha = isPresenting ? 0 : 1
        selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }
        } completion: { _ in
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            
            
            toView.alpha = 1
            
            transitionContext.completeTransition(true)
        }

    }
}

enum PresentationType {
    case present
    case dismiss
    
    var isPresenting: Bool {
        return self == .present
    }
}
