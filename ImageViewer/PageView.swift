//
//  PageView.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/16.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

protocol PageViewDelegate: class {
    func pageViewStatusDidChanged(_ status: PageView.Status)
}

final class PageView: UIScrollView {
    private lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(scrollViewDidDoubleTapped(_:)))
        gestureRecognizer.numberOfTapsRequired = 2
        return gestureRecognizer
    }()
    
    weak var pageViewDelegate: PageViewDelegate?
    
    init(image: UIImage) {
        super.init(frame: .zero)
        addSubview(imageView)
        imageView.image = image
        
        // initialize scrollView
        self.delegate = self
        maximumZoomScale = 2.0
        minimumZoomScale = 1.0
        addGestureRecognizer(doubleTapGestureRecognizer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Viewのinitialize時にimageViewのframeを設定する
        if imageView.frame == .zero, let imageSize = imageView.image?.size {
            let wrate = frame.width / imageSize.width
            let hrate = frame.height / imageSize.height
            let scale = min(wrate, hrate, 1)
            imageView.frame.size = .init(width: imageSize.width * scale, height: imageSize.height * scale)
            
            contentSize = imageView.frame.size
            adjustContentInset()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageView {
    
    enum Status {
        case normal
        case zoomIn
    }
    
    // MARK: centering the imageView
    private func adjustContentInset() {
        contentInset = .init(
            top: max((frame.height - imageView.frame.height) / 2, 0),
            left: max((frame.width - imageView.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
    }
    
    @objc func scrollViewDidDoubleTapped(_ sender: UITapGestureRecognizer) {
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let tapped = sender.location(in: self)
            let size: CGSize = .init(width: contentSize.width / maximumZoomScale, height: contentSize.height / maximumZoomScale)
            let origin: CGPoint = .init(x: tapped.x - (size.width / 2), y: tapped.y - (size.height / 2))
            zoom(to: .init(origin: origin, size: size), animated: true)
        }
    }
}

extension PageView: UIScrollViewDelegate {
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if zoomScale > minimumZoomScale {
            pageViewDelegate?.pageViewStatusDidChanged(.zoomIn)
        } else {
            pageViewDelegate?.pageViewStatusDidChanged(.normal)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustContentInset()
    }
}
