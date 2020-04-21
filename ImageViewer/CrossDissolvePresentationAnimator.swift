//
//  CrossDissolvePresentationAnimator.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/21.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

class CrossDissolvePresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Context {
        case present
        case dismiss
    }

    private lazy var context: Context = uninitialized()
    
    init(context: Context) {
        super.init()
        self.context = context
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch context {
        case .present:
            presentTransition(using: transitionContext)
        case .dismiss:
            dismissTransition(using: transitionContext)
        }
    }
    
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView) // fromViewは最初から追加されている
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            fromView.alpha = 0
        }) { complete in
            transitionContext.completeTransition(complete)
            fromView.alpha = 1
        }
    }
    
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView) // fromViewは最初から追加されている
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            fromView.alpha = 0
        }) { complete in
            transitionContext.completeTransition(complete)
            fromView.alpha = 1
        }
    }
}
