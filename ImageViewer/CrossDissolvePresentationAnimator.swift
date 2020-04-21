//
//  CrossDissolvePresentationAnimator.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/21.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

/*
 contextに関わらず同じanimationを使っているのでcontextなどは不要だったが、
 今後の参考になるように分けて書いている。
*/
class CrossDissolvePresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Context {
        case present
        case dismiss
    }

    private lazy var context: Context = uninitialized()
    private lazy var transitionDuration: TimeInterval = uninitialized()
    
    init(context: Context, duration: TimeInterval) {
        super.init()
        self.context = context
        self.transitionDuration = duration
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
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
    
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
