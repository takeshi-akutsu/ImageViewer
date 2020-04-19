//
//  ImageViewerController.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/19.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

class ImageViewerController: UIViewController {

    lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        return scrollView
    }()
    
    lazy var backgroundImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let effect = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.addSubview(effectView)
        return imageView
    }()

    private var images: [UIImage]
    private var pageIndex: Int = 0 {
        didSet {
            backgroundImageView.image = images[pageIndex]
        }
    }

    init(images: [UIImage], pageIndex: Int = 0) {
        self.images = images
        self.pageIndex = pageIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        backgroundImageView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: 非同期処理を絡める
        setPages(images)
        scrollView.setContentOffset(.init(x: scrollView.bounds.width * CGFloat(pageIndex), y: 0), animated: false)
        backgroundImageView.image = images[pageIndex]
    }
}

extension ImageViewerController {
    private func setPages(_ images: [UIImage]) {
        images.enumerated().forEach { [weak self] index, image in
            let pageView = PageView(image: image)
            pageView.pageViewDelegate = self
            pageView.frame = scrollView.bounds
            pageView.frame.origin.x += scrollView.frame.width * CGFloat(index)
            self?.scrollView.addSubview(pageView)
        }
        
        scrollView.contentSize.width = CGFloat(images.count) * scrollView.frame.width
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}

extension ImageViewerController: PageViewDelegate {
    func pageViewStatusDidChanged(_ status: PageView.Status) {
        scrollView.isScrollEnabled = (status == .normal)
    }
}
