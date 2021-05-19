//
//  RoutingModalTransition.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 21/3/21.
//

import Foundation
import UIKit

class RoutingModalTransition: NSObject {
    var animator: Animator?
    var isAnimated: Bool = true
    
    var modalTransitionStyle: UIModalTransitionStyle
    var modalPresentationStyle: UIModalPresentationStyle
    
    var completionHandler: (() -> Void)?
    
    weak var viewController: UIViewController?
    
    init(
        animator: Animator? = nil,
        isAnimated: Bool = true,
        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen
    ) {
        self.animator = animator
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
    }
}

// MARK: - RoutingTransition protocol
extension RoutingModalTransition: RoutingTransition {
    func open(_ viewController: UIViewController) {
        viewController.transitioningDelegate = self
        viewController.modalTransitionStyle = modalTransitionStyle
        viewController.modalPresentationStyle = modalPresentationStyle
        
        self.viewController?.present(viewController, animated: isAnimated, completion: completionHandler)
    }
    
    func close(_ viewController: UIViewController) {
        viewController.dismiss(animated: isAnimated, completion: completionHandler)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension RoutingModalTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        animator.isPresenting = false
        return animator
    }
}
