//
//  Animator.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/21.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        return context == .present ? 0.3 : 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView) // fromViewは最初から追加されている
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                fromView.alpha = 0
        }) { completion in
            transitionContext.completeTransition(completion)
            fromView.alpha = 1
        }
    }
}
