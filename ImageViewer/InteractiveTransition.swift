//
//  InteractiveTransition.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/21.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

final class InteractiveTransition: UIPercentDrivenInteractiveTransition {

    private(set) var isTransitioning: Bool = false
    private lazy var viewController: ImageViewerController = uninitialized()
    private let percentCompleteThreshold: CGFloat = 0.1 // 0.0 ~ 1.0
    
    init(target viewController: ImageViewerController) {
        super.init()
        self.viewController = viewController
        self.viewController.pageViews.forEach { [unowned self] pageView in
            let panGestureRecognizer = UIPanGestureRecognizer.init()
            panGestureRecognizer.delegate = self
            panGestureRecognizer.addTarget(self, action: #selector(self.handlePanGestureRecognizer(_:)))
            pageView.imageView.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @objc func handlePanGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: recognizer.view)
        
        // 縦方向にswipeしている場合のみinteractiveなtransitioningの処理をする
        guard abs(translation.x) < abs(translation.y) else { return }
        isTransitioning = recognizer.state == .began || recognizer.state == .changed

        switch recognizer.state {
        case .began:
            gestureBegan(recognizer)
        case .changed:
            gestureChanged(recognizer)
        case .ended, .cancelled:
            gestureCancelledAndEnded(recognizer)
        default:
            break
        }
    }
    
    private func gestureBegan(_ recognizer: UIPanGestureRecognizer) {
        viewController.dismiss(animated: true)
    }
    
    private func gestureChanged(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: viewController.view)
        recognizer.view?.frame.origin.y = translation.y

        let progress = abs(translation.y) / viewController.view.bounds.height
        update(progress)
    }
    
    private func gestureCancelledAndEnded(_ recognizer: UIPanGestureRecognizer) {
        if percentComplete > percentCompleteThreshold {
            recognizer.view?.frame.origin.y += 50
            finish()
        } else {
            recognizer.view?.frame.origin.y = 0
            cancel()
        }
    }
}

extension InteractiveTransition: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let translation = panGesture.translation(in: panGesture.view)
        if abs(translation.x) > abs(translation.y) {
            // 横向きにswipeしてるときはUIScrollView.panGestureRecognizerもONにする
            return true
        } else {
            // 縦向きにswipeしてるときはUIScrollView.panGestureRecognizerはOFF（imageView.panGestureのみ使える）
            return false
        }
    }
}
