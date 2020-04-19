//
//  ImageViewerController.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/19.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

class ImageViewerController: UIViewController {
    // MARK: - Setup Views
        lazy var scrollView: UIScrollView = { [unowned self] in
          let scrollView = UIScrollView()
          scrollView.isPagingEnabled = true
    //      scrollView.delegate = self
          scrollView.showsHorizontalScrollIndicator = false
    //      scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
            scrollView.backgroundColor = .green
          return scrollView
        }()
        
        

        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(scrollView)
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            scrollView.frame = view.bounds
        }
        
        func configure(_ images: [UIImage]) {
            configureImageViewPages(images)
        }
}

extension ImageViewerController {
    private func configureImageViewPages(_ images: [UIImage]) {
        images.enumerated().forEach { [weak self] index, image in
            let pageView = PageView(image: image)
            pageView.frame = scrollView.bounds
            pageView.frame.origin.x += scrollView.frame.width * CGFloat(index)
            self?.scrollView.addSubview(pageView)
        }
        
        scrollView.contentSize.width = CGFloat(images.count) * scrollView.frame.width
    }
}
