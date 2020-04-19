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

    private var pageIndex: Int
    private var pageViews: [PageView]

    init(imageURLs: [URL], pageIndex: Int = 0) {
        self.pageIndex = pageIndex
        self.pageViews = imageURLs.map { PageView.init(imageURL: $0) }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        pageViews.forEach { [weak self] pageView in
            self?.scrollView.addSubview(pageView)
            pageView.pageViewDelegate = self
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setup layout
        scrollView.frame = view.bounds
        backgroundImageView.frame = view.bounds
        pageViews.enumerated().forEach { [unowned self] index, view in
            view.frame = self.scrollView.bounds
            view.frame.origin.x += self.scrollView.frame.width * CGFloat(index)
        }
        scrollView.contentSize.width = CGFloat(pageViews.count) * scrollView.frame.width
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(.init(x: scrollView.bounds.width * CGFloat(pageIndex), y: 0), animated: false)
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        backgroundImageView.image = pageViews[pageIndex].imageView.image
    }
}

extension ImageViewerController: PageViewDelegate {
    func pageViewStatusDidChanged(_ status: PageView.Status) {
        scrollView.isScrollEnabled = (status == .normal)
    }
    
    func pageViewDidLoadImage() {
        backgroundImageView.image = pageViews[pageIndex].imageView.image
    }
}
